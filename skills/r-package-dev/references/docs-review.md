# Documentation review and edits

Read several roxygen blocks and the README source before judging consistency. Preserve established wording and structure when writing new documentation. For a review-only request, report issues with examples; keep edits within the user's requested scope.

## Roxygen

- Check whether sentence-level `@description`, `@param`, `@return` or `@returns`, and `@seealso` text ends in full stops, whether parameter descriptions start with capital letters, and whether these practices are consistent across the package.
- Compare title, description, `@param`, `@return` or `@returns`, and `@seealso` usage and phrasing. Note missing or unhelpful sections for exported functions, mismatches with actual inputs or return values, and inconsistent linking.
- Check that updated documentation explains behavior visible to users rather than internal mechanics. Regenerate `.Rd` files with the package's documentation workflow when source roxygen changes.

## README

- If `README.Rmd` exists, treat it as the source and keep `README.md` in sync with the package's build workflow.
- Check for an installation section and a small quick-start example that actually matches the current API.
- Verify installation instructions for a reader who does not already have `remotes`, `pak`, or another named installer. Show how to install that tool first, or use a base-R installation route when available. Do not claim the package is on CRAN or GitHub unless that is true.
- Keep the README's layout, level of detail, and tone consistent when editing it.
