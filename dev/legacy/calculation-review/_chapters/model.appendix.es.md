Este apéndice respalda el modelo presentado en @sec-calculation-model. Reúne
las relaciones de equilibrio, rigidez y compatibilidad empleadas para
determinar las resultantes seccionales de una línea circular de referencia.
Se considera un problema transversal plano, con
pequeños desplazamientos, respuesta elástica lineal, propiedades
circunferenciales constantes y deformación por corte despreciada.

El equilibrio del elemento diferencial se formula con un eje global $x$
positivo hacia la derecha y un eje $z$ positivo
hacia abajo. Con $\theta=0$ en la clave y sentido horario positivo,

$$
\mathbf e_r=\sin\theta\,\mathbf e_x-\cos\theta\,\mathbf e_z,
\qquad
\mathbf e_t=\cos\theta\,\mathbf e_x+\sin\theta\,\mathbf e_z.
$$

Por lo tanto,
$d\mathbf e_r/d\theta=\mathbf e_t$ y
$d\mathbf e_t/d\theta=-\mathbf e_r$. La fuerza interna sobre la cara
positiva del elemento se expresa, por unidad de ancho axial proyectado, como

$$
\mathbf F(\theta)=N_\theta\mathbf e_t-Q_\theta\mathbf e_r.
$$

Su derivada es

$$
\frac{d\mathbf F}{d\theta}
=\left(\frac{dN_\theta}{d\theta}-Q_\theta\right)\mathbf e_t
+\left(-N_\theta-\frac{dQ_\theta}{d\theta}\right)\mathbf e_r.
$$

El equilibrio de fuerzas de un elemento de longitud $R\,d\theta$ exige

$$
\frac{d\mathbf F}{d\theta}
+R(P_r\mathbf e_r+P_t\mathbf e_t)=\mathbf0.
$$

Las proyecciones tangencial y radial proporcionan

$$
\frac{dN_\theta}{d\theta}=Q_\theta-RP_t,
\qquad
\frac{dQ_\theta}{d\theta}=RP_r-N_\theta.
$$

En ausencia de un par distribuido, el equilibrio de momentos del mismo
elemento conduce a

$$
\frac{dM_\theta}{d\theta}=RQ_\theta.
$$

Las tres relaciones se reúnen en

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

Para $P_t=0$ se recupera la formulación radial de Baker
[@Baker1968, ecs. 2.1a--2.1c, p. 16]; el término $RP_t$ resulta de la
proyección tangencial de la acción perimetral.

La solución de producción integra este sistema con el método explícito de
Runge--Kutta de cuarto orden. La malla de integración reúne una partición
uniforme de la circunferencia, los ángulos en los que se solicitan resultados
y los puntos de discontinuidad declarados por la carga. En una discontinuidad,
los valores de los extremos se toman desde el interior de cada intervalo para
evitar contar dos veces el salto. Durante la misma marcha se acumulan las
integrales de compatibilidad y las tres resultantes globales; por ello el
procedimiento admite una distribución perimetral prescrita sin suponer de
antemano una forma sinusoidal.

Las resultantes globales de las acciones son

$$
\begin{aligned}
F_x&=R\int_0^{2\pi}
\left(P_r\sin\theta+P_t\cos\theta\right)d\theta,\\
F_z&=R\int_0^{2\pi}
\left(-P_r\cos\theta+P_t\sin\theta\right)d\theta,\\
M_c&=R^2\int_0^{2\pi}P_t\,d\theta.
\end{aligned}
$$ {#eq-calculation-appendix-global-components}

Para la solución particular iniciada con
$\widetilde N(0)=\widetilde Q(0)=\widetilde M(0)=0$, la integración en una
vuelta completa da

$$
\widetilde N(2\pi)=-F_x,
\qquad
\widetilde Q(2\pi)=-F_z,
\qquad
\widetilde M(2\pi)=M_c-RF_x.
$$ {#eq-calculation-particular-closure}

En consecuencia, $F_x=F_z=M_c=0$ asegura el cierre de la solución particular
para las acciones prescritas consideradas.

La ley seccional se obtiene, para un valor fijo de $\theta$, sobre la sección
resistente $A_b$ de una
franja de ancho axial proyectado $b$. La coordenada $\xi$ se mide desde el eje
baricéntrico y es positiva hacia la fibra interior. Bajo la hipótesis de
secciones planas,

$$
\varepsilon_\theta(\xi)=\varepsilon_0+\xi\kappa_\theta,
\qquad
\sigma_\theta(\xi)=E_\theta
\left(\varepsilon_0+\xi\kappa_\theta\right).
$$

Las propiedades por unidad de ancho axial proyectado son

$$
A_\theta=\frac{1}{b}\iint_{A_b}dA,
\qquad
S_\theta=\frac{1}{b}\iint_{A_b}\xi\,dA,
\qquad
I_\theta=\frac{1}{b}\iint_{A_b}\xi^2\,dA.
$$ {#eq-calculation-appendix-section-properties}

La integración de la tensión sobre la sección conduce a

$$
\begin{bmatrix}N_\theta\\M_\theta\end{bmatrix}
=E_\theta
\begin{bmatrix}A_\theta&S_\theta\\S_\theta&I_\theta\end{bmatrix}
\begin{bmatrix}\varepsilon_0\\\kappa_\theta\end{bmatrix}.
$$ {#eq-calculation-appendix-section-law}

Como $\xi$ se mide desde el baricentro, $S_\theta=0$. Los coeficientes
diagonales son entonces las rigideces $EA_\theta$ y $EI_\theta$ empleadas en
la @eq-calculation-section-stiffness. La razón
$\eta_s=I_\theta/(A_\theta R^2)$ es adimensional. Por estar normalizadas por
$b$, $A_\theta$ e $I_\theta$ tienen dimensiones de longitud y longitud al
cubo, respectivamente.

El cierre por compatibilidad parte, para acciones globalmente equilibradas, de
la solución particular $(\widetilde N,\widetilde Q,\widetilde M)$ de la
@eq-calculation-first-order-system iniciada con valores nulos en $\theta=0$.
La solución periódica completa puede escribirse como

$$
\begin{aligned}
N_\theta&=\widetilde N+\lambda_c\cos\theta+\lambda_s\sin\theta,\\
Q_\theta&=\widetilde Q-\lambda_c\sin\theta+\lambda_s\cos\theta,\\
M_\theta&=\widetilde M+R\lambda_c\cos\theta
+R\lambda_s\sin\theta+\lambda_0.
\end{aligned}
$$ {#eq-calculation-general-resultants}

Las constantes se determinan mediante compatibilidad.

Sean $w(\theta)$ y $v(\theta)$ los desplazamientos radial y tangencial. Las
relaciones de viga curva empleadas son
[@Baker1968, ecs. 2.3--2.6, pp. 16--17]

$$
M_\theta=\frac{EI_\theta}{R^2}(w''+w),
\qquad
N_\theta=\frac{EA_\theta}{R}(v'+w)+\frac{M_\theta}{R}.
$$ {#eq-calculation-appendix-displacement-relations}

La periodicidad de $w$ y $w'$ implica

$$
\int_0^{2\pi}M_\theta\cos\theta\,d\theta=0,
\qquad
\int_0^{2\pi}M_\theta\sin\theta\,d\theta=0.
$$

La media de la primera relación cinemática es

$$
\overline w=\frac{R^2}{EI_\theta}\overline M_\theta.
$$

Como $v$ es periódico, $\overline{v'}=0$; la media de la segunda relación da

$$
\overline w=\frac{R}{EA_\theta}\overline N_\theta
-\frac{1}{EA_\theta}\overline M_\theta.
$$

Al eliminar $\overline w$ se obtiene

$$
\overline M_\theta
=R\frac{\eta_s}{1+\eta_s}\overline N_\theta.
$$

La sustitución de la solución periódica general en estas tres condiciones
produce

$$
\lambda_c=-\frac{1}{\pi R}
\int_0^{2\pi}\widetilde M\cos\theta\,d\theta,
\qquad
\lambda_s=-\frac{1}{\pi R}
\int_0^{2\pi}\widetilde M\sin\theta\,d\theta,
$$

$$
\lambda_0=R\frac{\eta_s}{1+\eta_s}\,
\overline{\widetilde N}-\overline{\widetilde M},
\qquad
\overline f=\frac{1}{2\pi}\int_0^{2\pi}f(\theta)\,d\theta.
$$ {#eq-calculation-compatibility-constants}

Estas constantes determinan de manera unívoca las tres resultantes
seccionales.

La representación modal constituye una resolución independiente de las
mismas ecuaciones. Para $n\geq1$, los coeficientes de las acciones se definen
por

$$
\begin{aligned}
a_n&=\frac{1}{\pi}\int_0^{2\pi}P_r(\theta)\cos n\theta\,d\theta,&
b_n&=\frac{1}{\pi}\int_0^{2\pi}P_r(\theta)\sin n\theta\,d\theta,\\
c_n&=\frac{1}{\pi}\int_0^{2\pi}P_t(\theta)\cos n\theta\,d\theta,&
d_n&=\frac{1}{\pi}\int_0^{2\pi}P_t(\theta)\sin n\theta\,d\theta,
\end{aligned}
$$

con $a_0=(2\pi)^{-1}\int_0^{2\pi}P_r\,d\theta$ y
$c_0=(2\pi)^{-1}\int_0^{2\pi}P_t\,d\theta$. El modo $n=0$ representa la
componente uniforme. El modo $n=1$ contiene las fuerzas globales y su solución
para el anillo libre requiere coeficientes equilibrados; la reacción de apoyo
lleva la carga aplicada a esa condición. Los modos $n\geq2$ describen la
distorsión del anillo y producen las amplitudes de la
@eq-calculation-modal-resultants.

Para $n\geq2$, las amplitudes obtenidas de las ecuaciones de equilibrio son

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
$$ {#eq-calculation-modal-resultants}

Una serie truncada en $n_{\max}$ es una suma de componentes armónicas de la
carga y de la respuesta, donde $n_{\max}$ identifica el mayor orden espacial
incluido. Una distribución prescrita con un número finito de armónicos queda
representada al conservar su mayor modo activo. Para cargas localizadas o
discontinuas, $n_{\max}$ se aumenta hasta estabilizar las magnitudes de interés;
la reconstrucción de la carga puede presentar oscilaciones de Gibbs cerca de
los saltos. El caso biaxial uniforme comprende $n=0,2$ y la
@eq-calculation-biaxial-fourier-response es su solución modal exacta.

Definiendo $p_m=\Delta u+(\sigma'_v+\sigma'_h)/2$ y
$\Delta\sigma=\sigma'_v-\sigma'_h$, esa solución es

$$
N_\theta=-Rp_m
+R\Delta\sigma\frac{1+2\alpha}{6}\cos2\theta,
$$

$$
M_\theta=M_0
+R^2\Delta\sigma\frac{2+\alpha}{12}\cos2\theta,
$$

$$
Q_\theta=-R\Delta\sigma\frac{2+\alpha}{6}\sin2\theta.
$$ {#eq-calculation-biaxial-fourier-response}

La integración numérica directa se compara punto por punto con esa solución
cerrada y se controla además con $F_x$, $F_z$ y $M_c$. La tabla siguiente
informa los errores obtenidos con la discretización angular adoptada.

{{< include /_tbl/Calculation.controls.ES.qmd >}}

La demanda de diseño se obtiene con la solución elástica de carga externa de
Schwartz--Einstein y las siguientes razones de rigidez:

$$
C^*=\frac{E_gR(1-\nu_\ell^2)}
{E_\ell A_\ell(1-\nu_g^2)},
\qquad
F^*=\frac{E_gR^3(1-\nu_\ell^2)}
{E_\ell I_\ell(1-\nu_g^2)}.
$$ {#eq-calculation-se-stiffness}

Para esta comparación se definen

$$
P_{SE}=\sigma'_v(z_{ref}),
\qquad
K_{SE}=\frac{\sigma'_h(z_{ref})}{P_{SE}}.
$$ {#eq-calculation-se-reference-state}

Sea $c_\nu=1-\nu_g$. El coeficiente axisimétrico de la
secuencia de carga externa es [@SchwartzEinstein1980, ecs. A.49--A.54]

$$
a_1=\frac{C^*c_\nu-1+2\nu_g}{C^*c_\nu+1},
\qquad
t_0=\frac12(1+K_{SE})(1-a_1).
$$ {#eq-calculation-appendix-se-axisymmetric}

Para la interfaz con deslizamiento libre,

$$
a_2=\frac{F^*c_\nu+3-6\nu_g}{F^*c_\nu+15-18\nu_g},
\qquad
a_3=\frac{F^*c_\nu-3}{F^*c_\nu+15-18\nu_g},
$$

$$
t_2=m_2=\frac16(1-K_{SE})(1+3a_2-4a_3).
$$ {#eq-calculation-appendix-se-full-slip}

Para la interfaz sin deslizamiento se define

$$
\widehat a=
\frac{F^*c_\nu}{6}\left[(3-2\nu_g)+C^*c_\nu\right]
+C^*c_\nu\left(\frac52-3\nu_g\right)+6-8\nu_g,
$$

$$
a_2=
\frac{
\dfrac{F^*c_\nu}{6}\left[(1-2\nu_g)-C^*c_\nu\right]
-\dfrac12C^*c_\nu(1-2\nu_g)+2}
{\widehat a},
$$

$$
a_3=
\frac{
\dfrac{F^*c_\nu}{6}(C^*c_\nu+1)-\dfrac12C^*c_\nu-2}
{\widehat a},
$$

$$
t_2=\frac12(1-K_{SE})(1+a_2),
\qquad
m_2=\frac14(1-K_{SE})(1-a_2-2a_3).
$$ {#eq-calculation-appendix-se-no-slip}

La forma de $\widehat a$ anterior resulta de cancelar exactamente el factor
$1-2\nu_g$ de la expresión publicada y evita una indeterminación numérica
aparente. Los denominadores deben ser distintos de cero y
$-1<\nu_g<0.5$. La sustitución de estos coeficientes produce

$$
\begin{aligned}
N_\theta(\theta)&=-P_{SE}Rt_0+P_{SE}Rt_2\cos2\theta,\\
M_\theta(\theta)&=P_{SE}R^2m_2\cos2\theta,\\
Q_\theta(\theta)&=-2P_{SE}Rm_2\sin2\theta.
\end{aligned}
$$ {#eq-calculation-se-resultants}

Estas expresiones contienen los modos $n=0,2$ de la respuesta interactiva.
Schwartz--Einstein determina sus amplitudes mediante $C^*$, $F^*$ y la
condición de interfaz; Fourier descompone las acciones perimetrales prescritas.
La integración numérica directa, la solución cerrada y la representación de
Fourier comprueban de manera independiente el equilibrio y la reconstrucción
modal.
