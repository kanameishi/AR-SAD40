# Rigideces circunferenciales de la chapa corrugada

## Idealización seccional en el plano transversal

El modelo estructural adopta una viga curva por unidad de longitud axial. Su
cinemática contiene únicamente la deformación circunferencial
$\varepsilon_\theta$ y el cambio de curvatura $\kappa_\theta$; no incorpora
deformación axial, torsión ni curvaturas mixtas. El trabajo interno virtual por
unidad de longitud axial es

$$
\delta U=\int_0^{2\pi}
\left(N_\theta\,\delta\varepsilon_\theta
+M_\theta\,\delta\kappa_\theta\right)R\,d\theta.
$$ {#eq-sectional-virtual-work}

Dentro de esta idealización, la ley seccional queda reducida a

$$
N_\theta=K_N\varepsilon_\theta,
\qquad
M_\theta=K_M\kappa_\theta.
$$ {#eq-sectional-constitutive-law}

Esta reducción es una hipótesis cinemática del modelo de viga curva; su dominio
se limita a la respuesta circunferencial de la sección transversal. Cuando
resultan relevantes, la respuesta axial, el cortante en el plano de la chapa y
los acoplamientos ortótropos requieren una formulación de lámina ortótropa con
las rigideces correspondientes.

Para corrugaciones cuya dirección resistente principal coincide con la
circunferencia, el área $A_p$ y el segundo momento de área $I_p$ del perfil,
ambos por unidad de ancho axial proyectado, proporcionan

$$
K_N=E_\ell A_p,
\qquad
K_M=E_\ell I_p.
$$ {#eq-corrugated-rigidities}

La ley unidimensional de viga curva adoptada utiliza el módulo circunferencial
$E_\ell$. Para el ejemplo se toma $E_\ell=E_s=200\ \mathrm{GPa}$, es decir,
el módulo elástico uniaxial del acero, sin amplificación por restricción axial.
Como el mismo módulo interviene en ambas rigideces, se obtiene

$$
\eta_\ell=\frac{K_M}{K_NR^2}
=\frac{I_p}{A_pR^2},
$$ {#eq-corrugated-ratio}

que es la propiedad seccional que interviene en el cierre de compatibilidad de
la respuesta bajo cargas prescritas.

## Sección lisa equivalente

Para comparar con formulaciones que emplean una sección lisa, se define un
espesor y un módulo equivalentes que conservan simultáneamente
$K_N$ y $K_M$:

$$
t_{eq}=\sqrt{\frac{12I_p}{A_p}},
\qquad
E_{eq}=\frac{E_\ell A_p}{t_{eq}}.
$$ {#eq-equivalent-smooth-section}

El par $(t_{eq},E_{eq})$ reproduce las dos rigideces globales en la dirección
circunferencial. $t_{eq}$ es un parámetro de equivalencia seccional; el espesor
base de la chapa es la dimensión que corresponde a la posterior recuperación
de tensiones locales y a las verificaciones resistentes.

## Propiedades publicadas del perfil de $3\times1\ \mathrm{in}$

La tabla 2.6 del manual NCSPA presenta propiedades por unidad de ancho
proyectado para corrugaciones de $3\times1\ \mathrm{in}$
[@NCSPA2018, tabla 2.6]. La @tbl-ncspa-section reproduce las dos filas que
enmarcan un espesor base de 3.0 mm. El manual distingue el espesor nominal
especificado y el espesor base sin recubrimiento.

| Espesor nominal especificado (in) | Espesor base sin recubrimiento (mm) | $A_p$ (mm²/mm) | $I_p$ (mm⁴/mm) |
|---:|---:|---:|---:|
| 0.109 | 2.65684 | 3.30200 | 252.36079 |
| 0.138 | 3.41630 | 4.25027 | 331.01869 |

: Propiedades seccionales del perfil de $3\times1\ \mathrm{in}$. Fuente: tabla 2.6 de NCSPA [@NCSPA2018]. {#tbl-ncspa-section}

El valor nominal de $3.0\ \mathrm{mm}$ suministrado para el estudio no
identifica si corresponde al espesor especificado o al espesor base sin
recubrimiento. Para el ejemplo analítico se adopta el escenario condicional en
el que $3.0\ \mathrm{mm}$ es el espesor base. La interpolación lineal entre
ambas filas da

$$
\lambda=\frac{3.000-2.65684}{3.41630-2.65684}=0.452,
$$

$$
A_p\simeq3.73\ \mathrm{mm^2/mm},
\qquad
I_p\simeq288\ \mathrm{mm^4/mm}.
$$ {#eq-section-interpolation}

Los valores interpolados se aplican únicamente a ese escenario. La evaluación
del revestimiento utiliza las propiedades del perfil confirmado y la categoría
de espesor establecida mediante especificación, certificado o medición.

## Valores derivados para el ejemplo numérico

Con $E_\ell=200\ \mathrm{GPa}$ y $R=1.315\ \mathrm{m}$, adoptados en el
ejemplo,

$$
K_N\simeq7.46\times10^5\ \mathrm{kN/m},
\qquad
K_M\simeq57.6\ \mathrm{kN\,m^2/m},
$$

$$
\eta_\ell\simeq4.46\times10^{-5},
\qquad
t_{eq}\simeq30.4\ \mathrm{mm},
\qquad
E_{eq}\simeq24.5\ \mathrm{GPa}.
$$ {#eq-adopted-section}

El radio de 1.315 m es la aproximación $D_i/2$ utilizada en el ejemplo. En la
evaluación del caso real se emplea el radio centroidal de la sección
corrugada.

Como comparación, Mai publica para una corrugación de
$152\times51\times3\ \mathrm{mm}$ los valores
$A_p=3.522\ \mathrm{mm^2/mm}$ e $I_p=1057.25\ \mathrm{mm^4/mm}$
[@Mai2013, ecs. 2.1--2.2 y tabla 2.1]. La @eq-equivalent-smooth-section produce
$t_{eq}\simeq60.0\ \mathrm{mm}$ y $E_{eq}\simeq11.74\ \mathrm{GPa}$ para
$E_\ell=200\ \mathrm{GPa}$, coincidentes con la precisión publicada.
