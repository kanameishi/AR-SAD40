
Los parámetros de profundidad sismogénica definen la extensión vertical dentro de la cual se generan rupturas de terremotos. Las profundidades sismogénicas superior e inferior delimitan la zona de ruptura; las distribuciones de profundidad hipocentral, cuando se especifican, controlan la ubicación en profundidad de las rupturas de fuentes puntuales [@Poggi2020].

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

Las fuentes de falla simple comparten una profundidad sismogénica superior de 0.0 km; su profundidad sismogénica inferior varía de 1.7 km para estructuras muy someras a 25.0 km para fallas de escala cortical. A las fuentes multipunto se les asigna una base sismogénica más profunda: las fuentes WAF colapsadas se extienden hasta 45.0 km y las fuentes SSA colapsadas hasta 40.0 km, reflejando la distribución de profundidad más amplia de la sismicidad de fondo suavizada en el dominio del modelo [@Poggi2020].

Para las fuentes multipunto WAF (`MPS-1` a MPS-6), las distribuciones de profundidad hipocentral se definen explícitamente con una profundidad hipocentral media de 18.3 km, basada en una distribución discreta de cuatro niveles: 5 km (peso 0.267), 15 km (peso 0.267), 25 km (peso 0.333) y 35 km (peso 0.133). Las fuentes SSA colapsadas tienen asignadas profundidades hipocentrales medias comparables de aproximadamente 18.0 a 19.5 km según el subgrupo de fuentes [@Poggi2020].