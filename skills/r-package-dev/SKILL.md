---
name: r-package-dev
description: Review, add, or modify code, tests, and documentation in an existing R package. Use for package maintenance and code review; use r-package-start when creating a package from scratch.
---

# Develop an existing R package

Treat the package's established design and style as the default. Use [R Packages (2e)](https://r-pkgs.org/) as the reference for package mechanics when local conventions do not answer a question.

## Establish the baseline before reviewing or changing code

1. Find the package root, read local instructions and any saved package-style notes, and inspect Git status so existing work is not overwritten. On first use, sweep the package before making a review judgment or edit: read `DESCRIPTION`, `NAMESPACE`, representative `R/` files, `tests/`, `README.Rmd` or `README.md`, and `NEWS.md` when present. On later tasks, start from the saved notes and inspect the relevant code and its neighbors; repeat the wider sweep when the notes are missing, stale, or insufficient. Follow references into vignettes, data, and other files when relevant.
2. During a full sweep, map exported functions and methods, internal helpers, repeated behavior, and the object types they exchange. On later tasks, refresh the map for the affected area. Search for an existing implementation of the requested behavior before proposing new code.
3. During a full sweep, infer conventions from several examples, not one file. Note roxygen titles, descriptions, parameters, returns, and `@seealso`; programming style, object models, helper patterns, README structure and voice, and test layout and assertions. On later tasks, check the saved observations against nearby examples.
4. Run `devtools::check()` on the baseline before implementing a requested change. Record errors, warnings, notes, and any generated file changes separately from the user's existing edits. Resolve package check failures **before** implementing additional changes. If the check cannot run or its failures depend on unavailable tooling, explain the blocker and pause implementation until the baseline can be checked. For a review-only request, report the check result and actionable findings; the requirement to repair baseline failures applies before subsequent implementation.
5. Save a short, concrete summary of the package's observed conventions in an existing project guidance Markdown file or a new `R_PACKAGE_STYLE.md`. Update it when the relevant conventions change, and share the key points in the response. Keep observations separate from recommendations and note inconsistencies rather than inventing a uniform style. If a root guidance file causes an R CMD check NOTE, add a narrow `.Rbuildignore` entry. The saved notes reduce repeated discovery but do not replace checking the code relevant to the current task.

## Review code structure

When asked to review code or changes, inspect the design as well as correctness. Make a separate pass comparing branches and related helpers side by side, especially their type, length, missing-value, and error checks. Name meaningful duplication even when the behavior currently matches and tests pass, then explain the tradeoff between sharing that logic and keeping branches independent. Check nearby comments against the code. Verify claimed bugs with the code or a focused run before reporting them. Give concrete file locations and distinguish defects from optional refactors.

## Decide what to change

Reuse existing behavior when possible. Compare the plausible approaches and choose the simplest one that meets the request. Follow the package's code, documentation, and test style. If a different style would materially improve the result, explain why and get the user's permission before writing in that style. Do not add a package dependency without the user's permission, including a new `Imports` or `Suggests` entry.

For source or test changes, read [change-workflow.md](references/change-workflow.md). For documentation review or edits, read [docs-review.md](references/docs-review.md). Apply both when a code change touches documentation. Preserve the user's scope and distinguish requested changes from pre-existing issues in the final report.
