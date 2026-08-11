# Apéndice A. Síntesis de los desarrollos {#sec-calculation-appendix-derivations .unnumbered}

Este apéndice presenta los pasos indispensables para justificar las fórmulas
operativas del cuerpo. El desarrollo extenso y la revisión bibliográfica se
conservan en el documento metodológico de referencia.

## A.1 Equilibrio del elemento diferencial {.unnumbered}

La fuerza interna sobre la cara positiva se escribe

$$
\mathbf F(\theta)=N_\theta\mathbf e_t-Q_\theta\mathbf e_r.
$$

Con $d\mathbf e_r/d\theta=\mathbf e_t$ y
$d\mathbf e_t/d\theta=-\mathbf e_r$,

$$
\frac{d\mathbf F}{d\theta}
=\left(\frac{dN_\theta}{d\theta}-Q_\theta\right)\mathbf e_t
+\left(-N_\theta-\frac{dQ_\theta}{d\theta}\right)\mathbf e_r.
$$ {#eq-calculation-element-force}

El equilibrio de fuerzas del elemento de longitud $R\,d\theta$ exige

$$
\frac{d\mathbf F}{d\theta}
+R(P_r\mathbf e_r+P_t\mathbf e_t)=\mathbf0.
$$ {#eq-calculation-element-equilibrium}

La proyección radial y tangencial, junto con el equilibrio de momentos, conduce
a la @eq-calculation-first-order-system. Para $P_t=0$ se recupera la base
radial de Baker [@Baker1968, ecs. 2.1a--2.1c, p. 16]; el término $RP_t$ resulta
del equilibrio vectorial anterior.

## A.2 Cierre por compatibilidad {.unnumbered}

La solución homogénea del sistema contiene dos resultantes de orden uno y un
momento constante. Las condiciones cinemáticas de cierre son

$$
\int_0^{2\pi}M_\theta\cos\theta\,d\theta=0,
\qquad
\int_0^{2\pi}M_\theta\sin\theta\,d\theta=0,
$$

$$
\overline M_\theta
=R\frac{\eta_s}{1+\eta_s}\,\overline N_\theta.
$$ {#eq-calculation-compatibility-conditions}

Al sustituir la @eq-calculation-general-resultants, la ortogonalidad de seno y
coseno determina $\lambda_c$ y $\lambda_s$. Como los términos de orden uno
tienen media nula,
$\overline N_\theta=\overline{\widetilde N}$ y
$\overline M_\theta=\overline{\widetilde M}+\lambda_0$; la tercera condición
determina $\lambda_0$. El resultado es la
@eq-calculation-compatibility-constants.

## A.3 Representación modal {.unnumbered}

La integración directa es la formulación operativa. La representación de
Fourier proporciona un control independiente y permite interpretar los modos
de carga:

$$
P_r=a_0+\sum_{n=1}^{\infty}(a_n\cos n\theta+b_n\sin n\theta),
\qquad
P_t=c_0+\sum_{n=1}^{\infty}(c_n\cos n\theta+d_n\sin n\theta).
$$ {#eq-calculation-load-fourier}

Los coeficientes se calculan mediante la integral usual en $[0,2\pi]$. Para
$n\ge2$, la sustitución en el equilibrio produce

$$
N_n^{(c)}=R\frac{nd_n-a_n}{n^2-1},
\qquad
N_n^{(s)}=-R\frac{b_n+nc_n}{n^2-1},
$$

$$
Q_n^{(c)}=-R\frac{nb_n+c_n}{n^2-1},
\qquad
Q_n^{(s)}=R\frac{na_n-d_n}{n^2-1},
$$

$$
M_n^{(c)}=-R^2\frac{na_n-d_n}{n(n^2-1)},
\qquad
M_n^{(s)}=-R^2\frac{nb_n+c_n}{n(n^2-1)}.
$$ {#eq-calculation-modal-resultants}

El modo uniforme satisface

$$
N_0=Ra_0,
\qquad Q_0=0,
\qquad M_0=R\frac{\eta_s}{1+\eta_s}N_0,
$$ {#eq-calculation-uniform-mode}

y el equilibrio del armónico $n=1$ exige

$$
b_1+c_1=0,
\qquad -a_1+d_1=0.
$$ {#eq-calculation-first-mode-balance}

$n=2$ representa la ovalización; los órdenes superiores describen variaciones
localizadas y cargas por sectores. En cargas discontinuas, la serie se usa sólo
después de verificar convergencia de la carga reconstruida y de los extremos.

## A.4 Geometría de las franjas de compactación {.unnumbered}

Para una cota $0\le y\le2R$ medida desde la solera, las intersecciones con el
contorno están dadas por

$$
\alpha(y)=\arccos\left(\frac{y}{R}-1\right),
\qquad 2\pi-\alpha(y).
$$ {#eq-calculation-fhwa-band-angles}

Los cuatro ángulos asociados a $y_s^-$ y $y_s^+$, después de recortar cotas,
eliminar duplicados y ordenar, delimitan intervalos donde $I_s(\theta)$ es
constante. La integración se realiza por intervalos y conserva la dirección
horizontal y simétrica del esquema nodal de FHWA
[@McGrathEtAl1999, fig. 5.4, pp. 175--176].

## A.5 Propiedades del perfil corrugado {.unnumbered}

Para una deformación circunferencial generalizada
$\varepsilon_\theta+z\kappa_\theta$, el trabajo virtual por unidad de longitud
proyectada es

$$
\delta W_{int}
=\int_A E_\theta(\varepsilon_\theta+z\kappa_\theta)
(\delta\varepsilon_\theta+z\,\delta\kappa_\theta)\,dA.
$$ {#eq-calculation-section-virtual-work}

Si el eje de referencia pasa por el centroide, el término cruzado se anula y se
obtiene la @eq-calculation-section-stiffness. La equivalencia lisa de la
@eq-calculation-equivalent-section se deduce imponiendo
$E_{eq}t_{eq}=E_\theta A_p$ y
$E_{eq}t_{eq}^3/12=E_\theta I_p$.

## A.6 Estimadores y control estadístico {.unnumbered}

Para una probabilidad $p$ entre dos posiciones de orden consecutivas puede
emplearse el estimador lineal

$$
\widehat Q_p=(1-g)X_{(j)}+gX_{(j+1)},
\qquad
j=\lfloor (n_r-1)p+1\rfloor,
\qquad
g=(n_r-1)p+1-j.
$$ {#eq-calculation-quantile-estimator}

El remuestreo bootstrap y el criterio de cola se definen en la
@eq-calculation-monte-carlo-convergence. Para una frecuencia binomial
$\widehat p=x/n$, el intervalo de Wilson es

$$
\frac{
\widehat p+z^2/(2n)
\pm z\sqrt{\widehat p(1-\widehat p)/n+z^2/(4n^2)}
}{1+z^2/n}.
$$ {#eq-calculation-wilson-interval}

Este intervalo se aplica a frecuencias de etapa o sector gobernante; no a la
posición angular como variable lineal [@Wilson1927].

## A.7 Correspondencia con el documento metodológico de referencia {.unnumbered}

| Fórmula de esta memoria | Desarrollo de referencia | Función |
|---|---|---|
| @eq-calculation-depth y @eq-calculation-vertical-stress | Acciones del relleno: profundidad, tensiones efectivas y agua | acciones verticales y agua |
| @eq-calculation-k0 y @eq-calculation-compaction-history | Acciones del relleno: empuje en reposo y compactación | tensión lateral |
| @eq-calculation-biaxial-load | Acciones del relleno: transformación del estado biaxial | transformación al contorno |
| @eq-calculation-first-order-system | Modelo estructural: equilibrio diferencial | equilibrio seccional |
| @eq-calculation-compatibility-constants | Modelo estructural: integración directa y compatibilidad | cierre cinemático |
| @eq-calculation-section-stiffness | Perfil corrugado: ley seccional y rigideces | propiedades corrugadas |
| @eq-calculation-quantiles y @eq-calculation-model-envelope | Incertidumbres: cuantiles y envolvente de alternativas | tratamiento de incertidumbres |

: Trazabilidad entre las fórmulas operativas y el documento metodológico de referencia. {#tbl-calculation-equation-traceability}
