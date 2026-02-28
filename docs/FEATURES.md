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

## Tabbed Navigation Shell

**Status:** ✅ Complete  
**Branch:** `feature/profile`  
**Last Updated:** 2026-02-28

### Summary
- 3-tab bottom navigation: **Diary**, **Dashboard**, **Profile**
- `StatefulShellRoute.indexedStack` (go_router) — each tab preserves its own navigation stack independently
- Custom bottom nav bar (`AppShell`) with a **promoted center Dashboard button** — elevated circle with gradient, animated float on selection
- Diary tab: `Icons.book` / `Icons.book_outlined`
- Dashboard tab: Circular gradient FAB-style with `Icons.dashboard_rounded` — floats up when active
- Profile tab: `Icons.person_rounded` / `Icons.person_outline_rounded`
- All tab transitions are animated (200ms `easeInOut`)
- Login screen redirects to `/dashboard` after successful auth

### Files
- `lib/core/widgets/app_shell.dart` — custom bottom nav bar widget
- `lib/core/router/app_router.dart` — `StatefulShellRoute` wiring
- `lib/core/router/app_routes.dart` — route constants
- `lib/features/diary/presentation/screens/diary_screen.dart`
- `lib/features/dashboard/presentation/screens/dashboard_screen.dart`
- `lib/features/profile/presentation/screens/profile_screen.dart`

---

## Profile

**Status:** ✅ Complete  
**Branch:** `feature/profile`  
**Last Updated:** 2026-02-28

### Summary
- Displays user **name** and **email** from Firebase Auth state (via `authProvider`)
- **Avatar**: Shows Google profile photo if available; falls back to initials with gradient background
- **Account section**: Name, Email
- **Body Metrics section**: Editable Height (cm), Weight (kg), Age (yrs)
  - Inline edit mode with numeric text fields and input validation
  - Data saved to **Firestore** under `users/{userId}` document
  - Loaded on screen open with optimistic local update on save
- **Settings section**: Notifications, Privacy, Help & Support (placeholder rows)
- **Sign Out** button — calls `logout()` on `authProvider` then redirects to Login
- Firestore security rules: users can only access their own document

### Architecture
- `UserProfile` domain entity
- `FirestoreProfileDataSource` → Firestore `users/{userId}` document
- `UserProfileRepository` interface + `UserProfileRepositoryImpl`
- `BodyMetricsNotifier` (Riverpod) uses `UserProfileRepository` via GetIt

### Files
- `lib/features/profile/domain/entities/user_profile.dart`
- `lib/features/profile/domain/repositories/user_profile_repository.dart`
- `lib/features/profile/data/datasources/firestore_profile_datasource.dart`
- `lib/features/profile/data/models/user_profile_model.dart`
- `lib/features/profile/data/repositories/user_profile_repository_impl.dart`
- `lib/features/profile/presentation/providers/body_metrics_provider.dart`
- `lib/features/profile/presentation/screens/profile_screen.dart`
- `firestore.rules`

---

_Add new features above this line following the same format._
