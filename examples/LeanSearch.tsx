import { useEffect, useId, useRef, useState, type FormEvent } from "react";
import type { Item, Search } from "./search";

type Result =
  | { status: "idle" }
  | { status: "pending"; query: string }
  | { status: "success"; query: string; items: Item[] }
  | { status: "error"; query: string };

export function LeanSearch({ search }: { search: Search }) {
  const inputId = useId();
  const [query, setQuery] = useState("");
  const [result, setResult] = useState<Result>({ status: "idle" });
  const request = useRef<AbortController | null>(null);

  useEffect(() => () => {
    request.current?.abort();
    request.current = null;
  }, []);

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const submitted = query.trim();
    if (!submitted) return;
    request.current?.abort();
    const current = new AbortController();
    request.current = current;
    setResult({ status: "pending", query: submitted });
    try {
      const items = await search(submitted, current.signal);
      // Identity also protects against a transport that ignores AbortSignal.
      if (request.current === current) {
        setResult({ status: "success", query: submitted, items });
      }
    } catch {
      if (request.current === current && !current.signal.aborted) {
        setResult({ status: "error", query: submitted });
      }
    }
  }

  const status = result.status === "pending"
    ? `Searching for “${result.query}”…`
    : result.status === "success"
      ? result.items.length
        ? `${result.items.length} ${result.items.length === 1 ? "result" : "results"} for “${result.query}”.`
        : `No results for “${result.query}”. Try a different topic.`
      : "";

  return (
    <div>
      <form onSubmit={submit} aria-label="Topic search">
        <label htmlFor={inputId}>Search topics</label>
        <div className="search-controls">
          <input id={inputId} type="search" required value={query}
            onChange={(event) => setQuery(event.target.value)} />
          <button type="submit" disabled={!query.trim()}>Search</button>
        </div>
      </form>
      {/* Persist the live region; new reads replace old ones without stealing focus. */}
      <p className="status" role="status">{status}</p>
      {result.status === "error" && (
        <p role="alert">Could not search for “{result.query}”. Your query is kept; select Search to retry or edit it.</p>
      )}
      <div aria-busy={result.status === "pending"}>
        {result.status === "success" && result.items.length > 0 && (
          <ul aria-label={`Results for ${result.query}`}>
            {result.items.map((item) => <li key={item.id}>{item.name}</li>)}
          </ul>
        )}
      </div>
    </div>
  );
}
