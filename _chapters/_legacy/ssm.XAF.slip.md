
Activity rates for fault sources with available slip-rate data may be derived from seismic-moment balance:

$$\dot{M}_0 = \mu\, A\, S$$

where $\mu$ is the shear modulus, $A$ is the fault area, and $S$ is the long-term slip rate. This relationship connects geodetic or geologic slip-rate estimates to the seismic moment release rate used in MFD construction.

Slip-rate estimates from the GEM North Africa Active Fault Database (NAAFD) [@Styron2018] are documented for 15 of the 115 fault sources. The documented values encompass net slip rates, strike-parallel rates, vertical rates, and shortening rates, with magnitudes typically in the range 0.01 to 2.5 mm/yr. However, these slip-rate data are not encoded in the OpenQuake source-model XML files; the source-model audit records zero fault sources with slip-rate data present in the XML representation. The incremental MFD rates for fault sources were therefore specified independently of the NAAFD slip-rate constraints at the OpenQuake implementation stage [@Poggi2020].
