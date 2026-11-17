#!/usr/bin/env bash
# Starts the Flask backend and Vite frontend with one command (macOS/Linux).
# Usage: ./start.sh   (Ctrl+C stops both)

set -e
ROOT="$(cd "$(dirname "$0")" && pwd)"  # Resolve paths relative to this script, not the caller's cwd

# Prefer python3 (macOS ships no bare `python`); fall back to python
PY="$(command -v python3 || command -v python)"

# Install dependencies only when missing (frontend) to keep startup fast
if [ ! -d "$ROOT/frontend/node_modules" ]; then
  echo "Installing frontend dependencies..."
  (cd "$ROOT/frontend" && npm install)
fi
echo "Checking backend dependencies..."
"$PY" -m pip install -q -r "$ROOT/backend/requirements.txt"

# Stop the backend when this script exits (Ctrl+C, frontend crash, or normal exit)
BACKEND_PID=""
cleanup() {
  if [ -n "$BACKEND_PID" ]; then
    # Flask debug mode spawns a reloader child, so kill children before the parent
    pkill -P "$BACKEND_PID" 2>/dev/null || true
    kill "$BACKEND_PID" 2>/dev/null || true
    echo "Backend stopped."
  fi
}
trap cleanup EXIT INT TERM

echo "Starting backend on http://localhost:5000"
(cd "$ROOT/backend" && exec "$PY" app.py) &
BACKEND_PID=$!

# Frontend runs in the foreground; when it ends, the EXIT trap stops the backend
echo "Starting frontend on http://localhost:5173"
cd "$ROOT/frontend" && npm run dev
