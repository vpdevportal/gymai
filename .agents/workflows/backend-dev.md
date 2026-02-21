---
description: Start the Python FastAPI backend dev server
---

// turbo
1. Create and activate virtual environment (first time setup):
```bash
cd /Users/vaisakhprakash/Developer/Code/VPDevPortal/gymai/apps/backend && python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt
```

// turbo
2. Start the FastAPI dev server:
```bash
cd /Users/vaisakhprakash/Developer/Code/VPDevPortal/gymai/apps/backend && source .venv/bin/activate && uvicorn app.main:app --reload --port 8000
```
