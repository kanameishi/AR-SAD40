# Apéndice B. Contrastes numéricos {#sec-calculation-appendix-contrasts .unnumbered}

Este apéndice presenta comprobaciones de las ecuaciones y del procedimiento
numérico mediante soluciones analíticas y ejemplos publicados. Cada contraste conserva
las entradas, unidades y convenciones de su fuente. Su alcance se limita a la
relación reproducida en cada caso y no reemplaza la caracterización del relleno
del revestimiento existente.

## B.1 Baker: cargas radiales por sectores {.unnumbered}

Baker tabula resultantes adimensionales para dos sectores diametralmente
opuestos, cada uno sometido a una presión radial uniforme $p$ sobre un
semiángulo $\alpha$ [@Baker1968, tablas XIII--XIV, pp. 50--51]. Para un ancho
axial $b$, la resultante de la presión aplicada en cada sector es

$$
P=2\alpha pRb,
$$ {#eq-calculation-baker-sector-load}

y las magnitudes tabuladas se definen como

$$
\overline N=\frac{bN_\theta}{P},
\qquad
\overline M=\frac{bM_\theta}{RP}.
$$ {#eq-calculation-baker-normalization}

| Semiángulo | $\theta$ | $\overline N$ publicado | $\overline N$ calculado | $\overline M$ publicado | $\overline M$ calculado |
|---:|---:|---:|---:|---:|---:|
| 30° | 0° | -0.128 | -0.127936 | 0.190 | 0.190374 |
| 30° | 30° | -0.239 | -0.238732 | 0.080 | 0.079577 |
| 30° | 60° | -0.413 | -0.413497 | -0.095 | -0.095187 |
| 30° | 90° | -0.477 | -0.477465 | -0.159 | -0.159155 |
| 60° | 0° | -0.239 | -0.238732 | 0.080 | 0.079577 |
| 60° | 30° | -0.271 | -0.270716 | 0.048 | 0.047593 |
| 60° | 60° | -0.358 | -0.358099 | -0.040 | -0.039789 |
| 60° | 90° | -0.413 | -0.413497 | -0.095 | -0.095187 |

: Reproducción de las resultantes adimensionales tabuladas por Baker. {#tbl-calculation-baker-contrast}

Las diferencias absolutas máximas, calculadas en este estudio, son
$4.97\times10^{-4}$ para $\overline N$ y $4.23\times10^{-4}$ para
$\overline M$.

## B.2 USACE: ejemplo D4 {.unnumbered}

El ejemplo D4 considera un conducto de 36 in de diámetro, una tapada de 30 ft
y un peso unitario de 120 lb/ft³ [@USACE2020, ap. D4, pp. 332--333].

| Magnitud | Publicado | Calculado | Unidad |
|---|---:|---:|---|
| presión vertical permanente en clave | 3600 | 3600 | lb/ft² |
| fuerza normal sin factores | — | 5400 | lb/ft |
| fuerza normal factorizada | 10530 | 10530 | lb/ft |
| demanda con modificador del ejemplo | 11583 | 11583 | lb/ft |

: Reproducción del ejemplo D4 de USACE. {#tbl-calculation-usace-contrast}

El valor 5400 lb/ft resulta de aplicar $T_G=P_{FD}S/2$ y no está impreso como
resultado del ejemplo. El modificador 1.10 pertenece a D4; la ec. 4-21 de la
misma fuente indica 1.05 para tuberías metálicas corrugadas. La selección de
factores para el revestimiento requiere identificar la especificación
gobernante.

## B.3 FHWA: presión lateral equivalente de compactación {.unnumbered}

La @eq-calculation-fhwa-compaction se evaluó para los casos de la tabla 5.5 de
FHWA [@McGrathEtAl1999, pp. 177--178].

| $P$ (kN) | $\phi$ | $d_c$ (mm) | Publicado (kPa) | Calculado (kPa) |
|---:|---:|---:|---:|---:|
| 20.5 | 36° | 970 | 3.4 | 3.388 |
| 20.5 | 28° | 970 | 7.2 | 7.223 |
| 5.2 | 36° | 970 | 0.9 | 0.859 |
| 5.2 | 28° | 970 | 1.8 | 1.832 |
| 5.2 | 36° | 1575 | 0.3 | 0.254 |
| 5.2 | 28° | 1575 | 0.5 | 0.541 |
| 4.0 | 36° | 970 | 0.7 | 0.661 |
| 4.0 | 28° | 970 | 1.4 | 1.409 |
| 4.0 | 28° impreso | 1575 | 0.2 | 0.416 |

: Evaluación de la ecuación 5.1 frente a la tabla 5.5 de FHWA. {#tbl-calculation-fhwa-contrast}

Las primeras ocho filas reproducen los valores publicados al redondear a
0.1 kPa. En la última fila, los datos impresos producen 0.416 kPa; si se emplea
$\phi=36^\circ$, el resultado es 0.195 kPa y redondea a 0.2 kPa. La
discrepancia se conserva y no se utiliza para modificar la ecuación ni para
ajustar parámetros.

## B.4 Schwartz--Einstein: caso HP97 {.unnumbered}

Schwartz y Einstein expresan la respuesta de un revestimiento circular en un
medio elástico mediante razones de rigidez y coeficientes para la secuencia de
carga y la condición de interfaz [@SchwartzEinstein1980]. En la convención de
la fuente, $P_{SE}$ es la tensión vertical inicial, $K_{SE}$ es la relación
entre las tensiones horizontal y vertical iniciales, $T_{SE}$ es la fuerza
normal positiva a compresión y $M_{SE}$ es el momento flector. Las razones
$C^*$ y $F^*$ representan, respectivamente, la compresibilidad y la
flexibilidad relativas entre terreno y revestimiento. El caso HP97 adopta

$$
C^*=0.05,\qquad F^*=100,\qquad \nu_g=0.4,
\qquad K_{SE}=0.5,\qquad \theta_{SE}=30^\circ,
$$

donde $\nu_g$ es el coeficiente de Poisson del terreno y $\theta_{SE}$ se mide
desde el hastial derecho en sentido antihorario
[@SchwartzEinstein1980, ejemplo HP97, pp. 391--392].

| Secuencia | Interfaz | $T_{SE}/(P_{SE}R)$ publicado | Calculado | $M_{SE}/(P_{SE}R^2)$ publicado | Calculado |
|---|---|---:|---:|---:|---:|
| descarga por excavación | deslizamiento completo | 0.736 | 0.735909 | 0.00774 | 0.007743 |
| descarga por excavación | sin deslizamiento | 0.812 | 0.811806 | 0.00707 | 0.007066 |
| carga externa | deslizamiento completo | 0.887 | 0.887061 | 0.0133 | 0.013274 |
| carga externa | sin deslizamiento | 1.020 | 1.017169 | 0.0121 | 0.012113 |

: Reproducción del caso HP97 de Schwartz--Einstein. {#tbl-calculation-se-contrast}

Las cuatro combinaciones de fuerza normal y momento se reproducen. HP97 no
tabula fuerza cortante; cualquier valor obtenido por
$Q=(1/R)dM/d\theta$ es un resultado derivado, no un dato publicado. La
formulación representa interacción en un túnel excavado y se conserva como
contrapartida analítica, no como generador directo de la acción del relleno
compactado.

## B.5 Núñez (2000): ejemplos circulares {.unnumbered}

Los ejemplos de Núñez corresponden a túneles excavados y adoptan
$D=10$ m, profundidad del eje $H=15$ m,
$\gamma=1.9\ \mathrm{tf/m^3}$, $q=1\ \mathrm{tf/m^2}$ y $K_0=0.5$
[@Nunez2000, pp. 13--15]. Para cada revestimiento, $a_N$ es la razón de
interacción informada por la fuente y $A_N=a_N/(1+a_N)$. El cálculo utiliza
$a_N=0.02700$ y $\eta_N=0.5$ para el revestimiento primario, y
$a_N=0.10976$ y $\eta_N=1.0$ para el permanente. Con
$p_0=\gamma H+q$ se evalúan

$$
p_d=\eta_N(1-K_0)p_0,
\qquad
p_h=\frac{p_d}{1+a_N},
\qquad
M_{\max}=\frac{p_dD^2}{16}A_N,
$$

$$
N_C=\frac{D}{2}(K_0p_d+p_h),
\qquad
N_A=\frac{D}{2}(\eta_N\gamma H+q).
$$

$N_C$ y $N_A$ son las fuerzas normales en clave y hastial, respectivamente,
y la fuente adopta compresión positiva. La fila $a_N$ verifica el valor de
entrada; $A_N$, $M_{\max}$, $N_C$ y $N_A$ son resultados recalculados. La
unidad original se conserva; para una conversión posterior se adopta
$1\ \mathrm{tf}=9.80665$ kN.

| Revestimiento | Magnitud | Publicado | Calculado | Unidad |
|---|---|---:|---:|---|
| primario | $a_N$ | 0.027 | 0.02700 | — |
| primario | $A_N$ | 0.0263 | 0.02629 | — |
| primario | $M_{max}$ | 1.21 | 1.2118 | tf·m/m |
| primario | $N_C$ | 54.5 | 54.34 | tf/m |
| permanente | $a_N$ | 0.11 | 0.10976 | — |
| permanente | $A_N$ | 0.10 | 0.09890 | — |
| permanente | $M_{max}$ | 9.0 | 9.1177 | tf·m/m |
| permanente | $N_C$ | 103.4 | 103.33 | tf/m |
| permanente | $N_A$ | 147.5 | 147.50 | tf/m |

: Reproducción de los ejemplos circulares de Núñez (2000). {#tbl-calculation-nunez-contrast}

La diferencia relativa máxima es 1.31 % respecto de los valores redondeados.
La coincidencia confirma la evaluación aritmética de las expresiones de 2000;
el parámetro de relajación de excavación y la interacción con un macizo natural
no deben trasladarse sin reformulación al revestimiento instalado y rellenado.

## B.6 Integración directa y soluciones cerradas {.unnumbered}

Para el estado biaxial uniforme de la aplicación, los extremos
$\alpha_\delta=0$ y $\alpha_\delta=1$ admiten soluciones cerradas. La
@tbl-calculation-controls compara esas soluciones con la integración directa
empleada para las distribuciones generales de carga.

{{< include /_tbl/Calculation.controls.ES.qmd >}}

Las seis diferencias son inferiores a la tolerancia de $10^{-7}$ adoptada
para cada resultante. Esta comprobación cubre la discretización angular, la
integración y la recuperación de $N_\theta$, $M_\theta$ y $Q_\theta$ en los dos
extremos de transferencia tangencial.

## B.7 Alcance conjunto de los contrastes {.unnumbered}

Los casos de Baker comprueban equilibrio, compatibilidad y evaluación de cargas
radiales por sectores. USACE y FHWA comprueban relaciones de carga dentro de su
dominio. Schwartz--Einstein y Núñez documentan la respuesta de formulaciones de
interacción correspondientes a túneles excavados y fijan referencias numéricas
para sus propias convenciones. La comparación directa con soluciones cerradas
comprueba el procedimiento numérico empleado en la aplicación de esta memoria.

CANDE constituye una referencia del estado de la práctica para el análisis
acoplado de conductos enterrados [@KatonaEtAl1976CANDE;
@CANDE2025Formulations]. La evidencia reunida no contiene un caso común con
entradas y convenciones completas que permita incorporarlo como contraste
cuantitativo de esta aplicación.
