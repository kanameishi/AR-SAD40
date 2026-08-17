# Render de la memoria de cálculo

El ensamblador principal es:

```text
_master/calculation.review.es.qmd
```

Desde la raíz del repositorio, el HTML se regenera mediante:

```bash
qrt render _master/calculation.review.es.qmd --profile html
```

El render lee las 34 entradas del contrato `cover-case-2` en
`calculation.json`. La función pública `evaluateCoverCase()` las combina con
el perfil metodológico versionado, ejecuta el cálculo R y regenera
`data/calculation/`; la memoria hidrata tablas, figuras y texto desde esos
productos. Los factores normativos, identificadores, fuentes, estados y
magnitudes derivadas no son entradas editables del caso. Para regenerar y
comprobar la corrida determinística:

```bash
Rscript scripts/R/runCalculationMemo.R
Rscript scripts/R/testCoverCase.R
Rscript scripts/R/testCalculationLoading.R
```

El producto se publica localmente en:

```text
html/calculation.review.es/index.html
```

La memoria es actualmente un informe HTML autónomo y no utiliza el perfil
`book`.

La hoja de trabajo editable es
`scripts/wolfram/calculation.workbook.nb`; su único archivo de soporte es
`scripts/wolfram/calculationWorkbookSupport.wl`. La hoja no sobrescribe
`calculation.json`: después de adoptar una variante, sus valores deben copiarse
al JSON y ejecutarse nuevamente el cálculo antes del render.
