# YellowBasket — Client Handover Guide

This document walks you through everything you need to get YellowBasket running on your machine. It is written for someone who may not have set up an iOS app before, so every step is explained in plain language.

---

## 1. What YellowBasket Is

YellowBasket is an iOS app that helps users reduce food waste by scanning their fridge, identifying ingredients using AI, and generating recipe suggestions based on what they already have. It also shows discounted food items available at nearby stores.

**V1 prototype status:** This is a working prototype built for user testing and investor demonstrations. The core flow — login, scan, ingredient confirmation, recipe generation — runs end-to-end with real AI. Some data (store deals, distances, impact stats) is simulated using realistic mock values. It is not yet a commercial product.

---

## 2. What You Need Before Running the App

Make sure you have all of the following before starting:

- **A MacBook** running macOS (iOS apps cannot be built on Windows or Linux)
- **Xcode installed** — download it free from the Mac App Store (search "Xcode")
- **An iPhone or the iOS Simulator** — the Simulator is built into Xcode, so a physical iPhone is optional
- **The GitHub repository downloaded or cloned** to your MacBook
- **Access to the Firebase project** — you will need a Google account so you can be added to the Firebase Console (see Step 1)
- **A Gemini API key** — a free key from Google AI Studio (see Step 3)
- **An internet connection** — required for login, AI scanning, and recipe generation

---

## 3. Files Intentionally Not Included in GitHub

When you download the repository, **two files will be missing**. This is intentional for security reasons. They contain private credentials that must never be shared publicly.

### GoogleService-Info.plist
This file connects the app to Firebase, which powers user login and data storage. Without it, Firebase cannot start up and the app will get stuck on the login screen or show authentication errors immediately on launch.

### Secrets.plist
This file stores your Gemini API key. Without it, the AI ingredient scanning and recipe generation features will not work. The scan button will appear to run but will return an error instead of results.

**Why are they not in GitHub?**
Committing API keys and credentials to a public or shared repository is a serious security risk. Anyone who found them could use your Firebase project or rack up charges on your Gemini API account. Keeping them out of GitHub is the correct and standard practice.

**What breaks if they are missing:**

| Missing file | What breaks |
|---|---|
| `GoogleService-Info.plist` | Firebase does not start — login screen will not work, no accounts can be created |
| `Secrets.plist` | Gemini AI does not start — fridge scan and recipe generation fail |

Both files must be added manually after downloading the repo. The steps below explain exactly how.

---

## Step 1: Get Firebase Access and Download GoogleService-Info.plist

Firebase is the service that handles user accounts and data storage for YellowBasket.

1. **Send your Google account email address** to the developer (the person handing over this project). They will add you to the Firebase project as an owner.

2. Once added, go to [console.firebase.google.com](https://console.firebase.google.com) and sign in with that Google account.

3. You should see a project called **yellowbasket-f7095** (or similar). Click it to open it.

4. In the left sidebar, click the **gear icon** next to "Project Overview" and select **Project settings**.

5. Scroll down to the **Your apps** section. You will see an iOS app listed.

6. Click the **download icon** or the **GoogleService-Info.plist** download button next to the iOS app.

7. Save the file somewhere easy to find, such as your Desktop. You will add it to Xcode in the next step.

---

## Step 2: Add GoogleService-Info.plist to Xcode

1. Open the YellowBasket project in Xcode by double-clicking the file called **YellowBasket.xcodeproj** inside the downloaded folder.

2. Wait for Xcode to finish loading (the progress bar at the top will disappear when it is ready).

3. Find **GoogleService-Info.plist** on your Desktop (or wherever you saved it).

4. **Drag the file** from Finder into the Xcode project panel on the left side. Drop it directly onto the **YellowBasket** folder at the top of the file list — not into a subfolder.

5. A dialog box will appear. Make sure:
   - **"Copy items if needed"** is checked
   - The **YellowBasket** target is checked in the "Add to targets" list

6. Click **Finish**.

7. The file should now appear in the Xcode project list. Do not rename it — it must be called exactly `GoogleService-Info.plist`.

> **Important:** Do not drag this file into your GitHub folder or commit it to version control. It contains private credentials.

---

## Step 3: Create a Gemini API Key

Gemini is the Google AI service that identifies ingredients from photos and generates recipes.

1. Go to [aistudio.google.com](https://aistudio.google.com) and sign in with your Google account.

2. In the top-right area, click **Get API key**.

3. Click **Create API key** and select an existing Google Cloud project, or let it create a new one.

4. Your API key will be displayed — it looks something like `AIzaSyXXXXXXXXXXXXXXXXXXXXXX`.

5. **Copy the key** and keep it somewhere safe (like a password manager or a private note). You will need it in the next step.

> **Keep this key private.** Do not share it, post it online, or include it in any file that goes to GitHub.

---

## Step 4: Create Secrets.plist in Xcode

This file tells the app where to find your Gemini API key at runtime.

1. In Xcode, right-click on the **YellowBasket** folder in the left panel and select **New File from Template...** (or **New File...**).

2. In the file template picker, scroll down to find **Property List** and select it. Click **Next**.

3. Name the file exactly **Secrets** (Xcode will add the `.plist` extension automatically). Click **Create**.

4. The file will open as a table with one empty row. Click on the row to select it, then:
   - Set the **Key** to: `GEMINI_API_KEY`
   - Set the **Type** to: `String`
   - Set the **Value** to: your Gemini API key from Step 3

5. Save the file (Command + S).

6. Make sure the file is inside the **YellowBasket** group in the project panel, not floating outside it.

> **Do not commit this file to GitHub.** It is already listed in `.gitignore` so git will ignore it automatically, but double-check by running `git status` — `Secrets.plist` should not appear in the list of changed files.

---

## Step 5: Open and Run the App

1. In Xcode, make sure you have the correct file open — it should say **YellowBasket** in the top bar, not a subfolder or test file.

2. At the top of Xcode, click the **simulator selector** (it shows a device name like "iPhone 16" or "My Mac"). Choose an iPhone simulator such as **iPhone 16** or **iPhone 15**.

3. Press the **Run button** (the triangle/play icon) in the top-left corner of Xcode, or press **Command + R**.

4. Xcode will build the app and launch it in the Simulator. This may take a minute the first time.

5. The YellowBasket splash screen will appear, followed by the login screen.

6. **Create a new account** using any email address and password, or sign in with Google.

7. Once logged in, test the main flow:
   - Tap the **+** button at the bottom centre to add ingredients
   - Choose **Image Scan** and select a photo of food from your photo library
   - Confirm the detected ingredients and tap **Find Recipes**
   - Tap any recipe to see the full detail view
   - Tap **Save Recipe** to save it

---

## 9. Common Setup Problems

### Login does not work / stuck on login screen
**Cause:** `GoogleService-Info.plist` is missing or was not added to the Xcode target correctly.

**Fix:** Repeat Step 2. Make sure the file appears in the Xcode file list and that "Copy items if needed" and the YellowBasket target were both checked when you added it.

---

### AI scan or recipes fail / return nothing
**Cause:** `Secrets.plist` is missing, named incorrectly, or contains the wrong key name or value.

**Fix:** Open `Secrets.plist` in Xcode and confirm:
- The file is named exactly `Secrets.plist`
- The key is exactly `GEMINI_API_KEY` (capital letters, no spaces)
- The value is your full API key with no extra spaces or line breaks

---

### Build error saying a file is missing
**Cause:** A required file was added to the folder on disk but not added to the Xcode project target, so Xcode does not know it exists.

**Fix:** In Xcode, select the file in the left panel, open the right-hand inspector panel (View → Inspectors → File Inspector), and check that the YellowBasket target is listed under **Target Membership**.

---

### "Permission denied" errors when using the app / data not saving
**Cause:** The Firestore security rules have not been published yet, or the user is not logged in when the request is made.

**Fix:** Publish the Firestore rules as described in Section 10 below. Make sure you are fully logged in before trying to save any data.

---

### Google Sign-In button does nothing or shows an error
**Cause:** The `GoogleService-Info.plist` file does not match the Firebase project, or the Google Sign-In provider has not been enabled in the Firebase Console.

**Fix:** In the Firebase Console, go to **Authentication → Sign-in method** and confirm that **Google** is enabled. Then re-download a fresh `GoogleService-Info.plist` from Project Settings and replace the one in Xcode.

---

## 10. Firestore Rules

Firestore rules control who is allowed to read and write data in the database. Without the correct rules, either the database is fully open (a security risk) or fully locked (nothing works).

The rules need to be published manually in the Firebase Console. Here is what to do:

1. Go to [console.firebase.google.com](https://console.firebase.google.com) and open the YellowBasket project.

2. In the left sidebar, click **Firestore Database**.

3. Click the **Rules** tab at the top.

4. Delete any existing content in the rules editor and paste the following:

```
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      match /ingredients/{ingredientId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }

    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

5. Click **Publish**.

These rules ensure that each user can only access their own data, and that no one else can read or write another user's ingredients or saved recipes.

---

## 11. What Is Real vs. Mock Data

Not everything in the app connects to a live backend. Here is a clear breakdown:

### Real (live data, requires internet)

| Feature | How it works |
|---|---|
| Login and account creation | Firebase Authentication |
| Google Sign-In | Firebase + Google OAuth |
| Saved ingredients | Stored in Firestore under your user account, persists across sessions |
| Fridge scan — ingredient detection | Live call to the Gemini 2.5 Flash Vision API |
| Recipe generation | Live call to the Gemini 2.5 Flash LLM API |

### Mock (simulated data, for prototype demonstration)

| Feature | Notes |
|---|---|
| Store deals and discounts | Realistic fake data — prices, quantities, and store names are made up |
| Store names and addresses | Set to Liverpool locations for demonstration purposes |
| Distances to stores | Fixed values, not based on your actual location |
| Impact stats on Home screen | Fixed numbers — "£12.40 saved", "8 meals rescued" — do not update |

---

## 12. Final Handover Notes

**This is a V1 prototype.** It demonstrates the full core product experience and is suitable for user testing and investor presentations. It is not a finished commercial app.

### Keeping the existing Firebase project
If you are happy to continue using the Firebase project that was set up during development (`yellowbasket-f7095`), you do not need to change anything. Just follow Steps 1–5 above and the app will work using the existing project.

### Creating your own Firebase project
If you want to start fresh with your own Firebase project (for example, to have full independent ownership), you will need to:
1. Create a new Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add an iOS app to it with the bundle ID `com.raidkhan.YellowBasket`
3. Enable **Email/Password** and **Google** sign-in under Authentication
4. Create a Firestore database
5. Publish the security rules from Section 10
6. Download the new `GoogleService-Info.plist` and replace the one in Xcode

### Using your own Gemini API key
If you want to use your own Gemini API key (recommended for long-term ownership), follow Step 3 to create a new key and update the value in `Secrets.plist`.

### The one rule that never changes
**Never commit `Secrets.plist` or `GoogleService-Info.plist` to GitHub.** Both files are listed in `.gitignore` to prevent this, but always double-check before pushing any changes. If either file is accidentally pushed to a public repository, treat the credentials as compromised and rotate them immediately.

---

*Handover prepared for YellowBasket V1 — May 2026*
