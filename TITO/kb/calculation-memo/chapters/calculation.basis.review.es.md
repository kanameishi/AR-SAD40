# Introducción {#sec-calculation-introduction}

## Objeto y alcance {#sec-calculation-scope}

Esta memoria calcula las resultantes de un revestimiento circular sometido al
estado de tensiones del relleno. La fuerza normal circunferencial
$N_\theta(\theta)$, el momento flector $M_\theta(\theta)$ y el corte
$Q_\theta(\theta)$ se expresan por unidad de ancho axial proyectado. El
escenario determinístico queda definido por la altura de relleno sobre la
clave, las propiedades efectivas del suelo, la sobrecarga y la presión de agua
neta.

La demanda estructural combina la solución de carga externa de
Schwartz--Einstein para el campo uniforme del eje con una corrección
equilibrada por la variación geostática entre clave y solera. Para cada
revestimiento, Schwartz--Einstein utiliza el radio y las rigideces propias del
anillo; por lo tanto, un liner más rígido y uno más flexible no reciben
artificialmente las mismas resultantes. Se calculan los límites de interfaz
con deslizamiento libre y sin deslizamiento, porque la condición real de
contacto no está caracterizada.

La integración directa de las ecuaciones de equilibrio de la viga circular,
su solución cerrada para el estado biaxial y su representación de Fourier
controlan tanto la carga uniforme prescrita como la corrección de gradiente.
Comprueban equilibrio, compatibilidad y signos; no sustituyen los coeficientes
de interacción $C^*$ y $F^*$ de Schwartz--Einstein.

El procedimiento se aplica al liner existente de chapa corrugada y a secciones
de hormigón proyectado de 100 y 150 mm. La sección de 100 mm se comprueba
además como hormigón simple. Para ambos espesores de hormigón se presentan
dominios $P$--$M$ correspondientes a distintas cuantías circunferenciales. No
se adopta una armadura ni un detalle de barras.

La chapa se contrasta también con las comprobaciones escalares de
AASHTO/USACE para pared, pandeo, costura, flexibilidad y tapada. Ese cálculo y
las resultantes angulares de Schwartz--Einstein responden a formulaciones
distintas y se informan por separado [@USACE2020; @AndersonEtAl2023].

## Datos comunes e hipótesis {#sec-calculation-basis}

La @tbl-calculation-inputs reúne las entradas geotécnicas y geométricas del
escenario. Son hipótesis de cálculo y no se presentan como resultados de una
caracterización del relleno existente.

{{< include /_tbl/Calculation.inputs.ES.qmd >}}

El caso vigente usa $\phi'=30^\circ$, $\mathrm{OCR}=1$ y ausencia de presión
hidráulica neta. Con la formulación de $K_0$ seleccionada, esos valores
producen $K_0=0{,}5$. El valor no está fijado de manera independiente: se
recalcula a partir de $\phi'$ y OCR. Estas entradas deben reemplazarse cuando
se disponga de la caracterización geotécnica.

El modelo supone un medio elástico homogéneo alrededor del anillo. La
interacción por rigidez se calcula para el campo libre evaluado a la
profundidad del eje y la variación lineal sobre la altura se incorpora con una
reacción radial de equilibrio, sin asignar un resorte físico. No se representan
explícitamente la superficie libre, las tongadas, la secuencia de compactación
ni el arqueo tridimensional de una zanja. Esos efectos no se introducen
mediante factores implícitos.
