import { useEffect, useState } from "react";

// Shape of each item returned by GET /api/amendments
interface Amendment {
  id: number;
  name: string;
  keyPoint: string;
}

/** Renders a 4x4 grid of flashcards; click a card to flip it. */
export default function App() {
  const [amendments, setAmendments] = useState<Amendment[]>([]);
  // Track flipped cards by id; a Set keeps toggling simple
  const [flipped, setFlipped] = useState<Set<number>>(new Set());

  // Fetch once on mount (the only effect in the app)
  useEffect(() => {
    fetch("/api/amendments")
      .then((res) => res.json())
      .then(setAmendments);
  }, []);

  /** Add the card to the flipped set, or remove it if already there. */
  function toggle(id: number) {
    const next = new Set(flipped);
    if (!next.delete(id)) next.add(id);
    setFlipped(next);
  }

  return (
    <main>
      <h1>US Constitution Flashcards</h1>
      <div className="grid">
        {amendments.map((a) => {
          const isFlipped = flipped.has(a.id);
          return (
            // Different CSS class per side gives the two colors; no animation
            <button
              key={a.id}
              className={`card ${isFlipped ? "back" : "front"}`}
              onClick={() => toggle(a.id)}
            >
              {isFlipped ? a.keyPoint : a.name}
            </button>
          );
        })}
      </div>
    </main>
  );
}
