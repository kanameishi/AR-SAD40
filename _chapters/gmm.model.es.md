El término $P[I > i^* \mid m,\mathbf{r}]$ en la integral de amenaza representa la predicción probabilística de excedencia del modelo de predicción de movimiento sísmico y puede obtenerse a partir de ecuaciones de predicción de movimiento sísmico (GMPE). Las GMPE son modelos empíricos o semiempíricos que predicen la distribución estadística de medidas de intensidad del movimiento del suelo (por ejemplo, PGA, aceleración espectral) dadas las características de un sismo. Una GMPE suele proporcionar una predicción mediana del movimiento del suelo (a menudo en unidades $\log_{10}$ o de logaritmo natural) como función de parámetros tales como la magnitud $M$, la distancia fuente-sitio $R$ y la condición de sitio, junto con una estimación de la **variabilidad aleatoria** (la desviación estándar $\sigma$ de los residuos logarítmicos) [@Boore2008]. Una forma genérica de una GMPE para una medida de intensidad arbitraria $I$ se da en [-@eq-gmpe], donde $F$ y $S$ son variables indicadoras del tipo de falla (por ejemplo, inversa/normal) y de la clase de sitio (por ejemplo, roca o suelo), y $\varepsilon$ es una variable aleatoria normal estándar (de media cero) que representa la dispersión aleatoria, con $\sigma_{\ln I}$ como desviación estándar logarítmica. ($\varepsilon$ es una variable aleatoria que representa el residuo, en unidades logarítmicas, para un evento individual) [@Boore2008].

$$
\ln I \approx \hat{\eta}_I(m,\mathbf{r},F,S)\;+\;\varepsilon\,\sigma_{\ln I},
$${#eq-gmpe}

Si $\hat\eta_I(m,r,F,S)$ denota la intensidad mediana $I$ (en unidades lineales) para una magnitud $m$ a distancia $r$ y $\sigma_{\ln I}$ es la desviación estándar de $\ln I$, entonces la probabilidad condicional de excedencia puede expresarse como en [-@eq-gmpe-exc], donde $\Phi$ es la función de distribución acumulada normal estándar. La cantidad $\varepsilon^*$, definida en [-@eq-epsilon-star], representa el número de desviaciones estándar en que $i^*$ excede la predicción mediana para el escenario $(m,r,F,S)$.

$$
P[I > i^* \mid m,\mathbf{r}] \;=\; 1 \;-\; \Phi\left(\varepsilon^*\right),
$${#eq-gmpe-exc}

$$
\varepsilon^* \;=\; \frac{\ln i^* - \ln \hat{\eta}_I(m,\mathbf{r},F,S)}{\sigma_{\ln I}}
$${#eq-epsilon-star}

La desviación estándar aleatoria total $\sigma_{\ln I}$ satisface la relación de suma en cuadratura [-@eq-sigma-decomp], donde $\tau$ es la desviación estándar entre eventos (inter-evento) y $\phi$ es la desviación estándar intraevento, ambas expresadas en unidades de logaritmo natural.

$$
\sigma_{\ln I}^2 = \tau^2 + \phi^2
$${#eq-sigma-decomp}

Bajo la descomposición de efectos mixtos adoptada por la mayoría de las GMPE empíricas modernas, el residuo total del registro $j$ perteneciente al evento $i$ se particiona como en [-@eq-mixed-effects], donde $\eta_i \sim \mathcal{N}(0, \tau^2)$ es el residuo entre eventos para el evento $i$, que representa variación sistemática de fuente a fuente no capturada por la forma funcional mediana, y $\delta_{ij} \sim \mathcal{N}(0, \phi^2)$ es el residuo intraevento para el registro $j$, que representa variabilidad de trayectoria y sitio no resuelta por la predicción mediana. Se supone que los dos componentes residuales son mutuamente independientes. Las tres cantidades $\sigma_{\ln I}$, $\tau$ y $\phi$ dependen del período en la mayoría de las GMPE modernas y se tabulan o parametrizan como parte del modelo publicado. Las formulaciones no ergódicas particionan además $\tau$ y $\phi$ en componentes específicos del sitio y de la trayectoria; los modelos documentados en este capítulo son predominantemente ergódicos.

$$
\varepsilon_{ij} = \eta_i + \delta_{ij}
$${#eq-mixed-effects}

Las variables predictoras que entran en una GMPE varían según el modelo y el tipo de región tectónica, pero la siguiente notación se aplica de manera consistente en todos los modelos documentados en este capítulo. La magnitud de momento $M_w$ es el parámetro primario de tamaño de la fuente. Cada modelo declara la métrica de distancia que requiere como parte de su implementación. La amplificación de sitio se parametriza principalmente mediante $V_{S30}$, la velocidad de onda de corte promediada según el tiempo de viaje de los 30 m superiores. La profundidad de cuenca se captura mediante $z_{1.0}$, la profundidad hasta el horizonte donde la velocidad de onda de corte alcanza por primera vez 1.0 km/s, y mediante $z_{2.5}$, la profundidad hasta el horizonte de 2.5 km/s. Los descriptores de geometría de ruptura incluyen $z_{tor}$, la profundidad hasta la parte superior del plano de ruptura; el ángulo de buzamiento de la falla; el ángulo de rake que caracteriza el estilo de falla; el ancho de ruptura en la dirección del buzamiento $W$; y la profundidad hipocentral $h$. Para modelos de subducción, ciertas implementaciones requieren además un indicador binario de trasarco que distingue posiciones de sitio de antearco y trasarco.
