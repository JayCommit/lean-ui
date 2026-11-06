export type Item = { id: string; name: string };
export type Search = (query: string, signal: AbortSignal) => Promise<Item[]>;

const items: Item[] = [
  { id: "keyboard", name: "Keyboard navigation" },
  { id: "focus", name: "Focus management" },
  { id: "motion", name: "Reduced motion" },
];

// Local fixture only: no backend, API key, or parent repository dependencies.
export const search: Search = (query, signal) =>
  new Promise((resolve, reject) => {
    if (signal.aborted) {
      reject(new DOMException("Aborted", "AbortError"));
      return;
    }
    function abort() {
      clearTimeout(timer);
      reject(new DOMException("Aborted", "AbortError"));
    }
    const timer = setTimeout(() => {
      signal.removeEventListener("abort", abort);
      if (query.toLowerCase() === "error") reject(new Error("Demo failure"));
      else resolve(items.filter((item) => item.name.toLowerCase().includes(query.toLowerCase())));
    }, query.toLowerCase() === "slow" ? 3000 : 700);
    signal.addEventListener("abort", abort, { once: true });
  });
