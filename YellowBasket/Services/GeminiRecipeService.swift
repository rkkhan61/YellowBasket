import Foundation

final class GeminiRecipeService {
    static let shared = GeminiRecipeService()
    private init() {}

    private let model = "gemini-2.5-flash"

    private var apiKey: String {
        guard
            let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path),
            let key = dict["GEMINI_API_KEY"] as? String,
            !key.isEmpty
        else { return "" }
        return key
    }

    // Basic staples assumed always available — not counted as missing
    private let basicPantry: Set<String> = [
        "salt", "pepper", "oil", "olive oil", "water", "butter",
        "flour", "sugar", "vinegar", "baking powder", "baking soda"
    ]

    // MARK: - Public

    func generateRecipes(from ingredients: [Ingredient]) async -> [Recipe] {
        guard !apiKey.isEmpty, !ingredients.isEmpty else { return [] }

        let names = ingredients.map { $0.name }.joined(separator: ", ")
        let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent?key=\(apiKey)")!

        let prompt = """
        You are a practical cooking assistant. Generate 3 to 5 simple recipes using ONLY these ingredients: \(names).

        Rules:
        - Use only ingredients from the provided list.
        - You may assume these basic staples are always available: salt, pepper, oil, water, butter, flour, sugar.
        - Keep recipes simple and achievable at home.
        - difficulty must be exactly one of: Easy, Medium, Hard
        - servings must be a number between 1 and 6
        - Provide 3 to 6 clear, ordered cooking steps per recipe
        - Pick one relevant food emoji for each recipe

        Respond with ONLY a JSON array. No markdown, no code fences, no explanation.
        Format:
        [{"name":"","emoji":"","description":"","timeMinutes":0,"difficulty":"Easy","servings":2,"ingredients":[""],"steps":[""]}]
        """

        let body: [String: Any] = [
            "contents": [[
                "parts": [["text": prompt]]
            ]],
            "generationConfig": [
                "temperature": 0.2,
                "responseMimeType": "application/json"
            ]
        ]

        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: body)

            let (data, response) = try await URLSession.shared.data(for: request)

            if let http = response as? HTTPURLResponse, http.statusCode != 200 {
                let body = String(data: data, encoding: .utf8) ?? "<no body>"
                print("[GeminiRecipeService] Status \(http.statusCode):", body)
                return []
            }

            return parse(data, confirmedIngredients: ingredients)
        } catch {
            print("[GeminiRecipeService] Error:", error.localizedDescription)
            return []
        }
    }

    // MARK: - Private

    private func parse(_ data: Data, confirmedIngredients: [Ingredient]) -> [Recipe] {
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

        struct RawRecipe: Decodable {
            let name: String
            let emoji: String?
            let description: String?
            let timeMinutes: Int?
            let difficulty: String?
            let servings: Int?
            let ingredients: [String]?
            let steps: [String]?
        }

        let text: String
        if let env = try? JSONDecoder().decode(Envelope.self, from: data),
           let t = env.candidates.first?.content.parts.first?.text {
            text = t
        } else {
            text = String(data: data, encoding: .utf8) ?? ""
        }

        let arrayData = extractJSONArray(from: text)
        guard let raw = try? JSONDecoder().decode([RawRecipe].self, from: arrayData) else {
            print("[GeminiRecipeService] Failed to decode recipes from:", text.prefix(300))
            return []
        }

        let confirmedNames = Set(confirmedIngredients.map { $0.name.lowercased() })

        return raw.compactMap { r -> Recipe? in
            guard !r.name.isEmpty else { return nil }
            let recipeIngredients = r.ingredients ?? []
            let missing = recipeIngredients.filter { ingredient in
                let key = ingredient.lowercased()
                return !confirmedNames.contains(key) && !basicPantry.contains(key)
            }
            let minutes = r.timeMinutes ?? 20
            return Recipe(
                id: UUID(),
                name: r.name,
                emoji: r.emoji ?? "🍽️",
                description: r.description ?? "",
                cookTime: "\(minutes) min",
                difficulty: r.difficulty ?? "Easy",
                servings: r.servings ?? 2,
                ingredients: recipeIngredients,
                missingIngredients: missing,
                steps: r.steps ?? []
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
