import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { LeanSearch } from "./LeanSearch";
import { TypicalSearch } from "./TypicalSearch";
import { search } from "./search";
import "./styles.css";

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <main>
      <h1>One interaction, two implementations</h1>
      <p>Search “focus” for a match, “nothing” for empty, “error” for failure, or “slow” for a delayed response.</p>
      <div className="comparison">
        <section aria-labelledby="typical-heading">
          <h2 id="typical-heading">Typical: intentionally incomplete</h2>
          <TypicalSearch search={search} />
        </section>
        <section aria-labelledby="lean-heading">
          <h2 id="lean-heading">Lean: complete interaction</h2>
          <LeanSearch search={search} />
        </section>
      </div>
    </main>
  </StrictMode>,
);
