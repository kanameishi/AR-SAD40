Las historias temporales constituyen la demanda sísmica de entrada de los análisis dinámicos de deformaciones y representan simultáneamente su amplitud, duración y contenido de frecuencias. El PGA caracteriza la amplitud máxima; la duración significativa, el número de ciclos próximos al máximo y la distribución de energía entre frecuencias describen características adicionales que intervienen en la deformación acumulada de taludes y terraplenes de materiales sin cohesión [@Kramer1997; @BrayTravasarou2007]. La selección de registros establece un conjunto de movimientos cuya demanda espectral es compatible con la banda objetivo, cuyas características temporales permanecen disponibles para los modelos dinámicos y cuyos eventos, estaciones y registros de origen quedan identificados.


Los movimientos seleccionados deben ser compatibles con la amenaza que controla el sitio, con el espectro objetivo adoptado y con las variables de respuesta del modelo dinámico, y deben representar la variabilidad registro a registro pertinente [@NIST2011]. El conjunto candidato se delimita mediante ventanas de magnitud y distancia fuente--sitio vinculadas con los escenarios que controlan la amenaza, identificados a partir del modelo de amenaza y su desagregación; los criterios de selección comprenden además el ambiente tectónico, las condiciones de sitio, la disponibilidad de componentes, el contenido de frecuencias utilizable y la calidad del registro [@BakerCornell2006]. Dentro de ese conjunto, la forma espectral se evalúa mediante la concordancia con la demanda objetivo en el intervalo de períodos del análisis —no mediante una regla separada de espectro condicional o basada en épsilon— y se retiene como máximo un registro por evento. El espectro objetivo corresponde a la ordenada de diseño de la demanda adoptada para el sitio —la media o un fractil de diseño, según la demanda— y las envolventes inferior y superior a fractiles bajo y alto de esa misma demanda; las envolventes definen el rango admisible alrededor del objetivo para el conjunto ajustado. La malla incluye $T_n=0$ como ordenada de PGA y los períodos positivos del análisis. La evaluación conserva los identificadores del evento, la estación, el registro y la red o base de datos de origen, junto con las medidas de intensidad utilizadas para caracterizar el conjunto. No se aplican filtros adicionales por ambiente tectónico ni por $V_{S30}$ de la estación.

El mapeo determinístico de canales clasifica las tres direcciones registradas en las componentes canónicas H1, H2 y UP, y la rotación de las dos horizontales a sus ejes principales define H1 y H2, con el ángulo de rotación registrado por registro. El ajuste espectral y la verificación se realizan sobre H1, de modo que la tabla de registros, las medidas de intensidad y los espectros reportados corresponden a una definición única de movimiento horizontal.


El procedimiento no modifica el contenido de frecuencias de los registros para reproducir el espectro objetivo. El ajuste se limita a la amplitud de los modos retenidos y a un factor de escala por registro, de manera que cada historia conserva las fases, la secuencia de ciclos y la no estacionariedad del movimiento registrado —las propiedades que intervienen en la deformación acumulada de taludes y terraplenes—. La compatibilidad del conjunto con la banda objetivo se alcanza en la media espectral y en la contención de los espectros individuales.

La descomposición modal empírica introdujo las funciones modales intrínsecas como componentes adaptativas derivadas de los datos para series temporales no lineales y no estacionarias [@HuangEtAl1998]. El procedimiento adoptado utiliza la descomposición modal variacional (VMD), que representa una señal no estacionaria como un conjunto de modos con bandas de frecuencia compactas y un residuo [@DragomiretskiyZosso2014]; las historias canónicas del registro completo se descomponen componente por componente. Para la componente H1 del registro $i$,

$$
x_i(t)=\sum_{m=1}^{K_i}x_i^{(m)}(t)+r_i(t),
$${#eq-srs-vmd}

donde $x_i(t)$ es la aceleración registrada, $x_i^{(m)}(t)$ es el modo $m$ del registro $i$, $K_i$ es el número de modos y $r_i(t)$ es el residuo. El procedimiento excluye IMF1, la componente de baja frecuencia asociada con la deriva y el ruido, y define con los modos restantes el conjunto retenido $\mathcal{M}_i$. El ajuste aplica por registro multiplicadores de amplitud acotados $b_i^{(m)}$,

$$
\widetilde{x}_i(t;\mathbf b_i)=\sum_{m\in\mathcal{M}_i}b_i^{(m)}\,x_i^{(m)}(t),
$${#eq-srs-reconstruction}

y conserva las frecuencias centrales y las fases de los modos retenidos.

La compatibilidad se evalúa con el operador de aceleración pseudoespectral

$$
S_{a,j}[z]=S_a[z](T_j,\xi),
$${#eq-srs-sa}

donde $z(t)$ es una historia de aceleración, $T_j$ es un período objetivo y $\xi=5\%$ es la razón de amortiguamiento; $s_{ij}(\mathbf b_i)=S_{a,j}\!\left[\widetilde{x}_i(\mathbf b_i)\right]$ es la ordenada reconstruida del registro $i$. Con $y_j$, $l_j$ y $u_j$ como el objetivo y las envolventes inferior y superior en $T_j$, el desajuste normalizado por el objetivo y la salida de banda del registro son

$$
\mathrm{RMSE}_i(\mathbf b_i)=\left[\frac{1}{J}\sum_{j=1}^{J}\left(\frac{s_{ij}(\mathbf b_i)-y_j}{y_j}\right)^{2}\right]^{1/2},
\qquad
v_{ij}(\mathbf b_i)=\max\!\left\{\frac{l_j-s_{ij}(\mathbf b_i)}{l_j},\;\frac{s_{ij}(\mathbf b_i)-u_j}{u_j},\;0\right\}.
$${#eq-srs-modal-misfit}

Los multiplicadores se obtienen minimizando, con $b_i^{(m)}=b_{i,0}^{(m)}\,e^{\theta_i^{(m)}}$ y dentro de sus cotas, el objetivo regularizado

$$
L_i(\boldsymbol\theta_i)=\mathrm{RMSE}_i^{2}(\boldsymbol\theta_i)
+\lambda_{\mathrm{env}}\,\frac{1}{J}\sum_{j=1}^{J}v_{ij}^{2}(\boldsymbol\theta_i)
+\lambda_{\mathrm{mov}}\,\frac{1}{|\mathcal{M}_i|}\sum_{m\in\mathcal{M}_i}\bigl(\theta_i^{(m)}\bigr)^{2},
$${#eq-srs-modal-objective}

donde $b_{i,0}^{(m)}$ es el valor inicial del multiplicador: el primer término reduce el desajuste respecto del objetivo, el segundo penaliza las salidas de la banda y el tercero limita el movimiento innecesario de los multiplicadores retenidos. La minimización aplica un número deliberadamente acotado de iteraciones, de modo que el ajuste permanece próximo al movimiento registrado.

Después del ajuste modal, el factor

$$
e_i=\left[\frac{\sum_t x_i^2(t)}{\sum_t\widetilde{x}_i^2(t;\mathbf b_i)}\right]^{1/2},
\qquad y_i(t)=e_i\widetilde{x}_i(t;\mathbf b_i),
$${#eq-srs-energy}

normaliza la energía cuadrática de la señal reconstruida respecto de la historia registrada; la normalización preserva la norma cuadrática discreta de la aceleración del registro tras la reconstrucción, y la contribución efectiva del modo $m$ es $e_i\,b_i^{(m)}\,x_i^{(m)}(t)$. Esta etapa elimina la componente de baja frecuencia asociada con la deriva y el ruido y mantiene la estructura temporal de los modos que representan el movimiento en la condición de referencia [@VerriKozlowskiInPress].


Cada historia reconstruida y normalizada recibe un coeficiente positivo $c_i$,

$$
Y_i(t)=c_i y_i(t)=c_i e_i\sum_{m\in\mathcal{M}_i}b_i^{(m)}x_i^{(m)}(t),
$${#eq-srs-final}

de modo que $Y_i(t)$ es la componente H1 final empleada en los análisis. Los coeficientes $c_i$ se determinan conjuntamente, como un problema cuadrático acotado sobre el conjunto completo, para reproducir la media espectral objetivo y contener los espectros individuales dentro de la banda prescrita. La función objetivo es

$$
\begin{aligned}
\min_{c_i>0}\quad &\frac{1}{J}\sum_{j=1}^{J}w_j r_j^2
+\frac{\lambda_B}{NJ}\sum_{i=1}^{N}\sum_{j=1}^{J}v_{ij}^2,\\
&w_j=\begin{cases}
\lambda_D,&r_j<0,\\
1,&r_j\geq0,
\end{cases}
\end{aligned}
$${#eq-srs-objective}

con

$$
r_j=\frac{\overline S_a(T_j)-S_a^t(T_j)}{S_a^t(T_j)},
\qquad
\overline S_a(T_j)=\frac{1}{N}\sum_{i=1}^{N}c_iS_{a,j}[y_i],
$${#eq-srs-residual}

y la salida de banda evaluada sobre los espectros escalados $c_iS_{a,j}[y_i]$ con la misma forma que en el ajuste modal. Aquí, $N$ es el número de registros, $J$ es el número de períodos objetivo, $S_a^t$ es el espectro objetivo, $\lambda_B$ pondera la contención de los espectros individuales y $\lambda_D\geq1$ pondera los déficits de la media del conjunto. El valor $\lambda_D=1$ produce una ponderación simétrica de los residuales positivos y negativos.

La verificación final calcula el RMSE relativo de $\overline S_a$ respecto de $S_a^t$, la razón entre el PGA medio del conjunto y el PGA objetivo, la fracción de ordenadas registro--período contenidas por las envolventes y el intervalo de coeficientes $c_i$. El conjunto entregado conserva las historias de aceleración, velocidad y desplazamiento utilizadas en los análisis dinámicos, las medidas acumuladas y escalares de intensidad, las duraciones significativas, los espectros PSA y los metadatos de procedencia de eventos y estaciones. En este capítulo se reportan la tabla de registros seleccionados y la comparación PSA de H1 con el espectro objetivo.
