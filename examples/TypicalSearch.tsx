import { useState } from "react";
import type { Item, Search } from "./search";

// Deliberately incomplete teaching baseline. Do not use in production.
export function TypicalSearch({ search }: { search: Search }) {
  const [query, setQuery] = useState("");
  const [items, setItems] = useState<Item[]>([]);
  async function run() {
    try {
      setItems(await search(query, new AbortController().signal));
    } catch {
      setItems([]); // Hides failure as an empty list; no recovery explanation.
    }
  }
  return (
    <div>
      <input placeholder="Search topics" value={query} onChange={(event) => setQuery(event.target.value)} />
      <div className="fake-button" onClick={run}>Search</div>
      <ul>{items.map((item, index) => <li key={index}>{item.name}</li>)}</ul>
    </div>
  );
}
