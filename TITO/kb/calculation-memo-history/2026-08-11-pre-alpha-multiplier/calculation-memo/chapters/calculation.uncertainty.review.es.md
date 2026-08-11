# Plan de análisis probabilístico {#sec-calculation-uncertainty}

## Estado de esta emisión

La evaluación probabilística del revestimiento existente no fue ejecutada. No
se han adoptado distribuciones marginales, dependencias, truncamientos,
probabilidades de alternativas ni criterios de convergencia. En consecuencia,
esta memoria no presenta cuantiles, funciones de densidad de probabilidad ni
envolventes probabilísticas del proyecto.

El análisis se realizará mediante simulación directa de Monte Carlo una vez
completadas y definidas las etapas siguientes.

## Datos conocidos y magnitudes por caracterizar

La tapada, la geometría del revestimiento, el perfil de la chapa, el acero y el
espesor original se incorporarán como datos determinísticos a partir de los
registros definitivos. La @tbl-calculation-probabilistic-inputs identifica las
magnitudes que permanecen por caracterizar.

| Grupo | Magnitudes primitivas | Relación dentro del cálculo | Estado |
|---|---|---|---|
| relleno | clasificación, estratigrafía, $\gamma'$, humedad y parámetros resistentes | determina $\sigma_v'$, la rama aplicable de $K_0$ y la condición drenada o no drenada | pendiente de caracterización |
| estado lateral | $K_0$ o variables que lo determinan; incremento residual de compactación | determina $\sigma_h'(\theta)$ | definir una rama sin duplicar variables dependientes |
| compactación | equipo, energía, tongadas, secuencia y retención | determina acciones temporales y, si existe evidencia, componentes residuales | pendiente de registros de obra |
| interfaz | $\delta$ y, cuando corresponda, $c_a$ | $\alpha_\delta=\tan\delta$ y @eq-calculation-interface-friction | pendiente de caracterización suelo--chapa |
| corrosión | pérdida de espesor o mediciones de espesor actual | $t_{net}=t_0-\Delta t_{corr}$; se recalculan $A_p$, $I_p$, $EA_\theta$ y $EI_\theta$ | pendiente de inspección y modelo espacial |
| agua | niveles exterior e interior y variación temporal | determina $\Delta u(\theta)$ | confirmar para cada estado de carga |

: Variables que requieren caracterización antes de ejecutar Monte Carlo. {#tbl-calculation-probabilistic-inputs}

$K_0$ no se muestreará simultáneamente con todas las variables de una relación
que ya lo determine. Del mismo modo, $\delta$ y
$\alpha_\delta=\tan\delta$ representan una sola variable, y el espesor neto no
se muestreará independientemente de la pérdida de sección que lo produce. Las
dependencias entre clasificación, densidad, humedad, fricción y compactación
se establecerán a partir de datos; no se asignarán por conveniencia numérica.

## Cierre del modelo determinístico

Antes de generar realizaciones deberán definirse:

1. las ramas de empuje lateral y compactación aplicables a cada tipo de
   relleno;
2. la relación entre pérdida de espesor y propiedades seccionales actuales;
3. los parámetros y el dominio de la @eq-calculation-interface-friction;
4. la recuperación de tensiones normales en la chapa a partir de
   $N_\theta$ y $M_\theta$;
5. la contribución de $Q_\theta$ a las tensiones locales de la chapa; y
6. la conversión de $N_\theta$ en fuerza tributaria de la junta longitudinal,
   su distribución entre pernos y la eventual contribución de
   $M_\theta$ o $Q_\theta$.

El punto 5 permanece sin formulación adoptada. $Q_\theta$ se conservará como
resultante primaria hasta establecer una sección efectiva para cortante y una
distribución local compatible con la corrugación. Las tensiones y las demandas
de pernos se obtienen como respuestas calculadas a partir de cada realización;
no se prescriben como variables de entrada.

## Especificación de la simulación

Para cada variable se documentarán la fuente de datos, unidad, dominio,
representación probabilística, parámetros, truncamientos y dependencias. Antes
de la corrida se fijarán también el generador aleatorio, la semilla, el número
inicial y máximo de realizaciones, los cuantiles objetivo y los criterios de
estabilidad de los resultados.

Cada realización conservará sus valores de entrada y calculará, por etapa:

1. $P_r(\theta)$ y $P_t(\theta)$;
2. $N_\theta(\theta)$, $M_\theta(\theta)$ y $Q_\theta(\theta)$;
3. los mínimos, máximos y máximos absolutos, con su posición angular; y
4. una vez definida la recuperación resistente, las tensiones de la chapa y
   las demandas de las uniones.

Las funciones de densidad y distribución acumulada de las tensiones se
obtendrán de la misma muestra registrada. Las distribuciones en una posición
angular fija y las distribuciones del máximo sobre toda la sección son
resultados distintos y se informarán por separado. Esta distinción afecta
directamente la selección de los estados para la verificación resistente.

Las alternativas de suelo, compactación o corrosión que no dispongan de una
probabilidad sustentada se mantendrán como escenarios separados. Sólo se
construirá una envolvente exterior entre escenarios después de definir sus
entradas y su dominio; no se les asignarán pesos probabilísticos implícitos.
