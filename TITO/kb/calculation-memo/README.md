# Render de la memoria de cálculo

El ensamblador principal es:

```text
_master/calculation.review.es.qmd
```

Desde la raíz del repositorio, con `NGR >= 0.3.10` instalado, el HTML se
regenera mediante:

```bash
qrt render _master/calculation.review.es.qmd --profile html
```

El producto se publica localmente en:

```text
html/calculation.review.es/index.html
```

La memoria es actualmente un informe HTML autónomo; no utiliza el perfil
`book`. El archivo `_master/calculation.resultants.review.es.qmd` corresponde
al artefacto histórico de comparación gráfica y no es el master del reporte.

Mientras `NGR 0.3.10` permanezca sólo en el checkout de desarrollo, puede
renderizarse sin modificar la biblioteca R general:

```bash
NGR_LIB=/private/tmp/ngr-ar-sad40
mkdir -p "$NGR_LIB"
R CMD INSTALL --no-docs --no-help --no-html --no-demo --no-multiarch -l "$NGR_LIB" /Users/averrik/Cloud/github/libraries/NGR
R_LIBS_USER="$NGR_LIB" qrt render _master/calculation.review.es.qmd --profile html
```
