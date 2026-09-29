La evaluación con ST20 se realiza período por período y queda condicionada al PGA de la misma realización a través del término no lineal de $F$. En escala logarítmica, [-@eq-site-af] se expresa como $\ln S_a^s=\ln S_a^o+\ln F$. Para una componente $k$ de la distribución de $S_a^o$ y una realización $\mathrm{PGA}^o=pga^*$, con $q=\ln pga^*$, $\sigma_k$ es la desviación estándar de $\ln S_a^o(T_n)$ en la componente, $\rho=\operatorname{Corr}\!\left[\ln S_a^o(T_n),\ln \mathrm{PGA}^o\right]$ es la correlación intraevento entre la ordenada espectral y el PGA, y $\sigma_{\ln F}=\sigma_{\ln F}(T_n,V_{S30},e^q)$ es la desviación estándar de $\ln F$ para el período, la condición de sitio y el PGA condicionante $pga^*=e^q$; la varianza condicional de $\ln S_a^s$ es

$$
\operatorname{Var}\!\left[\ln S_a^s\mid k,q\right]=\left(1-\rho^2\right)\sigma_k^2+\sigma_{\ln F}^{2}.
$${#eq-site-var}

La dependencia entre $S_a^o(T_n)$ y $F$ se incorpora mediante el PGA de la misma realización, que condiciona el término no lineal de ST20. Una vez fijados la componente $k$ y ese PGA, el modelo no dispone de un parámetro que represente una correlación residual adicional entre la ordenada espectral y el factor de amplificación. La evaluación adopta, por tanto, independencia condicional entre ambos residuos, evitando introducir una covarianza no calibrada. Para los escenarios determinísticos, la demanda espectral en la condición de referencia se representa mediante la mezcla analítica de [-@eq-scenario-mixture]. En cada componente $k$, $(\mu_{P,k},\sigma_{P,k})$ son la media y la desviación estándar de $\ln \mathrm{PGA}^o$, mientras que $(\mu_k,\sigma_k)$ son la media y la desviación estándar de $\ln S_a^o(T_n)$. Condicionada a la componente y a una realización $\mathrm{PGA}^o=pga^*$, con $q=\ln pga^*$, y con $\mu_{\ln F}=\mu_{\ln F}(T_n,V_{S30},e^q)$ y $\sigma_{\ln F}=\sigma_{\ln F}(T_n,V_{S30},e^q)$ evaluadas para el período, la condición de sitio y el PGA condicionante, la ordenada obtenida con ST20 presenta la distribución

$$
\begin{aligned}
\ln S_a^s\mid(k,q)&\sim\mathcal{N}\!\left(\mu_k(q),\varsigma_k^2(q)\right),\\
\mu_k(q)&=\mu_k+\rho\frac{\sigma_k}{\sigma_{P,k}}(q-\mu_{P,k})+\mu_{\ln F},\\
\varsigma_k^2(q)&=\left(1-\rho^2\right)\sigma_k^2+\sigma_{\ln F}^{2}.
\end{aligned}
$${#eq-site-conditional}

La función de distribución acumulada de $S_a^s$ se obtiene integrando su distribución condicional respecto de $q=\ln pga^*$ en cada componente, donde $y>0$ es un valor de aceleración espectral en las mismas unidades que $S_a^s$, $w_k$ es el peso de la componente, $\mu_k(q)$ y $\varsigma_k(q)$ son, respectivamente, la media y la desviación estándar condicionales de $\ln S_a^s$ definidas en [-@eq-site-conditional], y $\Phi$ y $\varphi$ son la función de distribución acumulada y la densidad normal estándar:

$$
G^s(y)=P\!\left[S_a^s\leq y\right]=\sum_k w_k\int_{-\infty}^{\infty}\Phi\!\left(\frac{\ln y-\mu_k(q)}{\varsigma_k(q)}\right)\varphi\!\left(\frac{q-\mu_{P,k}}{\sigma_{P,k}}\right)\frac{\mathrm{d}q}{\sigma_{P,k}}.
$${#eq-site-mixture}

Los cuantiles de $G^s$ definen los fractiles determinísticos de $S_a^s$, y su media se evalúa con los momentos condicionales correspondientes de [-@eq-scenario-moments]. En la evaluación probabilística, la demanda espectral en superficie se caracteriza, para cada período $T_n$, período de retorno $T_R$ y condición $V_{S30}$, mediante dos distribuciones de probabilidad. La primera corresponde a la respuesta de sitio que los modelos de predicción de movimiento sísmico (GMM) evalúan directamente para ese valor de $V_{S30}$, representada por el sustituto lognormal de [-@eq-site-oq-surrogate]; la segunda resulta de aplicar ST20 a la demanda calculada en la condición de referencia $V_{\mathrm{ref}}=760\,\mathrm{m/s}$. Las variables aleatorias $S_a^o$ y $S_a^s$ representan las aceleraciones espectrales resultantes, y $G^o(y)$ y $G^s(y)$ sus respectivas funciones de distribución acumulada. La función de distribución acumulada de la variable aleatoria resultante, $S_a$, es

$$
G(y)=P\!\left[S_a\leq y\right]=\alpha G^o(y)+(1-\alpha)G^s(y),
\qquad 0\leq\alpha\leq1.
$${#eq-site-branch-mixture}

En ausencia de evidencia específica del sitio que permita asignar mayor representatividad a una de las dos distribuciones, se adopta $\alpha=0.5$, sin interpretarlo como un valor calibrado. Este coeficiente podrá revisarse mediante un estudio de respuesta de sitio que contraste $G^o$ y $G^s$ con observaciones o simulaciones validadas de la relación entre la demanda en roca y en superficie, y estime $\alpha$ en el intervalo $[0,1]$ mediante un criterio de calibración explícito. La media aritmética de la distribución resultante, su cuantil de probabilidad $p$ —que se obtiene invirtiendo su función de distribución acumulada— y su varianza se presentan a continuación; en estas expresiones, $\mu^o=E[S_a^o]$ y $\mu^s=E[S_a^s]$ son las medias aritméticas de las dos distribuciones componentes, $\mu=E[S_a]$ es la media aritmética de la distribución resultante —todas expresadas en la escala natural de aceleración espectral, no en escala logarítmica— y $Q$ es la función cuantil de la distribución resultante:

$$
\mu=\alpha\mu^o+(1-\alpha)\mu^s.
$${#eq-site-branch-mean}

$$
Q(p)=\inf\{y:G(y)\geq p\},
\qquad 0<p<1.
$${#eq-site-branch-quantile}

$$
\operatorname{Var}(S_a)=\alpha\operatorname{Var}(S_a^o)+(1-\alpha)\operatorname{Var}(S_a^s)+\alpha(1-\alpha)(\mu^o-\mu^s)^2.
$${#eq-site-branch-variance}

Los dos primeros términos ponderan las varianzas de las distribuciones componentes, mientras que el último corresponde a la contribución asociada a la diferencia entre sus medias. La mezcla definida anteriormente especifica distribuciones marginales para cada período, pero no determina la dependencia entre períodos. En las operaciones que requieren ordenadas conjuntamente distribuidas —por ejemplo PGA, $S_a(1.3T_n)$ y $S_a(1.5T_n)$ para la evaluación de desplazamientos—, esa dependencia se representa con el modelo de Baker y Jayaram [-@BakerJayaram2008]. Para el tramo $T_{\min}>0.109$ s, con $T_{\min}=\min(T_i,T_j)$ y $T_{\max}=\max(T_i,T_j)$,

$$
\rho(T_i,T_j)=1-\cos\!\left(\frac{\pi}{2}-0.366\ln\frac{T_{\max}}{\max(T_{\min},0.109)}\right).
$${#eq-site-rho}

Cuando $T_{\min}\leq0.109\,\mathrm{s}$, la correlación se obtiene de las ramas correspondientes de la formulación de Baker y Jayaram [-@BakerJayaram2008, Ecs. 5--6]. El modelo es aplicable entre 0.01 y 10 s y es independiente de la magnitud y la distancia.
