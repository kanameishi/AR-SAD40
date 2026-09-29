
The IND model is based on the probabilistic seismic hazard model for the Indian subcontinent developed by Nath and Thingbaijam [@NathThingbaijam2012], subsequently updated and translated into OpenQuake format in collaboration with Natural Resources Canada (version v2012.2.0), as documented in the GEM model report [@GemInd2012]. The model domain extends from approximately $60.0^\circ$E to $100.8^\circ$E in longitude and $2.0^\circ$N to $40.0^\circ$N in latitude, covering India, Bangladesh, Bhutan, Nepal, Pakistan, Myanmar, and surrounding regions of the Indian subcontinent. The minimum earthquake magnitude ($M_{\min}$) adopted for hazard calculations is 4.5 Mw across all area sources; the two smoothed-seismicity grids employ $M_{\min}$ thresholds of 4.5 Mw and 5.5 Mw respectively.

The IND SSM comprises 443,197 seismic sources of two types: 108 area sources (`areaSource`) and 443,089 point sources (`pointSource`). These sources span four tectonic region types (TRTs); the table below provides the complete census by TRT and source type.

```{r}
#| include: true
#| label: tbl-ssm-ind-inventory
#| tbl-cap: "Source inventory by tectonic region type."

DT <- data.table::data.table(
  `Description` = c("Subduction Intraslab", "Subduction Interface", "Stable Continental Crust", "Active Shallow Crust", "Total"),
  `TRT` = c("SIS", "SIF", "SCC", "ASC", ""),
  `Area sources` = c("35", "27", "17", "29", "108"),
  `Point sources` = c("139,942", "123,748", "94,433", "84,966", "443,089"),
  `Total` = c("139,977", "123,775", "94,450", "84,995", "443,197")
)

TBL <- DT |> buildTable(
  library = "flextable",
  align.body = "center",
  font.size.body = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |>
  flextable::set_table_properties(layout = "autofit")
TBL
```

The SSM is defined through logic-tree XML files. The primary logic tree references three source-model XML files and produces 27 end-branches from the Cartesian product of three branch sets ($3 \times 3 \times 3 = 27$). The branch set structure is described in detail in the Logic Tree Structure section below.

Seismic-source characterisation follows the classical PSHA framework outlined by Cornell [@Cornell1968] and formalised under SSHAC guidelines [@SSHAC1997]. Sources are delineated from geologic, geophysical, and seismological evidence, with geometry and parametrisation defined in OpenQuake source-model XML files. The implementation is publicly available at the `nackerley/indian-subcontinent-psha` repository on GitHub [@NackerleyRepo].
