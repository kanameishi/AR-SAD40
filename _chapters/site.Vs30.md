
The seismic site condition is initially characterized by $V_{S30}$, the time-averaged shear-wave velocity of the uppermost 30 m of the profile. The $V_S$ profile is obtained through geophysical investigations appropriate to the project conditions, among them borehole logging, seismic cone penetration tests, and surface-wave methods. The definition of $V_{S30}$ preserves the shear-wave travel time through the layered profile:

$$
V_{S30}=\frac{30}{\displaystyle\sum_{i=1}^{N}\frac{H_i}{V_{S,i}}},
$${#eq-class-vs30}

where $H_i$ and $V_{S,i}$ are, respectively, the thickness in meters and the shear-wave velocity of layer $i$ within the uppermost 30 m, and $N$ is the number of layers of the profile within that thickness. The expression corresponds to a travel-time average and provides the uniform velocity that reproduces the propagation time of the actual profile.

$V_{S30}$ is the site-condition predictor used by the ground-motion models and by the amplification relations of this assessment [@Borcherdt2012]. It also identifies the reference condition from which the hazard spectra and the rock-to-site transformations are interpreted. In the site-specific analyses, the calculation additionally uses the properties required by the response model; the initial classification does not replace that characterization.

The parameter summarizes the average shallow stiffness, but it does not by itself describe stratigraphic contrasts, depth to bedrock, basin effects, or resonance periods. These limitations are considered when defining the scope of a site-specific evaluation and when interpreting the resulting spectral demand.


The NEHRP provisions classify sites into Classes A through E and reserve Class F for conditions requiring site-specific evaluation [@BSSC2015]. The reference ranges based on $V_{S30}$ are the following:

* **Class A:** hard rock, with $V_{S30}>1500$ m/s.
* **Class B:** rock, with $V_{S30}$ between 760 and 1500 m/s.
* **Class C:** very dense soil or soft rock, with $V_{S30}$ between 360 and 760 m/s.
* **Class D:** stiff soil, with $V_{S30}$ between 180 and 360 m/s.
* **Class E:** soft soil, with $V_{S30}<180$ m/s.
* **Class F:** profiles requiring site-specific evaluation, among them soils susceptible to liquefaction or collapse, peats, organic clays, thick high-plasticity clays, and very soft clays.

Where velocity measurements are available, $V_{S30}$ is the primary criterion. The provisions also include criteria based on penetration resistance and on undrained shear strength where the geophysical information is insufficient. Class F is not assigned through a single $V_{S30}$ range and leads to a site response analysis in lieu of the direct application of generic factors.


ASCE/SEI 7-22 updates the discretization of site conditions and distinguishes Classes A, B, BC, C, CD, D, DE, and E through velocity ranges, from competent rock to soft soils [@ASCE722]. Class F identifies conditions that require site-specific response procedures and is not assigned solely through a $V_{S30}$ range.

The ranges and descriptions of the adopted classification are presented below. The evaluated $V_{S30}$ values represent the site conditions for which the demand is determined. The class of a particular location is assigned from the applicable geotechnical profile and from the additional conditions defined by the standard.

The evaluated site conditions extend down to $V_{S30}=180$ m/s, which falls within Class DE; the assessment does not reach Class E. Softer conditions are reserved for site-specific response procedures: Class F requires them under ASCE/SEI 7-22 [@ASCE722, secs. 11.4.7, 21.1], and Class E may additionally be assigned through the soft-clay criterion of Section 20.2.2, independently of $V_{S30}$. The ergodic amplification model declares its applicability for $V_{S30}$ between 200 and 3000 m/s, and its authors recommend a site-specific response analysis for conditions with $V_{S30}$ below 200 m/s [@Stewart2020; @Hashash2020]. For profiles softer than those evaluated, the spectra and parameters of this report are not applicable without a site-specific response evaluation.

```{r}
#| include: false
CAP <- "Seismic site classification. Source: ASCE/SEI 7-22 [@ASCE722]."
```

{{< include /_tbl/ASCE722.qmd >}}
