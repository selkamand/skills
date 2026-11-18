# Data recipes for ggoncoplot

## Recognising tidy mutation records

| sample | gene | mutation_type | variant_id |
| --- | --- | --- | --- |
| S1 | TP53 | Missense_Mutation | v1 |
| S1 | TP53 | Nonsense_Mutation | v2 |
| S2 | KRAS | Missense_Mutation | v3 |

The two S1/TP53 rows represent distinct variants. A plot script can read a table of this shape directly. Map its existing column names in the single plotting call.

## Preprocessing a wide input

Use the recipe matching the input orientation in `tidy_data_for_oncoplot.R`. Read the user's raw data into `wide`. For both examples, `WT` is a confirmed non-mutation marker and each other cell contains one mutation classification.

**Genes in columns.** Select the gene columns explicitly so sample metadata such as treatment stays out of the mutation values.

```r
mutations <- tidyr::pivot_longer(
  wide,
  cols = c("TP53", "KRAS"),
  names_to = "gene",
  values_to = "mutation_type"
)
mutations <- dplyr::filter(mutations, mutation_type != "WT")
readr::write_tsv(mutations, "mutations.tsv")
```

**Samples in columns.** Keep the gene identifier and pivot the sample columns.

```r
mutations <- tidyr::pivot_longer(
  wide,
  cols = c("S1", "S2"),
  names_to = "sample",
  values_to = "mutation_type"
)
mutations <- dplyr::filter(mutations, mutation_type != "WT")
readr::write_tsv(mutations, "mutations.tsv")
```

The plotting script starts with `mutations <- read.delim("mutations.tsv")`. Check what blanks, zeroes, missing values, or delimiters mean before adapting either recipe. A cell summarising several variants can be split into mutation records only when its encoding distinguishes the events.
