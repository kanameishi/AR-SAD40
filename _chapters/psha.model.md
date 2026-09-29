```{r}
#| include: false
source(file.path(root, "scripts", "setup", "hazardContext.R"))
```


Probabilistic seismic hazard analysis (PSHA) quantifies the rate at which different levels of ground motion may be exceeded at the site. The assessment represents the range of magnitudes, locations, and ground motions through the seismic-source model and the ground-motion prediction models, and applies the total-probability theorem over the scenarios that can contribute to the demand [@Cornell1968; @McGuire2004].

`r MODEL.EN`

For a seismic source $s$, $\nu_{0}^{(s)}$ is its annual occurrence rate above the minimum magnitude $M_{\min}$, $m$ is the moment magnitude, and $\mathbf r$ gathers the source-to-site distance metrics required by the GMMs. The domain $D$ comprises the admissible rupture locations and geometries for the source. The functions $f_{M,s}(m)$ and $f_{\mathbf{R}\mid M,s}(\mathbf r\mid m)$ describe the normalized magnitude and distance distributions, $M_{\max}^{(s)}$ is the upper magnitude bound of the source, $I$ is the intensity measure, and $i^*$ the level whose exceedance is evaluated. With these definitions, the contribution of the source is

$$
\lambda_I(i^*)^{(s)} \;=\;
\nu_{0}^{(s)}
\int_{M_{\min}}^{M_{\max}^{(s)}} \int_{D}
P\left[ I > i^* \,\big|\, m, \mathbf{r} \right]\;
f_{M,s}(m)\;
f_{\mathbf{R}\mid M,s}(\mathbf{r}\mid m)\;
\mathrm d\mathbf{r}\,\mathrm dm
$${#eq-hazard-integral}

The probability density functions (PDF) $f_{M,s}(m)$ and $f_{\mathbf{R}\mid M,s}(\mathbf{r}\mid m)$ describe the normalized distributions of earthquake magnitudes and locations within source $(s)$. This formulation is a direct application of the total-probability theorem in continuous form, integrating over all magnitudes and locations of earthquakes from source $(s)$ that could contribute to exceedance of level $i^*$. Aleatory variability represented in the recurrence, magnitude, location, and ground-motion models is propagated through the integration [@McGuire2004; @Baker2021].

If multiple seismic sources contribute to the hazard at the site, the total annual exceedance rate $\lambda_I(i^*)$ is obtained by summing the contributions from all sources as in [-@eq-hazard-sum]. Assuming $N_S$ independent sources, each with its own occurrence rate and distributions, the overall exceedance frequency for level $i^*$ is given by [-@eq-hazard-sum], where $\lambda_I(i^*)^{(s)}$ is evaluated for each source via the hazard integral. This linear superposition is valid under the assumption that earthquake occurrences in different sources are independent, typically modeled as independent Poisson processes. The result is a seismic-hazard curve that quantifies the rate at which various ground-motion levels are exceeded at the site.

$$
\lambda_I(i^*) \;=\; \sum_{s=1}^{N_S} \lambda_I(i^*)^{(s)}
$${#eq-hazard-sum}

The ground-motion model enters PSHA through its median $\hat{\eta}_I$ and its total standard deviation $\sigma_{\ln I}$. Variations among competing GMPEs in either quantity modify the exceedance rates, particularly at long return periods, where the integral weights the upper tail of the lognormal distribution [@OpenQuakeEngine].

The annual exceedance frequency $\lambda_I(i^*)$ obtained from the hazard integral [-@eq-hazard-integral] is the mean number of exceedances per year of level $i^*$. The curves labelled **AEP** in this report present that rate, in $1/\text{year}$. If exceedances follow a Poisson process in time, the exact probability of at least one exceedance during a single year is obtained through [-@eq-aep]. For small rates, $P_{1\text{yr}} \approx \lambda_I$, because $e^{-\lambda}\approx1-\lambda$.

$$
P_{1\text{yr}}[I > i^*] = 1 - \exp[-\lambda_I(i^*)]
$${#eq-aep}

By extension, the probability of exceedance in $T$ years is $P_{T}(I > i^*) = 1 - \exp[-\lambda_I(i^*) T]$ under stationarity. This relation converts the mean annual rate into the probability for the exposure interval. The **return period** $T_R$, or **mean return interval**, is defined by

$$
T_R=\frac{1}{\lambda_I(i^*)}.
$${#eq-hazard-return-period}

The return period is expressed in years and does not represent a deterministic recurrence time.
