import { StrictMode } from "react";
import { act, cleanup, fireEvent, render, screen } from "@testing-library/react";
import { afterEach, describe, expect, it, vi } from "vitest";
import { LeanSearch } from "./LeanSearch";
import type { Item, Search } from "./search";

afterEach(cleanup);

function submit(query: string) {
  fireEvent.change(screen.getByRole("searchbox", { name: "Search topics" }), { target: { value: query } });
  fireEvent.submit(screen.getByRole("form", { name: "Topic search" }));
}

function deferred() {
  let resolve!: (items: Item[]) => void;
  let reject!: (error: Error) => void;
  const promise = new Promise<Item[]>((yes, no) => { resolve = yes; reject = no; });
  return { promise, resolve, reject };
}

describe("LeanSearch", () => {
  it("names the input and native submit control, rejects whitespace, and exposes pending progress", () => {
    const search = vi.fn<Search>(() => new Promise(() => {}));
    render(<LeanSearch search={search} />);
    expect(screen.getByRole("button", { name: "Search" }).tagName).toBe("BUTTON");
    submit("   ");
    expect(search).not.toHaveBeenCalled();
    submit("focus");
    expect(screen.getByRole("status").textContent).toContain("Searching");
    expect(search.mock.calls[0][0]).toBe("focus");
  });

  it("renders results without moving focus", async () => {
    const pending = deferred();
    render(<LeanSearch search={() => pending.promise} />);
    const input = screen.getByRole("searchbox");
    input.focus();
    submit("focus");
    await act(async () => pending.resolve([{ id: "focus", name: "Focus management" }]));
    expect(screen.getByRole("status").textContent).toContain("1 result for");
    expect(screen.getByRole("list", { name: "Results for focus" }).textContent).toContain("Focus management");
    expect(document.activeElement).toBe(input);
  });

  it("distinguishes empty success from failure", async () => {
    render(<LeanSearch search={async () => []} />);
    submit("nothing");
    await screen.findByText(/No results for/);
    expect(screen.queryByRole("alert")).toBeNull();
    expect(screen.queryByRole("list")).toBeNull();
  });

  it("keeps the query after failure and recovers on retry", async () => {
    const search = vi.fn<Search>()
      .mockRejectedValueOnce(new Error("Offline"))
      .mockResolvedValueOnce([{ id: "focus", name: "Focus management" }]);
    render(<LeanSearch search={search} />);
    submit("focus");
    await screen.findByRole("alert");
    expect((screen.getByRole("searchbox") as HTMLInputElement).value).toBe("focus");
    fireEvent.submit(screen.getByRole("form"));
    await screen.findByRole("list");
    expect(screen.queryByRole("alert")).toBeNull();
    expect(search).toHaveBeenCalledTimes(2);
  });

  it.each(["resolve", "reject"] as const)("ignores obsolete %s even when transport ignores abort", async (outcome) => {
    const old = deferred();
    const latest = deferred();
    const search = vi.fn<Search>().mockReturnValueOnce(old.promise).mockReturnValueOnce(latest.promise);
    render(<LeanSearch search={search} />);
    submit("old");
    submit("latest");
    expect(search.mock.calls[0][1].aborted).toBe(true);
    await act(async () => latest.resolve([{ id: "new", name: "Latest result" }]));
    await act(async () => {
      if (outcome === "resolve") old.resolve([{ id: "old", name: "Obsolete result" }]);
      else old.reject(new Error("Obsolete failure"));
    });
    expect(screen.getByRole("list").textContent).toBe("Latest result");
    expect(screen.queryByRole("alert")).toBeNull();
  });

  it("aborts on unmount and tolerates late completion under StrictMode", async () => {
    const pending = deferred();
    const search = vi.fn<Search>(() => pending.promise);
    const view = render(<StrictMode><LeanSearch search={search} /></StrictMode>);
    submit("focus");
    view.unmount();
    expect(search.mock.calls[0][1].aborted).toBe(true);
    await act(async () => pending.resolve([{ id: "late", name: "Late result" }]));
    expect(screen.queryByRole("list")).toBeNull();
  });
});
