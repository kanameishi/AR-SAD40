
El modelo IND se basa en el modelo probabilístico de amenaza sísmica para el subcontinente indio desarrollado por Nath y Thingbaijam [@NathThingbaijam2012], posteriormente actualizado y traducido al formato OpenQuake en colaboración con Natural Resources Canada (versión v2012.2.0), según se documenta en el informe del modelo GEM [@GemInd2012]. El dominio del modelo se extiende aproximadamente desde $60.0^\circ$E hasta $100.8^\circ$E en longitud y desde $2.0^\circ$N hasta $40.0^\circ$N en latitud, cubriendo India, Bangladesh, Bután, Nepal, Pakistán, Myanmar y regiones circundantes del subcontinente indio. La magnitud mínima de terremoto ($M_{\min}$) adoptada para los cálculos de amenaza es 4.5 Mw en todas las áreas fuente; las dos mallas de sismicidad suavizada emplean umbrales $M_{\min}$ de 4.5 Mw y 5.5 Mw respectivamente.

El SSM IND comprende 443,197 fuentes sísmicas de dos tipos: 108 áreas fuente (`areaSource`) y 443,089 fuentes puntuales (`pointSource`). Estas fuentes abarcan cuatro tipos de región tectónica (TRT); la tabla siguiente proporciona el censo completo por TRT y tipo de fuente.

```{r}
#| include: true
#| label: tbl-ssm-ind-inventory
#| tbl-cap: "Source inventory by tectonic region type."

DT <- data.table::data.table(
  `Description` = c("Subduction Intraslab", "Subduction Interface", "Stable Continental Crust", "Active Shallow Crust", "Total"),
  `TRT` = c("SIS", "SIF", "SCC", "ASC", ""),
  `Area sources` = c("35", "27", "17", "29", "108"),
  `Point sources` = c("139,942", "123,748", "94,433", "84,966", "443,089"),
  `Total` = c("139,977", "123,775", "94,450", "84,995", "443,197")
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

El SSM se define mediante archivos XML de árbol lógico. El árbol lógico primario referencia tres archivos XML de modelo de fuentes y produce 27 ramas finales a partir del producto cartesiano de tres conjuntos de ramas ($3 \times 3 \times 3 = 27$). La estructura de conjuntos de ramas se describe en detalle en la sección Estructura del árbol lógico que sigue.

La caracterización de fuentes sísmicas sigue el marco clásico de PSHA delineado por Cornell [@Cornell1968] y formalizado bajo las directrices SSHAC [@SSHAC1997]. Las fuentes se delimitan a partir de evidencia geológica, geofísica y sismológica, con geometría y parametrización definidas en archivos XML de modelo de fuentes de OpenQuake. La implementación está disponible públicamente en el repositorio `nackerley/indian-subcontinent-psha` de GitHub [@NackerleyRepo].
