# YellowBasket V1 — Final Audit

**Audited against:** Yellow_Basket_v1Brief_edited.pdf · V1_IMPLEMENTATION_PLAN.md · README.md
**Date:** 2026-05-01
**Auditor:** Claude Code

---

## 1. What Is Working Well

- **End-to-end core flow is functional.** Login → Home → Add Sheet → Scan → Gemini detection → Ingredient confirmation → Gemini recipe generation → Recipe detail → Save. This is the full demo path and it works.
- **Gemini Vision integration is solid.** `GeminiService` compresses images, builds a well-constrained prompt, handles the API envelope, deduplicates ingredients, filters non-food items, and maps confidence to `isSelected`. Error types are specific and surfaced correctly.
- **Gemini LLM recipe generation is solid.** `GeminiRecipeService` generates 3–5 recipes, computes missing ingredients client-side against a reasonable pantry staple list, and parses the structured JSON response correctly.
- **Confidence threshold logic is implemented.** High-confidence items (>= 0.9) are auto-selected; low-confidence items show a percentage badge. This matches the brief exactly (Section 8).
- **HomeView exceeds the brief.** The brief asked for a "Nearby Discounts" section. The implementation has a full deals carousel, category filter chips, real-time search across ingredient names / categories / stores, and a "Your saved ingredients" strip. All powered by `HomeViewModel` cleanly.
- **RecipeDetailView is well built.** Overview card, cook time / difficulty / servings meta row, missing ingredient banner, ingredient list with colour-coded missing pills, numbered steps, and a sticky Save Recipe CTA. Visually very close to brief wireframe.
- **MockDataService is complete and well-structured.** 8 realistic ingredients with calibrated confidence values, 4 full recipes with correct steps and missing ingredient mapping, 3 stores with 13 discount items that cross-reference those missing ingredients.
- **Authentication is properly layered.** `AuthService` wraps Firebase, `LoginViewModel` owns state, `SessionManager` owns auth listener. Google Sign-In is wired end-to-end.
- **SettingsView has moved past placeholder.** Shows user email/display name, appearance theme picker, provider info, and a destructive logout button that correctly calls `sessionManager.logout()`.
- **Firestore ingredient persistence is wired.** Confirmed ingredients are saved on confirmation and reloaded into `SessionManager.savedIngredients` on next login.
- **Manual ingredient entry is functional.** Clean UX, pushes directly into `IngredientConfirmationView` so manual entries flow through the same confirmation → recipes path.
- **AppState uses `@Observable`.** Modern Swift Observation framework used correctly alongside `ObservableObject` for `SessionManager`.
- **UI polish is consistently applied.** `PressableButtonStyle`, brand yellow throughout, correct spacing, `secondarySystemBackground` cards, gradient on scan hero — the app reads as production-quality at a glance.

---

## 2. What Is Incomplete or Weak

### Core gaps vs. brief

- **RecipeCard missing ingredient pills and match count.** The wireframe (Figure 3, Section 10) explicitly shows "5/6 ingredients" and missing item pill tags on each recipe card. `RecipeResultsView.RecipeCard` only shows name, time, and description. No match indicator, no missing pills. This is a visible gap during a demo.
- **No "Available nearby" badge on recipe cards.** The brief (Section 8 — Missing Ingredient Detection) requires matching missing ingredients against store listings and surfacing a discount badge on the card. This matching logic exists in mock data (Onions, Mushrooms, Tomatoes, Chives all appear in store listings) but is never shown on recipe cards.
- **No recipe filters UI.** Section 8 specifies filters for servings, cuisine type, difficulty, and cooking theme. The Gemini prompt does not accept these. No filter UI is built. The brief lists this as a core feature of the Recipe Generator screen.
- **No Reservation / cart flow.** Section 8 (Ingredient Reservation) requires Select → Cart → Simulated Checkout → Confirmation. Classified as stretch in the plan but listed as Core in the brief (Section 6 V1 Product Goals bullet 5: "Reserve those ingredients for pickup"). It is entirely absent.
- **No dedicated Saved Ingredients screen.** Brief Section 9 lists "Saved ingredients" as a required screen. Ingredients appear as chips in HomeView, but there is no full-screen view to manage or clear them.
- **No offline behaviour.** Section 14 (Offline Behaviour) requires a message that scanning requires connectivity and that previously saved data remains accessible. Neither is implemented.

### Weaker implementations

- **ScanView has no ViewModel.** All async logic — Gemini call, `isAnalyzing`, `detectedIngredients`, `detectionError` — lives in the View via `@State` and inline `Task {}`. The implementation plan (Batch 2) explicitly called for `ScanViewModel`. This is the only remaining View that violates V→VM→Service.
- **`recipeError` is set but never shown.** `IngredientConfirmationViewModel.recipeError` is populated when Gemini returns nothing, but `IngredientConfirmationView` has no binding to it. A user who hits a Gemini error gets pushed to the empty RecipeResultsView with no explanation.
- **`showRecipes` navigates even on empty results.** When `generatedRecipes.isEmpty`, the ViewModel still sets `showRecipes = true`, pushing to a results screen that says "No recipes found." The error message and a retry option should appear instead.
- **Saved recipes are in-memory only.** Saving a recipe writes to `AppState.savedRecipes` (lost on app close) but not Firestore. `FirestoreService` has no recipe save/fetch methods. This is called out as Batch 7 stretch, but for investor demos this is a notable gap.
- **ScanView state is never reset between sessions.** If a user scans once, navigates back, and opens Scan again (via the + button which presents it as a sheet), `selectedImage` and `detectedIngredients` are gone because the sheet is re-created. Actually this is fine because ScanView is presented as a new sheet each time — but there is a subtle bug: pressing the close button on ScanView while analyzing leaves `isAnalyzing = true` with no cleanup. On re-present, the new view starts fresh so this is not persistent, but it's worth noting.
- **DealCard emoji lookup is duplicated.** The same `[String: String]` emoji map appears twice — once in `DealCard` and once in `SearchDealRow`, both private structs inside `HomeView`. Minor code quality issue.
- **Notifications toggle in SettingsView does nothing.** `@State private var notificationsEnabled = true` is never wired to actual `UNUserNotificationCenter`. Fine for prototype but could be confusing in a demo.
- **Location is hardcoded.** `"Liverpool, L6"` appears as a static label in HomeView header and store addresses. Distance is a mock value, not calculated from GPS. Acceptable for V1 but worth flagging for demos outside the UK.

---

## 3. Critical Bugs / Blockers

### Bug 1 — All mock deal expiry dates are in the past
All 13 `DiscountedItem` entries in `MockDataService` have `expiryDate` values between `"2026-04-25"` and `"2026-05-03"`. Today is 2026-05-01. Eight of the thirteen items are already expired and two expire today. `DealCard.formatExpiry()` displays "Expires 25 Apr", "Expires 26 Apr" etc., which will read as stale during any live demo. **This will look broken to anyone reviewing the app today or later.**

### Bug 2 — Placeholder tagline visible in two screens
Both `LoginView` and `SplashView` display the literal string `"* Brand tagline and logo to be inserted later *"`. This is shown to any user or investor who opens the app. It will undermine credibility in any demo context.

### Bug 3 — `recipeError` is unreachable by the UI
When `GeminiRecipeService` fails or returns empty, `IngredientConfirmationViewModel` sets `recipeError = "Couldn't generate recipes. Please try again."` but then immediately sets `showRecipes = true`. The View has no `recipeError` binding displayed. The user is silently pushed to an empty results screen with no way to retry. From a user's perspective the app appears broken.

### Bug 4 — `IngredientConfirmationViewModel` accesses FirebaseAuth directly
`Auth.auth().currentUser?.uid` is called in the ViewModel, bypassing `SessionManager`. This is a minor architecture violation (the plan called it out) but means the ViewModel has a direct Firebase dependency that should route through `SessionManager.currentUser?.uid`.

### Bug 5 — `dismissScanFlow` mechanism is fragile
`RecipeDetailView` sets `appState.selectedTab = 2` and `appState.dismissScanFlow = true` to dismiss the scan sheet and jump to Saved. `MainTabView.onChange(of: appState.dismissScanFlow)` handles this. If `AppState` is reset or the timing is off, this could leave the sheet open or the tab in the wrong state. It works in practice but is a design smell for a handover.

---

## 4. UI/UX Quality Score

**7.5 / 10**

**Strengths:**
- Visual hierarchy and spacing are polished throughout
- Brand yellow is used consistently and purposefully
- Cards, gradients, and button styles create a premium feel
- Ingredient confidence badges and missing ingredient indicators are a standout detail
- The Add Ingredients sheet (scan vs. manual choice) is a nice UX touch
- RecipeDetailView layout is excellent — clearly production-ready

**Weaknesses:**
- Placeholder tagline on two screens is a demo-breaking oversight
- RecipeCard is weaker than the wireframe — missing ingredient pills and match count are called out in the brief and visible in the wireframe mockup
- No recipe filter UI despite being specified in the brief
- Impact stat numbers are hardcoded and never update
- Empty states are functional but could be more inviting

---

## 5. Architecture / Code Quality Score

**6.5 / 10**

**Positives:**
- V→VM→Service pattern is followed in most places
- `@Observable` and `@ObservableObject` used appropriately for their contexts
- Services are singletons with clear responsibilities
- Async/await used correctly throughout; no Combine leakage
- Named error types (`GeminiError`, `AuthServiceError`) are good practice
- `IngredientConfirmationViewModel` correctly separates concerns from the View

**Negatives:**
- `ScanView` is the outlier: all logic in the View, no ViewModel, direct `GeminiService.shared` call
- `AppState` mixes saved recipes (in-memory), selectedTab, and a UI-coordination hack (`dismissScanFlow`) — it is doing three different jobs
- Saved recipes live in `AppState`; saved ingredients live in `SessionManager`. Inconsistent ownership
- `IngredientConfirmationViewModel` directly imports and calls `FirebaseAuth`
- `DealEntry` struct defined inside `HomeViewModel.swift` — belongs in Models
- Duplicate emoji maps in `HomeView` (two private structs with identical lookups)
- README is significantly out of date — claims no networking or backend is used

---

## 6. Backend / Firebase / Gemini Setup Score

**5.5 / 10**

**Working:**
- Firebase Auth (email/password + Google Sign-In) is fully integrated and functional
- Firestore ingredient persistence (save + fetch) is wired and live
- `SessionManager` correctly loads ingredients from Firestore on login
- Gemini 2.5 Flash used for both Vision and recipe LLM — correct model choice per brief
- API key loaded from `Secrets.plist` at runtime — not hardcoded in Swift

**Problems:**
- `FirestoreService` only persists ingredients — no recipe save/fetch despite `AppState.savedRecipes` being in-memory only
- No Firestore security rules file in the project. There is no `firestore.rules` and no confirmation they are configured in the Firebase console. Default Firebase rules open the database to any authenticated user for the first 30 days — after that the database locks. Rules need to be explicitly set.
- Offline behaviour is completely absent — no local cache, no connectivity check, no user message when the network is unavailable.
- Gemini API timeout/retry is not handled. A slow or dropped network call silently fails and returns empty recipes.
- No rate limiting protection on the Gemini calls — a user could spam the Continue button and fire multiple concurrent API requests.

---

## 7. Mock Data Quality

### Is mock data used appropriately?
Yes. Mock data is used exactly where the brief requires it: store discounts and ingredient detection fallback. The recipe generation and ingredient detection paths use real Gemini calls, which is correct. `MockDataService` is only read by `HomeViewModel` (for deals) and used as Preview data in `IngredientConfirmationView`.

### Should mock data stay in `MockDataService` or move to JSON?
**Keep it in `MockDataService.swift`.** The dataset is small (8 ingredients, 4 recipes, 13 deal items across 3 stores). Moving to JSON adds a decoding layer with no benefit at this scale. JSON would make sense if the mock data needed to be updated frequently by non-developers or if it exceeded ~30–40 entries. Neither is true here.

### What should be real vs. mock for V1?

| Feature | Current | Correct for V1 |
|---|---|---|
| Ingredient detection | Real (Gemini Vision) | Real — correct |
| Recipe generation | Real (Gemini LLM) | Real — correct |
| Store/discount listings | Mock | Mock — correct per brief |
| Ingredient persistence | Real (Firestore) | Real — correct |
| Recipe persistence | In-memory mock | Should be Firestore per brief Section 8 |
| Impact stats (HomeView) | Hardcoded fake | Acceptable as mock for prototype |
| User location / distance | Hardcoded Liverpool | Acceptable as mock for V1 |

**Primary gap:** Recipe saving should be real (Firestore). Everything else is correctly mocked or correctly real.

---

## 8. Security / Handover Risks

### API Keys — CRITICAL RISK

| Secret | Location | In git? | Risk |
|---|---|---|---|
| Gemini API key | `Secrets.plist` | No (gitignored) | Low — but the file exists on disk and travels with the project folder if shared as a zip |
| Firebase Web API key | `GoogleService-Info.plist` | **YES** | High — committed to the repo. Anyone with repo access can attempt Firebase operations |
| Google OAuth Client ID | `Info.plist` | **YES** | Medium — OAuth Client IDs are semi-public but should not be in a shared repo |

**`GoogleService-Info.plist` must be added to `.gitignore` immediately.** The current `.gitignore` only excludes `Secrets.plist` and `V1_IMPLEMENTATION_PLAN.md`.

### Firebase Config
`GoogleService-Info.plist` exposes the Firebase project ID (`yellowbasket-f7095`) and the Firebase Web API key. With these values, an attacker can attempt to create accounts, sign in, and access Firestore if rules allow it.

### Firestore Rules — UNKNOWN / HIGH RISK
There is no `firestore.rules` file in the project and no mention of rules configuration anywhere. Firebase's default Firestore rules for new projects are open (allow read/write to any authenticated user) for 30 days, then lock to deny-all. Current state is unknown. **Before any handover or demo with real users, Firestore rules must be verified and hardened.** Minimum acceptable rule for this app: a user can only read/write their own document at `users/{userId}`.

### Setup Assumptions for Handover
Anyone receiving this project needs:
1. The `Secrets.plist` file (not in git) with a valid `GEMINI_API_KEY`
2. The `GoogleService-Info.plist` file (should be removed from git) for Firebase configuration
3. A device or simulator with a Google account for Google Sign-In testing
4. Firebase project access (`yellowbasket-f7095`) to verify/configure Firestore rules and Auth providers

---

## 9. Product Brief Alignment

### Fulfilled

- User account & login (Firebase Auth, email + Google)
- Fridge image scanning via Gemini 2.5 Flash Vision
- Ingredient confirmation with confidence threshold
- Recipe generation via Gemini LLM
- Missing ingredient detection (surfaced in RecipeDetailView and RecipeResultsView)
- Discounted ingredient listings on Home using mock data (Section 13 schema compliant)
- 5-tab navigation structure (Home, Recipes, +, Saved, Settings)
- Login screen matches wireframe (Figure 1) closely
- Error states: scan fails, no food detected, no recipes found — all present
- Saved recipes tab (in-memory)

### Partially Fulfilled

- **Ingredient storage in Firebase profile** — ingredients are saved and fetched; recipes are not
- **Section 12 error states** — scan failure and no-food error are present; "No nearby discounts" message is not wired to any UI
- **Recipe suggestions screen (Figure 3 wireframe)** — cards exist but lack ingredient count indicator ("5/6 ingredients") and missing pill tags shown in the wireframe
- **Settings / profile page** — exists as SettingsView; no profile editing as brief's stretch goal requires
- **Offline behaviour** — saving works but no offline message and no local cache

### Missing / Not Implemented

- Recipe filters (servings, cuisine type, difficulty, cooking theme) — Section 8 core feature
- Reservation & cart flow (Section 8 + Section 6 Goal 5) — zero implementation
- Dedicated Saved Ingredients screen — Section 9 required screen
- Camera / Fridge scan screen matching Figure 2 wireframe — ScanView uses photo picker, not live camera preview with dashed boundary guides as wireframed
- Recipe generator screen (filters entry point before results) — Section 9 required screen
- "Available nearby" badge on recipe cards linking missing ingredients to nearby discount listings

---

## 10. Final Priority List Before Handover

### Must Fix (blocks demo or exposes credentials)

1. **Replace all expired mock expiry dates** in `MockDataService` with dates at least 7–14 days in the future from current date. This takes 5 minutes and makes every deal card readable.
2. **Remove placeholder tagline from `LoginView` and `SplashView`.** Replace with a real tagline or remove the line entirely. Do not ship a demo with `"* Brand tagline and logo to be inserted later *"` visible.
3. **Add `GoogleService-Info.plist` to `.gitignore`** and revoke/rotate the current Firebase Web API key if this repository has been pushed to any remote.
4. **Verify Firestore security rules** in the Firebase console. At minimum: `allow read, write: if request.auth != null && request.auth.uid == userId;` scoped to the `users/{userId}` path.
5. **Surface `recipeError` to the user** or, at minimum, prevent navigating to RecipeResultsView when `generatedRecipes.isEmpty` after a real Gemini failure. User should see an error with a retry option, not an empty results screen.

### Should Fix (improves demo quality or correctness)

6. **Add missing ingredient count and pills to `RecipeCard`** in `RecipeResultsView`. The brief wireframe shows "5/6 ingredients" and pill tags. Takes one subview addition. This is visible in Figure 3 and reviewers will notice the gap.
7. **Add "Available nearby" badge to `RecipeCard`** for missing ingredients that match a store listing. The matching logic is trivial (case-insensitive string compare against `MockDataService.storeListings`). This directly demonstrates the core value proposition.
8. **Save recipes to Firestore** via `FirestoreService`. `AppState.savedRecipes` is lost on app kill. A reviewer saving a recipe and reopening the app will find it gone.
9. **Move `ScanView` async logic into `ScanViewModel`**. Currently the View owns the Gemini call and all state. Low complexity refactor; fixes the only remaining V→VM→Service violation.
10. **Fix `IngredientConfirmationViewModel`** to use `sessionManager.currentUser?.uid` instead of calling `Auth.auth().currentUser?.uid` directly.

### Can Ignore for Now

11. **Recipe filter UI** — valuable feature but adds significant scope. Omit for V1 demo; the LLM produces good results without filters.
12. **Reservation / cart flow** — correctly scoped as stretch. Omit unless demo requires it.
13. **Dedicated Saved Ingredients screen** — ingredients shown as chips in Home are sufficient for demo context.
14. **`dismissScanFlow` hack in `AppState`** — works in practice; refactor is clean-up work, not demo-critical.
15. **Duplicate emoji map in `HomeView`** — code quality issue, no user impact.
16. **README inaccuracies** — update after the above fixes are done. Low priority relative to demo readiness.
17. **Notifications toggle in SettingsView** — dead UI, not misleading enough to be urgent.
18. **Offline behaviour / cache** — useful for production; unnecessary for a controlled demo environment.

---

## Summary

The app is significantly further along than the implementation plan's last known state. The core Gemini integration, Firestore persistence layer, and UI polish are all production-approaching. **The demo flow will run end-to-end without errors.** However, two presentation-layer issues (expired dates, placeholder tagline) and two security issues (Firebase config in git, unknown Firestore rules) must be resolved before any external demo or handover. The missing ingredient pills on recipe cards and the lack of a "Available nearby" badge are the most visible product gaps relative to the brief's wireframes.
