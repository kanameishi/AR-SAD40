# AR-SAD40

## Productos vigentes

El proyecto mantiene dos productos de revisión:

- la metodología integrada, ensamblada desde
  `_master/methodology.review.es.qmd` y renderizada en
  `html/methodology.review.es/index.html`; y
- la memoria de cálculo del escenario, renderizada como libro multipágina
  desde `_master/report.es.qmd` en `html/report.es/index.html`.

## Hoja Wolfram

La memoria interna editable está formada únicamente por
`scripts/wolfram/calculation.workbook.nb` y su soporte
`scripts/wolfram/calculationWorkbookSupport.wl`. El notebook permite modificar
los datos del caso, ejecutar una sola evaluación R y comparar los dominios
$P$--$M$ para varias cuantías de armadura. Los valores aceptados se copian a
`calculation.json` antes de regenerar la memoria HTML.
