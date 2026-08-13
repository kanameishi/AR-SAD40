# Parametrización candidata para la propagación de incertidumbre

## Estado de la nota

Esta nota define la frontera técnica para preparar la simulación de Monte
Carlo. No adopta distribuciones ni valores para el caso de estudio. Las
familias y dispersiones publicadas que se citan son antecedentes para
seleccionar un modelo estadístico; no constituyen *priors* transferibles al
relleno sin clasificación, ensayos o registros de construcción.

La auditoría independiente de las fuentes confirmó las atribuciones a JCSS,
JRC, MnDOT, FHWA, Duncan--Seed y Mai. Se excluyó de esta nota una atribución
no cerrada sobre el procedimiento estadístico de Caleyo et al. (2009).

## Frontera de cálculo

La resolución determinística vigente calcula una realización del estado de
acciones y devuelve

$$
N_\theta(\theta),\qquad M_\theta(\theta),\qquad Q_\theta(\theta).
$$

La función `runRingMonteCarlo()` recibe realizaciones ya generadas y agrega
sus respuestas. No genera variables aleatorias ni define distribuciones. El
modelo probabilístico debe, por lo tanto, construirse como una capa anterior
que produzca una tabla conjunta de variables primitivas y conserve el
escenario al que pertenece cada realización.

Se distinguen dos alcances:

1. **MC-R:** propagación hasta las resultantes seccionales y sus extremos; y
2. **MC-S:** propagación hasta tensiones y verificaciones resistentes, que
   requiere además la sección neta deteriorada y el procedimiento normativo
   aplicable.

La primera implementación corresponde a MC-R.

## Variables primitivas y derivadas

| Bloque | Variables primitivas candidatas | Magnitudes derivadas | Decisión o dato requerido |
|---|---|---|---|
| geometría y sobrecarga | tapada $H_0$, estratigrafía, pesos unitarios y sobrecarga superficial | $\sigma'_v$ en la cota de referencia | confirmar $H_0$, estratigrafía, sobrecarga y estado de agua |
| estado lateral | $\phi'$, OCR y, si se adopta, error de transformación | $K_0$ y $\sigma'_h$ | seleccionar ramas compatibles con el tipo y la historia del relleno |
| compactación | densidad seca, humedad y descriptores del procedimiento; o una presión residual caracterizada | incremento lateral residual | elegir representación y aportar registros o límites sustentados |
| agua | nivel o diferencia de carga hidráulica | $\Delta u$ y pesos unitarios efectivos | definir estados y datos piezométricos |
| participación tangencial | $\alpha\in[0,1]$ | $P_t(\theta)$ | adoptar su distribución o sus escenarios discretos |
| sección nominal | perfil, espesor base y módulo circunferencial | $A_\theta$, $I_\theta$, $EA_\theta$, $EI_\theta$ | confirmar cuáles magnitudes son determinísticas |
| deterioro, sólo MC-S | perfil medido $t_{\mathrm{net}}(\theta)$ y error de medición | propiedades netas y tensiones | completar el levantamiento ultrasónico y el modelo espacial |

$K_0$, $\sigma'_h$, $P_r$, $P_t$, $N_\theta$, $M_\theta$ y $Q_\theta$ son
salidas de transformaciones físicas y no se muestrean simultáneamente con
las variables primitivas que los determinan.

## Evidencia estadística disponible

JCSS publica desviaciones estándar indicativas de 5--10 % de la media para el
peso unitario y de 10--20 % para $\tan\phi'$. También señala que la normal es
habitual en confiabilidad geotécnica y recomienda la lognormal para
propiedades estrictamente positivas cuando una normal pueda generar valores
físicamente inadmisibles [@JCSS2006].

La guía JRC propone, como modelos generales, una distribución normal para el
ángulo de fricción de arenas y para el peso unitario sumergido, y normal o
lognormal para OCR. También documenta el uso de distribuciones uniforme,
triangular, normal y beta según la información efectivamente disponible, y
separa variabilidad inherente, error de medición, incertidumbre estadística e
incertidumbre de transformación [@VanDenEijndenEtAl2024].

Los coeficientes de variación publicados por JCSS y JRC son indicativos y
condicionados por clase de suelo y calidad de determinación. No se adoptarán
como dispersión del relleno hasta definir su clasificación y la evidencia de
proyecto.

## Tratamiento de $K_0$

Para una rama de suelo cargado y descargado puede considerarse la estimación
aproximada

$$
K_0=(1-\sin\phi')\,\mathrm{OCR}^{\sin\phi'},
$$

documentada por MnDOT [@DaggerSaftnerMayne2018, apéndice A, ec. A21]. En esta
rama, $K_0$ se deriva de $\phi'$ y OCR. No corresponde asignarle además una
distribución marginal independiente.

La incertidumbre de la correlación puede representarse mediante un sesgo y un
error multiplicativo, conforme al tratamiento general de las transformaciones
de la guía JRC. Sus parámetros para esta relación permanecen sin determinar y
no se incorporarán hasta disponer de evidencia comparable.

Si se dispone de mediciones directas de $K_0$, esa alternativa constituye una
rama distinta. No se combinará con la rama derivada duplicando la misma
incertidumbre.

## Compactación

FHWA define la compactación relativa a partir de la densidad seca de campo y
la densidad seca máxima, y trata densidad y contenido de agua como observables
de control [@ChristopherEtAl2006]. Una exigencia mínima de compactación no es
una distribución probabilística.

Duncan y Seed muestran que la compactación puede producir presiones laterales
máximas y residuales mediante un proceso transitorio e histerético
[@DuncanSeed1986]. No se identificó una distribución universal para ese
incremento. Las alternativas admisibles son:

1. una distribución conjunta de densidad y humedad obtenida de controles de
   obra;
2. escenarios discretos de procedimiento de compactación, con probabilidades
   sólo si existen registros suficientes; o
3. una presión lateral residual separada, caracterizada mediante mediciones o
   un modelo documentado.

El efecto residual no se incorporará simultáneamente mediante una presión
adicional y una historia tensional que represente el mismo fenómeno.

## Participación tangencial

El parámetro $\alpha$ es un multiplicador de la componente tangencial de la
familia de acciones prescrita:

$$
P_t(\theta)=\alpha p_t^*(\theta),\qquad 0\leq\alpha\leq1.
$$

No es un coeficiente de fricción ni $\tan\delta$. El usuario definió que
$\alpha$ participe en Monte Carlo, pero no existe todavía evidencia para
elegir su distribución. Una uniforme en $[0,1]$ no se adoptará por defecto:
esa elección asignaría probabilidades que no fueron justificadas.

## Deterioro y espesor remanente

Mai documenta que el espesor remanente de conductos corrugados deteriorados es
espacialmente variable y que debe levantarse mediante una malla de mediciones
ultrasónicas [@Mai2013, cap. 3, sec. 3.7]. Esta evidencia favorece un perfil
$t_{\mathrm{net}}(\theta)$ condicionado por mediciones, no un porcentaje
global de corrosión elegido sin datos.

El deterioro no modifica MC-R mientras el objetivo sea obtener resultantes
seccionales con rigideces nominales. Para MC-S, el espesor remanente y su
dependencia espacial son entradas obligatorias de la recuperación de tensiones
y de la verificación resistente.

## Dependencias obligatorias

El generador conjunto deberá imponer, como mínimo, las siguientes
dependencias:

- $K_0$ derivado de $\phi'$ y OCR en las ramas que empleen esa relación;
- $\sigma'_v$ derivada de tapada, estratigrafía, pesos unitarios, agua y
  sobrecarga cuando se adopte esa ruta;
- pesos unitarios, contenido de agua, grado de saturación y nivel freático
  coherentes con relaciones de fase;
- compactación relativa derivada de las densidades correspondientes, si se
  utiliza esa magnitud; y
- espesor neto derivado del espesor intacto y de la pérdida medida, con
  $0\leq t_{\mathrm{net}}\leq t_{\mathrm{intact}}$.

Las correlaciones entre propiedades del suelo se estimarán a partir de datos
pareados o se tratarán mediante escenarios de sensibilidad explícitos. No se
supondrá independencia por omisión.

## Ramas de modelo

Si el tipo de relleno permanece desconocido, las ramas granular, cohesiva y
cementada se calcularán por separado. No se formará una mezcla probabilística
sin pesos sustentados. La envolvente de resultados de ramas separadas es una
envolvente epistemológica y no una función de densidad combinada.

Del mismo modo, los estados de agua frecuentes y extremos, las ramas de
$K_0$ medido o derivado y las representaciones alternativas de compactación
permanecerán separados mientras no exista evidencia para asignarles
probabilidades.

## Productos de MC-R

Para cada rama aprobada se materializarán:

1. especificación completa de variables, marginales, parámetros,
   truncamientos y dependencias;
2. semilla, cantidad de realizaciones y criterio de convergencia;
3. cuantiles puntuales de $N_\theta(\theta)$, $M_\theta(\theta)$ y
   $Q_\theta(\theta)$;
4. mínimo, máximo y máximo absoluto espacial por realización; y
5. cuantiles escalares de esos extremos.

Los cuantiles puntuales conservan su coordenada angular. Los cuantiles de
extremos espaciales no reciben un ángulo ficticio. Las bandas angulares y la
tabla de extremos son productos distintos.

## Decisiones necesarias antes de ejecutar

1. tapada, estratigrafía, sobrecarga y tratamiento del agua;
2. clasificación del relleno o lista de ramas a calcular por separado;
3. variables primitivas y formulación de $K_0$ de cada rama;
4. representación de la compactación residual;
5. distribución o escenarios de $\alpha$;
6. marginales, parámetros, truncamientos y correlaciones;
7. semilla, cantidad de realizaciones, cuantiles y criterio de convergencia; y
8. alcance MC-R o MC-S de la primera corrida.

Hasta resolver estas decisiones, el cálculo determinístico permanece como
base por realización y control matemático, no como reemplazo de la propagación
de incertidumbre.
