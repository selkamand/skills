---
name: oncoplot
description: Create, explain, refine, and troubleshoot interactive cancer-cohort oncoplots in R using ggoncoplot. Use for mutation tables and MAFs, including wide-to-long preparation and user-guided review of tile colours, genes, sample metadata, and layout.
---

# Make and refine an interactive oncoplot

For a new oncoplot, work through the six stages below in order. Name the current stage and briefly explain what you are doing. Show its result in the same turn as a short question asking whether to keep it and move on or revise it. If the user wants another revision, ask what they want to change if they haven't said and offer one or two concrete suggestions when obvious. Make the requested change, show the result again, and ask again. **Advance only when the user approves the current result or explicitly asks to move on.** Honour explicit requests to skip stages or edit a specific part of an existing plot.

After data preparation, aim for one quick render per requested revision. Offer choices based on the preview and let the user choose. Keep earlier choices as you update the same plotting script. Show the interactive widget in the conversation when supported or link the HTML. Check that it renders before sharing. If rendering is unavailable, provide runnable code and say what you could verify.

## 1. Prepare the mutation data

- Inspect the input in R. Identify the gene and sample columns, what each sample ID represents, and any mutation classification and variant ID columns. Preserve ID strings and check for blank or missing IDs. Confirm ambiguous column mappings, cohort definitions, or cell encodings before using them.
- A tidy table has one row per mutation and columns for sample and gene. Use an already tidy table or mutation-level MAF directly with its original column names. For wide inputs, pivot only the gene or sample columns and interpret non-mutation markers based on the source. See the [wide and long data recipes](references/data-recipes.md).
- Check for duplicate annotations. Use a variant identifier or genomic coordinates and alleles within a sample to distinguish repeated annotations from distinct variants. Confirm how to resolve repeated annotations if the source does not establish a rule. Keep genuine variants as separate rows and preserve their original classifications.

Show a small preview of the ready-to-plot table, the proposed column mapping, and mutation, sample, and gene counts. Link the original file when ready as supplied. If reshaping was required, save the tidy data as TSV or RDS and share it with `tidy_data_for_oncoplot.R`, which reproduces the reshape. Ask the user to confirm the prepared data and mappings or request changes before plotting.

## 2. Render a basic interactive oncoplot

Read the agreed mutation data and make one call to `ggoncoplot()` with `draw_gene_barplot = TRUE`. Leave the other settings at their defaults, including interactive mode and the single mutation colour. The side bar counts the samples affected per gene. By default, samples appear if they have a mutation in a displayed gene.

For a tidy MAF in a headed TSV, the plotting script can be this short.

```r
mutations <- read.delim("cohort.maf.tsv")
p <- ggoncoplot::ggoncoplot(
  data = mutations,
  col_genes = "Hugo_Symbol",
  col_samples = "Tumor_Sample_Barcode",
  draw_gene_barplot = TRUE
)
htmlwidgets::saveWidget(p, "oncoplot.html", selfcontained = TRUE)
```

Use the actual paths, reader, and column names. Keep this first script to simple parsing, plotting, and widget output. Show the interactive plot and share the R script. Ask whether the baseline looks right and the user is ready to choose mutation colours, or whether they want to revisit the input or baseline.

## 3. Add mutation colours

If the user has yet to choose a tile colour column, propose one, such as `Variant_Classification` in a MAF. Ask whether to use it, pick another, or keep one colour. Pass the chosen column as `col_mutation_type` and try the package's automatic palette first. Check the rendered legend. If there is no usable automatic palette, apply a named, colourblind-friendly vector of hex colours via `palette`, using the actual class names. For example, `c(Missense_Mutation = "#0072B2", Nonsense_Mutation = "#D55E00", Multi_Hit = "#000000")` covers those two classes and `Multi_Hit`. Use a palette suited to the number of classes, such as Okabe–Ito for a small set.

Cover every observed class and reserve a colour for `Multi_Hit`. With mutation colouring enabled, ggoncoplot labels repeated sample–gene pairs `Multi_Hit` and combines their tooltips. The label describes multiplicity regardless of allelic phase. If a variant identifier would help users interpret a tile, offer the existing column as `col_tooltip`.

Show the interactive plot with the chosen colours and ask whether to keep them and move on to gene selection or adjust them. If the user keeps one colour, use the baseline preview. Rerender after each requested change and repeat the question.

## 4. Choose which genes to show

Show the current plot and explain that it defaults to the 10 most recurrent genes, ranked by the number of affected samples. Ask whether the user wants to keep the top 10 or try one of these changes.

- **Change the number of genes.** Offer the top 10, 20, or 30 with `topn`.
- **Exclude genes prone to frequent background mutations.** Offer examples present in the data, such as a long gene like TTN or a mucin like MUC16. For the package list, use `genes_to_ignore = somaticflags::somaticflags`. Pass exact symbols if the user wants specific exclusions. Explain that this affects the displayed ranking.
- **Exclude mitochondrial genes.** Identify their exact symbols from the cohort's chromosome annotation or a confirmed symbol convention and pass them to `genes_to_ignore`.
- **Show a specific gene set.** Use `genes_to_include`, which takes precedence over `topn`. Tell the user if any requested genes are absent from the input.

Apply each requested change with the ggoncoplot API. Show the interactive result and ask, “Are you happy with which genes are shown, or would you like to keep iterating?” Offer plausible next changes when the user wants to continue exploring. Advance to metadata only when they are happy with the gene selection.

## 5. Add sample metadata

Ask whether the user has a sample- or patient-level table and which annotations they want to see. Confirm which metadata column maps to the mutation sample ID and check ID overlap in both directions. Summarise unmatched IDs. The plotting table must have one row per sample with a unique, nonmissing key. If patient-level data covers several samples per patient, confirm the patient-to-sample mapping before expanding it. Resolve conflicting or ambiguous entries with the user before plotting.

Pass the agreed table as `metadata`, with `col_samples_metadata` and `cols_to_plot_metadata`. Show the interactive plot with the default annotation colours and ask whether to keep or revise them. For categorical annotations, customise `metadata_palette` as a list keyed by metadata column, with a named, colourblind-friendly vector for the levels in each column. For example, `list(Subtype = c(Basal = "#0072B2", Luminal = "#E69F00"))`. Ask which annotation or levels to adjust if unclear. Show each updated plot and ask whether to keep refining the annotation colours or move on. If the user has no metadata or chooses to skip it, advance to aesthetics.

If the user wants all known samples shown, use `show_all_samples = TRUE` and include samples known only from metadata with `metadata_require_mutations = FALSE`. If the recurrence denominator should include those samples too, use `total_samples = "all"`. Use `sample_order` or `metadata_sort_cols` when the user requests a different order.

## 6. Adjust aesthetics and finish

Show the current plot and offer a menu that fits the displayed panels and the user's goal. Pass the chosen styling settings through `options = ggoncoplot_options(...)`. Check the installed help for `ggoncoplot_options()` for additional settings.

- **Tile width and height.** Adjust `tile_width` and `tile_height` to change the gaps between sample columns and gene rows.
- **Marginal plot visibility.** Toggle the gene recurrence and TMB barplots independently with `draw_gene_barplot` and `draw_tmb_barplot` in `ggoncoplot()`.
- **Relative panel sizes.** Use `plotsize_tmb_rel_height` and `plotsize_metadata_rel_height` to change how much vertical space the displayed TMB and metadata panels take up. The main mutation tile plot uses the remaining height. Use `plotsize_gene_rel_width` to change the share of horizontal space taken up by the side barplot.
- **Overall dimensions and aspect ratio.** Set `interactive_svg_width` and `interactive_svg_height` for a wider or taller interactive canvas. For static exports, set `width` and `height` in `ggplot2::ggsave()`.
- **Spacing between panels.** Adjust the gaps around displayed panels with `buffer_tmb`, `buffer_genebar`, and `buffer_metadata`.
- **Sample IDs.** Show or hide them with `show_sample_ids`, move them above or below the tiles with `sample_id_position`, or adjust `sample_id_angle` and `fontsize_samples` for readability.
- **Axis titles and label styling.** Toggle titles with `show_xlab_title` and `show_ylab_title`, edit the text with `xlab_title` and `ylab_title`, and change the size or weight of gene and sample labels with `fontsize_genes`, `fontface_genes`, and `fontface_samples`.
- **Tile colours.** Change the fill of non-mutation tiles with `colour_backround` or adjust the mutation fill in a single-colour plot with `colour_mutation_type_unspecified`.
- **Legends.** Toggle legends or their titles with `show_legend` and `show_legend_titles`. Adjust mutation legend columns with `ggoncoplot_guide_ncol`, swatch size with `legend_key_size`, or text size with `fontsize_legend_title` and `fontsize_legend_text`. Use `prettify_legend_titles` and `prettify_legend_values` to control whether labels are reformatted.
- **Marginal axes and labels.** Toggle axes with `show_axis_gene` and `show_axis_tmb`. Add recurrence percentages with `show_genebar_labels` and adjust their precision with `genebar_label_round`. Offer a linear TMB axis with `log10_transform_tmb = FALSE`, especially when zero-count samples are displayed.
- **Metadata layout.** Move annotation tracks above or below the main plot with `metadata_position` and resize their labels with `fontsize_metadata_text`. Switch numeric annotations between bars and heatmaps with `metadata_numeric_plot_type`, or arrange categorical legend rows and columns with `metadata_legend_nrow` and `metadata_legend_ncol`.
- **Pathway labels.** When pathways are shown, adjust their label angle and text size with `pathway_text_angle` and `fontsize_pathway`, or change the strip fill and text colours with `colour_pathway_bg` and `colour_pathway_text`.

The default TMB bar counts mutation records per sample. A mutations-per-megabase estimate needs an appropriate denominator.

Render the requested adjustments and ask whether to revise again or finish. If the user wants a side-by-side comparison, hold the data, gene selection, and sample order fixed and save separately named interactive previews. Once the user approves the result, share the final widget and updated plotting script, plus the tidy data and preprocessing script if reshaping was required. Provide a static export when requested.
