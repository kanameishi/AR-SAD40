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

Las discontinuidades se incorporan como límites de integración. La integración
directa evita que la oscilación de una serie truncada gobierne los extremos de
una carga por sectores. La formulación modal se conserva como control
independiente en el apartado A.3 del Apéndice A.

## Soluciones cerradas para el estado biaxial uniforme

Para las acciones de la @eq-calculation-biaxial-load, el momento medio es

$$
M_m=-R^2p_m\frac{\eta_s}{1+\eta_s}.
$$ {#eq-calculation-mean-moment}

La proyección completa produce

$$
\begin{aligned}
N_\theta&=-Rp_m+\frac{R\Delta\sigma}{2}\cos2\theta,\\
M_\theta&=M_m+\frac{R^2\Delta\sigma}{4}\cos2\theta,\\
Q_\theta&=-\frac{R\Delta\sigma}{2}\sin2\theta.
\end{aligned}
$$ {#eq-calculation-biaxial-complete-response}

La carga exclusivamente normal produce

$$
\begin{aligned}
N_\theta&=-Rp_m+\frac{R\Delta\sigma}{6}\cos2\theta,\\
M_\theta&=M_m+\frac{R^2\Delta\sigma}{6}\cos2\theta,\\
Q_\theta&=-\frac{R\Delta\sigma}{3}\sin2\theta.
\end{aligned}
$$ {#eq-calculation-biaxial-normal-response}

Estas expresiones se utilizan como soluciones de control y para el escenario
de la @sec-calculation-application.

## Influencia de la tapada y de $K_0$

En un relleno homogéneo seco,

$$
\sigma'_{v,A}=q'+\gamma'(H_0+R),
\qquad
p_m=\frac{1+K_0}{2}\sigma'_{v,A},
\qquad
\Delta\sigma=(1-K_0)\sigma'_{v,A}.
$$ {#eq-calculation-cover-k0}

Para la proyección completa, las amplitudes del armónico de orden dos son

$$
A_{N,2}=\frac{R}{2}|1-K_0|\sigma'_{v,A},
\qquad
A_{M,2}=\frac{R^2}{4}|1-K_0|\sigma'_{v,A},
\qquad
|Q_\theta|_{\max}=\frac{R}{2}|1-K_0|\sigma'_{v,A}.
$$ {#eq-calculation-cover-sensitivity}

La tapada y la sobrecarga incrementan linealmente la presión media y la
amplitud desviadora en este caso homogéneo. Cuando $K_0\to1$, desaparece el
armónico de ovalización y permanece la compresión uniforme. Una diferencia
uniforme de presión de agua modifica $p_m$, pero no $\Delta\sigma$.
