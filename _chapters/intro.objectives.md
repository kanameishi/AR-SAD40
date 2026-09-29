

The primary objectives of this study are as follows:

* **Seismic Hazard:** Quantify annual exceedance probabilities for ground-motion intensity measures at the site using probabilistic seismic hazard analysis. Compute site-specific hazard curves and uniform hazard spectra at reference-rock conditions. Perform hazard deaggregation to identify controlling magnitude, distance, and epsilon (normalized residual) scenarios at each governing hazard level. Summarize the hazard results as mean and fractile annual-exceedance-probability curves for defined site conditions.
* **Site Response:** Compute site-specific peak ground acceleration and spectral ordinates through two ergodic estimates — the direct evaluation of the ground-motion model tree, with each model's own site terms, at each evaluated condition, and the transformation of the reference-rock motion through the Stewart and Hashash (2020) NGA-East ergodic amplification model — and combine their probability distributions as a finite mixture to define the design demand. Present the results as tables and figures summarizing peak ground acceleration and uniform hazard spectra for all evaluated site conditions and fractiles.
* **Slope Design:** Quantify permanent slope displacements and derive performance-based horizontal seismic coefficients ($k_{\max}$, $k_h$) for slope stability design. Displacements are estimated using a weighted ensemble of rigid- and flexible-block Newmark models across all geometry classes, material scenarios, MDE and MCE demand scenarios, and allowable displacement thresholds. Seismic coefficients are determined by inversion of the displacement framework for each prescribed performance objective. Summarize the $k_{\max}$ and $k_h$ design values for all geometry–material–demand-scenario combinations.
* **Design Criteria:** Establish seismic design criteria for tailings storage facilities based on international standards and consequence classification. Assign design earthquakes and performance objectives for all project lifecycle phases, including operation, closure, and post-closure, as required by GISTM, CDA, and ANCOLD. Determine Maximum Credible Earthquake (MCE) scenarios in accordance with regulatory requirements. Define the probabilistic design spectra and the associated ground motions for each operational stage and consequence rating. Establish, for conventional structures, the MCER spectra of the ASCE/SEI 7-22 (IBC 2024) site-specific procedure — the risk-targeted Maximum Considered Earthquake — and derive from them the design spectra, defined as two-thirds of the MCER ordinates, with their $S_{DS}$ and $S_{D1}$ parameters.

```{r}
#| echo: false
#| results: asis
if (.srsAvailable(root)) {
  cat(
    "\n* **Seismic Record Selection:** ",
    "Select, through magnitude and distance windows tied to the scenarios that control the hazard and with at most one record per event, a set of strong-motion records that represents the amplitude, duration, and frequency content of the seismic demand; process each horizontal component by removing the low-frequency mode associated with drift and noise and normalizing the energy of the reconstructed signal; scale the set to reproduce the mean of the site-specific target spectrum and to contain the individual spectra within its envelopes; and verify the resulting compatibility through the error of the spectral mean, the PGA ratio, and the contained fraction of ordinates, preserving the identification of events, stations, and intensity measures for the dynamic deformation analyses.",
    "\n", sep = ""
  )
}
```

* **Uncertainty Modeling:** Propagate epistemic uncertainty through logic-tree branching and aleatory variability through probabilistic integration across all analysis components. Propagate the hazard and model uncertainties in site response through analytical integration of the distributions to generate fractile site-response spectra. Aggregate uncertainties in ground-motion intensity measures, site response, and displacement models to generate fractile bands for Newmark displacements and performance-based seismic coefficients.
