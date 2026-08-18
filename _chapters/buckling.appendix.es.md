La pared corrugada se comprueba frente a fluencia y pandeo con la misma
demanda $T_u$ definida en @sec-calculation-appendix-thrust. Para el área $A$,
el momento de inercia $I$ y el radio de giro $r=\sqrt{I/A}$ por unidad de
ancho, la esbeltez de pandeo es

$$
\lambda_b=k_s\frac{S}{r},
\qquad
S_{tr}=\frac{r}{k_s}\sqrt{\frac{24E}{F_u}},
$$ {#eq-calculation-aashto-buckling-slenderness}

donde $S$ y $r$ se expresan en una misma unidad, $k_s$ es el factor de rigidez
del suelo, $E$ es el módulo del acero y $F_u$ es su resistencia a tracción. La
tensión crítica se evalúa con

$$
F_{cr}=
\begin{cases}
F_u-\dfrac{F_u^2}{48E}\lambda_b^2, & S\leq S_{tr},\\[6pt]
\dfrac{12E}{\lambda_b^2}, & S>S_{tr}.
\end{cases}
$$ {#eq-calculation-aashto-buckling-stress}

Las resistencias disponibles de la pared son

$$
R_y=\phi_wAF_y,
\qquad
R_b=\phi_wAF_{cr},
$$ {#eq-calculation-aashto-wall-resistance}

donde $F_y$ es la resistencia de fluencia y $\phi_w$ es el factor de
resistencia. Estas expresiones alimentan las filas **Fluencia de pared** y
**Pandeo de pared** de la @tbl-liner-aashto-checks
[@USACE2020, secs. 4.12.3.2--4.12.3.3; @AndersonEtAl2023, p. 164].
