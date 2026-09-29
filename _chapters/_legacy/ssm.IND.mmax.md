
Maximum magnitude ($M_{\max}$) defines the upper bound of the MFD for each source and is a critical parameter controlling the tail of the hazard curve. For all 108 area sources, base $M_{\max}$ values range from 6.0 to 9.4 Mw across the four tectonic region types, reflecting environments spanning from stable continental crust to subduction megathrust settings. The highest base $M_{\max}$ values correspond to Subduction Interface zones -- such as the Sumatra and Himalaya-Main Frontal Thrust systems -- where great earthquakes exceeding $M$ 8.5 are considered possible. $M_{\max}$ values are assigned per zone from the seismotectonic characterisation study by Nath and Thingbaijam [@NathThingbaijam2012] and are set as explicit parameters within the `truncGutenbergRichterMFD` specification.

Epistemic uncertainty in $M_{\max}$ is captured through `maxMagGRRelative` logic-tree branch set 2, which applies simultaneous perturbations of $\Delta = -0.3$, $0.0$, and $+0.3$ Mw to all sources (weights 0.32, 0.36, 0.32). For the smoothed-seismicity point-source grids, $M_{\max}$ is inherited from the parent areal zone parametrisation; point-source $M_{\max}$ values are not independently constrained and follow the same global perturbation scheme.

@tbl-ssm-ind-mmax summarises the base $M_{\max}$ ranges by tectonic region type together with the derived epistemic bounds.

```{r}
#| include: true
#| label: tbl-ssm-ind-mmax
#| tbl-cap: "Maximum magnitude characterisation by tectonic region type (base and epistemic bounds, area sources)."

DT <- data.table::data.table(
  `Tectonic region` = c("ASC", "SCC", "SIF", "SIS"),
  `Base Mmax (Mw)` = c("7.0-8.8", "6.0-8.2", "6.5-9.4", "6.5-8.6"),
  `Low (delta -0.3, Mw)` = c("6.7-8.5", "5.7-7.9", "6.2-9.1", "6.2-8.3"),
  `High (delta +0.3, Mw)` = c("7.3-9.1", "6.3-8.5", "6.8-9.7", "6.8-8.9"),
  `Derivation method` = c("truncGutenbergRichterMFD", "truncGutenbergRichterMFD", "truncGutenbergRichterMFD", "truncGutenbergRichterMFD")
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
