GMMs are among the main contributors to the epistemic uncertainty of the PSHA, together with source-model components such as fault geometry, seismicity rates, and magnitude-frequency distributions. Unlike aleatory variability, epistemic uncertainty represents incomplete scientific knowledge of the true ground-motion process: it is in principle reducible with additional data and is represented through a discrete set of alternative models. In regions with scarce strong-motion records, the medians of candidate GMPEs can diverge substantially over the spectral periods and magnitude-distance ranges of engineering interest, and that dispersion is frequently the main contributor to the uncertainty band of the hazard curve at low exceedance rates. Model uncertainty is therefore represented explicitly through a logic tree that samples the space of possible alternatives. Each logic tree is defined for one tectonic region type and comprises a single branching level. Each branch specifies an alternative GMPE with a non-negative weight $w_k$ satisfying the normalization condition

$$
\sum_{k=1}^{N} w_k = 1, \qquad w_k \geq 0
$${#eq-weight-norm}

where $N$ is the number of branches in the set. The weights define a discrete probability distribution over the candidate GMPEs; when all models receive equal weight, $w_k = 1/N$, the tree represents a state of maximum model uncertainty, with no prior preference for any formulation. The tree is propagated by evaluating the hazard integral separately for each branch and combining the resulting curves with their weights [@OpenQuakeEngine]. The mean hazard curve is the weighted average

$$
\bar{\lambda}_I(i^*) = \sum_{k=1}^{N} w_k\, \lambda_I^{(k)}(i^*)
$${#eq-mean-hazard}

where $\lambda_I^{(k)}(i^*)$ is the annual exceedance rate calculated with the GMPE of branch $k$. The full distribution over branches also allows fractile hazard curves at prescribed probability levels, which characterize the dispersion originated by the GMM epistemic uncertainty. The four trees of this assessment assign equal weights to their branches —with the single rounding adjustment of the SCC tree, detailed in its section—. This weighting is a grounded epistemic response: where the strong-motion catalog is insufficient to discriminate statistically among candidate formulations, there is no empirical basis for assigning systematically greater weights to one model family, and differential weights would introduce an apparent precision without support, at the risk of under-representing the true range of epistemic uncertainty. From information theory, the uniform distribution is the maximum-entropy assignment under a state of equal prior knowledge [@Springer2023LT]. The complement of that weighting is the breadth of the ensemble: a large set of diverse genealogies —European, New Zealand, Taiwanese, and global NGA-West2 calibrations in active crust; eastern North America and the European and Australian cratons in stable crust; regional databases from Chile, Japan, Taiwan, and Mexico together with the global NGA-Subduction compilation in the subduction regimes— spans the widest defensible range of predictions and reduces the risk that the mean curve be dominated by a narrow group of models sharing common assumptions or training data [@NRCSSHAC2012]. Comparisons among GMMs require an operation distinct from the combination of hazard curves. For a fixed cell $\mathbf{x}=(M_w,R_{epi},h,T_n,V_{S30})$, each branch $k$ contributes a lognormal distribution with logarithmic median $\mu_k(\mathbf{x})$ and total logarithmic standard deviation $\sigma_k(\mathbf{x})$. The cumulative distribution function of the weighted mixture is

$$
F_{S_a}(a\mid\mathbf{x}) = \sum_{k=1}^{N} w_k\,
\Phi\!\left[\frac{\ln a-\mu_k(\mathbf{x})}{\sigma_k(\mathbf{x})}\right].
$${#eq-gmm-grid-mixture}

The tabulated quantiles are obtained by numerically inverting this function, while the arithmetic mean of the mixture is evaluated directly:

$$
S_a^{(p)}(\mathbf{x})=F_{S_a}^{-1}(p\mid\mathbf{x}),
\quad p\in\{0.05,0.10,0.16,0.50,0.84,0.90,0.95\},
\qquad
E[S_a\mid\mathbf{x}]
=\sum_{k=1}^{N}w_k\exp\!\left[\mu_k(\mathbf{x})+\frac{\sigma_k^2(\mathbf{x})}{2}\right].
$${#eq-gmm-grid-products}

The separation among the branch medians represents the epistemic dispersion across models, and each $\sigma_k$ retains the aleatory variability of its formulation. The p5–p95 band is bounded by the 5th and 95th percentiles of the mixed conditional distribution and gathers both contributions. This per-cell mixture is used in the attenuation curves, the comparative spectra, and the conditional scenario evaluations. In the PSHA, each branch is integrated separately before the hazard curves are weighted; the resulting uniform hazard spectra constitute the spectral input of the probabilistic estimation of Newmark displacements, so the influence of the GMMs reaches that stage through those spectra [@VerriKozlowski2026Newmark].
