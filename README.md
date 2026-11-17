# Amendment Flashcards

React + TypeScript (Vite) frontend, Flask backend serving `backend/amendments.json`.

## About this repo

This repo was generated with Claude Code for running mock AI-assisted technical
interviews. It contains:

- **The code:** a small flashcard app (frontend and backend) with planted bugs.
- **The instructions:** [TASK.md](TASK.md), a two-part exercise for the candidate
  (Part 1: find and fix bugs; Part 2: add a cached search feature).

## Run (one command)

```
.\start.cmd      # Windows (or .\start.ps1 in PowerShell)
./start.sh       # macOS/Linux (first time: chmod +x start.sh)
```

Ctrl+C stops both servers. On macOS/Linux use `python3`/`pip3` in the manual steps below.

## Run (two terminals)

```
# Terminal 1 - backend (http://localhost:5000)
cd backend
pip install -r requirements.txt
python app.py

# Terminal 2 - frontend (http://localhost:5173)
cd frontend
npm install
npm run dev
```

Open http://localhost:5173.
