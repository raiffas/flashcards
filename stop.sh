#!/usr/bin/env bash
# Stops the Flask backend and Vite frontend started by start.sh (macOS/Linux).
# Usage: ./stop.sh   (useful if a terminal was closed and left servers running)

# Ports must match those in start.sh
for port in 5000 5173; do
  # -t prints bare PIDs; -sTCP:LISTEN ignores client connections to the port
  pids="$(lsof -t -iTCP:"$port" -sTCP:LISTEN 2>/dev/null || true)"
  if [ -z "$pids" ]; then
    echo "Nothing listening on port $port."
    continue
  fi
  for pid in $pids; do
    # Flask debug mode runs a reloader parent; kill it first so it can't respawn the server
    ppid="$(ps -o ppid= -p "$pid" | tr -d ' ')"
    if ps -o comm= -p "$ppid" 2>/dev/null | grep -Eqi 'python|node'; then
      kill "$ppid" 2>/dev/null || true
    fi
    kill "$pid" 2>/dev/null || true  # SIGTERM lets the servers close their sockets cleanly
  done
  echo "Stopped process(es) on port $port."
done
