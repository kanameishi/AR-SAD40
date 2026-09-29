```{r}
#| include: false
source(file.path(root, "scripts", "setup", "hazardContext.R"))
```

El análisis probabilístico de amenaza sísmica (PSHA) cuantifica la tasa con la que distintos niveles de movimiento del suelo pueden excederse en el sitio. La evaluación representa el rango de magnitudes, ubicaciones y movimientos del suelo mediante el modelo de fuentes sísmicas y los modelos de predicción de movimiento sísmico, y aplica el teorema de probabilidad total sobre los escenarios que pueden contribuir a la demanda [@Cornell1968; @McGuire2004].

`r MODEL.ES`

Para una fuente sísmica $s$, $\nu_{0}^{ (s)}$ es su tasa anual de ocurrencia por encima de la magnitud mínima $M_{\min}$, $m$ es la magnitud de momento y $\mathbf r$ reúne las métricas de distancia fuente--sitio requeridas por los GMM. El dominio $D$ comprende las ubicaciones y geometrías de ruptura admisibles para la fuente. Las funciones $f_{M,s} (m)$ y $f_{\mathbf{R}\mid M,s} (\mathbf r\mid m)$ describen las distribuciones normalizadas de magnitud y distancia, $M_{\max}^{ (s)}$ es el límite superior de magnitud de la fuente, $I$ es la medida de intensidad y $i^*$ el nivel cuya excedencia se evalúa. Con estas definiciones, la contribución de la fuente es

$$
\lambda_I (i^*)^{ (s)} \;=\; \nu_{0}^{ (s)} \int_{M_{\min}}^{M_{\max}^{ (s)}} \int_{D} P\left[ I > i^* \,\big|\, m, \mathbf{r} \right]\; f_{M,s} (m)\; f_{\mathbf{R}\mid M,s} (\mathbf{r}\mid m)\; \mathrm d\mathbf{r}\,\mathrm dm
$${#eq-hazard-integral}

Las funciones de densidad de probabilidad (PDF) $f_{M,s} (m)$ y $f_{\mathbf{R}\mid M,s} (\mathbf{r}\mid m)$ describen las distribuciones normalizadas de magnitudes y ubicaciones de sismos dentro de la fuente $(s)$. Esta formulación es una aplicación directa del teorema de la probabilidad total en forma continua, integrando sobre todas las magnitudes y ubicaciones de los sismos respecto de la fuente $(s)$ que podrían contribuir a la excedencia del nivel $i^*$. La variabilidad aleatoria representada en los modelos de recurrencia, magnitud, ubicación y movimiento del suelo se propaga a través de la integración [@McGuire2004; @Baker2021].

Si múltiples fuentes sísmicas contribuyen a la amenaza en el sitio, la tasa anual de excedencia total $\lambda_I (i^*)$ se obtiene sumando las contribuciones de todas las fuentes como en [-@eq-hazard-sum]. Suponiendo $N_S$ fuentes independientes, cada una con su propia tasa de ocurrencia y distribuciones, la frecuencia de excedencia global para el nivel $i^*$ se da en [-@eq-hazard-sum], donde $\lambda_I (i^*)^{ (s)}$ se evalúa para cada fuente mediante la integral de amenaza. Esta superposición lineal es válida bajo el supuesto de que las ocurrencias de sismos en las diferentes fuentes son independientes, modeladas típicamente como procesos de Poisson independientes. El resultado es una curva de amenaza sísmica que cuantifica la tasa a la cual diversos niveles de movimiento del suelo son excedidos en el sitio.

$$
\lambda_I (i^*) \;=\; \sum_{s=1}^{N_S} \lambda_I (i^*)^{ (s)}
$${#eq-hazard-sum}

El modelo de predicción de movimiento sísmico interviene en el PSHA mediante su mediana $\hat{\eta}_I$ y su desviación estándar total $\sigma_{\ln I}$. Variaciones entre GMPE competidoras en cualquiera de estas cantidades modifican las tasas de excedencia, particularmente en períodos de retorno largos, donde la integral pondera la cola superior de la distribución lognormal [@OpenQuakeEngine].

La frecuencia anual de excedencia $\lambda_I (i^*)$ obtenida de la integral de amenaza [-@eq-hazard-integral] es el número medio de excedencias por año del nivel $i^*$. Las curvas denominadas **AEP** en este reporte reportan esa tasa, en $1/\text{año}$. Si las excedencias siguen un proceso de Poisson en el tiempo, la probabilidad exacta de al menos una excedencia durante un año se obtiene mediante [-@eq-aep]. Para tasas pequeñas, $P_{1\text{yr}} \approx \lambda_I$, porque $e^{-\lambda}\approx1-\lambda$.

$$
P_{1\text{yr}}[I > i^*] = 1 - \exp[-\lambda_I (i^*)]
$${#eq-aep}

Por extensión, la probabilidad de excedencia en $T$ años es $P_{T} (I > i^*) = 1 - \exp[-\lambda_I (i^*) T]$ bajo estacionariedad. Esta relación convierte la tasa anual media en la probabilidad del intervalo de exposición. El **período de retorno** $T_R$ se define mediante

$$
T_R=\frac{1}{\lambda_I (i^*)}.
$${#eq-hazard-return-period}

