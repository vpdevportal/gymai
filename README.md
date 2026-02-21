# gymai

Cross-platform fitness AI app — Flutter (iOS, Android, macOS, Web) + Python FastAPI.

Built as a **Turborepo monorepo**.

## Structure

```
gymai/
├── apps/
│   ├── app/             ← Flutter app (iOS, Android, macOS, Web)
│   └── backend/         ← Python FastAPI backend
├── packages/            ← Shared libraries (future)
├── .agents/workflows/   ← Turbo automation workflows
├── turbo.json           ← Turborepo pipeline config
├── starting.sh          ← Dev startup script
└── package.json         ← Root workspaces + turbo scripts
```

## Quick Start

```bash
./starting.sh           # start everything (codegen → backend → app)
./starting.sh mobile    # Flutter + iOS Simulator only
./starting.sh api       # Python backend only
./starting.sh codegen   # regenerate code only
```

### Flutter app (manual)
```bash
cd apps/app
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### Python backend (manual)
```bash
cd apps/backend
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
uvicorn app.main:app --reload --port 8000
# API docs → http://localhost:8000/docs
```

## Workflows (slash commands)

| Command | Description |
|---|---|
| `/deploy` | Build all 4 platforms (turbo-all) |
| `/codegen` | Regen Freezed / Riverpod code |
| `/analyze-and-test` | Analyze + test Flutter |
| `/backend-dev` | Start Python dev server |
