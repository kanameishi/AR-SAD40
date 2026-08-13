# Resultantes seccionales {#sec-calculation-response}

## Equilibrio global

Antes de integrar la respuesta, cada estado de carga debe satisfacer

$$
R\int_0^{2\pi}
\left[P_r(\theta)\mathbf e_r(\theta)
+P_t(\theta)\mathbf e_t(\theta)\right]d\theta=\mathbf0,
\qquad
R^2\int_0^{2\pi}P_t(\theta)\,d\theta=0.
$$ {#eq-calculation-global-equilibrium}

El primer control elimina fuerzas resultantes no equilibradas y el segundo,
un par neto respecto del centro. Si el estado no cierra, deben incorporarse las
acciones y reacciones omitidas antes de calcular las resultantes internas.

## Integración directa y compatibilidad

El equilibrio de un elemento diferencial conduce al sistema

$$
\frac{d}{d\theta}
\begin{bmatrix}N_\theta\\Q_\theta\\M_\theta\end{bmatrix}
=
\begin{bmatrix}
Q_\theta-RP_t\\
RP_r-N_\theta\\
RQ_\theta
\end{bmatrix}.
$$ {#eq-calculation-first-order-system}

Sea $(\widetilde N,\widetilde Q,\widetilde M)$ la solución particular integrada
desde $\theta=0$ con valores iniciales nulos. Para una sección uniforme, la
solución compatible es

$$
\begin{aligned}
N_\theta&=\widetilde N+\lambda_c\cos\theta+\lambda_s\sin\theta,\\
Q_\theta&=\widetilde Q-\lambda_c\sin\theta+\lambda_s\cos\theta,\\
M_\theta&=\widetilde M+R\lambda_c\cos\theta
+R\lambda_s\sin\theta+\lambda_0.
\end{aligned}
$$ {#eq-calculation-general-resultants}

Las constantes se obtienen mediante periodicidad y compatibilidad de la viga
curva [@Baker1968, ecs. 2.3--2.6, pp. 16--18]:

$$
\lambda_c=-\frac{1}{\pi R}\int_0^{2\pi}\widetilde M\cos\theta\,d\theta,
\qquad
\lambda_s=-\frac{1}{\pi R}\int_0^{2\pi}\widetilde M\sin\theta\,d\theta,
$$

$$
\lambda_0=R\frac{\eta_s}{1+\eta_s}\,
\overline{\widetilde N}-\overline{\widetilde M},
\qquad
\overline f=\frac{1}{2\pi}\int_0^{2\pi}f(\theta)\,d\theta.
$$ {#eq-calculation-compatibility-constants}

Las discontinuidades de carga se incorporan como límites de integración y los
extremos se evalúan en cada intervalo continuo y en ambos lados de esos
límites.

## Soluciones de comprobación para el estado biaxial uniforme

Para las acciones de la @eq-calculation-biaxial-load, el momento medio es

$$
M_m=-R^2p_m\frac{\eta_s}{1+\eta_s}.
$$ {#eq-calculation-mean-moment}

donde $\eta_s=EI_\theta/(EA_\theta R^2)$ es la razón entre las rigideces
flexional y extensional definida en la @eq-calculation-section-stiffness.

Para $P_t=\alpha p_t^*$, la linealidad del sistema permite escribir la
respuesta para cualquier $0\leq\alpha\leq1$ como

$$
\begin{aligned}
N_\theta&=-Rp_m
+R\Delta\sigma\frac{1+2\alpha}{6}\cos2\theta,\\
M_\theta&=M_m
+R^2\Delta\sigma\frac{2+\alpha}{12}\cos2\theta,\\
Q_\theta&=-R\Delta\sigma\frac{2+\alpha}{6}\sin2\theta.
\end{aligned}
$$ {#eq-calculation-biaxial-alpha-response}

Con $\alpha=0$ se obtiene el estado de acción normal; con $\alpha=1$, el
estado que incorpora toda la componente tangencial proyectada. La
@eq-calculation-biaxial-alpha-response se emplea para comprobar la integración
directa en ambos extremos y en valores intermedios. Para distribuciones de
tensión variables con la profundidad o acciones por etapas, la respuesta se
obtiene mediante la @eq-calculation-first-order-system y la
@eq-calculation-compatibility-constants.

Las amplitudes de los tres diagramas son

$$
A_N=R\Delta\sigma\frac{1+2\alpha}{6},
\qquad
A_M=R^2\Delta\sigma\frac{2+\alpha}{12},
\qquad
A_Q=R\Delta\sigma\frac{2+\alpha}{6}.
$$ {#eq-calculation-biaxial-amplitudes}

Por lo tanto, los extremos globales del estado uniforme se obtienen sin una
búsqueda angular:

$$
N_{\theta,\min}=-Rp_m-|A_N|,
\qquad
N_{\theta,\max}=-Rp_m+|A_N|,
$$

$$
M_{\theta,\min}=M_m-|A_M|,
\qquad
M_{\theta,\max}=M_m+|A_M|,
\qquad
\max|Q_\theta|=|A_Q|.
$$ {#eq-calculation-biaxial-extrema}

La clave y el fondo corresponden a $\cos2\theta=1$; los dos puntos del
diámetro horizontal, a $\cos2\theta=-1$. La fuerza cortante se anula en esas
cuatro posiciones y alcanza su valor absoluto máximo en las direcciones
$\theta=\pi/4+k\pi/2$, con $k=0,1,2,3$. Para una acción perimetral general,
los extremos se determinan sobre cada intervalo continuo de la solución
integrada, incluyendo ambos lados de las discontinuidades de carga.
