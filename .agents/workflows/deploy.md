---
description: Build and deploy the Flutter app for all platforms (web, iOS, Android, macOS)
---

// turbo-all

## Prerequisites
Make sure `apps/app/.env` is configured with correct values before deploying.

## Step 1 – Get dependencies & generate code
```bash
export PATH="$PATH:/opt/homebrew/bin:/Users/vaisakhprakash/flutter/bin" && cd /Users/vaisakhprakash/Developer/Code/VPDevPortal/gymai/apps/app && flutter pub get && dart run build_runner build --delete-conflicting-outputs
```

## Step 2 – Analyze (fail fast on errors)
```bash
export PATH="$PATH:/opt/homebrew/bin:/Users/vaisakhprakash/flutter/bin" && cd /Users/vaisakhprakash/Developer/Code/VPDevPortal/gymai/apps/app && flutter analyze --no-pub --fatal-infos=false
```

## Step 3 – Build Web (production)
```bash
export PATH="$PATH:/opt/homebrew/bin:/Users/vaisakhprakash/flutter/bin" && cd /Users/vaisakhprakash/Developer/Code/VPDevPortal/gymai/apps/app && flutter build web --release --web-renderer canvaskit
```
Output: `apps/app/build/web/`

## Step 4 – Build macOS (production)
```bash
export PATH="$PATH:/opt/homebrew/bin:/Users/vaisakhprakash/flutter/bin" && cd /Users/vaisakhprakash/Developer/Code/VPDevPortal/gymai/apps/app && flutter build macos --release
```
Output: `apps/app/build/macos/Build/Products/Release/gymai.app`

## Step 5 – Build iOS Archive (for App Store / TestFlight)
```bash
export PATH="$PATH:/opt/homebrew/bin:/Users/vaisakhprakash/flutter/bin" && cd /Users/vaisakhprakash/Developer/Code/VPDevPortal/gymai/apps/app && flutter build ipa --release
```
Output: `apps/app/build/ios/ipa/gymai.ipa`

## Step 6 – Build Android App Bundle (for Play Store)
```bash
export PATH="$PATH:/opt/homebrew/bin:/Users/vaisakhprakash/flutter/bin" && cd /Users/vaisakhprakash/Developer/Code/VPDevPortal/gymai/apps/app && flutter build appbundle --release
```
Output: `apps/app/build/app/outputs/bundle/release/app-release.aab`

---

> **Web**: Copy `apps/app/build/web/` to Firebase Hosting / Vercel / Netlify.
> **iOS**: Upload `gymai.ipa` via Xcode Organizer or `xcrun altool`.
> **Android**: Upload `app-release.aab` to Google Play Console.
> **macOS**: Notarize and distribute via DMG or Mac App Store.
