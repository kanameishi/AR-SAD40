# Acciones del relleno {#sec-calculation-actions}

## Tensión vertical efectiva y agua

Sea $H_0$ la tapada medida desde la superficie del terreno hasta la clave y
$R$ el radio centroidal. La profundidad de un punto del contorno es

$$
z(\theta)=H_0+R(1-\cos\theta),
\qquad
(z_C,z_A,z_I)=(H_0,H_0+R,H_0+2R).
$$ {#eq-calculation-depth}

Para una estratigrafía de $n_\ell$ capas, la tensión vertical efectiva se
obtiene mediante

$$
\sigma'_v(z)=q'+\int_0^z\gamma'(\zeta)\,d\zeta
=q'+\sum_{j=1}^{n_\ell}\gamma'_j\,\Delta z_j(z),
$$

$$
u_{ext}(z)=\gamma_w\max(0,z-z_w),
\qquad
\sigma_v(z)=\sigma'_v(z)+u_{ext}(z),
\qquad
\Delta u=u_{ext}-u_{int}.
$$ {#eq-calculation-vertical-stress}

En estas expresiones, $q'$ es la sobrecarga efectiva aplicada en la superficie;
$\gamma'_j$ es el peso unitario efectivo de la capa $j$;
$\Delta z_j(z)$ es el espesor de esa capa comprendido entre la superficie y la
profundidad $z$; $z_w$ es la profundidad del nivel freático; y $\gamma_w$ es
el peso unitario del agua. $u_{ext}$ y $u_{int}$ son las presiones de agua
sobre las caras exterior e interior del revestimiento, respectivamente, por lo
que $\Delta u$ es positiva cuando la acción hidrostática neta se dirige hacia
el interior. Sobre el contorno se utiliza
$\sigma'_v(\theta)=\sigma'_v[z(\theta)]$. En el sistema SI empleado en la
aplicación, las tensiones y presiones se expresan en kPa, los pesos unitarios
en kN/m³ y las profundidades en m.

Las ordenadas de clave, eje y fondo constituyen controles obligatorios. El
peso unitario efectivo y la presión intersticial se calculan por separado para
evitar contabilizar el agua dos veces.

## Empuje lateral en reposo y compactación

El coeficiente de empuje en reposo se define para tensiones efectivas:

$$
K_0=\frac{\sigma'_h}{\sigma'_v},
\qquad
\sigma'_h=K_0\sigma'_v.
$$ {#eq-calculation-k0}

Como relaciones de referencia, un material elástico confinado lateralmente y
un suelo normalmente consolidado satisfacen, respectivamente,

$$
K_0=\frac{\nu_g}{1-\nu_g},
\qquad
K_{0,NC}=1-\sin\phi'.
$$

$\nu_g$ es el coeficiente de Poisson del terreno en la idealización elástica
isótropa y $\phi'$ es el ángulo de fricción interna efectiva.

Estas relaciones se aplican únicamente bajo los estados que las sustentan
[@ChristopherEtAl2006, sec. 5.4.9]. En un relleno compactado, la historia de
tensiones puede representarse mediante una de las dos expresiones siguientes:

$$
\sigma'_h=K_{0,c}\sigma'_v,
\qquad\text{o bien}\qquad
\sigma'_h=K_{0,b}\sigma'_v+\Delta\sigma'_{h,c}.
$$ {#eq-calculation-compaction-history}

$K_{0,c}$ es el coeficiente equivalente para el relleno compactado;
$K_{0,b}$ es el coeficiente correspondiente al estado base; y
$\Delta\sigma'_{h,c}$ es el incremento residual de tensión horizontal efectiva
atribuido a la compactación.

La primera rama concentra el efecto de compactación en un coeficiente
equivalente; la segunda separa un estado base y un incremento residual. Son
parametrizaciones alternativas y no deben sumarse. La elección requiere
clasificación del relleno, humedad, densidad, energía y secuencia de
compactación, además de mediciones disponibles.

## Transformación del estado tensional y acciones perimetrales

En cada punto del contorno, la proyección de las tensiones efectivas vertical
y horizontal produce la presión normal efectiva $p_n'$ y una tracción
tangencial disponible $p_t^*$:

$$
\begin{aligned}
p_n'(\theta)
&=\sigma_v'(\theta)\cos^2\theta
  +\sigma_h'(\theta)\sin^2\theta,\\
p_t^*(\theta)
&=\left[\sigma_v'(\theta)-\sigma_h'(\theta)\right]
  \sin\theta\cos\theta,\\
p_n(\theta)&=p_n'(\theta)+\Delta u(\theta).
\end{aligned}
$$ {#eq-calculation-stress-projection}

Para el estado uniforme en la cota del eje,

$$
p_m=\Delta u_A+\frac{\sigma'_{v,A}+\sigma'_{h,A}}{2},
\qquad
\Delta\sigma=\sigma'_{v,A}-\sigma'_{h,A},
$$

$$
p_n(\theta)=p_m+\frac{\Delta\sigma}{2}\cos2\theta,
\qquad
p_t^*(\theta)=\frac{\Delta\sigma}{2}\sin2\theta.
$$ {#eq-calculation-biaxial-load}

La participación de la componente tangencial proyectada se representa mediante

$$
P_r(\theta)=-p_n(\theta),
\qquad
P_t(\theta)=\alpha\,p_t^*(\theta),
\qquad 0\leq\alpha\leq1.
$$ {#eq-calculation-tangential-multiplier}

$\alpha$ es el multiplicador adoptado para la componente tangencial de la
proyección: $\alpha=0$ la omite y $\alpha=1$ la incorpora por completo. Los
valores intermedios prescriben una participación proporcional. Esta
idealización no establece una ley constitutiva de contacto ni identifica
$\alpha$ con un coeficiente de fricción; su selección se mantiene como una
hipótesis de modelación hasta disponer de evidencia específica de la
interacción entre el relleno y el revestimiento.

## Componente uniforme según USACE

USACE expresa la fuerza normal de cálculo de un conducto metálico corrugado
mediante [@USACE2020, ec. 4-20, sec. 4.12]

$$
T_L=\gamma_{DL}\frac{P_{FD}S}{2}
+\gamma_{LL}\frac{P_{FL}C_LF_1}{2}.
$$ {#eq-calculation-usace-thrust}

$T_L$ es la fuerza normal circunferencial factorizada por unidad de longitud
axial; $P_{FD}$ y $P_{FL}$ son las presiones verticales en clave debidas a
carga permanente y carga móvil; $S$ es la luz del conducto;
$\gamma_{DL}$ y $\gamma_{LL}$ son los factores de carga correspondientes;
$C_L=\min(l_w,S)$ es el ancho de distribución longitudinal de la carga móvil,
con $l_w$ definido por la dispersión de esa carga a la profundidad considerada;
y $F_1$ es el factor de distribución transversal especificado por USACE. Los
factores son adimensionales; $P_{FD}$ y $P_{FL}$ se expresan como presión, y
$S$, $C_L$ y $l_w$ como longitud dentro de un sistema coherente de unidades.

Para un relleno homogéneo, $P_{FD}=\gamma H_0$. En servicio, sin carga móvil,

$$
T_G=\frac{P_{FD}S}{2},
\qquad
p_{eq}=\frac{T_G}{R}=\frac{P_{FD}S}{2R},
\qquad
N_\theta=-T_G.
$$ {#eq-calculation-usace-uniform}

Esta relación permite contrastar la componente uniforme de fuerza normal. La
fuente no proporciona a partir de ella una distribución angular de
$M_\theta$ ni de $Q_\theta$.

## Acción temporal de compactación según FHWA

FHWA propone para la presión lateral equivalente inducida por un equipo de
compactación [@McGrathEtAl1999, ec. 5.1, pp. 176--178]

$$
n_p=1.3P(1-\sin\phi)^3
\left(\frac{970}{d_c-250}\right)^2,
$$ {#eq-calculation-fhwa-compaction}

donde $n_p$ es la presión nodal utilizada en el modelo de la fuente, en kPa;
$P$ es la fuerza total del equipo compactador, en kN —con un valor mínimo de
4 kN para representar el efecto gravitatorio del relleno—; $\phi$ es el ángulo
de fricción del suelo en estado suelto, en grados; y $d_c$ es el diámetro
centroidal del conducto, en mm. Para una tongada $s$, sea
$y(\theta)=R(1+\cos\theta)$ la cota medida desde el fondo e $I_s(\theta)$ el
indicador de la franja $y_s^-\le y\le y_s^+$. La idealización continua que
conserva la dirección horizontal del esquema nodal de la fuente es

$$
P_{r,c}^{(s)}(\theta)=-n_p|\sin\theta|I_s(\theta),
\qquad
P_{t,c}^{(s)}(\theta)=
-n_p\operatorname{sgn}(\sin\theta)\cos\theta\,I_s(\theta).
$$ {#eq-calculation-fhwa-stage-load}

La ecuación de $n_p$ es publicada; la distribución continua es una
transformación de este estudio para integrar la acción en la sección circular.
La acción se aplica por etapa. Su eventual retención en el estado permanente
requiere evidencia específica de construcción; la fuente no establece una
fracción universal.
