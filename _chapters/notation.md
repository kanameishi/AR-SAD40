The following tables summarize the mathematical notation of the report, by thematic block and in order of appearance.

### General symbols

| Symbol | Definition |
|---|---|
| $T_n$ | Oscillator period associated with spectral ordinate $n$; by convention, $T_n=0$ represents PGA (s). |
| $T_R$ | Return period, $T_R=1/\lambda_I(i^*)$ (yr). |
| $V_{S30}$ | Travel-time-averaged shear-wave velocity in the uppermost 30 m; it identifies a site condition, not a site class (m/s). |
| $V_{\mathrm{ref}}$ | Shear-wave velocity of the reference input condition; 760 and 3000 m/s occur in the formulation (m/s). |

### Seismic hazard

| Symbol | Definition |
|---|---|
| $M_w$ | Moment magnitude. |
| $I$ | Ground-motion intensity measure. |
| $i^*$ | Intensity level whose exceedance is evaluated. |
| $\lambda_I(i^*)$ | Total annual exceedance rate; per source, $\lambda_I(i^*)^{(s)}$ (1/yr). |
| $\nu_0^{(s)}$ | Annual rate of occurrence of source $s$ above $M_{\min}$ (1/yr). |
| $M_{\min}$, $M_{\max}^{(s)}$ | Minimum magnitude of the domain and source upper bound. |
| $P_{1\text{yr}}$, $P_T$ | Probability of at least one exceedance in 1 year / in $T$ years. |
| $\hat\eta_I$ | GMM median intensity in linear units. |
| $\sigma_{\ln I}$ | Total logarithmic standard deviation of the GMM. |
| $\tau$, $\phi$ | Inter-event and intra-event deviations; $\sigma_{\ln I}^2=\tau^2+\phi^2$. |
| $\varepsilon$, $\varepsilon^*$ | GMM standard-normal residual; number of deviations by which $i^*$ exceeds the median. |
| $R_{JB}$, $R_{rup}$, $R_x$, $R_{hypo}$, $R_{epi}$; $z_{1.0}$, $z_{2.5}$, $z_{tor}$, $W$, $h$ | Distance metrics and geometric parameters required by the GMMs (km). |
| $\theta_{k,j,\ell}$ | Conditional probability that exceedance originates in the magnitude–distance–residual bin $(k,j,\ell)$; its maximum defines the modal scenario. |

### DSHA

| Symbol | Definition |
|---|---|
| $e$ | Deterministic scenario within the analyzed set $\mathcal E$. |
| $\mu_{rg}$, $\sigma_{rg}$ | Mean and deviation of $\ln I$ for rupture realization $r$ and GMM branch $g$; with $k=(r,g)$, also written $\mu_k$, $\sigma_k$. |
| $w_k=v_g/N_R$ | Weight of component $k$: branch weight over the number of rupture variants; $\sum_k w_k=1$. |
| $S_a^{(84\%)}(T_n)$ | 84th-percentile envelope over the scenario set (g). |

### GMM mixture

| Symbol | Definition |
|---|---|
| $w_k$ | Weight of GMM branch $k$ in the ensemble; $\sum_k w_k=1$. |
| $\bar\lambda_I$, $\lambda_I^{(k)}$ | Mean hazard curve and branch-$k$ curve (1/yr). |
| $\varepsilon_{ij}=\eta_i+\delta_{ij}$ | Mixed-effects partition of the total residual of record $j$ of event $i$: inter-event term $\eta_i$ and intra-event term $\delta_{ij}$. |

### Site response

| Symbol | Definition |
|---|---|
| $S_a^o(T_n)$ | Spectral-acceleration random variable obtained from the GMMs in the hazard model; the superscript $o$ does not denote “rock” (g). |
| $S_a^s(T_n,V_{S30})$ | Spectral-acceleration random variable obtained by applying ST20 to $S_a^o(T_n)$ evaluated at the reference condition (g). |
| $S_a$ | Random variable resulting from the mixture of $S_a^o$ and $S_a^s$ (g). |
| $\alpha$ | Mixture coefficient assigned to the $S_a^o$ component; $1-\alpha$ is assigned to $S_a^s$. |
| $\mathrm{PGA}^o$ | PGA random variable obtained from the GMMs and used as the ST20 input intensity (g). |
| $pga^*$ | Realization of $\mathrm{PGA}^o$ conditioning the ST20 nonlinear term (g). |
| $F$ | Random ST20 amplification factor relating $S_a^s$ to $S_a^o$. |
| $F_{\mathrm{comp}}$ | Composite amplification model, $F_{\mathrm{comp}}=F_{760}F_VF_{nl}$; the factor applied from 760 m/s is the ratio between $F_{\mathrm{comp}}$ at the target and at the reference condition. |
| $F_{760}$ | Adjustment factor between the 760 m/s condition and the 3000 m/s hard-rock reference. |
| $F_V$ | Linear site-amplification factor; it equals one at the 760 m/s reference. |
| $F_{nl}$ | Nonlinear amplification factor. |
| $\mu_{\ln F}$, $\sigma_{\ln F}$ | Mean and total standard deviation of $\ln F$, conditional on $T_n$, $V_{S30}$, and $pga^*$. |
| $\sigma_L$, $\sigma_I$, $\sigma_{NL}$ | Linear, reference-change, and nonlinear contributions to $\sigma_{\ln F}$. |
| $\mathrm{AF}$ | Published amplification factor: mean and quantiles of the ratio between the site-condition demand and the reference-rock demand; exactly 1 at $V_{S30}=760$ m/s. |

### Seismic record selection

| Symbol | Definition |
|---|---|
| $\mathrm{CAV}$ | Cumulative absolute velocity of the record. |
| $\mathrm{CAV}_5$ | Cumulative absolute velocity restricted to the intervals where the acceleration exceeds 5 cm/s². |
| $\overline S_a(T_j)$, $S_a^t(T_j)$ | Spectral mean of the scaled record set and target spectrum (g). |

### MCER

| Symbol | Definition |
|---|---|
| $C_x$ | Spectral collapse capacity of the generic fragility anchored at ordinate $x$: lognormal with $P[C_x\leq x]=0.10$ and $\sigma_{\ln C}=0.60$ (g). |
| $\lambda_C(x)$ | Annual collapse rate; $\lambda_C^{-1}$ is its functional inverse (1/yr). |
| $\underline S_a(T_n)$ | Deterministic lower-limit ordinate of Table 21.2-1 (g). |
| $S_{aM}(T_n)$ | Site-specific MCER ordinate (ASCE/SEI 7-22 Section 21.2.3) (g). |
| $S_a(T_n)$ | Design-spectrum ordinate, $\tfrac23 S_{aM}(T_n)$ (normative symbol, Eq. 21.3-1) (g). |
| $S_{DS}$, $S_{D1}$, $T^*$ | Section 21.4 design acceleration parameters (g) and period limit (s). |
| $S_{MS}=1.5S_{DS}$, $S_{M1}=1.5S_{D1}$ | MCER parameters (g). |
| $T_0$, $T_S$, $T_L$ | Corner periods of the Section 11.4.5 code-form spectrum: $T_0=0.2\,S_{D1}/S_{DS}$, $T_S=S_{D1}/S_{DS}$; $T_L$ is the long-period transition (s). |

### Slope dynamics

| Symbol | Definition |
|---|---|
| $H_s$, $s$, $\lambda_o=b/b_{\max}$ | Slope height (m), slope ratio, and truncation ratio, with $b$ and $b_{\max}$ the berm and base widths. |
| $G_o$, $m_o$ | Fitted basal small-strain shear modulus (MPa) and inhomogeneity factor governing the shear-modulus profile. |
| $V_S^o$ | Basal shear-wave velocity associated with $G_o$ (m/s). |
| $T_s$ | Fundamental period of the slope (Dakoulas–Gazetas) (s). |

### Displacements and seismic coefficients

| Symbol | Definition |
|---|---|
| $D_n$ | Newmark permanent displacement (cm). |
| $\mu_{\ln D}$, $\sigma_{\ln D}$ | Mean and standard deviation of $\ln D_n$ defined by each displacement model. |
| $I_A$ | Arias intensity, derived from PGA through the relation adopted in the report (m/s). |
| $D_a$ | Allowable permanent displacement (cm). |
| $D_a/H$ | Relative residual displacement (%). |
| $a_y$, $k_y=a_y/g$ | Yield acceleration (m/s²) and its dimensionless form. |
| $r$, $r^\star$ | Ratio $k_y/\mathrm{PGA}$ and its capped form $\min(k_y/\mathrm{PGA},0.9999)$ (AM88). |
| $k_{\max}(p_e\mid D_a)$ | Smallest $k_y$ whose probability of exceeding $D_a$ does not exceed $p_e$ (g). |
| $p_e$ | Target exceedance probability of the coefficient; the associated empirical fractile is $q=1-p_e$. |
| $k_h=100\,k_{\max}/\mathrm{PGA}(V_{S30})$ | Seismic coefficient normalized by the site-condition PGA (%). |
