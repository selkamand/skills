---
name: r-package-start
description: Create and explain a new R package from scratch with usethis, a README, example function, and development next steps. Use for new package setup, not edits to an existing package.
---

# Start a new R package

Ask what the package should do and who it is for if the user has not said. Clarify the package name or destination only when needed to create it. Use [R Packages (2e)](https://r-pkgs.org/) as the authoritative guide for the package workflow, and adapt the scaffold to the stated goal.

Apply the [comment skill](../comment/SKILL.md) whenever writing or changing R code.

1. Create the package with `usethis::create_package()`. Use `usethis::use_rstudio()` to add an `.Rproj` file if package creation did not already make one. Avoid overwriting an existing project.
2. Create `README.Rmd` with `usethis::use_readme_rmd()` and replace its starter text. Include a plain-language purpose and `Installation` and `Quick start` sections, with an example using the package's actual API. For a local source package, give working local installation instructions; switch to GitHub or repository instructions only when that destination exists. Bootstrap any installer named in the instructions so a reader need not have it preinstalled. Render `README.md` from `README.Rmd`.
3. Put a prominent warning callout in the README saying the package is in early development and is not yet ready for use. Add applicable standard badges: experimental lifecycle, plus a license badge if a license has been chosen. Add CI, coverage, release, or repository badges only when the backing workflow, release, or repository actually exists. Explain briefly when those badges are not yet applicable.
4. Add one small, documented example function under `R/`, chosen to fit the package goal when possible; `add()` is a fallback. Give it a standard roxygen title, parameters, return value, example, and `@export` if it is intended to be public. Run `devtools::document()` and `devtools::check()` on the scaffold; report any tooling or check blockers rather than claiming success.
5. In the handoff, explain the development loop using `devtools::load_all()`, trying the function in an R session, adding a focused test, documenting, and running `devtools::check()`. Ask what the user wants to learn next. Recommend adding real package functionality first; also offer help moving analysis code into the package, using Git and publishing on GitHub, or writing vignettes. For teaching, offer to walk through one function step by step.

Keep the initial scaffold small. Do not add dependencies or publish the package as part of setup unless the user requests those steps.
