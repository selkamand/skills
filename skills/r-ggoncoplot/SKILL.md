---
name: r-ggoncoplot
description: Build, explain, refine, and troubleshoot oncoplots in R using the ggoncoplot package. Use for cancer-cohort mutation visualisation, converting wide mutation tables into mutation-level long data, deciding how to display multiple mutations in a sample–gene pair, choosing genes and samples, adding clinical metadata and barplots, and checking or exporting an oncoplot. Suitable for R beginners and experienced bioinformaticians.
---

# Make an oncoplot in R with ggoncoplot

Guide the user through five phases: **Data → Decisions → First plot → Refinement → Validation and delivery**. Start with a working plot before discussing cosmetic details. Use R for all data manipulation and plotting; favour `dplyr`, `tidyr`, `ggoncoplot`, and `ggplot2`. Do not switch to `maftools` or manually draw an oncoplot unless the user specifically asks.

Work with the data the user supplies (file, data frame, reproducible R snippet, or a small example). If data is not available, give an adaptable example and identify precisely what columns or file are needed. Ask only questions that affect scientific interpretation or cannot safely be inferred; otherwise show the recommended default and let the user change it.

## Phase 1 — Understand and prepare the data

1. Inspect the columns, data types, and a few rows. Identify the **sample identifier**, **gene**, optional **mutation type**, optional **mutation/variant identifier**, and optional **clinical metadata**. Confirm whether each sample is a tumour, patient, time point, etc.; never merge these units silently.
2. Explain long vs wide in plain language if useful: **wide** means different genes are separate columns; **long** means one column holds the gene name and different rows describe mutation records. Show a 2–3-row example instead of relying on jargon. See [data recipes](references/data-recipes.md).
3. `ggoncoplot()` expects a data frame with **one row per mutation** and columns for sample and gene. If already in this form (including MAF-like tables), preserve it. If wide (whether genes are rows or columns), convert with `tidyr::pivot_longer()`, selecting **only gene or sample columns**, not clinical metadata. Then remove explicitly understood non-mutation markers; do not treat blanks, zeroes, `WT`, and `NA` as interchangeable without knowing the encoding.
4. Distinguish a **mutation-level** table (separate variants) from a **sample–gene summary** (one cell per gene and sample). A wide cell encoding several variants may require careful splitting, but do so only when the delimiter truly separates distinct variant events.
5. Check for missing sample/gene IDs, invalid mutation categories, duplicated mutation records, and inconsistent gene or sample naming. Alternative-transcript annotations and duplicated joins can create false multi-hits. Preserve legitimate multiple variants.

Briefly report the inferred column mappings and any transformation; do not silently remove rows.

## Phase 2 — Make scientific and display decisions

Use this **default decision policy** unless the user requests otherwise:

- **Multiple mutations in one gene and sample:** *Keep every genuine mutation as its own row.* Let `ggoncoplot` handle it. If `col_mutation_type` is supplied, it collapses the sample–gene combination to **one tile labelled `Multi_Hit`** whenever there is more than one row for that pair. It combines the distinct tooltips; an optional top mutation-count barplot still counts all mutation rows. Do **not** select a single “most severe” variant or collapse records before plotting by default. Explain that multi-hit does not establish biallelic status. If no mutation-type column is supplied, the plot still consolidates to one tile but does not label it `Multi_Hit`.
- **What counts as a mutation:** Respect the user's included call types and filters. Do not automatically equate all measured alterations with pathogenic mutations. If a table mixes SNVs, indels, CNVs, structural variants, and expression events, establish whether these belong in one classification scheme.
- **Which genes:** Default to `topn = 10` (most recurrent genes). Use `genes_to_include` for an explicit biological gene list; it overrides `topn`. Clarify whether the question is discovery or a predefined pathway/panel.
- **Which samples and denominator:** The package defaults to showing samples represented by selected genes, with `show_all_samples = FALSE`. Ask for a cohort definition if unmutated samples matter; use `show_all_samples = TRUE`, and where appropriate sample `metadata`, `metadata_require_mutations = FALSE`, and `total_samples = "all"`. Explain denominator changes before stating percentages.
- **Mutation colouring:** Use `col_mutation_type` if available; let the package recognise standard MAF/SO/PAVE terms and choose a default palette, or provide an explicit complete named `palette` for custom types (including `Multi_Hit` when relevant). If classification is unavailable, omit `col_mutation_type`; do not invent labels.
- **Ordering:** Start with ggoncoplot's gene-based sample ordering; use `sample_order` or metadata sorting only for a stated need.
- **Interactivity:** Default to `interactive = TRUE` for exploration; use `interactive = FALSE` for a static, publication-ready plot or when interactive widgets cannot render.
- **Marginal plots:** Leave `draw_gene_barplot` and `draw_tmb_barplot` off initially unless useful. The built-in top bar counts mutation records, not necessarily true mutations per megabase; avoid calling it a standardised TMB estimate without an appropriate denominator or custom `tmb_data`.

If the user wants another multi-hit policy (severity priority, combination labels, separate subtiles), describe the trade-off and obtain a severity/aggregation rule before preprocessing. Do not pretend the default `ggoncoplot()` offers a multi-hit-policy argument.

## Phase 3 — Construct the first oncoplot

Produce executable R code using the user's *actual column names*, not abstract placeholders when names are available. Start with the smallest valid call:

```r
library(ggoncoplot)

p <- ggoncoplot(
  data = mutations,
  col_genes = "gene",
  col_samples = "sample",
  col_mutation_type = "mutation_type",
  topn = 10,
  interactive = FALSE
)
p
```

Omit `col_mutation_type` if the column does not exist. Name the transformed data frame `mutations` only when the code also creates it. The column mapping arguments take **strings**. Do not install packages without the user's permission if execution is requested; show installation instructions separately when missing. Consult [R recipes](references/data-recipes.md) for working examples.

## Phase 4 — Refine only what improves the scientific message

Offer targeted improvements, in roughly this order: selected genes/pathways; cohort inclusion and mutation classes; mutation recurrence and per-sample burden; clinical sample metadata; sorting; interactivity and tooltips; aesthetic options. Keep the plot readable and avoid unnecessary clutter.

For metadata, require **one row per sample** and an unambiguous join key; use `metadata`, `col_samples_metadata`, `cols_to_plot_metadata` and, if desired, `metadata_palette`. For variant-specific tooltips, construct a readable text column in R and set `col_tooltip` to its name. For appearance, use `ggoncoplot_options()`. Check the installed package help with `utils::help("ggoncoplot", package = "ggoncoplot")` and verify options in the installed version if anything differs.

## Phase 5 — Validate, communicate, and deliver

Before claiming success, check:

- Sample and gene IDs are present and the intended biological unit is preserved.
- Each true variant is represented once; repeated sample–gene rows are expected when biologically distinct, not an error.
- Report the count of sample–gene pairs with more than one mutation and how those are displayed.
- Confirm the plotted gene set, sample inclusion policy, cohort denominator, category legend (including `Multi_Hit`), and metadata joins.
- If marginal plots are used, distinguish **unique altered samples per gene** from **number of mutation records per sample**.
- Inspect the rendered plot when an R environment is available; do not assert that code executed when it did not. For a static plot, use `ggplot2::ggsave()` on the non-interactive result. For interactive output, use the widget-saving approach supported by the installed package and environment.

Deliver (a) the reusable R code, (b) a short description of the chosen defaults and transformations, (c) validation observations or clearly labelled checks the user should run, and (d) the plot or output file when execution is available.
