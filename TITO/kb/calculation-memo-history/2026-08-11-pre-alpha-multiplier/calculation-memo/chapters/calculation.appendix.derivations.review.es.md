# Apéndice A. Síntesis de los desarrollos {#sec-calculation-appendix-derivations .unnumbered}

Este apéndice resume los desarrollos necesarios para comprobar las fórmulas
operativas empleadas en la memoria.

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

La proyección radial y tangencial, junto con el equilibrio de momentos,
conduce a la @eq-calculation-first-order-system. Para $P_t=0$ se recupera la
formulación radial de Baker [@Baker1968, ecs. 2.1a--2.1c, p. 16]. El término
$RP_t$ proviene de la componente tangencial de la acción perimetral.

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
tienen media nula, $\overline N_\theta=\overline{\widetilde N}$ y
$\overline M_\theta=\overline{\widetilde M}+\lambda_0$; la tercera condición
determina $\lambda_0$. El resultado es la
@eq-calculation-compatibility-constants.

## A.3 Geometría de las franjas de compactación {.unnumbered}

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

## A.4 Propiedades del perfil corrugado {.unnumbered}

Para una deformación circunferencial generalizada
$\varepsilon_\theta+\xi\kappa_\theta$, el trabajo virtual por unidad de longitud
proyectada es

$$
\delta W_{int}
=\int_A E_\theta(\varepsilon_\theta+\xi\kappa_\theta)
(\delta\varepsilon_\theta+\xi\,\delta\kappa_\theta)\,dA.
$$ {#eq-calculation-section-virtual-work}

Si el eje de referencia pasa por el centroide, el término cruzado se anula y
se obtiene la @eq-calculation-section-stiffness.

## A.5 Coeficiente requerido de fricción de interfaz {.unnumbered}

Para un estado efectivo biaxial uniforme con
$\sigma_v'>0$, $\sigma_h'>0$ y adhesión nula $(c_a=0)$, la fricción necesaria para transferir la
tracción tangencial proyectada satisface

$$
\alpha_{\delta,req}
=\max_\theta
\frac{|(\sigma_v'-\sigma_h')\sin\theta\cos\theta|}
{\sigma_v'\cos^2\theta+\sigma_h'\sin^2\theta}.
$$ {#eq-calculation-interface-threshold-general}

Con $x=|\tan\theta|$, el cociente toma la forma
$|\sigma_v'-\sigma_h'|x/(\sigma_v'+\sigma_h'x^2)$. Su máximo ocurre en
$x=\sqrt{\sigma_v'/\sigma_h'}$ y resulta

$$
\alpha_{\delta,req}
=\frac{|\sigma_v'-\sigma_h'|}
{2\sqrt{\sigma_v'\sigma_h'}}.
$$ {#eq-calculation-interface-threshold-derived}

Este valor es una propiedad del estado de tensiones considerado. El
coeficiente disponible se obtiene de $\alpha_\delta=\tan\delta$ y la
transferencia efectiva se limita mediante la
@eq-calculation-interface-friction.
