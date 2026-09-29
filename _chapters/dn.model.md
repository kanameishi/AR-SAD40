The Newmark sliding-block method [-@Newmark1965] represents the wedge in potential sliding as a rigid block resting on an inclined plane: the block accumulates displacement whenever the driving acceleration exceeds the yield acceleration $k_y g$, and the permanent displacement results from double integration of the acceleration excess. Makdisi and Seed [-@MakdisiSeed1978] extended the procedure to dams and embankments by deriving the equivalent acceleration of the sliding mass from its dynamic response, the direct antecedent of the flexible formulations. Rigid models relate the displacement to measures of the base excitation; flexible models additionally incorporate the dynamic response of the mass through $T_s$ and the spectral acceleration evaluated at a period proportional to $T_s$.

The active formulations express the positive displacement $D_n$, in centimeters, through

$$
D_n=\exp\!\left(\mu_{\ln D}+\epsilon\sigma_{\ln D}\right), \qquad \epsilon\sim\mathcal N (0,1),
$${#eq-newmark-lognormal}

where $\mu_{\ln D}$ and $\sigma_{\ln D}$ are the mean and standard deviation of $\ln D_n$ defined by each model, and $\epsilon$ is a standard-normal residual. Some source formulations contain a discrete branch of zero or negligible displacement; the implemented evaluation uses exclusively the positive lognormal branch. In the following equations, $k_y$, PGA, and $S_a$ are expressed in units of $g$—the acceleration of gravity—$I_A$ in m/s, and $T_s$ in seconds. The Arias intensity is derived from the PGA of each realization according to [-@eq-newmark-arias]. The reference magnitude of the project, $M_w=$ `r .fmt(Mw.gmdp, 1)`, is applied as a constant input to every demand, geometry, material and site evaluated.

The performance-based seismic coefficient can be defined as

$$
k_{\max} (p_e\mid D_a)
=\inf\left\{k_y:P[D_n (k_y)>D_a]\leq p_e\right\}.
$${#eq-kmax-criterion}

where $p_e$ is the target probability that $D_n$ exceeds $D_a$.

The normalized coefficient is calculated with the PGA transformed to the $V_{S30}$ of the geometry--material combination evaluated for each demand:

$$
k_h=\frac{k_{\max}}{\mathrm{PGA} (V_{S30})}.
$${#eq-kh-normalization}

$k_{\max}$ is expressed in units of $g$ and $k_h$ as a percentage of the PGA with site response. These quantities carry the displacement criterion over to the seismic excitation used in the pseudo-static verification.
