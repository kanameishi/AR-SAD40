# Render de la memoria de cálculo

El ensamblador principal es:

```text
_master/calculation.review.es.qmd
```

Desde la raíz del repositorio, el HTML se regenera mediante:

```bash
qrt render _master/calculation.review.es.qmd --profile html
```

El producto se publica localmente en:

```text
html/calculation.review.es/index.html
```

La memoria es actualmente un informe HTML autónomo y no utiliza el perfil
`book`.
