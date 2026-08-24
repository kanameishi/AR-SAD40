# Motor R — transferencia y plan de corrección

Documento de traspaso para la sesión que edita el código.
Repuesto el 2026-08-18 con cifras corregidas tras una remedición.

## Advertencia sobre la versión anterior

Una versión previa de este documento y del protocolo fue borrada. Al
reponerla se remidieron todas las cifras y **cuatro eran incorrectas**. Si
alguien conserva una copia de la versión anterior, descartarla.

| Afirmación anterior | Valor real | Instrumento correcto |
|---|---|---|
| 82 % del tiempo en `buildConcreteSectionDomain()` | **22,8 %**; el 69,5 % está en `.validateConcreteDomain()` | `Rprof`; la cifra anterior nunca se midió |
| 26 funciones de más de 200 líneas | **20** | parser de R con `srcref`, no conteo por `awk` |
| 29 helpers de validación | **28** | recuento |
| 24 archivos de test con arranque duplicado | **17 de 19** | recuento sobre el árbol vigente |

La primera era una invención: no hubo medición. Las otras tres provenían de
instrumentos groseros o de un árbol que después cambió.

## Estado de transferencia

- **Repositorio:** `/Users/averrik/Cloud/github/projects/AR-SAD40`
- **Rama y base:** `dev` en `85aa060`
- **Escritor único:** no. Durante el 2026-08-18 hubo al menos dos sesiones
  escribiendo en paralelo. Comprobar `git status` antes de tocar nada.
- **Superficie vigente:** 30 archivos de producción bajo `scripts/R`,
  18 806 líneas, 19 archivos de test.
- **Proceso o agente vivo al cierre:** ninguno.
- **Artefactos de esta tarea:**
  `TITO/kb/research/g10.aci.concrete.verification.audit.es.md` (dictamen de
  hormigón), `scripts/global.R`, este documento y `audit-protocol.md`. Todos
  sin versionar.

## Hechos del plan

- **objetivo (2026-08-18):** auditar la verificación seccional de hormigón y
  el nivel de programación del motor R.
- **ruling (2026-08-18):** la resistencia del hormigón se alinea con
  CIRSOC 804-4 para acompañar los factores de carga adoptados.
- **ruling (2026-08-18):** la auditoría de código se limita a corregir, no a
  optimizar.
- **verdict (2026-08-18):** la mecánica seccional de hormigón es correcta.
  Punto balanceado de la sección de 150 mm verificado a mano contra el
  código: 1322,55 kN/m y 65,46 kN·m/m, coincidencia exacta.
- **verdict (2026-08-18):** la disciplina de nombres cumple `STYLE.md`. Cero
  snake_case, cero sufijos de etapa, contenedores efímeros dentro del
  vocabulario canónico, cero parámetros declarados y no usados, ningún
  `tryCatch` que silencie. No hay renombrado pendiente.
- **verdict (2026-08-18):** los validadores duplicados coinciden en
  comportamiento sobre once entradas límite. Redundancia, no defecto.
- **verdict (2026-08-18):** la colisión `evaluateRingLoad` está aislada en
  ambos consumidores mediante `sys.source()` en entorno propio. No es defecto.
- **run (2026-08-18):** suite completa sobre `85aa060` limpio: 23 de 26
  archivos en verde, 3 en rojo. El árbol cambió después; remedir antes de
  citar esta cifra.
- **no-replay (2026-08-18):** no repetir la lectura del articulado de
  ACI CODE-318-25 ni de CIRSOC 804-4; los localizadores están en el dictamen.
- **next (2026-08-18):** ruling de alcance sobre el Monte Carlo huérfano.

## Parte 1 — Qué es obsoleto y se puede borrar

Método: búsqueda de cada nombre en **todos** los archivos versionados
(`git ls-files`, excluidos binarios). Lo que sólo aparece en su archivo de
definición no tiene consumidor.

### 1.A Borrado seguro — 254 líneas

| Función | Archivo | Líneas |
|---|---|---:|
| `.coverCaseTextToken` | `scripts/R/coverCase.R` | 5 |
| `bakerDiametricLoadSpectrum` | `scripts/R/ringFourier.R` | 33 |
| `combineRingSpectra` | `scripts/R/ringFourier.R` | 45 |
| `scaleRingSpectrum` | `scripts/R/ringFourier.R` | 15 |
| `summarizeRingResponse` | `scripts/R/ringFourier.R` | 116 |
| `ringVerticalStressOrdinates` | `scripts/R/ringLoads.R` | 40 |

`ringVerticalStressOrdinates` aparece además en `scripts/R/README.md`: al
borrarla hay que borrar su bloque documentado.

**`ringFourier.R` no se borra**: lo consumen `runInteractionMethodStudy.R` y
`testRingMethod.R`. Sólo se retiran esas cuatro funciones.

### 1.B Borrado con corrección documental — 169 líneas

`scripts/R/calculationScenarioExample.R` no lo carga ningún archivo ni lo
ejecuta ningún test. Sólo lo menciona el README, que afirma que «comprueba al
final la correspondencia con `calculateScenario()`». Esa comprobación no
ocurre. O se borra con su párrafo, o se convierte en test real.

### 1.C Decisión de alcance — 358 líneas

`ringMonteCarlo.R` y `calculationMonteCarloOutput.R` sólo son alcanzables
desde sus propios tests y no participan de ningún producto. No borrar sin
ruling: la pregunta es de alcance, no técnica.

## Parte 2 — Rendimiento: el cuello real

**Esto faltaba en la versión anterior y es el hallazgo de mayor rendimiento
disponible.**

Perfil de `evaluateCoverCase()` sobre 55,2 s muestreados con `Rprof`:

| Función | % total | % propio |
|---|---:|---:|
| `.validateConcreteDomain` | 69,5 | 8,2 |
| `.concreteSegmentsIntersect` | 61,1 | 24,5 |
| `.concreteCross2D` | 28,9 | 28,9 |
| `buildConcreteSectionDomain` | 22,8 | 0,0 |

El costo no está en construir el dominio sino en **validar que el polígono no
se auto-intersecte**. Ese chequeo es un doble bucle O(n²) sobre los puntos del
perímetro, en `scripts/R/concreteDemand.R`, dentro de `.validateConcreteDomain()`.

Escalado medido sobre un dominio de 150 mm:

| Malla | Puntos del polígono | Construir | Validar | Pares evaluados |
|---:|---:|---:|---:|---:|
| 201 | 288 | 0,35 s | 0,48 s (58 %) | 41 328 |
| 401 | 574 | 0,58 s | 1,45 s (71 %) | 164 451 |
| 601 | 860 | 0,82 s | 3,20 s (80 %) | 369 370 |

La construcción crece de forma lineal; la validación, cuadrática. Con la malla
de 601 que usa la configuración vigente, el 80 % del tiempo de cada dominio se
va en la validación.

Esto es optimización, no corrección: el resultado es correcto. Se registra
porque es la única palanca de rendimiento significativa y porque el estudio
paramétrico construye ocho dominios por corrida.

## Parte 3 — Tablas fuera del scaffold

Un solo archivo viola el patrón de tablas:
`TITO/kb/calculation-memo/chapters/calculation.appendix.verification.review.es.md`.

1. **Tabla pipe escrita a mano** (reproducción del ejemplo HP97). Sus columnas
   «Calculado» contienen salida del motor congelada en prosa —0,735909;
   0,811806; 0,887061; 1,017169 y sus momentos—. Si el modelo cambia, esos
   números quedan obsoletos en silencio y nada lo detecta.
2. **Bloque `knitr::kable()` en línea** dentro del capítulo, que lee
   `TITO/kb/benchmarks/project-hybrid-gradient-verification.csv` directamente
   en vez de pasar por `_tbl/<nombre>.qmd` más `scripts/tbl/<nombre>.R`.

El patrón correcto está en los 31 pares `_tbl/` + `scripts/tbl/` que ya
existen: el capítulo incluye, el wrapper resuelve el caption, el builder lee
el dato. Los 28 archivos `_tbl/*.ES.qmd` restantes son wrappers legítimos con
`{{< include >}}` y no son infracciones.

Atenuante de alcance: ese capítulo **no lo incluye ningún master ni ningún
`_index/`**, así que hoy no está en el producto renderizado. Es una violación
de un capítulo candidato, no del producto vigente.

## Parte 4 — Plan de corrección

### Fase 1 — Runner de la suite

Hay 19 archivos de test y ningún runner que los agregue; un rojo es invisible.
Crear un runner que devuelva código distinto de cero si alguno falla y
registrarlo en `dev/SoT/METHODOLOGY-PHASE2.md` como el comando de verificación.

Regla de arbitraje: si el test arma una entrada que el código ya rechaza, se
corrige el test; si el producto versionado no coincide con el esquema del
código, se regenera el producto, no se relaja la aserción.

### Fase 2 — Retiro de fósil

Aplicar 1.A y 1.B, un commit por bloque, suite en verde antes y después.

### Fase 3 — Ruling de alcance sobre Monte Carlo

### Fase 4 — Rama muerta y contrato de datos

1. `scripts/R/concreteAci31825.R`, línea 818: el bloque
   `if (shellClassificationStatus != "applicable")` asigna `"blocked"` a un
   campo que ya vale `"blocked"`. Borrar.
2. La fila `equal-reinforcement-at-opposite-faces` de `GateChecks` usa
   `demandValue = 0`, `capacityValue` igual a la máxima diferencia entre caras
   y `utilization = 0` fijo, con semántica invertida respecto del resto.
   Severidad baja: sin consumidor hoy.

### Fase 5 — Afirmaciones no establecidas

Además de 1.B: el registro de controles informa `axialLimitStatus = "applied"`
y la memoria habla del «límite axial del artículo 21.2.2.3». Lo aplicado es
sólo el tope del factor de reducción. El límite de resistencia de la
Tabla 22.4.2.1 de ACI CODE-318-25 no está implementado.

### Fase 6 — Tablas fuera del scaffold

Aplicar la Parte 3 cuando ese capítulo entre al producto.

## Parte 5 — Estado de la capa de figuras

Corregido en esta sesión, con `testCalculationFigures.R` en `PASS`:

- `scripts/fig/Calculation.concrete.axial.flexure.R`: se agregó
  `plot.theme = NGR::hc_theme_538_gridlines()` —el idioma de casa, presente en
  20 de 20 builders del scaffold— y `plot.height` pasó de 600 a 750, el valor
  dominante del estándar.
- `::: {.column-page}` eliminado de los seis wrappers que lo tenían. El
  scaffold y AR-S2L1W no usan `column-page`, `column-screen` ni
  `column-body-outset` en ninguna figura o tabla.
- `scripts/global.R` nuevo, enlazado desde `scripts/setup/setup.R`, con
  `FONT.SIZE.BODY` y `FONT.SIZE.HEADER`. Se omitieron `PAGE_WIDTH`,
  `PAGE_HEIGHT`, `FACTOR_WIDTH`, `FACTOR_HEIGHT`, `PALETTE` y `NMAX` porque no
  tienen consumidor ni en el propio scaffold.

**Corrección importante para quien continúe.** Una versión anterior de esta
auditoría afirmaba que «ninguno de los tres builders pasa `plot.theme`, y el
patrón del scaffold lo pasa siempre». Es falso como generalización:

- `Calculation.resultants.R` usa `NGR::buildSectionResultantsPlot`, cuyos
  parámetros son `curves, rays, referenceRadius, panelTitles, positionLabels,
  subtitle, plotHeight`. **No admite tema.**
- `Calculation.classical.comparison.R` **no usa NGR**: arma el gráfico con
  `highcharter::highchart()` y una tubería de `hc_*`.

Sólo uno de los tres usa `buildPlot`, y ya está corregido. No queda
`plot.theme` que extender.

## Parte 6 — Llamadas directas a highcharter: no tocar

En `Calculation.concrete.axial.flexure.R` hay cinco llamadas
`highcharter::` posteriores a `buildPlot`. **No son redundantes con NGR**:
`buildPlot` no expone ninguna de esas capacidades.

1. `hc_plotOptions(series = list(requireSorting = FALSE))` — **estructural**.
   Highcharts exige x ordenada en series de línea. Un dominio P–M es un
   polígono cerrado: medido sobre los datos vigentes tiene ocho cambios de
   dirección en x y abre y cierra en x = 0. Sin esa línea la figura no se
   dibuja.
2. `hc_xAxis` y `hc_yAxis` con `labels format = "{value:.0f}"` — decimales de
   los ejes primarios. `buildPlot` sólo tiene `yAxis2.decimals`.
3. El bucle sobre `Plot$x$hc_opts$series` — oculta de la leyenda las series de
   puntos de demanda y les da un `pointFormat` con interfaz, caso de carga,
   θ, M, P y utilización. `buildPlot` no tiene `showInLegend` ni tooltip por
   serie.
4. `hc_tooltip(valueDecimals = 0)` — decimales globales del tooltip.

## Parte 7 — Lo que NO hay que corregir

- **Nombres y variables efímeras.** Conformes a `STYLE.md`.
- **Validadores duplicados.** 28 helpers, comportamiento coincidente.
  Unificarlos es refactor, no corrección.
- **Manejo de errores.** `stop()` con mensaje de dominio y ningún catch-all.
  Es el punto más fuerte del motor.
- **Trazabilidad de fuentes.** Cada resistencia lleva su `sourceLocator` en el
  dato, no en un comentario.
- **Los 28 `_tbl/*.ES.qmd` sin `source()`.** Son wrappers con
  `{{< include >}}`, que es el patrón correcto.

## Parte 8 — Riesgo conocido, sin corrección propuesta

El puente Wolfram acopla por 36 cadenas de texto que navegan el resultado R
con `$`. Las 36 resuelven contra el objeto vigente. Ningún test las guarda: un
renombre en la estructura de retorno de `evaluateCoverCase()` rompería el
notebook en silencio.

## Parte 9 — Estructura del reporte: dónde va cada cosa

Derivado por comparación con el scaffold QRT instalado (`git_commit=095e982`),
el scaffold PSHA y el proyecto de referencia AR-S2L1W.

### 9.1 Encuadre: qué tipo de proyecto es este

**AR-SAD40 no es un proyecto PSHA.** No tiene `_local/`, `_scope/`,
`_slides/`, `mapper/`, `oq/` ni `gmsp/`, y su `scripts/setup/` no contiene
ninguno de los 21 módulos de dominio del scaffold PSHA. Es un proyecto
gestionado por **QRT** que adoptó la convención de nombres de contenido.

Consecuencia operativa: **no crear** `_local/`, `_scope/`, `_slides/` ni
`mapper/`. Son componentes PSHA y aquí no aplican. `psha init` y `psha pull`
no son herramientas de este proyecto.

### 9.2 Propiedad por directorio

| Directorio | Dueño | Contenido |
|---|---|---|
| `bib/`, `lua/`, `styles/`, `yml/` | **QRT** | Infraestructura de render. Se gestiona con `qrt init`, `qrt status`, `qrt pull`. No editar a mano sin clasificar cada ruta |
| `qrt.manifest.json` | proyecto | Autoridad única del conjunto de artefactos declarados |
| `_master/` | proyecto | Semillas. Una por producto. Declaran `chapters:` y `appendices:` |
| `_index/` | proyecto | Un ensamblador por capítulo. Carga `setup.R`, emite los encabezados y **incluye**; no define lógica de negocio |
| `_chapters/` | proyecto | Prosa. Predominantemente `.md` |
| `_results/` | proyecto | Narrativa de resultados calculados, incluida desde `_index/` |
| `_fig/`, `_tbl/` | proyecto | Por figura o tabla: un `.qmd` base que construye e incluye, y un `.ES.qmd` que resuelve el caption e incluye al base |
| `_captions/` | proyecto | `fig.<nombre>.ES.md` y `tbl.<nombre>.ES.md` |
| `scripts/setup/` | proyecto | `setup.R` defaults, `utils.R` helpers, `cover.R` portada, y el `report.R` de ayudantes de capítulo |
| `scripts/fig/`, `scripts/tbl/` | proyecto | Builders. Un archivo por figura o tabla |
| Raíz | proyecto | `index.qmd` y `params.yml` |

Regla de flujo, verificada en los 31 pares existentes: **el capítulo incluye,
el wrapper resuelve el caption, el builder lee el dato**. Ningún capítulo
construye una tabla o una figura.

### 9.3 Divergencias medidas, en orden de severidad

**D1 — `qrt.manifest.json` — RESUELTO 2026-08-18.** Creado por pedido
explícito del usuario, con los dos artefactos reales: `report.es` y
`methodology.review.es`, ambos `kind: quarto`, `profile: book`, hacia
`html/<alias>`. `qrt render --manifest qrt.manifest.json --dry-run` resuelve
las dos tareas correctamente.

Convención derivada de los siete manifiestos preexistentes bajo
`~/github/projects/` (ocho archivos en total contando el de este proyecto):
`schemaVersion: 2` en 7 de 7; `siteSlug` en 7 de 7 con la forma
`<project_id en minúscula y sin guion>-<sufijo>`; `domain` igual a
`<siteSlug>.srk.ar` en 6 de 7.

Dos reglas comprobadas por búsqueda exhaustiva sobre los 7: **ningún** slug
es el identificador de proyecto pelado sin sufijo, y **ningún** dominio
carece de subdominio de proyecto. Por eso «slug `arsad40` con dominio
`srk.ar`» se interpreta como el par raíz, y cada artefacto recibe
`arsad40-<sufijo>` y `arsad40-<sufijo>.srk.ar`.

Regla adicional comprobada sobre los 7: `siteSlug` es
`<projectid>-<alias>` en **todos** los artefactos, con una sola familia de
excepciones —los alias con sufijo de idioma (`report.es`, `report.en`,
`memo.es`), donde el sufijo se colapsa al código de idioma—. Este proyecto no
tiene segundo idioma, de modo que esa excepción no aplica y los alias no
llevan sufijo `.es`.

Valores adoptados, con el alcance declarado por el usuario —dos reportes,
memoria y metodología, y nada más—:

| Alias | Producto | siteSlug | domain | renderSource |
|---|---|---|---|---|
| `report` | memoria | `arsad40-report` | `arsad40-report.srk.ar` | `_master/report.es.qmd` |
| `model` | metodología | `arsad40-model` | `arsad40-model.srk.ar` | `_master/methodology.review.es.qmd` |

El alias es el asa de selección y no tiene por qué reproducir el nombre de la
semilla: hay precedente en los manifiestos observados, donde `at` apunta a
`_master/srs.at.qmd`. El campo `path` sí reproduce la salida real del render,
`html/<stem>`, que es donde `qrt` deposita el artefacto.

`required: true` en ambos. `QRT.md` aclara que el campo no controla la
selección; las reglas del repositorio declaran los dos como productos
vigentes.

Declarar `siteSlug` y `domain` **no despliega nada**. No existe
`.netlify/sites.env` en el repositorio, ningún sitio fue creado y no se
ejecutó ningún deploy. El registro del sitio y el enlace del dominio son
efectos aparte, con sus propias compuertas en `QRT.md`.

**Corrección de una afirmación falsa de una versión anterior.** Ese texto
decía que AR-S2L1X es «el análogo estructural más cercano: reportes `book`,
sin decks, sin `toc`», y lo usaba para justificar la omisión de `domain`. Es
falso: AR-S2L1X declara `audit` con `profile: revealjs`, tiene `_slides/` y
cuatro semillas en `_master/`. La analogía fue fabricada para respaldar una
decisión ya tomada. La convención dominante es declarar `domain`, y así se
hizo.

**D2 — recurso inexistente — RESUELTO 2026-08-18.** `yml/_quarto-book.yml`
declaraba `resources: - ref/**`. El directorio `ref/` no existe aquí; existe
`_ref/`, que es material de trabajo y que las reglas locales excluyen de
inspección. Ninguna otra fuente del proyecto menciona `ref/`. Se eliminó la
entrada; quedó sólo `styles/**`.

Corrección de encuadre: `ref/` **no es un producto ni un directorio de QRT**.
Es un directorio de recursos del proyecto. Una versión anterior de este
documento lo insinuó dentro del ámbito de QRT y era incorrecto.

**D3 — Siete capítulos son `.qmd` sin código.** El estándar de `_chapters/`
es prosa en `.md`: el scaffold tiene 100 `.md` contra 4 `.qmd`. Este proyecto
tiene 7 y 7. Los siete `.qmd` tienen **cero líneas de código R** medidas:
`introduction.es.qmd`, `k0.appendix.es.qmd`, `liner.existing.es.qmd`,
`model.actions.es.qmd`, `model.basis.es.qmd`, `reference.appendix.es.qmd` y
`rehabilitation.shotcrete.es.qmd`. Renombrarlos a `.md` y actualizar los
`{{< include >}}` que los referencian.

**D4 — Ayudantes de capítulo duplicados dentro de los ensambladores.**
Confirmado por recuento sobre el árbol vigente, y es más grave de lo que
decía la versión anterior:

| Archivo | Funciones definidas |
|---|---|
| `_index/executive.ES.qmd` | `ReportExtreme`, `ReportAashtoCheck` |
| `_index/liner.ES.qmd` | `ReportExtreme`, `ReportAashtoCheck` |
| `_index/rehabilitation.ES.qmd` | `ReportConcreteCase`, `FormatStrengthFactor` |

`ReportExtreme` (13 líneas) y `ReportAashtoCheck` (11 líneas) son **idénticas
carácter por carácter** en `executive.ES.qmd` y `liner.ES.qmd`, verificado con
`diff`. Eso es lógica de negocio duplicada tras dos puntos de entrada, un
hard stop de `PRACTICE.md`.

En el estándar esa lógica vive en `scripts/setup/report.R`, que el ensamblador
carga junto a `setup.R`. Este proyecto no lo tiene. Crearlo y mover ahí las
seis funciones.

**D5 — `_results/` existe y está vacío.** O se usa para la narrativa de
resultados calculados, o se elimina. Un directorio canónico vacío sugiere una
estructura que no se completó.

**D6 — `scripts/global.R` — REVERTIDO 2026-08-18.** Fue un error crear ese
archivo. `global.R` es un nombre con significado establecido en el scaffold:
`scripts/setup/global.R` son 103 líneas de carga de tablas OpenQuake
(`UHSTable`, `GMPETable`, `AEPTable` y once más). Usar ese nombre para
constantes de presentación era una colisión de significado.

Tampoco había un `global.R` propio que hidratar: este proyecto no tenía
ninguno, y el del scaffold es inaplicable porque no existe `oq/` aquí.

Resuelto plegando `FONT.SIZE.BODY` y `FONT.SIZE.HEADER` dentro de
`scripts/setup/setup.R`, junto a las demás constantes de presentación que ya
vivían ahí (`THIN_LINE_SIZE`, `MID_LINE_SIZE`, `THICK_LINE_SIZE`, `HC.THEME`,
`GG_THEME`), con el mismo idioma de guarda. `scripts/global.R` fue eliminado y
no queda ninguna referencia.

### 9.4 Lo que ya está conforme

No tocar: `_master/` con una semilla por producto; los 31 pares
`_fig`/`scripts/fig` y `_tbl`/`scripts/tbl`; los 28 wrappers `.ES.qmd` con
`{{< include >}}`; `_chapters/` con **0 % de código R**, más limpio que el
propio scaffold, que tiene 22 %; `index.qmd` y `params.yml` en raíz.

### 9.5 Por qué no se normalizó en esta sesión

El árbol tenía 138 archivos sucios y otra sesión escribiendo en paralelo,
incluida la capa de figuras. Renombrar capítulos y mover ayudantes toca
`{{< include >}}` en varios archivos a la vez y habría chocado. La
normalización se ejecuta con el árbol limpio y la suite en verde, en el orden
D2 → D3 → D4 → D5, dejando D1 y D6 para ruling del usuario.

## Parte 10 — Renombre de las semillas de `_master/` (pendiente)

Instrucción para la sesión que edita el código. **No ejecutado en esta
sesión**: al momento de decidirlo, `_master/report.es.qmd` y
`_master/methodology.review.es.qmd` estaban ambos modificados por la otra
sesión, junto con `dev/SoT/METHODOLOGY-PHASE2.md` y `scripts/R/README.md`,
sobre 312 archivos sucios. Renombrar archivos en edición ajena pierde trabajo.

### 10.1 Motivo

Los alias del manifiesto son `report` y `model`. Las semillas conservan
nombres con sufijo de idioma (`report.es.qmd`, `methodology.review.es.qmd`)
que ya no describen nada: este proyecto no tiene segundo idioma.

### 10.2 Restricción que condiciona el nombre

`QRT.md` fija una correspondencia entre el **nombre de la semilla** y el
**perfil de render**. No tiene ninguna relación con sitios ni dominios:

> «it is bound to the seed qmd — `report.*.qmd` renders with `book`»

Comprobación sobre los 7 manifiestos preexistentes: **todos** los artefactos
con `profile: book` renderizan desde `_master/report.en.qmd` o
`_master/report.es.qmd`. No hay ni un solo precedente de una semilla `book`
que no se llame `report.*.qmd`.

Por lo tanto, nombrar la metodología `_master/model.qmd` produciría un
artefacto `book` cuya semilla contradice esa correspondencia y no tiene
precedente. La forma que satisface a la vez el alias elegido y la
correspondencia de perfil es `_master/report.model.qmd`.

### 10.3 Decisión pendiente del usuario

| Producto | Alias | Opción A (respeta la correspondencia de perfil) | Opción B (sigue el alias) |
|---|---|---|---|
| memoria | `report` | `_master/report.es.qmd` sin cambio | `_master/report.qmd` |
| metodología | `model` | `_master/report.model.qmd` | `_master/model.qmd` |

`report.qmd` tampoco tiene precedente: las siete instancias observadas llevan
token (`report.es`, `report.en`). No ejecutar hasta que el usuario elija.

### 10.4 Procedimiento, una vez elegido el nombre

Ejecutar con el árbol limpio y la suite en verde. El `stem` cambia, y con él
la ruta de salida `html/<stem>`; hay que actualizar todo lo que la nombra.

1. `git mv` de las semillas en `_master/`.
2. `qrt.manifest.json`: actualizar `renderSource` y `path` de ambos
   artefactos. Los `alias`, `siteSlug` y `domain` **no cambian**.
3. `scripts/R/testCalculationResultantsDom.R`: lee
   `html/report.es/_index/liner.ES.html`. Actualizar la ruta.
4. Menciones en prosa: `AGENTS.md`, `README.md`,
   `dev/SoT/METHODOLOGY-PHASE2.md` y `scripts/R/README.md` nombran las
   semillas, las rutas de salida, o ambas.
5. `qrt render --manifest qrt.manifest.json --dry-run` debe resolver dos
   tareas con las rutas nuevas.
6. Re-renderizar ambos artefactos. **No mover ni copiar a mano** los
   directorios de salida: `QRT.md` lo prohíbe expresamente y registra pérdida
   de documentos como resultado observado. Los directorios antiguos bajo
   `html/` quedan huérfanos; su eliminación es una decisión aparte del
   usuario.
7. Correr la suite completa.

### 10.5 Lo que no cambia

`alias`, `siteSlug` y `domain` son independientes del nombre de archivo. El
alias es el asa de selección y ya hay precedente de que difiera de la semilla:
en los manifiestos observados, `at` apunta a `_master/srs.at.qmd`.

## Parte 11 — `_fig/`: violaciones de convención de nombres y patrón

Auditoría de sólo lectura sobre 13 `.qmd` y 2 `.png` en `_fig/`, contrastada
contra los 57 archivos de `_fig/` del scaffold PSHA y contra `STYLE.md`.
Nada fue modificado.

### 11.1 Violaciones confirmadas

**F1 — Dos PNG dentro de `_fig/`.** `biaxialRingResponse.png` (262 KB) y
`fhwaStageResponse.png` (221 KB). El `_fig/` del scaffold contiene
**únicamente `.qmd`**: es un directorio de includes, no de activos. Este
proyecto ya tiene `_images/` para imágenes. Además, `QRT.md` advierte que el
barrido de recursos del renderizador recorre el árbol del proyecto y no
consulta Git, de modo que todo lo que quede ahí entra al artefacto publicado.
Mover ambos a `_images/` y actualizar sus referencias.

**F2 — Wrapper huérfano.** `Calculation.classical.comparison.ES.qmd` existe
sin su base `Calculation.classical.comparison.qmd`. Los otros seis pares
están completos. El patrón del scaffold es base `.qmd` más wrapper `.ES.qmd`
que la incluye; ese archivo hace las dos cosas a la vez.

**F3 — Lectura de captions fuera del helper.** El scaffold usa
`readCaption()` en **17 de 17** wrappers. Este proyecto usa `readLines()` con
ruta literal en **6 de 7**, y `readCaption()` sólo en `liner.profile.ES.qmd`.
`readCaption()` es el helper de `scripts/setup/utils.R` que resuelve
`_captions/<nombre>.md` y falla con mensaje propio si el caption no existe;
`readLines()` con ruta literal no valida nada y duplica la ruta en cada
archivo. Migrar los seis.

**F4 — Profundidad de nombre fuera de rango.** `STYLE.md` admite el punto en
R como calificador de familia corta, «cuando la identidad base es
significativa y las variantes coexisten de verdad», y exige revisión de
diseño para identificadores de cinco o más palabras.

| Segmentos | Scaffold | AR-SAD40 |
|---:|---:|---:|
| 1 | 25 | 0 |
| 2 | 31 | 4 |
| 3 | 1 | 3 |
| 4 | 0 | 2 |
| 5 | 0 | 4 |

El máximo del scaffold es `MCE.MDE.Vs30`, con tres. Este proyecto llega a
cinco: `Calculation.concrete.t100.axial.flexure` y
`Calculation.concrete.reinforced.axial.flexure`. Ahí el punto ya no es un
calificador de familia sino una jerarquía codificada en el nombre, que es lo
que `STYLE.md` marca como parada.

Cuatro archivos con cinco segmentos y dos con cuatro requieren revisión de
diseño antes de renombrar: el nombre corto correcto depende de qué familia se
quiera preservar, y esa es una decisión del usuario, no mecánica.

**F5 — Inicial inconsistente.** Conviven `Calculation.*` con mayúscula,
`liner.profile` con minúscula y los dos PNG en camelCase
(`biaxialRingResponse`, `fhwaStageResponse`). El scaffold también mezcla —37
con mayúscula y 20 con minúscula— así que la inicial no es regla dura; lo que
sí es defecto es que en catorce archivos convivan tres estilos sin criterio
declarado.

### 11.2 Sospechas medidas y descartadas — no corregir

**No es violación que varias figuras compartan un builder.**
`Calculation.resultants.R` sirve a tres figuras y
`Calculation.concrete.axial.flexure.R` a dos. Se comprobó que el scaffold
tampoco es uno a uno: **24 de sus 39 figuras base no tienen builder
homónimo** (`AF.Vs30`, `DEQ.closure`, `srs.*`, `UHS.TR`, entre otras).

**No es violación que el nombre del caption difiera del de la figura.** Los
archivos de resultantes emiten tres subfiguras cada uno —normal, momento y
corte— y por eso leen `fig.Calculation.normal`, `fig.Calculation.moment` y
`fig.Calculation.shear`. Verificado: cuatro archivos declaran 3 captions y
tres declaran 1.

### 11.3 Estado real de cada hallazgo — 2026-08-18

**Esta sección faltaba y su ausencia causó un malentendido.** La Parte 11 se
escribió como auditoría, se aplicaron cambios después, y el documento no se
actualizó. Quien lo leyó lo tomó como lista de pendientes y atribuyó a estado
preexistente una corrupción que era reciente.

| | Estado | Quién |
|---|---|---|
| F1 — PNG en `_fig/` | **ABIERTO**: `biaxialRingResponse.png` y `fhwaStageResponse.png` siguen ahí | — |
| F2 — wrapper huérfano | **APLICADO** | esta sesión |
| F3 — `readLines` → `readCaption` | **APLICADO** | esta sesión |
| F4 — profundidad de nombre | **RESUELTO** antes de aplicarse nada: máximo 2 segmentos | la otra sesión |
| F5 — inicial inconsistente | **RESUELTO**: 13 de 13 con mayúscula | la otra sesión |

**F3, detalle de lo aplicado.** Se migraron 11 cargadores de caption en cinco
wrappers (`PM.shotcrete100`, `PM.shotcrete150`, `Resultants.liner`,
`Resultants.shotcrete100`, `Resultants.shotcrete150`) y 3 guardas en la base
`Resultants.liner.qmd`, de `paste(readLines(...), collapse = "\n")` a
`readCaption(...)`.

**Defecto introducido y reparado en la misma sesión.** La migración se hizo
con una expresión regular que en dos archivos casó de menos y dejó la cola
huérfana:

```r
CAP.PM100 <- readCaption("fig.PM.shotcrete100.ES"),
  collapse = "\n"
)
```

Afectó a `_fig/PM.shotcrete100.ES.qmd` y `_fig/PM.shotcrete150.ES.qmd`.
Ambos reparados. **No era corrupción preexistente**: la introdujo esta sesión
el 2026-08-18.

Causa raíz de que se escapara: la única verificación fue un `grep` que
comprobaba la ausencia del idioma viejo, no que el R resultante parseara. Un
`grep` de lo que se quitó no prueba la validez de lo que quedó.

**Verificación añadida.** Se parsean ahora todos los chunks `{r}` de `_fig/` y
`_tbl/`: 73 archivos, **0 errores de sintaxis**. Ese control debe correrse
después de cualquier edición mecánica sobre los chunks.

**F2, detalle de lo aplicado.** Se creó la base `_fig/Comparison.qmd` y se
reescribió `_fig/Comparison.ES.qmd` como wrapper que resuelve los tres
captions y la incluye. La base **no** lleva guardas `if (!exists(...))`
porque los captions en inglés `fig.Comparison.*.md` no existen —sólo los
`.ES.md`— y no corresponde inventarlos. `Resultants.liner.qmd` sí conserva
sus guardas porque sus captions `.md` existen.

### 11.4 Pendiente

F1 sigue abierto. F4 y F5 ya no requieren ruling: los resolvió la otra sesión
renombrando `_fig/` completo.

## Parte 12 — Notación de interfaz: problema abierto, sin resolver

**Estado: NO RESUELTO. Requiere verificación independiente.**

Advertencia previa para quien lo tome: el auditor que escribió esta sección
cambió de interpretación dos veces sobre el mismo material y el usuario marcó
ambas como alucinación. **No confiar en la lectura, sólo en las mediciones.**
Todo lo que sigue está separado en hechos medidos y en interpretaciones
retiradas.

### 12.1 Hechos medidos y reproducibles

Medición sobre el objeto que devuelve `evaluateCoverCase()`, recorriendo cada
data frame del resultado y listando los valores únicos de `caseID` e
`interfaceID`:

| Estructura | `caseID` | `interfaceID` |
|---|---|---|
| `$interaction` | `alpha-0`, `alpha-1` | `full-traction`, `normal-only` |
| `$resultants` | `alpha-0`, `alpha-1` | `full-slip`, `no-slip` |
| `$extrema` | `alpha-0`, `alpha-1` | `full-slip`, `no-slip` |
| `$hybridGradient` | `alpha-0`, `alpha-1` | `full-slip`, `no-slip` |
| `$summary` | — | `full-slip`, `no-slip` |
| `$schwartzEinsteinComparison` | — | `full-slip`, `no-slip` |
| `$assessment$aci$*` | `alpha-0`, `alpha-1` | `full-slip`, `no-slip` |
| `$assessment$mechanical` | `alpha-0`, `alpha-1` | `full-slip`, `no-slip` |

Cruce por caso, sobre el mismo revestimiento:

| `caseID` | `interfaceID` en `$interaction` | `interfaceID` en `$resultants` |
|---|---|---|
| `alpha-1` | `full-traction` | `full-slip` |
| `alpha-0` | `normal-only` | `no-slip` |

Configuración declarada en `scripts/config/cover.method.mesh.2026-08-16.json`:

```json
{"caseID": "alpha-1", "interfaceID": "full-traction", "tangentialMultiplier": 1.0, "comparisonInterfaceID": "full-slip"}
{"caseID": "alpha-0", "interfaceID": "normal-only",   "tangentialMultiplier": 0.0, "comparisonInterfaceID": "no-slip"}
```

Otros hechos verificados:

- `scripts/R/ringInteraction.R:216`:
  `# Four published branches: external/excavation x fullSlip/noSlip.`
- `scripts/R/ringInteraction.R:376`:
  `"full-slip and no-slip are discrete limiting interfaces"`
- `scripts/R/coverInteractionScenario.R`, líneas 162, 165 y 167: el
  multiplicador tangencial entra en los coeficientes como
  `(1 + 2 * tangentialMultiplier) / 6`, `(2 + tangentialMultiplier) / 12` y
  `(2 + tangentialMultiplier) / 6`.
- `_chapters/methodology.load.interaction.es.md` define
  `P_t(θ) = α p_t*(θ)` con `0 ≤ α ≤ 1`, y declara que α = 1 es la proyección
  tangencial completa y α = 0 una acción exclusivamente normal.
- Escriben el rótulo largo en castellano: `scripts/tbl/Calculation.extrema.R`,
  `scripts/tbl/Calculation.interaction.R`,
  `scripts/tbl/Calculation.shotcrete.checks.R` y `scripts/fig/PM.R`.
- Cuatro tablas ya usan `$\alpha$` con valores `1` y `0`:
  `Calculation.extrema.R`, `Calculation.inputs.R`,
  `Calculation.interaction.R` y `Calculation.classical.comparison.R`.
- `\alpha` aparece además en `_chapters/methodology.appendix.es.md` como
  ángulo geométrico `\alpha(y)`, cuatro veces.

### 12.2 Interpretaciones retiradas

Ninguna de estas debe usarse como base de una corrección:

1. «`full-traction`/`normal-only` y `full-slip`/`no-slip` son dos conceptos
   distintos y la distinción importa» — retirada.
2. «Hace falta crear un símbolo nuevo para la interfaz Schwartz–Einstein» —
   retirada.
3. «La correspondencia está invertida respecto del significado físico» —
   retirada como conclusión; el hecho medido es la correspondencia de la
   tabla de cruce, no su corrección.

### 12.3 Lo que hay que resolver

Formulado como preguntas, no como diagnóstico:

1. ¿Por qué `interfaceID` toma dos conjuntos de valores distintos según la
   estructura del resultado?
2. ¿Los resultantes del proyecto, parametrizados por α, deben rotularse con
   los nombres de las ramas de Schwartz–Einstein, o con su propio α?
3. ¿El emparejamiento `alpha-1 ↔ full-slip` y `alpha-0 ↔ no-slip` de la
   configuración es intencional o un error?
4. Una vez resuelto lo anterior, ¿qué notación va en las celdas de las
   tablas? El usuario pidió símbolos en las celdas y explicación en los
   captions, no frases.

### 12.4 Alcance de cualquier cambio

`interfaceID` con valores `full-slip`/`no-slip` aparece en once estructuras
del resultado, incluidas las que consumen las comprobaciones ACI. El puente
Wolfram navega el resultado por 36 rutas de texto sin ningún test que las
proteja (Parte 8). Renombrar ese campo toca el contrato de datos.
