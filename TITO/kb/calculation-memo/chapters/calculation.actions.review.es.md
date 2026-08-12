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

## Estimación del coeficiente de empuje en reposo {#sec-calculation-k0-estimation}

El coeficiente de empuje en reposo se define mediante tensiones efectivas:

$$
K_0(z)=\frac{\sigma'_h(z)}{\sigma'_v(z)},
\qquad
\sigma'_h(z)=K_0(z)\,\sigma'_v(z).
$$ {#eq-calculation-k0}

La magnitud que alimenta el cálculo de las acciones perimetrales es
$\sigma'_h(z)$. Salvo que se disponga de una medición representativa o se
declare un escenario analítico, $K_0$ se obtiene de las propiedades del suelo
y de la trayectoria de carga. Las ramas admisibles se mantienen separadas;
cada estado adopta una única rama, seleccionada según las propiedades del
suelo, la trayectoria de carga y la evidencia disponible.

| Condición representada | Variables requeridas | Uso dentro del procedimiento |
|---|---|---|
| medición directa | valor medido, profundidad, trayectoria y calidad del ensayo | estimación preferente cuando el ensayo representa el relleno y el intervalo tensional considerados |
| idealización elástica confinada | $\nu_g$ | referencia constitutiva para deformación lateral impedida |
| carga primaria o estado normalmente consolidado | $\phi'$ | correlación de Jáky para suelos no cohesivos y suelos cohesivos normalmente consolidados |
| descarga primaria | $\phi'$ y $\mathrm{OCR}$ | relación de Mayne--Kulhawy para descarga desde la compresión virgen |
| descarga seguida de recarga | $\phi'$, $\mathrm{OCR}$ y $\mathrm{OCR}_{\max}$ | relación condicionada al conocimiento de la historia tensional máxima |
| valor adoptado | $K_0$ declarado | comprobación o sensibilidad; no constituye una estimación del relleno existente |

: Ramas para determinar el estado lateral efectivo. {#tbl-calculation-k0-branches}

Para la idealización elástica confinada y el estado normalmente consolidado,
respectivamente [@ChristopherEtAl2006, sec. 5.4.9],

$$
K_0=\frac{\nu_g}{1-\nu_g},
\qquad
K_{0,NC}=1-\sin\phi'.
$$ {#eq-calculation-k0-reference}

$\nu_g$ es el coeficiente de Poisson de la idealización elástica isótropa y
$\phi'$ es el ángulo de fricción interna efectiva correspondiente al material
y al intervalo de tensiones analizado.

Para una descarga primaria, Mayne y Kulhawy proponen
[@MayneKulhawy1982, ec. 10]

$$
K_{0,OC}=(1-\sin\phi')\,\mathrm{OCR}^{\sin\phi'},
\qquad
\mathrm{OCR}=\frac{\sigma'_{v,\max}}{\sigma'_v}.
$$ {#eq-calculation-k0-unloading}

La relación corresponde a descarga desde la rama de compresión virgen. Los
ajustes reunidos por los autores se obtuvieron generalmente para
$\mathrm{OCR}<15$; su empleo requiere una tensión vertical efectiva máxima
histórica identificable.

Cuando la trayectoria incluye descarga y recarga, se define además
[@MayneKulhawy1982, ec. 14]

$$
\mathrm{OCR}_{\max}
=\frac{\sigma'_{v,\max}}{\sigma'_{v,\min}},
$$

y se utiliza [@MayneKulhawy1982, ec. 18]

$$
K_0=(1-\sin\phi')\left[
\frac{\mathrm{OCR}}
{\mathrm{OCR}_{\max}^{\,1-\sin\phi'}}
+\frac{3}{4}\left(
1-\frac{\mathrm{OCR}}{\mathrm{OCR}_{\max}}
\right)
\right].
$$ {#eq-calculation-k0-reloading}

Esta última relación recupera la descarga primaria cuando
$\mathrm{OCR}=\mathrm{OCR}_{\max}$ y el estado normalmente consolidado cuando
$\mathrm{OCR}=\mathrm{OCR}_{\max}=1$. Debido a que la evidencia de recarga es
más limitada, no se adopta sin una trayectoria tensional documentada.

La relación de descarga deja de representar un estado en reposo al alcanzar
el límite pasivo considerado por los autores
[@MayneKulhawy1982, ecs. 11--12]:

$$
K_p=\frac{1+\sin\phi'}{1-\sin\phi'},
\qquad
\mathrm{OCR}_{\lim}
=\left[
\frac{1+\sin\phi'}{(1-\sin\phi')^2}
\right]^{1/\sin\phi'}.
$$ {#eq-calculation-k0-passive-limit}

Al alcanzar este límite se declara la formulación fuera de dominio; no se
recorta el valor de $K_0$. El coeficiente pasivo se emplea sólo para este
control y no constituye una ley de interfaz suelo--revestimiento. Tampoco se
impone una restricción general $K_0\leq1$, porque la sobreconsolidación puede
producir valores mayores.

### Compactación

El estado en reposo y la tensión horizontal residual de compactación son
magnitudes distintas. Según la evidencia disponible, el estado permanente se
representará mediante una de las alternativas siguientes:

$$
\sigma'_h(z)=K_0^{(m)}(z)\,\sigma'_v(z),
\qquad\text{o bien}\qquad
\sigma'_h(z)=K_{0,b}(z)\,\sigma'_v(z)
+\Delta\sigma'_{h,c}(z).
$$ {#eq-calculation-compaction-history}

En la primera alternativa, la formulación $m$ representa la trayectoria de
carga adoptada. En la segunda, $K_{0,b}$ define el estado base y
$\Delta\sigma'_{h,c}$ una tensión horizontal residual sustentada por un modelo
específico. Las dos rutas no se combinan si describen el mismo proceso de
carga--descarga. Para el revestimiento existente, la magnitud y la variación
con la profundidad de $\Delta\sigma'_{h,c}$ permanecen sin determinar hasta
disponer de la secuencia de colocación, el equipo, la humedad, la densidad
alcanzada y la movilidad del revestimiento.

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
