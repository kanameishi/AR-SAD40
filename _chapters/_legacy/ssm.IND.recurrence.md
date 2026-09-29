
All 108 area sources employ the truncated Gutenberg-Richter MFD (`truncGutenbergRichterMFD`), parameterised by an $a$-value and a $b$-value with explicit $M_{\min}$ and $M_{\max}$ bounds. The minimum magnitude is 4.5 Mw for area sources in Active Shallow Crust, Stable Continental Crust, and Subduction Interface settings; Subduction Intraslab sources encompass a range of $M_{\min}$ values from 4.5 to 7.5 Mw reflecting the variable depth of deep slab zones. Epistemic uncertainty in the $b$-value is captured through logic-tree branch set 3, which applies simultaneous relative perturbations of $-0.1$, $0.0$, and $+0.1$ (weights 0.32, 0.36, 0.32); $M_{\max}$ uncertainty treatment is addressed in the Maximum Magnitude section below. The two smoothed-seismicity point-source grids inherit the same Gutenberg-Richter parametrisation from the parent areal zones, distributed over a regular spatial grid; individual grid nodes carry spatially redistributed $a$-values derived from parent zone rates rather than independently fitted catalogue statistics [@NathThingbaijam2012].

@tbl-ssm-ind-recurrence summarises the recurrence parameters for the 108 area sources grouped by tectonic region type. The $M_{\max}$ values are base (central) estimates prior to application of the $M_{\max}$ logic-tree perturbation.

```{r}
#| include: true
#| label: tbl-ssm-ind-recurrence
#| tbl-cap: "Earthquake recurrence parameters by tectonic region type (108 area sources, base values)."

DT <- data.table::data.table(
  `Tectonic region` = c("Active Shallow Crust (ASC)", "Stable Continental Crust (SCC)", "Subduction Interface (SIF)", "Subduction Intraslab (SIS)"),
  `MFD type` = c("truncGR", "truncGR", "truncGR", "truncGR"),
  `a-value range` = c("2.73-7.08", "1.58-4.84", "3.12-5.40", "3.22-7.33"),
  `b-value range` = c("0.72-1.37", "0.63-1.19", "0.72-1.24", "0.80-1.57"),
  `Mmin (Mw)` = c("4.5", "4.5", "4.5", "4.5-7.5"),
  `Mmax range (Mw)` = c("7.0-8.8", "6.0-8.2", "6.5-9.4", "6.5-8.6"),
  `n` = c("29", "17", "27", "35")
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
