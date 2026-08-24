# Estado vigente — metodología, memoria de cálculo y Wolfram

Fecha de corte: 2026-08-20.

Este archivo contiene sólo el estado necesario para continuar después de una
compactación. No reconstruir handoffs, planes históricos ni auditorías.

## Objetivo y productos únicos

El proyecto entrega una metodología integrada y una memoria de cálculo. R es
el motor de cálculo; `calculation.json` es la entrada humana; Wolfram consume
la misma frontera R para estudiar otros escenarios.

- Metodología: `_master/model.qmd`,
  `_index/methodology.review.ES.qmd` y
  `html/model/index.html`.
- Memoria: libro multipágina `_master/report.qmd`, sus capítulos en
  `_index/` y `html/report/index.html`.
- Wolfram: únicamente `scripts/wolfram/calculation.workbook.nb` y
  `scripts/wolfram/calculationWorkbookSupport.wl`.

La antigua memoria HTML continua se conserva sólo como fuente bajo
`dev/legacy/calculation-review/`; no es un producto vigente ni debe
renderizarse para revisión.

No crear variantes `extension`, un segundo notebook, un optimizador de
armadura, archivos `.codex-task*`, handoffs ni auditorías en cascada.

## Modelo vigente

Las demandas de cada revestimiento se recalculan con sus propias rigideces.
La respuesta de cálculo es híbrida:

1. Schwartz--Einstein, en la secuencia de carga externa, calcula la componente
   uniforme y los modos $n=0,2$ para los límites Slip (`S`) y No Slip (`NS`);
2. el gradiente geostático lineal sobre la altura se proyecta en los modos
   $n=1,3$ y se equilibra mediante una reacción radial circunferencial;
3. se superponen ambas componentes para obtener
   $N_\theta(\theta)$, $M_\theta(\theta)$ y $Q_\theta(\theta)$;
4. Fourier y la integración directa RK4 controlan la reconstrucción. Los 8192
   valores de RK4 son pasos angulares, no términos de Fourier;
5. la solución cerrada controla el caso uniforme de carga prescrita.

La reacción del gradiente es una restricción de equilibrio, no un resorte
calibrado; no se informa $k_r$ ni un desplazamiento asociado. El modelo no
reproduce por tongadas la construcción del relleno. AASHTO/USACE, FHWA y Núñez
se conservan en sus dominios como referencias separadas y no se promedian con
la demanda híbrida.

CANDE no forma parte del motor, de los benchmarks vigentes ni de la
metodología pública.

## Caso determinístico vigente

Entradas en `calculation.json`:

- tapada sobre clave: 5,7 m;
- peso unitario efectivo del relleno inferior: 19,0 kN/m³;
- capa superior de lodo: 5,7 m de 14,71 kN/m³ (83,85 kPa permanentes); no se
  desagrega una combinación de carga viva;
- $E_g=30000$ kPa y $\nu_g=0,25$; recubrimiento libre fijo de 15 mm
  (`clearCoverMm`);
- $\phi'=33^\circ$, OCR = 1 y presión hidráulica neta nula;
- $K_0$ se deriva con la relación de Jáky (`jaky-nc`, que exige OCR = 1) y
  resulta 0,455361; no está fijado de manera independiente del suelo;
- chapa CSPI 76 × 25, espesor especificado 3,5 mm y espesor remanente analizado
  3,0 mm;
- shotcrete de 100 y 150 mm, $f'_c=30$ MPa;
- familias P--M para las mallas físicas Ø8/150, Ø10/150 y Ø12/150 en
  ambas caras de cada espesor. El caso asimétrico de chapa exterior más malla
  interior fue retirado por decisión del usuario el 2026-08-20: no existe una
  verificación específica de sección mixta y su acción compuesta no se
  comprobaba (`compositeCase.enabled = false`).

$\phi'$, OCR y ausencia de agua son hipótesis provisionales hasta recibir datos
geotécnicos definitivos.

## Resultados vigentes

Para la chapa, los máximos absolutos del estado no mayorado son:

| Interfaz | $|N|$ [kN/m] | $|M|$ [kN·m/m] | $|Q|$ [kN/m] |
|---|---:|---:|---:|
| Slip (`S`) | 306 | 2,03 | 3,67 |
| No Slip (`NS`) | 392 | 1,82 | 3,38 |

La reproducción de comprobaciones AASHTO/USACE de ediciones previas satisface
fluencia, pandeo, flexibilidad y tapada mínima. La demanda de costura es
517,3 kN/m frente a una resistencia publicada de referencia de 515,2 kN/m
($U=1{,}004$); con la tolerancia de aceptación declarada
`utilizationTolerance = 0.005` (redondeo de $U$ a dos decimales, ruling del
usuario 2026-08-20) ese control se informa satisfecho. Esto no acredita una verificación normativa de la
edición contractual vigente. La costura publicada de referencia tampoco está
demostrada como equivalente a la unión existente.

Para shotcrete, los máximos absolutos del estado no mayorado son:

| Espesor | Interfaz | $|N|$ [kN/m] | $|M|$ [kN·m/m] | $|Q|$ [kN/m] |
|---:|---|---:|---:|---:|
| 100 mm | Slip (`S`) | 306 | 12,60 | 20,11 |
| 100 mm | No Slip (`NS`) | 389 | 10,38 | 16,63 |
| 150 mm | Slip (`S`) | 315 | 30,22 | 48,86 |
| 150 mm | No Slip (`NS`) | 387 | 25,14 | 40,68 |

La sección simple de 100 mm no satisface la comprobación local de tracción. La
familia P--M no adopta una armadura. Sus resultados discretos son:

| Espesor | ID | Armadura | $\rho_\theta$ | $U_{PM,\max}$ | $E_{PM}$ | $U_{V,\max}$ | $E_V$ | $U_{r,\max}^{*}$ | $E_r^{*}$ | $E$ |
|---:|---|---|---:|---:|---|---:|---|---:|---|---|
| 100 mm | S8 | Ø8/150, ambas caras | 0,67 % | 0,96 | OK | 0,47 | OK | 0,23 | OK | OK |
| 100 mm | S10 | Ø10/150, ambas caras | 1,05 % | 0,75 | OK | 0,44 | OK | 0,36 | OK | OK |
| 100 mm | S12 | Ø12/150, ambas caras | 1,51 % | 0,66 | OK | 0,41 | OK | 0,52 | OK | OK |
| 150 mm | S8 | Ø8/150, ambas caras | 0,45 % | 1,85 | FAIL | 0,94 | OK | 0,24 | OK | FAIL |
| 150 mm | S10 | Ø10/150, ambas caras | 0,70 % | 1,28 | FAIL | 0,86 | OK | 0,37 | OK | FAIL |
| 150 mm | S12 | Ø12/150, ambas caras | 1,01 % | 0,95 | OK | 0,80 | OK | 0,53 | OK | OK |

`OK` corresponde a $U\leq1$ y `FAIL` a $U>1$. $E_{PM}$,
$E_V$ y $E_r^{*}$ son dictámenes separados; $E$ combina flexocompresión y
corte. El asterisco identifica la analogía condicional de
desprendimiento radial del recubrimiento de CIRSOC 804-4, que no forma parte de
la flexocompresión P--M.

Cada curva P--M reúne estados resistentes compatibles; sus puntos no son
iteraciones. Hay tres configuraciones y dos demandas por configuración: seis
marcadores por espesor. Las tres mallas simétricas comparten las mismas dos
coordenadas de demanda porque emplean la misma rigidez fisurada; en la figura
aparecen como tres anillos concéntricos.

## Contenido restaurado

El resumen ejecutivo integra la portada como sección no numerada. La memoria
se organiza luego en cinco capítulos sin prefijos numéricos —introducción,
modelo de cálculo, verificación del liner de acero, verificación del liner de
shotcrete y especificación técnica de inspección— seguidos por los apéndices.
El análisis de sensibilidad al módulo del terreno no es un capítulo separado:
cada bloque se presenta dentro de la verificación estructural que le
corresponde, sin encabezado propio. El caso completo se recalcula con
$E_g$ = 30, 60, 90 y 120 MPa (constante `MODULI` de
`runCalculationMemo.R`) y `buildCoverSensitivityData()` publica los productos
`sensitivity.*.csv`. Las comprobaciones AASHTO/USACE de la chapa son
independientes de $E_g$ (rama prismática); las secciones simples se rechazan
en todo el rango y los dictámenes P--M de 150 mm cambian con el módulo (S8 y
S10 verifican desde 60 MPa). Las figuras $P$--$M$ de sensibilidad conservan el
cuadrante $P\geq0$, $M\geq0$ y trazan la trayectoria de la demanda
gobernante de S8 por interfaz, con el momento en valor absoluto.
Conserva:

- definición de $z(\theta)$, tensiones efectivas, $K_0$, presiones normales y
  tangenciales y convenciones de signo;
- ecuaciones de equilibrio de la viga circular, integración directa, solución
  cerrada, Fourier y relación con Schwartz--Einstein;
- componente de gradiente, reacción equilibrante y controles numéricos;
- propiedades y rigideces separadas de chapa, shotcrete de 100 mm y de 150 mm;
- croquis catalogado del perfil CSPI 76 × 25 mm con sus dimensiones y vínculo
  con la tabla de propiedades de la chapa;
- diagramas verdaderos de $N$, $M$ y $Q$ para las tres secciones;
- comprobaciones de chapa, hormigón simple y dominios P--M de ambos espesores;
- ecuaciones AASHTO/USACE empleadas por la chapa desarrolladas junto a su
  verificación; casos Baker, HP97, USACE D4, FHWA y Núñez conservados en los
  apéndices de contraste y enlazados desde los capítulos correspondientes.

La prosa pública no usa encabezados de nivel 3 ni narrativa interna de
software, auditoría o aceptación.

## Wolfram

El notebook contiene celdas editables para tapada, peso unitario, sobrecarga,
propiedades del suelo, $K_0$, agua, perfil y espesor remanente de chapa,
resistencia de costura, espesores y resistencia del shotcrete, posición de
capas y casos físicos de armadura P--M. Sus valores iniciales coinciden con
`calculation.json`.

El notebook ejecuta una sola evaluación R mediante `evaluateCoverCase()` y
muestra la misma respuesta híbrida, las tres familias de resultantes y los dos
diagramas P--M. Cambiarlo no reescribe `calculation.json`: después de aceptar
un escenario, copiar los valores al JSON y regenerar la memoria.

No ejecutar Wolfram en modo headless. El usuario debe abrir
`scripts/wolfram/calculation.workbook.nb` en un kernel nuevo y evaluar las
celdas de forma interactiva.

## Verificación y render del cierre

- Suite completa `scripts/R/test*.R`: PASS el 2026-08-19/20 (incluye la
  migración a `clearCoverMm`, el escenario `plainConcrete150` y los productos
  de sensibilidad).
- `Rscript scripts/R/runCalculationMemo.R`: PASS el 2026-08-20 (incluye el
  barrido de sensibilidad; unos minutos más de corrida).
- Renders QRT vigentes: `html/report/` (book) y `html/model/` (html);
  Word en `docx/report.docx`; zips en `deliv/`. Report y model publicados en
  producción el 2026-08-19 (`arsad40-report.srk.ar`, `arsad40-model.srk.ar`);
  la sección de sensibilidad es posterior a esa publicación.

## Regeneración mínima

Cuando se acepte un cambio de `calculation.json`:

1. ejecutar una vez `Rscript scripts/R/runCalculationMemo.R` (regenera
   `data/calculation`, incluidos los `sensitivity.*.csv`, y
   `data/benchmarks`);
2. si cambió la superficie del anillo o del estudio de interacción, ejecutar
   `runRingBenchmarks.R` y `runInteractionMethodStudy.R` (alimentan
   `data/benchmarks/ring/`, que consume la metodología);
3. renderizar una vez
   `qrt render _master/report.qmd --profile book`;
4. evaluar Wolfram interactivamente sólo si se desea comparar el escenario.

No repetir pruebas o renders si no cambió su superficie relevante. No generar
PDF, preparar cambios, crear commits ni publicar sin una instrucción explícita.
El worktree contiene cambios amplios; preservar todo cambio ajeno.
