
Seismogenic depth parameters define the vertical extent within which earthquake ruptures are generated. Upper and lower seismogenic depths bound the rupture zone; hypocentral depth distributions, where specified, control the depth placement of point-source ruptures [@Poggi2020].

```{r}
#| include: true
#| label: tbl-ssm-xaf-depth
#| tbl-cap: "Seismogenic depth parameters by source type."

DT <- data.table::data.table(
  `Source type` = c("Simple fault sources", "Multi-point sources (WAF)", "Multi-point sources (SSA)"),
  `z_upper (km)` = c("0.0", "0.0", "0.0"),
  `z_lower (km)` = c("1.7-25.0", "45.0", "40.0"),
  `Hypocentral depth distribution` = c(
    "Not specified (rupture geometry from fault model)",
    "5 km (0.267), 15 km (0.267), 25 km (0.333), 35 km (0.133)",
    "Depth-weighted discrete distribution; mean 18.0-19.5 km"
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

Simple fault sources share an upper seismogenic depth of 0.0 km; their lower seismogenic depth ranges from 1.7 km for very shallow structures to 25.0 km for crustal-scale faults. Multi-point sources are assigned a deeper seismogenic base: WAF collapsed sources extend to 45.0 km and SSA collapsed sources to 40.0 km, reflecting the broader depth distribution of smoothed background seismicity across the model domain [@Poggi2020].

For the WAF multi-point sources (`MPS-1` through MPS-6), hypocentral depth distributions are explicitly defined with a mean hypocentral depth of 18.3 km, based on a four-level discrete distribution: 5 km (weight 0.267), 15 km (weight 0.267), 25 km (weight 0.333), and 35 km (weight 0.133). SSA collapsed sources carry comparable mean hypocentral depths of approximately 18.0 to 19.5 km depending on the source sub-group [@Poggi2020].
