Los sismos de diseño se definen para las condiciones $V_{S30}$ evaluadas en el sitio a partir de la demanda espectral en superficie. La evaluación representa estos efectos mediante dos estimaciones alternativas de la demanda espectral en superficie y combina las distribuciones de probabilidad correspondientes para definir la demanda de diseño en cada período estructural, período de retorno y condición $V_{S30}$.

El árbol lógico de GMM se evalúa en el modelo de amenaza para las condiciones $V_{S30}$ del proyecto (`r paste(Vs30.gmdp, collapse = ", ")` m/s). Cada modelo incorpora su término empírico de sitio al estimar $S_a(T_n,V_{S30})$; los pesos del árbol lógico representan las alternativas epistémicas adoptadas y la variabilidad aleatoria de cada modelo queda integrada en las curvas de excedencia. La evaluación conserva, por tanto, la misma caracterización de fuentes y de movimiento del suelo utilizada en la evaluación en roca; los términos de sitio se evalúan para cada valor de $V_{S30}$ analizado. El término de sitio de las GMM y el modelo externo representan respuestas ergódicas medias derivadas de conjuntos de registros.

La demanda calculada para la condición de referencia $V_{\mathrm{ref}}=760\,\mathrm{m/s}$ constituye la entrada del modelo ergódico de amplificación de sitio de NGA-East (ST20), desarrollado por Stewart *et al.* [-@Stewart2020] y Hashash *et al.* [-@Hashash2020]. Para cada período $T_n$, condición $V_{S30}$ y realización del PGA de entrada $pga^*$, el factor $F$ se modela como una variable aleatoria lognormal cuyo logaritmo natural tiene media $\mu_{\ln F}$ y desviación estándar $\sigma_{\ln F}$,

$$
\ln F \sim \mathcal{N}\!\left(\mu_{\ln F},\;\sigma_{\ln F}^{2}\right),
$${#eq-site-lnf}

donde $\mu_{\ln F}$ es la log-amplificación media condicional y $\sigma_{\ln F}$ es la dispersión total del modelo. La media combina el ajuste entre las referencias de 760 y 3000 m/s, el término lineal dependiente de $V_{S30}$ y el término no lineal dependiente de $pga^*$. La dispersión se expresa como

$$
\sigma_{\ln F}^{2}=\sigma_L^{2}+\sigma_I^{2}+\sigma_{NL}^{2},
$${#eq-site-sigma-decomp}

donde $\sigma_L$ corresponde al término lineal de sitio, $\sigma_I$ al cambio entre horizontes de referencia y $\sigma_{NL}$ al término no lineal dependiente de la intensidad. La formulación de los componentes y el tratamiento de la referencia se detallan a continuación.

$S_a^o(T_n)$ y $\mathrm{PGA}^o$ denotan las ordenadas calculadas por OpenQuake con los GMM para la condición de referencia adoptada. Esta condición es 760 m/s en la evaluación actual y puede ser 3000 m/s cuando la entrada corresponde a la referencia de roca dura.

Para cada período y período de retorno, la distribución de $S_a^o$ se representa mediante un sustituto lognormal calibrado con la media aritmética y los siete cuantiles publicados por el cálculo de amenaza: la media se preserva exactamente y la desviación logarítmica $\sigma_o$ se ajusta a los cuantiles,

$$
\ln S_a^o \sim \mathcal N\!\left(\ln\mu^o-\tfrac{\sigma_o^2}{2},\;\sigma_o^2\right),
$${#eq-site-oq-surrogate}

donde $\mu^o=E[S_a^o]$ es la media aritmética reportada. Los cuantiles publicados de la evaluación directa corresponden a este sustituto y no a los fractiles crudos del árbol lógico. La ordenada obtenida con ST20 es

$$
S_a^s\!\left(T_n,V_{S30}\right)=F\!\left(T_n,V_{S30},\mathrm{PGA}^o\right)\,S_a^o\!\left(T_n\right).
$${#eq-site-af}

La evaluación considera por separado la distribución de $S_a^o$, obtenida con los GMM para el $V_{S30}$ analizado, y la distribución de $S_a^s$, obtenida con ST20. La distribución resultante se define como una mezcla finita de ambas; su formulación y sus estadísticas se presentan en la sección de incertidumbre.
