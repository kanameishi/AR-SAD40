
El modelo de profundidad sismogénica en el SSM IND refleja una estructura multicapa consistente con el ambiente tectónico asignado a cada zona fuente. Las fuentes de Corteza Superficial Activa (ASC) se limitan a los primeros 25 km, con profundidad sismogénica superior $z_{\text{upper}}$ = 0 km, profundidad sismogénica inferior $z_{\text{lower}}$ = 25 km y profundidad hipocentral media de 15 km. Las fuentes de Corteza Continental Estable (SCC) abarcan $z_{\text{upper}}$ = 0-25 km y $z_{\text{lower}}$ = 25-70 km, con profundidades hipocentrales medias de 15-25 km. Las fuentes de Interfaz de Subducción (SIF) presentan $z_{\text{upper}}$ = 0-70 km y $z_{\text{lower}}$ = 25-180 km, con profundidades hipocentrales medias de 15-70 km. Las fuentes de Subducción Intraplaca de Profundidad Intermedia (SIS) ocupan la zona más profunda, con $z_{\text{upper}}$ = 25-180 km, $z_{\text{lower}}$ = 70-300 km y profundidades hipocentrales medias de 25-180 km. Las distribuciones de profundidad hipocentral se especifican como distribuciones de valor único con probabilidad 1.0 para todas las áreas fuente; es decir, se asigna determinísticamente una única profundidad hipocentral representativa a cada zona.

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

La estructura de profundidad refleja una arquitectura de tres capas: las fuentes corticales superficiales (ASC y la capa superior SCC) se limitan a los primeros 25 km; las zonas de profundidad intermedia (SCC inferior y las porciones superiores de las envolventes de subducción) se extienden hasta 70 km; y las zonas profundas de subducción intraplaca alcanzan 300 km de profundidad. Los amplios rangos de profundidad para SIF y SIS reflejan la variabilidad global de geometrías de subducción incluidas en el dominio del modelo, desde zonas someras de contacto de interfaz hasta rupturas profundas dentro de la placa subducida.