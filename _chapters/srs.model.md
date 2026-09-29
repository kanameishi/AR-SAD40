The time histories constitute the seismic demand used as input to the dynamic deformation analyses and represent simultaneously its amplitude, duration, and frequency content. PGA characterizes the peak amplitude; the significant duration, the number of cycles near the peak, and the distribution of energy across frequencies describe additional characteristics that contribute to the accumulated deformation of slopes and embankments of cohesionless materials [@Kramer1997; @BrayTravasarou2007]. Record selection establishes a suite of motions whose spectral demand is compatible with the target band, whose temporal characteristics remain available to the dynamic models, and whose source events, stations, and records are identified.


The selected motions must be compatible with the hazard controlling the site, with the adopted target spectrum, and with the response variables of the dynamic model, and must represent the relevant record-to-record variability [@NIST2011]. The candidate set is delimited by magnitude and source--site distance windows tied to the scenarios controlling the hazard, identified from the hazard model and its disaggregation; the selection criteria further comprise the tectonic environment, the site conditions, component availability, usable frequency content, and record quality [@BakerCornell2006]. Within that set, spectral shape is evaluated by agreement with the target demand over the period range of the analysis —not through a separate conditional-spectrum or epsilon-based rule— and at most one record per event is retained. The target spectrum corresponds to the design ordinate of the demand adopted for the site —the mean or a design fractile, per the demand— and the lower and upper envelopes to low and high fractiles of that same demand; the envelopes define the admissible range around the target for the matched suite. The grid includes $T_n=0$ as the PGA ordinate and the positive periods of the analysis. The evaluation retains the identifiers of the event, the station, the record, and the source network or database, together with the intensity measures used to characterize the suite. No additional filters are applied by tectonic environment or by station $V_{S30}$.

Deterministic channel mapping classifies the three recorded directions into the canonical components H1, H2, and UP, and the rotation of the two horizontals to their principal axes defines H1 and H2, with the rotation angle recorded per record. Spectral matching and verification are performed on H1, so that the record table, the intensity measures, and the reported spectra correspond to a single definition of horizontal motion.


The procedure does not modify the frequency content of the records to reproduce the target spectrum. The adjustment is limited to the amplitude of the retained modes and to one scale factor per record, so that each history preserves the phases, the sequence of cycles, and the non-stationarity of the recorded motion —the properties that contribute to the accumulated deformation of slopes and embankments—. The compatibility of the suite with the target band is achieved in the spectral mean and in the containment of the individual spectra.

Empirical mode decomposition introduced intrinsic mode functions as data-adaptive components for nonlinear and non-stationary time series [@HuangEtAl1998]. The adopted procedure uses variational mode decomposition (VMD), which represents a non-stationary signal as a set of modes with compact frequency bands and a residue [@DragomiretskiyZosso2014]; the canonical histories of the full record are decomposed component by component. For the H1 component of record $i$,

$$
x_i(t)=\sum_{m=1}^{K_i}x_i^{(m)}(t)+r_i(t),
$${#eq-srs-vmd}

where $x_i(t)$ is the recorded acceleration, $x_i^{(m)}(t)$ is mode $m$ of record $i$, $K_i$ is the number of modes, and $r_i(t)$ is the residue. The procedure excludes IMF1, the low-frequency component associated with drift and noise, and defines the retained set $\mathcal{M}_i$ with the remaining modes. The adjustment applies bounded amplitude multipliers $b_i^{(m)}$ per record,

$$
\widetilde{x}_i(t;\mathbf b_i)=\sum_{m\in\mathcal{M}_i}b_i^{(m)}\,x_i^{(m)}(t),
$${#eq-srs-reconstruction}

and preserves the central frequencies and the phases of the retained modes.

Compatibility is evaluated with the pseudo-spectral acceleration operator

$$
S_{a,j}[z]=S_a[z](T_j,\xi),
$${#eq-srs-sa}

where $z(t)$ is an acceleration history, $T_j$ is a target period, and $\xi=5\%$ is the damping ratio; $s_{ij}(\mathbf b_i)=S_{a,j}\!\left[\widetilde{x}_i(\mathbf b_i)\right]$ is the reconstructed ordinate of record $i$. With $y_j$, $l_j$, and $u_j$ as the target and the lower and upper envelopes at $T_j$, the target-normalized misfit and the out-of-band excursion of the record are

$$
\mathrm{RMSE}_i(\mathbf b_i)=\left[\frac{1}{J}\sum_{j=1}^{J}\left(\frac{s_{ij}(\mathbf b_i)-y_j}{y_j}\right)^{2}\right]^{1/2},
\qquad
v_{ij}(\mathbf b_i)=\max\!\left\{\frac{l_j-s_{ij}(\mathbf b_i)}{l_j},\;\frac{s_{ij}(\mathbf b_i)-u_j}{u_j},\;0\right\}.
$${#eq-srs-modal-misfit}

The multipliers are obtained by minimizing, with $b_i^{(m)}=b_{i,0}^{(m)}\,e^{\theta_i^{(m)}}$ and within their bounds, the regularized objective

$$
L_i(\boldsymbol\theta_i)=\mathrm{RMSE}_i^{2}(\boldsymbol\theta_i)
+\lambda_{\mathrm{env}}\,\frac{1}{J}\sum_{j=1}^{J}v_{ij}^{2}(\boldsymbol\theta_i)
+\lambda_{\mathrm{mov}}\,\frac{1}{|\mathcal{M}_i|}\sum_{m\in\mathcal{M}_i}\bigl(\theta_i^{(m)}\bigr)^{2},
$${#eq-srs-modal-objective}

where $b_{i,0}^{(m)}$ is the initial value of the multiplier: the first term reduces the misfit with respect to the target, the second penalizes the excursions outside the band, and the third limits unnecessary movement of the retained multipliers. The minimization applies a deliberately bounded number of iterations, so that the adjustment remains close to the recorded motion.

After the modal adjustment, the factor

$$
e_i=\left[\frac{\sum_t x_i^2(t)}{\sum_t\widetilde{x}_i^2(t;\mathbf b_i)}\right]^{1/2},
\qquad y_i(t)=e_i\widetilde{x}_i(t;\mathbf b_i),
$${#eq-srs-energy}

normalizes the quadratic energy of the reconstructed signal with respect to the recorded history; the normalization preserves the discrete quadratic norm of the record's acceleration after reconstruction, and the effective contribution of mode $m$ is $e_i\,b_i^{(m)}\,x_i^{(m)}(t)$. This stage removes the low-frequency component associated with drift and noise and maintains the temporal structure of the modes that represent the motion at the reference condition [@VerriKozlowskiInPress].


Each reconstructed and normalized history receives a positive coefficient $c_i$,

$$
Y_i(t)=c_i y_i(t)=c_i e_i\sum_{m\in\mathcal{M}_i}b_i^{(m)}x_i^{(m)}(t),
$${#eq-srs-final}

so that $Y_i(t)$ is the final H1 component employed in the analyses. The coefficients $c_i$ are determined jointly, as a bounded quadratic problem over the complete suite, to reproduce the target spectral mean and to contain the individual spectra within the prescribed band. The objective function is

$$
\begin{aligned}
\min_{c_i>0}\quad &\frac{1}{J}\sum_{j=1}^{J}w_j r_j^2
+\frac{\lambda_B}{NJ}\sum_{i=1}^{N}\sum_{j=1}^{J}v_{ij}^2,\\
&w_j=\begin{cases}
\lambda_D,&r_j<0,\\
1,&r_j\geq0,
\end{cases}
\end{aligned}
$${#eq-srs-objective}

with

$$
r_j=\frac{\overline S_a(T_j)-S_a^t(T_j)}{S_a^t(T_j)},
\qquad
\overline S_a(T_j)=\frac{1}{N}\sum_{i=1}^{N}c_iS_{a,j}[y_i],
$${#eq-srs-residual}

and the out-of-band excursion evaluated on the scaled spectra $c_iS_{a,j}[y_i]$ with the same form as in the modal adjustment. Here, $N$ is the number of records, $J$ is the number of target periods, $S_a^t$ is the target spectrum, $\lambda_B$ weights the containment of the individual spectra, and $\lambda_D\geq1$ weights the deficits of the suite mean. The value $\lambda_D=1$ produces a symmetric weighting of positive and negative residuals.

The final verification computes the relative RMSE of $\overline S_a$ with respect to $S_a^t$, the ratio of the suite-mean PGA to the target PGA, the fraction of record--period ordinates contained by the envelopes, and the range of the coefficients $c_i$. The delivered suite retains the acceleration, velocity, and displacement histories used in the dynamic analyses, the cumulative and scalar intensity measures, the significant durations, the PSA spectra, and the provenance metadata of events and stations. This chapter reports the table of selected records and the PSA comparison of H1 with the target spectrum.
