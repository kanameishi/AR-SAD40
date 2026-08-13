# Estimación del coeficiente de empuje en reposo

## Estado lateral efectivo del relleno

El estado lateral efectivo constituye una entrada de la proyección de acciones
sobre el revestimiento circular. Las relaciones siguientes permiten obtenerlo
a partir de las propiedades del suelo y de su historia tensional.

El capítulo caracteriza las formulaciones aplicables según la trayectoria
tensional, identifica sus variables primitivas y establece la separación entre
$K_0$ y una eventual tensión horizontal residual inducida por la compactación.

## Definición del estado lateral

En condiciones de deformación lateral nula, el coeficiente de empuje en reposo
se define mediante tensiones efectivas:

$$
K_0(z)=\frac{\sigma'_h(z)}{\sigma'_v(z)}.
$$

La tensión horizontal total es

$$
\sigma_h(z)=\sigma'_h(z)+u(z)
=K_0(z)\,\sigma'_v(z)+u(z),
$$

donde $u$ es la presión intersticial. Esta separación evita aplicar $K_0$ a
una tensión vertical total y contabilizar el agua dos veces
[@ChristopherEtAl2006, sec. 5.4.9].

La salida que consume el cálculo estructural es $\sigma'_h(z)$. Para organizar
el procedimiento adoptado en este estudio, una rama geotécnica $m$ se expresa
como

$$
K_0^{(m)}(z)=f_m\!\left[\mathbf x_m(z)\right],
\qquad
\sigma_h'^{(m)}(z)=K_0^{(m)}(z)\,\sigma'_v(z),
$$

y $\mathbf x_m$ contiene únicamente las variables primitivas requeridas por
esa formulación.

## Carga primaria

### Forma abreviada de Jáky

Para carga primaria, la expresión de uso habitual es

$$
K_{0,NC}=1-\sin\phi',
$$

donde $\phi'$ es el ángulo de fricción interna efectiva correspondiente al
material y al intervalo tensional considerado. Mayne y Kulhawy confrontaron
esta relación con una base de datos de suelos cohesivos y no cohesivos y la
adoptaron como representación de la rama normalmente consolidada
[@MayneKulhawy1982, pp. 852--853]. FHWA la presenta para suelos no cohesivos y
suelos cohesivos normalmente consolidados
[@ChristopherEtAl2006, ec. 5.38].

La relación es una correlación para una trayectoria de carga primaria. Las
trayectorias de descarga y recarga, así como una eventual tensión horizontal
retenida durante la construcción, requieren formulaciones independientes.

### Forma de 1944 y alcance de la derivación

Michalowski transcribe la forma obtenida por Jáky en 1944:

$$
K_{0,\mathrm{J\acute{a}ky\,1944}}
=(1-\sin\phi')
\frac{1+\frac{2}{3}\sin^2\phi'}{1+\sin\phi'}.
$$

Jáky eliminó posteriormente el factor fraccionario y produjo la forma
abreviada. Michalowski observa que la derivación de 1944 utiliza el campo
tensional de un prisma de arena y que ese campo no representa una trayectoria
general de deformación unidimensional [@Michalowski2005, ec. 8]. Por ello, la
forma abreviada se utiliza aquí como correlación respaldada por observaciones,
no como una consecuencia universal de la elasticidad ni como una segunda rama
probabilística independiente de la forma original.

## Idealización elástica confinada

Para un continuo elástico lineal e isótropo con deformación lateral impedida,

$$
K_0=\frac{\nu_g}{1-\nu_g},
$$

donde $\nu_g$ es el coeficiente de Poisson de la idealización constitutiva
[@ChristopherEtAl2006, ec. 5.37]. Esta relación constituye una referencia
elástica. No sustituye una formulación que represente explícitamente la
historia tensional de un suelo compactado.

## Descarga primaria

Mayne y Kulhawy expresan el efecto de la sobreconsolidación mediante

$$
\frac{K_{0,OC}}{K_{0,NC}}=\mathrm{OCR}^{a},
\qquad
\mathrm{OCR}=\frac{\sigma'_{v,\max}}{\sigma'_v}.
$$

Los datos reunidos por los autores sustentan la aproximación
$a=\sin\phi'$, con lo cual

$$
K_{0,OC}
=(1-\sin\phi')\,\mathrm{OCR}^{\sin\phi'}.
$$

La expresión corresponde a descarga desde la rama de compresión virgen
[@MayneKulhawy1982, ecs. 6--10]. Los exponentes fueron ajustados generalmente
para $\mathrm{OCR}<15$. La variable OCR sólo tiene significado cuando
$\sigma'_{v,\max}$ representa una tensión máxima histórica identificable. OCR
se emplea únicamente cuando esa tensión puede definirse a partir de la
trayectoria considerada.

## Descarga seguida de recarga

Para una trayectoria de descarga y recarga se requiere una segunda medida de
la historia:

$$
\mathrm{OCR}_{\max}
=\frac{\sigma'_{v,\max}}{\sigma'_{v,\min}}.
$$

La relación general propuesta es

$$
K_0=(1-\sin\phi')\left[
\frac{\mathrm{OCR}}
{\mathrm{OCR}_{\max}^{\,1-\sin\phi'}}
+\frac{3}{4}\left(
1-\frac{\mathrm{OCR}}{\mathrm{OCR}_{\max}}
\right)
\right].
$$

Si $\mathrm{OCR}=\mathrm{OCR}_{\max}$ se recupera la expresión de descarga
primaria. Si $\mathrm{OCR}=\mathrm{OCR}_{\max}=1$ se recupera la rama
normalmente consolidada. La relación de recarga se construyó con una base de
datos más reducida que las ramas anteriores y exige conocer
$\mathrm{OCR}_{\max}$ [@MayneKulhawy1982, ecs. 14--18]. Su aplicación se
restringe a trayectorias de descarga y recarga cuya historia máxima pueda
establecerse.

## Límite de la condición en reposo

Mayne y Kulhawy adoptan el coeficiente pasivo de Rankine como límite de la
rama de descarga:

$$
K_p=\frac{1+\sin\phi'}{1-\sin\phi'}.
$$

Al imponer $K_{0,OC}=K_p$ se obtiene

$$
\mathrm{OCR}_{\lim}
=\left[
\frac{1+\sin\phi'}{(1-\sin\phi')^2}
\right]^{1/\sin\phi'}.
$$

Para $\mathrm{OCR}\geq\mathrm{OCR}_{\lim}$, la correlación deja de describir
un estado en reposo [@MayneKulhawy1982, ecs. 11--12]. El control debe informar
esa condición y no recortar silenciosamente $K_0$. Este uso de $K_p$ no define
una ley de interfaz ni una capacidad general del relleno contra el
revestimiento.

## Discrepancia de transcripción en FHWA NHI-05-037

La ecuación 5.39 de FHWA NHI-05-037 imprime el término de recarga como
[@ChristopherEtAl2006, ec. 5.39]

$$
\frac{3}{4}\frac{\mathrm{OCR}}{\mathrm{OCR}_{\max}},
$$

mientras que la ecuación 18 del artículo primario contiene
[@MayneKulhawy1982, ec. 18]

$$
\frac{3}{4}\left(
1-\frac{\mathrm{OCR}}{\mathrm{OCR}_{\max}}
\right).
$$

La versión del manual produciría
$1.75(1-\sin\phi')$ para
$\mathrm{OCR}=\mathrm{OCR}_{\max}=1$ y no recuperaría la relación normalmente
consolidada presentada inmediatamente antes por el mismo manual. La expresión
primaria satisface los límites de carga primaria y descarga; por ello gobierna
la metodología y la versión FHWA queda excluida del cálculo.

## Compactación y tensión lateral residual

La densificación de un relleno puede modificar $\phi'$, generar una historia
de carga--descarga y dejar una tensión horizontal residual. Estos efectos no
deben concentrarse automáticamente en un único $K_0$ aumentado. La
representación general es

$$
\sigma'_h(z)
=K_{0,b}(z)\,\sigma'_v(z)
+\Delta\sigma'_{h,c}(z),
$$

donde $K_{0,b}$ describe un estado base y
$\Delta\sigma'_{h,c}$ representa, únicamente cuando exista un modelo
aplicable, la tensión efectiva residual atribuida a la construcción.

Esta descomposición y una relación de $K_0$ que ya representa la misma
trayectoria de carga son alternativas: no se suman sin demostrar que describen
fenómenos distintos. La presión equivalente de compactación de
FHWA-RD-98-191 es una acción por etapa y no define una fracción permanente
retenida ni un coeficiente $K_0$ universal [@McGrathEtAl1999, ec. 5.1]. Para
un revestimiento circular flexible, la magnitud y la distribución de
$\Delta\sigma'_{h,c}$ permanecen sin determinar hasta caracterizar la
secuencia, el equipo, el contenido de agua, la densidad alcanzada y la
movilidad del revestimiento.

## Selección de la formulación

La secuencia de selección es:

1. utilizar una medición representativa cuando exista y conservar su
   profundidad, trayectoria tensional e incertidumbre;
2. emplear $K_{0,NC}=1-\sin\phi'$ para carga primaria o estado normalmente
   consolidado;
3. emplear la relación de descarga sólo cuando OCR sea físicamente definible;
4. emplear la relación de recarga sólo cuando OCR y
   $\mathrm{OCR}_{\max}$ estén documentados;
5. mantener como escenarios separados las historias que no puedan
   discriminarse; y
6. tratar un valor constante adoptado como sensibilidad o comprobación, no
   como estimación del relleno.

La relación elástica se conserva como referencia constitutiva y no se combina
con las correlaciones de historia tensional para obtener un promedio.

## Propagación de incertidumbres

En cada realización se muestrean las variables primitivas de la rama elegida:
$\phi'$, $\nu_g$, OCR, $\mathrm{OCR}_{\max}$ o los datos que definan una
medición. $K_0$ se calcula después y se conserva junto con
$\sigma'_h(z)$, la identificación de la formulación y el estado de sus
controles.

No se muestrean de forma independiente $K_0$ y las variables que lo
determinan. Cuando no existan probabilidades justificadas para las
formulaciones alternativas, cada una permanece como un escenario discreto y
contribuye a una envolvente exterior; no se construye una distribución híbrida
por promediación de correlaciones.

La eventual tensión residual de compactación constituye otra variable o rama
de modelo. Su distribución y su dependencia con densidad, humedad, equipo e
historia tensional sólo podrán definirse después de contar con evidencia
aplicable al revestimiento considerado.

## Alcance

Las relaciones anteriores determinan el estado lateral efectivo que se
proyecta sobre la sección circular. No calculan resultantes estructurales,
tensiones de la chapa ni resistencia de uniones. La aplicación al
revestimiento existente requiere todavía clasificar el relleno y reconstruir
su historia tensional y constructiva.
