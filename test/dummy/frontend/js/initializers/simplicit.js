import { start } from "simplicit";

import Article from "models/Article";
import LoadMore from "components/main/LoadMore";

// Scripts are loaded from <head> without `defer`, so <body> — and the
// data-model payload — do not exist yet at module eval.
document.addEventListener("DOMContentLoaded", () => {
  start({ root: document, models: [Article], components: [LoadMore] });
});
