---
description: Project rules and conventions for GymAI
---

# GymAI Project Rules

Follow these rules for EVERY task in this project unless explicitly overridden:

## Project Structure
- Flutter monorepo root: `/Users/vaisakhprakash/Developer/Code/VPDevPortal/gymai`
- Flutter app: `apps/app/`
- Python FastAPI backend: `apps/backend/`

## Architecture
- Use **Clean Architecture**: datasource → repository → usecase → provider → screen
- State management: **Riverpod** with `riverpod_annotation` codegen
- Dependency injection: **injectable** + **get_it**
- Routing: **go_router**

## Code Quality
- Run `dart analyze` after any Dart file changes
- Fix all linting errors before committing
- Run `dart run build_runner build --delete-conflicting-outputs` after adding new Freezed/Riverpod/injectable annotated classes

## Git & Commits
- Always use **conventional commits**: `feat`, `fix`, `style`, `chore`, `docs`, `refactor`, `test`
- Group related files into logical commits by context (auth, ui, config, etc.)
- Firebase config files (`google-services.json`, `GoogleService-Info.plist`, `firebase_options.dart`) ARE tracked in git — do NOT add them to `.gitignore`

## Documentation — MANDATORY
- After **every feature addition, modification, or removal**, update `docs/FEATURES.md`
- Use this format for each feature entry:
  ```
  ## Feature Name
  **Status:** ✅ Complete | 🚧 In Progress | ❌ Removed
  **Branch:** `branch-name`
  **Last Updated:** YYYY-MM-DD
  ### Summary
  - bullet points describing what was done
  ### Files
  - list of relevant file paths
  ```
- Commit doc updates separately as: `docs: update features documentation`

## App Icons
- Source icons are in `apps/app/assets/icon/`
- Regenerate icons with: `dart run flutter_launcher_icons` (run from `apps/app/`)
- Splash screens: `dart run flutter_native_splash:create` (run from `apps/app/`)
- Do not modify splash screen or `assets/images/` logo when only updating launcher icons
