# Comprobación de la chapa corrugada según la base AASHTO adoptada

## Alcance y condición normativa

La evaluación recibe un empuje circunferencial mayorado $T_u$, las propiedades
por unidad de ancho de la corrugación y los datos resistentes de la pared y de
la costura. El cálculo reproduce las comprobaciones identificadas para
conductos circulares corrugados de AASHTO LRFD, sección 12.7, a partir de las
relaciones publicadas por USACE y de las referencias complementarias
documentadas [@USACE2020; @AndersonEtAl2023].

El procedimiento mantiene tres puertas independientes: edición y erratas,
clasificación del producto y correspondencia de cada ecuación con la rama
aplicable. El índice oficial de la décima edición permite localizar la sección
12, pero no contiene el articulado necesario para cerrar esas puertas
[@AASHTO2024TOC]. Mientras alguna permanezca abierta, la aritmética puede
calificarse como satisfecha o no satisfecha, pero el estado normativo se
informa como no evaluado.

## Demanda circunferencial

La presión vertical de diseño en la clave y la luz $S$ producen el empuje
mayorado por unidad de longitud de pared. Para las componentes permanente y
móvil, USACE reproduce la relación

$$
T_u=\gamma_{DL}\frac{P_{FD}S}{2}
   +\gamma_{LL}\frac{P_{FL}C_LF_1}{2}.
$$ {#eq-methodology-aashto-thrust}

El empuje es una demanda escalar de pared. No sustituye la distribución
perimetral de Schwartz--Einstein empleada para calcular $M_\theta$ y
$Q_\theta$, ni convierte los
extremos de resultantes correspondientes a ángulos distintos en una acción
concurrente.

## Pared y pandeo

Con área de pared $A$, resistencia de fluencia $F_y$ y factor resistente
$\phi_w$, la resistencia disponible por fluencia es

$$
R_y=\phi_w A F_y.
$$ {#eq-methodology-aashto-wall-yield}

La rama de pandeo utiliza el radio de giro $r=\sqrt{I/A}$, la luz, el módulo
elástico, la resistencia última y el factor de rigidez del suelo de la base de
referencia. La tensión crítica se evalúa con la rama elástica o inelástica que
corresponde y la resistencia disponible es

$$
R_b=\phi_w A F_{cr}.
$$ {#eq-methodology-aashto-wall-buckling}

Las dos comprobaciones se mantienen separadas:

$$
U_y=\frac{T_u}{R_y},
\qquad
U_b=\frac{T_u}{R_b},
\qquad U\leq1.
$$ {#eq-methodology-aashto-wall-utilization}

## Costura, flexibilidad y tapada mínima

La costura utiliza una resistencia nominal publicada $R_{n,0}$ y un factor
$\phi_s$. Cuando se representa una pérdida relativa $\delta_d$ del diámetro de
los elementos de unión, la reducción geométrica adoptada es

$$
R_s(\delta_d)=\phi_sR_{n,0}(1-\delta_d)^2,
\qquad
U_s(\delta_d)=\frac{T_u}{R_s(\delta_d)},
\qquad 0\leq\delta_d<1.
$$ {#eq-methodology-aashto-seam}

Esta relación permite estudiar sensibilidad; no demuestra que una costura
publicada sea equivalente a la unión existente. La comprobación requiere
confirmar geometría, material, disposición, estado y modo resistente de los
elementos reales.

El factor de flexibilidad se calcula como

$$
FF=\frac{S^2}{EI},
\qquad
U_F=\frac{FF}{FF_{lim}}.
$$ {#eq-methodology-aashto-flexibility}

La condición de tapada mínima se expresa mediante

$$
H_{min}=\max\left(\frac{S}{8},0.3048\ \mathrm{m}\right),
\qquad
U_H=\frac{H_{min}}{H_0}.
$$ {#eq-methodology-aashto-cover}

La pared, el pandeo, la costura, la flexibilidad y la tapada mínima conservan
su propia procedencia, unidad, utilización y estado. El resultado general sólo
puede ser normativamente satisfactorio cuando todas las entradas están
completas y las tres puertas de aplicabilidad están verificadas. Estas
comprobaciones no sustituyen el análisis de juntas, pernos, servicio ni
estabilidad global del revestimiento.
