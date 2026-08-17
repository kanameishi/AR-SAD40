# Implementación R del anillo circular

R es la única implementación de producción. La planilla Wolfram consume la
frontera pública R y presenta el cálculo sin duplicar sus ecuaciones; Fourier
se conserva como comparador modal independiente.

El producto del cálculo vigente son los resultantes $N(\theta)$, $M(\theta)$ y
$Q(\theta)$ y sus extremos/envolventes. La evaluación resistente de la chapa
se realiza mediante la rama AASHTO aplicable a conductos corrugados; AISI se
conserva sólo como antecedente. Las alternativas de hormigón simple y armado
se resuelven por separado con sus propias rigideces y comprobaciones locales
ACI. El cálculo no obtiene tensión local a partir de $Q$ ni calcula demandas
de pernos.

La metodología vigente está en
[`_master/methodology.review.es.qmd`](../../_master/methodology.review.es.qmd).

## Carga de la API

```r
projectRoot <- normalizePath(".")
source("scripts/setup/calculationFunctions.R")
```

No cargue `ringFourier.R` en el mismo entorno global: conserva nombres
históricos, entre ellos `evaluateRingLoad()`. Para una comparación aislada:

```r
Fourier <- new.env(parent = globalenv())
sys.source("scripts/R/ringFourier.R", envir = Fourier)
```

## Contrato numérico

- `theta` está en radianes, comienza en 0, es estrictamente creciente y no
  incluye $2\pi$.
- `radial(theta)` es positiva hacia afuera.
- `tangential(theta)` es positiva en el sentido creciente de `theta`.
- `normalForce` es positiva a tracción.
- Todas las entradas deben pertenecer a un sistema coherente. No hay conversión
  automática de unidades.
- Una carga válida debe tener resultante global y momento central nulos.
  `solveRingDirect()` la rechaza en caso contrario.

Con tensiones en kPa y longitudes en m, la salida queda en kN/m para `N` y `Q`
y en kN m/m para `M`.

## Escenario determinístico vigente

El archivo [`calculationScenarioExample.R`](calculationScenarioExample.R)
expone el cálculo vigente como una secuencia de etapas. No escribe productos ni
define una implementación alternativa: llama a las mismas funciones que usa
`buildCalculationData()` y comprueba al final la correspondencia con
`calculateScenario()`.

| Etapa | Función | Entradas principales | Salida |
|---:|---|---|---|
| 1 | `buildThetaMesh()` | cantidad de puntos y ángulos críticos | `theta`, en radianes |
| 2 | `estimateK0()` | rama y primitivas de $K_0$ | estado de $K_0$ |
| 3 | `calculateEffectiveStressState()` | $\sigma'_v$, $K_0$ y $\Delta u$ | $\sigma'_v$, $\sigma'_h$ y $\Delta u$, en kPa |
| 4 | `interpolateCorrugatedSection()` | tabla, perfil y espesor base | $A_\theta$ e $I_\theta$ |
| 5 | `calculateRingSection()` | $E_\theta$, $A_\theta$, $I_\theta$ y $R$ | $EA_\theta$, $EI_\theta$ y `sectionRatio` |
| 6 | `calculatePerimeterActions()` | estado tensional, $\alpha$ y `theta` | $P_r(\theta)$ y $P_t(\theta)$ |
| 7 | `calculateSectionResultants()` | acciones, $R$, rigidez y controles numéricos | $N_\theta$, $M_\theta$, $Q_\theta$ y diagnósticos |
| 8 | `summarizeSectionResultants()` | respuesta de la etapa 7 | mínimos, máximos y posiciones |

La ejecución independiente es:

```sh
Rscript scripts/R/calculationScenarioExample.R
```

`calculateScenario(realization, context)` compone esas mismas etapas. Para la
realización, exige `effectiveVerticalKPa`, `waterPressureDifferenceKPa`,
`baseThicknessMm`, `alpha` y las primitivas de la rama de $K_0$. El contexto
contiene el modelo de $K_0$, la sección de referencia, el perfil, el módulo, el
radio, la malla y las tolerancias. Su salida conserva `k0State`, `stressState`,
`corrugatedSection`, `sectionRigidity`, `perimeterActions`,
`sectionResultants` y `resultantExtrema`.

## Ejemplo general de carga prescrita

```r
Theta <- (0:720) * 2 * pi / 721

Load <- k0TensorLoad(
  effectiveVertical = 100,
  k0 = 0.5,
  porePressure = 20,
  interface = "fullTraction"
)

Response <- calculateSectionResultants(
  load = Load,
  radius = 2,
  theta = Theta,
  sectionRatio = 0,
  integrationSteps = 4096L
)

stopifnot(Response$diagnostics$valid)
summarizeSectionResultants(Response)
```

`sectionRatio` es

$$
k=\frac{I}{AR^2}.
$$

Para una tira rectangular, $k=t^2/(12R^2)$. El valor 0 aplica el cierre
membranal.

Para una sección corrugada, use las propiedades por longitud axial proyectada:

```r
Reference <- read.csv(
  "data/reference/corrugation.section.properties.csv",
  check.names = FALSE,
  stringsAsFactors = FALSE
)
CorrugatedSection <- interpolateCorrugatedSection(
  reference = Reference,
  profileID = "ncspa-3x1",
  baseThicknessMm = 3
)

Section <- calculateRingSection(
  youngModulus = 200000, # MPa
  area = CorrugatedSection$areaMm2PerMm,
  inertia = CorrugatedSection$inertiaMm4PerMm,
  radius = 1315          # mm
)

Section$sectionRatio
```

`calculateRingSection()` devuelve $EA$, $EI$, `sectionRatio`, $\bar t$ y
$\bar E$ en el sistema coherente de unidades ingresado. El comparador Fourier
acepta el mismo cociente con `uniformMoment = "section"`.

## Evaluación resistente AISI

`screenAisiFlexuralDemand()` se conserva como control unilateral aislado de
las rutas prescriptivas F2--F4. No forma parte de
`evaluateCoverScenario()`, no produce una capacidad disponible y no alimenta
las interacciones H1/H2.

`evaluateAisiS100Demand()` recibe cuatro objetos explícitos: filas concurrentes
de demanda, una tabla larga de capacidades, estados de aplicabilidad y la base
ASD o LRFD. La función evalúa H1 y H2 por separado, conserva el signo de
$N_\theta$ y de $M_\theta$, y no convierte $Q_\theta$ en una reacción
localizada. El proveedor de capacidades es una responsabilidad separada.

Las pruebas `scripts/R/testAisiFlexuralBound.R` y
`scripts/R/testAisiS100Demand.R` comprueban, respectivamente, la cota nominal
y las interacciones H1/H2/H3. Una demanda de servicio no mayorada o una
capacidad cuya aplicabilidad no esté demostrada no produce un dictamen
resistente.

## Escenarios por tapada y alternativa de revestimiento

`evaluateCoverScenario()` calcula una sola alternativa; la función plural
`evaluateCoverScenarios()` repite exactamente esa secuencia. La distancia de
la clave al eje geométrico y el radio centroidal de la alternativa son entradas
distintas. No se aplican factores de acción implícitos.

```r
Reference <- read.csv(
  "data/reference/cspi.corrugation.section.properties.csv",
  stringsAsFactors = FALSE
)
SteelReference <- selectCorrugatedSection(
  reference = Reference,
  profileID = "cspi-76x25-csp-sheet",
  referenceRowID = "cspi-76x25-2.8"
)
Theta <- seq(0, 2 * pi, length.out = 361)[-361]

Scenario <- list(
  scenarioID = "steel-h2-t2.64",
  cover = list(
    coverCrownM = 2,
    crownToAxisM = 1.315,
    effectiveUnitWeightKnPerM3 = 20,
    effectiveSurchargeKPa = 0,
    referencePositionID = "axis"
  ),
  ground = list(
    modulusKPa = 30000,
    poisson = 0.30,
    k0 = list(modelID = "adopted-constant", k0 = 0.50)
  ),
  interfaceID = "fullSlip",
  action = list(
    combinationID = "declared-service-state",
    stageID = "completed-fill",
    forceEffectStatus = "unfactored-reference-state",
    loadCombinationBasisID = "declared-service-basis"
  ),
  lining = list(
    liningTypeID = "corrugated-steel",
    sectionID = "steel-t2.64",
    centroidalRadiusM = 1.315,
    poisson = 0.30,
    referenceProfileID = "cspi-76x25-csp-sheet",
    referenceRowID = "cspi-76x25-2.8",
    remainingBaseThicknessMm = 2.64,
    youngModulusKPa = 200e6,
    yieldStrengthMPa = 250,
    aisi = NULL
  )
)

Result <- evaluateCoverScenario(Scenario, Theta, SteelReference)
Result$summary
```

Para comparar tapadas o espesores, copie el escenario, cambie sus entradas y
asigne otro `scenarioID`; si cambia la sección resistente, cambie también
`sectionID`. La salida conserva todas las filas concurrentes de
$N_\theta$, $M_\theta$ y $Q_\theta$. Sin capacidades AISI, informa
`aisiWallMemberUtilization = NA`. Con `lining$aisi` completo, la utilización
de la pared se toma sin transformaciones de `evaluateAisiS100Demand()`; el
estado del sistema se conserva por separado en `aisiSystemStatus`.
El objeto `lining$aisi` declara además `capacityBaseThicknessMm`,
`capacityYieldStrengthMPa`, `capacityProfileID` y
`capacityReferenceRowID`; todos deben coincidir con la sección del escenario.
El ejecutor no escala ni interpola capacidades cuando cambia el espesor, la
resistencia de fluencia o el perfil.

`sectionReference` sólo es obligatorio cuando el conjunto contiene una
alternativa de acero corrugado; los escenarios exclusivamente de shotcrete no
dependen de esa tabla.

La alternativa de shotcrete usa su propia rigidez. La rama
`plain-concrete` evalúa las comprobaciones locales del Capítulo 14 de ACI
318-25 y expone `shotcreteLocalStrengthUtilization` por condición de interfaz.
En esta rama, `shotcreteMechanicalStatus` y
`minimumReinforcementStatus` son `not-applicable`; no se construye un dominio
de hormigón armado ni se evalúa una cuantía mínima. La rama
`reinforced-concrete` construye el dominio local $P$--$M$ con
`evaluateAci31825ReinforcedShellStrip()` a partir de las capas
circunferenciales declaradas y contrasta por separado la cuantía mínima en las
dos direcciones. No emite conformidad integral de cáscara sin el texto
operativo aplicable de ACI 318.2-25. El fixture ejecutable de ambas
alternativas está en `scripts/R/testCoverScenarios.R`.

La configuración raíz puede declarar alternativas autónomas bajo
`additionalLinings`. Para `additionalLinings.shotcrete`, las primitivas son
`outerRadiusM`, `thicknessM`, `poisson`, `compressiveStrengthMPa`,
`modulusModelID`, `stiffnessBasisID`, `stripWidthM`, `reinforcement`,
`convergenceTolerance` y el bloque `aci`, además de sus identificadores. Para
`plain-concrete`, `reinforcement` es una lista vacía y no se declaran campos de
armadura mínima. La fachada pública
`evaluateCoverConfiguration()` devuelve la alternativa bajo
`additionalLinings$shotcrete`, con `stress`, `section`, `interaction`,
`resultants`, `extrema`, `controls`, `assessment` y `summary`.

## Cargas arbitrarias

```r
Load <- newRingLoad(
  radial = function(theta) -10 * (1 + 0.2 * cos(2 * theta)),
  tangential = function(theta) rep(0, length(theta)),
  label = "declared scenario",
  source = "analysis specification XYZ",
  representation = "normal traction"
)
```

Si una carga tiene saltos, declare sus ángulos:

```r
Load <- newRingLoad(
  radial = function(theta) ifelse(theta < pi, -10, -5),
  label = "illustrative discontinuity",
  source = "example only",
  representation = "piecewise radial traction",
  breakpoints = pi
)
```

El segundo ejemplo no está equilibrado y será rechazado. Para inspeccionar sus
residuos, sin usarlo como solución física:

```r
Diagnostic <- solveRingDirect(
  load = Load,
  radius = 1,
  allowUnbalanced = TRUE
)
Diagnostic$diagnostics
```

`runRingMonteCarlo()` no acepta respuestas de diagnóstico desequilibradas.

## Perfiles y cargas de fuente

```r
Stress <- ringVerticalStressOrdinates(
  coverCrown = 5,
  radius = 1,
  layerBottom = c(3, Inf),
  effectiveUnitWeight = c(17, 19),
  effectiveSurcharge = 10,
  waterTableDepth = 4
)
```

Las relaciones de historia tensional reciben variables primitivas y devuelven
$K_0$ derivado:

```r
K0.unloading <- k0MayneKulhawyUnloading(
  frictionAngleDeg = 30,
  ocr = 4
)

K0.reloading <- k0MayneKulhawyReload(
  frictionAngleDeg = 30,
  ocr = 2,
  ocrMaximum = 4
)

Domain <- checkK0PassiveDomain(
  frictionAngleDeg = 30,
  ocrMaximum = 4
)
```

La fachada determinística selecciona una sola formulación a partir de sus
variables primitivas. El estado tensional efectivo se forma en una etapa
independiente y conserva como desconocido el incremento horizontal residual:

```r
K0 <- estimateK0(
  modelID = "jaky-nc",
  frictionAngleDeg = 30
)

StressState <- calculateEffectiveStressState(
  effectiveVerticalKPa = 100,
  k0State = K0,
  waterPressureDifferenceKPa = 0,
  horizontalIncrementKPa = NA_real_,
  horizontalIncrementStatus = "unknown-not-modeled"
)

Theta <- buildThetaMesh(
  pointCount = 721,
  criticalAnglesDeg = seq(0, 315, by = 45)
)
PerimeterActions <- calculatePerimeterActions(
  stressState = StressState,
  alpha = 0.5,
  theta = Theta
)

Response <- calculateSectionResultants(
  load = PerimeterActions$load,
  radius = 1.315,
  theta = Theta,
  sectionRatio = 0,
  integrationSteps = 8192L
)
```

La misma secuencia puede evaluarse para una realización mediante un contexto
preparado una sola vez. La función no lee archivos ni genera valores
aleatorios:

```r
SectionReference <- utils::read.csv(
  "data/reference/corrugation.section.properties.csv",
  check.names = FALSE,
  stringsAsFactors = FALSE
)
Context <- list(
  k0ModelID = "jaky-nc",
  horizontalIncrementKPa = NA_real_,
  horizontalIncrementStatus = "unknown-not-modeled",
  sectionReference = SectionReference,
  profileID = "ncspa-3x1",
  youngModulusKPa = 200e6,
  radiusM = 1.315,
  theta = Theta,
  integrationSteps = 8192L,
  balanceTolerance = 1e-9
)
Realization <- list(
  frictionAngleDeg = 30,
  effectiveVerticalKPa = 100,
  waterPressureDifferenceKPa = 0,
  baseThicknessMm = 3,
  alpha = 0.5
)
Scenario <- calculateScenario(
  realization = Realization,
  context = Context
)
Scenario$resultantExtrema
```

El límite pasivo identifica la frontera de aplicación de la relación en
reposo. `Domain` informa `valid`, `domainStatus`, `passiveCoefficient` y
`ocrLimit`. Las funciones de descarga y recarga exigen
$1\leq\mathrm{OCR}\leq\mathrm{OCR}_{\max}$ cuando corresponda, rechazan la
frontera pasiva y no recortan $K_0$.

Adaptadores disponibles:

- `k0NormallyConsolidated()` y `k0ElasticConfined()`: dos estimaciones de
  $K_0$ con dominios distintos; no son modelos de compactación;
- `k0MayneKulhawyUnloading()` y `k0MayneKulhawyReload()`: relaciones de
  Mayne--Kulhawy para descarga primaria y descarga--recarga;
- `checkK0PassiveDomain()`: estado del dominio, coeficiente pasivo y OCR
  límite usados únicamente para comprobar las relaciones anteriores;
- `usaceCmpThrust()`: empuje seccional con factores explícitos;
- `usaceUniformSurrogate()`: presión uniforme de igual empuje, marcada como
  derivada;
- `fhwaCompactionPressure()`: ecuación 5.1 en SI;
- `fhwaCompactionBandLoad()`: etapa constructiva proyectada;
- `nunez2000CircularResultants()`: resultantes circulares secas de 2000;
- `nunez2014Resultants()`: resultantes puntuales de 2014;
- `nunezEquivalentTensorLoad()`: equivalencia comparativa con restricciones
  automáticas de radio y cierre.

Los objetos de fuente conservan `source`, `sourceLocation`, `evidenceLevel` y
limitaciones cuando corresponde.

## Productos determinísticos de la memoria

`calculation.json` contiene el contrato humano `cover-case-2`: 31 entradas
independientes, agrupadas en `cover`, `ground`, `steel`, `seam`,
`plainConcrete` y `reinforcedConcrete`. La última rama recibe las primitivas
de una malla simétrica —grado, diámetro, separación, recubrimiento libre
relativo y módulo del acero— y R deriva las áreas y coordenadas de sus capas.
El manifiesto no contiene factores normativos, estados, fuentes, presentación
ni magnitudes derivadas. El perfil
metodológico versionado reside en `scripts/config/` y el alias `current`
resuelve una identidad inmutable declarada dentro de ese perfil.

Las dos funciones públicas son:

```r
Resolved <- resolveCoverCaseConfig(
  inputs = Manifest[["inputs", exact = TRUE]],
  projectRoot = projectRoot,
  methodID = Manifest[["methodID", exact = TRUE]]
)

Evaluation <- evaluateCoverCase(
  inputs = Manifest[["inputs", exact = TRUE]],
  projectRoot = projectRoot,
  methodID = Manifest[["methodID", exact = TRUE]]
)
```

`resolveCoverCaseConfig()` valida las entradas, obtiene referencias de sección
y costura, deriva identificadores, luces, radios baricéntricos, áreas de acero
y coordenadas de las capas, e incorpora las constantes y fuentes del método.
`evaluateCoverCase()`
ejecuta una sola vez el motor determinístico y devuelve entradas, base del
método, derivados, estado tensional, secciones, interacción, resultantes,
extremos, controles y comprobaciones resistentes.

`calculateSymmetricReinforcementMesh()` es una función pura y recibe todas las
primitivas de la malla mediante argumentos nombrados. La frontera
`evaluateCoverCase()` recibe el conjunto completo de primitivas del escenario
como un objeto independiente; por lo tanto, un futuro muestreador puede crear
una copia por realización sin modificar constantes normativas ni el código del
núcleo.

El comando

```sh
Rscript scripts/R/runCalculationMemo.R
```

valida el caso, resuelve el perfil metodológico, lee las propiedades publicadas
conservadas en `data/reference/` y materializa los productos CSV junto con la
configuración de máquina reproducible en `data/calculation/`. El JSON raíz
permanece como entrada humana; `calculation.config.json` es un producto
derivado y no debe editarse.

La presión horizontal residual de compactación no se ha cuantificado. Por
ello `horizontalIncrementKPa` permanece nulo y
`horizontalIncrementStatus` registra `unknown-not-modeled`. La diferencia de
presión de agua se define como $u_{ext}-u_{int}$ y admite signo.

## Interacción elástica cerrada

`ringInteraction.R` contiene comparadores que resuelven simultáneamente el
contacto suelo-anillo y los resultantes. No son generadores de carga para
`solveRingDirect()`:

- `schwartzEinsteinStiffness()` calcula $C^*$ y $F^*$;
- `schwartzEinsteinResultants()` evalúa las cuatro ramas
  carga-externa/excavación por full-slip/no-slip;
- `candeLevel1Parameters()` calcula $K$, $\alpha$ y $\beta$ sin desacoplar
  artificialmente $K=\nu/(1-\nu)$;
- `candeLevel1Response()` evalúa la tabla analítica Level 1 para interfaz
  adherida o sin fricción.

Ambas fuentes usan $\theta=0$ en el arranque derecho y sentido antihorario.
Schwartz–Einstein publica `thrust` positivo a compresión. Las dos páginas
auditadas de CANDE no definen explícitamente el sentido físico de sus signos.
Por ello estas funciones conservan nombres y convenciones fuente-nativas y no
devuelven una clase `ringDirectResponse`.

```r
SE <- schwartzEinsteinResultants(
  theta = seq(0, 2 * pi, length.out = 361),
  verticalStress = 100,
  stressRatio = 0.5,
  radius = 2,
  cStar = 0.05,
  fStar = 100,
  groundPoisson = 0.4,
  sequence = "external",
  interface = "fullSlip"
)

SE$extrema$values
```

Para Monte Carlo sobre estas ramas fuente-nativas use
`runOutputMonteCarlo()` y extraiga resultantes o extremos con nombres
explícitos; no mezcle sus signos con el solver directo sin una transformación
documentada.

`calculatePrismThrust()` conserva la relación USACE como un resultado escalar:
devuelve la presión de carga permanente en clave y los empujes de servicio y
mayorados, pero no construye una presión angular. Para carga viva, el adaptador
comprueba que el ancho cargado no supere la luz y obtiene el factor de
distribución de la relación publicada, con la constante de 15 pulgadas
convertida a 0.381 m.

`calculateExternalInteraction()` evalúa exclusivamente la secuencia de carga
externa de Schwartz--Einstein. Recibe
`effectiveVerticalStressKPa`, `effectiveHorizontalStressKPa` y
`stressReferenceID`; ambas tensiones corresponden a la misma cota de campo
libre. La salida conserva `stressBasis = "effective"` y
`hydraulicActionTreatment = "separate-not-included"`. Sus signos y coordenadas
se adaptan a `thetaRad`, `normalForceKnPerM`,
`bendingMomentKnMPerM` y `shearForceKnPerM`, y sus extremos se obtienen en
forma analítica. `fullSlip` y `noSlip` son escenarios discretos; una eventual
envolvente exterior es una envolvente de escenarios de modelo, no una cota
física demostrada para la interfaz real.

## Monte Carlo

El motor recibe realizaciones, no distribuciones:

```r
Draws <- data.frame(
  frictionAngleDeg = c(28, 32, 36),
  effectiveVerticalKPa = c(80, 100, 120),
  waterPressureDifferenceKPa = c(0, 10, 20),
  baseThicknessMm = c(3.0, 3.1, 3.2),
  alpha = c(0, 0.5, 1)
)

Result <- runRingMonteCarlo(
  draws = Draws,
  responseFunction = function(draw, theta) {
    Context.draw <- Context
    Context.draw$theta <- theta
    Scenario <- calculateScenario(
      realization = as.list(draw[1L, , drop = FALSE]),
      context = Context.draw
    )
    Scenario$sectionResultants
  },
  theta = Context$theta,
  probabilities = c(0.05, 0.50, 0.95),
  modelLabel = "declared geotechnical branch"
)
```

El callback adapta una fila ya materializada al mismo `calculateScenario()`
que usa el cálculo determinístico. `runRingMonteCarlo()` conserva el orden de
esas filas y no elige distribuciones, dependencias, probabilidades de modelo ni
semilla.

Resultados principales:

- `pointwiseQuantiles`: cuantiles en cada ángulo;
- `extremaSamples`: extremos de cada realización, con signo y ángulo;
- `extremaQuantiles`: cuantiles de esos extremos;
- `diagnostics`: control de equilibrio de cada realización.

## Verificación reproducible

```sh
Rscript scripts/R/testRingMethod.R
Rscript scripts/R/testAisiS100Demand.R
Rscript scripts/R/testCalculationData.R
Rscript scripts/R/testCalculationFigures.R
Rscript scripts/R/runRingBenchmarks.R
Rscript scripts/R/runRingFigures.R
```

Las tablas se escriben en `TITO/kb/benchmarks` y las figuras en
`TITO/kb/figures`. Los scripts sólo sobrescriben los nombres que declaran.
