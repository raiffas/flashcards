# Interview Task: Amendment Flashcards

## About the app

A US Constitution flashcard site for studying amendments. The page shows a grid of
cards, each labelled with an amendment's name (for example "1st Amendment"). Click a
card to flip it and see its key point; click again to flip it back.

- **Frontend:** React + TypeScript (Vite) in `frontend/`.
- **Backend:** Flask in `backend/`, which serves the amendments from
  `backend/amendments.json` at `GET /api/amendments`.

## Ground rules

You may use AI tools. We care about how you work: how you reproduce problems,
check what the AI gives you, and explain your decisions.

Run the app with `.\start.cmd` (Windows) or `./start.sh` (macOS/Linux), then open
http://localhost:5173.

## Part 1: Something looks off (about 15 min)

The flashcards page has problems. Find them, fix them, and be ready to explain
the cause of each one.

## Part 2: Fast search (about 35 min)

Add a search box above the cards that filters them as the user types.

Requirements:
- A query matches amendments whose name or key point contains **every** typed word
  (case-insensitive). The last word may be a prefix (for example "ju" matches "jury").
- An empty query shows all cards.
- The server must stop re-reading and re-parsing `backend/amendments.json` on every
  request.
- Repeated searches should be served from a bounded cache of recent queries
  (keep the most recent 50).
- Edits to `amendments.json` must still show up without restarting the server.

Be ready to explain your data structure and caching choices, and how you tested them.
