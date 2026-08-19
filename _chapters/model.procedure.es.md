El cálculo comienza con la profundidad del centro del túnel y las tensiones
efectivas vertical y horizontal en esa cota. La chapa, el hormigón proyectado
simple y las secciones armadas comparten ese estado de campo libre. Para cada
revestimiento se definen por separado su radio baricéntrico, módulo elástico,
coeficiente de Poisson, área y momento de inercia.

La demanda transversal se obtiene con la secuencia de carga externa de
Schwartz--Einstein. Las razones de compresibilidad y flexibilidad son

$$
C^*=\frac{E_gR(1-\nu_\ell^2)}
{E_\ell A_\ell(1-\nu_g^2)},
\qquad
F^*=\frac{E_gR^3(1-\nu_\ell^2)}
{E_\ell I_\ell(1-\nu_g^2)}.
$$ {#eq-calculation-procedure-se-stiffness}

Con $P_{SE}=\sigma'_v$ y
$K_{SE}=\sigma'_h/\sigma'_v$, la respuesta tiene la forma

$$
\begin{aligned}
N_\theta(\theta)&=-P_{SE}Rt_0+P_{SE}Rt_2\cos2\theta,\\
M_\theta(\theta)&=P_{SE}R^2m_2\cos2\theta,\\
Q_\theta(\theta)&=-2P_{SE}Rm_2\sin2\theta.
\end{aligned}
$$ {#eq-calculation-procedure-se-resultants}

Los coeficientes $t_0$, $t_2$ y $m_2$ se calculan con $C^*$, $F^*$,
$\nu_g$, $K_{SE}$ y la condición de interfaz. Su deducción y sus expresiones
completas se presentan en la metodología ampliada. Para
representar la incertidumbre del contacto se evalúan los límites con
deslizamiento libre y sin deslizamiento. La presión hidráulica neta uniforme se
superpone a la componente media de $N_\theta$. Las combinaciones resistentes
modifican las tensiones vertical, horizontal e hidráulica según sus factores y
vuelven a calcular la interacción, de modo que $N_\theta$, $M_\theta$ y
$Q_\theta$ pertenecen a una misma combinación y posición angular.

La componente uniforme incorpora la redistribución elástica debida a la
rigidez relativa. La variación lineal de las tensiones entre clave y solera se
incorpora mediante la @eq-calculation-balanced-gradient-resultants. Para cada
revestimiento, la demanda utilizada en las comprobaciones es

$$
\begin{aligned}
N_\theta^{d}(\theta)&=N_\theta^{SE}(\theta)+\Delta N_\theta(\theta),\\
M_\theta^{d}(\theta)&=M_\theta^{SE}(\theta)+\Delta M_\theta(\theta),\\
Q_\theta^{d}(\theta)&=Q_\theta^{SE}(\theta)+\Delta Q_\theta(\theta).
\end{aligned}
$$ {#eq-calculation-hybrid-resultants}

El dominio del modelo corresponde a un relleno elástico homogéneo, un contacto
circunferencial continuo y la etapa de relleno completado. Los límites de
deslizamiento libre y ausencia de deslizamiento acotan la condición de
interfaz.

La comprobación independiente de carga prescrita utiliza las ecuaciones de
equilibrio de un anillo sometido a componentes perimetrales $P_r$ y $P_t$:

$$
\frac{d}{d\theta}
\begin{bmatrix}
N_\theta\\ Q_\theta\\ M_\theta
\end{bmatrix}
=
\begin{bmatrix}
Q_\theta-RP_t\\
RP_r-N_\theta\\
RQ_\theta
\end{bmatrix}.
$$ {#eq-calculation-ring-system}

La solución numérica integra este sistema mediante Runge--Kutta de cuarto
orden y determina las tres constantes de cierre mediante periodicidad de
desplazamientos y giro. La ley seccional, las condiciones de compatibilidad y
las constantes resultantes se desarrollan en la metodología ampliada. Esta vía
resuelve el equilibrio del anillo para una carga perimetral prescrita;
Schwartz--Einstein obtiene la componente interactiva a partir de $C^*$, $F^*$
y la interfaz.

La misma carga prescrita puede resolverse mediante series de Fourier. Para una
distribución general,

$$
\begin{aligned}
P_r(\theta)&=a_0+\sum_{n=1}^{\infty}
\left(a_n\cos n\theta+b_n\sin n\theta\right),\\
P_t(\theta)&=c_0+\sum_{n=1}^{\infty}
\left(c_n\cos n\theta+d_n\sin n\theta\right).
\end{aligned}
$$ {#eq-calculation-load-fourier}

Para el tensor biaxial uniforme, los coeficientes $a_0$, $a_2$ y $d_2$
completan la representación en $n=2$. El gradiente lineal equilibrado agrega
los coeficientes de los modos $n=1,3$. La serie de Fourier es la suma de estas
componentes armónicas; $n$ identifica el orden espacial de cada componente.
La integración Runge--Kutta se compara punto por punto con la reconstrucción
modal y se verifica mediante las resultantes globales. Los controles de cargas
discontinuas y de convergencia se documentan en la metodología ampliada.

Fourier descompone una acción perimetral prescrita y Schwartz--Einstein calcula
la respuesta interactiva uniforme a partir de la rigidez relativa y de la
interfaz. La comparación entre ambas vías controla el equilibrio y la
reconstrucción armónica de las componentes superpuestas.

La comprobación AASHTO/USACE calcula el empuje circunferencial escalar mayorado
y lo compara con pared, pandeo, costura, flexibilidad y tapada conforme a la
base de referencia identificada. Sus resultados se presentan junto con la
distribución angular del modelo híbrido como dos comprobaciones de alcance
diferenciado. FHWA aporta la relación documentada para una acción constructiva
de compactación y Núñez aporta casos publicados de revestimientos de túneles
excavados.

La demanda circunferencial y las comprobaciones de pared, costura,
flexibilidad y tapada se desarrollan junto con sus resultados en
@sec-calculation-steel. Los apéndices documentan el coeficiente de empuje y la
acción de compactación en @sec-calculation-appendix-k0, y comparan las
resultantes del proyecto con las formulaciones de referencia en
@sec-calculation-appendix-references.

En síntesis, el modelo obtiene una demanda propia para cada revestimiento a
partir de su radio y de sus rigideces axial y flexional. La componente uniforme
de Schwartz--Einstein incorpora la interacción con el terreno, mientras que
la corrección geostática equilibrada representa la variación de tensiones
entre clave y solera. Los dos límites de interfaz acotan la respuesta y las
comprobaciones numéricas confirman el equilibrio de las resultantes que se
utilizan en las verificaciones de los capítulos siguientes.
