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

Las ordenadas de clave, eje y solera constituyen controles obligatorios. El
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

Estas relaciones se aplican únicamente bajo los estados que las sustentan
[@ChristopherEtAl2006, sec. 5.4.9]. En un relleno compactado, la historia de
tensiones puede representarse mediante una de las dos expresiones siguientes:

$$
\sigma'_h=K_{0,c}\sigma'_v,
\qquad\text{o bien}\qquad
\sigma'_h=K_{0,b}\sigma'_v+\Delta\sigma'_{h,c}.
$$ {#eq-calculation-compaction-history}

La primera rama concentra el efecto de compactación en un coeficiente
equivalente; la segunda separa un estado base y un incremento residual. Son
parametrizaciones alternativas y no deben sumarse. La elección requiere
clasificación del relleno, humedad, densidad, energía y secuencia de
compactación, además de mediciones disponibles.

## Transformación del estado biaxial en el contorno

Para un estado uniforme definido en el eje del revestimiento,

$$
p_m=\Delta u_A+\frac{\sigma'_{v,A}+\sigma'_{h,A}}{2},
\qquad
\Delta\sigma=\sigma'_{v,A}-\sigma'_{h,A}.
$$

La acción normal compresiva y la componente tangencial obtenidas por
transformación de coordenadas son

$$
p_n(\theta)=p_m+\frac{\Delta\sigma}{2}\cos2\theta,
\qquad
p_t(\theta)=\frac{\Delta\sigma}{2}\sin2\theta.
$$ {#eq-calculation-biaxial-load}

Se consideran dos prescripciones separadas:

$$
\begin{array}{lll}
\text{proyección completa:} & P_r=-p_n, & P_t=p_t,\\[2mm]
\text{carga exclusivamente normal:} & P_r=-p_n, & P_t=0.
\end{array}
$$ {#eq-calculation-load-prescriptions}

La primera conserva las dos componentes del vector de tracción asociado al
estado biaxial; la segunda retiene sólo su componente normal. Ambas son límites
de modelación de una acción prescrita. La condición real de transferencia debe
sustentarse con la interfaz y la secuencia constructiva; no se deduce de estas
dos expresiones.

## Componente uniforme según USACE

USACE expresa la fuerza normal de cálculo de un conducto metálico corrugado
mediante [@USACE2020, ec. 4-20, sec. 4.12]

$$
T_L=\gamma_{DL}\frac{P_{FD}S}{2}
+\gamma_{LL}\frac{P_{FL}C_LF_1}{2}.
$$ {#eq-calculation-usace-thrust}

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

donde $n_p$ se expresa en kPa, $P$ en kN —con un valor mínimo de 4 kN en la
formulación—, $\phi$ en grados y $d_c$ en mm. Para una tongada $s$, sea
$y(\theta)=R(1+\cos\theta)$ la cota medida desde la solera e $I_s(\theta)$ el
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
