# Comparación y verificación con soluciones publicadas

Los casos siguientes contrastan la formulación analítica y los resultados numéricos con soluciones publicadas. Su alcance es matemático. La calibración del estado de cargas del revestimiento existente requiere ensayos o mediciones representativos de su geometría, relleno y secuencia constructiva.

## Carga radial uniforme por sectores

Baker estudia dos cargas radiales diametralmente opuestas y uniformes dentro de sectores de semiángulo $30^\circ$ y $60^\circ$. Para una resultante $P$ por sector y un ancho axial $b$, las tablas XIII y XIV presentan
[@Baker1968, tablas XIII--XIV, pp. 50--51]

$$
\overline N=\frac{bN_\theta}{P}, \qquad \overline M=\frac{bM_\theta}{RP}.
$$ {#eq-baker-normalization}

La integración directa de la carga radial reproduce los ocho pares de valores tabulados. Las diferencias absolutas máximas son

$$
\max\lvert\Delta\overline N\rvert =4.97\times10^{-4}, \qquad \max\lvert\Delta\overline M\rvert =4.23\times10^{-4}.
$$ {#eq-baker-errors}

| Semiángulo |   $\theta$ | $\overline N$ publicado | $\overline N$ calculado | $\overline M$ publicado | $\overline M$ calculado |
|-----------:|-----------:|------------------------:|------------------------:|------------------------:|------------------------:|
| $30^\circ$ |  $0^\circ$ |                $-0.128$ |             $-0.127936$ |                 $0.190$ |              $0.190374$ |
| $30^\circ$ | $30^\circ$ |                $-0.239$ |             $-0.238732$ |                 $0.080$ |              $0.079577$ |
| $30^\circ$ | $60^\circ$ |                $-0.413$ |             $-0.413497$ |                $-0.095$ |             $-0.095187$ |
| $30^\circ$ | $90^\circ$ |                $-0.477$ |             $-0.477465$ |                $-0.159$ |             $-0.159155$ |
| $60^\circ$ |  $0^\circ$ |                $-0.239$ |             $-0.238732$ |                 $0.080$ |              $0.079577$ |
| $60^\circ$ | $30^\circ$ |                $-0.271$ |             $-0.270716$ |                 $0.048$ |              $0.047593$ |
| $60^\circ$ | $60^\circ$ |                $-0.358$ |             $-0.358099$ |                $-0.040$ |             $-0.039789$ |
| $60^\circ$ | $90^\circ$ |                $-0.413$ |             $-0.413497$ |                $-0.095$ |             $-0.095187$ |

: Reproducción de las tablas XIII y XIV de Baker [@Baker1968, pp. 50--51]. {#tbl-baker-check}

Las diferencias máximas son inferiores a $5\times10^{-4}$, equivalente a media unidad de la última cifra publicada. El contraste corresponde a una carga radial discontinua. La extensión a componentes tangenciales se comprueba separadamente mediante la @eq-modal-algebra.

## Relación de fuerza normal de USACE

El ejemplo D4 de USACE considera un conducto de $36\ \mathrm{in}$ de diámetro, una tapada de $30\ \mathrm{ft}$ y un relleno con peso unitario de
$120\ \mathrm{lb/ft^3}$ [@USACE2020, ap. D4, pp. 332--333]. La @tbl-usace-check conserva las unidades de la fuente.

| Magnitud                                   | Valor publicado | Valor calculado | Unidad |
|--------------------------------------------|----------------:|----------------:|--------|
| presión vertical permanente en clave       |          $3600$ |          $3600$ | lb/ft² |
| fuerza normal sin factores                 |             --- |          $5400$ | lb/ft  |
| fuerza normal factorizada                  |         $10530$ |         $10530$ | lb/ft  |
| demanda con el modificador del apéndice D4 |         $11583$ |         $11583$ | lb/ft  |

: Reproducción del ejemplo D4 de USACE [@USACE2020, pp. 332--333]. {#tbl-usace-check}

La fuerza de $5400\ \mathrm{lb/ft}$ se obtiene de la Ec. 4-20 antes de aplicar los factores utilizados en el ejemplo. La Ec. 4-21 define el modificador combinado de carga $\eta_{cmp}=\eta_D\eta_R\eta_I$ por ductilidad, redundancia e importancia operacional y adopta $1.05$ para tuberías metálicas corrugadas; D4 emplea $1.10$. El valor $1.10$ se utiliza exclusivamente para reproducir D4. El modificador aplicable al revestimiento analizado es un dato de diseño que deberá establecer la norma gobernante.

## Presión de compactación en los hastiales

La @eq-fhwa-compaction se evaluó para las nueve combinaciones de equipo, material y diámetro de la tabla 5.5 de FHWA-RD-98-191
[@McGrathEtAl1999, ec. 5.1 y tabla 5.5, pp. 176--178]. En ocho filas, el valor calculado coincide con el tabulado al redondear a $0.1\ \mathrm{kPa}$. En la última fila, la tabla imprime $\phi'=28^\circ$ para piedra y un diámetro nominal de $1500\ \mathrm{mm}$. La figura 5.4 asocia ese diámetro nominal con
$d_c=1575\ \mathrm{mm}$. Esos datos producen $0.42\ \mathrm{kPa}$, mientras que el valor tabulado es $0.2\ \mathrm{kPa}$. El ángulo
$\phi'=36^\circ$, utilizado para la piedra en las demás filas, produce
$0.195\ \mathrm{kPa}$ y redondea a $0.2\ \mathrm{kPa}$. La fila se conserva como discrepancia de la fuente y se excluye de cualquier calibración.

La figura 5.4 de la misma referencia define la dirección horizontal de las fuerzas nodales aplicadas en ambos hastiales
[@McGrathEtAl1999, fig. 5.4, pp. 175--176]. Las @eq-fhwa-band y @eq-fhwa-perimeter-load trasladan esa acción a una franja de altura definida y a las componentes locales $P_r$ y $P_t$.

## Ejemplo HP97 de Schwartz--Einstein

El ejemplo HP97 utiliza $C^*=0.05$, $F^*=100$, $\nu_g=0.4$,
$K_{SE}=0.5$ y $\theta_{SE}=30^\circ$. La fuente informa
$T_{SE}/ (P_{SE}R)$ y $M_{SE}/ (P_{SE}R^2)$ para dos secuencias de carga y dos condiciones de interfaz [@SchwartzEinstein1980, ejemplo HP97, pp. 391--392]. La @tbl-se-check conserva la convención de la fuente: $T_{SE}>0$ a compresión. La transformación a la convención general se realiza mediante la @eq-se-coordinate-normal-conversion y las relaciones del apéndice.

| Secuencia               | Interfaz                             | $T_{SE}/(P_{SE}R)$ publicado |  Calculado | $M_{SE}/(P_{SE}R^2)$ publicado |  Calculado |
|-------------------------|--------------------------------------|-----------------------------:|-----------:|-------------------------------:|-----------:|
| descarga por excavación | deslizamiento completo (*full slip*) |                      $0.736$ | $0.735909$ |                      $0.00774$ | $0.007743$ |
| descarga por excavación | sin deslizamiento (*no slip*)        |                      $0.812$ | $0.811806$ |                      $0.00707$ | $0.007066$ |
| carga externa           | deslizamiento completo (*full slip*) |                      $0.887$ | $0.887061$ |                       $0.0133$ | $0.013274$ |
| carga externa           | sin deslizamiento (*no slip*)        |                       $1.02$ | $1.017169$ |                       $0.0121$ | $0.012113$ |

: Reproducción del ejemplo HP97 en la convención de Schwartz--Einstein [@SchwartzEinstein1980, pp. 391--392]. {#tbl-se-check}

La referencia no tabula la fuerza cortante. Su valor puede deducirse de la derivada del momento, pero no se utiliza como dato publicado de contraste. Este caso comprueba los coeficientes de la formulación Schwartz--Einstein empleada para las demandas de diseño. Los casos de Baker comprueban, de manera separada, la integración directa de cargas prescritas.

## Relación entre Schwartz--Einstein, Fourier y el estado $K_0$

Schwartz--Einstein entrega, después de transformar sus signos y coordenada, la respuesta

$$
N_\theta=N_0+N_2\cos2\theta, \qquad M_\theta=M_2\cos2\theta, \qquad Q_\theta=-\frac{2M_2}{R}\sin2\theta.
$$ {#eq-se-project-harmonics}

Para comprobar exclusivamente el equilibrio de esa respuesta, las @eq-ring-equilibrium-r y @eq-ring-equilibrium-t permiten reconstruir las tracciones equivalentes

$$
a_0=\frac{N_0}{R}, \qquad a_2=\frac{N_2}{R}-\frac{4M_2}{R^2}, \qquad d_2=\frac{2N_2}{R}-\frac{2M_2}{R^2},
$$ {#eq-se-equivalent-tractions}

con los demás coeficientes nulos. Al aplicar esos tres coeficientes a la solución Fourier y a la integración directa, las seis combinaciones de las tres secciones autónomas y las dos interfaces reproducen las resultantes Schwartz--Einstein dentro de las tolerancias declaradas. La sección compuesta reutiliza este motor verificado y recalcula sus demandas con sus propias rigideces. Las diferencias de la @tbl-se-fourier-equivalence se normalizan con $P_{SE}R$ para fuerzas y
$P_{SE}R^2$ para momentos.

```{r}
#| label: tbl-se-fourier-equivalence
#| tbl-cap: "Reconstrucción de las resultantes Schwartz--Einstein. I: condición de interfaz; S: deslizamiento completo; NS: sin deslizamiento; εF y εD: diferencias máximas normalizadas de Fourier e integración directa."
equivalence <- read.csv(
  "data/benchmarks/ring/project-es-fourier-equivalence.csv",
  na.strings = "UNKNOWN",
  check.names = FALSE
)
source(file.path("scripts", "tbl", "table.R"), local = TRUE)
liningNames <- c(
  steel = "Chapa",
  shotcrete = "HP 100",
  reinforcedConcrete = "HP 150"
)
interfaceNames <- c(
  `full-slip` = "S",
  `no-slip` = "NS"
)
equivalenceTable <- data.frame(
  section = unname(liningNames[equivalence$liningID]),
  interface = unname(interfaceNames[equivalence$interfaceID]),
  modes = equivalence$modes,
  epsFourier = formatC(
    equivalence$fourierMaximumNormalizedDifference,
    format = "e",
    digits = 2
  ),
  epsDirect = formatC(
    equivalence$directMaximumNormalizedDifference,
    format = "e",
    digits = 2
  ),
  status = ifelse(
    equivalence$fourierStatus == "satisfied" &
      equivalence$directStatus == "satisfied",
    "OK",
    "FAIL"
  ),
  check.names = FALSE
)
buildReportTable(
  data = equivalenceTable,
  headers = c("Sección", "I", "$n$", "$\\varepsilon_F$", "$\\varepsilon_D$", "Estado"),
  align = c("l", "l", "r", "r", "r", "c")
)
```

Este resultado no significa que Fourier converja físicamente a Schwartz--Einstein. La solución de interacción determina primero $N_0$, $N_2$
y $M_2$ mediante $C^*$, $F^*$ y la interfaz; Fourier e integración directa sólo reproducen después el equilibrio de esos coeficientes. Si se parte, en cambio, de la proyección uniforme del estado $K_0$, los coeficientes son los de la @eq-k0-full-response o la @eq-k0-normal-response y no dependen de la rigidez del revestimiento.

```{r}
#| label: tbl-uniform-interaction-comparison
#| tbl-cap: "Coeficientes para el mismo campo uniforme. M: método; C: condición; K0: carga biaxial prescrita; E-S: Schwartz--Einstein; PT: proyección completa; PN: proyección normal; S: deslizamiento completo; NS: sin deslizamiento."
interactionComparison <- read.csv(
  "data/benchmarks/ring/project-uniform-interaction-comparison.csv",
  na.strings = "UNKNOWN",
  check.names = FALSE
)
isPrescribed <- interactionComparison$methodID == "prescribed-uniform-k0"
prescribedRows <- interactionComparison[isPrescribed, , drop = FALSE]
prescribedRows <- prescribedRows[
  !duplicated(prescribedRows$interfaceID),
  ,
  drop = FALSE
]
comparisonRows <- rbind(
  prescribedRows,
  interactionComparison[!isPrescribed, , drop = FALSE]
)
methodNames <- c(
  `prescribed-uniform-k0` = "K0",
  `schwartz-einstein-external-loading` = "E-S"
)
conditionNames <- c(
  `full-traction` = "PT",
  `normal-only` = "PN",
  `full-slip` = "S",
  `no-slip` = "NS"
)
uniformTable <- data.frame(
  method = unname(methodNames[comparisonRows$methodID]),
  section = ifelse(
    comparisonRows$methodID == "prescribed-uniform-k0",
    "—",
    unname(liningNames[comparisonRows$liningID])
  ),
  condition = unname(conditionNames[comparisonRows$interfaceID]),
  n0 = formatC(
    comparisonRows$normalMode0Ratio,
    format = "f",
    digits = 4
  ),
  n2 = formatC(
    comparisonRows$normalMode2Ratio,
    format = "f",
    digits = 4
  ),
  m2 = formatC(
    comparisonRows$momentMode2Ratio,
    format = "f",
    digits = 4
  ),
  check.names = FALSE
)
buildReportTable(
  data = uniformTable,
  headers = c("M", "Sección", "C", "$N_0/(P_{SE}R)$", "$N_2/(P_{SE}R)$", "$M_2/(P_{SE}R^2)$"),
  align = c("l", "l", "l", "r", "r", "r")
)
```

La @tbl-uniform-interaction-comparison muestra el efecto buscado: las tres secciones reciben coeficientes diferentes con Schwartz--Einstein, mientras que la carga $K_0$ prescrita conserva los mismos coeficientes adimensionales. En la memoria vigente, Schwartz--Einstein gobierna la componente uniforme y la corrección equilibrada agrega el gradiente lineal; la proyección biaxial uniforme prescrita permanece como control y no se combina ni se promedia con la demanda.

La @eq-methodology-linear-gradient-load introduce sólo $n=1$ y $n=3$. La primera fila de cada revestimiento en la @tbl-balanced-gradient-modes muestra la resultante vertical antes de definir el apoyo; la segunda incorpora la reacción radial de equilibrio de la @eq-methodology-gradient-support-reaction y recupera el equilibrio global.

```{r}
#| label: tbl-balanced-gradient-modes
#| tbl-cap: "Modos del gradiente geostático. Fz, N y Q se expresan en kN/m; a1s, en kPa; M, en kN m/m."
gradientModes <- read.csv(
  "data/benchmarks/ring/project-depth-gradient-modes.csv",
  na.strings = "UNKNOWN",
  check.names = FALSE
)
fullGradient <- gradientModes[
  gradientModes$gradientCaseID ==
    "full-geostatic-linear-gradient-unbalanced",
  ,
  drop = FALSE
]
balancedGradient <- gradientModes[
  gradientModes$gradientCaseID ==
    "balanced-full-geostatic-linear-gradient",
  ,
  drop = FALSE
]
balancedGradient <- balancedGradient[
  match(fullGradient$liningID, balancedGradient$liningID),
  ,
  drop = FALSE
]
gradientTable <- data.frame(
  section = unname(liningNames[fullGradient$liningID]),
  fz0 = formatC(
    fullGradient$globalVerticalForceKnPerM,
    format = "f",
    digits = 0
  ),
  a1s = formatC(
    balancedGradient$supportRadialMode1KPa,
    format = "f",
    digits = 0
  ),
  fz = formatC(
    balancedGradient$globalVerticalForceKnPerM,
    format = "e",
    digits = 1
  ),
  n1 = formatC(
    balancedGradient$normalMode1KnPerM,
    format = "f",
    digits = 0
  ),
  n3 = formatC(
    balancedGradient$normalMode3KnPerM,
    format = "f",
    digits = 0
  ),
  m3 = formatC(
    balancedGradient$momentMode3KnMPerM,
    format = "f",
    digits = 0
  ),
  q3 = formatC(
    balancedGradient$shearMode3KnPerM,
    format = "f",
    digits = 0
  ),
  check.names = FALSE
)
buildReportTable(
  data = gradientTable,
  headers = c("Sección", "$F_{z,0}$", "$a_1^s$", "$F_z$", "$N_1$", "$N_3$", "$M_3$", "$Q_3$"),
  align = c("l", rep("r", 7))
)
```

La corrección equilibrada se evaluó de dos maneras independientes: solución modal de Fourier e integración numérica de las ecuaciones diferenciales del anillo. La @tbl-balanced-gradient-verification informa la diferencia máxima normalizada, el residuo de equilibrio y la compresión mínima prescrita sobre el contacto.

```{r}
#| label: tbl-balanced-gradient-verification
#| tbl-cap: "Controles del gradiente equilibrado. eh: descenso de la resultante lateral; εFD: diferencia Fourier--integración; εeq: residuo de equilibrio; pn,min: compresión mínima."
gradientVerification <- read.csv(
  "data/benchmarks/ring/project-hybrid-gradient-verification.csv",
  check.names = FALSE
)
gradientVerificationTable <- data.frame(
  section = unname(liningNames[gradientVerification$liningID]),
  eh = formatC(
    100 * gradientVerification$horizontalResultantOffsetBelowAxisM,
    format = "f",
    digits = 0
  ),
  epsFd = formatC(
    gradientVerification$fourierDirectMaximumNormalizedDifference,
    format = "e",
    digits = 1
  ),
  epsEq = formatC(
    gradientVerification$fourierMaximumNormalizedEquilibriumResidual,
    format = "e",
    digits = 1
  ),
  pmin = formatC(
    gradientVerification$minimumPrescribedCompressivePressureKPa,
    format = "f",
    digits = 0
  ),
  status = ifelse(
    gradientVerification$parityStatus == "satisfied" &
      gradientVerification$equilibriumStatus == "satisfied" &
      gradientVerification$prescribedCompressionStatus == "satisfied",
    "OK",
    "FAIL"
  ),
  check.names = FALSE
)
buildReportTable(
  data = gradientVerificationTable,
  headers = c("Sección", "$e_h$ [cm]", "$\\varepsilon_{FD}$", "$\\varepsilon_{eq}$", "$p_{n,\\min}$ [kPa]", "Estado"),
  align = c("l", "r", "r", "r", "r", "c")
)
```

La comparación con la solución uniforme se presenta en la @tbl-hybrid-resultant-comparison. Las variaciones relativas grandes de momento y corte de la chapa se deben a que sus valores uniformes son pequeños; deben leerse junto con la diferencia absoluta.

```{r}
#| label: tbl-hybrid-resultant-comparison
#| tbl-cap: "Máximos absolutos para S. R: resultante; E-S: campo uniforme; H: modelo híbrido; Δ: cambio absoluto. N y Q se expresan en kN/m; M, en kN m/m."
hybridComparison <- read.csv(
  "data/benchmarks/ring/project-hybrid-resultant-comparison.csv",
  check.names = FALSE
)
hybridComparison <- hybridComparison[
  hybridComparison$interfaceID == "full-slip",
  ,
  drop = FALSE
]
resultantNames <- c(N = "N", M = "M", Q = "Q")
hybridComparisonTable <- data.frame(
  section = unname(liningNames[hybridComparison$liningID]),
  resultant = unname(resultantNames[hybridComparison$resultantID]),
  es = formatC(
    hybridComparison$schwartzEinsteinAbsoluteMaximum,
    format = "f",
    digits = 0
  ),
  hybrid = formatC(
    hybridComparison$hybridAbsoluteMaximum,
    format = "f",
    digits = 0
  ),
  delta = formatC(
    hybridComparison$absoluteMaximumChange,
    format = "f",
    digits = 0
  ),
  deltaPct = formatC(
    100 * hybridComparison$relativeMaximumChange,
    format = "f",
    digits = 0
  ),
  check.names = FALSE
)
buildReportTable(
  data = hybridComparisonTable,
  headers = c("Sección", "R", "E-S", "H", "$\\Delta$", "$\\Delta$ [%]"),
  align = c("l", "c", "r", "r", "r", "r")
)
```

La comprobación separa así cuatro preguntas: HP97 valida las ecuaciones Schwartz--Einstein; la reconstrucción $n=0,2$ valida su transferencia a las ecuaciones del anillo; el equilibrio y la paridad Fourier--integración validan la corrección $n=1,3$; y el control de compresión verifica que la acción prescrita no exige tracción de contacto. No se atribuye a E--S una impedancia para $n=1$ o $n=3$ que la formulación publicada no contiene.

## Formulaciones de Núñez

El ejemplo de Núñez de 2000 adopta $D=10\ \mathrm{m}$, profundidad del eje
$H=15\ \mathrm{m}$, $\gamma=1.9\ \mathrm{tf/m^3}$,
$q=1\ \mathrm{tf/m^2}$ y $K_0=0.5$. La @tbl-nunez-check se calculó exclusivamente con la @eq-nunez-2000-resultants
[@Nunez2000, sec. "Cálculo aproximado del revestimiento", pp. 13--15 de la versión digital]. Las fuerzas publicadas son compresiones positivas; su conversión a la convención general requiere $N_\theta=-N^{ (2000)}$.

| Revestimiento | Magnitud   | Valor publicado | Valor calculado | Unidad |
|---------------|------------|----------------:|----------------:|--------|
| primario      | $a_N$      |         $0.027$ |        $0.0270$ | ---    |
| primario      | $A_N$      |        $0.0263$ |       $0.02629$ | ---    |
| primario      | $M_{\max}$ |          $1.21$ |        $1.2118$ | tf·m/m |
| primario      | $N_C$      |          $54.5$ |         $54.34$ | tf/m   |
| permanente    | $a_N$      |          $0.11$ |       $0.10976$ | ---    |
| permanente    | $A_N$      |          $0.10$ |       $0.09890$ | ---    |
| permanente    | $M_{\max}$ |           $9.0$ |        $9.1177$ | tf·m/m |
| permanente    | $N_C$      |         $103.4$ |        $103.33$ | tf/m   |
| permanente    | $N_A$      |         $147.5$ |        $147.50$ | tf/m   |

: Reproducción de los ejemplos circulares de Núñez de 2000 [@Nunez2000, sec. "Cálculo aproximado del revestimiento", pp. 13--15 de la versión digital]. {#tbl-nunez-check}

La mayor diferencia relativa es $1.31\,\%$ y corresponde al momento del revestimiento permanente, publicado con dos cifras significativas. Para la conversión de las unidades originales se adopta
$1\ \mathrm{tf}=9.80665\ \mathrm{kN}$.

Las ecuaciones publicadas en 2014 no son intercambiables con las de 2000. La @tbl-nunez-version-check muestra las diferencias obtenidas al utilizar los mismos datos de los ejemplos precedentes en la @eq-nunez-2000-resultants y en la @eq-nunez-2014-resultants.

| Revestimiento | Magnitud   | Versión 2000 | Versión 2014 | Unidad |
|---------------|------------|-------------:|-------------:|--------|
| primario      | $M_{\max}$ |      $1.212$ |      $1.212$ | tf·m/m |
| primario      | $N_C$      |     $54.343$ |     $52.895$ | tf/m   |
| primario      | $N_A$      |     $76.250$ |     $73.750$ | tf/m   |
| permanente    | $M_{\max}$ |      $9.118$ |      $9.118$ | tf·m/m |
| permanente    | $N_C$      |    $103.331$ |    $110.137$ | tf/m   |
| permanente    | $N_A$      |    $147.500$ |    $147.500$ | tf/m   |

: Evaluación separada de las formulaciones de Núñez de 2000 y 2014. {#tbl-nunez-version-check}

La coincidencia de $M_{\max}$ no implica equivalencia entre ambas versiones:
las expresiones de fuerza normal y sus parámetros difieren. Por esta razón, cada contraste conserva íntegramente la versión bibliográfica correspondiente.

Núñez, Sfriso y Laiún publican siete comparaciones entre su formulación de 2014 y análisis bidimensionales para túneles de Buenos Aires. La @tbl-nunez-2014-case3 reproduce tres resultantes del caso 3
[@NunezSfrisoLaiun2014, tabla 3, p. 7].

| Resultante | Formulación de 2014 | Análisis bidimensional | Unidad |
|------------|--------------------:|-----------------------:|--------|
| $N_C$      |               $720$ |                  $500$ | kN/m   |
| $M_C$      |              $10.2$ |                 $10.0$ | kN·m/m |
| $M_A$      |              $13.8$ |                 $65.0$ | kN·m/m |

: Resultados publicados para el caso 3 de Núñez, Sfriso y Laiún [@NunezSfrisoLaiun2014, tabla 3, p. 7]. {#tbl-nunez-2014-case3}

La publicación señala una dispersión mayor en los momentos que en las fuerzas normales. Como no proporciona todos los parámetros necesarios para reproducir los siete casos y varias secciones no son circulares, esos valores se presentan como antecedentes publicados y no como una reproducción independiente.

## Alcance de los contrastes

| Referencia                                                | Magnitud contrastada                                            | Resultado                                                                                                                      |
|-----------------------------------------------------------|-----------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|
| Baker                                                     | $N_\theta$ y $M_\theta$ ante cargas radiales por sectores       | diferencias menores que $5\times10^{-4}$ en las magnitudes adimensionales tabuladas                                            |
| USACE, ejemplo D4                                         | presión vertical y fuerza normal circunferencial                | valores publicados reproducidos con los factores del ejemplo                                                                   |
| FHWA-RD-98-191                                            | presión horizontal de compactación                              | ocho filas reproducidas; una inconsistencia de datos identificada                                                              |
| Schwartz--Einstein, HP97                                  | fuerza normal y momento para cuatro combinaciones               | valores publicados reproducidos en la convención de la fuente                                                                  |
| Schwartz--Einstein frente a Fourier e integración directa | reconstrucción de $N$, $M$ y $Q$ mediante los modos $n=0,2$     | diferencias dentro de las tolerancias declaradas para las seis combinaciones de las secciones autónomas                        |
| gradiente lineal sobre la altura                          | modos $n=1,3$, equilibrio global y paridad Fourier--integración | la reacción radial $n=1$ equilibra el campo completo; los controles numéricos y de compresión satisfacen                       |
| Núñez 2000                                                | parámetros, fuerza normal y momento                             | diferencia relativa máxima de $1.31\,\%$ respecto de valores redondeados                                                       |
| Núñez et al. 2014                                         | comparación publicada con análisis bidimensionales              | tres resultantes publicadas para el caso 3; la información disponible no permite reproducir independientemente los siete casos |

: Contenido y alcance de los contrastes numéricos. {#tbl-verification-summary}
