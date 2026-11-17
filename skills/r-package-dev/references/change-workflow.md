# Code and test changes

## Before writing code

- Search for existing behavior and helpers that can be reused. Ask whether new code is necessary.
- Consider a small change and a genuinely different strategy before choosing an approach. Use the simplest solution that satisfies the requested behavior and the package's design. If an attractive simplification fails for a non-obvious reason, verify the reason with a focused check or authoritative source, then leave a short plain-language comment at the relevant code. Do not document speculative failures.
- Match the package's existing approach to functional decomposition, object types, control flow, helper placement, and error messages. Explain a beneficial departure and ask permission before using it.
- Prefer base R and dependencies already declared by the package. Ask before adding any new package dependency, even one already present indirectly in the dependency tree; avoid adding packages outside that tree in particular.

## Source conventions

- Avoid non-standard or tidy evaluation and avoid `...` in new function interfaces where possible.
- Never use `sapply()`.
- For two-dimensional base R data-frame subsetting, use `drop = FALSE` whenever a data frame is intended, for example `df[rows, cols, drop = FALSE]`.
- Start every exported function with appropriate type and length checks for its user-facing inputs and informative errors. Continue using an existing assertion package if the package has one. Otherwise, follow the package's error style and use an explicit `if (...) { stop("...", call. = FALSE) }` or an equivalent caller-facing condition. Do not add a comment that merely restates a check. Do not use `stopifnot()` for user input validation. Do not add meaningless checks to a function with no inputs.
- For errors raised inside helpers, check whether the message or printed call leaks implementation details. When useful, capture a suitable caller frame or pass the public call into the helper and raise `stop(simpleError(message, call = public_call))` (or use an existing assertion helper's `call` argument). Keep the message actionable to the package user.

## Code comments

- Write comments like a person explaining a decision to a teammate. Use short, ordinary words. Explain why the code takes a non-obvious path or why a tempting alternative fails; avoid repeating what the next line already says. State only reasons supported by the code, the user's stated intent, or a focused check. If the reason is unknown, do not invent one.
- Before finishing any new or rewritten code comments, ask an independent second agent with less context about the codebase and language to read the comment with only the nearby code. Ask it to explain the comment in its own words and identify anything unclear. Do not give it your intended interpretation first. Revise comments it cannot understand without guessing.
- Separately from that readability pass, check each comment against the actual code path, tests, and stated requirement. Confirm that every claim is true and that the comment describes the real reason for the decision. Remove or correct inaccurate comments even if the second agent found them easy to read. If a second agent is unavailable, report that the readability pass could not be completed.

## Tests

- Follow the existing test framework, file layout, naming, fixture style, and level of detail. Add tests for meaningful behavior and edge cases.
- Never change an existing test merely to make it pass without first explaining why the test, rather than the implementation, is wrong and asking the user's permission. This also applies to pre-existing baseline failures.
- For tests that assert an error, capture the message with `testthat::expect_snapshot(error = TRUE)`. When the package controls the error text, also set `cran = TRUE`.
- Keep tests independent of global state. If temporary state is unavoidable, restore it on exit, including after errors. Prefer an existing state helper. If `withr` is already a dependency, its temporary-state helpers may fit; ask before adding it. For a dependency-light package, a small local helper such as this is an option when a random seed must be controlled:

```r
with_seed <- function(seed, expr) {
  had_seed <- exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE)
  if (had_seed) {
    old_seed <- get(".Random.seed", envir = .GlobalEnv, inherits = FALSE)
  }

  on.exit({
    if (had_seed) {
      assign(".Random.seed", old_seed, envir = .GlobalEnv)
    } else if (exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE)) {
      rm(".Random.seed", envir = .GlobalEnv)
    }
  }, add = TRUE)

  set.seed(seed)
  force(expr)
}
```

## Finish the change

- Update documentation and generated help files as appropriate, following the package's conventions and the [documentation review](docs-review.md).
- Run `devtools::check()` after the change and resolve new failures. Report the before-and-after check results accurately.
- If `NEWS.md` exists, add a very brief entry for the change and link the relevant GitHub issue for details. Find an existing issue first; if no issue can be identified, ask the user for its link before finalizing that entry. Never invent an issue or link. Do not create `NEWS.md` when it is absent.
