#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# gymai – Monorepo Dev Startup Script
# Usage:
#   ./starting.sh           → start everything (app + backend)
#   ./starting.sh mobile    → Flutter on iOS Simulator only
#   ./starting.sh api       → Python backend only
#   ./starting.sh codegen   → run code generation then exit
#
# Run with:  ./starting.sh  (NOT sh starting.sh)
# ─────────────────────────────────────────────────────────────────────────────
set -e

export PATH="$PATH:/opt/homebrew/bin:/Users/vaisakhprakash/flutter/bin"

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
MOBILE_DIR="$ROOT_DIR/apps/app"
API_DIR="$ROOT_DIR/apps/backend"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log()    { printf "${BLUE}[gymai]${NC} %s\n" "$*"; }
success(){ printf "${GREEN}[gymai]${NC} %s\n" "$*"; }
warn()   { printf "${YELLOW}[gymai]${NC} %s\n" "$*"; }
error()  { printf "${RED}[gymai]${NC} %s\n" "$*"; exit 1; }

# ── Checks ────────────────────────────────────────────────────────────────────
check_flutter() {
  command -v flutter >/dev/null 2>&1 || error "Flutter not found."
  FLUTTER_VER=$(flutter --version 2>/dev/null | head -1 | awk '{print $2}')
  log "Flutter $FLUTTER_VER"
}

check_python() {
  command -v python3 >/dev/null 2>&1 || error "Python 3 not found."
  log "$(python3 --version)"
}

# ── Tasks ─────────────────────────────────────────────────────────────────────
run_codegen() {
  log "Running Flutter code generation..."
  cd "$MOBILE_DIR"
  flutter pub get
  dart run build_runner build --delete-conflicting-outputs
  success "Code generation complete ✓"
}

start_api() {
  log "Setting up Python backend..."
  cd "$API_DIR"

  if [ ! -d ".venv" ]; then
    warn "Creating virtual environment..."
    python3 -m venv .venv
  fi

  # shellcheck disable=SC1091
  source .venv/bin/activate
  pip install -q -r requirements.txt

  if [ ! -f ".env" ]; then
    warn ".env not found — copying from .env.example"
    cp .env.example .env
  fi

  success "FastAPI → http://localhost:8000  |  docs → http://localhost:8000/docs"
  uvicorn app.main:app --reload --port 8000
}

start_mobile() {
  log "Starting Flutter on iOS Simulator..."
  cd "$MOBILE_DIR"

  flutter pub get

  # Codegen check: look for any generated dart file
  GENFILE=$(find lib -name "*.g.dart" 2>/dev/null | head -1)
  if [ -z "$GENFILE" ]; then
    warn "Generated files missing — running codegen..."
    dart run build_runner build --delete-conflicting-outputs
  fi

  # Boot the iOS Simulator app (xcrun boots the default/last device)
  log "Opening iOS Simulator..."
  open -a Simulator

  # Give simulator a moment to show up as a device
  sleep 3

  success "Launching app... (Flutter will connect to the booted iPhone)"
  flutter run -d iPhone
}

# ── Main ──────────────────────────────────────────────────────────────────────
MODE="${1:-all}"

case "$MODE" in
  mobile)
    check_flutter
    start_mobile
    ;;
  api)
    check_python
    start_api
    ;;
  codegen)
    check_flutter
    run_codegen
    ;;
  all)
    check_flutter
    check_python
    run_codegen

    log "Starting backend in background..."
    start_api &
    API_PID=$!
    sleep 2

    start_mobile

    log "Shutting down backend (PID $API_PID)..."
    kill "$API_PID" 2>/dev/null || true
    wait "$API_PID" 2>/dev/null || true
    success "All services stopped."
    ;;
  *)
    echo "Usage: $0 [mobile|api|codegen|all]"
    exit 1
    ;;
esac
