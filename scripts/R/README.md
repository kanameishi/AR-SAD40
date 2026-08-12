# Implementación R del anillo circular

R es la implementación canónica. El notebook Wolfram se conserva sólo como
oráculo interno y Fourier como comparador modal independiente.

El producto de este prototipo son los resultantes $N(\theta)$, $M(\theta)$ y
$Q(\theta)$ y sus extremos/envolventes. No recupera $\sigma$, $\tau$,
capacidades ni demandas de pernos.

La documentación matemática y de fuentes está en
[`TITO/kb/metodologia-anillo-enterrado.md`](../../TITO/kb/metodologia-anillo-enterrado.md).

## Carga de la API

```r
source("scripts/R/ringDirect.R")
source("scripts/R/ringLoads.R")
source("scripts/R/k0Models.R")
source("scripts/R/stressState.R")
source("scripts/R/ringInteraction.R")
source("scripts/R/ringMonteCarlo.R")
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

## Flujo mínimo

```r
Theta <- (0:720) * 2 * pi / 721

Load <- k0TensorLoad(
  effectiveVertical = 100,
  k0 = 0.5,
  porePressure = 20,
  interface = "fullTraction"
)

Response <- solveRingDirect(
  load = Load,
  radius = 2,
  theta = Theta,
  sectionRatio = 0,
  integrationSteps = 4096L
)

stopifnot(Response$diagnostics$valid)
summarizeRingGrid(Response)
```

`sectionRatio` es

$$
k=\frac{I}{AR^2}.
$$

Para una tira rectangular, $k=t^2/(12R^2)$. El valor 0 aplica el cierre
membranal.

Para una sección corrugada, use las propiedades por longitud axial proyectada:

```r
Section <- calculateRingSection(
  youngModulus = 200000, # MPa
  area = 3.522,          # mm2/mm
  inertia = 1057.25,     # mm4/mm
  radius = 1315          # mm
)

Section$sectionRatio
```

La función devuelve $EA$, $EI$, `sectionRatio`, $\bar t$ y $\bar E$ en el
sistema coherente de unidades ingresado. El comparador Fourier acepta el mismo
cociente con `uniformMoment = "section"`.

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
  modelId = "jaky-nc",
  frictionAngleDeg = 30
)

StressState <- calculateEffectiveStressState(
  effectiveVerticalKPa = 100,
  k0State = K0,
  waterPressureDifferenceKPa = 0,
  horizontalIncrementKPa = NA_real_,
  horizontalIncrementStatus = "unknown-not-modeled"
)
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
- `usaceCmpThrust()`: empuje escalar con factores explícitos;
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

`calculation.json` contiene las entradas adoptadas del escenario. El comando

```sh
Rscript scripts/R/runCalculationMemo.R
```

valida la configuración, interpola las propiedades publicadas conservadas en
`data/reference/`, selecciona una única rama de $K_0$ y materializa ocho
CSV más una instantánea exacta del JSON en `data/calculation/`. El estado
lateral distingue `k0Input`,
`k0Derived` y `k0Applied`; las acciones consumen
`effectiveHorizontalKPa` y no vuelven a calcular $K_0$.

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

## Monte Carlo

El motor recibe realizaciones, no distribuciones:

```r
Draws <- data.frame(
  effectiveVertical = c(80, 100, 120),
  frictionAngleDeg = c(28, 32, 36),
  porePressure = c(0, 10, 20),
  tangentialMultiplier = c(0, 0.5, 1)
)

Result <- runRingMonteCarlo(
  draws = Draws,
  responseFunction = function(Draw, theta) {
    Load <- k0TangentialMultiplierLoad(
      effectiveVertical = Draw$effectiveVertical,
      k0 = k0NormallyConsolidated(Draw$frictionAngleDeg),
      porePressure = Draw$porePressure,
      tangentialMultiplier = Draw$tangentialMultiplier
    )
    solveRingDirect(
      load = Load,
      radius = 2,
      theta = theta
    )
  },
  theta = (0:720) * 2 * pi / 721,
  probabilities = c(0.05, 0.50, 0.95),
  modelLabel = "declared geotechnical branch"
)
```

Resultados principales:

- `pointwiseQuantiles`: cuantiles en cada ángulo;
- `extremaSamples`: extremos de cada realización, con signo y ángulo;
- `extremaQuantiles`: cuantiles de esos extremos;
- `diagnostics`: control de equilibrio de cada realización.

## Verificación reproducible

```sh
Rscript scripts/R/testRingMethod.R
Rscript scripts/R/testCalculationData.R
Rscript scripts/R/testCalculationFigures.R
Rscript scripts/R/runRingBenchmarks.R
Rscript scripts/R/runRingFigures.R
```

Las tablas se escriben en `TITO/kb/benchmarks` y las figuras en
`TITO/kb/figures`. Los scripts sólo sobrescriben los nombres que declaran.
