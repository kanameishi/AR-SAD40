## Propiedades y rigideces del revestimiento {#sec-calculation-stiffness}

Las propiedades de la sección son constantes alrededor de la circunferencia.
Se usa el subíndice $\ell$ para identificar el revestimiento y se reserva el
subíndice $\theta$ para las resultantes variables. La ley seccional es

$$
N_\theta=K_N\varepsilon_\theta,
\qquad
M_\theta=K_M\kappa_\theta,
$$

$$
K_N=E_\ell A_\ell,
\qquad
K_M=E_\ell I_\ell,
\qquad
\eta_\ell=\frac{K_M}{K_NR^2}
=\frac{I_\ell}{A_\ell R^2}.
$$ {#eq-calculation-section-stiffness}

Para la chapa corrugada, $A_\ell=A_p$ e $I_\ell=I_p$ son el área y el
momento de inercia del perfil por unidad de longitud proyectada. Deben proceder
de la geometría real, de una tabla aplicable o de una medición documentada. La
@tbl-calculation-section-reference presenta las propiedades utilizadas para el
perfil CSPI de la familia 76 × 25 mm [@CSPIHandbookChapter2, tabla 2.4].

Para una sección rectangular homogénea de hormigón proyectado y una franja
unitaria,

$$
A_\ell=t_c,
\qquad
I_\ell=\frac{t_c^3}{12},
\qquad
K_N=E_ct_c,
\qquad
K_M=E_c\frac{t_c^3}{12}.
$$ {#eq-calculation-shotcrete-stiffness}

Las rigideces del hormigón corresponden a la sección bruta, no fisurada y de
corto plazo. Se utilizan para recalcular $C^*$, $F^*$ y las resultantes de
Schwartz--Einstein de cada espesor; no constituyen una resistencia. La cuantía
del estudio $P$--$M$ no modifica estas rigideces elásticas, de modo que, para
un mismo espesor, las demandas son comunes a todas las curvas resistentes.
