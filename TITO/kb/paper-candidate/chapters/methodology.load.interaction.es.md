# Estado tensional y acciones sobre el contorno

## Tensión vertical efectiva de referencia

La acción de producción parte del estado efectivo del relleno en ausencia del
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

$K_0$ caracteriza el estado efectivo inicial. No representa arqueo, fricción
de interfaz ni una reducción universal de la carga con la profundidad.
Para carga primaria normalmente consolidada, la especialización utilizada en
los controles es

$$
K_{0,NC}=1-\sin\phi'.
$$ {#eq-k0-jaky}

## Proyección del estado biaxial

Se prescribe en el centro de la sección un estado uniforme con componentes
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
equilibrio y compatibilidad. La solución cerrada y la representación de
Fourier controlan la misma acción prescrita. Schwartz--Einstein se evalúa en
una comparación separada y no reemplaza estas tracciones ni las resultantes
empleadas en las comprobaciones resistentes.

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
\begin{cases}
1, & y_s^-\leq R(1+\cos\theta)\leq y_s^+,\\
0, & \text{en otro caso},
\end{cases}
$$ {#eq-fhwa-band}

y la acción horizontal hacia el eje se proyecta como

$$
P_{r,c}^{(s)}(\theta)=-n_p\lvert\sin\theta\rvert I_s(\theta),
\qquad
P_{t,c}^{(s)}(\theta)=
-n_p\operatorname{sgn}(\sin\theta)\cos\theta\,I_s(\theta).
$$ {#eq-fhwa-perimeter-load}

FHWA no prescribe una fracción universal de retención de $n_p$. El estado
permanente compactado se representa, alternativamente, mediante

$$
\sigma'_h=K_{0,c}\sigma'_v,
\qquad\text{o bien}\qquad
\sigma'_h=K_{0,b}\sigma'_v+\Delta\sigma'_{h,c}.
$$ {#eq-compaction-history}

Cada caso utiliza una sola parametrización para evitar contabilizar dos veces
la compactación. La memoria determinística vigente no incorpora esta acción
porque los datos de construcción y retención no están definidos.

## Alcance de la acción prescrita

El estado biaxial uniforme conserva explícitamente la dependencia con la
tapada, el peso unitario, la sobrecarga, $\phi'$, OCR y el agua. Representa una
acción perimetral equilibrada para comparar las dos proyecciones y las
alternativas de revestimiento. No reproduce por sí solo la secuencia de
compactación, el arqueo de una zanja, una superficie libre próxima ni una ley
constitutiva completa de interacción suelo--estructura. Esos efectos requieren
acciones o modelos adicionales con datos propios y no se introducen mediante
un factor oculto.
