# Render de la memoria de cálculo

El ensamblador principal es:

```text
_master/calculation.review.es.qmd
```

Desde la raíz del repositorio, el HTML se regenera mediante:

```bash
qrt render _master/calculation.review.es.qmd --profile html
```

El render lee `calculation.json`, regenera `data/calculation/` y luego hidrata
el resumen, la aplicación numérica, las tablas y las figuras desde esos
productos. Para regenerar y comprobar sólo la corrida determinística:

```bash
Rscript scripts/R/runCalculationMemo.R
Rscript scripts/R/testCalculationData.R
```

El producto se publica localmente en:

```text
html/calculation.review.es/index.html
```

La memoria es actualmente un informe HTML autónomo y no utiliza el perfil
`book`.
