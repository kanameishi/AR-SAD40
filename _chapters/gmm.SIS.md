

The Intermediate-Depth Subduction Intraslab (SIS) ground-motion logic tree applies to all sources classified as the Intermediate-Depth Subduction Intraslab tectonic region type. The tree comprises nine branches of practically equal weight, $w_k = 0.11111$ —the first, `AbrahamsonEtAl2018SSlab`, carries $0.11112$ so that the total sums to exactly $1.00000$—. The SIS ensemble largely parallels the SIF ensemble in model selection, with the substitution of intraslab-specific GSIM variants (SSlab suffix models in place of SInter variants) and the addition of `JaimesEtAl2020SSlab`.

The nine branches are documented below, with their assigned weight and calibration context:

* **`AbrahamsonEtAl2018SSlab`** (weight: 0.11112). The intraslab variant of the BC Hydro subduction GMPE by Abrahamson, Gregor, and Addo (2016) [@AbrahamsonEtAl2016], calibrated for global subduction intraslab conditions from 2,590 recordings of 63 slab events spanning $M_w$ 5.0 to 7.9 at distances up to 300 km.

* **`AbrahamsonGulerce2020SSlab`** (weight: 0.11111). The intraslab component of the NGA-Subduction regionalized GMPE by Abrahamson and Gulerce (2022) [@AbrahamsonGulerce2022], calibrated from 4,850 recordings of 89 intraslab events spanning $M_w$ 5.0 to 7.8 from the NGA-SUB global database, with region-specific adjustments for seven subduction zones.

* **`Atkinson2022SSlab`** (weight: 0.11111). The intraslab backbone GMPE developed by Atkinson (2022) for the NZ22 model set [@Atkinson2022NZ], applying an equivalent point-source framework adapted to intraslab earthquake kinematics. Unlike the interface variant, this implementation requires a backarc classification flag in addition to $R_{rup}$, $V_{S30}$, and moment magnitude, distinguishing forearc and backarc site attenuation conditions. The backarc parameter accounts for the systematically reduced ground-motion amplitudes observed at backarc sites in subduction environments.

* **`ChaoEtAl2020SSlab`** (weight: 0.11111). The intraslab variant of the Taiwan ground-motion model by Chao et al. (2020) [@Chao2020], calibrated from Taiwan intraslab records.

* **`JaimesEtAl2020SSlab`** (weight: 0.11111). An updated GMPE for Mexican intermediate-depth intraslab earthquakes by Jaimes and Garcia-Soto (2020), published in Earthquake Spectra [@Jaimes2020]. The model was calibrated from 366 accelerogram records of 23 intraslab events on the Cocos plate subduction system, extended to include recordings from the September 2017 intraslab events in Mexico (including the $M_w$ 8.1 Chiapas normal-faulting event), covering $M_w$ approximately 5.0 to 8.2, $R_{rup}$ up to approximately 400 km, and focal depths up to approximately 75 km.

* **`KuehnEtAl2020SSlab`** (weight: 0.11111). The intraslab component of the partially non-ergodic NGA-Subduction GMPE by Kuehn et al. (2020) [@Kuehn2020], using the same Bayesian regression framework as the interface variant but calibrated on intraslab records from the NGA-Sub database.

* **`MontalvaEtAl2017SSlab`** (weight: 0.11111). The intraslab variant of the Chilean subduction GMPE by Montalva et al. (2017) [@Montalva2017]. In contrast to the interface variant, which uses $R_{rup}$ as the primary distance metric, the intraslab implementation uses $R_{hypo}$, consistent with the deeper and more diffuse rupture geometry of intraslab events.

* **`ParkerEtAl2020SSlab`** (weight: 0.11111). The intraslab component of the global NGA-Subduction GMPE by Parker et al. (2022) [@Parker2022], calibrated for intraslab events spanning $M_w$ 4.0 to 8.4 at $R_{rup}$ from approximately 35 to 2,000 km.

* **`PhungEtAl2020SSlab`** (weight: 0.11111). The intraslab variant of the GMPE by Phung et al. (2020) [@Phung2020], calibrated from Taiwan intraslab records.