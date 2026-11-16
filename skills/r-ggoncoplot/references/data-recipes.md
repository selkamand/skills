# Data recipes for ggoncoplot

`ggoncoplot()` needs one row per mutation, with sample and gene columns. Keep distinct variants as distinct rows, even when they share a sample and gene. The examples below use `sample`, `gene`, and `mutation_type`; replace these with the names in the user's data.

## Already long: preserve mutation records

```r
mutations <- data.frame(
  sample = c("S1", "S1", "S2"),
  gene = c("TP53", "TP53", "KRAS"),
  mutation_type = c("Missense_Mutation", "Nonsense_Mutation", "Missense_Mutation")
)

ggoncoplot::ggoncoplot(
  data = mutations,
  col_genes = "gene",
  col_samples = "sample",
  col_mutation_type = "mutation_type",
  topn = 10,
  interactive = FALSE
)
```

The two `S1`/`TP53` rows represent separate variant records. Confirm that they are genuinely distinct variants rather than duplicate annotations.

## Genes in columns: pivot only gene columns

This example assumes `WT` means no mutation and each non-`WT` cell describes **one** mutation. Confirm those meanings for the actual dataset before filtering.

```r
wide <- data.frame(
  sample = c("S1", "S2"),
  treatment = c("A", "B"),
  TP53 = c("Missense_Mutation", "WT"),
  KRAS = c("WT", "Nonsense_Mutation")
)

mutations <- tidyr::pivot_longer(
  wide,
  cols = c("TP53", "KRAS"),
  names_to = "gene",
  values_to = "mutation_type"
)
mutations <- dplyr::filter(mutations, mutation_type != "WT")
```

The `treatment` column is clinical metadata, so do not pivot it as a gene. If a cell contains several variants, establish the delimiter and variant encoding before splitting it into mutation rows.

## Samples in columns: pivot only sample columns

```r
wide <- data.frame(
  gene = c("TP53", "KRAS"),
  S1 = c("Missense_Mutation", "WT"),
  S2 = c("WT", "Nonsense_Mutation")
)

mutations <- tidyr::pivot_longer(
  wide,
  cols = c("S1", "S2"),
  names_to = "sample",
  values_to = "mutation_type"
)
mutations <- dplyr::filter(mutations, mutation_type != "WT")
```

## Check the result

```r
stopifnot(!anyNA(mutations$sample), !anyNA(mutations$gene))

# Inspect repeated sample–gene pairs. Keep genuine distinct variants.
multiple_hits <- dplyr::count(mutations, sample, gene, name = "n")
dplyr::filter(multiple_hits, n > 1)
```

Do not automatically drop duplicate looking rows: transcript annotations, repeated joins, and true variants need different handling. Check the variant identifier and source records first.
