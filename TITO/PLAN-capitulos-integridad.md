# Plan de producción — informe de integridad del túnel

Fecha: 10 de agosto de 2026
Estado: hito R0 implementado y renderizado; quedan para etapas posteriores la
interacción corrugada SC-06, el gráfico Highcharter definitivo, el apéndice y
las especificaciones.

## 1. Objetivo

Construir un informe técnico reproducible con tres capítulos principales:

1. antecedentes;
2. metodología de análisis;
3. especificaciones técnicas para la evaluación de integridad.

La fuente metodológica canónica seguirá siendo
`TITO/kb/metodologia-anillo-enterrado.md`. Primero se completará esa fuente de
verdad con ecuaciones, revisión bibliográfica, ejemplos y criterios de uso.
Después se hidratarán los capítulos públicos. No se desarrollarán dos versiones
independientes de una misma ecuación.

## 2. Decisiones ya adoptadas

- R es la implementación científica canónica.
- `scripts/R/ringDirect.R` es el solver canónico de tracciones prescritas;
  `scripts/R/ringFourier.R` es un comparador modal independiente.
- Wolfram queda como control interno y no forma parte del flujo de producción.
- Fourier se conserva como comparador; no vuelve a ser el motor principal.
- La corrugación no se incorporará como ajuste posterior de $N$, $M$ o $Q$.
  Para la corrugación anular y el problema plano se usarán las propiedades
  seccionales estándar $A_p$ e $I_p$, las rigideces $E_sA_p$ y $E_sI_p$, y
  `sectionRatio = I_p/(A_pR^2)`, según el
  [plan acotado de rigidez seccional](PLAN-investigacion-ortotropia.md).
- Los aportes de otros agentes se tratan como material no verificado. Sólo se
  migran a la fuente de verdad después de contrastarlos con la fuente primaria
  y reproducirlos de manera independiente.
- No se inspeccionará `_ref` durante este trabajo metodológico.
- Los capítulos heredados que presentan Fourier como núcleo no se corregirán
  por acumulación de parches: se reemplazarán por los archivos nuevos después
  de hidratar la fuente de verdad.
- Los PDF recuperados y los productos actuales de procedencia no resuelta se
  preservarán. No se borrarán para ordenar el informe.
- La revisión de práctica profesional será una sección separada,
  `methodology.practice.es.md`. Esto mantiene la evidencia y el dominio de
  cada método fuera de la derivación mecánica de
  `methodology.model.es.md`.
- Las ecuaciones detalladas que interrumpan el flujo del texto irán a
  `methodology.appendix.es.md`; las ecuaciones necesarias para comprender y
  aplicar el método permanecerán en el cuerpo principal.

### 2.1 Auditoría del aporte `scripts/py`

El veredicto completo está en
[`TITO/kb/auditoria-aporte-python.md`](kb/auditoria-aporte-python.md). Los dos
archivos se preservan como aporte bruto; no se convierten en dependencia del
render ni en una segunda implementación.

| Componente | Veredicto | Integración |
|---|---|---|
| Ecs. 22–25 de Núñez 2014 | coinciden con el PDF y con R | conservar R como SoT; usar el caso sólo como control cruzado |
| secuencia manual entradas–ecuación–resultado | clara y útil | reutilizar el formato con resultados producidos por R |
| Tablas 2–3 de 2014 | transcripción correcta pero duplicada | conservar el CSV canónico de `TITO/kb/benchmarks` |
| aproximación de chapa corrugada | sin fuente suficiente y fuera del dominio | no integrar; sustituir por $A_p$ e $I_p$ de una fuente autorizada |
| capacidades de chapa, costura y diagrama $N$–$M$ | placeholders explícitos | excluir del informe |
| distribuciones, probabilidades y rankings | supuestos ilustrativos | excluir; el motor R seguirá recibiendo realizaciones aprobadas |
| FORM/FOSM y linealización de una función de falla | ajenos a la metodología adoptada | descartar; no forman parte del backlog |

Antes del primer render no se copiará ningún valor de capacidad, utilización,
$\beta$, $P_f$ o importancia del notebook. No se implementarán FORM, FOSM ni
aproximaciones lineales de una función de falla. La única incorporación numérica
admisible es un fixture interno de Núñez que demuestre que Python y R evalúan
la misma ecuación; no se lo presentará como benchmark independiente.

## 3. Arquitectura documental objetivo

```text
_master/
  integrity.es.qmd                 # master final propio del proyecto
  methodology.es.qmd               # render metodológico aislado durante revisión

_index/
  intro.ES.qmd
  methodology.ES.qmd
  specifications.ES.qmd
  methodology.appendix.ES.qmd

_chapters/
  intro.background.es.md
  methodology.summary.es.md
  methodology.practice.es.md
  methodology.pressures.es.md
  methodology.model.es.md
  methodology.uncertainty.es.md
  methodology.sources.es.md
  methodology.corrugation.es.md
  methodology.results.es.qmd
  methodology.benchmarks.es.qmd
  methodology.appendix.es.md

  specifications.basis.es.md
  specifications.records.es.md
  specifications.inspection.es.md
  specifications.geometry.es.md
  specifications.materials.es.md
  specifications.joints.es.md
  specifications.ground.es.md
  specifications.assessment.es.md
  specifications.acceptance.es.md
  specifications.deliverables.es.md

scripts/R/                       # física, análisis y Monte Carlo
scripts/tbl/                     # adaptación de datos a objetos TBL
scripts/fig/                     # adaptación de datos a objetos PLOT
_tbl/<ID>.qmd                    # cálculo y composición neutros al idioma
_tbl/<ID>.ES.qmd                 # wrapper español y caption
_fig/<ID>.qmd                    # cálculo y composición neutros al idioma
_fig/<ID>.ES.qmd                 # wrapper español y caption
_captions/tbl.<ID>.md            # epígrafe base
_captions/tbl.<ID>.ES.md         # epígrafe español de tabla
_captions/fig.<ID>.md            # epígrafe base
_captions/fig.<ID>.ES.md         # epígrafe español de figura
_summary/<topic>.results.es.qmd  # fragmento ejecutivo español
```

El master final ordenará los capítulos como Antecedentes, Metodología y
Especificaciones. `methodology.appendix.ES.qmd` se declarará como apéndice y
llamará a `_chapters/methodology.appendix.es.md`.

No se usará `_master/report.es.qmd`: ese nombre pertenece al scaffold PSHA
instalado y contiene un master sísmico genérico. `_master/integrity.es.qmd`
evita convertir el informe en un override accidental y bloquea cualquier
tentación de hidratar o forzar el master ajeno.

### 3.1 Política de nombres derivada del scaffold

La política se obtuvo del scaffold efectivo instalado bajo
`/usr/local/libexec/psha/scaffold` y se contrastó con el checkout local de la
herramienta para los componentes auditados. No se trasladan literalmente los
títulos españoles a los nombres de archivo.

| Componente | Forma canónica | Ejemplo del proyecto |
|---|---|---|
| master español | `<product>.es.qmd` | `_master/integrity.es.qmd` |
| índice español | `<topic>.ES.qmd` | `_index/methodology.ES.qmd` |
| prosa de capítulo | `<topic>.<role>.es.md` | `_chapters/methodology.model.es.md` |
| capítulo ejecutable | `<topic>.<role>.es.qmd` | `_chapters/methodology.results.es.qmd` |
| resumen español | `<topic>.results.es.qmd` | `_summary/methodology.results.es.qmd` |
| fragmento base | `<ID>.qmd` | `_fig/Ring.resultants.qmd` |
| wrapper español | `<ID>.ES.qmd` | `_fig/Ring.resultants.ES.qmd` |
| caption base/español | `fig|tbl.<ID>[.ES].md` | `_captions/fig.Ring.resultants.ES.md` |
| builder | `<ID>.R` | `scripts/fig/Ring.resultants.R` |

Los stems narrativos son ingleses; el idioma vive en el sufijo. Los puntos
separan el tema base y sus calificadores. La caja de siglas y símbolos se
conserva (`K0`, `NMQ`, `FHWA`); no se introduce `camelCase` en IDs nuevos. Los
builders no llevan sufijo de idioma y comparten exactamente el ID del
fragmento base. `.md` se reserva para prosa o captions y `.qmd` para wrappers,
ejecución o composición Quarto.

### 3.2 Función de `_index/methodology.ES.qmd`

El índice metodológico será un orquestador, no otro capítulo monolítico:

```text
Metodología
  2.1 Estado de la práctica             -> methodology.practice.es.md
  2.2 Presiones y acciones              -> methodology.pressures.es.md
  2.3 Modelo de esfuerzos del anillo    -> methodology.model.es.md
  2.4 Incertidumbre y Monte Carlo       -> methodology.uncertainty.es.md
  2.5 Rigidez de sección corrugada      -> methodology.corrugation.es.md
  2.6 Aplicación numérica               -> methodology.results.es.qmd
  2.7 Benchmarking                      -> methodology.benchmarks.es.qmd
```

## 4. Contenido de los capítulos metodológicos

### `methodology.summary.es.md`

- síntesis del alcance, productos y límites de la metodología;
- ninguna ecuación nueva ni resultado sin trazabilidad;
- texto reutilizable por el master metodológico y, si corresponde, por un
  resumen ejecutivo posterior.

### `methodology.practice.es.md`

- taxonomía: carga prescrita, interacción suelo–estructura, túnel excavado y
  método de diseño;
- USACE, FHWA, Núñez, Schwartz–Einstein, Burns–Richard/CANDE y Baker;
- secuencia constructiva que representa cada método;
- hipótesis de profundidad, interfaz, elasticidad y geometría;
- entradas y salidas disponibles: presión, empuje, $N$, $M$, $Q$ o
  desplazamientos;
- tabla comparativa con evidencia `[PUBLICADO]`, `[DERIVADO]` y
  `[SUPUESTO DEL ANALISTA]`.

No repetirá las fórmulas completas de cada método.

### `methodology.pressures.es.md`

- perfil de tensión vertical efectiva y presión de poros;
- ordenadas de clave, eje y solera;
- definición, estimación y límites de $K_0$;
- efecto de compactación e historia de carga;
- proyección de un tensor biaxial a $P_r(\theta)$ y $P_t(\theta)$;
- diferencia entre campo libre y presión final de contacto;
- modelos USACE, FHWA y Núñez en el dominio que realmente soporta cada fuente;
- registro de escenarios de carga y balance global.

### `methodology.model.es.md`

- convención angular y signos del solver;
- equilibrio diferencial del anillo;
- compatibilidad, $EA_w$, $EI_w$ y `sectionRatio`;
- integración directa y tratamiento de discontinuidades;
- diagnóstico de resultante global y cierre numérico;
- soluciones cerradas $K_0$ para `fullTraction` y `normalOnly`;
- API R y procedimiento determinístico;
- sensibilidad de $N$, $M$ y $Q$ a tapada, $K_0$, agua e interfaz.

Schwartz–Einstein y CANDE se describirán aquí sólo cuando aporten una
comparación mecánica necesaria; su revisión de dominio permanecerá en
`methodology.practice.es.md`.

### `methodology.uncertainty.es.md`

- separación entre incertidumbre paramétrica, de escenario y de modelo;
- contrato de variables, dependencias, semilla y convergencia;
- generación de realizaciones separada del solver, con geometría conocida
  fija salvo que exista una incertidumbre de medición declarada;
- cuantiles puntuales, cuantiles de extremos y envolventes entre ramas;
- procedimiento Monte Carlo sin inventar distribuciones ausentes.

Monte Carlo se utiliza para propagar realizaciones y construir envolventes de
$N(\theta)$, $M(\theta)$, $Q(\theta)$ y sus extremos. No se resuelve una
ecuación de falla mediante FORM, FOSM ni otra aproximación lineal, y esos
métodos no forman parte de esta metodología.

### `methodology.corrugation.es.md`

- definición del perfil normalizado: paso, profundidad, radios de conformado,
  espesor y orientación de la corrugación;
- propiedades $A_p$ e $I_p$ por unidad de longitud axial proyectada, con
  fuente y unidades;
- cálculo de $E_sA_p$, $E_sI_p$ y
  $\eta=I_p/(A_pR^2)$;
- sección lisa equivalente
  $\bar t=\sqrt{12I_p/A_p}$ y $\bar E=E_sA_p/\bar t$ sólo para interfaces que
  la requieran;
- integración de $\eta$ en el solver directo y en el modo uniforme de Fourier;
- integración de $E_s$, $A_p$ e $I_p$ en CANDE;
- recálculo de las propiedades dentro de Monte Carlo cuando varíen el espesor
  o la geometría;
- benchmarks NCSPA, Mai, directo–Fourier y CANDE;
- recuperación posterior de tensiones locales en cresta y valle e interfaz
  futura hacia costuras y pernos.

No se aplicará un factor posterior a $N$, $M$ o $Q$. El capítulo termina en
resultantes globales y no desarrolla una teoría general de cáscara.

### `methodology.results.es.qmd`

- registro de entradas y unidades del caso analizado;
- un caso didáctico isotrópico completo, producido por R, que recorra
  perfil $\rightarrow$ tracciones $\rightarrow$ `solveRingDirect()`
  $\rightarrow$ $N,M,Q$ $\rightarrow$ extremos;
- resultados determinísticos por escenario;
- extremos y ángulos de $N$, $M$ y $Q$;
- barridos de tapada, $K_0$, compactación e interfaz;
- Monte Carlo y diferencia entre cuantiles puntuales y cuantiles de extremos;
- diagramas paramétricos del anillo;
- resultados del anillo con sección genérica y, una vez verificada, con la
  sección corrugada equivalente.

No se publicará un resultado del túnel real hasta aprobar su registro de
entradas. Mientras tanto, este capítulo puede usar casos de referencia
declarados y benchmarks. El caso Núñez del notebook puede aparecer sólo como
control cruzado de una ecuación ya implementada, con todos sus supuestos
rotulados; no se usarán sus capacidades ni probabilidades.

### `methodology.benchmarks.es.qmd`

- benchmark de Baker para el anillo;
- USACE D4;
- FHWA compactación y predicciones Burns–Richard;
- ejemplos y comparación analítica/FEM de Núñez;
- control cruzado Python–R de Núñez clasificado como prueba interna, no como
  benchmark independiente;
- HP97 para las cuatro ramas Schwartz–Einstein;
- fórmulas CANDE Level 1 para ambas interfaces;
- pruebas internas de equilibrio, convergencia y semejanza dimensional;
- clasificación inequívoca entre valor publicado, cálculo derivado, FEM,
  medición y prueba interna.

### `methodology.sources.es.md`

- orden de lectura y localización de las referencias auditadas;
- estado de evidencia y restricciones de dominio;
- puente temporal hacia `methodology.practice.es.md`, sin borrar ni fusionar
  contenido durante un simple cambio de nombres.

### `methodology.appendix.es.md`

- derivación completa del equilibrio y de la compatibilidad;
- coeficientes completos Schwartz–Einstein y CANDE;
- demostración de resultantes globales y cierre en una vuelta;
- transformaciones angulares y de signos;
- conversiones de unidades;
- fórmulas de extremos;
- contrato detallado de datos y funciones R.

## 5. Hidratación de la fuente de verdad

Antes de escribir los capítulos se completará
`TITO/kb/metodologia-anillo-enterrado.md` en este orden:

1. reconciliar la documentación con la API R vigente: integración directa
   como solver y Fourier como comparador;
2. incorporar una matriz única de métodos, secuencia constructiva, entradas,
   salidas, dominio y evidencia;
3. cerrar el registro de símbolos y la relación entre nombres de fuente y API
   R;
4. consolidar las ecuaciones de presión, equilibrio, compatibilidad e
   interacción ya auditadas;
5. incorporar el veredicto del aporte Python sin migrar sus elementos
   rechazados ni duplicar las ecuaciones de Núñez;
6. ejecutar el `PLAN-investigacion-ortotropia.md`: verificar $A_p$, $I_p$,
   $E_sA_p$, $E_sI_p$ y $\eta$; conectarlos con el solver directo, Fourier,
   CANDE y Monte Carlo; mantener separadas la respuesta global y la
   recuperación local;
7. añadir ejemplos numéricos completos con entradas, unidades, ecuación,
   resultado y estado de evidencia;
8. incorporar barridos paramétricos y un ejemplo Monte Carlo reproducible;
9. agregar una matriz de trazabilidad que indique qué sección de la fuente de
   verdad alimenta cada capítulo público;
10. trasladar derivaciones largas al futuro apéndice sin eliminarlas de la base
   de investigación hasta comprobar la migración.

### Regla contra divergencias

- una ecuación tiene un único capítulo propietario;
- `methodology.practice.es.md` compara, pero no duplica derivaciones;
- `methodology.results.es.qmd` presenta corridas, pero no redefine el modelo;
- `methodology.benchmarks.es.qmd` verifica, pero no introduce entradas del
  proyecto;
- `methodology.appendix.es.md` amplía una derivación, pero conserva la misma
  notación;
- toda modificación de una ecuación se realiza primero en la fuente de verdad
  y luego se propaga al capítulo propietario.

## 6. Arquitectura reproducible de tablas y figuras

Se adoptará el patrón del scaffold PSHA sin copiar su contenido de dominio:

```text
scripts/R/ring*.R
    cálculo, unidades, signos y diagnósticos
           ↓
scripts/tbl/*.R                    scripts/fig/*.R
adaptación y formato de TBL        geometría y formato de PLOT
           ↓                                  ↓
_tbl/*.qmd                         _fig/*.qmd
label + caption + TBL              label + caption + PLOT
```

Los scripts de tabla o figura no contendrán física ni una segunda versión de
las ecuaciones. Cada adaptador validará sus columnas y unidades y devolverá un
único objeto `TBL` o `PLOT`.

### 6.1 Tablas iniciales

Cada fila nombra la familia completa: fragmento base, wrapper español,
captions base/español y builder neutro al idioma. En las tablas siguientes,
`[.ES]` abrevia dos archivos reales —sin sufijo y con `.ES`—; no forma parte
del nombre de ninguno de ellos.

| ID | Base / español | Caption / builder | Contenido |
|---|---|---|---|
| `Methods.comparison` | `_tbl/Methods.comparison.qmd` / `_tbl/Methods.comparison.ES.qmd` | `_captions/tbl.Methods.comparison[.ES].md` / `scripts/tbl/Methods.comparison.R` | métodos, dominio y evidencia |
| `Model.parameters` | `_tbl/Model.parameters.qmd` / `_tbl/Model.parameters.ES.qmd` | `_captions/tbl.Model.parameters[.ES].md` / `scripts/tbl/Model.parameters.R` | variables, unidades, fuente y rango |
| `Loads.cases` | `_tbl/Loads.cases.qmd` / `_tbl/Loads.cases.ES.qmd` | `_captions/tbl.Loads.cases[.ES].md` / `scripts/tbl/Loads.cases.R` | escenarios y combinaciones |
| `Ring.extrema` | `_tbl/Ring.extrema.qmd` / `_tbl/Ring.extrema.ES.qmd` | `_captions/tbl.Ring.extrema[.ES].md` / `scripts/tbl/Ring.extrema.R` | extremos y ángulos de $N,M,Q$ |
| `Benchmarks.summary` | `_tbl/Benchmarks.summary.qmd` / `_tbl/Benchmarks.summary.ES.qmd` | `_captions/tbl.Benchmarks.summary[.ES].md` / `scripts/tbl/Benchmarks.summary.R` | publicado frente a R y error |
| `Uncertainty.register` | `_tbl/Uncertainty.register.qmd` / `_tbl/Uncertainty.register.ES.qmd` | `_captions/tbl.Uncertainty.register[.ES].md` / `scripts/tbl/Uncertainty.register.R` | variables aleatorias y de modelo |
| `Specifications.requirements` | `_tbl/Specifications.requirements.qmd` / `_tbl/Specifications.requirements.ES.qmd` | `_captions/tbl.Specifications.requirements[.ES].md` / `scripts/tbl/Specifications.requirements.R` | requisito, fuente, responsable y estado |

Los trece CSV reproducibles de `TITO/kb/benchmarks` permanecen como datos de
benchmark. `_tbl` contendrá fragmentos de presentación, no copias silenciosas
de esos CSV.

### 6.2 Figuras iniciales

| ID | Base / español | Caption / builder | Contenido |
|---|---|---|---|
| `Method.workflow` | `_fig/Method.workflow.qmd` / `_fig/Method.workflow.ES.qmd` | `_captions/fig.Method.workflow[.ES].md` / `scripts/fig/Method.workflow.R` | flujo cargas–anillo–envolventes |
| `Pressure.profile` | `_fig/Pressure.profile.qmd` / `_fig/Pressure.profile.ES.qmd` | `_captions/fig.Pressure.profile[.ES].md` / `scripts/fig/Pressure.profile.R` | $\sigma'_v$, $\sigma'_h$ y $u$ con profundidad |
| `Pressure.ring` | `_fig/Pressure.ring.qmd` / `_fig/Pressure.ring.ES.qmd` | `_captions/fig.Pressure.ring[.ES].md` / `scripts/fig/Pressure.ring.R` | $P_r(\theta)$ y $P_t(\theta)$ |
| `Ring.resultants` | `_fig/Ring.resultants.qmd` / `_fig/Ring.resultants.ES.qmd` | `_captions/fig.Ring.resultants[.ES].md` / `scripts/fig/Ring.resultants.R` | diagramas firmados $N,M,Q$ |
| `Ring.K0` | `_fig/Ring.K0.qmd` / `_fig/Ring.K0.ES.qmd` | `_captions/fig.Ring.K0[.ES].md` / `scripts/fig/Ring.K0.R` | sensibilidad a $H_0$ y $K_0$ |
| `Compaction.stages` | `_fig/Compaction.stages.qmd` / `_fig/Compaction.stages.ES.qmd` | `_captions/fig.Compaction.stages[.ES].md` / `scripts/fig/Compaction.stages.R` | banda FHWA y envolvente constructiva |
| `Ring.envelopes` | `_fig/Ring.envelopes.qmd` / `_fig/Ring.envelopes.ES.qmd` | `_captions/fig.Ring.envelopes[.ES].md` / `scripts/fig/Ring.envelopes.R` | cuantiles o envolventes declaradas |

Antes de implementar estos fragmentos se resolverá el setup efectivo de NGR,
`highcharter`, `flextable`, captions y `root`. El runtime auditado contiene
NGR 0.3.9, `highcharter` 0.9.5 y Highcharts JS 9.3.1. El proyecto todavía no
tiene `scripts/setup`; no se copiará ni hidratará un scaffold sin clasificar
propiedad y obtener autoridad para los paths exactos.

## 7. Diagrama paramétrico de $N$, $M$ y $Q$

La primera implementación será propia y en R con `highcharter`. La prueba de
API contra las versiones instaladas confirmó que Highcharts puede representar
la geometría completa; `ggplot2` queda únicamente como fallback sujeto a una
falla explícita de aceptación. No se necesita otro solver, una biblioteca
estructural Python ni Wolfram.

No se forzará `NGR::buildPlot()`. Su contrato actual representa líneas,
puntos y rangos del tipo $Y(X)$; por eso sí se reutilizará para $P_r(\theta)$,
$P_t(\theta)$, $N(\theta)$, $M(\theta)$, $Q(\theta)$ y envolventes contra
$\theta$. Una banda radial cerrada, en cambio, es un polígono cartesiano que
puede tener más de una ordenada para el mismo $X$ y no es un `arearange`.

Para la convención canónica, con cero en clave y ángulo horario:

$$
\mathbf r(\theta)=R
\begin{bmatrix}\sin\theta\\\cos\theta\end{bmatrix}.
$$

Para una resultante escalar $S(\theta)$:

$$
\Delta r_S(\theta)=d_{max,S}\frac{S(\theta)}{S_{ref,S}},
\qquad
\mathbf r_S(\theta)=\left[R+\Delta r_S(\theta)\right]
\begin{bmatrix}\sin\theta\\\cos\theta\end{bmatrix}.
$$

La ordenada positiva se dibuja hacia afuera y la negativa hacia adentro. Es
una convención gráfica, no una deformada ni la dirección física del
resultante.

### Producto gráfico

- tres paneles con geometría y límites comunes: $N$, $M$ y $Q$;
- eje del anillo, banda firmada, curva y ordenadas radiales;
- colores distintos para signos positivo y negativo;
- unidades, escala gráfica, convención angular y signos visibles;
- etiquetas de mínimo y máximo con valor y ángulo;
- relación cartesiana 1:1 demostrada por igualdad de límites y de longitud en
  píxeles de cada par de ejes;
- una referencia fija por resultante cuando se comparen casos.

La figura técnica inicial será un único widget Highcharts de tamaño fijo con
tres pares de ejes. Cada panel tendrá `width` y `height` numéricos e iguales,
`min = -L`, `max = L`, padding nulo, `alignTicks = FALSE` y
`reflow = FALSE`. Los porcentajes no son admisibles para probar la escala 1:1,
porque el ancho y el alto disponibles cambian de manera independiente. Una
grilla responsiva de tres widgets podrá añadirse después, pero no reemplaza la
figura única exportable.

### Capas Highcharts

La geometría se calculará enteramente en R. Highcharts sólo recibirá capas XY
preparadas:

- `line` para la directriz y la curva desplazada;
- `polygon` para cada lóbulo continuo de signo constante;
- una o pocas series `line`, separadas por puntos `NULL`, para las ordenadas;
- `scatter` para máximos, mínimos y otros puntos auditables.

Antes de separar lóbulos se insertarán por interpolación los cruces por cero.
Cada polígono recorrerá la directriz en un sentido y la curva desplazada en el
sentido inverso. Las trayectorias usarán `requireSorting = FALSE`,
`findNearestPointBy = "xy"` y `turboThreshold = 0`; la topología dependerá de
una columna `sequence`, nunca del ordenamiento por abscisa.

### Evidencia del prototipo temporal

El PoC ejecutado con R 4.6.0 y `highcharter` 0.9.5 produjo un HTML
autocontenido con tres pares de ejes de $360\times360$ px, 12 series
`polygon`, 12 `line` y 3 `scatter`. Highcharts 9.3.1 creó las 27 series sin
excepciones JavaScript; la consulta al gráfico renderizado confirmó longitudes
de 360 px en ambos ejes de cada panel. El caso $A\cos 2\theta$ produjo dos
lóbulos positivos y dos negativos por panel, todos cerrados dentro de la
tolerancia numérica.

La captura de control confirmó la circularidad y reveló un defecto menor: las
etiquetas de extremos laterales pueden recortarse contra el borde. El builder
de producción reservará margen o desplazará esas etiquetas según cuadrante.
El PoC es evidencia de factibilidad, no código de producción para copiar sin
auditoría.

### API prevista

```r
prepareRingResultants(values, radius, reference = NULL, ...)
buildParametricPlot(dataPaths, dataSegments = NULL,
                    dataPolygons = NULL, dataPoints = NULL, ...)
buildRingResultantPlot(prepared, ...)
buildRingResponsePlot(response, radius, ...)
```

`prepareRingResultants()` pertenecerá al dominio y devolverá tablas de eje,
curva, polígonos, ordenadas, extremos, escalas y metadatos.
`buildParametricPlot()` será un renderer XY genérico, sin conocimiento de
$N$, $M$, $Q$ ni del anillo. `buildRingResultantPlot()` será el adaptador de
dominio que compone los tres paneles. El gráfico será una consecuencia de las
tablas preparadas y no el único producto comprobable.

El builder nuevo se implementará y probará primero en este proyecto. No se
modificará NGR 0.3.9 durante esta fase. Sólo después de demostrar reutilización
en otro dominio paramétrico se evaluará promover el renderer genérico a NGR.
No se usarán funciones privadas `NGR:::` ni se creará un supuesto método
`buildPlot.Ring`, porque `buildPlot()` no es un genérico S3.

### Pruebas mínimas

1. ecuación del círculo y cuatro posiciones cardinales;
2. identidad entre desplazamiento radial y resultante normalizada;
3. cierre periódico sin exigir $2\pi$ en la entrada;
4. resultante nula;
5. resultante constante positiva y negativa;
6. armónico $\cos2\theta$ con extremos y cruces conocidos;
7. invariancia al escalar simultáneamente valor y referencia;
8. independencia entre escalas de $N$, $M$ y $Q$;
9. rechazo de $R+\Delta r\leq0$;
10. adaptación angular explícita para comparadores fuente-nativos;
11. orden paramétrico correcto con abscisa no monótona y filas barajadas;
12. cierre y signo de cada polígono después de insertar ceros;
13. misma longitud en píxeles y mismos límites para cada par de ejes;
14. asociación inequívoca de cada serie a su par `xAxis`–`yAxis`;
15. serialización HTML con `polygon`, separadores `NULL` y metadatos físicos;
16. exportación SVG y PNG con las dimensiones fuente declaradas;
17. regresión visual secundaria, posterior a las pruebas numéricas.

El campo idénticamente nulo debe ser un caso válido: se dibujará la directriz
sin banda ni ordenadas y conservará una escala de referencia declarada. La
autoescala no podrá dividir por cero ni ocultar que dos casos usan escalas
distintas.

El HTML es el producto nativo. El runtime auditado carga `highcharts-more.js`,
`exporting.js` y `offline-exporting.js`; por tanto, `polygon` y el menú local de
SVG/PNG están disponibles. La exportación programática y la prueba de PNG aún
deben cerrarse y se mantendrán `UNKNOWN` hasta verificar el artefacto. Se fijará
`fallbackToExportServer = FALSE` para no enviar configuraciones a un servidor
público si falla la exportación local.

Fuentes de implementación: manual de
[`highcharter` 0.9.5](https://cran.r-project.org/web/packages/highcharter/highcharter.pdf),
[serie `polygon`](https://api.highcharts.com/highcharts/plotOptions.polygon),
[posición de ejes](https://api.highcharts.com/highcharts/xAxis.left),
[ancho de ejes](https://api.highcharts.com/highcharts/xAxis.width) y
[exportación local](https://www.highcharts.com/docs/export-module/client-side-export).
La documentación web de Highcharts corresponde hoy a una versión posterior;
ninguna opción se aceptará sin comprobarla contra el bundle 9.3.1 instalado.
La licencia de Highcharts aplicable al proyecto queda `UNKNOWN` y deberá
confirmarse antes de publicar.

`ggplot2` sólo se activará si una prueba reproducible demuestra al menos una de
estas fallas bloqueantes en el runtime fijado: imposibilidad de conservar la
escala 1:1 en el HTML y en el artefacto exportado, corrupción de los polígonos
firmados, o imposibilidad de producir la salida estática exigida por el
informe. Una preferencia estética o la necesidad de ajustar etiquetas no son
motivo suficiente para cambiar de renderer.

## 8. Frente paralelo de especificaciones

El archivo existente
`_chapters/specifications.inspection.es.md` se conservará como
borrador de trabajo. No es todavía una especificación auditable: contiene
frecuencias, porcentajes, categorías y operaciones invasivas sin una fuente o
autoridad demostrada.

### 8.1 Productos del frente

1. ledger de normas, edición, acceso, alcance y afirmación permitida;
2. matriz maestra de requisitos con ID, fuente, responsable y estado;
3. registro de datos requerido por el cálculo;
4. plan de inspección y muestreo por mecanismo de daño;
5. QA/QC, calibración, incertidumbre y esquema de entrega;
6. matriz demanda–resistencia–decisión;
7. redline del borrador actual que preserve las propuestas no aprobadas.

### 8.2 Puntos de parada

No se fijarán como requisitos hasta contar con evidencia o decisión explícita:

- espaciamiento o porcentaje de muestreo;
- grados visuales o semáforos de pérdida;
- umbrales de espesor o corrosión;
- torque de pernos existentes;
- extracción de pernos o probetas;
- limpieza o remoción de recubrimiento;
- estados límite y factores de aceptación.

Las operaciones que modifiquen la protección o la estructura requieren
autorización, secuencia, reposición y control de estabilidad.

### 8.3 Interfaz con la sección corrugada y los pernos

Antes de redactar criterios finales se cerrarán tres contratos:

1. registro de sección y juntas: dimensiones, propiedades, tolerancias y
   evidencia;
2. registro de demanda: $N,M,Q$, ángulo, signo, combinación y estadístico;
3. registro de capacidad: modo de falla, ecuación, fuente, factores y datos
   requeridos.

El frente de especificaciones no inventará capacidad. El frente de sección
corrugada y conexiones no adoptará dimensiones o propiedades no verificadas.

## 9. Frentes de trabajo y dependencias

### Frente M — Metodología y R, camino crítico

1. cerrar la Puerta M0 de reconciliación entre documentación y R;
2. hidratar la fuente de verdad;
3. cerrar símbolos, ecuaciones, ejemplos y benchmarks;
4. producir casos determinísticos y envolventes Monte Carlo;
5. hidratar `methodology.practice.es.md`,
   `methodology.pressures.es.md` y `methodology.model.es.md`;
6. hidratar `methodology.benchmarks.es.qmd` y
   `methodology.results.es.qmd`.

### Frente O — Sección corrugada

1. fijar una designación normalizada o una geometría completa de control y su
   espesor;
2. obtener $A_p$ e $I_p$ de una tabla autorizada; usar integración geométrica
   sólo si no existe tabla para el perfil o como control opcional;
3. calcular $E_sA_p$, $E_sI_p$, $\eta$, $\bar t$ y $\bar E$;
4. reproducir una fila NCSPA y el ejemplo $152\times51\times3\ \mathrm{mm}$ de
   Mai;
5. auditar que `ringDirect.R` usa $\eta$ y adaptar el cierre uniforme de
   `ringFourier.R` para recibir la misma entrada;
6. demostrar la paridad directo–Fourier y el límite de pared lisa;
7. después de cerrar la sección, pasar $E_s$, $A_p$ e $I_p$ a CANDE y
   reproducir sus parámetros de interacción;
8. mantener la sección fija en Monte Carlo, salvo que se apruebe incertidumbre
   de espesor o geometría;
9. hidratar `methodology.corrugation.es.md` después de esos benchmarks.

Este frente termina en $N(\theta)$, $M(\theta)$, $Q(\theta)$ y sus
extremos/envolventes. La conversión posterior a $\sigma_*$, $\tau_*$,
capacidades o demandas de pernos no forma parte de esta puerta.

### Frente S — Especificaciones

1. construir el ledger normativo;
2. auditar inspección, UT, geometría, corrosión y conexiones;
3. desarrollar plan de muestreo y QA/QC;
4. incorporar requisitos del Frente O;
5. redactar los diez módulos de especificación.

### Frente P — Presentación reproducible

1. resolver setup, captions y los adaptadores mínimos del hito R0;
2. producir primero una tabla y una figura estática desde los productores R
   canónicos para el render de revisión;
3. implementar `prepareRingResultants()` y sus pruebas geométricas;
4. implementar `buildParametricPlot()` y `buildRingResultantPlot()` con
   `highcharter`;
5. comprobar escala 1:1, HTML y exportación SVG/PNG;
6. completar los adaptadores `scripts/tbl` y `scripts/fig`;
7. completar los fragmentos `_tbl` y `_fig`;
8. validar HTML y salida estática.

Los agentes de cada frente trabajarán en archivos propios. Un único integrador
modificará la fuente de verdad y los capítulos públicos para evitar escritores
concurrentes.

## 10. Fases y puertas de aceptación

### Fase 0 — Saneamiento lógico

- registrar qué capítulos son heredados;
- preservar artefactos de productor `UNKNOWN`;
- fijar la metodología auditada y la suite R como baseline;
- no cambiar todavía el master público.

**Puerta:** inventario y ownership resueltos para todo archivo que vaya a
reemplazarse.

### Puerta M0 — Reconciliación entre implementación y documentación

**Estado:** cerrada para R0 el 10 de agosto de 2026.

- declarar `solveRingDirect()` como solver público y Fourier como comparador
  en el master, resumen, práctica, modelo, incertidumbre y benchmarks;
- reemplazar en `methodology.uncertainty.es.md` las funciones inexistentes y
  el ejemplo basado en la API histórica por la API R efectivamente probada;
- retirar toda mención a FORM/FOSM y a probabilidades de falla;
- conectar benchmarks y figuras con los productores canónicos de
  `TITO/kb`, sin usar copias heredadas de procedencia distinta;
- incorporar la clasificación del aporte Python, sin migrar los elementos
  rechazados;
- marcar `PLAN-reinicio-metodologia.md` como baseline histórico sustituido
  por este plan y normalizar los nombres canónicos restantes.

**Puerta:** la documentación no contradice la API R, no promete funciones
inexistentes y cada artefacto público tiene un productor identificado.

### Fase 1 — Fuente de verdad isotrópica para revisión

- matriz de práctica profesional;
- ecuaciones y símbolos consolidados;
- un ejemplo determinístico completo y barridos de $H_0$ y $K_0$;
- contrato Monte Carlo de realizaciones, cuantiles y envolventes;
- bibliografía mínima conectada a ecuaciones, métodos y benchmarks centrales;
- interfaz de datos hacia especificaciones.

**Puerta:** cada ecuación y valor tiene fuente, página o etiqueta de derivación;
la suite R continúa pasando.

### Hito R0 — Primera revisión: metodología de resultantes auditable

R0 es el primer render que se entregará para revisión técnica. No es un
render de conveniencia ni un documento completo. Debe incluir:

1. `methodology.summary.es.md`, `methodology.practice.es.md`,
   `methodology.pressures.es.md`, `methodology.model.es.md`,
   `methodology.uncertainty.es.md`, `methodology.corrugation.es.md` y
   `methodology.sources.es.md`
   reconciliados con la API R;
2. `methodology.benchmarks.es.qmd` consumiendo sólo datos generados y
   preservados en `TITO/kb/benchmarks`, con rutas y productores explícitos,
   incluida la sección corrugada de control;
3. `methodology.results.es.qmd` con un caso didáctico producido por R que
   recorra cargas, tracciones, $A_p$, $I_p$, $\eta$, solución directa,
   $N,M,Q$ y extremos;
4. al menos una tabla y una figura provenientes de los productores R
   canónicos;
5. citas resolubles para las ecuaciones y métodos centrales;
6. suite R con salida satisfactoria y render QRT con salida cero, seguido de
   una inspección visual del HTML.

R0 puede declarar fuera de alcance $\sigma_*$, $\tau_*$, tensiones locales,
capacidades, pernos, especificaciones finales y el gráfico Highcharter
definitivo. No puede omitir la sección corrugada equivalente ni incluir
distribuciones inventadas o resultados del túnel real sin un registro de
entradas aprobado.

La forma de render instalada y el destino esperados son:

```bash
qrt render _master/methodology.es.qmd --profile html
```

```text
html/methodology.es/index.html
```

**Disponibilidad para revisión:** el primer HTML quedó renderizado en
`html/methodology.es/index.html`. El master presenta `solveRingDirect()` como
motor, Fourier como comparador, consume los CSV y PNG canónicos e incluye la
aplicación numérica y sus benchmarks. La revisión técnica del usuario es la
siguiente puerta; el gráfico Highcharter definitivo no forma parte de R0.

### Fase 2 — Figuras y tablas

- contratos de datos;
- diagrama paramétrico $N$–$M$–$Q$;
- tablas de métodos, parámetros, extremos y benchmarks;
- figuras de presiones, sensibilidad y envolventes.

**Puerta:** pruebas geométricas, datos–tabla y datos–figura; productor exacto
de cada artefacto.

### Fase 3 — Capítulos metodológicos

- completar los resultados, el apéndice y los productos
  gráficos no requeridos por R0;
- incorporar cross-references, tablas y figuras;
- eliminar duplicaciones y contradicciones.

**Puerta:** revisión técnica en este orden:
`methodology.practice` → `methodology.pressures` → `methodology.model` →
`methodology.uncertainty` → `methodology.benchmarks` →
`methodology.corrugation` → `methodology.results` →
`methodology.appendix`.

### Fase 4 — Especificaciones

- cerrar jerarquía normativa;
- redlinear el borrador existente;
- incorporar requisitos de sección corrugada y pernos;
- redactar módulos y matrices de trazabilidad.

**Puerta:** ningún `debe`, frecuencia o umbral sin fuente o decisión del
propietario.

### Fase 5 — Integración y render final

- crear o actualizar los índices y masters;
- renderizar nuevamente el master metodológico completo;
- corregir referencias, captions y formatos;
- integrar el informe completo;
- resolver `command -v qrt`, verificar su identidad mediante
  `/usr/local/libexec/qrt/BUILD_INFO` (`git_commit`) y consultar
  `qrt render --help` antes de cada render formal;
- declarar el seed exacto (`_master/methodology.es.qmd` para metodología o
  `_master/integrity.es.qmd` para el informe), su perfil efectivo y el comando
  `qrt render <seed> --profile <perfil>`;
- verificar salida cero y el artefacto esperado; renderizar con `qrt`, no con
  `quarto` directo.

Hoy no existe `qrt.manifest.json`. No se inferirá ni generará uno durante la
redacción. Si se necesita declarar un conjunto de artefactos, será una decisión
y una mutación explícita posterior.

**Puerta:** HTML reproducible, enlaces internos válidos, tablas y figuras
visualmente inspeccionadas. La publicación es una acción separada.

## 11. Orden inmediato de ejecución

1. revisar técnicamente el HTML R0 y registrar correcciones por capítulo;
2. acordar los rangos y dependencias del relleno para los barridos de $H_0$,
   $K_0$ y las envolventes Monte Carlo, sin inventar distribuciones;
3. cerrar SC-06 con una sección corrugada publicada en las ramas
   Schwartz–Einstein/CANDE;
4. después de la revisión R0, implementar el diagrama paramétrico Highcharter;
5. completar el apéndice y, con las decisiones externas de la sección 12,
   desarrollar las especificaciones.

## 12. Decisiones externas requeridas antes de cerrar especificaciones

- jurisdicción y norma/edición gobernante;
- carácter contractual o interno de la especificación;
- vida remanente y nivel de confiabilidad buscado;
- acciones operativas, externas y accidentales aplicables;
- disponibilidad de documentación conforme a obra;
- autorización para limpieza, extracción de muestras o torque;
- responsable de la decisión final de aptitud.

Estas decisiones no bloquean la hidratación de la metodología ni el desarrollo
del diagrama paramétrico. Sí bloquean criterios contractuales definitivos.
