import Foundation
import UIKit

enum GeminiError: LocalizedError {
    case missingAPIKey
    case imageEncodingFailed
    case invalidResponse(Int)
    case noFoodDetected

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "Gemini API key not configured in Secrets.plist"
        case .imageEncodingFailed:
            return "Could not encode image for upload"
        case .invalidResponse(let code):
            return "Gemini returned an unexpected response (status \(code))"
        case .noFoodDetected:
            return "We couldn't detect any ingredients. Try another photo or add ingredients manually."
        }
    }
}

final class GeminiService {
    static let shared = GeminiService()
    private init() {}

    private let model = "gemini-2.5-flash"
    private let maxBytes = 4 * 1024 * 1024  // 4 MB

    private var apiKey: String {
        guard
            let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path),
            let key = dict["GEMINI_API_KEY"] as? String,
            !key.isEmpty
        else { return "" }
        return key
    }

    // MARK: - Public

    func detectIngredients(from image: UIImage) async throws -> [Ingredient] {
        let key = apiKey
        guard !key.isEmpty else { throw GeminiError.missingAPIKey }
        guard let jpeg = compress(image, maxBytes: maxBytes) else { throw GeminiError.imageEncodingFailed }

        let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent?key=\(key)")!

        let prompt = """
        Identify all visible edible food ingredients in this image.

        Rules:
        - Only include real food items usable as cooking ingredients (vegetables, fruit, meat, dairy, eggs, herbs, spices, pantry staples, etc.)
        - Exclude: clothing, utensils, appliances, furniture, non-food packaging, backgrounds, scenery, and any non-food object.
        - If the same ingredient appears more than once, list it only once.
        - Set confidence (0.0–1.0) based on how certain you are of the identification.
        - Set isFood to false for any item that is NOT an edible food ingredient.
        - Pick one relevant emoji per ingredient.
        - Assign one category from: Vegetables, Fruit, Dairy & Eggs, Meat & Fish, Herbs & Spices, Pantry, Bakery, Other

        Respond with ONLY a JSON array. No markdown, no code fences, no explanation.
        Example: [{"name":"Eggs","emoji":"🥚","category":"Dairy & Eggs","confidence":0.94,"isFood":true}]
        """

        let body: [String: Any] = [
            "contents": [[
                "parts": [
                    ["inline_data": ["mime_type": "image/jpeg", "data": jpeg.base64EncodedString()]],
                    ["text": prompt]
                ]
            ]],
            "generationConfig": [
                "temperature": 0.1,
                "responseMimeType": "application/json"
            ]
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse, http.statusCode != 200 {
            let body = String(data: data, encoding: .utf8) ?? "<no body>"
            print("[GeminiService] Status \(http.statusCode) — response body:", body)
            throw GeminiError.invalidResponse(http.statusCode)
        }

        let ingredients = try parseIngredients(from: data)
        if ingredients.isEmpty { throw GeminiError.noFoodDetected }
        return ingredients
    }

    // MARK: - Private

    private func compress(_ image: UIImage, maxBytes: Int) -> Data? {
        var quality: CGFloat = 0.85
        while quality > 0.05 {
            if let d = image.jpegData(compressionQuality: quality), d.count <= maxBytes { return d }
            quality -= 0.15
        }
        return image.jpegData(compressionQuality: 0.05)
    }

    private func parseIngredients(from data: Data) throws -> [Ingredient] {
        // Gemini wraps the response in a candidates envelope; extract the inner text
        struct Envelope: Decodable {
            struct Candidate: Decodable {
                struct Content: Decodable {
                    struct Part: Decodable { let text: String }
                    let parts: [Part]
                }
                let content: Content
            }
            let candidates: [Candidate]
        }

        struct RawItem: Decodable {
            let name: String
            let emoji: String?
            let category: String?
            let confidence: Double
            let isFood: Bool?
        }

        let text: String
        if let env = try? JSONDecoder().decode(Envelope.self, from: data),
           let t = env.candidates.first?.content.parts.first?.text {
            text = t
        } else {
            text = String(data: data, encoding: .utf8) ?? ""
        }

        let arrayData = extractJSONArray(from: text)
        let raw = try JSONDecoder().decode([RawItem].self, from: arrayData)

        var seen = Set<String>()
        return raw.compactMap { item -> Ingredient? in
            guard item.isFood != false, item.confidence >= 0.45 else { return nil }
            guard seen.insert(item.name.lowercased()).inserted else { return nil }
            return Ingredient(
                id: UUID(),
                name: item.name,
                emoji: item.emoji.flatMap { $0.isEmpty ? nil : $0 } ?? "🍽️",
                category: item.category ?? "Other",
                isSelected: item.confidence >= 0.9,
                confidence: item.confidence
            )
        }
    }

    private func extractJSONArray(from text: String) -> Data {
        var s = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.hasPrefix("```") {
            s = s.components(separatedBy: "\n").dropFirst().joined(separator: "\n")
            if s.hasSuffix("```") { s = String(s.dropLast(3)) }
        }
        if let start = s.firstIndex(of: "["), let end = s.lastIndex(of: "]") {
            s = String(s[start...end])
        }
        return s.data(using: .utf8) ?? Data()
    }
}
