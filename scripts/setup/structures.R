# nolint start
StructuresSummary <- local({
  ID.target <- .cleanTarget(.currentTarget("ID.target"))
  if (!length(ID.target)) {
    ID.target <- .cleanTarget(.currentTarget("ID.gmdp"))
  }

  Spectra <- .selectASCETable(
    ASCETable,
    "structures summary",
    idTarget = ID.target,
    siteID = .currentTarget("siteID.target"),
    vs30 = Vs30.gmdp,
    p = "mean",
    spectrum = "mcer"
  )
  Spectra <- unique(Spectra[, .(Vs30, Tn, SaF, SDS, SD1, SMS, SM1)])

  Parameters <- unique(Spectra[, .(Vs30, SDS, SD1, SMS, SM1)])
  list(parameters = Parameters)
})
# nolint end
