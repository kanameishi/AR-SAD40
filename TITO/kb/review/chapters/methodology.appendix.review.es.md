# Apéndice A. Desarrollo de la solución estructural {.appendix .unnumbered}

## Equilibrio del elemento diferencial {.unnumbered}

La fuerza interna sobre la cara positiva de la sección se expresa como

$$
\mathbf F(\theta)=N_\theta\mathbf e_t-Q_\theta\mathbf e_r.
$$

Teniendo en cuenta las derivadas de la base polar,

$$
\frac{d\mathbf F}{d\theta}
=\left(\frac{dN_\theta}{d\theta}-Q_\theta\right)\mathbf e_t
+\left(-N_\theta-\frac{dQ_\theta}{d\theta}\right)\mathbf e_r.
$$

El equilibrio de fuerzas del elemento de longitud $R\,d\theta$ exige

$$
\frac{d\mathbf F}{d\theta}
+R(P_r\mathbf e_r+P_t\mathbf e_t)=\mathbf 0.
$$

La proyección sobre $\mathbf e_r$ y $\mathbf e_t$ conduce a las
@eq-ring-equilibrium-r y @eq-ring-equilibrium-t. El equilibrio de momentos
respecto del centro de la sección da la @eq-ring-equilibrium-m. Para
$P_t=0$, el sistema coincide con las ecuaciones radiales publicadas por Baker
[@Baker1968, ecs. 2.1a--2.1c, p. 16]; el término $RP_t$ resulta del equilibrio
vectorial del elemento.

## Determinación de las constantes de compatibilidad {.unnumbered}

La sustitución de la @eq-general-resultants en la primera condición de la
@eq-compatibility-conditions produce

$$
0=\int_0^{2\pi}\widetilde M\cos\theta\,d\theta
+R\lambda_c\int_0^{2\pi}\cos^2\theta\,d\theta
+R\lambda_s\int_0^{2\pi}\sin\theta\cos\theta\,d\theta.
$$

Como
$\int_0^{2\pi}\cos^2\theta\,d\theta=\pi$ y
$\int_0^{2\pi}\sin\theta\cos\theta\,d\theta=0$, se obtiene la expresión de
$\lambda_c$ de la @eq-compatibility-constants. La segunda condición conduce de
igual modo a $\lambda_s$.

Los términos de orden uno tienen media nula. Por lo tanto,

$$
\overline N_\theta=\overline{\widetilde N},
\qquad
\overline M_\theta=\overline{\widetilde M}+\lambda_0.
$$

Al introducir estas relaciones en la tercera condición de la
@eq-compatibility-conditions se obtiene

$$
\lambda_0=
R\frac{\eta_s}{1+\eta_s}\overline{\widetilde N}
-\overline{\widetilde M},
$$

que completa la derivación de la @eq-compatibility-constants a partir de las
relaciones cinemáticas y constitutivas de la viga curva
[@Baker1968, ecs. 2.3--2.6, pp. 16--18].

## Coeficientes modales {.unnumbered}

Para un armónico de orden $n\geq2$, sean

$$
\begin{aligned}
P_r&=a_n\cos n\theta+b_n\sin n\theta,\\
P_t&=c_n\cos n\theta+d_n\sin n\theta,\\
N_\theta&=N_n^{(c)}\cos n\theta+N_n^{(s)}\sin n\theta,\\
Q_\theta&=Q_n^{(c)}\cos n\theta+Q_n^{(s)}\sin n\theta,\\
M_\theta&=M_n^{(c)}\cos n\theta+M_n^{(s)}\sin n\theta.
\end{aligned}
$$

La sustitución en las tres ecuaciones de equilibrio da el sistema algebraico

$$
\begin{aligned}
nM_n^{(s)}&=RQ_n^{(c)}, & -nM_n^{(c)}&=RQ_n^{(s)},\\
Ra_n-N_n^{(c)}-nQ_n^{(s)}&=0,
& Rb_n-N_n^{(s)}+nQ_n^{(c)}&=0,\\
nN_n^{(s)}-Q_n^{(c)}+Rc_n&=0,
& -nN_n^{(c)}-Q_n^{(s)}+Rd_n&=0.
\end{aligned}
$$ {#eq-modal-algebra}

La resolución de la @eq-modal-algebra produce los coeficientes de la
@eq-modal-resultants. Los coeficientes satisfacen las tres ecuaciones de
equilibrio para cada armónico. La referencia de Baker sustenta la
especialización $P_t=0$; la extensión a $P_t\ne0$ procede del equilibrio
vectorial precedente.

# Apéndice B. Sectores angulares de una tongada de compactación {.appendix .unnumbered}

La franja lateral de la @eq-fhwa-band queda delimitada por las cotas
$y_s^-$ y $y_s^+$ medidas desde la solera. Para una cota
$0\leq y\leq2R$, los puntos de intersección con la circunferencia satisfacen

$$
\cos\theta=\frac{y}{R}-1
$$

y corresponden a los ángulos

$$
\alpha(y)=\arccos\left(\frac{y}{R}-1\right),
\qquad
2\pi-\alpha(y).
$$ {#eq-fhwa-band-angles}

Los límites de integración de la etapa $s$ se forman con

$$
\mathcal D_s=
\left\{
\alpha(y_s^-),\;2\pi-\alpha(y_s^-),\;
\alpha(y_s^+),\;2\pi-\alpha(y_s^+)
\right\},
$$ {#eq-fhwa-discontinuities}

después de recortar las cotas al intervalo $[0,2R]$, eliminar duplicados y
ordenar los ángulos. En cada intervalo definido por $\mathcal D_s$, la función
$I_s(\theta)$ es constante y las cargas de la @eq-fhwa-perimeter-load se
integran sin atravesar discontinuidades. La dirección horizontal y simétrica
de la acción reproduce la disposición de fuerzas de la figura 5.4 de FHWA
[@McGrathEtAl1999, fig. 5.4, pp. 175--176]. La formulación representa la acción
mediante franjas continuas de presión horizontal.

# Apéndice C. Coeficientes de Schwartz--Einstein {.appendix .unnumbered}

Las expresiones se presentan inicialmente con la convención de la fuente:
$\theta_{SE}=0$ en el hastial derecho, sentido antihorario y
$T_{SE}>0$ a compresión [@SchwartzEinstein1980, fig. 2.6, p. 22]. La fuerza
cortante de la fuente satisface

$$
V_{SE}=\frac{1}{R}\frac{dM_{SE}}{d\theta_{SE}}.
$$

El cambio de coordenada angular y de signos adoptado para expresar esas
resultantes en la convención general es

$$
\theta_{SE}=\frac{\pi}{2}-\theta\pmod{2\pi},
\qquad
N_\theta=-T_{SE},
\qquad
M_\theta=-M_{SE},
\qquad
Q_\theta=V_{SE}.
$$ {#eq-se-resultant-conversion}

En la condición *full slip*, la tracción tangencial en la interfaz es nula; en
*no slip*, el desplazamiento tangencial relativo entre terreno y revestimiento
es nulo [@SchwartzEinstein1980, sec. 2.3, p. 17]. En los encabezados siguientes
se emplean, respectivamente, «deslizamiento completo» y «sin deslizamiento»,
conservando entre paréntesis la denominación original.

Con las razones $C^*$ y $F^*$ de la @eq-se-stiffness, la respuesta se escribe
en la forma de la @eq-se-response. La fuerza cortante de la fuente es

$$
V_{SE}=-2P_{SE}R\,m_2\sin2\theta_{SE}.
$$ {#eq-se-shear}

## Descarga por excavación con deslizamiento completo (*full slip*) {.unnumbered}

Para la solución denominada *full slip* por la fuente
[@SchwartzEinstein1980, ec. A.47, pp. 368--369], se definen

$$
a_0^*=\frac{C^*F^*(1-\nu_g)}
{C^*+F^*+C^*F^*(1-\nu_g)},
$$

$$
a_2^*=\frac{(F^*+6)(1-\nu_g)}
{2F^*(1-\nu_g)+6(5-6\nu_g)}.
$$

Los coeficientes son

$$
t_0=\frac12(1+K_{SE})(1-a_0^*),
$$

$$
t_2=m_2=\frac12(1-K_{SE})(1-2a_2^*).
$$ {#eq-se-excavation-slip}

## Descarga por excavación sin deslizamiento (*no slip*) {.unnumbered}

Para la solución *no slip*
[@SchwartzEinstein1980, ec. A.48, pp. 368--371], se definen

$$
\widehat b=
\frac{(6+F^*)C^*(1-\nu_g)+2F^*\nu_g}
{3F^*+3C^*+2C^*F^*(1-\nu_g)},
$$

$$
b_2^*=\frac{C^*(1-\nu_g)}
{2\left[C^*(1-\nu_g)+4\nu_g-6\widehat b
-3\widehat b C^*(1-\nu_g)\right]},
\qquad
a_2^*=\widehat b\,b_2^*.
$$

Con el mismo $a_0^*$ de la solución anterior,

$$
t_0=\frac12(1+K_{SE})(1-a_0^*),
$$

$$
t_2=\frac12(1-K_{SE})(1+2a_2^*),
\qquad
m_2=\frac14(1-K_{SE})(1-2a_2^*+2b_2^*).
$$ {#eq-se-excavation-bonded}

## Carga externa con deslizamiento completo (*full slip*) {.unnumbered}

Para las ecuaciones A.49--A.51
[@SchwartzEinstein1980, ecs. A.49--A.51, pp. 372--373], se definen

$$
a_1=\frac{C^*(1-\nu_g)-1+2\nu_g}
{C^*(1-\nu_g)+1},
$$

$$
a_2=\frac{F^*(1-\nu_g)+3-6\nu_g}
{F^*(1-\nu_g)+15-18\nu_g},
\qquad
a_3=\frac{F^*(1-\nu_g)-3}
{F^*(1-\nu_g)+15-18\nu_g}.
$$

Los coeficientes son

$$
t_0=\frac12(1+K_{SE})(1-a_1),
$$

$$
t_2=m_2=\frac16(1-K_{SE})(1+3a_2-4a_3).
$$ {#eq-se-external-slip}

## Carga externa sin deslizamiento (*no slip*) {.unnumbered}

Para las ecuaciones A.52--A.54
[@SchwartzEinstein1980, ecs. A.52--A.54, pp. 373--374], se utiliza $a_1$ de la
solución anterior y se definen

$$
\widehat a=
\frac{F^*(1-\nu_g)}{6}
\left[(3-2\nu_g)+C^*(1-\nu_g)\right]
+\frac{C^*(1-\nu_g)}{1-2\nu_g}
\left(\frac52-8\nu_g+6\nu_g^2\right)+6-8\nu_g,
$$

$$
a_2=\frac{
\dfrac{F^*(1-\nu_g)}{6}
\left[(1-2\nu_g)-C^*(1-\nu_g)\right]
-\dfrac12C^*(1-\nu_g)(1-2\nu_g)+2}
{\widehat a},
$$

$$
a_3=\frac{
\dfrac{F^*(1-\nu_g)}{6}
\left[C^*(1-\nu_g)+1\right]
-\dfrac12C^*(1-\nu_g)-2}
{\widehat a}.
$$

Los coeficientes finales son

$$
t_0=\frac12(1+K_{SE})(1-a_1),
\qquad
t_2=\frac12(1-K_{SE})(1+a_2),
$$

$$
m_2=\frac14(1-K_{SE})(1-a_2-2a_3).
$$ {#eq-se-external-bonded}

Estas cuatro soluciones corresponden a un medio elástico homogéneo, una
sección circular, deformación plana y un estado tensional inicial uniforme. Su
uso como referencia exige conservar la secuencia de carga y la condición de
interfaz de cada expresión.
