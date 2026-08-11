# Incertidumbres y envolventes {#sec-calculation-uncertainty}

## Especificación de las variables

La simulación se define después de establecer, para cada variable, familia de
distribución, parámetros, dominio, unidad, truncamientos y dependencias. En el
relleno deben preservarse las relaciones físicas entre clasificación, peso
unitario, humedad, ángulo de fricción, estado de compactación y $K_0$; muestrear
como independientes variables vinculadas por una misma relación duplica la
incertidumbre. JCSS proporciona criterios generales para documentar modelos
probabilísticos de propiedades del suelo [@JCSS2006].

Las alternativas de modelación —por ejemplo, proyección completa y carga
exclusivamente normal— se ejecutan por separado cuando no se dispone de
probabilidades justificadas para combinarlas.

## Realizaciones y extremos espaciales

Para cada realización $j$ se calculan las acciones perimetrales y las tres
curvas de resultantes. Los extremos constructivos son

$$
X_{j,\min}^{con}=\min_{s,\theta}X_{j,s}(\theta),
\qquad
X_{j,\max}^{con}=\max_{s,\theta}X_{j,s}(\theta),
\qquad X\in\{N_\theta,M_\theta,Q_\theta\}.
$$ {#eq-calculation-spatial-extrema}

En cada intervalo continuo, los puntos estacionarios satisfacen

$$
N_\theta'=Q_\theta-RP_t=0,
\qquad
M_\theta'=RQ_\theta=0,
\qquad
Q_\theta'=RP_r-N_\theta=0.
$$ {#eq-calculation-stationarity}

También se comparan ambos límites laterales de cada discontinuidad y los
extremos del intervalo. Cada registro conserva valor, signo, ángulo, etapa y
alternativa gobernantes.

## Cuantiles puntuales y cuantiles de extremos

Para una resultante $X_j(\theta)$, el cuantil puntual es la función

$$
q_\alpha(\theta)=Q_\alpha
\{X_1(\theta),\ldots,X_{n_r}(\theta)\}.
$$

En cambio, si $X_{j,\max}=\max_\theta X_j(\theta)$,

$$
q_{\alpha,\max}=Q_\alpha
\{X_{1,\max},\ldots,X_{n_r,\max}\},
$$

y, en general,

$$
\max_\theta q_\alpha(\theta)
\ne Q_\alpha\{\max_\theta X_j(\theta)\}.
$$ {#eq-calculation-quantiles}

Los cuantiles puntuales se representan como bandas angulares. Los cuantiles de
mínimos, máximos y máximos absolutos son escalares y se informan por separado;
no se les asigna un ángulo ficticio.

## Envolvente exterior de alternativas

Sean $m$ alternativas de modelación evaluadas de forma separada. La envolvente
exterior de los intervalos puntuales se define como

$$
L(\theta)=\min_m q_{\alpha_L}^{(m)}(\theta),
\qquad
U(\theta)=\max_m q_{\alpha_U}^{(m)}(\theta).
$$ {#eq-calculation-model-envelope}

Esta operación no asigna probabilidades implícitas a las alternativas y
permite identificar cuál gobierna en cada posición.

## Precisión de la simulación

La estabilidad de cada cuantil o extremo $\widehat S$ se evalúa mediante
remuestreo bootstrap [@Efron1979Bootstrap]. Para un intervalo percentil de
nivel $1-\beta$ [@Efron1987BetterBootstrap, sec. 3, ec. 3.8, p. 173],

$$
L_S=Q_{\beta/2}\{S_1^*,\ldots,S_B^*\},
\qquad
U_S=Q_{1-\beta/2}\{S_1^*,\ldots,S_B^*\},
\qquad
h_S=\frac{U_S-L_S}{2},
$$

$$
h_S\le\varepsilon_{abs,S}
+\varepsilon_{rel,S}|\widehat S|,
\qquad
\min\{\lfloor n_r\alpha\rfloor,
\lfloor n_r(1-\alpha)\rfloor\}\ge n_{tail,min}.
$$ {#eq-calculation-monte-carlo-convergence}

Las frecuencias de etapa o sector gobernante se controlan mediante intervalos
binomiales de Wilson [@Wilson1927]. El tamaño de muestra, los cuantiles de
interés, el número de remuestras y las tolerancias deben fijarse antes de
ejecutar la evaluación.

En la información disponible no están definidas las distribuciones conjuntas,
las dependencias, las etapas ni esos criterios de precisión. En consecuencia,
la memoria establece el cálculo probabilístico y sus productos, pero no
informa cuantiles ni envolventes del revestimiento existente.
