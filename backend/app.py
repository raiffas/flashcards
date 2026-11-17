import json
from pathlib import Path

from flask import Flask, jsonify

app = Flask(__name__)

# Data file lives next to this script, so it works from any working directory
DATA_FILE = Path(__file__).parent / "amendments.json"


def ordinal(n: int) -> str:
    """Return n with its English ordinal suffix, e.g. 2 -> '2nd'."""
    # Suffix is chosen from the last digit
    suffix = {1: "st", 2: "nd", 3: "rd"}.get(n % 10, "th")
    return f"{n}{suffix}"


@app.get("/api/amendments")
def get_amendments():
    """Return all flashcard amendments, with display names, in list order."""
    # Read on every request so edits to the JSON show up without a restart
    with DATA_FILE.open(encoding="utf-8") as f:
        amendments = json.load(f)

    # Names are derived from the id rather than stored in the JSON
    for a in amendments:
        a["name"] = f"{ordinal(a['id'])} Amendment"

    # Keep the cards in a stable order for the frontend grid
    amendments.sort(key=lambda a: a["name"])
    return jsonify(amendments)


if __name__ == "__main__":
    # Port 5000 is what the Vite dev proxy points at (see frontend/vite.config.ts)
    app.run(port=5000, debug=True)
