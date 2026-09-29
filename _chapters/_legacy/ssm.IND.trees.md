
The source-model logic tree encodes epistemic uncertainty through three branch sets, collectively producing $3 \times 3 \times 3 = 27$ end-branches. Each branch set addresses a distinct type of epistemic uncertainty; branches within each set carry weights reflecting the relative credibility of each alternative [@GemInd2012].

Branch set 1 addresses source-model selection, offering three alternative source-model representations of the regional seismicity. Branch `b1m1` selects the 108-zone areal source model; branches `b1m2` and `b1m3` select spatially smoothed point-source grids with $M_{\min}$ thresholds of 4.5 Mw and 5.5 Mw respectively.

```{r}
#| include: true
#| label: tbl-ssm-ind-bs1
#| tbl-cap: "Branch set 1: source-model selection."

DT <- data.table::data.table(
  `Branch` = c("b1m1", "b1m2", "b1m3"),
  `Model file` = c("nt2012_areal_source_model_v1.xml", "nt2012_smoothed_source_model_v1_mmin4.5.xml", "nt2012_smoothed_source_model_v1_mmin5.5.xml"),
  `Weight` = c("0.40", "0.27", "0.33")
)

TBL <- DT |> buildTable(
  library = "flextable",
  align.body = "center",
  font.size.body = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |>
  flextable::set_table_properties(layout = "autofit")
TBL
```

Branch set 2 applies simultaneous relative perturbations to the base $M_{\max}$ of all sources. The symmetric flanking branches ($\pm 0.3$ Mw) each carry weight 0.32; the unperturbed central branch carries the higher weight of 0.36, reflecting greater credibility attributed to the nominal parameter estimate.

```{r}
#| include: true
#| label: tbl-ssm-ind-bs2
#| tbl-cap: "Branch set 2: maximum magnitude perturbation."

DT <- data.table::data.table(
  `Branch` = c("b2m1", "b2m2", "b2m3"),
  `Perturbation (Mw)` = c("-0.3", "0.0", "+0.3"),
  `Weight` = c("0.32", "0.36", "0.32")
)

TBL <- DT |> buildTable(
  library = "flextable",
  align.body = "center",
  font.size.body = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |>
  flextable::set_table_properties(layout = "autofit")
TBL
```

Branch set 3 applies simultaneous relative perturbations to the Gutenberg-Richter $b$-value of all sources, with the same symmetric weight structure as branch set 2.

```{r}
#| include: true
#| label: tbl-ssm-ind-bs3
#| tbl-cap: "Branch set 3: b-value perturbation."

DT <- data.table::data.table(
  `Branch` = c("b3m1", "b3m2", "b3m3"),
  `Perturbation` = c("-0.1", "0.0", "+0.1"),
  `Weight` = c("0.32", "0.36", "0.32")
)

TBL <- DT |> buildTable(
  library = "flextable",
  align.body = "center",
  font.size.body = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |>
  flextable::set_table_properties(layout = "autofit")
TBL
```

The combined weights within each branch set sum to unity: source-model branches sum to $0.40 + 0.27 + 0.33 = 1.00$; both perturbation branch sets sum to $0.32 + 0.36 + 0.32 = 1.00$.
