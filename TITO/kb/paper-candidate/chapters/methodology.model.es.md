# Formulación estructural de la sección transversal

## Ecuaciones de equilibrio

La tesis de Baker establece las ecuaciones de una viga curva circular bajo
carga radial prescrita [@Baker1968, ecs. 2.1a--2.1c, p. 16]. La generalización
a una carga tangencial se obtiene mediante equilibrio vectorial. Para la base
polar definida en la sección de alcance,

$$
\frac{d\mathbf e_r}{d\theta}=\mathbf e_t,
\qquad
\frac{d\mathbf e_t}{d\theta}=-\mathbf e_r.
$$

La fuerza interna sobre la cara positiva del elemento es
$N_\theta\mathbf e_t-Q_\theta\mathbf e_r$. Al equilibrar fuerzas y momentos
con la carga
$R(P_r\mathbf e_r+P_t\mathbf e_t)d\theta$ se obtiene

$$
R Q_\theta-\frac{dM_\theta}{d\theta}=0,
$$ {#eq-ring-equilibrium-m}

$$
R P_r-N_\theta-\frac{dQ_\theta}{d\theta}=0,
$$ {#eq-ring-equilibrium-r}

$$
\frac{dN_\theta}{d\theta}-Q_\theta+R P_t=0.
$$ {#eq-ring-equilibrium-t}

La sustitución $P_t=0$ produce el sistema radial de Baker. Las distribuciones
de carga consideradas satisfacen

$$
R\int_0^{2\pi}
\left[P_r(\theta)\,\mathbf e_r(\theta)
+P_t(\theta)\,\mathbf e_t(\theta)\right]d\theta
=\mathbf 0,
$$

$$
R^2\int_0^{2\pi}P_t(\theta)\,d\theta=0.
$$ {#eq-global-equilibrium}

Estas condiciones expresan fuerza y momento globales nulos. Un estado con peso,
flotación o apoyo se incorpora únicamente después de formular todas sus cargas
y reacciones de modo que el conjunto cumpla la @eq-global-equilibrium.

## Integración directa y cierre por compatibilidad

Las @eq-ring-equilibrium-m, @eq-ring-equilibrium-r y
@eq-ring-equilibrium-t forman el sistema

$$
\frac{d}{d\theta}
\begin{bmatrix}
N_\theta\\ Q_\theta\\ M_\theta
\end{bmatrix}
=
\begin{bmatrix}
Q_\theta-RP_t\\
RP_r-N_\theta\\
RQ_\theta
\end{bmatrix}.
$$ {#eq-first-order-system}

Sea $(\widetilde N,\widetilde Q,\widetilde M)$ una solución particular obtenida
al integrar la @eq-first-order-system desde $\theta=0$ con valores iniciales
nulos. La solución general equilibrada es

$$
N_\theta=\widetilde N+\lambda_c\cos\theta+\lambda_s\sin\theta,
$$

$$
Q_\theta=\widetilde Q-\lambda_c\sin\theta+\lambda_s\cos\theta,
$$

$$
M_\theta=\widetilde M
+R\lambda_c\cos\theta+R\lambda_s\sin\theta+\lambda_0.
$$ {#eq-general-resultants}

Se define

$$
\overline f=\frac{1}{2\pi}\int_0^{2\pi}f(\theta)\,d\theta,
\qquad
\eta_s=\frac{EI_\theta}{EA_\theta R^2}.
$$ {#eq-section-ratio}

Las relaciones cinemáticas y constitutivas de la viga curva de Baker
[@Baker1968, ecs. 2.3--2.6, pp. 16--18] conducen, después de imponer
periodicidad de desplazamientos y giro, a

$$
\int_0^{2\pi}M_\theta\cos\theta\,d\theta=0,
\qquad
\int_0^{2\pi}M_\theta\sin\theta\,d\theta=0,
$$

$$
\overline M_\theta=R\frac{\eta_s}{1+\eta_s}\,\overline N_\theta.
$$ {#eq-compatibility-conditions}

La sustitución de la @eq-general-resultants en estas tres condiciones produce

$$
\lambda_c=-\frac{1}{\pi R}
\int_0^{2\pi}\widetilde M(\theta)\cos\theta\,d\theta,
$$

$$
\lambda_s=-\frac{1}{\pi R}
\int_0^{2\pi}\widetilde M(\theta)\sin\theta\,d\theta,
$$

$$
\lambda_0=R\frac{\eta_s}{1+\eta_s}\,
\overline{\widetilde N}-\overline{\widetilde M}.
$$ {#eq-compatibility-constants}

La integración directa resuelve distribuciones equilibradas de $P_r(\theta)$ y
$P_t(\theta)$ para una sección uniforme, elástica lineal y de pequeñas
deformaciones. Las cargas por sectores se integran separadamente entre sus
ángulos de discontinuidad, manteniendo la continuidad de las tres resultantes.

## Representación mediante series de Fourier

Las cargas periódicas se expresan como

$$
P_r(\theta)=a_0+\sum_{n=1}^{\infty}
\left(a_n\cos n\theta+b_n\sin n\theta\right),
$$

$$
P_t(\theta)=c_0+\sum_{n=1}^{\infty}
\left(c_n\cos n\theta+d_n\sin n\theta\right),
$$ {#eq-load-fourier}

con

$$
a_0=\frac{1}{2\pi}\int_0^{2\pi}P_r\,d\theta,
\quad
a_n=\frac{1}{\pi}\int_0^{2\pi}P_r\cos n\theta\,d\theta,
\quad
b_n=\frac{1}{\pi}\int_0^{2\pi}P_r\sin n\theta\,d\theta,
$$

$$
c_0=\frac{1}{2\pi}\int_0^{2\pi}P_t\,d\theta,
\quad
c_n=\frac{1}{\pi}\int_0^{2\pi}P_t\cos n\theta\,d\theta,
\quad
d_n=\frac{1}{\pi}\int_0^{2\pi}P_t\sin n\theta\,d\theta.
$$ {#eq-load-coefficients}

La sustitución coeficiente por coeficiente en las ecuaciones de equilibrio
produce, para $n\geq2$,

$$
N_n^{(c)}=R\frac{n d_n-a_n}{n^2-1},
\qquad
N_n^{(s)}=-R\frac{b_n+n c_n}{n^2-1},
$$

$$
Q_n^{(c)}=-R\frac{n b_n+c_n}{n^2-1},
\qquad
Q_n^{(s)}=R\frac{n a_n-d_n}{n^2-1},
$$

$$
M_n^{(c)}=-R^2\frac{n a_n-d_n}{n(n^2-1)},
\qquad
M_n^{(s)}=-R^2\frac{n b_n+c_n}{n(n^2-1)}.
$$ {#eq-modal-resultants}

Estas expresiones incluyen la componente tangencial. Su sustitución satisface
las tres ecuaciones diferenciales. Para una misma representación de carga y una
serie convergida, los coeficientes modales coinciden con la integración directa
dentro de la tolerancia adoptada.

La contribución uniforme satisface

$$
N_0=Ra_0,
\qquad
Q_0=0,
\qquad
M_0=R\frac{\eta_s}{1+\eta_s}N_0.
$$ {#eq-uniform-mode}

El término de momento uniforme corresponde al modo axisimétrico de deformación
circunferencial de Baker [@Baker1968, ec. 3.9, p. 21]. La idealización
puramente membranal corresponde a $\eta_s=0$. Se impone $c_0=0$, porque una
componente tangencial media representa un par externo que requiere un estado
de reacción definido.

El armónico $n=1$ contiene las fuerzas resultantes. Para una distribución
autoequilibrada,

$$
b_1+c_1=0,
\qquad
-a_1+d_1=0.
$$ {#eq-first-mode-balance}

Los armónicos $n\geq2$ son autoequilibrados: $n=2$ describe el modo de
ovalización y los órdenes superiores representan variaciones localizadas o
cargas por sectores. El número de términos se selecciona comprobando la
convergencia de las cargas reconstruidas y de los extremos de
$N_\theta$, $M_\theta$ y $Q_\theta$. Para cargas discontinuas, la integración
directa evita que las oscilaciones de truncamiento condicionen los extremos.

## Solución cerrada para un estado biaxial uniforme

La sustitución de las @eq-normal-pressure y @eq-tangential-traction produce un
término uniforme y un armónico de orden dos. El momento medio es

$$
M_m=-R^2p_m\frac{\eta_s}{1+\eta_s}.
$$ {#eq-mean-moment}

### Proyección completa del estado biaxial

Cuando se aplican ambas componentes del vector de tracción,

$$
N_\theta(\theta)=-Rp_m
+\frac{R\Delta\sigma}{2}\cos2\theta,
$$

$$
M_\theta(\theta)=M_m
+\frac{R^2\Delta\sigma}{4}\cos2\theta,
$$

$$
Q_\theta(\theta)=-\frac{R\Delta\sigma}{2}\sin2\theta.
$$ {#eq-k0-full-response}

### Carga exclusivamente normal

Para $P_t(\theta)=0$,

$$
N_\theta(\theta)=-Rp_m
+\frac{R\Delta\sigma}{6}\cos2\theta,
$$

$$
M_\theta(\theta)=M_m
+\frac{R^2\Delta\sigma}{6}\cos2\theta,
$$

$$
Q_\theta(\theta)=-\frac{R\Delta\sigma}{3}\sin2\theta.
$$ {#eq-k0-normal-response}

La @tbl-k0-extrema reúne los valores en las posiciones principales para el
caso $\Delta\sigma>0$.

| Prescripción de carga | Posición | $N_\theta$ | $M_\theta$ | $Q_\theta$ |
|---|---|---:|---:|---:|
| proyección completa | clave y solera | $-Rp_m+R\Delta\sigma/2$ | $M_m+R^2\Delta\sigma/4$ | $0$ |
| proyección completa | hastiales | $-Rp_m-R\Delta\sigma/2$ | $M_m-R^2\Delta\sigma/4$ | $0$ |
| proyección completa | $\theta=45^\circ,135^\circ,225^\circ,315^\circ$ | $-Rp_m$ | $M_m$ | $\lvert Q_\theta\rvert_{\max}=R\lvert\Delta\sigma\rvert/2$ |
| exclusivamente normal | clave y solera | $-Rp_m+R\Delta\sigma/6$ | $M_m+R^2\Delta\sigma/6$ | $0$ |
| exclusivamente normal | hastiales | $-Rp_m-R\Delta\sigma/6$ | $M_m-R^2\Delta\sigma/6$ | $0$ |
| exclusivamente normal | $\theta=45^\circ,135^\circ,225^\circ,315^\circ$ | $-Rp_m$ | $M_m$ | $\lvert Q_\theta\rvert_{\max}=R\lvert\Delta\sigma\rvert/3$ |

: Resultantes en las posiciones principales del revestimiento circular. {#tbl-k0-extrema}

## Influencia de la tapada y de $K_0$

Para un relleno homogéneo, seco, sin incremento horizontal residual y con el
estado evaluado a la cota del eje,

$$
\sigma'_{v,A}=q'+\gamma'(H_0+R),
\qquad
\sigma'_{h,A}=K_0\sigma'_{v,A},
$$

$$
p_m=\frac{1+K_0}{2}\sigma'_{v,A},
\qquad
\Delta\sigma=(1-K_0)\sigma'_{v,A}.
$$ {#eq-cover-k0}

La tapada incrementa linealmente la tensión vertical en este estado geostático.
La componente uniforme de $N_\theta$ varía con
$(1+K_0)\sigma'_{v,A}$ y la amplitud del modo de ovalización con
$\lvert1-K_0\rvert\sigma'_{v,A}$. Para la proyección completa, las amplitudes
respecto del valor medio son

$$
A_{N,2}=\frac{R}{2}\lvert1-K_0\rvert\sigma'_{v,A},
\qquad
A_{M,2}=\frac{R^2}{4}\lvert1-K_0\rvert\sigma'_{v,A},
$$

$$
\lvert Q_\theta\rvert_{\max}
=\frac{R}{2}\lvert1-K_0\rvert\sigma'_{v,A}.
$$ {#eq-cover-sensitivity}

Cuando $K_0=1$, el estado biaxial es isotrópico y $N_\theta$ es uniforme. Una
diferencia uniforme de presión intersticial incrementa su magnitud y mantiene
$\Delta\sigma$ sin cambios; el gradiente hidráulico se considera junto con la
flotación y las reacciones de apoyo.
