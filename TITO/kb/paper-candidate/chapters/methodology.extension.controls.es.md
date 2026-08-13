# Apéndice A. Controles y casos de referencia {#sec-methodology-extension-controls .unnumbered}

## A.1 Clasificación de los controles {.unnumbered}

Los controles de esta ampliación se clasifican como resultados publicados,
resultados publicados reproducidos o comprobaciones matemáticas internas. La
concordancia entre formulaciones y programas comprueba ecuaciones, signos,
unidades y transferencias de datos; no constituye una validación física del
estado del relleno ni de la resistencia del revestimiento.

## A.2 Estado biaxial uniforme {.unnumbered}

La solución cerrada del estado biaxial uniforme se contrastó con la integración
directa de las ecuaciones de equilibrio y con una descomposición analítica en
los modos $n=0$ y $n=2$. La malla común contiene 728 posiciones angulares e
incluye los puntos críticos de los armónicos.

La máxima diferencia absoluta entre la solución cerrada y la integración
directa fue $1.48\times10^{-6}$ en las unidades de cada resultante, frente a
un límite propio de $10^{-4}$. El residuo adimensional máximo de equilibrio de
la integración fue $1.32\times10^{-13}$, frente a $10^{-9}$, y la diferencia
modal máxima fue $1.78\times10^{-15}$, frente a $10^{-7}$.

Una implementación independiente reprodujo las acciones con una diferencia
máxima de $9.95\times10^{-14}$ kPa y las curvas completas de resultantes con
$2.41\times10^{-12}$ en sus unidades respectivas, frente al límite
$10^{-7}$. Para los 18 extremos de $N_\theta$, $M_\theta$ y $Q_\theta$, las
diferencias máximas del valor y del valor con signo fueron
$1.34\times10^{-12}$.

Los extremos repetidos por simetría forman un conjunto de posiciones
equivalentes. Cada cálculo conserva una regla determinística para seleccionar
un representante, pero la comparación acepta cualquier posición del mismo
conjunto siempre que el valor con signo coincida.

## A.3 Límite de presión uniforme {.unnumbered}

En el límite puramente membranal $\eta_s=0$, una presión radial uniforme $p$
hacia el interior produce

$$
N_\theta=-pR,
\qquad
M_\theta=0,
\qquad
Q_\theta=0.
$$

La integración directa con $p=12.3$ kPa produjo un residuo máximo de
$5.39\times10^{-8}$ frente al límite $10^{-4}$. Este control no impone
$M_\theta=0$ cuando la compatibilidad incorpora $\eta_s>0$; en ese caso
permanece el acoplamiento del modo uniforme.

## A.4 Recuperación elástica de la tensión normal {.unnumbered}

Para una sección recta sintética con
$\bar A_n=4$ mm²/mm, $\bar I_n=300$ mm⁴/mm,
$y_o=12.5$ mm, $y_i=-12.5$ mm,
$N_\theta=-60$ kN/m y $M_\theta=0.02$ kN·m/m, la
@eq-methodology-sheet-normal-stress produce

$$
\sigma_{\theta,N}=-15.000\ \mathrm{MPa},
$$

$$
\sigma_{\theta,o}=-15.8333\ \mathrm{MPa},
\qquad
\sigma_{\theta,i}=-14.1667\ \mathrm{MPa}.
$$

El control comprueba la respuesta axial, la flexión pura, el cambio de signo de
$M_\theta$, la escala inversa de la tensión ante una reducción uniforme de
$\bar A_n$ y $\bar I_n$, y la independencia respecto de $Q_\theta$. Se trata
de una comprobación matemática interna; no representa una sección del
revestimiento existente.

## A.5 Contrastes seccionales de Mai {.unnumbered}

Mai publicó dos grupos de datos aptos para contrastar propiedades de sección:

1. la corrugación $152\times51$ mm de la tabla 2.1, que permite comprobar la
   conservación independiente de $EA$ y $EI$ para cuatro niveles de espesor;
   y
2. la corrugación $68\times13$ mm de la tabla E.1, con seis pares de
   $A$, $I$ y módulo elástico de sección para espesores entre 1.12 y 4.08 mm
   [@Mai2013, tabla 2.1 y tabla E.1].

Las rectas publicadas en el apéndice E son ajustes sobre varios puntos y no
reproducen exactamente cada fila. La propiedad extrapolada a 4.50 mm se
conserva como un resultado derivado por la tesis, no como una fila tabulada del
manual de origen.

Los casos de carga viva, los análisis CANDE y el ensayo último CSP1 se reservan
como antecedentes sobre las limitaciones del modelo lineal. No forman parte de
la comprobación del cálculo geostático ni de la memoria profesional.

## A.6 Alcance de la evidencia numérica {.unnumbered}

Los controles anteriores sostienen la correspondencia de las ecuaciones y la
implementación para los dominios declarados. La aplicación al revestimiento
existente requiere todavía el estado de tensiones del relleno, la sección neta,
el criterio de curvatura y la base resistente. Ninguna tolerancia numérica
resuelve esos datos físicos o normativos.
