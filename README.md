# YellowBasket

YellowBasket is a SwiftUI-based iOS prototype designed to help users reduce food waste by turning the ingredients they already have into practical meal ideas.

The app allows users to scan their fridge, confirm detected ingredients, and receive recipe suggestions based on what is available, creating a fast and intuitive cooking experience.

---

## What This Prototype Demonstrates

This repository represents a working prototype (not a full V1 product) focused on validating the core user journey and product experience.

### Current Demo Flow

- Login into the app  
- View the home screen  
- Start a fridge scan (simulated via photo selection)  
- Confirm detected ingredients  
- Generate recipe suggestions based on selected ingredients  

This flow is fully functional and demonstrates the main value of the product end-to-end.

---

## Product Vision

The goal of YellowBasket is to:

- Reduce food waste at the household level  
- Help users make better use of ingredients they already own  
- Simplify the decision of what to cook  
- Eventually integrate real-time data such as store discounts and availability  

---

## Tech Stack

- SwiftUI (iOS native)
- Xcode
- Local mock data for prototyping
- Lightweight state management via `AppState`
- AI-assisted development using Claude Code

---

## Current Architecture

The app is intentionally kept simple and modular to support rapid iteration:

- Views — UI screens such as Login, Home, Scan, and Results  
- Models — Ingredient and Recipe data structures  
- Services — Mock data provider  
- AppState — Global app state (e.g. login status)  

No backend or networking is used at this stage.

---

## UI and UX Considerations

This prototype includes several elements to simulate a production-ready experience:

- Clean, minimal SwiftUI layout  
- Consistent spacing and typography  
- Card-based interface design  
- Subtle gradients and depth  
- Dynamic greeting based on time of day  

### Interaction Details

- Button press feedback (scale and opacity)  
- Smooth transitions between screens  
- Animated ingredient selection  

### Realistic App Behavior

- Simulated loading states such as:
  - "Analyzing ingredients..."
  - "Finding recipes..."

- Graceful fallback handling:
  - "No recipes found. Try adjusting your ingredients."

These details help the prototype feel responsive and realistic.

---

## What Is Mocked

To keep the prototype focused and lightweight, the following are currently simulated:

- Ingredient detection (no real image recognition yet)  
- Recipe generation (static mock data)  
- App state (no persistence)  

---

## Not Yet Implemented

The following features are planned for future iterations:

- AI-based ingredient detection (e.g. Gemini API)  
- Dynamic recipe generation  
- Backend integration (Firebase or similar)  
- Saved recipes and user preferences  
- Profile management  
- Store integrations (discounts, availability)  

---

## How to Run

1. Open `YellowBasket.xcodeproj` in Xcode
2. Select an iPhone simulator or a physical device
3. Press Run

### Required setup files (not in git)

Two files are excluded from the repository and must be obtained separately before building:

- `YellowBasket/Resources/Secrets.plist` — must contain a `GEMINI_API_KEY` string entry with a valid Google Gemini API key.
- `GoogleService-Info.plist` — Firebase configuration file for the `yellowbasket-f7095` project. Download from the Firebase Console under Project Settings > Your apps.

### Firestore security rules

`firestore.rules` in the project root contains the required Firestore security rules. These must be deployed before the app is used with real user data. Deploy via the Firebase CLI:

```
firebase deploy --only firestore:rules
```

Or paste the contents of `firestore.rules` into the Firebase Console under Firestore Database > Rules.

The rules restrict each user to reading and writing only their own document at `users/{userId}`.

---

## Demo Flow

Login → Home → Scan → Ingredient Confirmation → Recipe Results

---

## Notes

This prototype is designed to:

- Validate the core product experience  
- Demonstrate the main user flow  
- Serve as a foundation for future V1 development  

It prioritizes clarity, usability, and speed of iteration over production-level complexity.

---

## Author

Developed as part of an early-stage product prototype using SwiftUI and AI-assisted development tools.
