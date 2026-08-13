# Apéndice A. Controles y casos de referencia {#sec-methodology-extension-controls .unnumbered}

## A.1 Clasificación de los controles {.unnumbered}

Los controles de esta ampliación se clasifican como resultados publicados,
resultados publicados reproducidos o comprobaciones matemáticas internas. La
concordancia entre formulaciones y programas comprueba ecuaciones, signos,
unidades y transferencias de datos; no constituye una validación física del
estado del relleno ni de la resistencia del revestimiento.

## A.2 Empuje circunferencial de referencia {.unnumbered}

La relación de empuje reproducida por USACE,
$T_L=P_FS/2$, tiene dimensiones de presión por longitud y, por lo tanto,
entrega fuerza por unidad de longitud de pared [@USACE2020, ec. 4-20]. Su
implementación se comprueba con entradas sintéticas independientes del caso
existente. El producto conserva únicamente $P_F$, $S$ y $T_L$; la sección
resistente que se comprueba se selecciona en la evaluación estructural. La
correspondencia de esta relación con la rama aplicable de AASHTO LRFD, 10.ª
edición, permanece pendiente de comprobar.

Para el revestimiento existente, el control permanece sin evaluar porque la
clasificación del producto, $P_F$ y $S$ no están confirmadas. La tensión
vertical efectiva en el eje y el diámetro interior del escenario biaxial no se
utilizan como sustitutos de esas entradas.

## A.3 Estado biaxial uniforme {.unnumbered}

La solución cerrada del estado biaxial uniforme se contrastó con la integración
directa de las ecuaciones de equilibrio y con una descomposición analítica en
los modos $n=0$ y $n=2$. La tabla siguiente identifica el caso empleado. Las
propiedades seccionales corresponden exclusivamente a este control numérico y
no representan la sección corroída del revestimiento existente.

| Magnitud | Valor adoptado |
|---|---:|
| escenario | `verification-biaxial-uniform` |
| diámetro interior | 2.63 m |
| radio de análisis | 1.315 m |
| corrugación nominal | $76\times25$ mm |
| espesor base de interpolación | 3.00 mm |
| $\bar A$ | 3.7304718 mm²/mm |
| $\bar I$ | 287.902154 mm⁴/mm |
| $E_\theta$ | 200 GPa |
| $EA_\theta$ | 746094.359 kN/m |
| $EI_\theta$ | 57.580431 kN·m²/m |
| $\eta_s=\bar I/(\bar A R^2)$ | $4.46303\times10^{-5}$ |
| $\sigma'_v$ | 100 kPa |
| $K_0$ adoptado | 0.50 |
| $\sigma'_h$ | 50 kPa |
| incremento horizontal residual de compactación | no determinado; no incluido en este escenario |
| $\Delta u$ | 0 kPa |
| casos tangenciales | $\alpha=1$ y $\alpha=0$ |
| posiciones angulares | 728 |
| pasos de integración | 8192 |
| tolerancia de equilibrio | $10^{-9}$ |
| tolerancia de solución cerrada | $10^{-7}$ |

La integración de producción se comparó por resultante; cada diferencia y su
tolerancia conservan la unidad de la magnitud examinada.

| Caso | Resultante | Diferencia absoluta máxima | Tolerancia | Unidad | Resultado |
|---|---|---:|---:|---|---|
| $\alpha=1$ | $N_\theta$ | $7.96\times10^{-13}$ | $10^{-7}$ | kN/m | satisface |
| $\alpha=1$ | $M_\theta$ | $1.28\times10^{-12}$ | $10^{-7}$ | kN·m/m | satisface |
| $\alpha=1$ | $Q_\theta$ | $1.08\times10^{-12}$ | $10^{-7}$ | kN/m | satisface |
| $\alpha=0$ | $N_\theta$ | $1.26\times10^{-12}$ | $10^{-7}$ | kN/m | satisface |
| $\alpha=0$ | $M_\theta$ | $2.39\times10^{-12}$ | $10^{-7}$ | kN·m/m | satisface |
| $\alpha=0$ | $Q_\theta$ | $1.54\times10^{-12}$ | $10^{-7}$ | kN/m | satisface |

Una implementación independiente evaluada con Wolfram 15.0.1 efectuó controles
adicionales. Cuando el registro de ejecución conservó una cota común para
varias filas, la tabla la informa por separado para cada familia dimensional;
no se calcula un máximo entre fuerza y momento.

| Comparación | Observable | Diferencia o cota verificada | Tolerancia | Unidad | Resultado |
|---|---|---:|---:|---|---|
| integración independiente -- solución cerrada | $N_\theta$ | $\leq1.48\times10^{-6}$ | $10^{-4}$ | kN/m | satisface |
| integración independiente -- solución cerrada | $M_\theta$ | $\leq1.48\times10^{-6}$ | $10^{-4}$ | kN·m/m | satisface |
| integración independiente -- solución cerrada | $Q_\theta$ | $\leq1.48\times10^{-6}$ | $10^{-4}$ | kN/m | satisface |
| equilibrio de la integración | residuo normalizado | $1.32\times10^{-13}$ | $10^{-9}$ | adimensional | satisface |
| Fourier -- solución cerrada | $N_\theta$ | $\leq1.78\times10^{-15}$ | $10^{-7}$ | kN/m | satisface |
| Fourier -- solución cerrada | $M_\theta$ | $\leq1.78\times10^{-15}$ | $10^{-7}$ | kN·m/m | satisface |
| Fourier -- solución cerrada | $Q_\theta$ | $\leq1.78\times10^{-15}$ | $10^{-7}$ | kN/m | satisface |
| acciones independientes -- producción | $P_r$, $P_t$ | $9.95\times10^{-14}$ | $10^{-10}$ | kPa | satisface |
| solución cerrada independiente -- producción | $N_\theta$, $Q_\theta$ | $\leq2.41\times10^{-12}$ | $10^{-7}$ | kN/m | satisface |
| solución cerrada independiente -- producción | $M_\theta$ | $\leq2.41\times10^{-12}$ | $10^{-7}$ | kN·m/m | satisface |
| extremos independientes -- producción | $N_\theta$, $Q_\theta$ | $\leq1.34\times10^{-12}$ | $10^{-7}$ | kN/m | satisface |
| extremos independientes -- producción | $M_\theta$ | $\leq1.34\times10^{-12}$ | $10^{-7}$ | kN·m/m | satisface |

Los extremos repetidos por simetría forman un conjunto de posiciones
equivalentes. Cada cálculo conserva una regla determinística para seleccionar
un representante, pero la comparación acepta cualquier posición del mismo
conjunto siempre que el valor con signo coincida.

## A.4 Límite de presión uniforme {.unnumbered}

En el límite puramente membranal $\eta_s=0$, una presión radial uniforme $p$
hacia el interior produce

$$
N_\theta=-pR,
\qquad
M_\theta=0,
\qquad
Q_\theta=0.
$$

La integración directa con $p=12.3$ kPa produjo los residuos siguientes:

| Resultante | Residuo absoluto máximo | Tolerancia | Unidad | Resultado |
|---|---:|---:|---|---|
| $N_\theta$ | $4.10\times10^{-8}$ | $10^{-4}$ | kN/m | satisface |
| $M_\theta$ | $5.39\times10^{-8}$ | $10^{-4}$ | kN·m/m | satisface |
| $Q_\theta$ | $4.09\times10^{-8}$ | $10^{-4}$ | kN/m | satisface |

Este control no impone $M_\theta=0$ cuando la compatibilidad incorpora
$\eta_s>0$; en ese caso permanece el acoplamiento del modo uniforme.

## A.5 Recuperación elástica de la tensión normal {.unnumbered}

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

## A.6 Contrastes seccionales de Mai {.unnumbered}

Mai publicó, para una corrugación $152\times51$ mm y $E=200$ GPa, los cuatro
estados de sección corrugada de la tabla 2.1. El espesor nominal era 3 mm y el
espesor real intacto informado era 2.841 mm [@Mai2013, tabla 2.1, p. 32; PDF
p. 41].

| Espesor remanente | Espesor real (mm) | $EI$ (N·m²/m) | $EA$ (N/m) | Clase de evidencia |
|---:|---:|---:|---:|---|
| 100 % | 2.841 | $211.4\times10^3$ | $704.4\times10^6$ | dato publicado |
| 42 % | 1.19 | $88.80\times10^3$ | $296\times10^6$ | dato publicado |
| 12.5 % | 0.355 | $26.43\times10^3$ | $88.05\times10^6$ | dato publicado |
| 1.5 % | 0.0426 | $3.180\times10^3$ | $10.56\times10^6$ | dato publicado |

La tabla E.1 de la misma tesis transcribe propiedades de una corrugación
$68\times13$ mm para seis espesores [@Mai2013, tabla E.1, PDF p. 225].

| $t$ (mm) | $A$ (mm²/mm) | $I$ (mm⁴/mm) | $S$ (mm³/mm) | Clase de evidencia |
|---:|---:|---:|---:|---|
| 1.12 | 1.209 | 22.61 | 3.27 | dato publicado |
| 1.40 | 1.512 | 28.37 | 4.02 | dato publicado |
| 1.82 | 1.966 | 37.11 | 5.11 | dato publicado |
| 2.64 | 2.852 | 54.57 | 7.11 | dato publicado |
| 3.35 | 3.621 | 70.16 | 8.74 | dato publicado |
| 4.08 | 4.411 | 86.71 | 10.33 | dato publicado |

Mai presenta como interpolaciones lineales los ajustes

$$
A=1.0817t-0.0026,
\qquad
I=21.619t-2.0007,
\qquad
S=2.3871t+0.6971.
$$

Esas rectas son resultados derivados por la tesis sobre varios puntos y no
reproducen exactamente cada fila tabulada. La extrapolación informada para
$t=4.50$ mm produce $A=4.870$ mm²/mm, $I=95.28$ mm⁴/mm y
$S=11.44$ mm³/mm. Se conserva como resultado derivado fuera del intervalo de
la tabla E.1, no como una fila publicada por el manual de origen.

Los casos de carga viva, los análisis CANDE y el ensayo último CSP1 se reservan
como antecedentes sobre las limitaciones del modelo lineal. No forman parte de
la comprobación del cálculo geostático ni de la memoria profesional.

## A.7 Alcance de la evidencia numérica {.unnumbered}

Los controles anteriores sostienen la correspondencia de las ecuaciones y la
implementación para los dominios declarados. La aplicación al revestimiento
existente requiere todavía el estado de tensiones del relleno, la sección neta,
el criterio de curvatura y la base resistente. Ninguna tolerancia numérica
resuelve esos datos físicos o normativos.
