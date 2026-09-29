
The earthquake recurrence parameters quantify the expected rate and size distribution of future earthquakes on each seismic source. Recurrence is described by a magnitude-frequency distribution (MFD) whose type and parameters are specified per source in the model. The three source groups in the XAF model correspond to three distinct MFD types, each carrying a different parameterisation approach [@Poggi2020].

```{r}
#| include: true
#| label: tbl-ssm-xaf-recurrence
#| tbl-cap: "Earthquake recurrence parameters by source group."

DT <- data.table::data.table(
  `Source group` = c("Simple fault sources", "MPS/SC (truncated GR)", "BG (arbitrary MFD)"),
  `MFD type` = c("incrementalMFD", "truncGutenbergRichterMFD", "arbitraryMFD"),
  `a-value range` = c("-", "3.13-5.45", "-"),
  `b-value range` = c("-", "0.93-1.16", "-"),
  `Mmin (Mw)` = c("6.05", "4.0-4.5", "-"),
  `Mmax range (Mw)` = c("6.05-7.75", "5.25-9.00", "5.25-9.00"),
  `n` = c(115, 86, 54)
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

For fault sources, activity rates are encoded as discrete incremental occurrence rates per 0.1-Mw magnitude bin starting at $M_{\min} = 6.05$ Mw; no parametric $a$- or $b$-values are defined. Maximum magnitudes range from 6.05 to 7.75 Mw across the 115 fault sources [@Poggi2020].

For the 86 multi-point sources with truncated Gutenberg-Richter MFDs, earthquake rates are parameterised by an $a$-value (range 3.13 to 5.45) and $b$-value (range 0.93 to 1.16) subject to explicit $M_{\min}$ and $M_{\max}$ bounds. Epistemic uncertainty in $b$-value is captured through logic-tree branch sets 3 and 4, applying relative perturbations of $\pm 0.05$ to the WAF (MPS group) and NAF (SC group) source groups respectively [@Poggi2020].

For the 54 background sources with arbitrary MFDs, occurrence rates are specified at arbitrary magnitude points, providing a non-parametric representation of seismicity that does not assume a Gutenberg-Richter relationship. No $a$- or $b$-values are defined for these sources [@Poggi2020].
