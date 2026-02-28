# GymAI – Feature Documentation

> This file is the single source of truth for all implemented features in the GymAI app.
> It must be updated whenever a feature is added, modified, or removed.

---

## App Branding & Icons

**Status:** ✅ Complete  
**Branch:** `main`  
**Last Updated:** 2026-02-28

### Summary
- Custom brain + dumbbell logo used across all platforms
- Launcher icons generated via `flutter_launcher_icons`
- Platform-specific icon configurations:
  - **iOS/macOS/Web:** `app_icon_black.png` (black background, 75% logo scale)
  - **Android Adaptive:** `app_icon_android_foreground.png` (transparent foreground, 66.6% safe zone, `#000000` adaptive background)
- Splash screens configured via `flutter_native_splash` with black background and transparent logo
- In-app logo assets available at `assets/images/logo_transparent.png` and `assets/images/logo_black.png`

---

## Authentication – Firebase Google Sign-In

**Status:** ✅ Complete  
**Branch:** `main`  
**Last Updated:** 2026-02-21

### Summary
- Firebase Authentication integrated across iOS, Android, macOS, and Web
- Google Sign-In as the primary login method
- Clean architecture pattern:
  - `FirebaseAuthDatasource` handles raw Firebase calls
  - `AuthRepository` / `AuthRepositoryImpl` abstract the auth logic
  - `AuthProvider` (Riverpod) exposes auth state to UI
- `GoogleSignIn` configured per-platform in native project files
- `firebase_options.dart` manages multi-platform Firebase config

### Files
- `lib/features/auth/data/datasources/firebase_auth_datasource.dart`
- `lib/features/auth/data/repositories/auth_repository_impl.dart`
- `lib/features/auth/domain/repositories/auth_repository.dart`
- `lib/features/auth/domain/usecases/sign_in_with_google_usecase.dart`
- `lib/features/auth/presentation/providers/auth_provider.dart`
- `lib/features/auth/presentation/screens/login_screen.dart`
- `lib/core/config/firebase_options.dart`
- `lib/core/di/injection.dart`

---

## Profile

**Status:** 🚧 In Progress  
**Branch:** `feature/profile`  
**Last Updated:** 2026-02-28

### Summary
- Feature branch created: `feature/profile`
- Implementation pending

---

_Add new features above this line following the same format._
