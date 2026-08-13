# Participación de la componente tangencial

## Acciones proyectadas sobre el contorno

La proyección de un estado biaxial sobre una circunferencia contiene una
componente normal y una componente tangencial. Como el grado de transferencia
de esta última no está caracterizado para el relleno existente, la metodología
define una familia continua de acciones prescritas entre su omisión y su
incorporación completa.

## Proyección del estado tensional

Para tensiones principales efectivas vertical y horizontal,
$\sigma_v'$ y $\sigma_h'$, la presión normal efectiva y la componente
tangencial proyectada son

$$
p_n'(\theta)=\sigma_v'\cos^2\theta+\sigma_h'\sin^2\theta,
$$

$$
p_t^*(\theta)=(\sigma_v'-\sigma_h')\sin\theta\cos\theta.
$$

La diferencia de presión intersticial se incorpora en la acción normal total:

$$
P_r(\theta)=-[p_n'(\theta)+\Delta u(\theta)].
$$

## Multiplicador tangencial

La acción tangencial prescrita es

$$
P_t(\theta)=\alpha\,p_t^*(\theta),
\qquad 0\leq\alpha\leq1.
$$

$\alpha=0$ omite la componente tangencial y $\alpha=1$ incorpora la
proyección completa. Los valores intermedios representan una participación
proporcional. El parámetro pertenece a la definición del estado de carga: no
es un coeficiente de fricción y la formulación no resuelve deslizamiento,
apertura ni recontacto de la interfaz.

## Respuesta del estado biaxial uniforme

Para una geometría y unas rigideces fijadas, las ecuaciones de equilibrio y
compatibilidad son lineales. Si $\mathbf S^{(0)}$ y $\mathbf S^{(1)}$ reúnen
$N_\theta$, $M_\theta$ y $Q_\theta$ en los dos extremos, entonces

$$
\mathbf S^{(\alpha)}
=(1-\alpha)\mathbf S^{(0)}+\alpha\mathbf S^{(1)}.
$$

Con

$$
p_m=\Delta u+\frac{\sigma_v'+\sigma_h'}{2},
\qquad
\Delta\sigma=\sigma_v'-\sigma_h',
\qquad
M_m=-R^2p_m\frac{\eta_s}{1+\eta_s},
$$

resulta

$$
\begin{aligned}
N_\theta&=-Rp_m
+R\Delta\sigma\frac{1+2\alpha}{6}\cos2\theta,\\
M_\theta&=M_m
+R^2\Delta\sigma\frac{2+\alpha}{12}\cos2\theta,\\
Q_\theta&=-R\Delta\sigma\frac{2+\alpha}{6}\sin2\theta.
\end{aligned}
$$

## Incorporación en el análisis probabilístico

$\alpha$ integra el vector de variables de Monte Carlo junto con $\phi'$ y
las restantes variables primitivas que determinen $K_0$. Su dominio,
distribución y dependencias deben definirse antes de la simulación. Cuando
$K_0$ se calcula desde $\phi'$ u otras propiedades, esas magnitudes no se
muestrean además como entradas independientes.

No se asigna a $\alpha$ una relación con parámetros geotécnicos de interfaz
dentro de esta formulación. Una ley constitutiva de contacto requeriría otros
parámetros y un procedimiento de solución propio.
