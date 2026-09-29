The term $P[I > i^* \mid m,\mathbf{r}]$ in the hazard integral represents the ground-motion model's probabilistic prediction of exceedance and can be obtained from ground-motion prediction equations (GMPEs). GMPEs are empirical or semi-empirical models that predict the statistical distribution of ground-motion intensity measures (e.g., PGA, spectral acceleration) given an earthquake's characteristics. A GMPE typically provides a median predicted ground motion (often in $\log_{10}$ or natural-log units) as a function of parameters such as magnitude $M$, source-to-site distance $R$, and site condition, along with an estimate of **aleatory variability** (the standard deviation $\sigma$ of the logarithmic residuals) [@Boore2008]. A generic form of a GMPE for an arbitrary intensity measure $I$ is given in [-@eq-gmpe], where $F$ and $S$ are indicator variables for fault type (e.g., reverse/normal) and site class (e.g., rock or soil), and $\varepsilon$ is a standard-normal (zero-mean) random variable representing the random scatter (with $\sigma_{\ln I}$ being the log-standard deviation) [@Boore2008]^[$\varepsilon$ is a random variable representing the residual (in log units) for an individual event].

$$
\ln I \approx \hat{\eta}_I(m,\mathbf{r},F,S)\;+\;\varepsilon\,\sigma_{\ln I},
$${#eq-gmpe}


If $\hat\eta_I(m,r,F,S)$ denotes the median intensity $I$ (in linear units) for magnitude $m$ at distance $r$ and $\sigma_{\ln I}$ is the standard deviation of $\ln I$, then the conditional exceedance probability can be expressed as in [-@eq-gmpe-exc], where $\Phi$ is the standard-normal cumulative-distribution function. The quantity $\varepsilon^*$, defined in [-@eq-epsilon-star],represents the number of standard deviations by which $i^*$ exceeds the median prediction for scenario $(m,r,F,S)$.
$$
P[I > i^* \mid m,\mathbf{r}] \;=\; 1 \;-\; \Phi\left(\varepsilon^*\right),
$${#eq-gmpe-exc}

$$
\varepsilon^* \;=\; \frac{\ln i^* - \ln \hat{\eta}_I(m,\mathbf{r},F,S)}{\sigma_{\ln I}}
$${#eq-epsilon-star}

The total aleatory standard deviation $\sigma_{\ln I}$ satisfies the quadrature relation [-@eq-sigma-decomp], where $\tau$ is the between-event (inter-event) standard deviation and $\phi$ is the within-event (intra-event) standard deviation, both expressed in natural-log units .

$$
\sigma_{\ln I}^2 = \tau^2 + \phi^2
$${#eq-sigma-decomp}

Under the mixed-effects decomposition adopted by most modern empirical GMPEs, the total residual for record $j$ belonging to event $i$ is partitioned as in [-@eq-mixed-effects], where $\eta_i \sim \mathcal{N}(0, \tau^2)$ is the between-event residual for event $i$, representing systematic source-to-source variation not captured by the median functional form, and $\delta_{ij} \sim \mathcal{N}(0, \phi^2)$ is the within-event residual for record $j$, representing path and site variability not resolved by the median prediction. The two residual components are assumed mutually independent . All three quantities $\sigma_{\ln I}$, $\tau$, and $\phi$ are period-dependent in most modern GMPEs and are tabulated or parameterized as part of the published model. Non-ergodic formulations further partition $\tau$ and $\phi$ into site-specific and path-specific components; the models documented in this chapter are predominantly ergodic.

$$
\varepsilon_{ij} = \eta_i + \delta_{ij}
$${#eq-mixed-effects}

The predictor variables entering a GMPE vary by model and tectonic region type, but the following notation applies consistently across all models documented in this chapter. Moment magnitude $M_w$ is the primary source-size parameter.Each model declares the distance metric it requires as part of its implementation. Site amplification is parameterized primarily by $V_{S30}$, the time-averaged shear-wave velocity in the uppermost 30 m. Basin depth is captured by $z_{1.0}$, the depth to the horizon where shear-wave velocity first reaches 1.0 km/s, and by $z_{2.5}$, the depth to the 2.5 km/s horizon. Rupture geometry descriptors include $z_{tor}$, the depth to the top of the rupture plane; the fault dip angle; the rake angle characterizing faulting style; the along-dip rupture width $W$; and hypocentral depth $h$. For subduction models, a binary backarc flag distinguishing forearc and backarc site positions is additionally required by certain implementations.
