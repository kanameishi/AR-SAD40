# Apéndice A. Síntesis de los desarrollos {#sec-calculation-appendix-derivations .unnumbered}

Este apéndice resume los desarrollos necesarios para comprobar las fórmulas
operativas empleadas en la memoria.

## A.1 Equilibrio del elemento diferencial {.unnumbered}

El radio $R$ corresponde al eje centroidal. El ángulo $\theta$ se mide desde
la clave y aumenta en sentido horario. Los vectores unitarios $\mathbf e_r$ y
$\mathbf e_t$ señalan, respectivamente, la dirección radial hacia el exterior
y la dirección de aumento de $\theta$. Las acciones $P_r$ y $P_t$ son
positivas en esas mismas direcciones.

Para una franja de ancho longitudinal proyectado $b$ y sección resistente
$A_b$, las resultantes se expresan por unidad de ancho:
$N_\theta$ y $Q_\theta$ tienen unidades de fuerza por longitud, mientras que
$M_\theta$ tiene unidades de momento por longitud. Se adopta $N_\theta>0$ en
tracción, $Q_\theta>0$ hacia el centro sobre la cara positiva y
$M_\theta>0$ cuando produce tracción en la fibra interior. Con estas
convenciones, la fuerza interna sobre la cara positiva se escribe

$$
\mathbf F(\theta)=N_\theta\mathbf e_t-Q_\theta\mathbf e_r.
$$

Con $d\mathbf e_r/d\theta=\mathbf e_t$ y
$d\mathbf e_t/d\theta=-\mathbf e_r$,

$$
\frac{d\mathbf F}{d\theta}
=\left(\frac{dN_\theta}{d\theta}-Q_\theta\right)\mathbf e_t
+\left(-N_\theta-\frac{dQ_\theta}{d\theta}\right)\mathbf e_r.
$$ {#eq-calculation-element-force}

El equilibrio de fuerzas del elemento de longitud $R\,d\theta$ exige

$$
\frac{d\mathbf F}{d\theta}
+R(P_r\mathbf e_r+P_t\mathbf e_t)=\mathbf0.
$$ {#eq-calculation-element-equilibrium}

Las proyecciones tangencial y radial proporcionan, respectivamente,

$$
\frac{dN_\theta}{d\theta}-Q_\theta+RP_t=0,
\qquad
\frac{dQ_\theta}{d\theta}+N_\theta-RP_r=0.
$$ {#eq-calculation-appendix-force-equilibrium}

Sea $\mathbf k=\mathbf e_r\times\mathbf e_t$. Como $\xi$ es positiva hacia
el interior, el par de las tensiones sobre la cara positiva es

$$
\mathbf C_+=-M_\theta\mathbf k.
$$

En ausencia de un par distribuido, las fuerzas cortantes de las dos caras
producen el par $RQ_\theta\,d\theta\,\mathbf k$. El equilibrio de momentos del
elemento, despreciando términos de orden superior a $d\theta$, es entonces

$$
M_\theta(\theta+d\theta)-M_\theta(\theta)
-RQ_\theta\,d\theta=0,
$$

y, por lo tanto,

$$
\frac{dM_\theta}{d\theta}-RQ_\theta=0.
$$ {#eq-calculation-appendix-moment-equilibrium}

Las tres ecuaciones forman el sistema de primer orden

$$
\frac{d}{d\theta}
\begin{bmatrix}N_\theta\\Q_\theta\\M_\theta\end{bmatrix}
=
\begin{bmatrix}
Q_\theta-RP_t\\
RP_r-N_\theta\\
RQ_\theta
\end{bmatrix}.
$$ {#eq-calculation-appendix-first-order-system}

Para $P_t=0$ se recupera la formulación radial de Baker
[@Baker1968, ecs. 2.1a--2.1c, p. 16]. El término $RP_t$ resulta directamente
de la proyección tangencial de la acción perimetral.

Las acciones prescritas deben incluir las reacciones necesarias para el
equilibrio de la sección cerrada. Si las resultantes internas son periódicas,
la integración del equilibrio vectorial sobre una vuelta completa exige

$$
R\int_0^{2\pi}
\left(P_r\mathbf e_r+P_t\mathbf e_t\right)d\theta=\mathbf0,
\qquad
R^2\int_0^{2\pi}P_t\,d\theta=0.
$$ {#eq-calculation-appendix-global-equilibrium}

Estas dos expresiones son, respectivamente, los controles de fuerza resultante
y de momento respecto del centro de la sección.

## A.2 Cierre por compatibilidad {.unnumbered}

Se consideran acciones periódicas que satisfacen los controles de equilibrio
global de A.1. Para estas acciones, la solución particular
$(\widetilde N,\widetilde Q,\widetilde M)$ obtenida con valores iniciales nulos
en $\theta=0$ también cierra al completar la circunferencia. Una corrección
homogénea periódica no podría compensar una fuerza o un par resultante no
equilibrados.

El sistema homogéneo asociado satisface

$$
N_h'=Q_h,
\qquad
Q_h'=-N_h,
\qquad
M_h'=RQ_h,
$$

de donde

$$
\begin{aligned}
N_\theta&=\widetilde N
+\lambda_c\cos\theta+\lambda_s\sin\theta,\\
Q_\theta&=\widetilde Q
-\lambda_c\sin\theta+\lambda_s\cos\theta,\\
M_\theta&=\widetilde M
+R\lambda_c\cos\theta+R\lambda_s\sin\theta+\lambda_0.
\end{aligned}
$$ {#eq-calculation-appendix-general-resultants}

El cierre constitutivo se formula para una viga curva circular uniforme, con
$EA_\theta$ y $EI_\theta$ constantes, comportamiento elástico lineal,
pequeños desplazamientos y deformación por corte despreciada. Sean $w(\theta)$
y $v(\theta)$ los desplazamientos radial y tangencial, respectivamente. Las
relaciones cinemáticas y constitutivas de Baker
[@Baker1968, ecs. 2.3--2.6, pp. 16--17], expresadas con la notación de esta
memoria y con $\xi$ positiva hacia la fibra interior, son

$$
M_\theta=\frac{EI_\theta}{R^2}\left(w''+w\right),
\qquad
N_\theta=\frac{EA_\theta}{R}\left(v'+w\right)
+\frac{M_\theta}{R}.
$$ {#eq-calculation-appendix-displacement-relations}

La primera relación equivale a

$$
w''+w=\frac{R^2}{EI_\theta}M_\theta.
$$

Para un desplazamiento cerrado, $w$ y $w'$ son periódicos. Dos integraciones
por partes proporcionan

$$
\int_0^{2\pi}(w''+w)\cos\theta\,d\theta=0,
\qquad
\int_0^{2\pi}(w''+w)\sin\theta\,d\theta=0.
$$

Por consiguiente, el momento debe ser ortogonal a los armónicos
$\cos\theta$ y $\sin\theta$; éstas son las dos condiciones asociadas al cierre
del desplazamiento radial. Para obtener la condición restante se define

$$
\overline f=\frac{1}{2\pi}\int_0^{2\pi}f(\theta)\,d\theta,
\qquad
\eta_s=\frac{EI_\theta}{EA_\theta R^2}.
$$

La media de la primera relación de
@eq-calculation-appendix-displacement-relations es

$$
\overline w=\frac{R^2}{EI_\theta}\overline M_\theta.
$$

Como $v$ también es periódico, $\overline{v'}=0$. La media de la segunda
relación da

$$
\overline w
=\frac{R}{EA_\theta}\overline N_\theta
-\frac{1}{EA_\theta}\overline M_\theta.
$$

La eliminación de $\overline w$ conduce a la tercera condición. En conjunto,
el cierre cinemático exige

$$
\boxed{
\begin{aligned}
\int_0^{2\pi}M_\theta\cos\theta\,d\theta&=0,\\
\int_0^{2\pi}M_\theta\sin\theta\,d\theta&=0,\\
\overline M_\theta
&=R\frac{\eta_s}{1+\eta_s}\,\overline N_\theta.
\end{aligned}}
$$ {#eq-calculation-compatibility-conditions}

Las dos condiciones integrales y la relación entre valores medios se deducen
así de las relaciones de Baker; no se transcriben de la fuente como fórmulas
independientes. Baker desarrolla el caso de acciones radiales. Su aplicación
a una componente tangencial prescrita es una extensión de este estudio, ya
que el cierre cinemático anterior no depende de la dirección de la acción.

Al sustituir el momento de la
@eq-calculation-appendix-general-resultants en la primera condición se obtiene

$$
0=\int_0^{2\pi}\widetilde M\cos\theta\,d\theta
+R\lambda_c\int_0^{2\pi}\cos^2\theta\,d\theta
+R\lambda_s\int_0^{2\pi}\sin\theta\cos\theta\,d\theta.
$$

Como
$\int_0^{2\pi}\cos^2\theta\,d\theta=\pi$ y
$\int_0^{2\pi}\sin\theta\cos\theta\,d\theta=0$,

$$
\lambda_c=-\frac{1}{\pi R}
\int_0^{2\pi}\widetilde M(\theta)\cos\theta\,d\theta.
$$

El mismo procedimiento aplicado a la segunda condición da

$$
\lambda_s=-\frac{1}{\pi R}
\int_0^{2\pi}\widetilde M(\theta)\sin\theta\,d\theta.
$$

Los términos de orden uno tienen media nula; por consiguiente,

$$
\overline N_\theta=\overline{\widetilde N},
\qquad
\overline M_\theta=\overline{\widetilde M}+\lambda_0.
$$

La tercera condición determina la constante restante:

$$
\lambda_0
=R\frac{\eta_s}{1+\eta_s}\,
\overline{\widetilde N}-\overline{\widetilde M}.
$$

Por lo tanto, las tres constantes de cierre son

$$
\boxed{
\begin{aligned}
\lambda_c&=-\frac{1}{\pi R}
\int_0^{2\pi}\widetilde M\cos\theta\,d\theta,\\
\lambda_s&=-\frac{1}{\pi R}
\int_0^{2\pi}\widetilde M\sin\theta\,d\theta,\\
\lambda_0&=R\frac{\eta_s}{1+\eta_s}\,
\overline{\widetilde N}-\overline{\widetilde M}.
\end{aligned}}
$$ {#eq-calculation-appendix-compatibility-constants}

La sustitución de estas constantes en la
@eq-calculation-appendix-general-resultants completa la solución compatible de
$N_\theta(\theta)$, $Q_\theta(\theta)$ y $M_\theta(\theta)$.

## A.3 Geometría de las franjas de compactación {.unnumbered}

La cota de un punto del contorno, medida desde el fondo, es

$$
y(\theta)=R(1+\cos\theta),
\qquad 0\leq y\leq2R.
$$

Para $0\leq y\leq2R$, las dos intersecciones con el contorno están dadas por

$$
\theta_1(y)=\arccos\left(\frac{y}{R}-1\right),
\qquad
\theta_2(y)=2\pi-\theta_1(y).
$$ {#eq-calculation-fhwa-band-angles}

Una franja $s$ se define mediante $y_s^-\leq y_s^+$. Su intersección con la
sección circular tiene límites

$$
\ell_s=\max(0,y_s^-),
\qquad
u_s=\min(2R,y_s^+).
$$

Si $\ell_s\geq u_s$, la franja no posee longitud activa sobre el contorno; en
el caso degenerado $\ell_s=u_s$ se adopta también una contribución nula. Se
define entonces $I_s(\theta)=0$ y $\mathcal D_s=\{0,2\pi\}$. Si
$\ell_s<u_s$, el conjunto ordenado de límites angulares es

$$
\mathcal D_s=\operatorname{sort}\operatorname{unique}
\left\{
0,\,2\pi,\,
\theta_1(\ell_s),\,
\theta_2(\ell_s),\,
\theta_1(u_s),\,
\theta_2(u_s)
\right\}.
$$ {#eq-calculation-appendix-band-discontinuities}

Para esa intersección no vacía, el indicador de pertenencia a la franja es

$$
I_s(\theta)=
\begin{cases}
1,&\ell_s\leq R(1+\cos\theta)\leq u_s,\\
0,&\text{en otro caso}.
\end{cases}
$$ {#eq-calculation-appendix-band-indicator}

La relación publicada por FHWA para la presión nodal equivalente inducida por
el equipo compactador es [@McGrathEtAl1999, ec. 5.1, p. 177]

$$
n_{p,s}=1.3P_s(1-\sin\phi_s)^3
\left(\frac{970}{d_c-250}\right)^2.
$$

En esta expresión, desarrollada exclusivamente para las unidades SI indicadas
por la fuente, $n_{p,s}$ se obtiene en kPa; $P_s$ es la fuerza total del
compactador en kN, con $P_s\geq4\ \mathrm{kN}$; $\phi_s$ es el ángulo de
fricción del suelo en estado suelto, expresado en grados; y $d_c$ es el
diámetro centroidal del conducto en mm. La expresión es singular para
$d_c=250\ \mathrm{mm}$; la fuente la contrastó con los dos tamaños estudiados
y no publicó un dominio general de extrapolación. La correlación procede de
un conjunto limitado de datos. FHWA aplicó las fuerzas
nodales horizontales en una franja de $300\ \mathrm{mm}$ bajo la superficie
vigente de la tongada [@McGrathEtAl1999, sec. 5.2.1, p. 173; fig. 5.4,
p. 175]; la fuente no establece una fracción universal de retención para el
estado permanente.

La transformación de ese esquema nodal a una acción perimetral continua se
deriva a continuación. Sea $\mathbf e_x$ el vector horizontal positivo hacia
la derecha. Con la convención angular de A.1,

$$
\mathbf e_x
=\sin\theta\,\mathbf e_r+\cos\theta\,\mathbf e_t.
$$

La acción horizontal simétrica, dirigida hacia el eje vertical de la sección
en ambos laterales, se escribe

$$
\mathbf h_s(\theta)
=-n_{p,s}\operatorname{sgn}(\sin\theta)
I_s(\theta)\,\mathbf e_x,
\qquad \operatorname{sgn}(0)=0.
$$

Sus proyecciones radial y tangencial son

$$
P_{r,c}^{(s)}(\theta)
=\mathbf h_s\mathbin{\cdot}\mathbf e_r
=-n_{p,s}|\sin\theta|I_s(\theta),
\qquad
P_{t,c}^{(s)}(\theta)
=\mathbf h_s\mathbin{\cdot}\mathbf e_t
=-n_{p,s}\operatorname{sgn}(\sin\theta)
\cos\theta\,I_s(\theta).
$$ {#eq-calculation-appendix-fhwa-stage-load}

La correlación de $n_{p,s}$ y la dirección de las fuerzas nodales proceden de
FHWA; las funciones perimetrales anteriores son una transformación derivada en
este estudio.

Para una etapa constructiva $c$, sea $\mathcal S_c$ el conjunto declarado de
franjas activas. El uso directo del esquema de la fuente contiene una sola
franja bajo la superficie vigente. Cualquier retención o concurrencia de
franjas constituye una hipótesis adicional del estado de cálculo. Para el
conjunto adoptado, las acciones y los límites de integración son

$$
P_{r,c}(\theta)=\sum_{s\in\mathcal S_c}P_{r,c}^{(s)}(\theta),
\qquad
P_{t,c}(\theta)=\sum_{s\in\mathcal S_c}P_{t,c}^{(s)}(\theta),
$$

$$
\mathcal D_c
=\operatorname{sort}\operatorname{unique}
\left(\bigcup_{s\in\mathcal S_c}\mathcal D_s\right).
$$ {#eq-calculation-appendix-fhwa-stage-combination}

Las contribuciones de franjas superpuestas se suman algebraicamente; la unión
geométrica de indicadores no conserva su multiplicidad. Los ángulos de
$\mathcal D_c$ dividen la circunferencia en intervalos de carga continua, que
se integran por separado sin atravesar una discontinuidad.

## A.4 Propiedades del perfil corrugado {.unnumbered}

Considérese una franja representativa de ancho longitudinal proyectado $b$.
El radio $R$ corresponde al eje centroidal de la sección y $\xi$ se mide desde
ese eje, con sentido positivo hacia la fibra interior. Para una sección
homogénea, con $E_\theta$ uniforme, y bajo la cinemática lineal de secciones
planas, la deformación circunferencial de una fibra es

$$
\varepsilon_\theta(\xi)
=\varepsilon_\theta+\xi\kappa_\theta,
\qquad
\sigma_\theta(\xi)
=E_\theta\left(\varepsilon_\theta+\xi\kappa_\theta\right).
$$ {#eq-calculation-section-fiber-law}

La densidad local de trabajo virtual interno por unidad de longitud
circunferencial y por unidad de ancho longitudinal proyectado es

$$
\delta w_{int}
=\frac{1}{b}\int_{A_b}
E_\theta\left(\varepsilon_\theta+\xi\kappa_\theta\right)
\left(\delta\varepsilon_\theta
+\xi\,\delta\kappa_\theta\right)\,dA,
$$ {#eq-calculation-section-virtual-work}

Por consiguiente, el trabajo virtual interno de la circunferencia por unidad
de ancho longitudinal proyectado se obtiene integrando a lo largo del eje
centroidal:

$$
\frac{\delta U_{int}}{b}
=\int_0^{2\pi}\delta w_{int}(\theta)R\,d\theta.
$$ {#eq-calculation-section-total-virtual-work}

donde $A_b$ es el área de la franja. Se definen las propiedades por unidad de
longitud proyectada

$$
A_p=\frac{1}{b}\int_{A_b}dA,
\qquad
S_p=\frac{1}{b}\int_{A_b}\xi\,dA,
\qquad
I_p=\frac{1}{b}\int_{A_b}\xi^2\,dA.
$$ {#eq-calculation-section-properties}

Al desarrollar la integral se obtiene

$$
\delta w_{int}
=E_\theta\left(A_p\varepsilon_\theta
+S_p\kappa_\theta\right)\delta\varepsilon_\theta
+E_\theta\left(S_p\varepsilon_\theta
+I_p\kappa_\theta\right)\delta\kappa_\theta.
$$ {#eq-calculation-section-virtual-work-expanded}

Las resultantes seccionales por unidad de ancho longitudinal proyectado se
definen como

$$
N_\theta=\frac{1}{b}\int_{A_b}\sigma_\theta\,dA,
\qquad
M_\theta=\frac{1}{b}\int_{A_b}\sigma_\theta\xi\,dA.
$$

Por lo tanto, la densidad local también puede escribirse como

$$
\delta w_{int}
=N_\theta\,\delta\varepsilon_\theta
+M_\theta\,\delta\kappa_\theta.
$$

La @eq-calculation-section-total-virtual-work queda entonces

$$
\frac{\delta U_{int}}{b}
=\int_0^{2\pi}
\left(N_\theta\,\delta\varepsilon_\theta
+M_\theta\,\delta\kappa_\theta\right)R\,d\theta.
$$

Como $\delta\varepsilon_\theta$ y $\delta\kappa_\theta$ son variaciones
independientes, la comparación término a término conduce a

$$
\begin{bmatrix}
N_\theta\\[2pt] M_\theta
\end{bmatrix}
=E_\theta
\begin{bmatrix}
A_p&S_p\\[2pt] S_p&I_p
\end{bmatrix}
\begin{bmatrix}
\varepsilon_\theta\\[2pt] \kappa_\theta
\end{bmatrix}.
$$ {#eq-calculation-section-general-law}

Como $\xi$ se mide desde el centroide de la sección homogénea, $S_p=0$; el
momento de inercia $I_p$ y el radio $R$ están referidos al mismo eje.
Desaparece entonces el acoplamiento entre extensión y flexión y se
obtienen las relaciones operativas

$$
N_\theta=E_\theta A_p\varepsilon_\theta,
\qquad
M_\theta=E_\theta I_p\kappa_\theta,
$$

$$
EA_\theta=E_\theta A_p,
\qquad
EI_\theta=E_\theta I_p.
$$ {#eq-calculation-appendix-section-stiffness}

La razón adimensional que interviene en el cierre de compatibilidad del
revestimiento circular es, por lo tanto,

$$
\eta_s
=\frac{EI_\theta}{EA_\theta R^2}
=\frac{I_p}{A_pR^2}.
$$ {#eq-calculation-appendix-section-ratio}

Así, la corrugación queda incorporada en el problema plano mediante $A_p$ e
$I_p$ por unidad de longitud longitudinal proyectada. No se aplica una
corrección posterior a las resultantes: las rigideces anteriores forman parte
de la ley seccional utilizada al resolver el equilibrio y la compatibilidad.

## A.5 Solución cerrada para el estado biaxial uniforme {.unnumbered}

El desarrollo siguiente constituye una solución de comprobación del modelo de
acciones prescritas. Se limita a un revestimiento circular uniforme, con
geometría y rigideces fijadas, sometido a un estado biaxial uniforme y a la
relación $P_t=\alpha p_t^*$; no representa una ley constitutiva de la
interfaz.

Considérese un estado uniforme de tensiones principales efectivas
$\sigma_v'$ y $\sigma_h'$ y una diferencia uniforme de presión de agua
$\Delta u=u_{ext}-u_{int}$, positiva cuando la acción hidrostática neta se
dirige hacia el interior. Se definen

$$
p_m=\Delta u+\frac{\sigma_v'+\sigma_h'}{2},
\qquad
\Delta\sigma=\sigma_v'-\sigma_h'.
$$

La presión normal y la componente tangencial proyectada sobre la circunferencia
son

$$
p_n(\theta)=p_m+\frac{\Delta\sigma}{2}\cos2\theta,
\qquad
p_t^*(\theta)=\frac{\Delta\sigma}{2}\sin2\theta.
$$

Para el modelo de acción prescrita,

$$
P_r(\theta)=-p_m-\frac{\Delta\sigma}{2}\cos2\theta,
\qquad
P_t(\theta)=\alpha\frac{\Delta\sigma}{2}\sin2\theta,
\qquad 0\leq\alpha\leq1.
$$ {#eq-calculation-appendix-alpha-load}

La respuesta contiene un término uniforme y un armónico de orden dos. Se
escribe

$$
\begin{aligned}
N_\theta&=N_0+N_2\cos2\theta,\\
Q_\theta&=Q_2\sin2\theta,\\
M_\theta&=M_m+M_2\cos2\theta.
\end{aligned}
$$

La sustitución de estas expresiones y de la
@eq-calculation-appendix-alpha-load en las tres ecuaciones de equilibrio de
A.1 produce, para los términos uniformes y de orden dos,

$$
N_0=-Rp_m,
$$

$$
-2N_2=Q_2-R\alpha\frac{\Delta\sigma}{2},
\qquad
2Q_2=-R\frac{\Delta\sigma}{2}-N_2,
\qquad
-2M_2=RQ_2.
$$ {#eq-calculation-appendix-alpha-algebra}

La resolución sucesiva de este sistema da

$$
N_2=R\Delta\sigma\frac{1+2\alpha}{6},
\qquad
Q_2=-R\Delta\sigma\frac{2+\alpha}{6},
$$

$$
M_2=R^2\Delta\sigma\frac{2+\alpha}{12}.
$$ {#eq-calculation-appendix-alpha-coefficients}

La compatibilidad del término uniforme, con
$\eta_s=EI_\theta/(EA_\theta R^2)$, determina

$$
M_m=R\frac{\eta_s}{1+\eta_s}N_0
=-R^2p_m\frac{\eta_s}{1+\eta_s}.
$$ {#eq-calculation-appendix-alpha-mean-moment}

Por lo tanto, la solución cerrada completa es

$$
\boxed{
\begin{aligned}
N_\theta(\theta)&=-Rp_m
+R\Delta\sigma\frac{1+2\alpha}{6}\cos2\theta,\\
M_\theta(\theta)&=-R^2p_m\frac{\eta_s}{1+\eta_s}
+R^2\Delta\sigma\frac{2+\alpha}{12}\cos2\theta,\\
Q_\theta(\theta)&=-R\Delta\sigma
\frac{2+\alpha}{6}\sin2\theta.
\end{aligned}}
$$ {#eq-calculation-appendix-biaxial-alpha-response}

La misma solución puede comprobarse por superposición. Sea
$\mathbf P^{(0)}$ el estado que contiene sólo la componente normal y
$\mathbf P^{(1)}$ el que incorpora la proyección tangencial completa. De la
definición de la carga se obtiene

$$
\mathbf P^{(\alpha)}
=(1-\alpha)\mathbf P^{(0)}+\alpha\mathbf P^{(1)}.
$$

El sistema de equilibrio y compatibilidad es lineal para las rigideces y la
geometría fijadas. Por consiguiente, cada resultante satisface la misma
superposición. Los coeficientes de los estados extremos cumplen

$$
\frac{1-\alpha}{6}+\frac{\alpha}{2}
=\frac{1+2\alpha}{6},
\qquad
\frac{1-\alpha}{6}+\frac{\alpha}{4}
=\frac{2+\alpha}{12},
$$

$$
\frac{1-\alpha}{3}+\frac{\alpha}{2}
=\frac{2+\alpha}{6},
$$

para $N_\theta$, $M_\theta$ y $Q_\theta$, respectivamente, y reproducen la
@eq-calculation-appendix-biaxial-alpha-response.

La @eq-calculation-appendix-biaxial-alpha-response es un resultado derivado en
esta memoria para la familia de acciones prescritas $P_t=\alpha p_t^*$. Su
ámbito no se extiende a una ley de interacción suelo--estructura, fricción o
deslizamiento.

## A.6 Recuperación de la tensión normal circunferencial {.unnumbered}

Sea $\xi$ la coordenada de la sección neta medida desde su centroide y positiva
hacia el interior. Para una sección homogénea en régimen elástico y una
distribución lineal de deformaciones,

$$
\varepsilon_\theta(\xi)
=\varepsilon_0+\kappa_\theta\xi,
\qquad
\sigma_\theta(\xi)
=E_\theta\left(\varepsilon_0+\kappa_\theta\xi\right).
$$ {#eq-calculation-appendix-sheet-strain}

Las propiedades netas por unidad de longitud longitudinal proyectada son

$$
\bar A_n=\frac{1}{b}\int_{A_n}dA,
\qquad
\bar I_n=\frac{1}{b}\int_{A_n}\xi^2\,dA,
\qquad
\frac{1}{b}\int_{A_n}\xi\,dA=0.
$$ {#eq-calculation-appendix-net-properties}

Al integrar las tensiones de la
@eq-calculation-appendix-sheet-strain sobre la sección se obtiene

$$
N_\theta=E_\theta\bar A_n\varepsilon_0,
\qquad
M_\theta=E_\theta\bar I_n\kappa_\theta.
$$ {#eq-calculation-appendix-net-resultants}

La eliminación de $\varepsilon_0$ y $\kappa_\theta$ conduce a

$$
\sigma_\theta(\theta,\xi)
=\frac{N_\theta(\theta)}{\bar A_n}
+\frac{M_\theta(\theta)\xi}{\bar I_n}.
$$

En las unidades de la memoria, $1\ \mathrm{kN/m}=1\ \mathrm{N/mm}$ para la
fuerza por unidad de ancho, mientras que
$1\ \mathrm{kN\,m/m}=1000\ \mathrm{N\,mm/mm}$ para el momento por unidad de
ancho. Por lo tanto,

$$
\boxed{
\sigma_\theta(\theta,\xi)\,[\mathrm{MPa}]
=\frac{N_\theta(\theta)\,[\mathrm{kN/m}]}{\bar A_n\,[\mathrm{mm^2/mm}]}
+1000\frac{M_\theta(\theta)\,[\mathrm{kN\,m/m}]\,\xi\,[\mathrm{mm}]}
{\bar I_n\,[\mathrm{mm^4/mm}]}}
$$ {#eq-calculation-appendix-sheet-normal-stress}

Como $M_\theta>0$ produce tracción en la fibra interior, el signo positivo del
término flexional es coherente con $\xi>0$ hacia el interior.

La derivación supone una distribución lineal de deformaciones. En un perfil
corrugado curvo sólo se aplica después de adoptar un criterio respaldado de
aplicabilidad frente a la curvatura o de cuantificar la diferencia mediante
una formulación de viga curva. Ese criterio no ha sido adoptado para el
revestimiento existente. La misma sección neta y el mismo eje centroidal deben
determinar las rigideces con las que se obtienen $N_\theta$ y $M_\theta$. Si
$\bar A_n$ o $\bar I_n$ varían de manera relevante con $\theta$, deben
recalcularse las resultantes con una representación compatible de esa variación
o justificarse una sección equivalente aplicable. La resultante $Q_\theta$ no
interviene en esta recuperación y no se transforma aquí en una tensión local.
Una sección perforada o con ligamentos aislados requiere, además, evaluar la
continuidad del camino resistente y la estabilidad local.
