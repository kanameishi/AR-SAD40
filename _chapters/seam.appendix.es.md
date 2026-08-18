La comprobación de la costura utiliza la demanda $T_u$ definida en
@sec-calculation-appendix-thrust. La pérdida relativa de diámetro de los
pernos se representa mediante

$$
\delta_d=\frac{\Delta d}{d_0},
\qquad
d_r=d_0-\Delta d=d_0(1-\delta_d),
$$ {#eq-calculation-aashto-seam-diameter}

donde $d_0$ y $d_r$ son los diámetros nominal y remanente. La relación entre
las áreas remanente y nominal es

$$
\rho_d
=\frac{\pi d_r^2/4}{\pi d_0^2/4}
=(1-\delta_d)^2.
$$ {#eq-calculation-aashto-seam-area-ratio}

La sensibilidad adoptada reduce la resistencia nominal publicada en
proporción a esa relación de áreas:

$$
R_s(\delta_d)=\phi_sR_{n,0}(1-\delta_d)^2,
\qquad
U_s(\delta_d)=\frac{T_u}{R_s(\delta_d)}.
$$ {#eq-calculation-aashto-seam-resistance}

$R_{n,0}$ es la resistencia nominal publicada de la costura de referencia y
$\phi_s$ es su factor de resistencia. Cuando
$T_u\leq\phi_sR_{n,0}$, la pérdida que iguala demanda y resistencia es

$$
\delta_{d,lim}
=1-\sqrt{\frac{T_u}{\phi_sR_{n,0}}}.
$$ {#eq-calculation-aashto-seam-loss-limit}

La fila **Resistencia de costura** de la @tbl-liner-aashto-checks aplica esta
relación. La resistencia publicada corresponde a una costura doble de la
familia de perfil adoptada; la identificación de agujeros, solape, número y
diámetro de pernos permite confirmar su correspondencia con la unión existente
[@CSPIHandbookChapter6; @CIRSOC8044].
