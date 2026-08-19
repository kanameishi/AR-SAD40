# Estado vigente — metodología, memoria de cálculo y Wolfram

Fecha de corte: 2026-08-18.

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
- peso unitario efectivo: 19,6133 kN/m³, equivalente a 2,0 tf/m³;
- sobrecarga permanente: 83,84686 kPa, equivalente a 5,7 m de lodo de
  1,5 tf/m³; no se desagrega una combinación de carga viva;
- $E_g=30000$ kPa y $\nu_g=0,30$;
- $\phi'=30^\circ$, OCR = 1 y presión hidráulica neta nula;
- $K_0$ se deriva con la rama Mayne--Kulhawy y resulta 0,50; no está fijado de
  manera independiente del suelo;
- chapa CSPI 76 × 25, espesor especificado 3,5 mm y espesor remanente analizado
  3,0 mm;
- shotcrete de 100 y 150 mm, $f'_c=30$ MPa;
- familias P--M para las mallas físicas Ø8/150, Ø10/150 y Ø12/150 en
  ambas caras de cada espesor, más el caso asimétrico de chapa exterior y
  Ø8/150 interior con acción compuesta total.

$\phi'$, OCR y ausencia de agua son hipótesis provisionales hasta recibir datos
geotécnicos definitivos.

## Resultados vigentes

Para la chapa, los máximos absolutos del estado no mayorado son:

| Interfaz | $|N|$ [kN/m] | $|M|$ [kN·m/m] | $|Q|$ [kN/m] |
|---|---:|---:|---:|
| Slip (`S`) | 300 | 1,88 | 3,42 |
| No Slip (`NS`) | 379 | 1,73 | 3,20 |

La reproducción de comprobaciones AASHTO/USACE de ediciones previas satisface
fluencia, pandeo, flexibilidad y tapada mínima. La demanda de costura es
526,8 kN/m frente a una resistencia publicada de referencia de 515,2 kN/m y no
satisface ese control. Esto no acredita una verificación normativa de la
edición contractual vigente. La costura publicada de referencia tampoco está
demostrada como equivalente a la unión existente.

Para shotcrete, los máximos absolutos del estado no mayorado son:

| Espesor | Interfaz | $|N|$ [kN/m] | $|M|$ [kN·m/m] | $|Q|$ [kN/m] |
|---:|---|---:|---:|---:|
| 100 mm | Slip (`S`) | 299 | 11,56 | 18,46 |
| 100 mm | No Slip (`NS`) | 376 | 9,86 | 15,79 |
| 150 mm | Slip (`S`) | 308 | 28,00 | 45,28 |
| 150 mm | No Slip (`NS`) | 376 | 24,00 | 38,84 |

La sección simple de 100 mm no satisface la comprobación local de tracción. La
familia P--M no adopta una armadura. Sus resultados discretos son:

| Espesor | ID | Armadura | $\rho_\theta$ | $U_{PM,\max}$ | $E_{PM}$ | $U_{V,\max}$ | $E_V$ | $U_{r,\max}^{*}$ | $E_r^{*}$ | $E$ |
|---:|---|---|---:|---:|---|---:|---|---:|---|---|
| 100 mm | S8 | Ø8/150, ambas caras | 0,67 % | 0,94 | OK | 0,45 | OK | 0,23 | OK | OK |
| 100 mm | S10 | Ø10/150, ambas caras | 1,05 % | 0,72 | OK | 0,42 | OK | 0,36 | OK | OK |
| 100 mm | S12 | Ø12/150, ambas caras | 1,51 % | 0,63 | OK | 0,40 | OK | 0,52 | OK | OK |
| 100 mm | A8 | chapa + Ø8/150 interior | 4,07 % | 6,01 | FAIL | 1,04 | FAIL | 0,23 | OK | FAIL |
| 150 mm | S8 | Ø8/150, ambas caras | 0,45 % | 1,79 | FAIL | 0,96 | OK | 0,23 | OK | FAIL |
| 150 mm | S10 | Ø10/150, ambas caras | 0,70 % | 1,28 | FAIL | 0,88 | OK | 0,37 | OK | FAIL |
| 150 mm | S12 | Ø12/150, ambas caras | 1,01 % | 0,97 | OK | 0,82 | OK | 0,53 | OK | OK |
| 150 mm | A8 | chapa + Ø8/150 interior | 2,71 % | 5,91 | FAIL | 1,46 | FAIL | 0,24 | OK | FAIL |

`OK` corresponde a $U\leq1$ y `FAIL` a $U>1$. $E_{PM}$,
$E_V$ y $E_r^{*}$ son dictámenes separados; $E$ combina flexocompresión y
corte. El asterisco identifica la analogía condicional de
desprendimiento radial del recubrimiento de CIRSOC 804-4, que no forma parte de
la flexocompresión P--M.

Cada curva P--M reúne estados resistentes compatibles; sus puntos no son
iteraciones. Hay cuatro configuraciones y dos demandas por configuración:
ocho marcadores por espesor. Las tres mallas simétricas comparten las mismas
dos coordenadas de demanda porque emplean la misma rigidez fisurada; en la
figura aparecen como tres anillos concéntricos. El caso asimétrico aporta otras
dos coordenadas porque recalcula las acciones con su propia rigidez.

## Contenido restaurado

El resumen ejecutivo integra la portada como sección no numerada. La memoria
se organiza luego en cinco capítulos sin prefijos numéricos —introducción,
modelo de cálculo, verificación del liner de acero, verificación del liner de
shotcrete y especificación técnica de inspección— seguidos por los apéndices.
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

- `Rscript scripts/R/testRingMethod.R`: PASS el 2026-08-19.
- `Rscript scripts/R/testCoverCalculationData.R`: PASS el 2026-08-19.
- `Rscript scripts/R/runCalculationMemo.R`: PASS el 2026-08-19.
- `Rscript scripts/R/testCalculationFigures.R`: PASS el 2026-08-19.
- Los máximos de $N$, $M$ y $Q$ son idénticos antes y después de renombrar los
  casos y retirar los fósiles metodológicos.
- Por instrucción del usuario no se ejecutó QRT. `html/report/` y `html/model/`
  deben considerarse obsoletos respecto de las fuentes hasta el próximo render.

## Regeneración mínima

Cuando se acepte un cambio de `calculation.json`:

1. ejecutar una vez `Rscript scripts/R/runCalculationMemo.R`;
2. renderizar una vez
   `qrt render _master/report.qmd --profile book`;
3. evaluar Wolfram interactivamente sólo si se desea comparar el escenario.

No repetir pruebas o renders si no cambió su superficie relevante. No generar
PDF, preparar cambios, crear commits ni publicar sin una instrucción explícita.
El worktree contiene cambios amplios; preservar todo cambio ajeno.
