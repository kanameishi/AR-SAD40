# Estimación del coeficiente de empuje en reposo

## Estado lateral efectivo del relleno

El coeficiente de empuje en reposo caracteriza el estado efectivo inicial del relleno. Interviene como dato geotécnico en modelos que representen la interacción suelo--conducto y, separadamente, en el estado biaxial analítico de control desarrollado en esta metodología. No reemplaza la presión vertical mayorada en la clave utilizada para obtener el empuje circunferencial reglamentario, ni determina por sí solo la presión de contacto sobre un conducto flexible.

El capítulo caracteriza las formulaciones aplicables según la trayectoria tensional, identifica sus variables primitivas y establece la separación entre
$K_0$ y una eventual tensión horizontal residual inducida por la compactación.

## Definición del estado lateral

En condiciones de deformación lateral nula, el coeficiente de empuje en reposo se define mediante tensiones efectivas:

$$
K_0 (z)=\frac{\sigma'_h (z)}{\sigma'_v (z)}.
$$

La tensión horizontal total es

$$
\sigma_h (z)=\sigma'_h (z)+u (z)
=K_0 (z)\,\sigma'_v (z)+u (z),
$$

donde $u$ es la presión intersticial. Esta separación evita aplicar $K_0$ a una tensión vertical total y contabilizar el agua dos veces
[@ChristopherEtAl2006, sec. 5.4.9].

La salida de este módulo geotécnico es $\sigma'_h (z)$. Su transferencia al cálculo estructural requiere una formulación de interacción o un estado de carga analítico explícitamente prescrito. Para organizar el procedimiento, una rama geotécnica $m$ se expresa como

$$
K_0^{ (m)} (z)=f_m\!\left[\mathbf x_m (z)\right], \qquad \sigma_h'^{ (m)} (z)=K_0^{ (m)} (z)\,\sigma'_v (z),
$$

y $\mathbf x_m$ contiene únicamente las variables primitivas requeridas por esa formulación.

## Carga primaria

Para carga primaria, la expresión de uso habitual es

$$
K_{0,NC}=1-\sin\phi',
$$

donde $\phi'$ es el ángulo de fricción interna efectiva correspondiente al material y al intervalo tensional considerado. Mayne y Kulhawy confrontaron esta relación con una base de datos de suelos cohesivos y no cohesivos y la adoptaron como representación de la rama normalmente consolidada
[@MayneKulhawy1982, pp. 852--853]. FHWA la presenta para suelos no cohesivos y suelos cohesivos normalmente consolidados
[@ChristopherEtAl2006, ec. 5.38].

La relación es una correlación para una trayectoria de carga primaria. Las trayectorias de descarga y recarga, así como una eventual tensión horizontal retenida durante la construcción, requieren formulaciones independientes.

La relación se emplea con parámetros efectivos para suelos no cohesivos y para suelos cohesivos normalmente consolidados en condiciones drenadas. No se le agrega un término genérico en $c'$: las expresiones que contienen
$\pm2c'\sqrt K$ corresponden a estados límite activo o pasivo, no al estado en reposo. Un análisis no drenado en tensiones totales constituye otra rama constitutiva y no se habilita sin datos y evidencia propios.

Michalowski transcribe la forma obtenida por Jáky en 1944:

$$
K_{0,\mathrm{J\acute{a}ky\,1944}} = (1-\sin\phi')
\frac{1+\frac{2}{3}\sin\phi'}{1+\sin\phi'}.
$$

Jáky eliminó posteriormente el factor fraccionario y produjo la forma abreviada. Michalowski observa que la derivación de 1944 utiliza el campo tensional de un prisma de arena y que ese campo no representa una trayectoria general de deformación unidimensional [@Michalowski2005, ec. 8]. Por ello, la forma abreviada se utiliza aquí como correlación respaldada por observaciones, no como una consecuencia universal de la elasticidad ni como una segunda rama probabilística independiente de la forma original.

## Idealización elástica confinada

Para un continuo elástico lineal e isótropo con deformación lateral impedida,

$$
K_0=\frac{\nu_g}{1-\nu_g},
$$

donde $\nu_g$ es el coeficiente de Poisson de la idealización constitutiva
[@ChristopherEtAl2006, ec. 5.37]. Esta relación constituye una referencia elástica. No sustituye una formulación que represente explícitamente la historia tensional de un suelo compactado.

## Descarga primaria

Mayne y Kulhawy expresan el efecto de la sobreconsolidación mediante

$$
\frac{K_{0,OC}}{K_{0,NC}}=\mathrm{OCR}^{a}, \qquad \mathrm{OCR}=\frac{\sigma'_{v,\max}}{\sigma'_v}.
$$

Los datos reunidos por los autores sustentan la aproximación
$a=\sin\phi'$, con lo cual

$$
K_{0,OC} = (1-\sin\phi')\,\mathrm{OCR}^{\sin\phi'}.
$$

La expresión corresponde a descarga desde la rama de compresión virgen
[@MayneKulhawy1982, ecs. 6--10]. Los exponentes fueron ajustados generalmente para $\mathrm{OCR}<15$. La variable OCR sólo tiene significado cuando
$\sigma'_{v,\max}$ representa una tensión máxima histórica identificable. OCR se emplea únicamente cuando esa tensión puede definirse a partir de la trayectoria considerada.

## Descarga seguida de recarga

Para una trayectoria de descarga y recarga se requiere una segunda medida de la historia:

$$
\mathrm{OCR}_{\max} =\frac{\sigma'_{v,\max}}{\sigma'_{v,\min}}.
$$

La relación general propuesta es

$$
K_0= (1-\sin\phi')\left[
\frac{\mathrm{OCR}} {\mathrm{OCR}_{\max}^{\,1-\sin\phi'}} +\frac{3}{4}\left (1-\frac{\mathrm{OCR}}{\mathrm{OCR}_{\max}} \right)
\right].
$$

Si $\mathrm{OCR}=\mathrm{OCR}_{\max}$ se recupera la expresión de descarga primaria. Si $\mathrm{OCR}=\mathrm{OCR}_{\max}=1$ se recupera la rama normalmente consolidada. La relación de recarga se construyó con una base de datos más reducida que las ramas anteriores y exige conocer
$\mathrm{OCR}_{\max}$ [@MayneKulhawy1982, ecs. 14--18]. Su aplicación se restringe a trayectorias de descarga y recarga cuya historia máxima pueda establecerse.

## Límite de la condición en reposo

Mayne y Kulhawy adoptan el coeficiente pasivo de Rankine como límite de la rama de descarga:

$$
K_p=\frac{1+\sin\phi'}{1-\sin\phi'}.
$$

Al imponer $K_{0,OC}=K_p$ se obtiene

$$
\mathrm{OCR}_{\lim} =\left[
\frac{1+\sin\phi'}{ (1-\sin\phi')^2} \right]^{1/\sin\phi'}.
$$

Para $\mathrm{OCR}\geq\mathrm{OCR}_{\lim}$, la correlación deja de describir un estado en reposo [@MayneKulhawy1982, ecs. 11--12]. El control debe informar esa condición y no recortar silenciosamente $K_0$. Este uso de $K_p$ no define una ley de interfaz ni una capacidad general del relleno contra el revestimiento.

## Discrepancia de transcripción en FHWA NHI-05-037

La ecuación 5.39 de FHWA NHI-05-037 imprime el término de recarga como
[@ChristopherEtAl2006, ec. 5.39]

$$
\frac{3}{4}\frac{\mathrm{OCR}}{\mathrm{OCR}_{\max}},
$$

mientras que la ecuación 18 del artículo primario contiene
[@MayneKulhawy1982, ec. 18]

$$
\frac{3}{4}\left (1-\frac{\mathrm{OCR}}{\mathrm{OCR}_{\max}} \right).
$$

La versión del manual produciría
$1.75 (1-\sin\phi')$ para
$\mathrm{OCR}=\mathrm{OCR}_{\max}=1$ y no recuperaría la relación normalmente consolidada presentada inmediatamente antes por el mismo manual. La expresión primaria satisface los límites de carga primaria y descarga; por ello gobierna la metodología y la versión FHWA queda excluida del cálculo.

## Compactación y tensión lateral residual

La densificación de un relleno puede modificar $\phi'$, generar una historia de carga--descarga y dejar una tensión horizontal residual. Estos efectos no deben concentrarse automáticamente en un único $K_0$ aumentado. La representación general es

$$
\sigma'_h (z)
=K_{0,b} (z)\,\sigma'_v (z)
+\Delta\sigma'_{h,c} (z),
$$

donde $K_{0,b}$ describe un estado base y
$\Delta\sigma'_{h,c}$ representa, únicamente cuando exista un modelo aplicable, la tensión efectiva residual atribuida a la construcción.

Esta descomposición y una relación de $K_0$ que ya representa la misma trayectoria de carga son alternativas: no se suman sin demostrar que describen fenómenos distintos. Para un revestimiento circular flexible, la magnitud y la distribución de $\Delta\sigma'_{h,c}$ permanecen sin determinar hasta caracterizar la secuencia, el equipo, el contenido de agua, la densidad alcanzada y la movilidad del revestimiento.

FHWA-RD-98-191 propone, para representar la acción de un equipo de compactación durante la colocación del relleno, la presión nodal horizontal equivalente [@McGrathEtAl1999, sec. 5.2.1, ec. 5.1]:

$$
n_p=1.3P (1-\sin\phi_\ell)^3 \left (\frac{970}{d_c-250}\right)^2.
$$

En esta relación, $n_p$ se expresa en kPa, la fuerza total $P$ del equipo en kN, el diámetro $d_c$ medido hasta el baricentro de la pared en mm y
$\phi_\ell$ es el ángulo de fricción del relleno en estado suelto. La fuente adopta $P\geq4$ kN para representar también el efecto gravitatorio del relleno. La correlación se ajustó a un conjunto limitado de análisis de conductos de diámetros nominales de 900 y 1500 mm, con $d_c$ aproximadamente igual a 970 y 1575 mm, materiales con
$\phi_\ell=28^\circ$ y $36^\circ$, y fuerzas de 4.0, 5.2 y 20.5 kN. Su empleo fuera de ese dominio requiere justificación específica.

La Tabla 5.5 de esa referencia reúne los casos utilizados para comprobar la ecuación; no contiene coeficientes de $K_0$ ni valores directamente transferibles a otro proyecto. Tampoco es una tabla AASHTO: AASHTO T 99 se menciona en la fuente únicamente como procedimiento de control de densidad. El modelo de FHWA aplica $n_p$ directamente a los nodos comprendidos hasta 300 mm por debajo de la superficie de la tongada activa. La ecuación no establece una fracción de presión retenida después de retirar el equipo ni una distribución angular general para un revestimiento circular.

{{< include /_tbl/Methodology.fhwa.compaction.ES.qmd >}}

La fila 9 se conserva como aparece en la fuente: con el valor impreso
$\phi_\ell=28^\circ$ no reproduce $n_p=0.2$ kPa, mientras que
$\phi_\ell=36^\circ$ sí lo hace al redondear. Esta discrepancia documental no autoriza a sustituir el parámetro impreso ni constituye una alternativa de diseño.

La aplicación de la relación de FHWA sigue una secuencia distinta de la estimación de $K_0$:

1. El estado permanente del relleno se define mediante la rama de historia tensional aplicable y
   $\sigma'_{h,b}=K_{0,b}\sigma'_v$.
2. Si se comprueba una etapa activa de compactación y el equipo, el material y la geometría se encuentran dentro de un dominio justificable, se calcula
   $n_p$ con los parámetros de esa etapa.
3. $n_p$ se introduce como una acción horizontal independiente sobre la banda activa de 300 mm. El modelo de la etapa debe declarar su extensión, su dirección y la regla con la que se combina con las acciones preexistentes. La ecuación 5.1 no autoriza la sustitución
   $\sigma'_h=K_{0,b}\sigma'_v+n_p$ ni la transformación
   $K_0=K_{0,b}+n_p/\sigma'_v$.
4. Al finalizar la compactación, $n_p$ no se conserva en el estado permanente. Una tensión residual sólo puede incorporarse mediante un modelo o una medición independiente de $\Delta\sigma'_{h,c}$.

Cuando esa tensión residual ha sido determinada de manera independiente y
$\sigma'_v>0$, puede informarse para una profundidad y una etapa dadas el coeficiente equivalente

$$
K_{0,eq} (z)
=\frac{\sigma'_h (z)}{\sigma'_v (z)} =K_{0,b} (z)
+\frac{\Delta\sigma'_{h,c} (z)}{\sigma'_v (z)}.
$$

$K_{0,eq}$ es el cociente resultante de un estado ya definido; no constituye una nueva correlación de $K_0$. En particular, $n_p$ no puede utilizarse como
$\Delta\sigma'_{h,c}$ porque la fuente no establece retención permanente y el valor mínimo de $P$ ya incorpora el efecto gravitatorio. Su adición directa al estado geostático puede contabilizar dos veces una misma contribución.

## Función dentro del análisis de conductos enterrados

La referencia normativa principal es AASHTO LRFD Bridge Design Specifications, sección 12. La rama resistente no se selecciona a partir de la forma circular solamente: el índice oficial distingue los tubos, arcos y estructuras de arco metálicos del artículo 12.7, las estructuras de gran luz de chapas estructurales del artículo 12.8, el subcaso de corrugación profunda del artículo 12.8.9 y las chapas de acero para revestimiento de túneles del artículo 12.13 [@AASHTO2024TOC]. La identificación del producto y de su procedimiento de montaje determina qué artículo y, cuando corresponda, qué subartículo resultan aplicables.

Para conductos metálicos corrugados, USACE reproduce como relación de empuje por unidad de longitud de pared [@USACE2020, ec. 4-20]

$$
T_L=P_F\frac{S}{2}.
$$

$P_F$ reúne la acción vertical mayorada del suelo y las sobrecargas, y $S$ es la luz. Esta expresión es una reproducción pública del procedimiento que USACE atribuía a AASHTO en 2020; no se presenta como transcripción verificada del articulado de la décima edición. Antes de utilizarla en una comprobación reglamentaria deben confirmarse en la edición adoptada su permanencia, las definiciones de las variables, los factores, las combinaciones y el dominio de la rama seleccionada. CIRSOC 804-4 conserva una relación coincidente y una numeración basada en una edición anterior de AASHTO, pero se mantiene sólo como contraste métrico y no como autoridad normativa de este procedimiento
[@CIRSOC8044].

En particular, el índice de AASHTO identifica una comprobación combinada de empuje y momento en el artículo 12.8.9.5 para corrugación profunda. Esa disposición no se transfiere a los artículos 12.7 o 12.13. Las ecuaciones de resistencia de pared o área, pandeo, costuras y conexiones permanecen pendientes hasta consultar el articulado vigente y clasificar el producto.

Cuando se necesita la variación angular de las acciones y de las resultantes, debe adoptarse una formulación de interacción que represente el relleno, la rigidez del conducto, el arqueo, la interfaz y las etapas constructivas. En esa formulación $K_0$ puede definir el estado inicial de tensiones del relleno; no se iguala sin demostración a la relación entre presiones de contacto horizontal y vertical sobre la pared.

## Selección de la formulación

La secuencia de selección es:

1. utilizar una medición representativa cuando exista y conservar su profundidad, trayectoria tensional e incertidumbre;
2. emplear $K_{0,NC}=1-\sin\phi'$ para carga primaria o estado normalmente consolidado;
3. emplear la relación de descarga sólo cuando OCR sea físicamente definible;
4. emplear la relación de recarga sólo cuando OCR y
   $\mathrm{OCR}_{\max}$ estén documentados;
5. mantener como escenarios separados las historias que no puedan discriminarse; y
6. tratar un valor constante adoptado como sensibilidad o comprobación, no como estimación del relleno.

La relación elástica se conserva como referencia constitutiva y no se combina con las correlaciones de historia tensional para obtener un promedio.

## Comparación entre formulaciones

Las relaciones anteriores no constituyen estimadores intercambiables de una misma condición. La comparación debe preservar la clase de material y la trayectoria tensional que define cada rama. En particular, la expresión elástica utiliza $\nu_g$, la relación de Jáky utiliza $\phi'$ y las relaciones de Mayne--Kulhawy incorporan además la historia representada por OCR y
$\mathrm{OCR}_{\max}$.

FHWA y USACE no aportan, en las secciones verificadas, nuevas correlaciones independientes: FHWA presenta la referencia elástica y la relación abreviada de Jáky, mientras USACE utiliza esta última dentro de una comprobación específica [@ChristopherEtAl2006, sec. 5.4.9; @USACE2020, sec. 7.5.3.4.6]. En Núñez (2000), $K_0$ interviene como parámetro de la formulación de cargas e interacción; no se identificó allí una expresión independiente para estimarlo
[@Nunez2000, pp. 13--15]. Por ello, FHWA, USACE y Núñez no se incorporan como tres modelos adicionales de $K_0$.

Sea $s=\sin\phi'$. Para un mismo $\phi'$, la rama normalmente consolidada define el valor de referencia

$$
K_{0,NC}=1-s.
$$

La comparación con la descarga primaria puede escribirse sin fijar valores numéricos:

$$
\frac{K_{0,OC}}{K_{0,NC}}=\mathrm{OCR}^{s}.
$$

Por lo tanto, ambas ramas coinciden para $\mathrm{OCR}=1$ y, para
$\phi'>0$, la descarga incrementa $K_0$ en forma monótona mientras la relación permanezca dentro de su dominio. Para descarga seguida de recarga,

$$
\frac{K_0}{K_{0,NC}} =\frac{\mathrm{OCR}} {\mathrm{OCR}_{\max}^{\,1-s}} +\frac{3}{4}\left (1-\frac{\mathrm{OCR}}{\mathrm{OCR}_{\max}} \right).
$$

Esta forma permite comprobar directamente los límites de carga primaria y descarga sin introducir resultados tabulados. La igualdad formal entre la idealización elástica y la relación de Jáky se obtiene cuando

$$
\nu_g=\frac{1-\sin\phi'}{2-\sin\phi'}.
$$

La igualdad es sólo un control algebraico; no establece una relación constitutiva entre $\nu_g$ y $\phi'$ ni autoriza a derivar uno de esos parámetros a partir del otro.

Para aislar la incidencia de $K_0$ en el estado biaxial prescrito, se mantienen iguales $\sigma'_v$ y $\Delta u$ entre escenarios. Entonces

$$
\sigma'_h=K_0\sigma'_v, \qquad p_m=\Delta u+\frac{1+K_0}{2}\sigma'_v, \qquad \Delta\sigma= (1-K_0)\sigma'_v.
$$

El incremento de $K_0$ aumenta la componente media con
$\partial p_m/\partial K_0=\sigma'_v/2$ y reduce la amplitud desviadora con
$\partial\Delta\sigma/\partial K_0=-\sigma'_v$. Para $K_0=1$ desaparece la componente armónica de esa proyección; para $K_0>1$ cambia su signo. Estas relaciones describen el escenario biaxial analítico y no sustituyen una ley de contacto suelo--conducto.

La comparación numérica se construye a partir de casos declarados. Cada caso registra la formulación, sus variables primitivas, el estado de dominio y la misma definición de tensiones y agua empleada en la comparación. Los valores de $K_0$, $\sigma'_h$, $p_m$, $\Delta\sigma$ y, cuando corresponda, las resultantes se calculan desde esas entradas. Si la trayectoria del relleno no permite seleccionar una única formulación, las ramas se mantienen como escenarios discretos sin promediarlas ni asignarles probabilidades no documentadas.

## Alcance

Las relaciones anteriores determinan el estado lateral efectivo del relleno. No calculan la presión de contacto ni las resultantes estructurales, y tampoco reemplazan la solicitación reglamentaria de la rama AASHTO aplicable. La aplicación al revestimiento existente requiere clasificar el producto, el relleno y el procedimiento constructivo, reconstruir la historia tensional y seleccionar una formulación de interacción cuando se pretendan obtener distribuciones angulares de $N_\theta$, $M_\theta$ y $Q_\theta$.
