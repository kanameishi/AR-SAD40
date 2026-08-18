Este apéndice complementa las acciones definidas en
@sec-calculation-model y las comprobaciones del liner de chapa de
@sec-calculation-steel. Desarrolla la distribución vertical, la presión de
agua, el empuje circunferencial de referencia y las relaciones de $K_0$
aplicables a distintas trayectorias tensionales.

La distribución vertical comienza con la profundidad de cada punto del
contorno:

$$
z(\theta)=H_0+R(1-\cos\theta).
$$ {#eq-calculation-depth}

Con $\theta=0$ en la clave, las profundidades de la clave, del centro y del
fondo son, respectivamente,

$$
z_C=H_0,
\qquad
z_A=H_0+R,
\qquad
z_F=H_0+2R.
$$ {#eq-calculation-control-depths}

La presión de agua exterior y la acción hidráulica neta son

$$
u_{ext}(z)=\gamma_w\max(0,z-z_w),
\qquad
\Delta u(z)=u_{ext}(z)-u_{int}(z).
$$ {#eq-calculation-water-pressure}

$z_w$ es la profundidad del nivel freático, $\gamma_w$ es el peso unitario
del agua y $u_{int}$ es la presión sobre la cara interior del revestimiento.
Por convención, $\Delta u>0$ representa una presión neta dirigida hacia el
interior. $K_0$ se aplica a las tensiones efectivas; la presión intersticial se
incorpora después como acción hidráulica neta.

La comparación del empuje circunferencial utiliza, para un relleno homogéneo
sin sobrecarga, la presión vertical de carga permanente del ejemplo D4 de
USACE:

$$
P_{FD}=\gamma H_0,
$$ {#eq-calculation-prism-pressure}

donde $\gamma$ es el peso unitario adoptado para la carga permanente y $H_0$
la altura de relleno sobre la clave [@USACE2020, ap. D4, pp. 332--333]. Para conductos
metálicos corrugados, USACE reproduce la relación

$$
T_L=\gamma_{DL}\frac{P_{FD}S}{2}
+\gamma_{LL}\frac{P_{FL}C_LF_1}{2},
$$ {#eq-calculation-prism-thrust}

en la que $T_L$ es el empuje circunferencial mayorado por unidad de longitud
de pared; $S$ es la luz; $P_{FL}$ es la presión vertical de carga móvil en la
clave; $C_L$ es el ancho cargado; y $F_1$ es su factor de distribución
[@USACE2020, sec. 4.12.3.1.1, ec. 4-20]. USACE atribuye la relación a AASHTO;
su aplicación reglamentaria requiere comprobar el artículo, los factores y la
clasificación del producto en la edición adoptada.

El modificador de demanda se aplica como

$$
T_u=\eta T_L.
$$ {#eq-calculation-aashto-design-thrust}

Para la pared corrugada, las resistencias correspondientes a fluencia y
pandeo son

$$
R_y=\phi_w A F_y,
\qquad
R_b=\phi_w A f_{cr},
\qquad
r=\sqrt{\frac{I}{A}},
$$ {#eq-calculation-aashto-wall-resistance}

donde $A$, $I$ y $r$ son, respectivamente, el área, el momento de inercia y
el radio de giro de la pared por unidad de ancho; $F_y$ es la resistencia de
fluencia y $\phi_w$ el factor de resistencia. La tensión crítica se evalúa con
las dos ramas reproducidas para conductos corrugados:

$$
f_{cr}=
\begin{cases}
F_u-\dfrac{F_u^2}{48E}
\left(\dfrac{kS}{r}\right)^2,
&
S\leq\dfrac{r}{k}\sqrt{\dfrac{24E}{F_u}},\\[8pt]
\dfrac{12E}{(kS/r)^2},
&
S>\dfrac{r}{k}\sqrt{\dfrac{24E}{F_u}}.
\end{cases}
$$ {#eq-calculation-aashto-buckling}

$F_u$ es la resistencia a tracción, $E$ el módulo del acero y $k$ el factor
de rigidez del suelo. En estas expresiones de pandeo, $S$ y $r$ se expresan en
una misma unidad.

Para incorporar de manera paramétrica la pérdida de sección de los pernos, se
define

$$
\delta_d=\frac{\Delta d}{d_0},
\qquad
d_r=d_0-\Delta d=d_0(1-\delta_d),
$$ {#eq-calculation-aashto-seam-diameter}

donde $d_0$ y $d_r$ son los diámetros nominal y remanente. Si la
reducción de resistencia se representa mediante la relación entre las áreas
del perno remanente y nominal,

$$
\rho_d
=\frac{\pi d_r^2/4}{\pi d_0^2/4}
=(1-\delta_d)^2.
$$ {#eq-calculation-aashto-seam-area-ratio}

La resistencia nominal reducida y la resistencia factorizada de referencia
son entonces

$$
R_{n,c}=\rho_d R_{n,0},
\qquad
R_s=\phi_sR_{n,c}
=\phi_sR_{n,0}(1-\delta_d)^2.
$$ {#eq-calculation-aashto-seam}

$R_{n,0}$ es la resistencia publicada de la costura sin pérdida de diámetro.
Esta relación de sensibilidad supone que la resistencia de la costura varía en
proporción al área remanente de los pernos. La inspección y la evaluación de la
unión deben considerar además los agujeros, el aplastamiento, el desgarro, la
sección neta y el solape de la chapa. Para $T_u\leq\phi_sR_{n,0}$, la igualdad
entre demanda y resistencia se alcanza cuando

$$
\delta_{d,lim}
=1-\sqrt{\frac{T_u}{\phi_sR_{n,0}}}.
$$ {#eq-calculation-aashto-seam-loss-limit}

La flexibilidad durante manipulación e instalación y la condición geométrica
de tapada mínima se expresan mediante

$$
FF=\frac{S^2}{EI},
\qquad
H_{min}=\max\left(\frac{S}{8},\ 0.3048\ \mathrm{m}\right).
$$ {#eq-calculation-aashto-service-limits}

Para el valor de $FF$ informado, $S$ se expresa en mm, $E$ en MPa e $I$ en
mm$^4$/mm, por lo que el resultado se obtiene en mm/N. Las expresiones de pared
y flexibilidad reproducen las ecuaciones 4-22 y 4-23 de USACE. La rama de
pandeo, el factor $k=0.22$ y el factor de resistencia de la costura se
contrastan con la reproducción de AASHTO LRFD 9.ª edición de Anderson et al.,
p. 164; la condición de tapada mínima corresponde a su tabla
7.1, p. 133
[@USACE2020, secs. 4.12.3.2--4.12.5;
@AndersonEtAl2023, pp. 133, 164]. Estas fuentes reproducen disposiciones de
ediciones anteriores; la emisión del proyecto requiere adoptar los factores y
artículos de la edición contractual.

La relación determina un empuje circunferencial escalar para la rama
AASHTO/USACE. La distribución angular de fuerza, momento y corte utilizada en
las comprobaciones se obtiene por separado con Schwartz--Einstein; la
integración numérica directa controla únicamente la respuesta a la carga
perimetral prescrita.
FHWA adopta un factor vertical de arqueo igual a 1,0 para la teoría de
compresión anular de tubos flexibles; los factores SIDD publicados corresponden
a instalaciones de tubos rígidos
[@McGrathEtAl1999, ecs. 2.1--2.3 y p. 14].

La formulación de $K_0$ debe representar la trayectoria tensional del estado
analizado. Una medición directa es aplicable cuando reproduce el material, la
profundidad y el intervalo de tensiones considerados. En ausencia de una
medición representativa, pueden evaluarse las relaciones siguientes.

Para una idealización elástica lineal e isótropa con deformación lateral
impedida [@ChristopherEtAl2006, sec. 5.4.9],

$$
K_0=\frac{\nu_g}{1-\nu_g}.
$$ {#eq-calculation-k0-elastic}

Para carga primaria o condición normalmente consolidada se utiliza la
relación abreviada de Jáky [@MayneKulhawy1982, pp. 852--853]:

$$
K_{0,NC}=1-\sin\phi'.
$$ {#eq-calculation-k0-jaky}

La relación se aplica en tensiones efectivas a suelos no cohesivos y a suelos
cohesivos normalmente consolidados en condiciones drenadas. El estado en
reposo se evalúa sin un término en $c'$; las relaciones que contienen
$\pm2c'\sqrt K$ corresponden a los estados límite activo o pasivo.

Para una descarga demostrada desde la compresión virgen, Mayne y Kulhawy
proponen
[@MayneKulhawy1982, ecs. 6--10]

$$
K_{0,OC}=(1-\sin\phi')\,\mathrm{OCR}^{\sin\phi'},
\qquad
\mathrm{OCR}=\frac{\sigma'_{v,\max}}{\sigma'_v}.
$$ {#eq-calculation-k0-unloading}

La tensión $\sigma'_{v,\max}$ debe corresponder a una máxima histórica
identificable y $\mathrm{OCR}\geq1$. Los ajustes reunidos por los autores para
la descarga se obtuvieron generalmente con $\mathrm{OCR}<15$. Para una
trayectoria de descarga y recarga se define

$$
\mathrm{OCR}_{\max}
=\frac{\sigma'_{v,\max}}{\sigma'_{v,\min}},
$$

y se emplea [@MayneKulhawy1982, ecs. 14--18]

$$
K_0=(1-\sin\phi')\left[
\frac{\mathrm{OCR}}
{\mathrm{OCR}_{\max}^{\,1-\sin\phi'}}
+\frac{3}{4}\left(
1-\frac{\mathrm{OCR}}{\mathrm{OCR}_{\max}}
\right)
\right].
$$ {#eq-calculation-k0-reloading}

Esta expresión recupera la relación de descarga cuando
$\mathrm{OCR}=\mathrm{OCR}_{\max}$ y la condición normalmente consolidada
cuando $\mathrm{OCR}=\mathrm{OCR}_{\max}=1$. Su dominio requiere
$1\leq\mathrm{OCR}\leq\mathrm{OCR}_{\max}$ y
$\mathrm{OCR}_{\max}\geq1$. Para $0<\phi'<90^\circ$, la relación queda fuera de
su dominio cuando alcanza el límite pasivo adoptado por los autores:

$$
K_p=\frac{1+\sin\phi'}{1-\sin\phi'},
\qquad
\mathrm{OCR}_{\lim}
=\left[
\frac{1+\sin\phi'}{(1-\sin\phi')^2}
\right]^{1/\sin\phi'}.
$$ {#eq-calculation-k0-passive-limit}

La descarga requiere $\mathrm{OCR}<\mathrm{OCR}_{\lim}$ y la recarga requiere
$\mathrm{OCR}_{\max}<\mathrm{OCR}_{\lim}$. El escenario de esta memoria, con
$\mathrm{OCR}=1$, utiliza la relación de Jáky para suelo normalmente
consolidado.
