# Acciones del relleno {#sec-calculation-actions}

## Tensión vertical efectiva y presión de agua

Sea $H_0$ la tapada medida desde la superficie del terreno hasta la clave y
$R$ el radio de la línea circular de referencia. La profundidad del contorno
es

$$
z(\theta)=H_0+R(1-\cos\theta).
$$ {#eq-calculation-depth}

Con $\theta=0$ en la clave, las profundidades de la clave, del centro y del
fondo son, respectivamente,

$$
z_C=H_0,
\qquad
z_A=H_0+R,
\qquad
z_F=H_0+2R.
$$ {#eq-calculation-control-depths}

Para una estratigrafía de $n_\ell$ capas, la tensión vertical efectiva se
determina mediante

$$
\sigma'_v(z)=q'+\int_0^z\gamma'(\zeta)\,d\zeta
=q'+\sum_{j=1}^{n_\ell}\gamma'_j\,\Delta z_j(z),
$$ {#eq-calculation-vertical-effective-stress}

donde $q'$ es la sobrecarga efectiva aplicada en la superficie,
$\gamma'_j$ es el peso unitario efectivo de la capa $j$ y
$\Delta z_j(z)$ es el espesor de esa capa comprendido entre la superficie y
la profundidad $z$. La presión de agua exterior y la acción hidráulica neta
son

$$
u_{ext}(z)=\gamma_w\max(0,z-z_w),
\qquad
\Delta u(z)=u_{ext}(z)-u_{int}(z).
$$ {#eq-calculation-water-pressure}

$z_w$ es la profundidad del nivel freático, $\gamma_w$ es el peso unitario
del agua y $u_{int}$ es la presión sobre la cara interior del revestimiento.
Por convención, $\Delta u>0$ representa una presión neta dirigida hacia el
interior. En el sistema de unidades empleado, las profundidades se expresan
en m, los pesos unitarios en kN/m³ y las tensiones y presiones en kPa.

Las tensiones efectivas y la presión intersticial se calculan por separado.
Esta separación evita aplicar $K_0$ a una tensión total o contabilizar dos
veces la acción del agua. Las ordenadas $\sigma'_v(z_C)$,
$\sigma'_v(z_A)$ y $\sigma'_v(z_F)$ permiten comprobar el gradiente de carga
sobre el diámetro.

## Estado lateral efectivo del relleno {#sec-calculation-k0-estimation}

El coeficiente de empuje en reposo se define en tensiones efectivas:

$$
K_0(z)=\frac{\sigma'_h(z)}{\sigma'_v(z)},
\qquad
\sigma'_h(z)=K_0(z)\,\sigma'_v(z).
$$ {#eq-calculation-k0}

La formulación de $K_0$ se selecciona de acuerdo con la trayectoria tensional
representada. Una medición directa es aplicable cuando reproduce el material,
la profundidad y el intervalo de tensiones analizado. En ausencia de una
medición representativa, las ramas operativas son las siguientes.

Para una idealización elástica lineal e isótropa con deformación lateral
impedida [@ChristopherEtAl2006, sec. 5.4.9],

$$
K_0=\frac{\nu_g}{1-\nu_g},
$$ {#eq-calculation-k0-elastic}

donde $\nu_g$ es el coeficiente de Poisson de la idealización constitutiva.
Para carga primaria o condición normalmente consolidada se utiliza la
relación abreviada de Jáky [@MayneKulhawy1982, pp. 852--853]:

$$
K_{0,NC}=1-\sin\phi',
$$ {#eq-calculation-k0-jaky}

donde $\phi'$ es el ángulo de fricción interna efectiva. La relación se
aplica en tensiones efectivas a suelos no cohesivos y a suelos cohesivos
normalmente consolidados en condiciones drenadas. No se adiciona un término
en $c'$: las relaciones que contienen $\pm2c'\sqrt K$ corresponden a estados
límite activo o pasivo y no al estado en reposo.

Para descarga desde la rama de compresión virgen, Mayne y Kulhawy proponen
[@MayneKulhawy1982, ecs. 6--10]

$$
K_{0,OC}=(1-\sin\phi')\,\mathrm{OCR}^{\sin\phi'},
\qquad
\mathrm{OCR}=\frac{\sigma'_{v,\max}}{\sigma'_v}.
$$ {#eq-calculation-k0-unloading}

La tensión $\sigma'_{v,\max}$ debe corresponder a una máxima histórica
identificable y $\mathrm{OCR}\geq1$. Los ajustes reunidos por los autores para
la descarga se obtuvieron generalmente con $\mathrm{OCR}<15$. Para una
trayectoria de descarga y recarga se define

$$
\mathrm{OCR}_{\max}
=\frac{\sigma'_{v,\max}}{\sigma'_{v,\min}},
$$

y se emplea [@MayneKulhawy1982, ecs. 14--18]

$$
K_0=(1-\sin\phi')\left[
\frac{\mathrm{OCR}}
{\mathrm{OCR}_{\max}^{\,1-\sin\phi'}}
+\frac{3}{4}\left(
1-\frac{\mathrm{OCR}}{\mathrm{OCR}_{\max}}
\right)
\right].
$$ {#eq-calculation-k0-reloading}

Esta expresión recupera la rama de descarga cuando
$\mathrm{OCR}=\mathrm{OCR}_{\max}$ y la condición normalmente consolidada
cuando $\mathrm{OCR}=\mathrm{OCR}_{\max}=1$. Su dominio requiere
$1\leq\mathrm{OCR}\leq\mathrm{OCR}_{\max}$ y
$\mathrm{OCR}_{\max}\geq1$; la evidencia experimental de recarga es menor
que la disponible para carga primaria y descarga. Para $0<\phi'<90^\circ$,
la rama queda fuera de su dominio cuando alcanza el límite pasivo adoptado por
los autores:

$$
K_p=\frac{1+\sin\phi'}{1-\sin\phi'},
\qquad
\mathrm{OCR}_{\lim}
=\left[
\frac{1+\sin\phi'}{(1-\sin\phi')^2}
\right]^{1/\sin\phi'}.
$$ {#eq-calculation-k0-passive-limit}

La descarga requiere $\mathrm{OCR}<\mathrm{OCR}_{\lim}$; la recarga requiere
$\mathrm{OCR}_{\max}<\mathrm{OCR}_{\lim}$. Al alcanzar esa frontera se
descarta la rama, sin limitar artificialmente el valor calculado de $K_0$.
Cada estado adopta una sola formulación y $K_0$ se calcula a partir de sus
variables primitivas.

## Historia de compactación

La compactación puede modificar las propiedades del relleno, producir una
trayectoria de carga--descarga y dejar una tensión horizontal residual. El
estado permanente se representa mediante una de las dos expresiones
siguientes:

$$
\sigma'_h(z)=K_0^{(m)}(z)\,\sigma'_v(z),
$$

o bien

$$
\sigma'_h(z)=K_{0,b}(z)\,\sigma'_v(z)
+\Delta\sigma'_{h,c}(z).
$$ {#eq-calculation-compaction-history}

En la primera, la rama $m$ representa la trayectoria tensional completa. En
la segunda, $K_{0,b}$ describe el estado base y
$\Delta\sigma'_{h,c}$ la tensión horizontal residual atribuida a la
construcción. Las dos expresiones no se superponen cuando representan el mismo
proceso de carga y descarga.

## Acción temporal de compactación

FHWA propone la siguiente presión lateral equivalente para representar la
acción de un equipo de compactación [@McGrathEtAl1999, ec. 5.1, pp. 176--178]:

$$
n_p=1.3P(1-\sin\phi)^3
\left(\frac{970}{d_c-250}\right)^2.
$$ {#eq-calculation-fhwa-compaction}

La relación empírica utiliza $n_p$ en kPa, $P$ en kN, $d_c$ en mm y $\phi$
en grados. La fuerza $P$ no se toma menor que 4 kN, valor con el cual la fuente
representa el efecto gravitatorio del relleno. La correlación fue ajustada
para un conjunto limitado de análisis de tuberías con diámetros nominales de
900 y 1500 mm; los diámetros centroidales $d_c$ empleados por la ecuación son
aproximadamente 970 y 1575 mm. Los casos incluyen ángulos de fricción de 28° y
36° y fuerzas de 4,0, 5,2 y 20,5 kN; su empleo fuera de ese dominio requiere
una justificación específica.

El modelo de referencia aplica $n_p$ a los nodos situados hasta 300 mm por
debajo de la superficie de la tongada activa. Para una tongada $s$, sea
$y(\theta)=R(1+\cos\theta)$ la cota medida desde el fondo e
$I_s(\theta)$ el indicador de esa franja. La transformación continua que
conserva la dirección horizontal de la acción nodal es

$$
P_{r,c}^{(s)}(\theta)=-n_p|\sin\theta|I_s(\theta),
\qquad
P_{t,c}^{(s)}(\theta)=
-n_p\operatorname{sgn}(\sin\theta)\cos\theta\,I_s(\theta).
$$ {#eq-calculation-fhwa-stage-load}

La ecuación de $n_p$ es publicada; la transformación sobre el contorno es una
derivación de este estudio. La acción se evalúa por etapa y no se incorpora
como presión residual permanente sin una caracterización específica del
proceso constructivo.

## Estado biaxial uniforme prescrito

Para comprobar la integración estructural se prescribe en la cota del centro
de la sección un estado efectivo uniforme con componentes principales
$\sigma'_{v,A}$ y $\sigma'_{h,A}$. Su proyección sobre el contorno define
$p'_n$ y $p_t^*$:

$$
\begin{aligned}
p'_n(\theta)
&=\sigma'_{v,A}\cos^2\theta
  +\sigma'_{h,A}\sin^2\theta,\\
p_t^*(\theta)
&=\left(\sigma'_{v,A}-\sigma'_{h,A}\right)
  \sin\theta\cos\theta,\\
p_n(\theta)&=p'_n(\theta)+\Delta u_A.
\end{aligned}
$$ {#eq-calculation-stress-projection}

Con la convención estructural adoptada, las acciones son

$$
P_r(\theta)=-p_n(\theta),
\qquad
P_t(\theta)=\alpha\,p_t^*(\theta),
\qquad 0\leq\alpha\leq1.
$$ {#eq-calculation-tangential-multiplier}

$\alpha$ representa el grado de participación de la componente tangencial
prescrita. No es un coeficiente de fricción ni define una ley constitutiva de
la interfaz. Los valores $\alpha=0$ y $\alpha=1$ delimitan, respectivamente,
la omisión y la incorporación completa de esa componente.

$$
p_m=\Delta u_A+\frac{\sigma'_{v,A}+\sigma'_{h,A}}{2},
\qquad
\Delta\sigma=\sigma'_{v,A}-\sigma'_{h,A},
$$ {#eq-calculation-biaxial-invariants}

y las acciones se reducen a

$$
P_r(\theta)=-p_m-\frac{\Delta\sigma}{2}\cos2\theta,
\qquad
P_t(\theta)=\alpha\frac{\Delta\sigma}{2}\sin2\theta.
$$ {#eq-calculation-biaxial-load}

El estado uniforme es autoequilibrado y permite comprobar la resolución
estructural mediante una solución cerrada. Esta proyección no representa por
sí sola la interacción entre un relleno variable con la profundidad y un
conducto flexible; las acciones distintas de este escenario se formulan y se
equilibran antes de aplicar el procedimiento estructural.
