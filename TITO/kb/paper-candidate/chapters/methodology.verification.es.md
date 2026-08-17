# Contraste numérico con resultados publicados

Los casos siguientes contrastan la formulación analítica y los resultados
numéricos con soluciones publicadas. Su alcance es matemático. La calibración del estado de cargas del
revestimiento existente requiere ensayos o mediciones representativos de su
geometría, relleno y secuencia constructiva.

## Carga radial uniforme por sectores

Baker estudia dos cargas radiales diametralmente opuestas y uniformes dentro
de sectores de semiángulo $30^\circ$ y $60^\circ$. Para una resultante $P$ por
sector y un ancho axial $b$, las tablas XIII y XIV presentan
[@Baker1968, tablas XIII--XIV, pp. 50--51]

$$
\overline N=\frac{bN_\theta}{P},
\qquad
\overline M=\frac{bM_\theta}{RP}.
$$ {#eq-baker-normalization}

La integración directa de la carga radial reproduce los ocho pares de valores
tabulados. Las diferencias absolutas máximas son

$$
\max\lvert\Delta\overline N\rvert
=4.97\times10^{-4},
\qquad
\max\lvert\Delta\overline M\rvert
=4.23\times10^{-4}.
$$ {#eq-baker-errors}

| Semiángulo | $\theta$ | $\overline N$ publicado | $\overline N$ calculado | $\overline M$ publicado | $\overline M$ calculado |
|---:|---:|---:|---:|---:|---:|
| $30^\circ$ | $0^\circ$ | $-0.128$ | $-0.127936$ | $0.190$ | $0.190374$ |
| $30^\circ$ | $30^\circ$ | $-0.239$ | $-0.238732$ | $0.080$ | $0.079577$ |
| $30^\circ$ | $60^\circ$ | $-0.413$ | $-0.413497$ | $-0.095$ | $-0.095187$ |
| $30^\circ$ | $90^\circ$ | $-0.477$ | $-0.477465$ | $-0.159$ | $-0.159155$ |
| $60^\circ$ | $0^\circ$ | $-0.239$ | $-0.238732$ | $0.080$ | $0.079577$ |
| $60^\circ$ | $30^\circ$ | $-0.271$ | $-0.270716$ | $0.048$ | $0.047593$ |
| $60^\circ$ | $60^\circ$ | $-0.358$ | $-0.358099$ | $-0.040$ | $-0.039789$ |
| $60^\circ$ | $90^\circ$ | $-0.413$ | $-0.413497$ | $-0.095$ | $-0.095187$ |

: Reproducción de las tablas XIII y XIV de Baker [@Baker1968, pp. 50--51]. {#tbl-baker-check}

Las diferencias máximas son inferiores a $5\times10^{-4}$, equivalente a
media unidad de la última cifra publicada. El contraste corresponde a una
carga radial discontinua. La extensión a componentes tangenciales se comprueba
separadamente mediante la @eq-modal-algebra.

## Relación de fuerza normal de USACE

El ejemplo D4 de USACE considera un conducto de $36\ \mathrm{in}$ de diámetro,
una tapada de $30\ \mathrm{ft}$ y un relleno con peso unitario de
$120\ \mathrm{lb/ft^3}$ [@USACE2020, ap. D4, pp. 332--333]. La
@tbl-usace-check conserva las unidades de la fuente.

| Magnitud | Valor publicado | Valor calculado | Unidad |
|---|---:|---:|---|
| presión vertical permanente en clave | $3600$ | $3600$ | lb/ft² |
| fuerza normal sin factores | --- | $5400$ | lb/ft |
| fuerza normal factorizada | $10530$ | $10530$ | lb/ft |
| demanda con el modificador del apéndice D4 | $11583$ | $11583$ | lb/ft |

: Reproducción del ejemplo D4 de USACE [@USACE2020, pp. 332--333]. {#tbl-usace-check}

La fuerza de $5400\ \mathrm{lb/ft}$ se obtiene de la Ec. 4-20 antes de aplicar
los factores utilizados en el ejemplo. La Ec. 4-21 define el modificador
combinado de carga $\eta_{cmp}=\eta_D\eta_R\eta_I$ por ductilidad, redundancia e
importancia operacional y adopta $1.05$ para tuberías metálicas corrugadas;
D4 emplea $1.10$. El valor $1.10$ se utiliza exclusivamente para reproducir D4.
El modificador aplicable al revestimiento analizado es un dato de diseño que
deberá establecer la norma gobernante.

## Presión de compactación en los hastiales

La @eq-fhwa-compaction se evaluó para las nueve combinaciones de equipo,
material y diámetro de la tabla 5.5 de FHWA-RD-98-191
[@McGrathEtAl1999, ec. 5.1 y tabla 5.5, pp. 176--178]. En ocho filas, el valor
calculado coincide con el tabulado al redondear a $0.1\ \mathrm{kPa}$. En la
última fila, la tabla imprime $\phi'=28^\circ$ para piedra y un diámetro
nominal de $1500\ \mathrm{mm}$. La figura 5.4 asocia ese diámetro nominal con
$d_c=1575\ \mathrm{mm}$. Esos datos producen $0.42\ \mathrm{kPa}$, mientras
que el valor tabulado es $0.2\ \mathrm{kPa}$. El ángulo
$\phi'=36^\circ$, utilizado para la piedra en las demás filas, produce
$0.195\ \mathrm{kPa}$ y redondea a $0.2\ \mathrm{kPa}$. La fila se conserva
como discrepancia de la fuente y se excluye de cualquier calibración.

La figura 5.4 de la misma referencia define la dirección horizontal de las
fuerzas nodales aplicadas en ambos hastiales
[@McGrathEtAl1999, fig. 5.4, pp. 175--176]. Las @eq-fhwa-band y
@eq-fhwa-perimeter-load trasladan esa acción a una franja de altura definida y
a las componentes locales $P_r$ y $P_t$.

## Ejemplo HP97 de Schwartz--Einstein

El ejemplo HP97 utiliza $C^*=0.05$, $F^*=100$, $\nu_g=0.4$,
$K_{SE}=0.5$ y $\theta_{SE}=30^\circ$. La fuente informa
$T_{SE}/(P_{SE}R)$ y $M_{SE}/(P_{SE}R^2)$ para dos secuencias de carga y dos
condiciones de interfaz [@SchwartzEinstein1980, ejemplo HP97, pp. 391--392].
La @tbl-se-check conserva la convención de la fuente: $T_{SE}>0$ a compresión.
La transformación a la convención general se realiza mediante la
@eq-se-coordinate-normal-conversion y las relaciones del apéndice.

| Secuencia | Interfaz | $T_{SE}/(P_{SE}R)$ publicado | Calculado | $M_{SE}/(P_{SE}R^2)$ publicado | Calculado |
|---|---|---:|---:|---:|---:|
| descarga por excavación | deslizamiento completo (*full slip*) | $0.736$ | $0.735909$ | $0.00774$ | $0.007743$ |
| descarga por excavación | sin deslizamiento (*no slip*) | $0.812$ | $0.811806$ | $0.00707$ | $0.007066$ |
| carga externa | deslizamiento completo (*full slip*) | $0.887$ | $0.887061$ | $0.0133$ | $0.013274$ |
| carga externa | sin deslizamiento (*no slip*) | $1.02$ | $1.017169$ | $0.0121$ | $0.012113$ |

: Reproducción del ejemplo HP97 en la convención de Schwartz--Einstein [@SchwartzEinstein1980, pp. 391--392]. {#tbl-se-check}

La referencia no tabula la fuerza cortante. Su valor puede deducirse de la
derivada del momento, pero no se utiliza como dato publicado de contraste.

## Formulaciones de Núñez

### Ejemplos circulares de 2000

El ejemplo de Núñez de 2000 adopta $D=10\ \mathrm{m}$, profundidad del eje
$H=15\ \mathrm{m}$, $\gamma=1.9\ \mathrm{tf/m^3}$,
$q=1\ \mathrm{tf/m^2}$ y $K_0=0.5$. La @tbl-nunez-check se calculó
exclusivamente con la @eq-nunez-2000-resultants
[@Nunez2000, sec. "Cálculo aproximado del revestimiento", pp. 13--15 de la versión digital]. Las fuerzas publicadas son compresiones
positivas; su conversión a la convención general requiere $N_\theta=-N^{(2000)}$.

| Revestimiento | Magnitud | Valor publicado | Valor calculado | Unidad |
|---|---|---:|---:|---|
| primario | $a_N$ | $0.027$ | $0.0270$ | --- |
| primario | $A_N$ | $0.0263$ | $0.02629$ | --- |
| primario | $M_{\max}$ | $1.21$ | $1.2118$ | tf·m/m |
| primario | $N_C$ | $54.5$ | $54.34$ | tf/m |
| permanente | $a_N$ | $0.11$ | $0.10976$ | --- |
| permanente | $A_N$ | $0.10$ | $0.09890$ | --- |
| permanente | $M_{\max}$ | $9.0$ | $9.1177$ | tf·m/m |
| permanente | $N_C$ | $103.4$ | $103.33$ | tf/m |
| permanente | $N_A$ | $147.5$ | $147.50$ | tf/m |

: Reproducción de los ejemplos circulares de Núñez de 2000 [@Nunez2000, sec. "Cálculo aproximado del revestimiento", pp. 13--15 de la versión digital]. {#tbl-nunez-check}

La mayor diferencia relativa es $1.31\,\%$ y corresponde al momento del
revestimiento permanente, publicado con dos cifras significativas. Para la
conversión de las unidades originales se adopta
$1\ \mathrm{tf}=9.80665\ \mathrm{kN}$.

### Diferencia respecto de la formulación de 2014

Las ecuaciones publicadas en 2014 no son intercambiables con las de 2000. La
@tbl-nunez-version-check muestra las diferencias obtenidas al utilizar los
mismos datos de los ejemplos precedentes en la @eq-nunez-2000-resultants y en
la @eq-nunez-2014-resultants.

| Revestimiento | Magnitud | Versión 2000 | Versión 2014 | Unidad |
|---|---|---:|---:|---|
| primario | $M_{\max}$ | $1.212$ | $1.212$ | tf·m/m |
| primario | $N_C$ | $54.343$ | $52.895$ | tf/m |
| primario | $N_A$ | $76.250$ | $73.750$ | tf/m |
| permanente | $M_{\max}$ | $9.118$ | $9.118$ | tf·m/m |
| permanente | $N_C$ | $103.331$ | $110.137$ | tf/m |
| permanente | $N_A$ | $147.500$ | $147.500$ | tf/m |

: Evaluación separada de las formulaciones de Núñez de 2000 y 2014. {#tbl-nunez-version-check}

La coincidencia de $M_{\max}$ no implica equivalencia entre ambas versiones:
las expresiones de fuerza normal y sus parámetros difieren. Por esta razón,
cada contraste conserva íntegramente la versión bibliográfica correspondiente.

Núñez, Sfriso y Laiún publican siete comparaciones entre su formulación de 2014
y análisis bidimensionales para túneles de Buenos Aires. La @tbl-nunez-2014-case3
reproduce tres resultantes del caso 3
[@NunezSfrisoLaiun2014, tabla 3, p. 7].

| Resultante | Formulación de 2014 | Análisis bidimensional | Unidad |
|---|---:|---:|---|
| $N_C$ | $720$ | $500$ | kN/m |
| $M_C$ | $10.2$ | $10.0$ | kN·m/m |
| $M_A$ | $13.8$ | $65.0$ | kN·m/m |

: Resultados publicados para el caso 3 de Núñez, Sfriso y Laiún [@NunezSfrisoLaiun2014, tabla 3, p. 7]. {#tbl-nunez-2014-case3}

La publicación señala una dispersión
mayor en los momentos que en las fuerzas normales. Como no proporciona todos
los parámetros necesarios para reproducir los siete casos y varias secciones no
son circulares, esos valores se presentan como antecedentes publicados y no
como una reproducción independiente.

## Alcance de los contrastes

| Referencia | Magnitud contrastada | Resultado |
|---|---|---|
| Baker | $N_\theta$ y $M_\theta$ ante cargas radiales por sectores | diferencias menores que $5\times10^{-4}$ en las magnitudes adimensionales tabuladas |
| USACE, ejemplo D4 | presión vertical y fuerza normal circunferencial | valores publicados reproducidos con los factores del ejemplo |
| FHWA-RD-98-191 | presión horizontal de compactación | ocho filas reproducidas; una inconsistencia de datos identificada |
| Schwartz--Einstein, HP97 | fuerza normal y momento para cuatro combinaciones | valores publicados reproducidos en la convención de la fuente |
| Núñez 2000 | parámetros, fuerza normal y momento | diferencia relativa máxima de $1.31\,\%$ respecto de valores redondeados |
| Núñez et al. 2014 | comparación publicada con análisis bidimensionales | tres resultantes publicadas para el caso 3; la información disponible no permite reproducir independientemente los siete casos |

: Contenido y alcance de los contrastes numéricos. {#tbl-verification-summary}
