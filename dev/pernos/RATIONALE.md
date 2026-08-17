# Fundamento de la geometría observada y de la resistencia de referencia de la costura

## Objeto

Este registro documenta la interpretación utilizada para incorporar una
comprobación preliminar de la costura longitudinal del revestimiento circular.
Se distinguen tres niveles de evidencia: la geometría visible en las
fotografías, los datos informados por el usuario y las resistencias publicadas
para configuraciones de referencia. La comparación no constituye la
certificación de la unión existente.

## Evidencia disponible

- `pernos.jpeg` y `pernos2.jpeg` muestran dos filas paralelas de fijaciones en
  la unión de las chapas. La corrosión y la perspectiva impiden medir con
  precisión los diámetros de agujero, las distancias a borde y el solape.
- El usuario identificó las fijaciones como pernos de 1/2 in de acero ASTM
  A325. Esta identificación se adopta como dato informado; las marcas de los
  pernos y los certificados del material no se verificaron en las imágenes.
- `liner.png` indica un diámetro de 2600 mm. El modelo de cálculo conserva el
  diámetro centroidal de 2630 mm declarado en `calculation.json`; la
  conciliación entre ambas cotas se mantiene como una cuestión geométrica
  separada de la costura.
- El perfil adoptado para la chapa es CSPI 76 x 25, fila de espesor nominal
  2,8 mm y espesor base de cálculo 2,64 mm.

## Interpretación geométrica

Las marcas rojas permiten seguir una fijación por cada onda en las dos filas
axiales. Por ello se adopta provisionalmente un paso axial de 76,2 mm. En la
segunda fotografía se distinguen aproximadamente nueve a diez fijaciones por
fila; la distancia entre los centros extremos resulta entonces comprendida
entre 609,6 y 685,8 mm. La estimación es compatible con un módulo de chapa del
orden de 0,76 m, pero no determina por sí sola el ancho nominal del panel.

La fila que sigue la circunferencia resulta compatible, después de considerar
el acortamiento por perspectiva, con un módulo de aproximadamente 152,4 mm.
Los cruces visibles entre esa fila y las dos filas axiales están separados por
aproximadamente dos módulos, es decir, 304,8 mm. Estas magnitudes se registran
como interpretación fotográfica preliminar; no se emplean para calcular una
resistencia racional de los pernos.

## Resistencia de referencia

La comprobación reproducida del artículo 12.7 exige que la resistencia
factorizada de la costura sea al menos igual a la fuerza circunferencial de
diseño:

$$
\phi_s R_n \geq T_u.
$$

Se encontraron dos valores publicados comparables:

- CSPI, *Handbook of Steel Drainage & Highway Construction Products*, cap. 6,
  tabla 6.4a, página impresa 207/PDF 5: perfil 76 x 25 mm, espesor nominal
  2,8 mm, remaches de 12 mm y costura doble, $R_n=769$ kN/m.
- CIRSOC 804-4, apéndice A12, tabla A12-7, página impresa 97/PDF 115:
  perfil 76,2 x 25,4 mm, espesor 2,77 mm, remaches dobles de 7/16 in y
  $R_n=773,48$ kN/m. El apéndice reproduce la base histórica de AASHTO 2012.

Se adopta $R_n=769$ kN/m, el menor de ambos valores y el que corresponde a la
fila publicada de espesor nominal 2,8 mm. El valor se identifica en la
configuración como una resistencia de una costura doble remachada de
referencia. No se atribuye directamente a los pernos A325 observados.

Para el escenario `deterministic-cover-h8`, con $T_u=409,2543$ kN/m y
$\phi_s=0,67$, se obtiene

$$
\phi_s R_n=515,23\ \mathrm{kN/m},
\qquad
U_s=\frac{T_u}{\phi_sR_n}=0,7943.
$$

La comparación numérica satisface el límite de la configuración de
referencia. El estado normativo del sistema permanece condicionado porque no
se demostró que la unión abulonada existente sea equivalente a la costura
doble remachada tabulada y porque la edición y las erratas vigentes de AASHTO
no se verificaron con el articulado completo.

## Pérdida paramétrica de diámetro

Se define $d_0=12,7$ mm como diámetro nominal informado del perno y
$\Delta d$ como la pérdida total de diámetro. La variable que posteriormente
podrá ingresar a la simulación de Monte Carlo es la razón adimensional

$$
\delta_d=\frac{\Delta d}{d_0},
\qquad 0\leq\delta_d<1.
$$

El diámetro remanente y la relación de áreas son

$$
d_r=d_0(1-\delta_d),
\qquad
\rho_d=\left(\frac{d_r}{d_0}\right)^2
=(1-\delta_d)^2.
$$

Como modelo de sensibilidad se adopta

$$
R_{n,c}=R_{n,0}\rho_d,
\qquad
U_s(\delta_d)
=\frac{T_u}{\phi_sR_{n,0}(1-\delta_d)^2}.
$$

La relación supone que la resistencia de referencia disminuye en proporción
al área transversal remanente de los pernos. Es una hipótesis derivada para
estudiar sensibilidad y no una regla tabulada por AASHTO. No representa la
pérdida de espesor de la chapa, que conserva su propia variable, ni cubre los
modos de aplastamiento, desgarro, sección neta o falla del solape.

El escenario determinístico mantiene $\delta_d=0$. Para las demás entradas
vigentes, el límite analítico $U_s=1$ se alcanza en
$\delta_{d,lim}=1-\sqrt{0,7943}\simeq0,109$. La futura etapa probabilística
podrá evaluar valores entre 0 y el límite superior que se adopte, sin asignar
por ahora una distribución a $\delta_d$.

## Datos requeridos para verificar la unión existente

Una comprobación específica de los pernos y de la chapa neta requiere, como
mínimo, diámetro de agujero, distancias longitudinales y transversales entre
centros, distancias a borde, longitud de solape, cantidad efectiva de filas,
espesor remanente en la zona de unión, identificación verificable de los
pernos y posición de las roscas respecto de los planos de corte. Hasta contar
con esos datos, la resistencia de 769 kN/m se utiliza sólo como contraste
publicado de referencia.
