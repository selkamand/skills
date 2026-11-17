---
name: r-package-dev
description: Review, add, or modify code, tests, and documentation in an existing R package. Use for package maintenance and code review; use r-package-start when creating a package from scratch.
---

# Develop an existing R package

Treat the package's established design and style as the default. Use [R Packages (2e)](https://r-pkgs.org/) as the reference for package mechanics when local conventions do not answer a question.

## Establish the baseline before reviewing or changing code

1. Find the package root, read local instructions, and inspect Git status so existing work is not overwritten. Sweep the package before making a review judgment or edit. Read `DESCRIPTION`, `NAMESPACE`, representative `R/` files, `tests/`, `README.Rmd` or `README.md`, and `NEWS.md` when present. Follow references into vignettes, data, and other package files when relevant.
2. Map the existing functionality. Identify exported functions and methods, internal helpers, repeated behavior, and the object types they exchange. Search for an existing implementation of the requested behavior before proposing new code.
3. Infer the authors' conventions from several examples, not one file. Note roxygen block structure and the phrasing of titles, descriptions, parameters, returns, and `@seealso`; the programming style, object models, common patterns, and function depth; README structure and voice; and test layout, fixtures, and assertion style.
4. Run `devtools::check()` on the baseline before implementing a requested change. Record errors, warnings, notes, and any generated file changes separately from the user's existing edits. Resolve package check failures **before** implementing additional changes. If the check cannot run or its failures depend on unavailable tooling, explain the blocker and pause implementation until the baseline can be checked. For a review-only request, report the check result and actionable findings; the requirement to repair baseline failures applies before subsequent implementation.
5. Distill the sweep into a short, concrete set of package-specific rules and share it in the response. For ongoing work, update an existing project guidance file or, when useful, create a concise `R_PACKAGE_STYLE.md` in the package root. Keep it factual and current; a saved note does not replace a fresh sweep on later tasks.

## Decide what to change

Reuse existing behavior when possible. Compare the plausible approaches and choose the simplest one that meets the request. Follow the package's code, documentation, and test style. If a different style would materially improve the result, explain why and get the user's permission before writing in that style. Do not add a package dependency without the user's permission, including a new `Imports` or `Suggests` entry.

For source or test changes, read [change-workflow.md](references/change-workflow.md). For documentation review or edits, read [docs-review.md](references/docs-review.md). Apply both when a code change touches documentation. Preserve the user's scope and distinguish requested changes from pre-existing issues in the final report.



