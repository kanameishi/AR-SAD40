# nolint start
# Executive-summary bullet constructor per scenario (binding spec:
# dev/SoT/HANDOFF-OQT-DSHA-DATA-20260714.md §7.3, MCETable era).
if (!exists("TRT.text", inherits = FALSE)) TRT.text <- c(
  ASC = "shallow crustal source",
  SCC = "stable continental source",
  SIF = "subduction interface source",
  SIS = "subduction intraslab source"
)

.mceBullet <- function(scnID, site, label = "tbl-mce") {
  Scn <- ScenarioTable[ID == scnID & siteID == site]
  if (nrow(Scn) != 1L) {
    stop(sprintf("mce summary: ScenarioTable row not unique for %s/%s.", scnID, site), call. = FALSE)
  }
  DT <- MCETable[ID == scnID & siteID == site & Vs30 == 760]
  PGA50 <- DT[Tn == 0 & .matchP(p, "0.50"), SaF]
  PGA84 <- DT[Tn == 0 & .matchP(p, "0.84"), SaF]
  AUX <- DT[.matchP(p, "0.50")][which.max(SaF)]
  if (length(PGA50) != 1L || length(PGA84) != 1L || !nrow(AUX)) {
    stop(sprintf("mce summary: rock cells missing for %s/%s.", scnID, site), call. = FALSE)
  }
  sprintf(
    "Scenario %s (%s, Mw %s at %d km): the deterministic median spectrum at reference rock reaches %s g PGA and peaks at %s g near %s s; the 84th percentile PGA is %s g (@%s).",
    scnID, TRT.text[[Scn$TRT]], Scn$Mw, round(Scn$Repi),
    signif(PGA50, 2), signif(AUX$SaF, 2), AUX$Tn, signif(PGA84, 2), label
  )
}
# nolint end
