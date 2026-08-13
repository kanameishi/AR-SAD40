# Apéndice A. Desarrollos empleados {#sec-calculation-appendix-derivations .unnumbered}

Este apéndice desarrolla las relaciones de equilibrio, rigidez y
compatibilidad empleadas para determinar las resultantes seccionales de una
línea circular de referencia. Se considera un problema transversal plano, con
pequeños desplazamientos, respuesta elástica lineal, propiedades
circunferenciales constantes y deformación por corte despreciada.

## A.1 Equilibrio del elemento diferencial {.unnumbered}

Se adoptan un eje global $x$ positivo hacia la derecha y un eje $z$ positivo
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

Las tres relaciones reunidas reproducen el sistema de la
@eq-calculation-first-order-system. Para $P_t=0$ se recupera la formulación
radial de Baker [@Baker1968, ecs. 2.1a--2.1c, p. 16]; el término $RP_t$
resulta de la proyección tangencial de la acción perimetral.

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

## A.2 Ley seccional y rigideces circunferenciales {.unnumbered}

A un valor fijo de $\theta$, considérese la sección resistente $A_b$ de una
franja de ancho axial proyectado $b$. La coordenada $\xi$ se mide desde el eje
centroidal y es positiva hacia la fibra interior. Bajo la hipótesis de
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

Como $\xi$ se mide desde el centroide, $S_\theta=0$. Los coeficientes
diagonales son entonces las rigideces $EA_\theta$ y $EI_\theta$ empleadas en
la @eq-calculation-section-stiffness. La razón
$\eta_s=I_\theta/(A_\theta R^2)$ es adimensional. Por estar normalizadas por
$b$, $A_\theta$ e $I_\theta$ tienen dimensiones de longitud y longitud al
cubo, respectivamente.

## A.3 Cierre por compatibilidad {.unnumbered}

Para acciones globalmente equilibradas, la solución homogénea periódica del
sistema diferencial permite escribir la respuesta completa como se indica en
la @eq-calculation-general-resultants. Las constantes se determinan
mediante compatibilidad.

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
produce las constantes reunidas en la
@eq-calculation-compatibility-constants y completa, sin parámetros libres,
las tres resultantes seccionales.

## A.4 Recuperación de la tensión normal circunferencial {.unnumbered}

Al medir $\xi$ desde el centroide, la @eq-calculation-appendix-section-law se
desacopla y proporciona

$$
\varepsilon_0=\frac{N_\theta}{E_\theta A_\theta},
\qquad
\kappa_\theta=\frac{M_\theta}{E_\theta I_\theta}.
$$

La sustitución en
$\sigma_\theta=E_\theta(\varepsilon_0+\xi\kappa_\theta)$ conduce a

$$
\sigma_\theta(\theta,\xi)
=\frac{N_\theta(\theta)}{A_\theta}
+1000\frac{M_\theta(\theta)\,\xi}{I_\theta}.
$$ {#eq-calculation-appendix-stress-recovery}

Para la sección corrugada de referencia,

$$
A_\theta=A_p,
\qquad
I_\theta=I_p,
\qquad
\xi_e=-\frac{I_p}{S_p},
\qquad
\xi_i=\frac{I_p}{S_p}.
$$

En las unidades adoptadas, $1\ \mathrm{kN/m}=1\ \mathrm{N/mm}$ y
$1\ \mathrm{kN\,m/m}=1000\ \mathrm{N}$. Por ello,
$N_\theta/A_p$ y $1000M_\theta\xi/I_p$ se expresan en
$\mathrm{N/mm^2}=\mathrm{MPa}$. La sustitución de las coordenadas extremas
proporciona

$$
\sigma_{\theta,e}(\theta)
=\frac{N_\theta(\theta)}{A_p}
-1000\frac{M_\theta(\theta)}{S_p},
\qquad
\sigma_{\theta,i}(\theta)
=\frac{N_\theta(\theta)}{A_p}
+1000\frac{M_\theta(\theta)}{S_p},
$$

que coincide con la @eq-calculation-sheet-reference-stress.
