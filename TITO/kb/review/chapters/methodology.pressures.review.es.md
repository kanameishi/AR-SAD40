# Determinación de las acciones del relleno

## Profundidad y tensiones verticales

La profundidad de un punto del contorno, medida desde la superficie del
terreno, es

$$
z(\theta)=H_0+R\left(1-\cos\theta\right).
$$ {#eq-depth-theta}

Las profundidades de la clave, del eje y de la solera resultan

$$
z_C=H_0,
\qquad
z_A=H_0+R,
\qquad
z_I=H_0+2R.
$$ {#eq-control-depths}

El equilibrio vertical de un estrato conduce a
$d\sigma'_v/dz=\gamma'(z)$. Para un perfil estratificado,

$$
\sigma'_v(z)=q'+\int_0^z\gamma'(\zeta)\,d\zeta
=q'+\sum_{j=1}^{n_\ell}\gamma'_j\,\Delta z_j(z),
$$ {#eq-effective-vertical}

donde $q'$ es la sobrecarga efectiva uniforme, $\gamma'_j$ es el peso unitario
efectivo de la capa $j$ y $\Delta z_j(z)$ es el espesor de esa capa comprendido
entre la superficie y la profundidad $z$. Para un nivel freático horizontal a
profundidad $z_w$, la presión intersticial exterior es

$$
u_{ext}(z)=\gamma_w\max(0,z-z_w),
\qquad
\sigma_v(z)=\sigma'_v(z)+u_{ext}(z).
$$ {#eq-pore-pressure}

La acción hidráulica sobre la chapa depende de la diferencia
$\Delta u=u_{ext}-u_{int}$ entre las presiones exterior e interior. La condición
$u_{int}=0$ representa un interior drenado a presión atmosférica en términos
manométricos.

Las ordenadas $\sigma'_v(z_C)$, $\sigma'_v(z_A)$ y
$\sigma'_v(z_I)$ caracterizan el gradiente sobre el diámetro. El análisis
transversal adopta el estado uniforme a la cota del eje cuando se requiere una
distribución autoequilibrada. El empleo del gradiente completo exige definir en el
mismo estado el peso propio, la flotación y la reacción de apoyo que equilibran
su resultante vertical.

## Presión de tierras en reposo

El coeficiente de presión de tierras en reposo se define en tensiones
efectivas:

$$
K_0=\frac{\sigma'_h}{\sigma'_v},
\qquad
\sigma'_h=K_0\sigma'_v.
$$ {#eq-k0-definition}

El manual FHWA NHI-05-037 presenta dos relaciones de referencia
[@ChristopherEtAl2006, sec. 5.4.9]. Para un material elástico confinado
lateralmente,

$$
K_0=\frac{\nu_g}{1-\nu_g},
$$ {#eq-k0-elastic}

y para suelos normalmente consolidados, la relación de Jaky se expresa como

$$
K_{0,NC}=1-\sin\phi',
$$ {#eq-k0-jaky}

donde $\nu_g$ es el coeficiente de Poisson y $\phi'$ es el ángulo de fricción
efectiva. Estas relaciones corresponden a estados constitutivos definidos. Un
relleno compactado ha experimentado carga, descarga y recarga; por lo tanto,
su $K_0$ se caracteriza mediante ensayos, registros de construcción o
escenarios explícitos.

A falta de mediciones, se consideran dos parametrizaciones alternativas del
estado horizontal permanente:

$$
\sigma'_h=K_{0,c}\sigma'_v,
$$

o bien

$$
\sigma'_h=K_{0,b}\sigma'_v+\Delta\sigma'_{h,c}.
$$ {#eq-compaction-history}

La primera representa directamente el estado compactado. La segunda agrega un
incremento horizontal residual $\Delta\sigma'_{h,c}$ a un estado de referencia
$K_{0,b}$. Cada caso adopta una sola parametrización para evitar una doble
contabilización de la compactación.

## Transformación del estado tensional en cargas perimetrales

Considérese un estado biaxial uniforme a la cota del eje, con tensiones
efectivas $\sigma'_{v,A}$ y $\sigma'_{h,A}$ y diferencia de presión
intersticial $\Delta u_A$. Se definen

$$
p_m=\Delta u_A+\frac{\sigma'_{v,A}+\sigma'_{h,A}}{2},
\qquad
\Delta\sigma=\sigma'_{v,A}-\sigma'_{h,A}.
$$ {#eq-mean-difference}

La proyección tensorial sobre el contorno circular produce una presión normal
$p_n$, positiva hacia el revestimiento, y una componente tangencial $p_t$,
positiva en el sentido creciente de $\theta$:

$$
p_n(\theta)=p_m+\frac{\Delta\sigma}{2}\cos 2\theta,
$$ {#eq-normal-pressure}

$$
p_t(\theta)=\frac{\Delta\sigma}{2}\sin 2\theta.
$$ {#eq-tangential-traction}

Estas ecuaciones se obtienen evaluando
$\mathbf t=\boldsymbol\sigma\mathbf n$ y proyectando $\mathbf t$ sobre
$(\mathbf e_r,\mathbf e_t)$ con la convención general. En las ecuaciones
estructurales se utiliza $P_r=-p_n$ y $P_t=p_t$. En la clave y la solera,
$p_n=\Delta u_A+\sigma'_{v,A}$; en los hastiales a la altura del eje,
$p_n=\Delta u_A+\sigma'_{h,A}$.

Se evalúan dos estados de carga prescrita:

- **proyección completa del estado biaxial**, con $P_r=-p_n$ y $P_t=p_t$;
- **carga exclusivamente normal**, con $P_r=-p_n$ y $P_t=0$.

El primer estado conserva las componentes normal y tangencial de
$\boldsymbol\sigma\mathbf n$; el segundo prescribe únicamente la componente
normal. Una condición de interfaz requiere, además, una relación constitutiva
entre las tracciones y los desplazamientos relativos. Las dos prescripciones
se evalúan como alternativas independientes; la comparación posterior
determina la envolvente de cada resultante.

## Gradiente sobre el diámetro y equilibrio global

La sustitución de $\sigma'_v[z(\theta)]$, $\sigma'_h[z(\theta)]$ y
$\Delta u[z(\theta)]$ en las @eq-normal-pressure y @eq-tangential-traction
conserva el gradiente vertical. El armónico de orden uno de esa distribución
determina su fuerza resultante. El cálculo estructural admite ese estado sólo
después de agregar una distribución explícita de peso, flotación y reacción de
apoyo que satisfaga las condiciones de equilibrio global. Mientras esa
distribución no se encuentre definida, las envolventes se calculan con el
estado uniforme a la cota del eje y con otras cargas autoequilibradas.

## Relación de diseño USACE

Para tuberías metálicas corrugadas, USACE expresa la fuerza normal
circunferencial factorizada por unidad de longitud como

$$
T_L=\gamma_{DL}\frac{P_{FD}S}{2}
+\gamma_{LL}\frac{P_{FL}C_LF_1}{2},
$$ {#eq-usace-thrust}

donde $S$ es la luz, $P_{FD}$ y $P_{FL}$ son las presiones verticales de carga
permanente y móvil en la clave, $C_L$ es el ancho cargado y $F_1$ es el factor
de distribución de la carga móvil [@USACE2020, ec. 4-20, sec. 4.12]. Para un relleno
homogéneo, el ejemplo D4 utiliza

$$
P_{FD}=\gamma H_0.
$$ {#eq-usace-crown}

En condición de servicio y sin carga móvil,
$T_G=P_{FD}S/2$. La presión radial uniforme que produce la misma fuerza normal
en el radio centroidal $R$ es

$$
p_{eq}=\frac{T_G}{R}=\frac{P_{FD}S}{2R},
\qquad
N_\theta=-T_G.
$$ {#eq-equivalent-uniform}

Si se aproxima $R=S/2$, entonces $p_{eq}=P_{FD}$. Cuando el radio centroidal y
la semiluz difieren, se conserva el cociente $S/(2R)$. Esta equivalencia compara
la componente uniforme de la fuerza normal circunferencial; $M_\theta$ y
$Q_\theta$ requieren una distribución angular.

## Acciones asociadas a la compactación

FHWA-RD-98-191 aplicó fuerzas nodales horizontales en ambos laterales de los
conductos para reproducir la deformación observada durante la compactación. La
fuerza nodal de un elemento se obtiene a partir de la presión lateral y de su
longitud tributaria,

$$
F_i=n_pL_{trib,i},
$$ {#eq-fhwa-nodal-force}

donde $F_i$ tiene unidades de fuerza por unidad de longitud axial
[@McGrathEtAl1999, fig. 5.4, pp. 175--176]. La relación ajustada para la presión
lateral $n_p$, desarrollada exclusivamente en unidades SI, es

$$
n_p=1.3P\left(1-\sin\phi\right)^3
\left(\frac{970}{d_c-250}\right)^2,
$$ {#eq-fhwa-compaction}

donde $n_p$ es la presión lateral en kPa, $P$ es la fuerza total del equipo de
compactación en kN —no menor que 4 kN en la formulación—, $\phi$ es el ángulo
de fricción del suelo en estado suelto, expresado en grados, y $d_c$ es el
diámetro centroidal en mm [@McGrathEtAl1999, ec. 5.1, pp. 176--178]. La
ecuación se obtuvo de un conjunto limitado de análisis para diámetros nominales
de 900 y 1500 mm.

La presión nodal y la dirección horizontal proceden de FHWA. Para trasladarlas
a la viga curva se adopta la siguiente idealización continua. Sea

$$
y(\theta)=R(1+\cos\theta)
$$

la altura del punto sobre la solera. La etapa $s$ actúa en la franja lateral
$y_s^-\leq y(\theta)\leq y_s^+$, definida por la tongada y el alcance del
equipo, mediante la función indicadora

$$
I_s(\theta)=
\begin{cases}
1, & y_s^-\leq y(\theta)\leq y_s^+,\\
0, & \text{en otro caso}.
\end{cases}
$$ {#eq-fhwa-band}

La fuerza horizontal se orienta hacia el eje vertical del conducto en ambos
laterales. Su descomposición en la base local es

$$
P_{r,c}^{(s)}(\theta)=-n_p\lvert\sin\theta\rvert I_s(\theta),
$$

$$
P_{t,c}^{(s)}(\theta)=
-n_p\operatorname{sgn}(\sin\theta)\cos\theta\,I_s(\theta),
$$ {#eq-fhwa-perimeter-load}

con $\operatorname{sgn}(0)=0$. La franja simétrica produce una carga
autoequilibrada. Sus discontinuidades angulares se determinan resolviendo
$y(\theta)=y_s^-$ y $y(\theta)=y_s^+$; la integración estructural se realiza
por intervalos. Con $I_s=1$, la idealización continua aplica la presión
horizontal a toda la altura lateral. Su equivalencia con el esquema nodal
exige conservar, en cada elemento, la misma resultante horizontal.

La presión $n_p$ caracteriza el estado constructivo bidimensional de la
fuente. El estado permanente se evalúa por separado mediante $K_{0,c}$ o
$\Delta\sigma'_{h,c}$, porque FHWA no prescribe una fracción universal de
retención de $n_p$ después de la compactación.

FHWA presenta además, para el sistema SIDD de tubos rígidos,

$$
W_{sp}=\gamma_sD_o\left(H_0+0.11D_o\right),
\qquad
W_p=2T_{sl},
\qquad
VAF=\frac{W_p}{W_{sp}},
$$ {#eq-fhwa-prism}

donde $\gamma_s$ es el peso unitario del suelo, $D_o$ es el diámetro exterior,
$W_{sp}$ es el peso del prisma, $W_p$ es la carga vertical total y $T_{sl}$ es
la compresión en los hastiales [@McGrathEtAl1999, ecs. 2.1--2.3, p. 12]. Por
su dominio de origen, esta relación se conserva como comparación global de
carga y arqueo; no define la distribución perimetral del conducto flexible.
