The evaluation with ST20 is performed period by period and is conditioned on the PGA of the same realization through the nonlinear term of $F$. In logarithmic scale, [-@eq-site-af] is expressed as $\ln S_a^s=\ln S_a^o+\ln F$. For a component $k$ of the distribution of $S_a^o$ and a realization $\mathrm{PGA}^o=pga^*$, with $q=\ln pga^*$, $\sigma_k$ is the standard deviation of $\ln S_a^o(T_n)$ in the component, $\rho=\operatorname{Corr}\!\left[\ln S_a^o(T_n),\ln \mathrm{PGA}^o\right]$ is the within-event correlation between the spectral ordinate and the PGA, and $\sigma_{\ln F}=\sigma_{\ln F}(T_n,V_{S30},e^q)$ is the standard deviation of $\ln F$ for the period, the site condition, and the conditioning PGA $pga^*=e^q$; the conditional variance of $\ln S_a^s$ is

$$
\operatorname{Var}\!\left[\ln S_a^s\mid k,q\right]=\left(1-\rho^2\right)\sigma_k^2+\sigma_{\ln F}^{2}.
$${#eq-site-var}

The dependence between $S_a^o(T_n)$ and $F$ is incorporated through the PGA of the same realization, which conditions the nonlinear term of ST20. Once the component $k$ and that PGA are fixed, the model does not provide a parameter representing an additional residual correlation between the spectral ordinate and the amplification factor. The evaluation therefore adopts conditional independence between the two residuals, avoiding the introduction of an uncalibrated covariance. For the deterministic scenarios, the spectral demand at the reference condition is represented by the analytic mixture of [-@eq-scenario-mixture]. In each component $k$, $(\mu_{P,k},\sigma_{P,k})$ are the mean and standard deviation of $\ln \mathrm{PGA}^o$, while $(\mu_k,\sigma_k)$ are the mean and standard deviation of $\ln S_a^o(T_n)$. Conditional on the component and on a realization $\mathrm{PGA}^o=pga^*$, with $q=\ln pga^*$, and with $\mu_{\ln F}=\mu_{\ln F}(T_n,V_{S30},e^q)$ and $\sigma_{\ln F}=\sigma_{\ln F}(T_n,V_{S30},e^q)$ evaluated for the period, the site condition, and the conditioning PGA, the ordinate obtained with ST20 has the distribution

$$
\begin{aligned}
\ln S_a^s\mid(k,q)&\sim\mathcal{N}\!\left(\mu_k(q),\varsigma_k^2(q)\right),\\
\mu_k(q)&=\mu_k+\rho\frac{\sigma_k}{\sigma_{P,k}}(q-\mu_{P,k})+\mu_{\ln F},\\
\varsigma_k^2(q)&=\left(1-\rho^2\right)\sigma_k^2+\sigma_{\ln F}^{2}.
\end{aligned}
$${#eq-site-conditional}

The cumulative distribution function of $S_a^s$ is obtained by integrating its conditional distribution with respect to $q=\ln pga^*$ in each component, where $y>0$ is a spectral-acceleration value in the same units as $S_a^s$, $w_k$ is the component weight, $\mu_k(q)$ and $\varsigma_k(q)$ are, respectively, the conditional mean and standard deviation of $\ln S_a^s$ defined in [-@eq-site-conditional], and $\Phi$ and $\varphi$ are the standard-normal cumulative distribution function and density:

$$
G^s(y)=P\!\left[S_a^s\leq y\right]=\sum_k w_k\int_{-\infty}^{\infty}\Phi\!\left(\frac{\ln y-\mu_k(q)}{\varsigma_k(q)}\right)\varphi\!\left(\frac{q-\mu_{P,k}}{\sigma_{P,k}}\right)\frac{\mathrm{d}q}{\sigma_{P,k}}.
$${#eq-site-mixture}

The quantiles of $G^s$ define the deterministic fractiles of $S_a^s$, and its mean is evaluated with the corresponding conditional moments of [-@eq-scenario-moments]. In the probabilistic assessment, the surface spectral demand is characterized, for each period $T_n$, return period $T_R$, and $V_{S30}$ condition, by two probability distributions. The first corresponds to the site response that the ground-motion models (GMMs) evaluate directly for that $V_{S30}$ value, represented by the lognormal surrogate of [-@eq-site-oq-surrogate]; the second results from applying ST20 to the demand calculated at the reference condition $V_{\mathrm{ref}}=760\,\mathrm{m/s}$. The random variables $S_a^o$ and $S_a^s$ represent the resulting spectral accelerations, and $G^o(y)$ and $G^s(y)$ their respective cumulative distribution functions. The cumulative distribution function of the resulting random variable, $S_a$, is

$$
G(y)=P\!\left[S_a\leq y\right]=\alpha G^o(y)+(1-\alpha)G^s(y),
\qquad 0\leq\alpha\leq1.
$${#eq-site-branch-mixture}

In the absence of site-specific evidence that would assign greater representativeness to one of the two distributions, $\alpha=0.5$ is adopted, without interpreting it as a calibrated value. This coefficient may be revised through a site-response study that contrasts $G^o$ and $G^s$ with observations or validated simulations of the relation between the rock and surface demands, and estimates $\alpha$ in the interval $[0,1]$ through an explicit calibration criterion. The arithmetic mean of the resulting distribution, its probability-$p$ quantile —obtained by inverting its cumulative distribution function— and its variance follow; in these expressions, $\mu^o=E[S_a^o]$ and $\mu^s=E[S_a^s]$ are the arithmetic means of the two component distributions, $\mu=E[S_a]$ is the arithmetic mean of the resulting distribution —all expressed on the natural spectral-acceleration scale, not on the logarithmic scale— and $Q$ is the quantile function of the resulting distribution:

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

The first two terms weight the variances of the component distributions, while the last corresponds to the contribution associated with the difference between their means. The mixture defined above specifies marginal distributions for each period but does not determine the dependence between periods. In operations requiring jointly distributed ordinates —for example PGA, $S_a(1.3T_n)$, and $S_a(1.5T_n)$ for the displacement evaluation—, that dependence is represented with the model of Baker and Jayaram [-@BakerJayaram2008]. For the range $T_{\min}>0.109$ s, with $T_{\min}=\min(T_i,T_j)$ and $T_{\max}=\max(T_i,T_j)$,

$$
\rho(T_i,T_j)=1-\cos\!\left(\frac{\pi}{2}-0.366\ln\frac{T_{\max}}{\max(T_{\min},0.109)}\right).
$${#eq-site-rho}

When $T_{\min}\leq0.109\,\mathrm{s}$, the correlation is obtained from the corresponding branches of the Baker and Jayaram formulation [-@BakerJayaram2008, Eqs. 5--6]. The model is applicable between 0.01 and 10 s and is independent of magnitude and distance.
