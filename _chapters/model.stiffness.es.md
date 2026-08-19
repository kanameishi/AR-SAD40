La chapa corrugada se representa mediante el área $A_p$ y el momento de
inercia $I_p$ por unidad de longitud proyectada sobre el eje del túnel. Su ley
seccional circunferencial es

$$
N_\theta=EA_\theta\varepsilon_\theta,
\qquad
M_\theta=EI_\theta\kappa_\theta,
$$

$$
EA_\theta=E_\theta A_p,
\qquad
EI_\theta=E_\theta I_p,
\qquad
\eta_s=\frac{EI_\theta}{EA_\theta R^2}
=\frac{I_p}{A_pR^2}.
$$ {#eq-calculation-section-stiffness}

Las propiedades de la chapa proceden de la fila aplicable de la tabla 2.4 del
manual CSPI, que distingue el espesor especificado del espesor base de diseño
[@CSPIHandbookChapter2]. La inspección deberá confirmar la geometría y el
espesor remanente para sustituir estas propiedades tabuladas. La razón
$\eta_s$ participa en la compatibilidad del modo uniforme del anillo. Como las
acciones adoptadas son constantes a lo largo del túnel, el modelo utiliza las
rigideces circunferenciales.

Cada alternativa de hormigón proyectado se calcula como un revestimiento
independiente de la chapa. Para una franja de ancho axial unitario y una pared
rectangular homogénea de espesor $t_c$,

$$
A_c=t_c,
\qquad
I_g=\frac{t_c^3}{12},
\qquad
EA_c=E_cA_c,
\qquad
EI_c=0.35E_cI_g.
$$ {#eq-calculation-shotcrete-stiffness}

El área axial se conserva completa y la rigidez flexional utiliza
$I_e=0.35I_g$, correspondiente a muro fisurado en el análisis elástico a nivel
de cargas mayoradas de ACI 318-25, Tabla 6.6.3.1.1(a) [@ACI31825]. Con esta
rigidez y con el radio propio de cada
espesor se recalculan $C^*$ y $F^*$ en Schwartz--Einstein. La interacción
produce una distribución de fuerza y momento propia de cada alternativa. En
la comprobación de carga prescrita, la rigidez interviene en la compatibilidad
del modo uniforme; los armónicos $n\geq2$ quedan definidos por las acciones y
el equilibrio. La resistencia se evalúa con las propiedades de cada sección.
Para las tres mallas simétricas de cada espesor, el acero modifica la
resistencia seccional pero no la rigidez usada para obtener las acciones. El
caso adicional compuesto incorpora la chapa exterior y una malla interior a
la rigidez transformada; sus acciones se recalculan con el centroide elástico
y las rigideces $EA$ y $EI$ propias de esa sección.
