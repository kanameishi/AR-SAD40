The deterministic assessment characterizes the seismic demand through a finite set of postulated rupture scenarios. Each scenario represents the maximum credible earthquake (MCE) of one source: the largest earthquake reasonably conceivable along a recognized fault or within a geographically defined tectonic province, under the presently known tectonic framework [@ICOLD2016]. Each scenario preserves the identity of the tectonic source, its tectonic regime, the adopted moment magnitude, the rupture geometry, and the source-to-site distances required by the ground-motion models. The objective is to obtain the conditional distribution of spectral acceleration for each scenario and to construct, period by period, the deterministic envelopes used in the comparison with the probabilistic hazard.

The construction of the scenarios starts from the tectonic characterization adopted for each source: tectonic regime, magnitude, and explicit geometric rupture variants. Each realization represents one of those variants, receives the same weight, and supplies the distance vector required by the ground-motion models. The logic tree corresponding to the tectonic regime supplies the model branches and their weights; each combination of rupture realization and GMM branch constitutes a component of the scenario distribution [@OpenQuakeEngine].


The probabilistic assessment integrates the conditional exceedance probability against the recurrence of the sources, whereas the deterministic assessment computes that same probability conditioned on the occurrence of the postulated scenario. For the scenario $e=(m_e,\mathbf r_e,\boldsymbol\theta_e)$, $m_e$ is the moment magnitude, $\mathbf r_e$ collects the source-to-site distances, and $\boldsymbol\theta_e$ contains the remaining rupture parameters and the site condition. The intensity $I$ represents the maximum horizontal ordinate $S_a(T_n)$ at period $T_n$, and $i^*$ is the level whose exceedance is evaluated.

For a rupture realization $r$ and a GMM branch $g$, the logarithm of the intensity is represented by a normal distribution with mean $\mu_{rg}=\ln\hat\eta_I(m_e,\mathbf r_r,F,S)$, evaluated with the corresponding formulation, and standard deviation $\sigma_{rg}=\sigma_{\ln I}$. In this expression, $\hat\eta_I$ is the median intensity in linear units, $\mathbf r_r$ is the distance vector of the realization, $F$ represents the faulting style, and $S$ the site condition. Identifying each pair $(r,g)$ by $k$, the component weight is

$$
w_k=\frac{v_g}{N_R},\qquad \sum_k w_k=1,
$${#eq-scenario-weights}

where $v_g$ is the weight of branch $g$ of the logic tree and $N_R$ is the number of explicit rupture variants, represented by equally weighted realizations. The conditional exceedance probability of the scenario is obtained as

$$
P\!\left[I>i^*\mid e\right]=\sum_k w_k\left[1-\Phi\!\left(\frac{\ln i^*-\mu_k}{\sigma_k}\right)\right],
$${#eq-dsha-exceedance}

where $\mu_k$ and $\sigma_k$ correspond to component $k$ and $\Phi$ is the standard normal cumulative distribution function. The conditional cumulative distribution function of the intensity is the complement of the exceedance:

$$
G(a\mid e)=\sum_k w_k\,\Phi\!\left(\frac{\ln a-\mu_k}{\sigma_k}\right).
$${#eq-scenario-mixture}

The fractiles are obtained by numerical inversion of $G(\cdot\mid e)$, while the mean is computed directly from the lognormal components:

$$
Q(p\mid e)=\inf\{a:G(a\mid e)\geq p\},\qquad E[S_a\mid e]=\sum_k w_k\exp\!\left(\mu_k+\tfrac12\sigma_k^2\right).
$${#eq-scenario-moments}

The calculation obtains seven fractiles and the mean for each scenario. The evaluation is carried out analytically from $(\mu_k,\sigma_k,w_k)$; the comparison in this chapter presents the mean of each scenario and retains the 84th percentile only in the MCE (84%) envelope. The ordinates correspond to the maximum horizontal component at 5% of critical damping and are evaluated at the reference condition $V_{\mathrm{ref}}=760$ m/s; the PGA corresponds to $T_n=0$. This condition provides the computational reference from which the site-response model derives the site conditions actually evaluated (see the site-response chapter).

The scenario spectra remain separate and preserve the physical identity of each source's earthquake across the period range. The report nomenclature defines two envelopes over the scenario set $\mathcal E$ through a single construction: the per-period maximum of the scenario ordinates for the reported statistic. The upper-fractile envelope, reported as MCE (84%), is

$$
S_a^{(84\%)}(T_n)=\max_{e\in\mathcal E}Q(0.84\mid e),
$${#eq-dsha-envelope}

a maximum over values that does not select a scenario. The mean envelope, reported as MCE, applies the same construction to the scenario means, so its ordinates likewise belong to no individual scenario. Neither envelope identifies a controlling magnitude–distance pair. The comparison with the probabilistic hazard superimposes the mean and the 84th percentile of each scenario on the available mean uniform-hazard spectra and uses the mean spectrum for $T_R=10{,}000$ years as the comparison level at the selected periods, alongside both deterministic envelopes.
