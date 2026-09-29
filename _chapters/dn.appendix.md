This appendix compiles the published form of each Newmark permanent-displacement formulation applied in the seismic-coefficient chapter: three rigid-block models, two flexible-block models, and the rule that defines the active configuration.

## Rigid-Block Models {#sec-newmark-rigid}

The `AM88` formulation of Ambraseys and Menu [-@AmbraseysMenu1988] uses the ratio of yield acceleration to PGA, capped to preserve the logarithmic domain, $r^\star=\min (k_y/\mathrm{PGA},0.9999)$^[The numerical support of $k_y$ corresponds to the interval defined in the demand section; when a complete AM88 realization reaches the limit $r^\star=0.9999$, its inversion retains the sampled PGA and recovers the physical branch according to @eq-kmax-am88-limit.]:

$$
\begin{aligned} \mu_{\ln D} &=\ln (10)\left[0.90+\log_{10}\!\left((1-r^\star)^{2.53} (r^\star)^{-1.09}\right)\right],\\ \sigma_{\ln D}&=0.30\ln (10). \end{aligned}
$${#eq-newmark-am88}

The exception is the AM88 limit. If the sampled PGA of a realization, $\mathrm{PGA}_s$, is smaller than the lower end of the grid, all stored points may satisfy $k_y/\mathrm{PGA}_s\geq r_{\max}=0.9999$ and form a plateau $D_{0,s}$. In that case the plateau is not extrapolated, nor is $k_{\max}=0$ assigned. For $D_a>D_{0,s}$, the physical branch $0<r<r_{\max}$ of @eq-newmark-am88 is solved:

$$
\mu_{\ln D}(r)
=\ln D_a-\ln D_{0,s}+\mu_{\ln D}(r_{\max}),
\qquad
k_{\max,s}=\mathrm{PGA}_s r .
$${#eq-kmax-am88-limit}

The random residual cancels between $D_a$ and $D_{0,s}$. Moreover, $\mathrm{d}\mu_{\ln D}/\mathrm{d}r=-2.53/(1-r)-1.09/r<0$, so the root is unique. An AM88 plateau is accepted only when the original curve is exactly constant and $\mathrm{PGA}_s$ itself shows that the entire grid reached that limit; a flat curve from another model, or a target $D_a\leq D_{0,s}$, is rejected as non-identifiable support.

The Arias intensity used by JB07 and SR08 is estimated for each realization from the PGA [@Verri2023a]:

$$
I_A=\exp(2.6109)\,\mathrm{PGA}^{1.9228}.
$${#eq-newmark-arias}

where $I_A$ is expressed in m/s and PGA in units of $g$. The evaluation applies this relation deterministically: each PGA realization determines a single value of $I_A$, and the displacement sample propagates the PGA variability.

The `JB07` formulation of Jibson [-@Jibson2007] incorporates the Arias intensity and the ratio $k_y/\mathrm{PGA}$:

$$
\begin{aligned} \mu_{\ln D} &=\ln (10)\left[0.561\log_{10}I_A -3.833\log_{10}\!\left(\frac{k_y}{\mathrm{PGA}}\right)-1.474\right],\\ \sigma_{\ln D}&=0.616\ln (10). \end{aligned}
$${#eq-newmark-jb07}

The `SR08` formulation of Saygili and Rathje [-@SaygiliRathje2008] defines $r=k_y/\mathrm{PGA}$ and combines PGA and Arias intensity:

$$
\begin{aligned} \mu_{\ln D} ={}&2.39-5.24r-18.78r^2+42.01r^3-29.15r^4\\ &-1.56\ln\mathrm{PGA}+1.38\ln I_A,\\ \sigma_{\ln D}={}&0.46+0.56r. \end{aligned}
$${#eq-newmark-sr08}

## Flexible-Block Models {#sec-newmark-flexible}

The `BT07` formulation of Bray and Travasarou [-@BrayTravasarou2007] employs $S_a=S_a (1.5T_s)$ and $M_w$:

$$
\begin{aligned} \mu_{\ln D}={}&a_0-2.83\ln k_y-0.333 (\ln k_y)^2 +0.566\ln k_y\ln S_a\\ &+3.04\ln S_a-0.244 (\ln S_a)^2 +1.50T_s+0.278 (M_w-7),\\ a_0={}& \begin{cases} -0.22, & T_s<0.05\ \mathrm{s},\\ -1.10, & T_s\geq0.05\ \mathrm{s}, \end{cases}\\ \sigma_{\ln D}={}&0.66. \end{aligned}
$${#eq-newmark-bt07}

The `BM17` formulation of Bray, Macedo, and Travasarou [-@BrayEtAl2018] represents subduction-interface motions with $S_a=S_a (1.5T_s)$:

$$
\begin{aligned} \mu_{\ln D}&=a_0+a_1\ln S_a-0.225 (\ln S_a)^2,\\ a_1&=3.060+0.538\ln k_y,\\ a_{0,<}={}&-5.864+0.550M_w-9.421T_s\\ &-3.353\ln k_y-0.390 (\ln k_y)^2,\\ a_{0,\geq}={}&-6.896+0.550M_w+3.081T_s-0.803T_s^2\\ &-3.353\ln k_y-0.390 (\ln k_y)^2,\\ a_0&= \begin{cases} a_{0,<}, & T_s<0.1\ \mathrm{s},\\ a_{0,\geq}, & T_s\geq0.1\ \mathrm{s}, \end{cases}\\ \sigma_{\ln D}&=0.73. \end{aligned}
$${#eq-newmark-bm17}

The `BM19` formulation of Bray and Macedo [-@BrayMacedo2019] represents ordinary shallow crustal motions with $S_a=S_a (1.3T_s)$:

$$
\begin{aligned} \mu_{\ln D}&=a_0+\left(2.649+0.344\ln k_y\right)\ln S_a -0.090 (\ln S_a)^2,\\ a_{0,<}={}&-4.684+0.603M_w-9.471T_s\\ &-2.482\ln k_y-0.244 (\ln k_y)^2,\\ a_{0,\geq}={}&-5.981+0.603M_w+3.223T_s-0.945T_s^2\\ &-2.482\ln k_y-0.244 (\ln k_y)^2,\\ a_0&= \begin{cases} a_{0,<}, & T_s<0.1\ \mathrm{s},\\ a_{0,\geq}, & T_s\geq0.1\ \mathrm{s}, \end{cases}\\ \sigma_{\ln D}&=0.72. \end{aligned}
$${#eq-newmark-bm19}

## Ensemble {#sec-newmark-ensemble}

The active configuration applies five formulations: `AM88`, `JB07`, `SR08`, `BT07`, and one BM branch — `BM17` when the project declares subduction control, `BM19` when it declares crustal control; each evaluation therefore applies five formulations, never both BM branches at once. The predictors and dispersions are applied in the published form of each model.
