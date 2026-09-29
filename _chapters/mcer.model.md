
Seismic demand for conventional structures is established in accordance with ASCE/SEI 7-22 from the hazard and site-response spectra developed in Part I. Section 11.4.7 refers to the site-specific procedures of Sections 21.1 and 21.2; where those procedures are applied, the design spectrum and its parameters are determined in accordance with Sections 21.3 and 21.4 [@ASCE722, secs. 11.4.7, 21.1--21.4].

The probabilistic component of the MCER spectrum is evaluated, for each period $T_n$ and $V_{S30}$ condition, from the resulting random variable $S_a(T_n)$, whose cumulative distribution function $G$ is defined in [-@eq-site-branch-mixture]. For each return period $T_R$, the ordinate considered is its arithmetic mean $\mu=E[S_a]$, defined in [-@eq-site-branch-mean], and the associated annual exceedance rate is $1/T_R$, in accordance with [-@eq-hazard-return-period]. The pairs $(\mu,1/T_R)$ corresponding to the available return periods constitute the input curve to the risk-targeted adjustment procedure of Section 21.2.1.

The risk-targeted adjustment represents the fragility prescribed by Section 21.2.1 through the random variable $C_x$, the spectral collapse capacity associated with a candidate ordinate $x$:

$$
\ln C_x\sim\mathcal N\!\left(\mu_{\ln C},\sigma_{\ln C}^{2}\right).
$${#eq-structures-collapse-capacity}

In this expression, $\mu_{\ln C}$ and $\sigma_{\ln C}$ are the mean and the standard deviation of $\ln C_x$, respectively. For each $x$,

$$
\mu_{\ln C}
=\ln x-\Phi^{-1}(0.10)\sigma_{\ln C},
\qquad
\sigma_{\ln C}=0.60,
$$

so that $P[C_x\leq x]=0.10$. $C_x$ represents the generic fragility adopted by the risk-targeted adjustment procedure and not a capacity calculated for the structures at the site [@ASCE722, sec. 21.2.1; @Luco2007].

In the risk calculation, the intensity measure $I$ of [-@eq-hazard-sum] corresponds to $S_a(T_n)$. The annual collapse rate associated with the candidate ordinate $x$ is

$$
\lambda_C(x)
=\int_0^\infty
\lambda_I(i^*)\,f_{C_x}(i^*)\,\mathrm{d}i^*,
$${#eq-structures-collapse-rate}

where $f_{C_x}$ is the density function of the capacity defined in [-@eq-structures-collapse-capacity], and $\lambda_I(i^*)$ represents the curve determined by the pairs $(\mu,1/T_R)$ of the preceding paragraph. The probabilistic ordinate corresponds to the value of $x$ that satisfies

$$
1-\exp\!\left[-50\,\lambda_C(x)\right]=0.01.
$${#eq-structures-probabilistic-ordinate}

This evaluation is performed separately for each $T_n$ and $V_{S30}$ condition.

ASCE/SEI 7-22 requires the MCER spectral ordinates to represent the maximum response in the horizontal plane. Where the GMM provides the geometric mean or a similar measure of the two horizontal components, Section 21.2 establishes directional factors of 1.20 for $T_n\leq0.2$ s, 1.25 for $T_n=1.0$ s, and 1.30 for $T_n\geq10$ s [@ASCE722, sec. 21.2]. To establish a common definition among the horizontal GMMs, the hazard model transforms the RotD50, GMRotI50, and random-horizontal components to geometric mean before combining the branches; the models defined for the vertical component do not enter this combination. The ordinates expressed as geometric mean are subsequently converted to maximum response in the horizontal plane through the directional factors indicated.

The contribution of the scenarios to the deterministic component of the MCER spectrum is obtained, for each $T_n$ and $V_{S30}$, as

$$
S_a^{(84\%)}(T_n)=\max_{e\in\mathcal E}Q(0.84\mid e).
$${#eq-structures-scenario-84}

where $\mathcal E$ gathers the seismic scenarios included in the analysis. The ordinates $\underline{S}_a(T_n)$ of Table 21.2-1 constitute the prescribed lower limit for the deterministic MCER spectrum corresponding to the site class used for the evaluated $V_{S30}$ condition. The deterministic component is established, for each $T_n$, as

$$
\max\!\left[S_a^{(84\%)}(T_n),\underline{S}_a(T_n)\right].
$${#eq-structures-deterministic-component}

The site-specific MCER ordinate is the lesser of the probabilistic and the deterministic components [@ASCE722, sec. 21.2.3]. The probabilistic component is the solution of [-@eq-structures-probabilistic-ordinate], expressed through $\lambda_C^{-1}$, the inverse function of the collapse rate defined in [-@eq-structures-collapse-rate]. For each $T_n$ and $V_{S30}$ condition,

$$
S_{aM}(T_n)
=\min\!\left[
\lambda_C^{-1}\!\left(-\frac{\ln 0.99}{50}\right),
\max\!\left[S_a^{(84\%)}(T_n),\underline{S}_a(T_n)\right]
\right].
$${#eq-structures-mcer-ordinate}

In accordance with Section 21.3, the design spectral accelerations are obtained from the MCER ordinates of [-@eq-structures-mcer-ordinate] through

$$
S_a(T_n)=\frac{2}{3}S_{aM}(T_n).
$${#eq-structures-design-spectrum}

Where the design ground motions are determined through the site-specific procedure^[The site-specific procedure of ASCE/SEI 7-22 encompasses the complete determination of the ground motions through site-specific analyses: the probabilistic component of Section 21.2.1, the deterministic component of Section 21.2.2 and, where applicable, the site-response analysis of Section 21.1, as opposed to the general procedure of Section 11.4.6.], in accordance with Section 21.3, the design acceleration parameters are calculated as [@ASCE722, sec. 21.4]

$$
\begin{aligned}
S_{DS}
  &=0.9\max_{T\in[0.2,5]\,\mathrm{s}}S_a(T),\\
S_{D1}
  &=\max\!\left[
      0.9\max_{T\in[1,T^*]\,\mathrm{s}}\bigl(T\,S_a(T)\bigr),
      S_a(1\,\mathrm{s})
    \right],\\
T^*
  &=\begin{cases}
      2\,\mathrm{s}, & V_{S30}>442\,\mathrm{m/s},\\
      5\,\mathrm{s}, & V_{S30}\leq442\,\mathrm{m/s}.
    \end{cases}
\end{aligned}
$${#eq-structures-design-parameters}

The corresponding MCER parameters are recovered from the design values through

$$
S_{MS}=1.5S_{DS},\qquad S_{M1}=1.5S_{D1}.
$${#eq-structures-mcer-parameters}

The chapter retains the site-specific MCER spectra for the evaluated $V_{S30}$ conditions, with one ordinate per period of the hazard curves; the results report the MCER PGA and the maximum spectral ordinates per site condition.

Section 21.2.2 bounds the deterministic spectrum from below by the tabulated values of Table 21.2-1 — the $\underline{S}_a(T_n)$ component of [-@eq-structures-deterministic-component] —, defined by site class from $T=0$ to 10 s and including PGA, and admits an exception: where the probabilistic spectrum remains below those values at all periods, the deterministic motions are not calculated [@ASCE722, sec. 21.2.2]. Verifying that exception consists of comparing the probabilistic spectrum with the tabulated values at each evaluated site condition. The 80% floor of Section 21.2.3 is anchored to the USGS Seismic Design Geodatabase and its application is limited to that database's coverage [@ASCE722, sec. 21.2.3].


In addition to the site-specific design spectrum, the report includes the code-form design spectrum of ASCE/SEI 7-22 Section 11.4.5, built piecewise from the parameters $S_{DS}$ and $S_{D1}$. With $T_0=0.2\,S_{D1}/S_{DS}$ and $T_S=S_{D1}/S_{DS}$,

$$
S_a(T_n)=
\begin{cases}
S_{DS}\left(0.4+0.6\,\dfrac{T_n}{T_0}\right), & T_n<T_0,\\[4pt]
S_{DS}, & T_0\leq T_n\leq T_S,\\[4pt]
\dfrac{S_{D1}}{T_n}, & T_n>T_S,
\end{cases}
$${#eq-structures-code-spectrum}

with the ordinates in $g$. Outside the reach of the Section 22 maps no long-period transition $T_L$ is adopted; the $S_{D1}/T_n$ branch extends to the end of the period grid [@ASCE722, sec. 11.4.5].
