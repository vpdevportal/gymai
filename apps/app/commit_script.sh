#!/bin/bash
git status -s

# Add auth files
git add lib/features/auth/
git add lib/core/config/
git add lib/core/error/
git add lib/core/di/
git add lib/main.dart
git add android/app/google-services.json
git add android/build.gradle
git add android/app/build.gradle
git add ios/Runner/GoogleService-Info.plist
git add ios/Runner/AppDelegate.swift
git add ios/Runner/Runner.entitlements
git add macos/Runner/GoogleService-Info.plist
git add macos/Runner/DebugProfile.entitlements
git add macos/Runner/Release.entitlements
git add ios/Runner/Runner.xcodeproj/project.pbxproj
git add pubspec.yaml
git add pubspec.lock

git commit -m "feat(auth): integrate firebase google sign in across platforms"

# Add branding files
git add assets/icon/
git add assets/images/
git add ios/Runner/Assets.xcassets/
git add ios/Runner/Base.lproj/
git add ios/Runner/Info.plist
git add ios/Runner/SceneDelegate.swift
git add macos/Runner/Assets.xcassets/
git add macos/Flutter/GeneratedPluginRegistrant.swift
git add android/app/src/main/res/
git add android/app/src/main/AndroidManifest.xml
git add web/

git commit -m "style(ui): update app icons and uniform splash screens"

# Add any remaining uncommitted changes just in case
git add .
git commit -m "chore: cleanup and configuration updates" || echo "No remaining changes"

# Status
git status
