# Apéndice B. Controles y datos requeridos {#sec-methodology-shotcrete-controls .unnumbered}

## B.1 Control de hormigón simple {.unnumbered}

Para una franja rectangular destinada exclusivamente a comprobar ecuaciones y
unidades:

$$
b=1000\ \mathrm{mm},\qquad h=100\ \mathrm{mm},\qquad
f'_c=25\ \mathrm{MPa},\qquad \lambda_{\mathrm{lw}}=1,
\qquad \ell_c=0.
$$

Las ecuaciones @eq-shotcrete-plain-bending, @eq-shotcrete-plain-axial y
@eq-shotcrete-plain-shear producen:

| Magnitud | Resultado |
|---|---:|
| $A_g$ | $100\,000\ \mathrm{mm^2}$ |
| $S_m$ | $1\,666\,666.667\ \mathrm{mm^3}$ |
| $M_{n,t}$ | $3.500\ \mathrm{kN\,m}$ |
| $M_{n,c}$ | $35.4167\ \mathrm{kN\,m}$ |
| $P_n$ | $1500.0\ \mathrm{kN}$ |
| $V_n$ | $55.0\ \mathrm{kN}$ |
| $\phi M_n$ | $2.100\ \mathrm{kN\,m}$ |
| $\phi P_n$ | $900.0\ \mathrm{kN}$ |
| $\phi V_n$ | $33.0\ \mathrm{kN}$ |

Este control reproduce las expresiones de los artículos 14.5.2.1, 14.5.3.1 y
14.5.5.1 de CIRSOC 201-25. No establece que $\ell_c=0$, la franja unitaria o
la clasificación como hormigón simple sean aplicables a la obra.

## B.2 Control de hormigón armado {.unnumbered}

Para

$$
b=1000\ \mathrm{mm},\qquad h=200\ \mathrm{mm},\qquad
f'_c=30\ \mathrm{MPa},\qquad A_{st}=2000\ \mathrm{mm^2},
\qquad f_y=420\ \mathrm{MPa},
$$

las ecuaciones @eq-shotcrete-beta-one y @eq-shotcrete-pure-compression dan

$$
\beta_1=0.8357142857,
\qquad
P_o=5889.0\ \mathrm{kN}.
$$

El control no asigna $P_{n,\max}$ ni $\phi$, porque ambos dependen de la
clasificación y del detalle de la armadura transversal. Tampoco demuestra el
cumplimiento de las cuantías mínimas de una sección armada.

## B.3 Deformación neta de tracción y factor de reducción {.unnumbered}

Para $f_y=420$ MPa y $E_s=200\,000$ MPa:

$$
\varepsilon_{ty}=0.0021.
$$

Con la convención de @eq-shotcrete-steel-law, una deformación firmada
$\varepsilon_{s,t}=-0.0051$ produce
$\varepsilon_t=0.0051=\varepsilon_{ty}+0.003$ y, por lo tanto,
$\phi=0.90$. Para $\varepsilon_{s,t}=-0.0036$ se obtiene
$\varepsilon_t=0.0036$ y $\phi=0.775$. El control impide alimentar la Tabla
21.2.2 con una deformación de tracción negativa.

## B.4 Límite global de corte {.unnumbered}

Para un control aritmético de una sección cuya clasificación y armadura
transversal se suponen previamente resueltas:

$$
f'_c=25\ \mathrm{MPa},\quad b_w=1000\ \mathrm{mm},\quad
d=150\ \mathrm{mm},\quad A_g=200\,000\ \mathrm{mm^2},
$$

$$
P_u=0,\quad A_s=1000\ \mathrm{mm^2},\quad
A_v=1000\ \mathrm{mm^2},\quad f_{yt}=420\ \mathrm{MPa},\quad
s=100\ \mathrm{mm}.
$$

Se adopta $A_v\ge A_{v,\min}$ y la segunda expresión de
@eq-shotcrete-shear-at-minimum. Los resultados son:

| Magnitud | Resultado |
|---|---:|
| $\rho_w$ | $0.0066666667$ |
| $V_c$ | $93.162567\ \mathrm{kN}$ |
| $V_s$ | $630.000000\ \mathrm{kN}$ |
| $V_c+V_s$ | $723.162567\ \mathrm{kN}$ |
| $V_c+0.66\sqrt{f'_c}b_wd$ | $588.162567\ \mathrm{kN}$ |
| $\phi(V_c+V_s)$ | $542.371925\ \mathrm{kN}$ |
| $V_d$ gobernante | $441.121925\ \mathrm{kN}$ |

El límite del artículo 22.5.1.2 gobierna este control. El caso verifica que la
resistencia de cálculo no aumente sin cota al incrementar $A_v/s$; no demuestra
que esa disposición de armadura sea reglamentaria para el revestimiento.

## B.5 Controles del dominio $P$--$M$ {.unnumbered}

Antes de aplicar el procedimiento a una sección real se comprueban:

- equilibrio de fuerzas y momentos para cada posición del eje neutro;
- simetría del dominio respecto de $M=0$ cuando la geometría y las armaduras
  sean simétricas;
- convergencia respecto de la discretización seccional;
- reproducción de la compresión pura de
  @eq-shotcrete-pure-compression; y
- correspondencia de signos y unidades mediante estados elementales de carga.

El control de signos debe confirmar, en particular, que una compresión
circunferencial $N_\theta<0$ produce $P_u>0$ y que un momento
$M_\theta>0$ comprime la cara exterior.

La tolerancia numérica se fija antes de la aplicación y se informa con los
resultados. Una coincidencia matemática con otra implementación no sustituye
la comprobación de aplicabilidad reglamentaria.

## B.6 Datos necesarios para la aplicación {.unnumbered}

| Grupo | Datos requeridos |
|---|---|
| Base normativa | jurisdicción, adhesión, contrato, edición, artículos aplicables de CIRSOC 201-25 y función de CIRSOC 804-4 |
| Sistema resistente | revestimiento autónomo o acción conjunta; secuencia y transferencia de cargas |
| Acciones | combinaciones de resistencia y servicio; convención de signos; $N_\theta$, $M_\theta$ y $Q_\theta$ obtenidos con la rigidez del sistema analizado |
| Geometría | ancho de franja, espesor geométrico y resistente, defectos, juntas, $b_w$, $d$ y $\ell_c$ cuando corresponda |
| Hormigón | vía húmeda o seca, $f'_{c,\mathrm{eq}}$, población y localización de testigos, estadística aprobada, densidad y exposición |
| Armaduras | clasificación reglamentaria, capas, coordenadas, áreas netas, recubrimientos, diámetros, separaciones, $f_y$, $E_s$, $A_v$ y $f_{yt}$ |
| Fibras | tipo, dosificación, orientación, ensayo, resistencias residuales y formulación normativa, si se pretende considerar su contribución |
| Servicio | fisuración admisible, estanqueidad, deformaciones, contracción, temperatura, fluencia lenta y durabilidad |

Mientras esos datos no estén establecidos, la formulación constituye una base
de cálculo y no una comprobación resistente del revestimiento existente. En
particular, no corresponde publicar capacidad, utilización ni reserva del caso
con valores nominales supuestos.
