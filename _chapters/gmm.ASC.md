

The Active Shallow Crust (ASC) ground-motion logic tree applies to all sources classified as the Active Shallow Crust tectonic region type. The tree comprises eight branches, each assigned equal weight $w_k = 0.12500$, with the total weight summing to exactly $1.00000$. The uniform weighting reflects the equal epistemic standing afforded to all eight GMPEs; the supporting documentation does not provide explicit per-model selection rationale beyond ASC regime applicability.

The eight branches are documented below, with their assigned weight and calibration context:

* **`AristeidouEtAl2024`** (weight: 0.12500). A GMPE for active shallow crustal earthquakes developed using an artificial neural network regression on strong-motion data [@Aristeidou2024]. The model is calibrated for the ASC regime with records from events of $M_w \geq 4.5$.

* **`Atkinson2022Crust`** (weight: 0.12500). A backbone crustal GMPE developed by Atkinson (2022) for the 2022 Aotearoa New Zealand National Seismic Hazard Model (NZ22), applying an equivalent point-source framework calibrated against New Zealand strong-motion observations spanning approximately $M_w$ 4.0 to 8.0 at rupture distances up to approximately 400 km [@Atkinson2022NZ; @Bradley2022NZ]. The model is calibrated specifically for the New Zealand crustal (ASC) setting.

* **`BooreEtAl2020`** (weight: 0.12500). The GMPE by Boore *et al.* [-@Boore2021Greece] for active shallow crustal earthquakes in Greece, published in the Bulletin of the Seismological Society of America, which adapts a global NGA-West2-family model to the faster attenuation and weaker magnitude scaling observed in Greek strong motions.


* **`CampbellBozorgnia2019`** (weight: 0.12500). The Campbell-Bozorgnia NGA-West2 model, implemented in OpenQuake via the `campbell_bozorgnia_2014.py` module and representing a 2019 update to the 2014 NGA-West2 CB model [@CampbellBozorgnia2014]. The model is calibrated for active shallow crustal earthquakes using the NGA-West2 database, covering approximately $M_w$ 3.3 to 8.5 at distances up to 300 km.

* **`ChaoEtAl2020Asc`** (weight: 0.12500). The active shallow crustal variant of a horizontal ground-motion model for Taiwan developed by Chao et al. (2020) [@Chao2020], calibrated from a Taiwan strong-motion flat-file of more than 40,000 recordings spanning 1992 to 2016 using a two-step maximum-likelihood regression procedure. The model is calibrated for the Taiwan crustal regime.

* **`KothaEtAl2020`** (weight: 0.12500). The backbone GMPE by Kotha et al. (2020) for active shallow crustal earthquakes in Europe, published in the Bulletin of Earthquake Engineering [@Kotha2020], serving as the ASC component of the 2020 European Seismic Hazard Model (ESHM20). The model was calibrated from the Engineering Strong Motion (ESM) dataset comprising 23,014 recordings from 2,179 earthquakes predominantly in Italy, Turkey, and Greece, spanning $M_w$ 3.0 to 7.4 and Joyner-Boore distances from 0 to approximately 300 km. A hinge magnitude $M_h = 6.2$ separates quadratic from linear magnitude scaling.

* **`PhungEtAl2020Asc`** (weight: 0.12500). The active shallow crustal variant of a GMPE by Phung et al. (2020) [@Phung2020], calibrated from the Taiwan strong-motion database using 13,415 ground-motion records from 187 crustal events. The model adopts a functional form based on Chiou and Youngs (2014) with Taiwan-specific recalibration and spans approximately $M_w$ 3.5 to 8.0.

* **`Stafford2022`** (weight: 0.12500). A backbone crustal GMPE developed by Stafford (2022) for the 2022 New Zealand National Seismic Hazard Model as part of the NZ22 model set [@Bradley2022NZ], derived through adjustments to the Chiou and Youngs (2014) response spectral model. The model is calibrated for the New Zealand ASC setting, spanning $M_w$ 4.5 to 8.4 at rupture distances from 0 to approximately 300 km.

