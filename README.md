# AR-SAD40

## Productos renderizables

El repositorio mantiene tres productos renderizables:

| Producto | Master | Comando | Salida |
|---|---|---|---|
| Memoria técnica | `_master/calculation.review.es.qmd` | `qrt render _master/calculation.review.es.qmd --profile html` | `html/calculation.review.es/index.html` |
| Documento metodológico | `_master/methodology.review.es.qmd` | `qrt render _master/methodology.review.es.qmd --profile html` | `html/methodology.review.es/index.html` |
| Especificaciones técnicas | `_master/specifications.review.es.qmd` | `qrt render _master/specifications.review.es.qmd --profile html` | `html/specifications.review.es/index.html` |

Los tres son documentos HTML autónomos; no usan el perfil `book`. La memoria
técnica utiliza `NGR::buildSectionResultantsPlot()` para representar las
resultantes seccionales. Las especificaciones técnicas permanecen como
candidato de revisión; su render no implica aprobación técnica.
