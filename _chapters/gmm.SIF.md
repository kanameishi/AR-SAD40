


The Subduction Interface (SIF) ground-motion logic tree applies to all sources classified as the Subduction Interface tectonic region type. The tree comprises ten branches, each assigned equal weight $w_k = 0.10000$, with the total weight summing to exactly $1.00000$. All ten models are calibrated for subduction interface conditions.

The ten branches are documented below, with their assigned weight and calibration context:

* **`AbrahamsonEtAl2018SInter`** (weight: 0.10000). An update to the BC Hydro subduction interface GMPE by Abrahamson, Gregor, and Addo, published as PEER Report 2018/02 [@AbrahamsonEtAl2018]. The original 2016 model was calibrated from 953 recordings of 43 interface events spanning $M_w$ 6.0 to 8.4 at distances up to 300 km, with magnitude scaling constrained by numerical simulations for $M_w > 8.0$ [@AbrahamsonEtAl2016]; the 2018 update extended coverage using the NGA-Subduction dataset to approximately $M_w$ 6.0 to 9.0. The model is calibrated for global subduction interface conditions.

* **`AbrahamsonGulerce2020SInter`** (weight: 0.10000). The subduction interface component of the NGA-Subduction regionalized GMPE by Abrahamson and Gulerce (2022), developed under the PEER NGA-Sub program [@AbrahamsonGulerce2022]. The model was calibrated from 3,914 recordings of 113 interface events spanning $M_w$ 5.0 to 9.2 from the NGA-SUB global database, with region-specific adjustments for seven subduction zones including Cascadia, Japan, New Zealand, South America, Central America and Mexico, Alaska, and Taiwan.

* **`Atkinson2022SInter`** (weight: 0.10000). The subduction interface backbone GMPE developed by Atkinson (2022) for the 2022 New Zealand National Seismic Hazard Model (NZ22), applying an equivalent point-source framework adapted to interface earthquake kinematics [@Atkinson2022NZ]. The model is calibrated for the New Zealand subduction interface setting, with empirical constraints spanning approximately $M_w$ 4.0 to 7.0 at distances up to approximately 400 km.

* **`AtkinsonMacias2009NSHMP2014`** (weight: 0.10000). The subduction interface GMPE by Atkinson and Macias (2009) as implemented for the 2014 National Seismic Hazard Mapping Program [@AtkinsonMacias2009], originally developed for the Cascadia subduction zone using stochastic simulations anchored to recordings from the 2003 Tokachi-Oki earthquake sequence in Japan with subsequent adjustments for Cascadia source and attenuation conditions. The model targets large interface events in the magnitude range $M_w$ 7.5 to 9.0.

* **`ChaoEtAl2020SInter`** (weight: 0.10000). The subduction interface variant of the Taiwan ground-motion model by Chao et al. (2020) [@Chao2020], calibrated from the Taiwan strong-motion flat-file for interface earthquake records.

* **`KuehnEtAl2020SInter`** (weight: 0.10000). The subduction interface component of a partially non-ergodic NGA-Subduction GMPE by Kuehn et al. (2020), published as PEER Report 2020/04 [@Kuehn2020]. The model was developed through Bayesian regression with informative priors over a NGA-Sub database comprising more than 210,000 ground-motion components from 1,570 events spanning $M_w$ 4.0 to 9.1, providing region-specific constants and attenuation parameters for seven global subduction zones.

* **`MontalvaEtAl2017SInter`** (weight: 0.10000). The subduction interface GMPE by Montalva et al. (2017), published in the Bulletin of the Seismological Society of America [@Montalva2017], calibrated from 3,774 recordings of 473 earthquakes recorded in Chile between 1985 and 2015, covering $M_w$ 4.6 to 8.8 and $R_{rup}$ from approximately 20 to 650 km. The model is calibrated for the Chilean subduction interface regime.

* **`ParkerEtAl2020SInter`** (weight: 0.10000). The subduction interface component of a global NGA-Subduction GMPE by Parker et al. (2022), published as PEER Report 2020/03 and subsequently in Earthquake Spectra [@Parker2022]. The model was calibrated from records spanning subduction zones in Japan, Taiwan, New Zealand, Mexico, Central America, South America, Alaska, and Cascadia, covering $M_w$ 4.7 to 9.1 and $R_{rup}$ from approximately 25 to 2,000 km. The model provides predictions for PGA, PGV, and 5%-damped pseudo-spectral acceleration at 26 oscillator periods from 0.01 to 10 s.

* **`PhungEtAl2020SInter`** (weight: 0.10000). The subduction interface variant of the GMPE by Phung et al. (2020) [@Phung2020], calibrated from the Taiwan subduction database for interface events spanning approximately $M_w$ 4.0 to 7.6 at distances up to approximately 200 km.

* **`SiEtAl2020SInter`** (weight: 0.10000). The subduction interface component of a NGA-Subduction regional GMPE by Si et al. (2020), published as PEER Report 2020/06 and developed for Japanese subduction earthquakes [@Si2020].


