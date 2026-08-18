# Estado vigente — metodología, memoria de cálculo y Wolfram

Fecha de corte: 2026-08-17.

Este archivo contiene sólo el estado necesario para continuar después de una
compactación. No reconstruir handoffs, planes históricos ni auditorías.

## Objetivo y productos únicos

El proyecto entrega una metodología integrada y una memoria de cálculo. R es
el motor de cálculo; `calculation.json` es la entrada humana; Wolfram consume
la misma frontera R para estudiar otros escenarios.

- Metodología: `_master/methodology.review.es.qmd`,
  `_index/methodology.review.ES.qmd` y
  `html/methodology.review.es/index.html`.
- Memoria: libro multipágina `_master/report.es.qmd`, sus capítulos en
  `_index/` y `html/report.es/index.html`.
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
   uniforme y los modos $n=0,2$ para los límites de deslizamiento libre y sin
   deslizamiento;
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

## Caso determinístico vigente

Entradas en `calculation.json`:

- tapada sobre clave: 4,0 m;
- peso unitario efectivo: 19,6133 kN/m³, equivalente a 2,0 tf/m³;
- sobrecarga permanente: 88,25985 kPa, equivalente a 6 m de lodo de
  1,5 tf/m³; no se desagrega una combinación de carga viva;
- $E_g=30000$ kPa y $\nu_g=0,30$;
- $\phi'=30^\circ$, OCR = 1 y presión hidráulica neta nula;
- $K_0$ se deriva con la rama Mayne--Kulhawy y resulta 0,50; no está fijado de
  manera independiente del suelo;
- chapa CSPI 76 × 25, espesor especificado 3,5 mm y espesor remanente analizado
  3,0 mm;
- shotcrete de 100 y 150 mm, $f'_c=25$ MPa;
- familia P--M total $\rho_\theta=0,18\%,1\%,2\%,3\%$ para ambos espesores.

$\phi'$, OCR y ausencia de agua son hipótesis provisionales hasta recibir datos
geotécnicos definitivos.

## Resultados vigentes

Para la chapa, los máximos absolutos del estado no mayorado son:

| Interfaz | $|N|$ [kN/m] | $|M|$ [kN·m/m] | $|Q|$ [kN/m] |
|---|---:|---:|---:|
| deslizamiento libre | 262 | 1,76 | 3,25 |
| sin deslizamiento | 329 | 1,62 | 3,06 |

La reproducción de comprobaciones AASHTO/USACE de ediciones previas satisface
fluencia, pandeo, costura de referencia, flexibilidad y tapada mínima. Esto no
acredita una verificación normativa de la edición contractual vigente. La
costura publicada de referencia tampoco está demostrada como equivalente a la
unión existente.

Para shotcrete, los máximos absolutos del estado no mayorado son:

| Espesor | Interfaz | $|N|$ [kN/m] | $|M|$ [kN·m/m] | $|Q|$ [kN/m] |
|---:|---|---:|---:|---:|
| 100 mm | deslizamiento libre | 268 | 20,73 | 32,92 |
| 100 mm | sin deslizamiento | 330 | 17,74 | 28,20 |
| 150 mm | deslizamiento libre | 280 | 39,65 | 64,06 |
| 150 mm | sin deslizamiento | 332 | 34,45 | 55,68 |

La sección simple de 100 mm no satisface la comprobación local de tracción. La
familia P--M no adopta una armadura. Sus resultados discretos son:

| Espesor | $\rho_\theta$ | $A_{s,\theta}$ total [cm²/m] | $U_{PM,\max}$ | Estado |
|---:|---:|---:|---:|---|
| 100 mm | 0,18 % | 1,8 | 8,36 | no satisface |
| 100 mm | 1,00 % | 10,0 | 2,03 | no satisface |
| 100 mm | 2,00 % | 20,0 | 1,14 | no satisface |
| 100 mm | 3,00 % | 30,0 | 0,84 | satisface |
| 150 mm | 0,18 % | 2,7 | 8,11 | no satisface |
| 150 mm | 1,00 % | 15,0 | 1,89 | no satisface |
| 150 mm | 2,00 % | 30,0 | 1,04 | no satisface |
| 150 mm | 3,00 % | 45,0 | 0,72 | satisface |

Cada curva P--M reúne estados resistentes compatibles; sus puntos no son
iteraciones. Las cuatro marcas son demandas físicas críticas. No interpolar
estos cuatro niveles como una búsqueda de cuantía óptima ni convertirlos en
una armadura adoptada.

## Contenido restaurado

La memoria conserva su estructura actual y vuelve a incluir:

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
- casos Baker, HP97, USACE D4, FHWA y Núñez en los apéndices, enlazados desde
  los capítulos que emplean o controlan esas formulaciones.

La prosa pública no usa encabezados de nivel 3 ni narrativa interna de
software, auditoría o aceptación.

## Wolfram

El notebook contiene celdas editables para tapada, peso unitario, sobrecarga,
propiedades del suelo, $K_0$, agua, perfil y espesor remanente de chapa,
resistencia de costura, espesores y resistencia del shotcrete, posición de
capas y grilla de cuantías P--M. Sus valores iniciales coinciden con
`calculation.json`.

El notebook ejecuta una sola evaluación R mediante `evaluateCoverCase()` y
muestra la misma respuesta híbrida, las tres familias de resultantes y los dos
diagramas P--M. Cambiarlo no reescribe `calculation.json`: después de aceptar
un escenario, copiar los valores al JSON y regenerar la memoria.

No ejecutar Wolfram en modo headless. El usuario debe abrir
`scripts/wolfram/calculation.workbook.nb` en un kernel nuevo y evaluar las
celdas de forma interactiva.

## Verificación y render del cierre

- `Rscript scripts/R/testCoverCase.R`: PASS antes del cierre editorial.
- `Rscript scripts/R/runCalculationMemo.R`: PASS antes del cierre editorial.
- `Rscript scripts/R/runInteractionMethodStudy.R`: PASS antes del cierre
  editorial.
- `Rscript scripts/R/testCalculationFigures.R`: PASS el 2026-08-17.
- `Rscript scripts/R/testCalculationResultantsDom.R`: PASS el 2026-08-17;
  tres figuras cuadradas, contenidas y con ambas formulaciones seleccionables.
- `qrt render _master/methodology.review.es.qmd --profile html`: código 0 el
  2026-08-17.
- `qrt render _master/report.es.qmd --profile book`: código 0 el
  2026-08-17.

SHA-256 de los productos renderizados:

- metodología HTML:
  `c1662a652f7ad7af04ab33cd881ef2174763b2ca179b9dfa68501e0a76329c66`;
- memoria HTML:
  `0b3cee736e7c5f92d6f3eba8a0567970c212310ad7d852fbd4ce38f69157c660`;
- notebook:
  `85a98115614d6cbd6fa4680ff0b0af0ef0e66b6ddfea07eb295c6f2a4c6a3d43`;
- soporte Wolfram:
  `33effe209ac118f48acf804af825f6bb3f49993de0cd10650485e258b9802a10`;
- `calculation.json`:
  `fc42a0ecea76cca49d280c09e4cfb3c397df603f43f3565981acceab115e9560`.

## Regeneración mínima

Cuando se acepte un cambio de `calculation.json`:

1. ejecutar una vez `Rscript scripts/R/runCalculationMemo.R`;
2. renderizar una vez
   `qrt render _master/report.es.qmd --profile book`;
3. evaluar Wolfram interactivamente sólo si se desea comparar el escenario.

No repetir pruebas o renders si no cambió su superficie relevante. No generar
PDF, preparar cambios, crear commits ni publicar sin una instrucción explícita.
El worktree contiene cambios amplios; preservar todo cambio ajeno.
