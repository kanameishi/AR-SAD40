El método del bloque deslizante de Newmark [-@Newmark1965] representa la cuña en potencial deslizamiento mediante un bloque rígido apoyado sobre un plano inclinado: el bloque acumula desplazamiento cada vez que la aceleración impulsora supera la aceleración de fluencia $k_y g$, y el desplazamiento permanente resulta de la doble integración del exceso de aceleración. Makdisi y Seed [-@MakdisiSeed1978] extendieron el procedimiento a presas y terraplenes al derivar la aceleración equivalente de la masa deslizante a partir de su respuesta dinámica, antecedente directo de las formulaciones flexibles. Los modelos rígidos relacionan el desplazamiento con medidas de la excitación basal; los modelos flexibles incorporan además la respuesta dinámica de la masa mediante $T_s$ y la aceleración espectral evaluada en un período proporcional a $T_s$.

Las formulaciones activas expresan el desplazamiento positivo $D_n$, en centímetros, mediante

$$
D_n=\exp\!\left(\mu_{\ln D}+\epsilon\sigma_{\ln D}\right), \qquad \epsilon\sim\mathcal N (0,1),
$${#eq-newmark-lognormal}

donde $\mu_{\ln D}$ y $\sigma_{\ln D}$ son la media y la desviación estándar de $\ln D_n$ definidas por cada modelo, y $\epsilon$ es un residuo normal estándar. Algunas formulaciones fuente contienen una rama discreta de desplazamiento nulo o despreciable; la evaluación implementada utiliza exclusivamente la rama lognormal positiva. En las ecuaciones siguientes, $k_y$, PGA y $S_a$ se expresan en unidades de $g$ —la aceleración de la gravedad—, $I_A$ en m/s y $T_s$ en segundos. La intensidad de Arias se deriva de la PGA de cada realización según [-@eq-newmark-arias]. La magnitud de referencia del proyecto, $M_w=$ `r .fmt(Mw.gmdp, 1)`, se aplica como entrada constante a todas las demandas, geometrías, materiales y sitios evaluados.

El coeficiente sísmico basado en desempeño puede definirse como

$$
k_{\max} (p_e\mid D_a)
=\inf\left\{k_y:P[D_n (k_y)>D_a]\leq p_e\right\}.
$${#eq-kmax-criterion}

donde $p_e$ es la probabilidad objetivo de que $D_n$ exceda $D_a$.

El coeficiente normalizado se calcula con la PGA transformada al $V_{S30}$ de la combinación de geometría y material evaluada para cada demanda:

$$
k_h=\frac{k_{\max}}{\mathrm{PGA} (V_{S30})}.
$${#eq-kh-normalization}

$k_{\max}$ se expresa en unidades de $g$ y $k_h$ como porcentaje de la PGA con respuesta de sitio. Estas magnitudes trasladan el criterio de desplazamiento a la acción sísmica empleada en la verificación pseudoestática.
