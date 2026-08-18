# Estado tensional y acciones sobre el contorno

## Tensión vertical efectiva de referencia

La acción de cálculo parte del estado efectivo del relleno en ausencia del
revestimiento, evaluado en una cota de referencia declarada. Si $H_0$ es la
altura de relleno sobre la clave y $R_c$ la distancia entre la clave y el
centro geométrico de la sección, la profundidad utilizada es

$$
z_{ref}=H_0+R_c.
$$ {#eq-methodology-reference-depth}

Para un relleno homogéneo,

$$
\sigma'_v(z_{ref})=q'+\gamma' z_{ref},
$$ {#eq-methodology-effective-vertical-stress}

donde $q'$ es la sobrecarga asignada al estado efectivo y $\gamma'$ es el peso
unitario efectivo adoptado. En una estratigrafía general, el término
$\gamma' z_{ref}$ se sustituye por la integral de los pesos unitarios por
estrato. La condición hidráulica se incorpora mediante la tensión efectiva y
la diferencia de presión de agua exterior--interior; no se suma una segunda
corrección implícita por agua.

La tensión horizontal se obtiene con el $K_0$ seleccionado en el capítulo
anterior:

$$
\sigma'_h(z_{ref})=K_0(z_{ref})\,\sigma'_v(z_{ref}).
$$ {#eq-methodology-effective-horizontal-stress}

En el terreno, ambas tensiones varían con la profundidad. Para un punto del
perímetro del conducto, medido con $\theta=0$ en la clave, la profundidad
geométrica sería

$$
z(\theta)=z_{ref}-R\cos\theta.
$$ {#eq-methodology-perimeter-depth}

Esta relación permite reconocer el gradiente geostático entre clave y solera,
pero no se sustituye punto por punto dentro de Schwartz--Einstein.
La solución publicada supone un campo libre uniforme en un medio infinito y
utiliza $\sigma'_v(z_{ref})$ y $\sigma'_h(z_{ref})$ como dos escalares. El
procedimiento adoptado conserva esa solución para los modos uniformes y de
ovalización y superpone, mediante las ecuaciones de equilibrio del anillo, la
corrección exacta correspondiente al gradiente lineal entre clave y solera.

$K_0$ caracteriza el estado efectivo inicial. No representa arqueo, fricción
de interfaz ni una reducción universal de la carga con la profundidad.
Para carga primaria normalmente consolidada, la especialización utilizada en
los controles es

$$
K_{0,NC}=1-\sin\phi'.
$$ {#eq-k0-jaky}

El estado de cálculo se define mediante
$P_{SE}=\sigma'_v(z_{ref})$ y
$K_{SE}=\sigma'_h(z_{ref})/P_{SE}$. Para cada revestimiento, la solución de
carga externa de Schwartz--Einstein transforma ese campo libre en
$N_\theta$, $M_\theta$ y $Q_\theta$ utilizando sus propias razones $C^*$ y
$F^*$. Se calculan los límites con deslizamiento libre y sin deslizamiento; la
presión hidráulica neta uniforme se superpone a la componente media de fuerza
circunferencial. A esas resultantes se agrega la corrección equilibrada de
gradiente desarrollada más adelante. Por ello, la respuesta final contiene
los modos $n=0,1,2,3$: la interacción por rigidez permanece en $n=0,2$ y la
variación geostática sobre la altura aporta $n=1,3$.

La tapada interviene en la magnitud de $P_{SE}$ y, a través de
$z(\theta)$, en la diferencia entre clave y solera. El cociente $H/D$ no
aparece como una corrección empírica independiente. El modelo no reproduce
una superficie libre próxima, el arqueo tridimensional de una zanja ni la
secuencia de relleno; por ello no debe interpretarse la corrección lineal como
una calibración de esos fenómenos.

## Proyección del estado biaxial

Como control independiente se prescribe en el centro de la sección un estado
uniforme con componentes
principales $\sigma'_{v,A}$ y $\sigma'_{h,A}$. Con $\theta=0$ en la clave, su
proyección normal y tangencial sobre el contorno es

$$
\begin{aligned}
p'_n(\theta)&=\sigma'_{v,A}\cos^2\theta
  +\sigma'_{h,A}\sin^2\theta,\\
p_t^*(\theta)&=(\sigma'_{v,A}-\sigma'_{h,A})
  \sin\theta\cos\theta,\\
p_n(\theta)&=p'_n(\theta)+\Delta u_A.
\end{aligned}
$$ {#eq-methodology-stress-projection}

La convención estructural adopta la tracción radial positiva hacia afuera y la
tracción tangencial positiva con el incremento de $\theta$:

$$
P_r(\theta)=-p_n(\theta),
\qquad
P_t(\theta)=\alpha p_t^*(\theta),
\qquad 0\leq\alpha\leq1.
$$ {#eq-methodology-tangential-projection}

$\alpha=1$ representa la proyección tangencial completa y $\alpha=0$ una
acción exclusivamente normal. Los dos valores son prescripciones de cálculo;
$\alpha$ no es un coeficiente de fricción ni una ley de contacto.

Al definir

$$
p_m=\Delta u_A+\frac{\sigma'_{v,A}+\sigma'_{h,A}}{2},
\qquad
\Delta\sigma=\sigma'_{v,A}-\sigma'_{h,A},
$$

se obtiene la forma armónica

$$
p_n(\theta)=p_m+\frac{\Delta\sigma}{2}\cos2\theta,
$$ {#eq-normal-pressure}

$$
p_t^*(\theta)=\frac{\Delta\sigma}{2}\sin2\theta.
$$ {#eq-tangential-traction}

Por consiguiente,

$$
P_r(\theta)=-p_n(\theta),
\qquad
P_t(\theta)=\alpha p_t^*(\theta).
$$ {#eq-methodology-biaxial-load}

Estas tracciones alimentan la integración directa de las ecuaciones de
equilibrio y compatibilidad. La solución cerrada y Fourier controlan la misma
acción prescrita. No son la ley de interfaz de Schwartz--Einstein y sus
resultantes no alimentan las comprobaciones resistentes.

## Descomposición armónica de un gradiente lineal

Para evaluar el estado geostático a lo largo de la altura del conducto se
considera el caso homogéneo

$$
\sigma'_v(\theta)=\sigma'_{v,A}-\gamma_vR\cos\theta,
\qquad
\sigma'_h(\theta)=\sigma'_{h,A}-\gamma_hR\cos\theta.
$$ {#eq-methodology-linear-gradient-stress}

Para un relleno homogéneo con $K_0$ constante,
$\gamma_v=\gamma'$ y $\gamma_h=K_0\gamma'$. Una sobrecarga uniforme modifica
$\sigma'_{v,A}$ y $\sigma'_{h,A}$, pero no estos gradientes. Si se adopta un
$K_{0,c}$ uniforme por compactación, se utiliza de igual manera
$\gamma_h=K_{0,c}\gamma'$; una distribución por tongadas requiere su propia
proyección.

Al proyectar ambas componentes sobre el contorno, la diferencia respecto del
estado uniforme del eje puede escribirse como

$$
\Delta P_r(\theta)=a_1^g\cos\theta+a_3^g\cos3\theta,
\qquad
\Delta P_t(\theta)=d_1^g\sin\theta+d_3^g\sin3\theta,
$$

$$
\begin{aligned}
a_1^g&=\frac{R}{4}(3\gamma_v+\gamma_h),
&d_1^g&=-\frac{R}{4}(\gamma_v-\gamma_h),\\
a_3^g&=\frac{R}{4}(\gamma_v-\gamma_h),
&d_3^g&=-\frac{R}{4}(\gamma_v-\gamma_h).
\end{aligned}
$$ {#eq-methodology-linear-gradient-load}

Por lo tanto, un gradiente lineal no requiere una serie extensa: agrega
exactamente los modos $n=1$ y $n=3$. Antes de introducir una reacción, sus
coeficientes de orden uno no satisfacen la @eq-first-mode-balance y la
resultante vertical por unidad de longitud es

$$
F_z=-\pi\gamma_vR^2.
$$ {#eq-methodology-linear-gradient-resultant}

Ese valor es la resultante del campo gravitatorio sobre el material encerrado
por el contorno. El anillo no puede recibirla como cuerpo libre sin una
reacción. Se representa el contacto continuo mediante una restricción radial
distribuida sobre toda la circunferencia y rigidez tangencial nula. La
reacción sólo necesita el modo $n=1$,

$$
a_1^s=d_1^g-a_1^g=-R\gamma_v.
$$ {#eq-methodology-gradient-support-reaction}

Después de superponerla, $a_1=d_1^g$ y la resultante global es nula. Esta es
una reacción de restricción obtenida por equilibrio; no se adopta un valor de
$k_r$ ni se calcula un desplazamiento del terreno. La solución modal de la
carga equilibrada da, con
$\Delta\gamma=\gamma_v-\gamma_h$,

$$
\Delta N_\theta(\theta)=
-\frac{R^2\Delta\gamma}{4}\cos\theta
-\frac{R^2\Delta\gamma}{8}\cos3\theta,
$$

$$
\Delta M_\theta(\theta)=
-\frac{R^3\Delta\gamma}{24}\cos3\theta,
\qquad
\Delta Q_\theta(\theta)=
\frac{R^2\Delta\gamma}{8}\sin3\theta.
$$ {#eq-methodology-balanced-gradient-resultants}

La respuesta empleada en las comprobaciones es la suma de las resultantes
Schwartz--Einstein y de la @eq-methodology-balanced-gradient-resultants. Esta
superposición no extiende la ley de impedancia de Schwartz--Einstein a los
modos impares: $C^*$, $F^*$ y la interfaz continúan actuando sólo sobre los
modos $n=0,2$ del campo uniforme. Los modos $n=1,3$ son una corrección de
carga prescrita, equilibrada y controlada mediante Fourier e integración
numérica. La compresión normal prescrita se verifica sobre todo el perímetro;
si apareciera tracción de contacto, el modelo lineal dejaría de ser aplicable.

## Acción constructiva de compactación

Cuando se estudia una etapa de compactación, la presión lateral propuesta por
FHWA-RD-98-191 se mantiene separada del estado permanente de $K_0$. En las
unidades SI de la fuente,

$$
n_p=1.3P\left(1-\sin\phi\right)^3
\left(\frac{970}{d_c-250}\right)^2,
$$ {#eq-fhwa-compaction}

donde $P$ es la fuerza total del equipo en kN, $\phi$ el ángulo de fricción en
estado suelto y $d_c$ el diámetro centroidal en mm
[@McGrathEtAl1999, ec. 5.1, pp. 176--178]. Para una franja lateral de una
tongada se define

$$
I_s(\theta)=
\mathbf{1}_{[y_s^-,y_s^+]}
\left[R(1+\cos\theta)\right].
$$ {#eq-fhwa-band}

y la acción horizontal hacia el eje se proyecta como

$$
P_{r,c}^{(s)}(\theta)=-n_p\lvert\sin\theta\rvert I_s(\theta),
\qquad
P_{t,c}^{(s)}(\theta)=
-n_p\operatorname{sgn}(\sin\theta)\cos\theta\,I_s(\theta).
$$ {#eq-fhwa-perimeter-load}

FHWA no prescribe una fracción universal de retención de $n_p$. Una
representación del estado permanente compactado utiliza

$$
\sigma'_h=K_{0,c}\sigma'_v.
$$

La representación alternativa separa una componente residual:

$$
\sigma'_h=K_{0,b}\sigma'_v+\Delta\sigma'_{h,c}.
$$ {#eq-compaction-history}

Cada caso utiliza una sola parametrización para evitar contabilizar dos veces
la compactación. La memoria determinística vigente no incorpora esta acción
porque los datos de construcción y retención no están definidos.

## Alcance de la acción prescrita

La solución final conserva explícitamente la dependencia con la tapada, el
peso unitario, la sobrecarga, $\phi'$, OCR y el agua. Schwartz--Einstein
incorpora la redistribución elástica por rigidez relativa para el campo
uniforme; la corrección equilibrada incorpora la variación lineal de ese campo
sobre la altura. El procedimiento no reproduce por sí solo la secuencia de
compactación, el arqueo de una zanja, una superficie libre próxima ni una ley
constitutiva completa para los modos impares. Esos efectos requieren datos
propios y no se introducen mediante un factor oculto.
