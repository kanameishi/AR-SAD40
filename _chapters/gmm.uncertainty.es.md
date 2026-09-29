Las GMM son unos de los principales contribuyentes a la incertidumbre epistémica del PSHA, junto con componentes del modelo de fuentes como la geometría de las fallas, las tasas de sismicidad y las distribuciones magnitud-frecuencia. A diferencia de la variabilidad aleatoria, la incertidumbre epistémica representa conocimiento científico incompleto del verdadero proceso de movimiento del suelo: es en principio reducible con datos adicionales y se representa mediante un conjunto discreto de modelos alternativos. En regiones con registros de movimientos fuertes escasos, las medianas de las GMPE candidatas pueden divergir sustancialmente en los períodos espectrales y rangos magnitud-distancia de interés ingenieril, y esa dispersión es frecuentemente el principal contribuyente a la banda de incertidumbre de la curva de amenaza a tasas de excedencia bajas. Por eso la incertidumbre de modelo se representa explícitamente mediante un árbol lógico que muestrea el espacio de alternativas posibles. Cada árbol lógico se define para un tipo de región tectónica y comprende un único nivel de ramificación. Cada rama especifica una GMPE alternativa con un peso no negativo $w_k$ que cumple la condición de normalización

$$
\sum_{k=1}^{N} w_k = 1, \qquad w_k \geq 0
$${#eq-weight-norm}

donde $N$ es el número de ramas del conjunto. Los pesos definen una distribución de probabilidad discreta sobre las GMPE candidatas; cuando todos los modelos reciben igual peso, $w_k = 1/N$, el árbol representa un estado de máxima incertidumbre de modelo, sin preferencia previa por ninguna formulación. El árbol se propaga evaluando la integral de amenaza separadamente para cada rama y combinando las curvas resultantes con sus pesos [@OpenQuakeEngine]. La curva media de amenaza es el promedio ponderado

$$
\bar{\lambda}_I(i^*) = \sum_{k=1}^{N} w_k\, \lambda_I^{(k)}(i^*)
$${#eq-mean-hazard}

donde $\lambda_I^{(k)}(i^*)$ es la tasa anual de excedencia calculada con la GMPE de la rama $k$. La distribución completa sobre ramas permite además calcular curvas de amenaza fractiles en niveles de probabilidad prescritos, que caracterizan la dispersión originada por la incertidumbre epistémica de GMM. Los cuatro árboles de esta evaluación asignan pesos iguales a sus ramas —con el único ajuste de redondeo del árbol SCC, detallado en su sección—. Esta ponderación es una respuesta epistémica fundamentada: donde el catálogo de movimientos fuertes es insuficiente para discriminar estadísticamente entre formulaciones candidatas, no existe base empírica para asignar pesos sistemáticamente mayores a una familia de modelos, y los pesos diferenciales introducirían una precisión aparente sin sustento, con el riesgo de subrepresentar el verdadero rango de incertidumbre epistémica. Desde la teoría de la información, la distribución uniforme es la asignación de máxima entropía bajo un estado de conocimiento previo igual [@Springer2023LT]. El complemento de esa ponderación es la amplitud del conjunto: un ensamble grande y de genealogías diversas —calibraciones europeas, neozelandesas, taiwanesas y globales NGA-West2 en corteza activa; este de Norteamérica y cratones europeo y australiano en corteza estable; bases regionales de Chile, Japón, Taiwán y México junto con la compilación global NGA-Subduction en los regímenes de subducción— abarca el rango más amplio defendible de predicciones y reduce el riesgo de que la curva media quede dominada por un grupo estrecho de modelos con supuestos o datos de entrenamiento comunes [@NRCSSHAC2012]. Las comparaciones entre GMM requieren una operación distinta de la combinación de curvas de amenaza. Para una celda fija $\mathbf{x}=(M_w,R_{epi},h,T_n,V_{S30})$, cada rama $k$ aporta una distribución lognormal con mediana logarítmica $\mu_k(\mathbf{x})$ y desviación estándar logarítmica total $\sigma_k(\mathbf{x})$. La función de distribución acumulada de la mezcla ponderada es

$$
F_{S_a}(a\mid\mathbf{x}) = \sum_{k=1}^{N} w_k\,
\Phi\!\left[\frac{\ln a-\mu_k(\mathbf{x})}{\sigma_k(\mathbf{x})}\right].
$${#eq-gmm-grid-mixture}

Los cuantiles tabulados se obtienen invirtiendo numéricamente esta función, mientras que la media aritmética de la mezcla se evalúa directamente:

$$
S_a^{(p)}(\mathbf{x})=F_{S_a}^{-1}(p\mid\mathbf{x}),
\quad p\in\{0.05,0.10,0.16,0.50,0.84,0.90,0.95\},
\qquad
E[S_a\mid\mathbf{x}]
=\sum_{k=1}^{N}w_k\exp\!\left[\mu_k(\mathbf{x})+\frac{\sigma_k^2(\mathbf{x})}{2}\right].
$${#eq-gmm-grid-products}

La separación entre las medianas de rama representa la dispersión epistémica entre modelos y cada $\sigma_k$ conserva la variabilidad aleatoria de su formulación. La banda p5–p95 está delimitada por los percentiles 5 y 95 de la distribución condicional mezclada y reúne ambas contribuciones. Esta mezcla por celda se emplea en las curvas de atenuación, los espectros comparativos y las evaluaciones condicionales de escenario. En el PSHA, cada rama se integra por separado antes de ponderar las curvas de amenaza; los espectros uniformes de amenaza resultantes constituyen la entrada espectral de la estimación probabilística de desplazamientos de Newmark, de modo que la influencia de los GMM se transfiere a esa etapa a través de esos espectros [@VerriKozlowski2026Newmark].
