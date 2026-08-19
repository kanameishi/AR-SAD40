# Handoff de cierre: notación, tablas y Wolfram

Fecha: 2026-08-19  
Rama observada: `dev`  
HEAD observado: `85aa060`  
Estado observado: 927 entradas en `git status --porcelain`; preservar todo
cambio ajeno.

Este handoff se crea por pedido explícito del usuario. Es el documento de
continuidad para este paquete de trabajo. No reemplaza `AGENTS.md`, el router
global ni los contratos seleccionados por la tarea.

## Continuidad activa Tier 0

### objective

- `OBJ-001 | OPEN |` Dejar `_master/report.qmd`, `_master/model.qmd` y el
  único notebook Wolfram con un contrato inequívoco de interfaz, proyección
  tangencial, comprobaciones y estados; preservar los resultados del motor R;
  entregar al usuario las fuentes listas para que él evalúe Wolfram y opere
  QRT.

### rulings

- `R-001 | 2026-08-19 |` `S` y `NS` significan exclusivamente Slip y No Slip.
- `R-002 | 2026-08-19 |` Las leyendas “Slip” y “No Slip” van en captions o
  leyendas gráficas, nunca repetidas en filas de tablas.
- `R-003 | 2026-08-19 |` El estado binario se publica con tokens ASCII
  `OK` y `FAIL`; `N/A` se reserva a una comprobación no evaluada.
- `R-004 | 2026-08-19 |` El control de proyección tangencial se representa
  como $\lambda_t$; `alpha-0`, `alpha-1` y Alpha público quedan prohibidos.
- `R-005 | 2026-08-19 |` CANDE no forma parte del motor ni del producto
  vigente.
- `R-006 | 2026-08-19 |` R es la única autoridad numérica y Wolfram consume
  su frontera; no se duplican ecuaciones.
- `R-007 | 2026-08-19 |` El usuario se reserva evaluación interactiva de
  Wolfram, render y publicación QRT.

### verdicts

- `C-001 | DONE |` CANDE retirado de las rutas activas alcanzadas; retiro sin
  cambio de máximos $N$, $M$, $Q$.
- `C-002 | DONE |` IDs de escenarios públicos cambiados de
  `alpha-1`/`alpha-0` a `slip`/`no-slip`.
- `C-003 | DONE |` Notación pública de proyección cambiada de $\alpha$ a
  $\lambda_t$.
- `C-004 | DONE |` Builders activos de interfaz emiten filas `S`/`NS`.
- `C-005 | DONE |` Builders activos de estados emiten `OK`/`FAIL` y `N/A`
  cuando corresponde.
- `C-006 | DONE |` Comparación Schwartz--Einstein corregida de casos fósiles
  `D`/`S` a `S`/`NS`.
- `C-007 | DONE |` Vista Wolfram de armaduras corregida de estados `S`/`NS`
  a `OK`/`FAIL` y encabezados `E_PM`, `E_V`, `E_r*`.
- `C-008 | DONE |` Handoff integral persistido por pedido del usuario.

### runs

- `RUN-001 | PASS 2026-08-19 |` `Rscript scripts/R/testRingMethod.R`, antes
  del cambio puramente editorial `OK`/`FAIL`.
- `RUN-002 | PASS 2026-08-19 |` `Rscript scripts/R/testCoverCalculationData.R`,
  antes del cambio puramente editorial `OK`/`FAIL`.
- `RUN-003 | PASS 2026-08-19 |` `Rscript scripts/R/runCalculationMemo.R`, antes
  del cambio puramente editorial `OK`/`FAIL`.
- `RUN-004 | PASS 2026-08-19 |` `Rscript scripts/R/testCalculationFigures.R`,
  antes del cambio puramente editorial `OK`/`FAIL`.
- `RUN-005 | PASS 2026-08-19 |` Construcción directa de las tablas activas de
  chapa, hormigón simple, familias P--M y comparación clásica. Las interfaces
  fueron sólo `S`/`NS`; los estados, sólo `OK`/`FAIL`; los casos `SE`, sólo
  `S`/`NS`.

### no-replay

- `NR-001 |` No repetir las auditorías del modelo híbrido, Fourier,
  Schwartz--Einstein, ACI o AASHTO sin una modificación de su superficie.
- `NR-002 |` No repetir el origen histórico de CANDE y `alpha-*`; ya está
  establecido que fueron benchmark compartido e IDs de escenarios, no método
  oficial.
- `NR-003 |` No ejecutar QRT ni operar sitios.
- `NR-004 |` No evaluar Wolfram headless.
- `NR-005 |` No usar `html/report/` como evidencia hasta que el usuario lo
  regenere.

### next

- `C-009 | DONE |` Comprobar los datasets de las tablas activas: interfaz sólo
  `S`/`NS`, estado sólo `OK`/`FAIL`/`N/A`, sin prosa repetida en filas.
- `C-010 | DONE |` Barrido textual focal de masters activos, capítulos,
  captions, builders y support Wolfram para CANDE, `alpha-*`, `D/S` fósil y
  estados residuales.
- `C-011 | DONE |` Revisar el diff focal de las correcciones; preservar toda
  modificación ajena.
- `C-012 | DONE |` Ejecutar una sola verificación R proporcional a las tablas
  modificadas; no regenerar cálculos si no cambió la entrada o el motor.
- `C-013 | USER |` Evaluar el único notebook Wolfram en un kernel nuevo.
- `C-014 | USER |` Renderizar y publicar memoria/metodología mediante QRT.
- `C-015 | OPEN |` Entregar al usuario estado exacto de fuentes, resultados,
  archivos y dependencias de `C-013`/`C-014`.

## Por qué se perdió el plan

El plan detallado se desarrolló en conversación, pero nunca se persistió como
un documento único. `dev/SoT/METHODOLOGY-PHASE2.md` guardó resultados y una
síntesis del producto, no las decisiones de notación ni las medidas de cierre.
Después de la compactación se reconstruyó el trabajo desde esa síntesis
insuficiente y se confundió una corrección puntual de tablas con el plan
completo.

`dev/plan/motor-r/checkpoint.md` tampoco es este plan: es una auditoría y un
plan de mantenimiento del motor R, contiene estado histórico parcialmente
superado y no debe usarse para reabrir auditorías ya cerradas.

La auditoría paralela de `/Users/averrik/github/agents/` concluyó que la
salvaguarda Tier 0 ya existía y falló su ejecución: cada compromiso material
debía persistirse con identidad, estado y evidencia. La prohibición local de
handoffs/planes paralelos introdujo una ambigüedad práctica, pero la nota Tier
0 no era un handoff y debía haberse mantenido. Este archivo implementa ahora
los seis slots requeridos. El informe completo de sólo lectura quedó en
`/private/tmp/ar-sad40-github-agents-compaction-audit.md`; no se modificó el
router global.

## Problema informado por el usuario

El producto activo presenta deriva semántica y editorial entre el reporte, la
metodología, los builders R y Wolfram:

1. `CANDE` apareció en código y texto aunque no forma parte del método del
   proyecto.
2. Los identificadores `alpha-1` y `alpha-0` mezclaron dos conceptos:
   condición de interfaz y proyección tangencial de una carga prescrita.
3. El símbolo `\alpha` quedó sobrecargado y se confundió con casos de cálculo.
4. `S` y `NS` deben identificar exclusivamente las interfaces Slip y No Slip
   en las filas de tablas; la leyenda larga pertenece al caption.
5. Algunas tablas y la vista Wolfram reutilizan `S`/`NS` para “satisface/no
   satisface”, lo cual colisiona con Slip/No Slip.
6. Las tablas de chapa, hormigón simple y hormigón armado usan idiomas
   diferentes: prosa en encabezados o celdas, códigos distintos y dictámenes
   difíciles de comparar.
7. La comparación de métodos conserva códigos fósiles `D`/`S` para los casos
   de Schwartz--Einstein, aunque el contrato público vigente es `S`/`NS`.
8. El HTML existente fue generado antes de varias correcciones y todavía
   muestra “Deslizamiento libre”, “Sin deslizamiento”, “Satisface” y “No
   satisface” en filas. No demuestra el estado de las fuentes actuales.
9. La misma nomenclatura debe llegar a la única planilla Wolfram sin duplicar
   ecuaciones ni alterar los resultados del motor R.

El problema no es recalcular la estructura ni volver a auditar la teoría. Es
cerrar un contrato de presentación inequívoco y aplicarlo de extremo a extremo
sin cambiar las demandas ni las resistencias.

## Diagnóstico

Se colapsaron cuatro dominios conceptuales que deben permanecer separados:

| Dominio | Significado | Representación pública |
|---|---|---|
| Interfaz suelo--revestimiento | límite Slip o No Slip | columna $I$: `S`, `NS` |
| Proyección tangencial de carga prescrita | multiplicador numérico de $p_t^*$ | $\lambda_t\in[0,1]$ |
| Estado de una comprobación | resultado binario o no evaluado | columna $E$: `OK`, `FAIL`, `N/A` |
| Configuración de armadura | malla o sección compuesta evaluada | columna `ID`: `S8`, `S10`, `S12`, `A8` |

La correlación numérica actual entre ciertos casos y
`tangentialMultiplier = 1/0` no autoriza a llamar `alpha-1/alpha-0` a las
interfaces. Del mismo modo, `S` no puede significar simultáneamente Slip y
“satisface”.

La deriva se agravó porque las fuentes y `html/report/` no se regeneraron en
la misma operación. Corregir el builder no corrige un HTML ya emitido.

## Objetivo

Entregar una memoria, una metodología y una planilla Wolfram que usen el mismo
contrato de nomenclatura y presenten con claridad qué caso se evalúa y qué
comprobación verifica, manteniendo R como única autoridad de cálculo y
`calculation.json` como entrada humana.

El cierre debe cumplir simultáneamente:

- cero `CANDE` en productos o rutas activas;
- cero identificadores públicos `alpha-0`/`alpha-1`;
- $I\in\{\mathrm{S},\mathrm{NS}\}$ sólo para interfaz;
- $E\in\{\mathrm{OK},\mathrm{FAIL},\mathrm{N/A}\}$ sólo para dictamen;
- $\lambda_t$ sólo para la proyección tangencial prescrita;
- códigos en las filas y explicaciones en captions;
- resultados $N$, $M$, $Q$, P--M y verificaciones numéricamente invariantes
  frente a los cambios puramente editoriales;
- una sola evaluación del motor R desde el único notebook Wolfram.

## Productos activos y límites

- Memoria: `_master/report.qmd` y los capítulos que declara.
- Metodología: `_master/model.qmd` y
  `_index/methodology.review.ES.qmd`.
- Entrada: `calculation.json`.
- Motor: `scripts/R/`.
- Wolfram: únicamente
  `scripts/wolfram/calculation.workbook.nb` y
  `scripts/wolfram/calculationWorkbookSupport.wl`.

No crear otro notebook, otro master, una metodología `extension`, un
wolframscript ni una segunda implementación de las ecuaciones.

El usuario se reservó todas las operaciones QRT y de publicación. No ejecutar
`qrt render`, `qrt deploy`, `qrt deploy init`, `qrt deploy domain` ni modificar
enlaces Netlify.

No inspeccionar `_ref`. No restaurar, borrar, confirmar ni publicar las 927
entradas del worktree como una operación global.

## Contrato público de notación

### Interfaz

- IDs de escenario de producto: `slip`, `no-slip`.
- IDs internos del solver, cuando el algoritmo los requiera:
  `fullSlip`/`noSlip` o `full-slip`/`no-slip`; no exponerlos al lector.
- Código en columna $I$: `S`, `NS`.
- Caption: “`S`, Slip; `NS`, No Slip”.
- Las filas nunca dicen “Slip (S)”, “No Slip (NS)”, “Deslizamiento libre” ni
  “Sin deslizamiento”.

### Proyección tangencial

- Campo interno: `tangentialMultiplier`.
- Símbolo público: $\lambda_t$.
- $\lambda_t=1$: se incluye la proyección tangencial completa.
- $\lambda_t=0$: se conserva la proyección normal.
- No llamarlo `alpha`, interfaz, adherencia, fricción, Slip o No Slip.
- No sustituir otros usos legítimos de $\lambda$ en ACI, pandeo o
  multiplicadores de equilibrio; el subíndice distingue $\lambda_t$.

### Comprobaciones

- Columna de control: $i$.
- Chapa: `A` fluencia, `B` pandeo, `C` costura, `D` flexibilidad, `E` tapada
  mínima.
- Hormigón simple: `T` tracción, `C` compresión, `V` corte, `PM`
  flexocompresión.
- Columna de estado: $E$.
- Estados: `OK` para $U\leq1$, `FAIL` para $U>1$ y `N/A` cuando no fue evaluado.
- `S` y `NS` están prohibidos como estados.

### Armaduras

- `S8`, `S10`, `S12` son IDs de mallas simétricas, no interfaces ni estados.
- `A8` es el caso asimétrico chapa exterior + Ø8/150 interior.
- Los IDs aparecen sólo en la columna `ID`; la interfaz, cuando corresponda,
  aparece en una columna $I$ separada.
- No adoptar una armadura final. Se reportan configuraciones discretas y sus
  estados P--M y de corte.

### Comparación de métodos

- Métodos: `H`, `SE`, `K0`, `N00`, `N14`, `AU`.
- Casos de interfaz, también dentro de `SE`: `S`, `NS`.
- `SER` y `LRFD` se reservan a las filas AASHTO/USACE que realmente
  representan esas bases.
- `D`/`S` como abreviaturas de “deslizamiento/sin deslizamiento” son fósiles y
  deben desaparecer.

## Trabajo ya realizado: no repetir

1. Se retiró el bloque CANDE de `scripts/R/ringInteraction.R` y su producción
   desde `scripts/R/runRingBenchmarks.R`.
2. Se retiraron referencias CANDE de los textos y bibliografía activos
   alcanzados por ese cambio.
3. Los casos de configuración pasaron de `alpha-1`/`alpha-0` a
   `slip`/`no-slip`.
4. El multiplicador público de carga prescrita pasó de $\alpha$ a
   $\lambda_t$ en el modelo y la metodología.
5. Los builders de extremos, interacción Schwartz--Einstein y comprobaciones
   de hormigón producen `S`/`NS` en la columna de interfaz.
6. Los builders de comprobaciones AASHTO, hormigón simple y barrido de
   armaduras producen `OK`/`FAIL`/`N/A` en la columna de estado.
7. Las tablas AASHTO y de hormigón se migraron al builder común
   `buildReportTable()`.
8. La tabla de hormigón simple se redujo a la combinación gobernante por
   interfaz y control.
9. El estado global del barrido de armaduras combina P--M y corte; el control
   radial permanece separado.
10. Los captions activos de esas tablas explican sus códigos.
11. `Rscript scripts/R/testRingMethod.R`,
    `testCoverCalculationData.R`, `runCalculationMemo.R` y
    `testCalculationFigures.R` pasaron después de esos cambios.
12. La comparación exacta realizada entonces confirmó que los máximos de
    $N$, $M$ y $Q$ no cambiaron.

No volver a ejecutar esos cuatro comandos antes de modificar una superficie
que cubran. Al final, ejecutarlos una sola vez, en el orden indicado.

## Defectos abiertos comprobados

1. `scripts/wolfram/calculationWorkbookSupport.wl`, función
   `reinforcementStudyView`: usa encabezados `S_PM`, `S_V`, `S_r*` y valores
   `S`/`NS` para estados. Deben ser `E_PM`, `E_V`, `E_r*` y `OK`/`FAIL`.
2. `scripts/tbl/Calculation.classical.comparison.R`:
   `.classicalCaseCode` todavía mapea
   `schwartz-einstein-full-slip -> D` y
   `schwartz-einstein-no-slip -> S`. Debe mapearlos a `S` y `NS`.
3. Las tablas clásicas aún usan algunos encabezados de prosa (`Mét.`, `Caso`)
   en vez de símbolos/códigos explicados por el caption.
4. `buildCalculationInteractionTable()` en
   `scripts/tbl/Calculation.interaction.R` conserva filas “Completa/Normal” y
   el encabezado “Proyección”. No tiene consumidor en los masters vigentes;
   probar la falta de consumidor y retirar o mover el fósil, en lugar de
   invertir trabajo editorial en una tabla inactiva.
5. `html/report/` está obsoleto. Sus filas largas no deben usarse para juzgar
   los builders actuales. El usuario hará el próximo render.
6. El notebook no fue evaluado interactivamente después de los cambios del
   support. No ejecutarlo headless.
7. Existen scripts Python históricos con terminología CANDE fuera de los
   productos activos. Probar que carecen de consumidor y moverlos a
   `dev/legacy/` si entran en el alcance de limpieza; no borrar por barrido.

## Plan de ejecución completo

### A. Congelar el alcance

1. Leer este handoff y `dev/SoT/METHODOLOGY-PHASE2.md`; no reconstruir los
   handoffs ni las auditorías anteriores.
2. Registrar rama, HEAD y estado antes de editar; no exigir un worktree
   limpio.
3. Trazar sólo los includes alcanzables desde `_master/report.qmd` y
   `_master/model.qmd`.
4. Clasificar cada hallazgo como producto activo, soporte activo o fósil; no
   editar archivos desconectados como si fueran producto.
5. No reabrir el modelo híbrido, ACI, AASHTO, Fourier ni Schwartz--Einstein
   salvo que una prueba focal demuestre un defecto numérico nuevo.
6. No ejecutar R, Wolfram ni QRT durante la edición semántica.

### B. Cerrar la nomenclatura

7. Mantener `slip` y `no-slip` como IDs de los dos escenarios públicos.
8. Mantener los tokens internos `fullSlip`/`noSlip` sólo dentro de las APIs
   que los requieren.
9. Verificar que ningún texto público use `alpha-0`, `alpha-1` o $\alpha$ para
   esos escenarios.
10. Mantener $\lambda_t$ en modelo, metodología y tablas de control de carga
    prescrita.
11. Definir $\lambda_t$ una sola vez por documento y referenciar esa
    definición; no repetir una explicación distinta.
12. Verificar que $\lambda_t$ no sea presentado como una ley de fricción o
    una condición de interfaz.
13. Reservar `S`/`NS` a la columna $I$.
14. Reservar `OK`/`FAIL`/`N/A` a la columna $E$.
15. Mantener los códigos de control en una columna $i$ separada.
16. Eliminar CANDE únicamente de las rutas activas; no borrar fuentes
    históricas protegidas por un barrido textual.

### C. Normalizar las tablas activas

17. Inventariar las tablas de verificación realmente incluidas por la memoria:
    chapa, hormigón simple, familias P--M y comparación clásica.
18. Hacer que todas pasen por `buildReportTable()`/flextable.
19. Usar símbolos o códigos en encabezados; trasladar su significado al
    caption.
20. Usar sólo códigos en las filas; prohibir leyendas repetidas dentro de
    celdas.
21. Mantener `S`/`NS` en las filas de interfaz y explicar Slip/No Slip una vez
    en el caption.
22. Mantener `OK`/`FAIL`/`N/A` en las filas de estado y explicar el dictamen una
    vez en el caption.
23. Conservar los controles de chapa `A`--`E` y sus definiciones en caption.
24. Conservar los controles de hormigón `T`, `C`, `V`, `PM` y sus definiciones
    en caption.
25. Presentar una sola combinación gobernante por par $(I,i)$ cuando la tabla
    sea un resumen; no mezclar un registro completo de combinaciones con el
    dictamen público.
26. Mantener separadas demanda $D$, resistencia $R$, utilización $U=D/R$,
    unidad $u$ y estado $E$.
27. En familias de armadura, mantener columnas separadas para
    $U_{PM}$/$E_{PM}$, $U_V$/$E_V$ y $U_r^*$/$E_r^*$.
28. Calcular el estado global $E$ únicamente con P--M y corte, tal como ya
    hace el builder; no incorporar silenciosamente el control radial.
29. No reintroducir la tabla histórica de armadura mínima como si fuera una
    alternativa estructural adoptada.
30. No convertir Ø8/150, Ø10/150 u Ø12/150 en una recomendación de diseño; son
    casos discretos.
31. Aplicar el formato acordado: m con un decimal, MPa con los decimales
    técnicos necesarios y kN/mm sin decimales cuando corresponda.
32. Mantener el espaciado compacto de flextable desde el builder común; no
    agregar CSS ad hoc por tabla.

### D. Reparar la comparación de métodos

33. Corregir los casos Schwartz--Einstein de `D`/`S` a `S`/`NS`.
34. Conservar la columna de método para distinguir `H S`, `H NS`, `SE S` y
    `SE NS`; no inventar códigos de caso adicionales.
35. Cambiar encabezados de prosa de la tabla resumen por símbolos breves y
    documentarlos en los tres captions.
36. Explicar en caption que $r_N$, $r_M$ y $r_Q$ son razones respecto de la
    envolvente híbrida y que valores mayores que uno no son utilizaciones
    resistentes.
37. Mantener la raya sólo para magnitudes que la formulación no entrega o no
    hace comparables.

### E. Alinear figuras y diagramas sin recalcular

38. En leyendas gráficas sí se admite “Slip (S)” y “No Slip (NS)”; la
    prohibición de leyendas largas aplica a filas de tablas.
39. No hardcodear títulos dentro del plot; el título pertenece al caption.
40. Mantener los tooltips como “modelo híbrido”, no como
    “Schwartz--Einstein” a secas.
41. Mantener dos puntos de demanda por configuración e interfaz en cada
    diagrama P--M; las mallas simétricas pueden compartir coordenadas y usar
    marcadores concéntricos.
42. No interpretar los puntos de las curvas P--M como iteraciones; las curvas
    son dominios resistentes.
43. No cambiar escalas ni datos de $N$, $M$, $Q$ dentro de este paquete salvo
    que el cambio sea necesario para corregir una etiqueta.

### F. Alinear Wolfram

44. Conservar un notebook y un support; no generar alternativas.
45. Mantener una sola llamada a `evaluateCoverCase()` y consumir la estructura
    devuelta por R.
46. Corregir `reinforcementStudyView` a estados `OK`/`FAIL` y encabezados
    $E_{PM}$, $E_V$, $E_r^*$.
47. Mantener `caseName()` con “Slip (S)” y “No Slip (NS)” para vistas y
    leyendas, no para estados.
48. Mostrar “multiplicador tangencial” o $\lambda_t$ en el control de carga
    prescrita; no reintroducir Alpha.
49. No trasladar ecuaciones R al notebook.
50. No evaluar el notebook headless. La aceptación Wolfram corresponde a una
    evaluación interactiva del usuario en un kernel nuevo.

### G. Verificación final, una sola vez

51. Ejecutar un chequeo textual focal de las rutas activas para CANDE,
    `alpha-0`, `alpha-1` y usos ilegales de `S`/`NS` como estado.
52. Construir en R los objetos flextable y comprobar sus datasets internos;
    no usar el HTML viejo como evidencia.
53. Ejecutar una vez `testRingMethod.R`.
54. Ejecutar una vez `testCoverCalculationData.R`.
55. Ejecutar una vez `runCalculationMemo.R` sólo si cambió una fuente que
    alimenta los productos calculados.
56. Ejecutar una vez `testCalculationFigures.R`.
57. Comparar exactamente los máximos de $N$, $M$ y $Q$ con el baseline de
    este handoff.
58. Entregar al usuario la lista de archivos modificados y los comandos que
    pasaron.
59. No renderizar ni publicar. Indicar que el HTML seguirá obsoleto hasta que
    el usuario ejecute QRT.
60. Actualizar este handoff y `dev/SoT/METHODOLOGY-PHASE2.md` con el cierre;
    no crear otro plan paralelo.

## Baseline numérico que no debe cambiar

Máximos absolutos no mayorados observados:

| Sección | Interfaz | $|N|$ [kN/m] | $|M|$ [kN·m/m] | $|Q|$ [kN/m] |
|---|---|---:|---:|---:|
| chapa | S | 300.475161358326 | 1.88258709708926 | 3.41905922845516 |
| chapa | NS | 378.794882429009 | 1.72665150753119 | 3.20170472786245 |
| shotcrete 100 mm | S | 299.492496621413 | 11.5605725685793 | 18.4638577165654 |
| shotcrete 100 mm | NS | 375.873204820728 | 9.85754676522879 | 15.7875067320668 |
| shotcrete 150 mm | S | 308.241034622626 | 27.9981115521595 | 45.2756496680698 |
| shotcrete 150 mm | NS | 375.514764423117 | 24.0039247831990 | 38.8413542468315 |

Resultados públicos esperados de las tablas vigentes:

- chapa: `A OK`, `B OK`, `C FAIL`, `D OK`, `E OK`;
- hormigón simple 100 mm: tracción `FAIL` y corte `OK` para `S` y `NS`;
- familia 100 mm: `S8 OK`, `S10 OK`, `S12 OK`, `A8 FAIL` para el estado global
  P--M + corte;
- familia 150 mm: `S8 FAIL`, `S10 FAIL`, `S12 OK`, `A8 FAIL` para el mismo estado.

Si una corrección de etiquetas cambia estas cifras o estados, detenerse: dejó
de ser una corrección editorial.

## Criterios de aceptación

El paquete está cerrado cuando:

1. ninguna fila de tabla contiene leyendas largas de interfaz;
2. `S`/`NS` sólo significan Slip/No Slip;
3. ningún estado Wolfram o R usa `S`/`NS` para satisfacer/no satisfacer;
4. no quedan `D`/`S` fósiles en la comparación Schwartz--Einstein;
5. no quedan `alpha-0`, `alpha-1` ni Alpha público para el multiplicador;
6. los captions definen todos los códigos una sola vez;
7. R y Wolfram presentan los mismos IDs y estados;
8. el baseline numérico permanece idéntico;
9. los tests focales pasan una vez;
10. no se ejecutó QRT ni se tocó la publicación.

## Primera acción del agente receptor

No iniciar una auditoría general. Abrir solamente:

1. `scripts/wolfram/calculationWorkbookSupport.wl` en
   `reinforcementStudyView`;
2. `scripts/tbl/Calculation.classical.comparison.R` en
   `.classicalCaseCode` y el builder de resumen;
3. los tres captions `tbl.Calculation.classical.*.ES.md`.

Aplicar esos defectos abiertos, revisar el diff focal y continuar desde la
Fase G. Todo lo demás ya tiene ruling o está fuera del paquete.
