# Antecedentes y alcance de las formulaciones de referencia

Las referencias examinadas corresponden a sistemas estructurales y secuencias
constructivas diferentes. La @tbl-methods identifica las magnitudes que aporta
cada una y su función dentro de la metodología.

| Referencia | Sistema considerado | Resultados que entrega la formulación | Función en la metodología |
|---|---|---|---|
| Baker [@Baker1968] | viga curva circular delgada con carga radial prescrita | $N_\theta$, $M_\theta$ y desplazamientos mediante series de Fourier | base mecánica del caso radial y comprobación con cargas por sectores |
| Schwartz--Einstein [@SchwartzEinstein1980] | revestimiento circular extensible en un medio elástico homogéneo | fuerza normal y momento en función de la rigidez relativa, el estado inicial y la interfaz | comparación de interacción suelo--revestimiento para carga externa y descarga por excavación |
| USACE [@USACE2020] | tubería metálica corrugada enterrada, diseño LRFD | fuerza normal circunferencial factorizada por unidad de longitud | comparación externa de la componente uniforme de fuerza normal |
| FHWA [@McGrathEtAl1999] | conductos instalados en zanja o terraplén; ensayos y análisis de interacción | carga vertical, empuje en hastiales y acción de la compactación | definición de estados de instalación y reproducción de la Ec. 5.1 |
| Núñez [@Nunez2000] | túneles excavados en suelos pampeanos | fuerzas normales y momentos en puntos característicos | comparación semiempírica con los ejemplos circulares sin presión de agua de 2000 |
| Núñez, Sfriso y Laiún [@NunezSfrisoLaiun2014] | sostenimientos temporarios de túneles excavados | fuerzas normales y momentos calculados y obtenidos numéricamente | contraste de la versión 2014 y de su dispersión respecto de análisis bidimensionales |
| CANDE [@KatonaEtAl1976CANDE; @CANDE2025Formulations] | conducto y relleno representados conjuntamente en deformación plana | desplazamientos y fuerzas internas durante etapas de construcción y servicio | referencia para análisis acoplados; una comparación cuantitativa requiere un caso común |
| NCSPA [@NCSPA2018] | perfiles de chapa corrugada | área y segundo momento de área por unidad de ancho proyectado | propiedades de la sección corrugada |
| Mai [@Mai2013] | conductos de acero corrugado deteriorados | propiedades seccionales equivalentes y resultados experimentales y numéricos | comparación de la equivalencia entre rigideces seccionales |

: Formulaciones consideradas y función asignada en el estudio. {#tbl-methods}

## Solución de Baker para cargas prescritas

Baker formula la respuesta de una viga curva circular delgada sometida a carga
radial mediante equilibrio, compatibilidad y series de Fourier
[@Baker1968, pp. 15--21]. En esa referencia la carga radial constituye un dato
del problema; por consiguiente, la caracterización geotécnica se establece por
separado.

La tesis de Baker formula exclusivamente la carga radial. La componente
tangencial $P_t(\theta)$ se obtiene por equilibrio vectorial del elemento
diferencial y se comprueba por sustitución armónica. La derivación se presenta
en la sección estructural y en el apéndice.

## Interacción según Schwartz--Einstein

Schwartz y Einstein representan la interacción entre un revestimiento circular
y un medio elástico mediante las razones adimensionales de compresibilidad y
flexibilidad [@SchwartzEinstein1980, ecs. 2.1--2.2, pp. 12--13]:

$$
C^*=\frac{E_gR(1-\nu_\ell^2)}
{E_\ell A_\ell(1-\nu_g^2)},
\qquad
F^*=\frac{E_gR^3(1-\nu_\ell^2)}
{E_\ell I_\ell(1-\nu_g^2)}.
$$ {#eq-se-stiffness}

Aquí, $E_g$ y $\nu_g$ son las propiedades elásticas del terreno;
$E_\ell$, $\nu_\ell$, $A_\ell$ e $I_\ell$ corresponden al revestimiento por
unidad de longitud axial. Para una tensión vertical inicial $P_{SE}$ y un
cociente horizontal/vertical $K_{SE}$, las soluciones adoptan la forma

$$
\frac{T_{SE}(\theta_{SE})}{P_{SE}R}=t_0+t_2\cos 2\theta_{SE},
\qquad
\frac{M_{SE}(\theta_{SE})}{P_{SE}R^2}=m_2\cos 2\theta_{SE}.
$$ {#eq-se-response}

La fuente mide $\theta_{SE}$ desde el hastial derecho en sentido antihorario y
adopta $T_{SE}>0$ a compresión
[@SchwartzEinstein1980, fig. 2.6, p. 22]. El cambio a la convención general es

$$
\theta_{SE}=\frac{\pi}{2}-\theta\pmod{2\pi},
\qquad
N_\theta=-T_{SE}.
$$ {#eq-se-coordinate-normal-conversion}

La conversión de $M_{SE}$ y de la fuerza cortante se detalla junto con los
coeficientes del apéndice. Los coeficientes $t_0$, $t_2$ y $m_2$ dependen de
$C^*$, $F^*$, $\nu_g$, $K_{SE}$, la secuencia de carga y la condición de
interfaz.

La referencia distingue carga externa —el revestimiento existe cuando se
aplica el estado tensional— y descarga por excavación —el terreno está
tensionado antes de excavar e instalar el sostenimiento—
[@SchwartzEinstein1980, sec. 2.3, pp. 18--20]. Para el conducto colocado y
rellenado se adopta la carga externa únicamente como comparación de interacción;
el medio infinito, el campo uniforme y la ausencia de tongadas no representan
la instalación real.

## Formulación circular de Núñez (2000)

Núñez (2000) desarrolla una formulación semiempírica para túneles excavados y
publica ejemplos de una sección circular sin presión de agua
[@Nunez2000, sec. "Cálculo aproximado del revestimiento", pp. 13--15 de la versión digital]. Para diámetro $D$, profundidad del eje
$H$, espesor homogéneo $e$ y presión vertical $p_0=\gamma H+q$, se definen

$$
\bar E_\ell=\frac{E_\ell}{1-\nu_\ell^2},
\qquad
\bar E_g=\frac{E_g}{1-\nu_g^2},
$$

$$
a_N=\frac{16}{\chi_N}\frac{\bar E_\ell}{\bar E_g}
\left(\frac{e}{D}\right)^3,
\qquad
A_N=\frac{a_N}{1+a_N}.
$$ {#eq-nunez-flexibility}

El factor $\chi_N$ es adimensional y modifica el módulo de reacción del terreno.
La fuente adopta $\chi_N=1$ para el sostenimiento primario y $\chi_N=2$ para el
revestimiento permanente en sus ejemplos. El parámetro $\eta_N$ representa la
relajación asociada al avance del frente.

En la especialización circular sin presión de agua de 2000,

$$
p_d=\eta_N(1-K_0)p_0,
\qquad
p_h=\frac{p_d}{1+a_N},
$$

$$
M_{\max}^{(2000)}=\frac{p_dD^2}{16}A_N,
$$

$$
N_C^{(2000)}=\frac{D}{2}\left(K_0p_d+p_h\right),
\qquad
N_A^{(2000)}=\frac{D}{2}\left(\eta_N\gamma H+q\right).
$$ {#eq-nunez-2000-resultants}

Los símbolos $C$ y $A$ designan la clave y el arranque a la cota del eje. La
fuente presenta las fuerzas normales positivas a compresión. Su conversión a
la convención general utiliza $N_\theta=-N^{(2000)}$ en el punto
correspondiente; $M_{\max}^{(2000)}$ se conserva como magnitud hasta asignar su
posición y signo.

## Formulación de Núñez, Sfriso y Laiún (2014)

El trabajo de 2014 publica otra expresión para las fuerzas normales puntuales
[@NunezSfrisoLaiun2014, ecs. 22--25, p. 6]:

$$
M_{\max}^{(2014)}=\frac{1}{16}\eta_N(1-K_0)p_0D^2A_N,
$$

$$
N_A^{(2014)}=\frac{1}{2}\eta_NDp_0,
$$

$$
N_C^{(2014)}=\frac{1}{2}\eta_NDp_0
\left[K_0+\frac{2}{3}\frac{1-K_0}{1+a_N}\right]
-\frac{1}{12}K_0\gamma D^2,
$$

$$
N_I^{(2014)}=\frac{1}{2}\eta_NDp_0
\left[K_0+\frac{4}{3}\frac{1-K_0}{1+a_N}\right]
+\frac{1}{12}K_0\gamma D^2.
$$ {#eq-nunez-2014-resultants}

Estas ecuaciones también utilizan compresión positiva. No se combinan con las
expresiones de 2000: la posición de $\eta_N$ y de la sobrecarga produce
diferencias mensurables en $N_C$ y $N_A$. La sección de comprobación cuantifica
esas diferencias. En ambas fuentes, $H$ se mide hasta el eje; para una tapada
$H_0$ medida sobre la clave, $H=H_0+D/2$.

Las dos versiones corresponden a túneles excavados. Su función es proporcionar
comparaciones separadas para ese dominio; las cargas del conducto colocado y
rellenado se determinan mediante las formulaciones geotécnicas posteriores.

## USACE, FHWA y CANDE

El manual USACE aplica la especificación AASHTO a tuberías metálicas corrugadas
y calcula una fuerza normal circunferencial factorizada
[@USACE2020, sec. 4.12]. Esa magnitud permite comparar la componente uniforme
de fuerza normal circunferencial dentro del procedimiento citado. La
distribución angular necesaria para calcular $M_\theta(\theta)$ y
$Q_\theta(\theta)$ se establece mediante los modelos de carga del capítulo
siguiente.

FHWA-RD-98-191 combina caracterización de rellenos, ensayos de instalación y
análisis bidimensionales. El material, la densidad alcanzada, el procedimiento
de compactación, el tratamiento de riñones y la geometría de la zanja modifican
la respuesta del conducto [@McGrathEtAl1999, caps. 4--5]. La acción horizontal
empleada para reproducir la compactación se transforma a cargas perimetrales en
la sección siguiente.

CANDE es un sistema especializado de análisis y diseño de conductos enterrados.
El informe original define niveles de análisis, incluidos modelos en los que
el conducto, el terreno y las etapas constructivas se representan mediante el
método de los elementos finitos
[@KatonaEtAl1976CANDE, resumen y cap. 5]. CANDE-2025 conserva formulaciones
analíticas de Nivel 1 y procedimientos bidimensionales de interacción
[@CANDE2025Formulations, secs. 1.1--1.2]. CANDE se utiliza como referencia de
análisis acoplado. Una comparación cuantitativa exige un caso común con igual
geometría, secuencia constructiva, leyes constitutivas y convenciones; ese caso
queda fuera del alcance de la formulación de cargas prescritas.
