## Rigideces circunferenciales {#sec-calculation-stiffness}

### Perfil corrugado

En el problema plano, la corrugación se representa mediante las propiedades de
la sección por unidad de longitud proyectada sobre el eje. La ley constitutiva
es

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

$A_p$ e $I_p$ son, respectivamente, el área y el momento de inercia del perfil
corrugado por unidad de longitud proyectada; deben proceder de la geometría
real, de tablas aplicables o de una medición documentada. La tabla 2.4 del
manual CSPI publica estas propiedades para la familia corrugada considerada y
distingue el espesor especificado del espesor base de diseño
[@CSPIHandbookChapter2, tabla 2.4].

La razón $\eta_s$ interviene en la compatibilidad del modo uniforme mediante la
@eq-calculation-compatibility-constants. El modelo plano emplea exclusivamente
las rigideces circunferenciales porque las acciones adoptadas no varían en la
dirección longitudinal. En esta etapa, las propiedades tabuladas se emplean
para obtener las rigideces circunferenciales del caso analítico.

### Alternativas de hormigón proyectado

Cada alternativa de hormigón proyectado se analiza como un revestimiento
autónomo, sin acción compuesta con la chapa ni con la otra alternativa. Para
una franja de ancho axial proyectado unitario y una sección rectangular
homogénea de espesor $t_c$,

$$
A_c=t_c,
\qquad
I_c=\frac{t_c^3}{12},
\qquad
EA_c=E_cA_c,
\qquad
EI_c=E_cI_c.
$$ {#eq-calculation-shotcrete-stiffness}

Estas rigideces corresponden a la sección bruta, no fisurada y de corto plazo.
Se emplean exclusivamente para recalcular la interacción con el relleno y las
resultantes de cada alternativa; no constituyen una capacidad resistente. Las
alternativas simple y armada conservan sus propios espesores y propiedades
seccionales, por lo que sus rigideces se calculan por separado. Sus productos y
comprobaciones resistentes también permanecen separados.
