# Recuperación de la tensión normal circunferencial {#sec-calculation-sheet-stress}

## Sección resistente actual

La recuperación de tensiones requiere las propiedades de la sección neta
actual por unidad de longitud proyectada sobre el eje: el área
$\bar A_n$, el momento de inercia $\bar I_n$ y las coordenadas de las fibras
extremas respecto del centroide neto. En la convención de esta memoria,
$\xi$ es positiva hacia el interior; por tanto, $\xi_i>0$ corresponde a la
fibra interior y $\xi_o<0$ a la fibra exterior.

Las propiedades netas deben derivarse del espesor metálico medido, de los
estados de lectura y de una regla espacial documentada. Una perforación, una
superficie que no admite medición y una zona inaccesible son condiciones
diferentes y se registran por separado [@Mai2013, pp. 44--53]. Las propiedades
nominales de un perfil normalizado son adecuadas para comprobar geometría y
unidades, pero no sustituyen la caracterización de la sección deteriorada
[@NCSPA2018, tabla 2.6].

La misma sección neta debe utilizarse para determinar $EA_\theta$,
$EI_\theta$ y la recuperación de tensiones. De este modo, la rigidez que
produce $N_\theta$ y $M_\theta$ es coherente con la sección sobre la que se
evalúa la demanda.

La formulación de resultantes empleada en esta memoria supone propiedades
seccionales circunferenciales uniformes. Si se adopta una sección neta uniforme,
las resultantes deben recalcularse con sus valores netos antes de recuperar las
tensiones. Si $\bar A_n$ o $\bar I_n$ varían de manera relevante con
$\theta$, no corresponde aplicar la relación siguiente a resultantes obtenidas
con una rigidez nominal uniforme: debe resolverse el equilibrio y la
compatibilidad con rigideces variables, o justificarse previamente una sección
equivalente aplicable.

## Fórmula operativa

Con $N_\theta>0$ a tracción y $M_\theta>0$ produciendo tracción en la fibra
interior, la tensión normal circunferencial es

$$
\sigma_\theta(\theta,\xi)
=\frac{N_\theta(\theta)}{\bar A_n}
+1000\frac{M_\theta(\theta)\,\xi}{\bar I_n}.
$$ {#eq-calculation-sheet-normal-stress}

La expresión entrega $\sigma_\theta$ en MPa para $N_\theta$ en kN/m,
$M_\theta$ en kN·m/m, $\bar A_n$ en mm²/mm, $\bar I_n$ en mm⁴/mm y $\xi$ en
mm. Se evalúa en $\xi_i$ y $\xi_o$ para cada posición angular y cada estado de
carga. Los extremos conservan el valor con signo, la fibra, el ángulo y el
estado que los produce.

## Condiciones de aplicación

La distribución lineal anterior requiere que la relación entre la dimensión
radial de la corrugación y el radio de curvatura sea compatible con la
idealización de sección recta. En miembros curvos, el eje neutro y la
distribución de tensiones por flexión no coinciden en general con los de una
viga recta [@USBR1968Beggs, p. 6]. La tensión se evalúa sólo después de
adoptar un criterio aplicable o de cuantificar la diferencia mediante una
formulación de viga curva.

$Q_\theta$ se conserva como resultante seccional. Su transformación en una
tensión local exige un flujo cortante o un área efectiva compatibles con la
geometría corrugada; no se aplica una expresión de sección rectangular. Si la
inspección identifica perforaciones o ligamentos aislados, la tensión normal
homogeneizada constituye un diagnóstico global y debe complementarse con una
evaluación de continuidad y estabilidad local [@Mai2013, pp. 86--90].

## Estado de la aplicación

El escenario de comprobación utiliza propiedades nominales para verificar el
cálculo de las resultantes. Esas propiedades no representan la sección neta
actual del revestimiento. En consecuencia, la presente aplicación no informa
valores de $\sigma_\theta$.

Para completar esta operación se requieren $\bar A_n$, $\bar I_n$,
$\xi_i$, $\xi_o$ y el criterio de aplicabilidad frente a la curvatura. La
comprobación resistente posterior requiere además identificar el producto, la
norma y edición aplicables, las propiedades del acero, las combinaciones de
acciones y los estados límite obligatorios. No se informa una utilización ni
un factor de seguridad mientras esos antecedentes permanezcan sin definir. La
regla espacial adoptada para la corrosión debe establecer, además, si las
rigideces pueden representarse como uniformes o si se requiere una solución
con propiedades variables alrededor de la sección.
