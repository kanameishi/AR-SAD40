# AR-SAD40

## Productos renderizables

El repositorio mantiene dos productos públicos:

| Producto | Master | Comando | Salida |
|---|---|---|---|
| Memoria técnica | `_master/calculation.review.es.qmd` | `qrt render _master/calculation.review.es.qmd --profile html` | `html/calculation.review.es/index.html` |
| Documento metodológico | `_master/methodology.review.es.qmd` | `qrt render _master/methodology.review.es.qmd --profile html` | `html/methodology.review.es/index.html` |

Ambos son informes HTML autónomos; no usan el perfil `book`.

La memoria técnica requiere `NGR >= 0.3.10`, porque sus tres diagramas de
resultantes utilizan `NGR::buildSectionResultantsPlot()`. Puede comprobarse la
versión visible para R mediante:

```bash
Rscript -e 'packageVersion("NGR")'
```

Mientras la versión `0.3.10` permanezca en el checkout de desarrollo, puede
usarse sin reemplazar la instalación general:

```bash
NGR_LIB=/private/tmp/ngr-ar-sad40
mkdir -p "$NGR_LIB"
R CMD INSTALL --no-docs --no-help --no-html --no-demo --no-multiarch -l "$NGR_LIB" /Users/averrik/Cloud/github/libraries/NGR
R_LIBS_USER="$NGR_LIB" qrt render _master/calculation.review.es.qmd --profile html
```
