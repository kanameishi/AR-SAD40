# Tratamiento de incertidumbres y construcción de envolventes

## Variables y dependencias

La incertidumbre geotécnica y constructiva se propaga mediante simulación
Monte Carlo. En cada realización se recalculan las acciones perimetrales y las
tres resultantes seccionales. La geometría confirmada del conducto se trata
como determinista. Los valores geométricos que todavía no estén confirmados
se evalúan como alternativas deterministas y se mantienen separados de la
variabilidad del relleno.

Cada variable queda documentada mediante su definición, unidades, procedencia,
dominio de admisibilidad y relaciones de dependencia. JCSS aporta criterios
para seleccionar familias compatibles con el dominio de la variable y con la
información estadística disponible, y para representar variabilidad,
incertidumbre estadística y correlación entre propiedades
[@JCSS2006, secs. 3.7.2--3.7.4].

| Grupo | Magnitudes | Evidencia requerida |
|---|---|---|
| estado vertical | $\gamma'_j$, espesores de capas, $q'$, $z_w$, $\gamma_w$ | perfil geotécnico, ensayos y condición hidráulica |
| estado lateral | $K_0$ o variables que lo determinan; $\Delta\sigma'_{h,c}$ | tipo de suelo, historia tensional y compactación |
| construcción | fuerza y posición del equipo, espesor y secuencia de tongadas | registros de obra o escenarios constructivos definidos |
| transferencia de carga | deslizamiento libre o ausencia de deslizamiento en Schwartz--Einstein | alternativas discretas sin pesos probabilísticos mientras no exista calibración |

: Magnitudes incluidas en la propagación de incertidumbre. {#tbl-uncertain-inputs}

Las dependencias físicas se conservan durante el muestreo. Cuando $K_0$ se
calcula a partir de $\phi'$ mediante la @eq-k0-jaky, ambas magnitudes forman una
misma relación y $K_0$ no se muestrea de manera independiente. De modo análogo,
un valor de $K_{0,c}$ que ya representa el estado compactado sustituye al par
$(K_{0,b},\Delta\sigma'_{h,c})$ de la @eq-compaction-history.

## Secuencia de cálculo por realización

Sea $\mathbf X_j$ el vector conjunto de variables correspondiente a la
realización $j$. La evaluación sigue la cadena

$$
\mathbf X_j
\longrightarrow
\{\sigma'_{v,j},\sigma'_{h,j},C_j^*,F_j^*,i_j\}
\longrightarrow
\{N_{\theta,j}(\theta),M_{\theta,j}(\theta),Q_{\theta,j}(\theta)\}.
$$ {#eq-monte-carlo-chain}

$i_j$ identifica la condición discreta de interfaz de la realización.

Cada realización comprende las siguientes operaciones:

1. integrar las tensiones verticales y la diferencia de presión intersticial;
2. determinar el estado lateral y las acciones constructivas;
3. calcular $C^*$ y $F^*$ para la sección correspondiente;
4. resolver Schwartz--Einstein para cada condición de interfaz;
5. ejecutar por separado los controles de carga prescrita; y
6. registrar las distribuciones, los valores en posiciones de interés y los
   extremos sobre toda la circunferencia.

Las etapas de compactación se conservan dentro de cada realización. Para una
magnitud $X\in\{N_\theta,M_\theta,Q_\theta\}$ y etapas
$s=1,\ldots,n_s$,

$$
X_{j,\min}^{\mathrm{con}}=\min_{s,\theta}X_{j,s}(\theta),
\qquad
X_{j,\max}^{\mathrm{con}}=\max_{s,\theta}X_{j,s}(\theta).
$$ {#eq-construction-extremes}

Este orden conserva la coincidencia entre el valor extremo, su posición y la
etapa que lo produce.

La circunferencia se divide en los intervalos definidos por las
discontinuidades de $P_r(\theta)$ y $P_t(\theta)$. En cada intervalo abierto,
las posiciones estacionarias se obtienen de

$$
N_\theta'=Q_\theta-RP_t=0,
\qquad
M_\theta'=RQ_\theta=0,
\qquad
Q_\theta'=RP_r-N_\theta=0.
$$ {#eq-spatial-stationarity}

Para cada resultante se comparan los valores en todas sus posiciones
estacionarias y en los límites laterales de cada intervalo. El registro del
extremo conserva $\theta$, la etapa constructiva y el lado del límite. Cuando
las raíces se obtienen numéricamente, se fijan una tolerancia angular
$\varepsilon_\theta$ y una tolerancia de resultante $\varepsilon_X$; el
refinamiento de los intervalos continúa hasta que la posición y la magnitud del
extremo varían menos que esas tolerancias.

## Cuantiles puntuales y cuantiles de extremos

Para una muestra ordenada $x_{(1)}\leq\cdots\leq x_{(n_r)}$ y
$0<\alpha<1$, se adopta el estimador lineal definido por

$$
h=1+(n_r-1)\alpha,
\quad j=\lfloor h\rfloor,
\quad g=h-j,
\quad
Q_\alpha=(1-g)x_{(j)}+g x_{(j+1)},
$$ {#eq-quantile-estimator}

con $Q_0=x_{(1)}$ y $Q_1=x_{(n_r)}$. Esta definición se mantiene para todos
los cuantiles calculados.

El cuantil puntual de orden $\alpha$ se calcula, para cada ángulo, como

$$
q_\alpha(\theta)=Q_\alpha
\left\{X_1(\theta),\ldots,X_{n_r}(\theta)\right\}.
$$ {#eq-pointwise-quantile}

La distribución del máximo espacial se obtiene en cambio a partir de

$$
X_{j,\max}=\max_\theta X_j(\theta),
\qquad
q_{\alpha,\max}=Q_\alpha
\left\{X_{1,\max},\ldots,X_{n_r,\max}\right\},
$$ {#eq-maximum-quantile}

y de manera análoga para el mínimo. En general,

$$
\max_\theta q_\alpha(\theta)
\ne
Q_\alpha\left\{\max_\theta X_j(\theta)\right\}.
$$ {#eq-quantile-distinction}

Los resultados comprenden bandas puntuales y distribuciones de extremos
espaciales. Cuando varias posiciones coinciden con un extremo dentro de la
tolerancia numérica de la integración, se conservan todas las posiciones
coincidentes.

## Alternativas de modelación

Las prescripciones de transferencia tangencial, el tratamiento del gradiente,
la compactación residual y las formulaciones de interacción se evalúan por
separado. Sea $m$ una alternativa y sean
$q_{\alpha_L}^{(m)}(\theta)$ y $q_{\alpha_U}^{(m)}(\theta)$ sus cuantiles
inferior y superior. La envolvente exterior entre alternativas es

$$
L(\theta)=\min_m q_{\alpha_L}^{(m)}(\theta),
\qquad
U(\theta)=\max_m q_{\alpha_U}^{(m)}(\theta).
$$ {#eq-model-envelope}

Esta banda reúne resultados condicionales a distintas hipótesis. Su carácter
desfavorable sólo puede establecerse posteriormente para cada estado límite,
teniendo en cuenta la magnitud y el signo de las resultantes. Una combinación
probabilística entre alternativas requiere probabilidades de modelo
sustentadas en evidencia.

## Precisión de la simulación

La incertidumbre de muestreo se controla sobre los estadísticos de respuesta
de la @tbl-monte-carlo-controls. Antes de la simulación se fijan el tamaño
mínimo $n_{min}$, el incremento $n_b$, el número $B$ de remuestras, el nivel de
confianza $1-\beta$ y las tolerancias absoluta y relativa de cada estadístico.

| Estadístico de respuesta | Dominio de control | Tolerancias requeridas |
|---|---|---|
| cuantiles puntuales de $N_\theta$, $M_\theta$ y $Q_\theta$ | $\theta=0,\pi/4,\pi/2,3\pi/4,\pi,5\pi/4,3\pi/2,7\pi/4$; límites laterales de cada discontinuidad de carga y posiciones adicionales exigidas por la verificación | $\varepsilon_{abs,q}$ en unidades de la resultante y $\varepsilon_{rel,q}$ |
| cuantiles de máximos y mínimos espaciales | circunferencia completa y todas las etapas constructivas | $\varepsilon_{abs,q}$ y $\varepsilon_{rel,q}$ |
| frecuencia con que cada etapa y cada sector angular producen el extremo | categorías marginales de etapa y de sector angular | $\varepsilon_{abs,f}$ |

: Estadísticos utilizados para controlar la precisión de la simulación. {#tbl-monte-carlo-controls}

Para una muestra de $n_r$ realizaciones se generan $B$ remuestras, con
reposición y de tamaño $n_r$ [@Efron1979Bootstrap]. Sea $S$ uno de los estadísticos cuantitativos de
las dos primeras filas de la tabla y $S_b^*$ su valor en la remuestra $b$. El
intervalo de confianza percentil y su semiancho se definen mediante
[@Efron1987BetterBootstrap, sec. 3, ec. 3.8, p. 173]

$$
L_S=Q_{\beta/2}\{S_1^*,\ldots,S_B^*\},
\qquad
U_S=Q_{1-\beta/2}\{S_1^*,\ldots,S_B^*\},
$$

$$
h_S=\frac{U_S-L_S}{2}.
$$ {#eq-monte-carlo-precision}

La muestra satisface la precisión requerida cuando, simultáneamente para todos
los estadísticos,

$$
h_S\leq
\varepsilon_{abs,S}
+\varepsilon_{rel,S}\lvert\widehat S\rvert.
$$ {#eq-monte-carlo-convergence}

Las frecuencias de etapa o sector se controlan mediante el intervalo binomial
de Wilson, que mantiene ancho positivo cuando el conteo observado es cero o
$n_r$ [@Wilson1927]. Para
$y$ ocurrencias, $\widehat p=y/n_r$ y
$z=z_{1-\beta/2}$, el centro $c_p$ y el semiancho $h_p$ son

$$
c_p=
\frac{\widehat p+z^2/(2n_r)}{1+z^2/n_r},
\qquad
h_p=
\frac{z}{1+z^2/n_r}
\sqrt{
\frac{\widehat p(1-\widehat p)}{n_r}
+\frac{z^2}{4n_r^2}
}.
$$ {#eq-monte-carlo-frequency-precision}

La frecuencia satisface la precisión requerida cuando
$h_p\leq\varepsilon_{abs,f}$.

Para un cuantil de orden $\alpha$ se exige además un número mínimo
$n_{tail,min}$ de realizaciones en ambas colas:

$$
\min\{\lfloor n_r\alpha\rfloor,
\lfloor n_r(1-\alpha)\rfloor\}\geq n_{tail,min}.
$$ {#eq-monte-carlo-tail}

Esta condición evita aceptar intervalos artificialmente estrechos en colas
escasamente muestreadas. Si la distribución empírica presenta un salto en el
cuantil objetivo, se informa el intervalo completo y la frecuencia de la masa
asociada se controla mediante la @eq-monte-carlo-frequency-precision. En caso
de incumplimiento se agregan $n_b$
realizaciones y se repite la evaluación. El registro del cálculo incluye
$n_{min}$, $n_b$, $B$, $1-\beta$, $n_{tail,min}$, las tolerancias, las semillas
aleatorias, el tamaño final de muestra, la definición del cuantil y la
distribución conjunta de las variables.
