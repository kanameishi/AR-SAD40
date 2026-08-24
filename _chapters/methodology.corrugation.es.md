# Rigideces circunferenciales de la chapa corrugada

## Idealización seccional en el plano transversal

El modelo estructural adopta una viga curva por unidad de longitud axial. Su cinemática contiene únicamente la deformación circunferencial
$\varepsilon_\theta$ y el cambio de curvatura $\kappa_\theta$; no incorpora deformación axial, torsión ni curvaturas mixtas. El trabajo interno virtual por unidad de longitud axial es

$$
\delta U=\int_0^{2\pi} \left (N_\theta\,\delta\varepsilon_\theta +M_\theta\,\delta\kappa_\theta\right)R\,d\theta.
$$ {#eq-sectional-virtual-work}

Dentro de esta idealización, la ley seccional queda reducida a

$$
N_\theta=K_N\varepsilon_\theta, \qquad M_\theta=K_M\kappa_\theta.
$$ {#eq-sectional-constitutive-law}

Esta reducción es una hipótesis cinemática del modelo de viga curva; su dominio se limita a la respuesta circunferencial de la sección transversal. Cuando resultan relevantes, la respuesta axial, el cortante en el plano de la chapa y los acoplamientos ortótropos requieren una formulación de lámina ortótropa con las rigideces correspondientes.

Para corrugaciones cuya dirección resistente principal coincide con la circunferencia, el área $A_p$ y el segundo momento de área $I_p$ del perfil, ambos por unidad de ancho axial proyectado, proporcionan

$$
K_N=E_\ell A_p, \qquad K_M=E_\ell I_p.
$$ {#eq-corrugated-rigidities}

La ley unidimensional de viga curva adoptada utiliza el módulo circunferencial
$E_\ell$. Para el ejemplo se toma $E_\ell=E_s=200\ \mathrm{GPa}$, es decir, el módulo elástico uniaxial del acero, sin amplificación por restricción axial. Como el mismo módulo interviene en ambas rigideces, se obtiene

$$
\eta_\ell=\frac{K_M}{K_NR^2} =\frac{I_p}{A_pR^2},
$$ {#eq-corrugated-ratio}

que es la propiedad seccional que interviene en el cierre de compatibilidad de la respuesta bajo cargas prescritas.

## Sección lisa equivalente

Para comparar con formulaciones que emplean una sección lisa, se define un espesor y un módulo equivalentes que conservan simultáneamente
$K_N$ y $K_M$:

$$
t_{eq}=\sqrt{\frac{12I_p}{A_p}}, \qquad E_{eq}=\frac{E_\ell A_p}{t_{eq}}.
$$ {#eq-equivalent-smooth-section}

El par $(t_{eq},E_{eq})$ reproduce las dos rigideces globales en la dirección circunferencial. $t_{eq}$ es un parámetro de equivalencia seccional; el espesor base de la chapa es la dimensión que corresponde a la posterior recuperación de tensiones locales y a las verificaciones resistentes.

## Propiedades del perfil CSPI de $76\times25\ \mathrm{mm}$

La fuente seccional adoptada es el Capítulo 2 del manual CSPI. La fila de espesor especificado $3.5\ \mathrm{mm}$ de su Tabla 2.4 corresponde a un espesor base de $3.35\ \mathrm{mm}$ y proporciona, por unidad de ancho proyectado, $A_{p,b}=4.169\ \mathrm{mm^2/mm}$ e
$I_{p,b}=319.77\ \mathrm{mm^4/mm}$
[@CSPIHandbookChapter2, fig. 2.1 y tabla 2.4].

La pérdida de espesor se representa mediante adelgazamiento uniforme con la línea media fija. Para un espesor base remanente $t_r$ se define

$$
r_t=\frac{t_r}{t_b}, \qquad A_p=r_tA_{p,b}, \qquad I_p=r_tI_{p,b}.
$$ {#eq-section-uniform-thinning}

Esta representación conserva la geometría de la corrugación y reduce en la misma proporción el área y el segundo momento de área de la fila de referencia. Las pérdidas localizadas, perforaciones y variaciones alrededor del perímetro requieren propiedades seccionales específicas.

## Valores del escenario vigente

El escenario utiliza un espesor especificado de
`r formatCalculationGeneral(Calculation$section$specifiedThicknessMm)` mm, un espesor base de referencia de
`r formatCalculationGeneral(Calculation$section$designBaseThicknessMm)` mm y un espesor base remanente de
`r formatCalculationGeneral(Calculation$section$remainingBaseThicknessMm)` mm. El modelo de adelgazamiento produce
$A_p=`r formatCalculationGeneral(Calculation$section$areaMm2PerMm)`\,\mathrm{mm^2/mm}$
e $I_p=`r formatCalculationGeneral(Calculation$section$inertiaMm4PerMm)`\,\mathrm{mm^4/mm}$.

Con el módulo circunferencial y el radio centroidal declarados en la entrada, las rigideces son
$K_N=`r formatCalculationGeneral(Calculation$section$extensionalRigidityKnPerM)`\,\mathrm{kN/m}$
y $K_M=`r formatCalculationGeneral(Calculation$section$flexuralRigidityKnM2PerM)`\,\mathrm{kN\,m^2/m}$. La razón seccional es
$\eta_\ell=`r formatCalculationScientificLatex(Calculation$section$sectionRatio)`$
y el espesor liso equivalente es
`r formatCalculationGeneral(1000 * Calculation$section$equivalentThicknessM)` mm. El radio utilizado por el cálculo es el radio centroidal de
`r formatCalculationGeneral(Calculation$section$centroidalRadiusM)` m definido en `calculation.json`.

Como comparación, Mai publica para una corrugación de
$152\times51\times3\ \mathrm{mm}$ los valores
$A_p=3.522\ \mathrm{mm^2/mm}$ e $I_p=1057.25\ \mathrm{mm^4/mm}$
[@Mai2013, ecs. 2.1--2.2 y tabla 2.1]. La @eq-equivalent-smooth-section produce
$t_{eq}\simeq60.0\ \mathrm{mm}$ y $E_{eq}\simeq11.74\ \mathrm{GPa}$ para
$E_\ell=200\ \mathrm{GPa}$, coincidentes con la precisión publicada.
