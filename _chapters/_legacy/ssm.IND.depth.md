
The seismogenic depth model in the IND SSM reflects a multi-layer structure consistent with the tectonic environment assigned to each source zone. Active Shallow Crust (ASC) sources are confined to the upper 25 km, with upper seismogenic depth $z_{\text{upper}}$ = 0 km, lower seismogenic depth $z_{\text{lower}}$ = 25 km, and mean hypocentral depth 15 km. Stable Continental Crust (SCC) sources span $z_{\text{upper}}$ = 0-25 km and $z_{\text{lower}}$ = 25-70 km, with mean hypocentral depths of 15-25 km. Subduction Interface (SIF) sources exhibit $z_{\text{upper}}$ = 0-70 km and $z_{\text{lower}}$ = 25-180 km, with mean hypocentral depths of 15-70 km. Subduction Intraslab (SIS) sources occupy the deepest zone, with $z_{\text{upper}}$ = 25-180 km, $z_{\text{lower}}$ = 70-300 km, and mean hypocentral depths of 25-180 km. Hypocentral depth distributions are specified as single-value distributions with probability 1.0 for all area sources; that is, a single representative hypocentral depth is assigned deterministically to each zone.

```{r}
#| include: true
#| label: tbl-ssm-ind-depth
#| tbl-cap: "Seismogenic depth parameters by tectonic region type (area sources)."

DT <- data.table::data.table(
  `Tectonic region` = c("Active Shallow Crust (ASC)", "Stable Continental Crust (SCC)", "Subduction Interface (SIF)", "Subduction Intraslab (SIS)"),
  `z_upper (km)` = c("0", "0-25", "0-70", "25-180"),
  `z_lower (km)` = c("25", "25-70", "25-180", "70-300"),
  `Mean hypocentral depth (km)` = c("15", "15-25", "15-70", "25-180")
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

The depth structure reflects a three-layer architecture: shallow crustal sources (ASC and the upper SCC layer) are confined to the uppermost 25 km; intermediate-depth zones (lower SCC and the upper portions of the subduction envelopes) extend to 70 km; and deep subduction intraslab zones reach 300 km depth. The wide depth ranges for SIF and SIS reflect the global variability of subduction geometries included in the model domain, from shallow interface contact zones to deep slab ruptures.
