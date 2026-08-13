# Estado biaxial analítico y componente tangencial

## Acciones proyectadas sobre el contorno

Esta sección define un estado de carga analítico prescrito para comprobar las
ecuaciones de la sección circular y estudiar su sensibilidad. No constituye
una ley de contacto ni una distribución reglamentaria de presiones para un
conducto enterrado.

La proyección de un estado biaxial sobre una circunferencia contiene una
componente normal y una componente tangencial. El multiplicador adoptado
define una familia continua de acciones analíticas entre su omisión y su
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

## Uso en análisis de sensibilidad

$\alpha$ puede tratarse como variable de incertidumbre de modelo únicamente
dentro de esta familia biaxial prescrita. Su dominio, distribución y
dependencias deben justificarse antes de una simulación. Cuando $K_0$ se
calcula desde $\phi'$ u otras propiedades, esas magnitudes no se muestrean
además como entradas independientes.

No se asigna a $\alpha$ una relación con parámetros geotécnicos de interfaz.
Una simulación basada en un modelo físico de interacción deberá muestrear los
parámetros de ese modelo y no utilizar $\alpha$ como sustituto automático.
