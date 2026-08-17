# Estado vigente — metodología, memoria de cálculo y Wolfram

Fecha de corte: 2026-08-16.

Este archivo contiene únicamente el estado necesario para continuar. Sustituye
el registro histórico de 7150 líneas, que no debe reconstruirse ni releerse.
Las fuentes técnicas preservadas y Git conservan la trazabilidad histórica.

## Objetivo aceptado

El proyecto entrega exactamente dos productos públicos:

1. una metodología integrada para el análisis del revestimiento circular; y
2. una memoria de cálculo del caso determinístico.

Wolfram es una memoria interna editable. R es la única implementación de
producción. No crear una segunda metodología, un segundo notebook, una rama
`extension`, un optimizador de armadura ni un nuevo handoff.

## Productos vigentes

### Metodología única

- master: `_master/methodology.review.es.qmd`
- índice: `_index/methodology.review.ES.qmd`
- capítulos: `TITO/kb/paper-candidate/chapters/methodology.*.es.md`
- HTML: `html/methodology.review.es/index.html`
- SHA-256 master:
  `9b4f4e69386f8b44415d1958652d177d93db0b0a00ce07fc2a49bceac2e1a292`
- SHA-256 índice:
  `d7049b390e7c67b8e42abaeebabd5fbf30b198a422d2cc964e1ac57c9d861699`
- SHA-256 HTML:
  `836b3a3f052b7232c471386dac0114954026c141f250b928f750e551fe1b8f12`
- último render: `qrt render _master/methodology.review.es.qmd --profile html`,
  código 0.

### Memoria de cálculo

- master: `_master/calculation.review.es.qmd`
- índice: `_index/calculation.review.ES.qmd`
- HTML: `html/calculation.review.es/index.html`
- SHA-256 HTML vigente:
  `56fb8b01845ef316e2ef2b7a9a35ea6fa0538205bbf7182e969eb104819b1114`
- último render: `qrt render _master/calculation.review.es.qmd --profile html`,
  código 0.
- no generar PDF salvo instrucción explícita del usuario.

### Wolfram

La superficie vigente contiene exactamente dos archivos:

- `scripts/wolfram/calculation.workbook.nb`
  (`299597e3c87879f3eb496c020afff85f37b27ca72e73e12980f009692de1d72e`);
- `scripts/wolfram/calculationWorkbookSupport.wl`
  (`220632b99725cf1e50b5ee6b81ac6c373766f7dc5a5fefd08378dd48c12479ec`).

El notebook expone entradas editables, ejecuta una sola evaluación R y muestra
los resultados y los dominios P--M. No volver a ejecutar evaluaciones headless
automáticas: una inicialización anterior de RLink quedó colgada. El usuario
puede abrir y evaluar el notebook de forma interactiva.

El notebook quedó cargado como tanteo con `t = 0.10 m`, Ø10/150 y
`clearCoverRatio = 0.15`; `calculation.json` conserva el caso publicado de
0.15 m y Ø6/150. El tanteo proporciona 10.47 cm2/m totales, satisface el mínimo
histórico y no satisface P--M (`U_max = 4.212845`). La tolerancia de convergencia
del barrido gráfico discreto es 0.015; el control resistente configurado
conserva su tolerancia 0.01.

## Modelo de producción

- La respuesta vigente se obtiene mediante integración directa del
  revestimiento circular en R.
- Las salidas son `N_theta(theta)`, `M_theta(theta)` y `Q_theta(theta)`, sus
  extremos y envolventes.
- La solución cerrada y Fourier son controles independientes.
- Schwartz--Einstein se conserva sólo como contraste; no gobierna las demandas.
- La chapa se comprueba por la rama AASHTO aplicable a conductos corrugados.
- AISI es sólo antecedente y no participa del dictamen.
- El hormigón simple y el hormigón armado tienen espesores y rigideces propias.
- La rama armada usa dominios seccionales P--M por compatibilidad y equilibrio.
- El problema es plano y no introduce variación longitudinal de cargas.

## Entradas editables

La fuente humana es `calculation.json`. Las claves principales son:

- tapada: `inputs.cover.coverCrownM`;
- peso unitario efectivo: `inputs.ground.effectiveUnitWeightKnPerM3`;
- sobrecarga: `inputs.ground.effectiveSurchargeKPa`;
- módulo y Poisson del suelo: `inputs.ground.modulusKPa` y `poisson`;
- modelo de K0: `inputs.ground.k0ModelID`;
- ángulo de fricción efectivo: `inputs.ground.frictionAngleDeg`;
- OCR: `inputs.ground.ocr`;
- presión hidráulica neta: `inputs.ground.waterPressureDifferenceKPa`;
- espesor remanente de chapa: `inputs.steel.remainingBaseThicknessMm`;
- hormigón simple: `inputs.plainConcrete.thicknessM` y
  `compressiveStrengthMPa`;
- hormigón armado: `inputs.reinforcedConcrete.thicknessM`,
  `compressiveStrengthMPa`, `barDiameterMm`, `barSpacingMm` y
  `clearCoverRatio`.

El espesor armado vigente es 0.15 m. El recubrimiento se calcula como
`clearCoverRatio * thicknessM`; el valor provisional 0.15 produce 22.5 mm
(2.25 cm). Es editable y no se presenta como conformidad normativa definitiva.

## Hipótesis geotécnicas provisionales

Hasta que el usuario suministre los datos definitivos:

- `phi' = 30 grados`;
- `OCR = 1`;
- sin presencia de agua;
- `gamma' = 19 kN/m3`.

Con esas entradas resulta `K0 = 0.5`; no es una constante clavada. Cambia al
modificar el ángulo de fricción, OCR o la rama de K0.

## Armadura y diagrama P--M

La malla configurada es Ø6 cada 150 mm, simétrica en ambas caras:

- armadura total provista: 3.77 cm2/m;
- mínimo histórico ACI 318.2-14: 2.70 cm2/m;
- el mínimo se satisface;
- utilización P--M máxima: 5.7579;
- la sección configurada no satisface P--M.

La figura muestra cinco dominios físicos, no iteraciones. Cada curva reúne los
estados resistentes de una cuantía y las cuatro marcas son demandas físicas.
La familia discreta vigente es:

| Armadura total (cm2/m) | Utilización máxima | Estado P--M |
|---:|---:|---|
| 2.70 | 7.8938 | no satisface |
| 3.77 | 5.7579 | no satisface |
| 15.00 | 1.7712 | no satisface |
| 30.00 | 0.9662 | satisface |
| 45.00 | 0.66985 | satisface |

No implementar búsqueda de cuantía óptima. El usuario puede elegir otra malla,
regenerar y observar de nuevo la familia P--M. 3000 mm2/m equivalen a
30 cm2/m, no a 3 cm2/m.

## Convenciones de presentación

- armaduras en cm2/m;
- mm, mm2 y kN sin decimales en superficies públicas;
- conservar precisión completa en cálculo y CSV;
- las curvas P--M pueden conservar la precisión necesaria, con ejes legibles;
- no describir los puntos de una curva resistente como iteraciones.

## Regeneración mínima

Cuando cambie `calculation.json`:

1. ejecutar una vez `Rscript scripts/R/runCalculationMemo.R`;
2. si termina correctamente, renderizar una vez
   `qrt render _master/calculation.review.es.qmd --profile html`;
3. abrir el notebook Wolfram y evaluarlo interactivamente si se desea comparar
   el nuevo caso.

No iniciar auditorías, agentes, optimizaciones ni ciclos de render adicionales
sin una solicitud explícita. Ante un fallo, diagnosticar el fallo observado y
no repetir a ciegas.

## Limpieza completada

Se retiraron:

- `.codex-task.md`, `.codex-task-wolfram-bundle.md` y `dev/handoff/`;
- `dev/chapa/HANDOFF-chapa-76x25-espesor-2026-08-13.md`;
- notebooks y scripts Wolfram duplicados;
- los planes históricos bajo `TITO/`;
- `_master/methodology.extension.review.es.qmd`;
- `_index/methodology.extension.review.ES.qmd`;
- `html/methodology.extension.review.es/`;
- `TITO/kb/review/`;
- `TITO/kb/metodologia-anillo-enterrado.md`;
- ledgers, informe S1 y planes ACI/Wolfram ya ejecutados que dependían de esas
  variantes.

Los capítulos todavía usados fueron trasladados al único árbol metodológico
vigente. Los PDF y textos fuente se conservaron. No inspeccionar `_ref`.

`AGENTS.md` fue reducido a reglas locales esenciales y ya no obliga a leer el
router global ni registros históricos al comenzar cada tarea.

El registro histórico completo previo a esta compactación quedó respaldado en
`/private/tmp/ar-sad40-methodology-retirement.KEsfSo/fossils/METHODOLOGY-PHASE2.full.md`,
SHA-256 `752ebff5fc70f0d19f65651e3d41144438931e1bb38f02d80e8a7c9d806b25dc`.

## Estado de Git y autoridad

- Rama observada durante el cierre: `main`.
- HEAD inicial del cierre:
  `33ce40bdcf7c7e6ec027d44e1371eaf656a2f07e`.
- El worktree contiene cambios amplios del usuario y del trabajo anterior;
  preservarlos.
- No hay cambios preparados por este cierre, no se creó commit y no se publicó.
- La aceptación técnica y editorial final corresponde al usuario.
