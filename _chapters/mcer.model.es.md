
La demanda sísmica de las estructuras convencionales se establece de acuerdo con ASCE/SEI 7-22 a partir de los espectros de amenaza y respuesta de sitio desarrollados en la Parte I. La Sección 11.4.7 remite a los procedimientos específicos del sitio de las Secciones 21.1 y 21.2; cuando se aplican esos procedimientos, el espectro de diseño y sus parámetros se determinan conforme a las Secciones 21.3 y 21.4 [@ASCE722, secs. 11.4.7, 21.1--21.4].

La componente probabilística del espectro MCER se evalúa, para cada período $T_n$ y condición $V_{S30}$, a partir de la variable aleatoria resultante $S_a(T_n)$, cuya función de distribución acumulada $G$ se define en [-@eq-site-branch-mixture]. Para cada período de retorno $T_R$, la ordenada considerada es su media aritmética $\mu=E[S_a]$, definida en [-@eq-site-branch-mean], y la tasa anual de excedencia asociada es $1/T_R$, conforme a [-@eq-hazard-return-period]. Los pares $(\mu,1/T_R)$ correspondientes a los períodos de retorno disponibles constituyen la curva de entrada al procedimiento de ajuste por riesgo de la Sección 21.2.1.

El ajuste por riesgo representa la fragilidad prescrita por la Sección 21.2.1 mediante la variable aleatoria $C_x$, correspondiente a la capacidad espectral de colapso asociada a una ordenada candidata $x$:

$$
\ln C_x\sim\mathcal N\!\left(\mu_{\ln C},\sigma_{\ln C}^{2}\right).
$${#eq-structures-collapse-capacity}

En esta expresión, $\mu_{\ln C}$ y $\sigma_{\ln C}$ son la media y la desviación estándar de $\ln C_x$, respectivamente. Para cada $x$,

$$
\mu_{\ln C}
=\ln x-\Phi^{-1}(0.10)\sigma_{\ln C},
\qquad
\sigma_{\ln C}=0.60,
$$

de modo que $P[C_x\leq x]=0.10$. $C_x$ representa la fragilidad genérica adoptada por el procedimiento de ajuste por riesgo y no una capacidad calculada para las estructuras del sitio [@ASCE722, sec. 21.2.1; @Luco2007].

En el cálculo de riesgo, la medida de intensidad $I$ de [-@eq-hazard-sum] corresponde a $S_a(T_n)$. La tasa anual de colapso asociada a la ordenada candidata $x$ es

$$
\lambda_C(x)
=\int_0^\infty
\lambda_I(i^*)\,f_{C_x}(i^*)\,\mathrm{d}i^*,
$${#eq-structures-collapse-rate}

donde $f_{C_x}$ es la función de densidad de la capacidad definida en [-@eq-structures-collapse-capacity], y $\lambda_I(i^*)$ representa la curva determinada por los pares $(\mu,1/T_R)$ del párrafo anterior. La ordenada probabilística corresponde al valor de $x$ que satisface

$$
1-\exp\!\left[-50\,\lambda_C(x)\right]=0.01.
$${#eq-structures-probabilistic-ordinate}

Esta evaluación se realiza separadamente para cada $T_n$ y condición $V_{S30}$.

ASCE/SEI 7-22 requiere que las ordenadas espectrales del MCER representen la respuesta máxima en el plano horizontal. Cuando el GMM proporciona la media geométrica o una medida similar de las dos componentes horizontales, la Sección 21.2 establece factores direccionales de 1.20 para $T_n\leq0.2$ s, 1.25 para $T_n=1.0$ s y 1.30 para $T_n\geq10$ s [@ASCE722, sec. 21.2]. Para establecer una definición común entre los GMM horizontales, el modelo de amenaza transforma las componentes RotD50, GMRotI50 y horizontal aleatoria a media geométrica antes de combinar las ramas; los modelos definidos para la componente vertical no intervienen en esta combinación. Las ordenadas expresadas en media geométrica se convierten posteriormente a respuesta máxima en el plano horizontal mediante los factores direccionales indicados.

La contribución de los escenarios a la componente determinística del espectro MCER se obtiene, para cada $T_n$ y $V_{S30}$, como

$$
S_a^{(84\%)}(T_n)=\max_{e\in\mathcal E}Q(0.84\mid e).
$${#eq-structures-scenario-84}

donde $\mathcal E$ reúne los escenarios sísmicos incluidos en el análisis. Las ordenadas $\underline{S}_a(T_n)$ de la Tabla 21.2-1 constituyen el límite inferior prescrito para el espectro determinístico MCER correspondiente a la clase de sitio utilizada para la condición $V_{S30}$ evaluada. La componente determinística se establece, para cada $T_n$, como

$$
\max\!\left[S_a^{(84\%)}(T_n),\underline{S}_a(T_n)\right].
$${#eq-structures-deterministic-component}

La ordenada MCER específica del sitio es el menor valor entre la componente probabilística y la componente determinística [@ASCE722, sec. 21.2.3]. La componente probabilística es la solución de [-@eq-structures-probabilistic-ordinate], expresada mediante $\lambda_C^{-1}$, la función inversa de la tasa de colapso definida en [-@eq-structures-collapse-rate]. Para cada $T_n$ y condición $V_{S30}$,

$$
S_{aM}(T_n)
=\min\!\left[
\lambda_C^{-1}\!\left(-\frac{\ln 0.99}{50}\right),
\max\!\left[S_a^{(84\%)}(T_n),\underline{S}_a(T_n)\right]
\right].
$${#eq-structures-mcer-ordinate}

De acuerdo con la Sección 21.3, las aceleraciones espectrales de diseño se obtienen a partir de las ordenadas MCER de [-@eq-structures-mcer-ordinate] mediante

$$
S_a(T_n)=\frac{2}{3}S_{aM}(T_n).
$${#eq-structures-design-spectrum}

Cuando los sismos de diseño se determinan mediante el procedimiento específico del sitio^[El procedimiento específico del sitio de ASCE/SEI 7-22 abarca la determinación completa de los movimientos del suelo mediante análisis propios del sitio: la componente probabilística de la Sección 21.2.1, la determinística de la Sección 21.2.2 y, cuando corresponde, el análisis de respuesta de sitio de la Sección 21.1, en oposición al procedimiento general de la Sección 11.4.6.], de acuerdo con la Sección 21.3, los parámetros de aceleración de diseño se calculan como [@ASCE722, sec. 21.4]

$$
\begin{aligned}
S_{DS}
  &=0.9\max_{T\in[0.2,5]\,\mathrm{s}}S_a(T),\\
S_{D1}
  &=\max\!\left[
      0.9\max_{T\in[1,T^*]\,\mathrm{s}}\bigl(T\,S_a(T)\bigr),
      S_a(1\,\mathrm{s})
    \right],\\
T^*
  &=\begin{cases}
      2\,\mathrm{s}, & V_{S30}>442\,\mathrm{m/s},\\
      5\,\mathrm{s}, & V_{S30}\leq442\,\mathrm{m/s}.
    \end{cases}
\end{aligned}
$${#eq-structures-design-parameters}

Los parámetros MCER correspondientes se recuperan de los valores de diseño mediante

$$
S_{MS}=1.5S_{DS},\qquad S_{M1}=1.5S_{D1}.
$${#eq-structures-mcer-parameters}

El capítulo conserva los espectros MCER específicos del sitio para las condiciones de $V_{S30}$ evaluadas, con una ordenada por cada período de las curvas de amenaza; los resultados reportan la PGA MCER y las ordenadas espectrales máximas por condición de sitio.

La Sección 21.2.2 acota inferiormente el espectro determinístico mediante los valores tabulados de la Tabla 21.2-1 — la componente $\underline{S}_a(T_n)$ de [-@eq-structures-deterministic-component] —, definidos por clase de sitio entre $T=0$ y 10 s e incluyendo la PGA, y admite una excepción: cuando el espectro probabilístico se mantiene por debajo de esos valores en todos los períodos, la demanda determinística no se calcula [@ASCE722, sec. 21.2.2]. La verificación de esa excepción consiste en comparar el espectro probabilístico con los valores tabulados en cada condición de sitio evaluada. El piso del 80% de la Sección 21.2.3 se ancla a la base de datos geoespacial de diseño sísmico del USGS y su aplicación se limita a la cobertura de esa base [@ASCE722, sec. 21.2.3].


Además del espectro de diseño específico del sitio, el reporte incluye el espectro de diseño en forma de código de la Sección 11.4.5 de ASCE/SEI 7-22, construido por tramos a partir de los parámetros $S_{DS}$ y $S_{D1}$. Con $T_0=0.2\,S_{D1}/S_{DS}$ y $T_S=S_{D1}/S_{DS}$,

$$
S_a(T_n)=
\begin{cases}
S_{DS}\left(0.4+0.6\,\dfrac{T_n}{T_0}\right), & T_n<T_0,\\[4pt]
S_{DS}, & T_0\leq T_n\leq T_S,\\[4pt]
\dfrac{S_{D1}}{T_n}, & T_n>T_S,
\end{cases}
$${#eq-structures-code-spectrum}

con las ordenadas en $g$. Fuera del alcance de los mapas de la Sección 22 no se adopta un período de transición de período largo $T_L$; la rama $S_{D1}/T_n$ se extiende hasta el fin de la malla de períodos [@ASCE722, sec. 11.4.5].
