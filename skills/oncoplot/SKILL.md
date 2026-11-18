---
name: oncoplot
description: Create, explain, refine, and troubleshoot interactive cancer-cohort oncoplots in R using ggoncoplot. Use for mutation tables or MAFs, preparing wide data when needed, and conversational changes to genes, samples, colours, labels, and marginal plots.
---

# Make and refine an interactive oncoplot

Show one working interactive oncoplot first. Then ask what the user would like to explore and make that change through `ggoncoplot()` or `ggoncoplot_options()`. Apply any settings the user already specified on the first call.

## Keep the workflow to at most two R scripts

Inspect the supplied data in R. Identify the sample, gene, optional mutation classification, and any variant identifier. Preserve the biological unit represented by each sample ID. Confirm ambiguous encodings or cohort definitions when they affect the result.

1. **Preprocessing script, only when needed.** A tidy input has one row per mutation and columns for sample and gene. A mutation-level MAF is ready to use with its original column names. Go straight to the plotting script for these inputs. If the data needs reshaping, decoding, or a requested biological filter, put those transformations in one preprocessing script and save its tidy output as a TSV or RDS. For wide inputs, pivot only the gene or sample columns and interpret non-mutation markers according to the source. See the [data recipes](references/data-recipes.md).
2. **Plotting script.** Read the original tidy file or the saved preprocessing output. Make a single call to `ggoncoplot()` and display or save the returned widget directly. Use the user's actual paths and column names. Keep data preparation, custom ggplot layers, and edits to the widget's internals out of this script.

Check missing IDs and potential duplicate annotations while inspecting the input. Use the variant identifier or genomic coordinates and alleles within a sample to distinguish repeated annotations from distinct mutations. Keep genuine variants as separate rows and retain the supplied classifications. With `col_mutation_type`, ggoncoplot shows repeated sample–gene pairs as `Multi_Hit` and combines their tooltips. This label describes multiplicity regardless of allelic phase.

## Make the first plot

For a tidy MAF, the entire plotting script can be this short.

```r
library(ggoncoplot)

mutations <- read.delim("cohort.maf.tsv")
p <- ggoncoplot(
  data = mutations,
  col_genes = "Hugo_Symbol",
  col_samples = "Tumor_Sample_Barcode",
  col_mutation_type = "Variant_Classification",
  interactive = TRUE,
  options = ggoncoplot_options()
)
htmlwidgets::saveWidget(p, "oncoplot.html", selfcontained = TRUE)
```

Start with the package defaults for options, the ten most recurrent genes, gene-based sample ordering, and marginal plots off. The default view shows samples with a call in a displayed gene. Omit `col_mutation_type` if classification is unavailable. An existing variant column such as `Genome_Change` can go directly into `col_tooltip`. Use the package palette when possible. If it cannot colour all supplied classes, pass a complete named `palette` including `Multi_Hit`. The data recipes include a short MAF palette example.

Inspect the rendered widget when execution is available. Show it in the conversation or link the self-contained HTML, and provide the script or scripts that reproduce it. Briefly report transformations, sample inclusion, and multi-hit counts when relevant. Use a static export when the user requests one. If rendering is unavailable, say what could be verified and give runnable code. Obtain permission before installing missing packages.

## Continue the conversation through the API

After showing the first plot, ask one short question offering a few changes relevant to what the user can see. For example, “Would you like to show the top 20 genes, see which genes come next if we leave out TTN and MUC16, or compare a couple of layouts?” Offer gene exclusions using symbols present in the data and apply them when the user chooses them.

| What the user wants to explore | Change in the same plotting script |
| --- | --- |
| More or fewer genes, or a specific panel | Set `topn = 20` or `topn = 5`. An explicit `genes_to_include` vector takes precedence over `topn`. |
| Recurrence after excluding particular genes | Pass exact symbols, e.g. `genes_to_ignore = c("TTN", "MUC16")`. Offer this view when a long or frequently mutated gene dominates the ranking. Let the user choose which genes matter to their question. |
| Different mutation colours | Pass a named `palette` covering the observed classes and `Multi_Hit`. |
| Narrower tiles or visible sample IDs | Set `options = ggoncoplot_options(tile_width = 0.8, show_sample_ids = TRUE)`. Change either setting independently. |
| Marginal plots | Toggle `draw_gene_barplot` and `draw_tmb_barplot` independently. The side bar counts affected samples per gene. The default top bar counts mutation records per sample. A mutations-per-megabase estimate needs an appropriate denominator. |
| All cohort samples | Set `show_all_samples = TRUE`. To include samples known only from metadata, also set `metadata_require_mutations = FALSE`. Recurrence defaults to samples with any mutation in the input. Use `total_samples = "all"` for a denominator that includes the metadata-only samples. |
| Sample annotations or order | Supply `metadata` with one row per sample, `col_samples_metadata` for its key, and `cols_to_plot_metadata` for its annotations. Use `sample_order` or `metadata_sort_cols` to change the ordering. |

Make these changes by editing arguments in the existing plotting script and rerunning it on the same tidy input. For appearance requests, offer a small comparison of interactive plots, such as default tiles, narrower tiles, and visible sample IDs. If the user wants the comparison, reuse the single plotting call once per named set of settings in that script. Hold the data, gene selection, and sample order fixed for an aesthetic comparison. Give each widget a distinct HTML filename, show the choices, and ask which to keep.

Use the installed help for `ggoncoplot` and `ggoncoplot_options` to check unfamiliar arguments. If a request genuinely changes what counts as a mutation, agree on that rule and record the transformation in the optional preprocessing script.
