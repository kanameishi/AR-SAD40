La evaluación determinística caracteriza la demanda sísmica mediante un conjunto finito de escenarios de ruptura postulados. Cada escenario representa el sismo máximo creíble (MCE) de una fuente: el mayor terremoto razonablemente concebible a lo largo de una falla reconocida o dentro de una provincia tectónica geográficamente definida, bajo el marco tectónico actualmente conocido [@ICOLD2016]. Cada escenario conserva la identidad de la fuente tectónica, su régimen tectónico, la magnitud de momento adoptada, la geometría de ruptura y las distancias fuente--sitio requeridas por los modelos de predicción de movimiento sísmico. El objetivo es obtener la distribución condicional de la aceleración espectral para cada escenario y construir, período por período, las envolventes determinísticas empleadas en la comparación con la amenaza probabilística.

La construcción de los escenarios parte de la caracterización tectónica adoptada para cada fuente: régimen tectónico, magnitud y variantes geométricas explícitas de la ruptura. Cada realización representa una de esas variantes, recibe el mismo peso y aporta el vector de distancias exigido por los modelos de predicción de movimiento sísmico. El árbol lógico correspondiente al régimen tectónico aporta las ramas de modelo y sus pesos; cada combinación de realización de ruptura y rama GMM constituye una componente de la distribución del escenario [@OpenQuakeEngine].


La evaluación probabilística integra la probabilidad condicional de excedencia respecto de la recurrencia de las fuentes, mientras que la evaluación determinística calcula esa misma probabilidad condicionada a la ocurrencia del escenario postulado. Para el escenario $e=(m_e,\mathbf r_e,\boldsymbol\theta_e)$, $m_e$ es la magnitud de momento, $\mathbf r_e$ reúne las distancias fuente--sitio y $\boldsymbol\theta_e$ contiene los restantes parámetros de ruptura y la condición de sitio. La intensidad $I$ representa la ordenada máxima horizontal $S_a(T_n)$ al período $T_n$, y $i^*$ es el nivel cuya excedencia se evalúa.

Para una realización de ruptura $r$ y una rama GMM $g$, el logaritmo de la intensidad se representa mediante una distribución normal con media $\mu_{rg}=\ln\hat\eta_I(m_e,\mathbf r_r,F,S)$, evaluada con la formulación correspondiente, y desviación estándar $\sigma_{rg}=\sigma_{\ln I}$. En esta expresión, $\hat\eta_I$ es la mediana de la intensidad en unidades lineales, $\mathbf r_r$ es el vector de distancias de la realización, $F$ representa el estilo de falla y $S$ la condición de sitio. Al identificar cada par $(r,g)$ mediante $k$, el peso de la componente es

$$
w_k=\frac{v_g}{N_R},\qquad \sum_k w_k=1,
$${#eq-scenario-weights}

donde $v_g$ es el peso de la rama $g$ del árbol lógico y $N_R$ es el número de variantes explícitas de ruptura, representadas por realizaciones equiponderadas. La probabilidad condicional de excedencia del escenario se obtiene como

$$
P\!\left[I>i^*\mid e\right]=\sum_k w_k\left[1-\Phi\!\left(\frac{\ln i^*-\mu_k}{\sigma_k}\right)\right],
$${#eq-dsha-exceedance}

donde $\mu_k$ y $\sigma_k$ corresponden a la componente $k$ y $\Phi$ es la función de distribución acumulada normal estándar. La función de distribución acumulada condicional de la intensidad es el complemento de la excedencia:

$$
G(a\mid e)=\sum_k w_k\,\Phi\!\left(\frac{\ln a-\mu_k}{\sigma_k}\right).
$${#eq-scenario-mixture}

Los fractiles se obtienen por inversión numérica de $G(\cdot\mid e)$, mientras que la media se calcula directamente a partir de las componentes lognormales:

$$
Q(p\mid e)=\inf\{a:G(a\mid e)\geq p\},\qquad E[S_a\mid e]=\sum_k w_k\exp\!\left(\mu_k+\tfrac12\sigma_k^2\right).
$${#eq-scenario-moments}

El cálculo obtiene para cada escenario siete fractiles y la media. La evaluación se realiza analíticamente a partir de $(\mu_k,\sigma_k,w_k)$; la comparación de este capítulo presenta la media de cada escenario y conserva el percentil 84 únicamente en la envolvente MCE (84%). Las ordenadas corresponden a la componente máxima horizontal con 5% de amortiguamiento crítico y se evalúan en la condición de referencia $V_{\mathrm{ref}}=760$ m/s; la PGA corresponde a $T_n=0$. Esta condición proporciona la referencia computacional desde la cual el modelo de respuesta de sitio deriva las condiciones de sitio efectivamente evaluadas (véase el capítulo de respuesta de sitio).

Los espectros de los escenarios permanecen separados y conservan la identidad física del terremoto de cada fuente en el rango de períodos. La nomenclatura del reporte define dos envolventes sobre el conjunto de escenarios $\mathcal E$ mediante una misma construcción: el máximo por período de las ordenadas de los escenarios para el estadístico reportado. La envolvente del fractil superior, reportada como MCE (84%), es

$$
S_a^{(84\%)}(T_n)=\max_{e\in\mathcal E}Q(0.84\mid e),
$${#eq-dsha-envelope}

un máximo sobre valores que no selecciona un escenario. La envolvente media, reportada como MCE, aplica la misma construcción a las medias de los escenarios, por lo que sus ordenadas tampoco pertenecen a un escenario individual. Ninguna de las dos envolventes identifica un par magnitud–distancia controlante. La comparación con la amenaza probabilística superpone la media y el percentil 84 de cada escenario a los espectros medios de amenaza uniforme disponibles y utiliza el espectro medio para $T_R=10{,}000$ años como nivel de comparación en los períodos seleccionados, junto con ambas envolventes determinísticas.
