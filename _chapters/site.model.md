The design ground motions are defined for the $V_{S30}$ conditions evaluated at the site from the spectral demand at the surface. The assessment represents these effects through two alternative estimates of the surface spectral demand and combines the corresponding probability distributions to define the design demand at each structural period, return period, and $V_{S30}$ condition.

The GMM logic tree is evaluated in the hazard model for the project $V_{S30}$ conditions (`r paste(Vs30.gmdp, collapse = ", ")` m/s). Each model incorporates its empirical site term when estimating $S_a(T_n,V_{S30})$; the logic-tree weights represent the adopted epistemic alternatives, and the aleatory variability of each model is integrated into the exceedance curves. The assessment therefore retains the same source and ground-motion characterization used in the rock assessment; the site terms are evaluated for each $V_{S30}$ value analyzed. The GMM site term and the external model represent mean ergodic responses derived from sets of records.

The demand calculated for the reference condition $V_{\mathrm{ref}}=760\,\mathrm{m/s}$ constitutes the input to the NGA-East ergodic site-amplification model (ST20), developed by Stewart *et al.* [-@Stewart2020] and Hashash *et al.* [-@Hashash2020]. For each period $T_n$, condition $V_{S30}$, and realization of the input PGA $pga^*$, the factor $F$ is modeled as a lognormal random variable whose natural logarithm has mean $\mu_{\ln F}$ and standard deviation $\sigma_{\ln F}$,

$$
\ln F \sim \mathcal{N}\!\left(\mu_{\ln F},\;\sigma_{\ln F}^{2}\right),
$${#eq-site-lnf}

where $\mu_{\ln F}$ is the conditional mean log-amplification and $\sigma_{\ln F}$ is the total dispersion of the model. The mean combines the adjustment between the 760 and 3000 m/s references, the linear term dependent on $V_{S30}$, and the nonlinear term dependent on $pga^*$. The dispersion is expressed as

$$
\sigma_{\ln F}^{2}=\sigma_L^{2}+\sigma_I^{2}+\sigma_{NL}^{2},
$${#eq-site-sigma-decomp}

where $\sigma_L$ corresponds to the linear site term, $\sigma_I$ to the change between reference horizons, and $\sigma_{NL}$ to the intensity-dependent nonlinear term. The formulation of the components and the treatment of the reference are detailed below.

$S_a^o(T_n)$ and $\mathrm{PGA}^o$ denote the ordinates calculated by OpenQuake with the GMMs for the adopted reference condition. This condition is 760 m/s in the current assessment and may be 3000 m/s when the input corresponds to the hard-rock reference.

For each period and return period, the distribution of $S_a^o$ is represented by a lognormal surrogate calibrated with the arithmetic mean and the seven quantiles published by the hazard calculation: the mean is preserved exactly and the logarithmic deviation $\sigma_o$ is fitted to the quantiles,

$$
\ln S_a^o \sim \mathcal N\!\left(\ln\mu^o-\tfrac{\sigma_o^2}{2},\;\sigma_o^2\right),
$${#eq-site-oq-surrogate}

where $\mu^o=E[S_a^o]$ is the reported arithmetic mean. The published quantiles of the direct assessment correspond to this surrogate and not to the raw fractiles of the logic tree. The ordinate obtained with ST20 is

$$
S_a^s\!\left(T_n,V_{S30}\right)=F\!\left(T_n,V_{S30},\mathrm{PGA}^o\right)\,S_a^o\!\left(T_n\right).
$${#eq-site-af}

The assessment considers separately the distribution of $S_a^o$, obtained with the GMMs for the $V_{S30}$ analyzed, and the distribution of $S_a^s$, obtained with ST20. The resulting distribution is defined as a finite mixture of the two; its formulation and its statistics are presented in the uncertainty section.
