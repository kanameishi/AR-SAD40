# Reglas locales de AR-SAD40

## Trabajo sin sobrecarga

- No leer routers globales, handoffs, planes históricos ni registros completos
  como paso de arranque.
- Consultar `dev/SoT/METHODOLOGY-PHASE2.md` sólo cuando la tarea afecte la
  metodología, la memoria o Wolfram; contiene únicamente el estado vigente.
- No crear archivos `.codex-task*`, handoffs, planes paralelos, auditorías en
  cascada ni subagentes salvo solicitud explícita del usuario.
- No repetir tests, renders o evaluaciones Wolfram que ya pasaron si no cambió
  su superficie relevante.

## Productos únicos

- Metodología: `_master/model.qmd`,
  `_index/methodology.review.ES.qmd` y `html/model/`.
- Memoria: libro multipágina `_master/report.qmd`, sus capítulos en
  `_index/` y `html/report/`.
- Wolfram: únicamente `scripts/wolfram/calculation.workbook.nb` y
  `scripts/wolfram/calculationWorkbookSupport.wl`.
- No recrear variantes `extension`, una segunda metodología ni notebooks
  alternativos.

## Implementación y edición

- R es la implementación de producción. Wolfram consume su frontera pública y
  no duplica las ecuaciones.
- La fuente humana de entradas es `calculation.json`.
- Renderizar HTML con `qrt`; no generar PDF salvo pedido explícito.
- La respuesta activa usa integración directa del revestimiento circular;
  solución cerrada y Fourier son controles, Schwartz--Einstein es contraste,
  AASHTO gobierna la chapa y AISI es sólo antecedente.
- Preservar cambios ajenos del worktree. No preparar, confirmar ni publicar
  cambios sin pedido explícito.

## Recálculo de escenarios

Cuando el usuario pida otro escenario, el agente debe hidratar
`calculation.json` con los datos solicitados y ejecutar los motores existentes.
En este flujo está prohibido modificar código bajo `scripts/R/`,
`scripts/setup/` o `scripts/wolfram/`, incluido el notebook. Tampoco se crean
scripts auxiliares, notebooks alternativos ni implementaciones de fórmulas.

- Leer el JSON vigente y cambiar sólo los campos que el usuario haya definido.
- Conservar nombres, estructura y unidades del contrato. Por ejemplo, la altura
  de la capa superior se carga en
  `inputs.ground.upperLayerHeightM`; el espesor remanente de chapa se carga en
  `inputs.steel.remainingBaseThicknessMm`.
- No inferir propiedades faltantes ni cambiar identificadores de perfiles,
  métodos o materiales para acomodar un dato. Marcar lo no resuelto `UNKNOWN`.
- Si está disponible `Rscript`, ejecutar una vez
  `Rscript scripts/R/runCalculationMemo.R` desde la raíz del repositorio.
- Si está disponible `qrt`, renderizar una vez con
  `qrt render _master/report.qmd --profile book` y revisar
  `html/report/index.html`.
- Si falta R o `qrt`, conservar el JSON hidratado y declarar exactamente qué
  ejecutable falta; no sustituir el motor.

Cuando el usuario pida revisar el escenario en Wolfram, el agente debe operar
el notebook vigente si dispone de un Wolfram Front End controlable: abrir
`scripts/wolfram/calculation.workbook.nb` con un kernel nuevo, cargar en la
sesión las asociaciones equivalentes al JSON, evaluar `EngineeringInputs` y
la única invocación `runCoverCalculation[EngineeringInputs]`, y revisar los
resultados solicitados. No guardar cambios en el notebook ni en su soporte. Si
el Front End no está disponible o no puede controlarse, no afirmar que Wolfram
fue ejecutado; el cálculo y el render R siguen siendo válidos por separado.

Publicar sólo por pedido explícito. Con el manifiesto vigente, el reporte se
publica mediante
`qrt deploy --manifest qrt.manifest.json --only report --prod`.

## Salvaguardas

- No inspeccionar `_ref`.
- Conservar PDF y textos fuente bajo `_ref/TITO-kb/sources/`.
- La prosa pública usa terminología de ingeniería y excluye narrativa interna
  de software o auditoría.
- No inventar datos faltantes; marcarlos `UNKNOWN` o mantener las hipótesis
  provisionales expresamente declaradas.
