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

Adaptadores disponibles:

- `k0NormallyConsolidated()` y `k0ElasticConfined()`: dos estimaciones de
  $K_0$ con dominios distintos; no son modelos de compactación;
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
  k0 = c(0.4, 0.5, 0.6),
  porePressure = c(0, 10, 20)
)

Result <- runRingMonteCarlo(
  draws = Draws,
  responseFunction = function(Draw, theta) {
    solveK0Closed(
      effectiveVertical = Draw$effectiveVertical,
      k0 = Draw$k0,
      porePressure = Draw$porePressure,
      radius = 2,
      theta = theta,
      interface = "fullTraction"
    )
  },
  theta = (0:720) * 2 * pi / 721,
  probabilities = c(0.05, 0.50, 0.95),
  modelLabel = "declared K0 branch"
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
Rscript scripts/R/runRingBenchmarks.R
Rscript scripts/R/runRingFigures.R
```

Las tablas se escriben en `TITO/kb/benchmarks` y las figuras en
`TITO/kb/figures`. Los scripts sólo sobrescriben los nombres que declaran.
