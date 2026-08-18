# Modelo de cálculo {#sec-calculation-model}

## Coordenada angular y convenciones de signo

La coordenada angular se define con $\theta=0$ en la clave y sentido positivo
horario. El vector radial $\mathbf e_r$ es positivo hacia el exterior y el
vector tangencial $\mathbf e_t$ sigue el incremento de $\theta$. La fuerza
normal circunferencial $N_\theta$ es positiva a tracción. La coordenada local
$\xi$ de la sección es positiva hacia la fibra interior, de modo que
$M_\theta>0$ produce tracción en esa fibra. En la cara positiva del elemento,
$Q_\theta>0$ actúa hacia el centro del anillo.

Las acciones perimetrales $P_r$ y $P_t$ se expresan en kPa;
$N_\theta$ y $Q_\theta$, en kN/m; y $M_\theta$, en kN·m/m. El subíndice
$\theta$ identifica resultantes cuya magnitud cambia con la posición angular;
no se utiliza para propiedades constantes de la sección.

## Definición de las resultantes

Para una posición angular fija, sea $A_b$ la sección resistente de una franja
de ancho axial proyectado $b$. Con $x_L$ en la dirección axial y $\xi$ medida
desde el eje baricéntrico,

$$
\begin{aligned}
N_\theta(\theta)
&=\frac{1}{b}\iint_{A_b}
\sigma_\theta(\theta,x_L,\xi)\,dA,\\
M_\theta(\theta)
&=\frac{1}{b}\iint_{A_b}
\sigma_\theta(\theta,x_L,\xi)\,\xi\,dA,\\
Q_\theta(\theta)
&=\frac{1}{b}\iint_{A_b}
\tau_{\theta\xi}(\theta,x_L,\xi)\,dA.
\end{aligned}
$$ {#eq-calculation-resultant-definitions}

Estas integrales se evalúan sobre la sección a $\theta$ constante; no son
integrales alrededor de la circunferencia.

## Estado de campo libre y profundidad de referencia

En un perfil general, la tensión vertical efectiva es función de la
profundidad $z$:

$$
\sigma'_v(z)=q'+\int_0^z\gamma'(\zeta)\,d\zeta,
\qquad
\sigma'_h(z)=K_0(z)\,\sigma'_v(z).
$$ {#eq-calculation-general-effective-stress}

Para el relleno homogéneo del escenario, $\gamma'$ es constante y
$\sigma'_v(z)=q'+\gamma'z$. Si $H_0$ es la altura sobre la clave y $R_c$ la
distancia desde la clave hasta el centro de la sección,

$$
z_{ref}=H_0+R_c,
\qquad
\sigma'_{v,ref}=q'+\gamma'z_{ref},
\qquad
\sigma'_{h,ref}=K_0(z_{ref})\sigma'_{v,ref}.
$$ {#eq-calculation-reference-depth}

El coeficiente de presión en reposo se define en tensiones efectivas:

$$
K_0(z)=\frac{\sigma'_h(z)}{\sigma'_v(z)}.
$$ {#eq-calculation-k0}

Para el modelo seleccionado en este caso,

$$
K_0=(1-\sin\phi')\,\mathrm{OCR}^{\sin\phi'}.
$$ {#eq-calculation-k0-unloading}

La profundidad geométrica de un punto del perímetro sería

$$
z(\theta)=z_{ref}-R\cos\theta.
$$ {#eq-calculation-local-depth}

Schwartz--Einstein representa un anillo en un medio infinito sometido a un
campo libre uniforme; por eso utiliza los dos escalares
$\sigma'_{v,ref}$ y $\sigma'_{h,ref}$. La memoria conserva esa solución para
la interacción por rigidez y representa por separado la variación lineal que
resulta de $z(\theta)$. La sobrecarga uniforme modifica las tensiones de
referencia, pero no el gradiente sobre la altura del liner.

## Interacción de Schwartz--Einstein

La carga externa de Schwartz--Einstein se define con

$$
P_{SE}=\sigma'_{v,ref},
\qquad
K_{SE}=\frac{\sigma'_{h,ref}}{P_{SE}}.
$$ {#eq-calculation-se-reference-state}

La interacción uniforme depende de las razones de rigidez

$$
C^*=\frac{E_gR(1-\nu_\ell^2)}
{K_N(1-\nu_g^2)},
\qquad
F^*=\frac{E_gR^3(1-\nu_\ell^2)}
{K_M(1-\nu_g^2)},
$$ {#eq-calculation-se-stiffness}

donde $K_N=E_\ell A_\ell$ y $K_M=E_\ell I_\ell$ son las rigideces del
revestimiento. Los coeficientes $t_0$, $t_2$ y $m_2$ se calculan para los
límites con deslizamiento libre y sin deslizamiento. En la convención de esta
memoria, las resultantes de Schwartz--Einstein son

$$
\begin{aligned}
N_\theta^{SE}(\theta)&=-P_{SE}Rt_0+P_{SE}Rt_2\cos2\theta-\Delta u\,R,\\
M_\theta^{SE}(\theta)&=P_{SE}R^2m_2\cos2\theta,\\
Q_\theta^{SE}(\theta)&=-2P_{SE}Rm_2\sin2\theta.
\end{aligned}
$$ {#eq-calculation-se-resultants}

La presión hidráulica neta uniforme $\Delta u$ se superpone a la componente
media de $N_\theta$. Los coeficientes completos y la conversión de signos se
desarrollan en el [Apéndice A](#sec-calculation-appendix-external-interaction).

Al cambiar el revestimiento cambian $R$, $K_N$, $K_M$, $C^*$ y $F^*$; por
eso se recalculan las demandas de la chapa y de cada espesor de hormigón.

## Corrección equilibrada del gradiente geostático

En el relleno homogéneo se definen
$\gamma_v=\gamma'$ y $\gamma_h=K_0\gamma'$. La proyección de
$\sigma'_v(z(\theta))$ y $\sigma'_h(z(\theta))$ agrega exactamente los modos
$n=1$ y $n=3$. Antes de equilibrar el anillo, esa acción tiene una resultante
vertical $-\pi\gamma_vR^2$. El contacto continuo se representa mediante la
reacción radial distribuida

$$
P_r^s(\theta)=-R\gamma_v\cos\theta,
\qquad k_t=0.
$$ {#eq-calculation-gradient-reaction}

Esta reacción impone el equilibrio del modo $n=1$; no se adopta una rigidez
$k_r$ ni se deduce un desplazamiento. Con
$\Delta\gamma=\gamma_v-\gamma_h$, las resultantes incrementales son

$$
\begin{aligned}
\Delta N_\theta(\theta)&=-\frac{R^2\Delta\gamma}{4}\cos\theta
-\frac{R^2\Delta\gamma}{8}\cos3\theta,\\
\Delta M_\theta(\theta)&=-\frac{R^3\Delta\gamma}{24}\cos3\theta,\\
\Delta Q_\theta(\theta)&=\frac{R^2\Delta\gamma}{8}\sin3\theta.
\end{aligned}
$$ {#eq-calculation-balanced-gradient-resultants}

Las demandas empleadas en las verificaciones son

$$
N_\theta=N_\theta^{SE}+\Delta N_\theta,
\qquad
M_\theta=M_\theta^{SE}+\Delta M_\theta,
\qquad
Q_\theta=Q_\theta^{SE}+\Delta Q_\theta.
$$ {#eq-calculation-hybrid-resultants}

La corrección no atribuye a Schwartz--Einstein una ley de impedancia para los
modos impares. La realimentación por rigidez permanece en los modos $n=0,2$;
los modos $n=1,3$ satisfacen las ecuaciones de equilibrio del anillo y se
controlan independientemente con Fourier e integración numérica. El desarrollo
completo se presenta en el [Apéndice A](#sec-calculation-appendix-gradient).

## Carga biaxial prescrita para control

Como control independiente se proyecta sobre el contorno un tensor uniforme
con componentes principales $\sigma'_{v,A}$ y $\sigma'_{h,A}$:

$$
\begin{aligned}
p'_n(\theta)&=\sigma'_{v,A}\cos^2\theta
  +\sigma'_{h,A}\sin^2\theta,\\
p_t^*(\theta)&=(\sigma'_{v,A}-\sigma'_{h,A})
  \sin\theta\cos\theta,\\
p_n(\theta)&=p'_n(\theta)+\Delta u_A.
\end{aligned}
$$ {#eq-calculation-stress-projection}

Definiendo

$$
p_m=\Delta u_A+\frac{\sigma'_{v,A}+\sigma'_{h,A}}{2},
\qquad
\Delta\sigma=\sigma'_{v,A}-\sigma'_{h,A},
$$

se obtiene

$$
P_r(\theta)=-p_m-\frac{\Delta\sigma}{2}\cos2\theta,
\qquad
P_t(\theta)=\alpha\frac{\Delta\sigma}{2}\sin2\theta.
$$ {#eq-calculation-biaxial-load}

$p_m$ y $\Delta\sigma$ son constantes porque se construyen con el estado
uniforme de referencia; la dependencia angular aparece en la proyección. Los
valores $\alpha=1$ y $\alpha=0$ representan, respectivamente, la proyección
tangencial completa y una acción exclusivamente normal. $\alpha$ no es un
coeficiente de fricción. Esta rama se resuelve con integración directa,
solución cerrada y Fourier sólo para controlar el cálculo; no alimenta
las verificaciones resistentes.
