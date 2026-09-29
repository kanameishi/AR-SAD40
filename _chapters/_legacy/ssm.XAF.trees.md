
The source-model logic tree encodes epistemic uncertainty by defining alternative realisations of the SSM. Each branch set addresses a specific source of uncertainty; branches within each set carry weights reflecting the relative credibility of each alternative. The primary logic tree contains five branch sets yielding $2 \times 3 \times 3 \times 3 \times 3 = 162$ end-branches [@Poggi2020].

Branch set 1 governs source-model selection and applies to all sources. It comprises two branches: `naf_faults` (weight 0.50), which incorporates `FaultSources.xml`, `GridMultiSources_C_L50_BG.xml`, and the collapsed WAF and SSA multi-point source files; and `naf_smooth` (weight 0.50), which replaces the explicit fault sources with a purely smoothed-seismicity representation using `GridMultiSources_C.xml` alongside the same collapsed regional files [@Poggi2020].

Branch sets 2 and 3 apply to the West African (WAF) group sources `MPS-1` through MPS-6. Branch set 2 (`mmax_waf`, type `maxMagGRRelative`) applies maximum-magnitude perturbations of $+0.2$, $0.0$, and $-0.2$ Mw with weights 0.25, 0.50, and 0.25 respectively. Branch set 3 (`bval_waf`, type `bGRRelative`) applies $b$-value perturbations of $+0.05$, $0.0$, and $-0.05$ with the same weight distribution [@Poggi2020].

Branch sets 4 and 5 apply to the North Africa (NAF) smoothed-seismicity sources SC_1 through SC_54. Branch set 4 (`naf_b`, type `bGRRelative`) applies $b$-value perturbations of $+0.05$, $0.0$, and $-0.05$ with weights 0.25, 0.50, and 0.25. Branch set 5 (`naf_m`, type `maxMagGRRelative`) applies $M_{\max}$ perturbations of $+0.2$, $0.0$, and $-0.2$ Mw with the same weights. The perturbation structure for the NAF group is structurally identical to that of the WAF group [@Poggi2020].

The following table summarises the complete logic-tree structure of `ssmLT_XAF.xml`.

```{r}
#| include: true
#| label: tbl-ssm-xaf-lt
#| tbl-cap: "Logic-tree structure of ssmLT_XAF.xml."

DT <- data.table::data.table(
  `Branch set` = c(1, 2, 3, 4, 5),
  `ID` = c("sourceModel", "mmax_waf", "bval_waf", "naf_b", "naf_m"),
  `Type` = c("Source model selection", "maxMagGRRelative", "bGRRelative", "bGRRelative", "maxMagGRRelative"),
  `Applies to` = c("All sources", "`MPS-1` to MPS-6", "`MPS-1` to MPS-6", "SC_1 to SC_54", "SC_1 to SC_54"),
  `Branches (perturbation / weight)` = c(
    "`naf_faults` (- / 0.50); `naf_smooth` (- / 0.50)",
    "+0.2 (0.25); 0.0 (0.50); -0.2 (0.25)",
    "+0.05 (0.25); 0.0 (0.50); -0.05 (0.25)",
    "+0.05 (0.25); 0.0 (0.50); -0.05 (0.25)",
    "+0.2 (0.25); 0.0 (0.50); -0.2 (0.25)"
  )
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
