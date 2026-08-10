# Incertidumbre, Monte Carlo y envolventes

## 1. Principio de trabajo

La simulación no completa información ausente. Cada variable aleatoria debe
tener una definición física, unidades, fuente y distribución aprobada antes de
muestrearse. En particular, los documentos USACE, FHWA y Núñez auditados no
definen distribuciones para $K_0$, compactación, rigidez, $\eta$ ni errores de
modelo. Esos priors continúan `UNKNOWN`.

Se separan tres clases de incertidumbre:

1. **paramétrica:** por ejemplo $\gamma'$, nivel freático, $K_0$ o fuerza del
   compactador, cuando exista una caracterización que sustente su
   distribución;
2. **de escenario:** interfaz `fullTraction` o `normalOnly`, etapa de relleno,
   fuente de carga y estado final o constructivo;
3. **de modelo:** diferencia entre adaptadores que representan fenómenos y
   dominios distintos.

Las incertidumbres de escenario y modelo no se convierten automáticamente en
variables aleatorias. Sin probabilidades justificadas se entregan ramas y una
envolvente exterior, no una mezcla probabilística.

## 2. Registro mínimo de entrada

Cada parámetro debe registrarse con los siguientes campos:

| Campo | Contenido obligatorio |
|---|---|
| `name` | identificador sin ambigüedad |
| `physicalMeaning` | magnitud y etapa a la que corresponde |
| `units` | sistema coherente dentro de la rama |
| `source` | ensayo, informe, juicio experto o dato geométrico |
| `distribution` | familia y parámetros, o valor fijo |
| `bounds` | límites físicos o documentales |
| `dependencies` | variables correlacionadas y mecanismo |
| `applicability` | rama y dominio donde puede utilizarse |

La geometría conocida se mantiene determinística. No se le asigna variación
para aparentar completitud probabilística.

## 3. Variables candidatas por operación

Esta lista identifica variables, no recomienda distribuciones:

| Operación | Variables que pueden requerir caracterización |
|---|---|
| perfil vertical | $\gamma'_i$, espesores de capa, $q'$, nivel freático, $\gamma_w$ |
| estado lateral | $K_0$ directo o $\phi'$ y $OCR$; no ambos sin controlar dependencia |
| compactación FHWA | $P$, $\phi$, $d_c$, cota de cada lift; retención final `UNKNOWN` |
| interfaz prescrita | selección `fullTraction`/`normalOnly` como escenarios separados |
| Núñez 2014 | $K_0$, $\eta$, $a$ y su fuente; dominio fuera de tubería rellenada |
| cálculo numérico | integración y grilla del solver; $n_{max}$ sólo para la comparación modal |

$K_0$ y $\phi'$ no deben muestrearse independientemente si se impone
$K_0=1-\sin\phi'$. Análogamente, un $K_0$ calibrado al relleno compactado y un
incremento residual $\Delta\sigma'_{h,c}$ pueden representar dos veces el
mismo fenómeno.

## 4. Diseño de escenarios

La matriz mínima de cálculo mantiene separadas las ramas:

| Identificador | Carga | Salidas con respaldo |
|---|---|---|
| `K0-full` | tensor de campo libre, tracción completa | $N(\theta),M(\theta),Q(\theta)$ derivados |
| `K0-normal` | misma presión normal, $P_t=0$ | $N(\theta),M(\theta),Q(\theta)$ derivados |
| `USACE-service` | empuje escalar | $N_0$ equivalente solamente |
| `USACE-design` | empuje factorizado con factores rotulados | demanda escalar; no $M,Q$ |
| `FHWA-prism` | carga de prisma/VAF | carga global y empuje de springline |
| `FHWA-stage-j` | banda horizontal durante el lift $j$ | respuesta angular de esa etapa derivada |
| `Nunez-2014-direct` | Ecs. 22–25 | resultantes puntuales; $Q$ `UNKNOWN` |
| `Nunez-2014-projection` | proyección simétrica derivada | curvas, siempre fuera de dominio |

El estado permanente y la envolvente durante construcción son productos
distintos. No se suma la banda FHWA al estado final salvo que se declare un
factor residual externo, con su propia fuente.

## 5. Cálculo de una muestra

Para la muestra $j$ y una rama angular:

$$
\mathbf x_j
\xrightarrow{\text{perfil y adaptador}}
\{P_{r,j}(\theta),P_{t,j}(\theta)\}
\xrightarrow{\text{solver directo}}
\{N_j(\theta),M_j(\theta),Q_j(\theta)\}.
$$

Toda corrida angular conserva:

- el vector de parámetros realizado $\mathbf x_j$;
- la metadata declarada de fuente, rama y unidades;
- mínimo, máximo, máximo absoluto y ángulo.

Cuando se activa `keepSampleCurves=TRUE`, se conservan además las curvas y los
resultantes de cada muestra. Esta opción puede requerir memoria considerable y
debe decidirse antes de una corrida grande. Los espectros Fourier no forman
parte de la salida del motor Monte Carlo canónico.

Un error de equilibrio, una variable fuera del dominio de la ecuación o un
modo $n=1$ sin reacción detiene la muestra; no se convierte en cero ni se
descarta silenciosamente.

## 6. Dos envolventes que no deben confundirse

Para un resultante genérico $X_j(\theta)$, el cuantil puntual es

$$
q_\alpha(\theta)=Q_\alpha\{X_1(\theta),\ldots,X_{n_s}(\theta)\}.
$$

Por otra parte, cada muestra tiene extremos espaciales

$$
X_{j,min}=\min_\theta X_j(\theta),
\qquad
X_{j,max}=\max_\theta X_j(\theta),
$$

y se calculan los cuantiles de esos extremos. En general,

$$
\max_\theta q_\alpha(\theta)
\ne
Q_\alpha\left\{\max_\theta X_j(\theta)\right\}.
$$

El prototipo guarda ambos resultados. Para $N>0$ a tracción, la mayor
compresión corresponde al mínimo de $N$; por eso no basta una envolvente de
valores absolutos.

En construcción, el extremo se toma primero sobre $\theta$ y sobre las etapas
de una misma muestra, y recién después se calcula el cuantil entre muestras.
Tomar el máximo de los cuantiles de cada lift no es, en general, equivalente.
El runner vigente no automatiza esta reducción por etapas; la envolvente de
cada muestra debe construirse explícitamente antes de calcular cuantiles.

## 7. Envolvente exterior entre modelos

Si no existen pesos de modelo, para un nivel inferior $\alpha_L$ y superior
$\alpha_U$ se puede informar

$$
L(\theta)=\min_m q_{\alpha_L}^{(m)}(\theta),
\qquad
U(\theta)=\max_m q_{\alpha_U}^{(m)}(\theta).
$$

Esta es una **envolvente de escenarios**, no un intervalo con probabilidad
$\alpha_U-\alpha_L$. USACE escalar y FHWA global no entran en una envolvente
angular de $M$ o $Q$. Los resultantes directos de Núñez usan compresión
positiva; antes de una comparación con el solver debe aplicarse y registrarse
la conversión $N_{solver}=-N_{N\acute{u}\tilde{n}ez}$.

## 8. Implementación R

`scripts/R/ringMonteCarlo.R` ofrece:

- `runRingMonteCarlo()` para respuestas angulares producidas por
  `solveRingDirect()`;
- `runOutputMonteCarlo()` para empujes o resultantes puntuales.

Las realizaciones se construyen externamente y se pasan como un `data.frame`;
el motor no selecciona distribuciones, correlaciones, límites ni cópulas. El
siguiente bloque usa tres realizaciones declaradas únicamente para mostrar la
API. No constituye una caracterización probabilística del relleno:

```r
source("scripts/R/ringDirect.R")
source("scripts/R/ringLoads.R")
source("scripts/R/ringMonteCarlo.R")

Draws <- data.frame(
  effectiveVertical = c(80, 100, 120),
  k0 = c(0.40, 0.50, 0.60),
  porePressure = c(0, 10, 20)
)

ResponseFunction <- function(draw, theta) {
  Load <- k0TensorLoad(
    effectiveVertical = draw$effectiveVertical,
    k0 = draw$k0,
    porePressure = draw$porePressure,
    interface = "fullTraction"
  )
  solveRingDirect(
    load = Load,
    radius = 2,
    theta = theta,
    sectionRatio = 0
  )
}

Result <- runRingMonteCarlo(
  draws = Draws,
  responseFunction = ResponseFunction,
  theta = (0:720) * 2 * pi / 721,
  probabilities = c(0.05, 0.50, 0.95),
  modelLabel = "declared K0 control"
)
```

La tabla `Draws` de un análisis real debe conservar su productor, semilla,
fuentes y reglas de dependencia. La generación de esas realizaciones permanece
fuera del solver para que ninguna distribución sea implícita.

## 9. Controles de convergencia

Antes de aceptar una envolvente:

1. refinar integración y grilla angular del solver directo;
2. aumentar $n_{max}$ del comparador Fourier, especialmente para bandas FHWA;
3. repetir Monte Carlo con tamaños crecientes y comparar cuantiles;
4. informar error de muestreo, por ejemplo mediante remuestreo de los
   estadísticos guardados;
5. repetir ramas de interfaz y de fuente por separado;
6. conservar semilla, versión de código, tablas fuente y manifiesto de PDF.

No se fija todavía un tamaño mínimo universal: depende del cuantil requerido,
la discontinuidad de las cargas y la estabilidad observada. Ese número queda
`UNKNOWN` hasta definir el objetivo probabilístico del estudio.
