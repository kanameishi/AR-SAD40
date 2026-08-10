# Rebuilds two explanatory figures for the Markdown methodology.
#
# Outputs are written only to TITO/kb/figures. They are dimensionless or use
# published FHWA benchmark inputs; no project data are embedded.

Arguments <- commandArgs(trailingOnly = FALSE)
FileArgument <- grep("^--file=", Arguments, value = TRUE)
if (length(FileArgument) != 1L) {
  stop("Run with Rscript scripts/R/runRingFigures.R.", call. = FALSE)
}
ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
ProjectRoot <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
OutputDirectory <- file.path(ProjectRoot, "TITO", "kb", "figures")
if (!dir.exists(OutputDirectory)) {
  dir.create(OutputDirectory, recursive = TRUE)
}

source(file.path(ProjectRoot, "scripts", "R", "ringDirect.R"))
source(file.path(ProjectRoot, "scripts", "R", "ringLoads.R"))

Blue <- "#0072B2"
Orange <- "#D55E00"
Green <- "#009E73"
Gray <- "#4D4D4D"
Theta <- (0:720) * 2 * pi / 721
ThetaDeg <- Theta * 180 / pi

# ---------------------------------------------------------------------------
# Constant K0 tensor: two explicit interface branches.
# ---------------------------------------------------------------------------

FullLoad <- k0TensorLoad(
  effectiveVertical = 1,
  k0 = 0.5,
  porePressure = 0,
  interface = "fullTraction"
)
NormalLoad <- k0TensorLoad(
  effectiveVertical = 1,
  k0 = 0.5,
  porePressure = 0,
  interface = "normalOnly"
)
FullResponse <- solveRingDirect(
  load = FullLoad,
  radius = 1,
  theta = Theta
)
NormalResponse <- solveRingDirect(
  load = NormalLoad,
  radius = 1,
  theta = Theta
)
FullApplied <- evaluateRingLoad(FullLoad, Theta)

png(
  filename = file.path(OutputDirectory, "k0-load-and-response.png"),
  width = 1800,
  height = 1200,
  res = 180
)
par(mfrow = c(2, 2), mar = c(4.2, 4.6, 2.2, 1.2), oma = c(2, 0, 3, 0))
plot(
  ThetaDeg,
  -FullApplied$radialOutward,
  type = "l",
  lwd = 2.5,
  col = Gray,
  ylim = range(
    -FullApplied$radialOutward,
    FullApplied$tangentialPositive
  ),
  xlab = expression(theta~"[deg]"),
  ylab = "traction / sigma[v]'",
  main = "Prescribed traction"
)
lines(ThetaDeg, FullApplied$tangentialPositive, lwd = 2.5, col = Green)
abline(h = 0, col = "#B3B3B3")
legend(
  "topright",
  legend = c(expression(-P[r]), expression(P[t])),
  col = c(Gray, Green),
  lty = 1,
  lwd = 2.5,
  bty = "n"
)

plot(
  ThetaDeg,
  FullResponse$values$normalForce,
  type = "l",
  lwd = 2.5,
  col = Blue,
  xlab = expression(theta~"[deg]"),
  ylab = expression(N/(sigma[v]*R)),
  main = "Normal force"
)
lines(
  ThetaDeg,
  NormalResponse$values$normalForce,
  lwd = 2.5,
  col = Orange,
  lty = 2
)
abline(h = 0, col = "#B3B3B3")
legend(
  "topright",
  legend = c("full traction", "normal only"),
  col = c(Blue, Orange),
  lty = c(1, 2),
  lwd = 2.5,
  bty = "n"
)

plot(
  ThetaDeg,
  FullResponse$values$bendingMoment,
  type = "l",
  lwd = 2.5,
  col = Blue,
  xlab = expression(theta~"[deg]"),
  ylab = expression(M/(sigma[v]*R^2)),
  main = "Bending moment"
)
lines(
  ThetaDeg,
  NormalResponse$values$bendingMoment,
  lwd = 2.5,
  col = Orange,
  lty = 2
)
abline(h = 0, col = "#B3B3B3")

plot(
  ThetaDeg,
  FullResponse$values$shearForce,
  type = "l",
  lwd = 2.5,
  col = Blue,
  xlab = expression(theta~"[deg]"),
  ylab = expression(Q/(sigma[v]*R)),
  main = "Shear force"
)
lines(
  ThetaDeg,
  NormalResponse$values$shearForce,
  lwd = 2.5,
  col = Orange,
  lty = 2
)
abline(h = 0, col = "#B3B3B3")
mtext(
  "Constant biaxial field: K0 = 0.5, u = 0, R = 1",
  side = 3,
  outer = TRUE,
  line = 1,
  cex = 1.15,
  font = 2
)
mtext(
  "Dimensionless mechanics check; neither branch is a published soil-interface law.",
  side = 1,
  outer = TRUE,
  line = 0.5,
  cex = 0.82
)
dev.off()

# ---------------------------------------------------------------------------
# FHWA construction stage: Eq. 5.1 projected onto a 300 mm band.
# ---------------------------------------------------------------------------

CompactionPressure <- fhwaCompactionPressure(
  compactorForceKn = 20.5,
  looseFrictionAngleDeg = 36,
  centroidalDiameterMm = 970
)
StageLoad <- fhwaCompactionBandLoad(
  pressureKpa = CompactionPressure,
  radiusM = 0.485,
  fillSurfaceDepthBelowCrownM = 0.485,
  bandDepthM = 0.300
)
StageApplied <- evaluateRingLoad(StageLoad, Theta)
StageResponse <- solveRingDirect(
  load = StageLoad,
  radius = 0.485,
  theta = Theta
)

png(
  filename = file.path(OutputDirectory, "fhwa-compaction-stage.png"),
  width = 1800,
  height = 1200,
  res = 180
)
par(mfrow = c(2, 2), mar = c(4.2, 4.6, 2.2, 1.2), oma = c(2, 0, 3, 0))
plot(
  ThetaDeg,
  StageApplied$radialOutward,
  type = "l",
  lwd = 2.2,
  col = Blue,
  ylim = range(
    StageApplied$radialOutward,
    StageApplied$tangentialPositive
  ),
  xlab = expression(theta~"[deg]"),
  ylab = "traction [kPa]",
  main = "Projected horizontal band"
)
lines(ThetaDeg, StageApplied$tangentialPositive, lwd = 2.2, col = Green)
abline(h = 0, col = "#B3B3B3")
legend(
  "topright",
  legend = c(expression(P[r]), expression(P[t])),
  col = c(Blue, Green),
  lty = 1,
  lwd = 2.2,
  bty = "n"
)

plot(
  ThetaDeg,
  StageResponse$values$normalForce,
  type = "l",
  lwd = 2.5,
  col = Orange,
  xlab = expression(theta~"[deg]"),
  ylab = "N [kN/m]",
  main = "Normal force"
)
abline(h = 0, col = "#B3B3B3")

plot(
  ThetaDeg,
  StageResponse$values$bendingMoment,
  type = "l",
  lwd = 2.5,
  col = Orange,
  xlab = expression(theta~"[deg]"),
  ylab = "M [kN m/m]",
  main = "Bending moment"
)
abline(h = 0, col = "#B3B3B3")

plot(
  ThetaDeg,
  StageResponse$values$shearForce,
  type = "l",
  lwd = 2.5,
  col = Orange,
  xlab = expression(theta~"[deg]"),
  ylab = "Q [kN/m]",
  main = "Shear force"
)
abline(h = 0, col = "#B3B3B3")
mtext(
  "FHWA Eq. 5.1: rammer, stone, dc = 970 mm; 300 mm construction band",
  side = 3,
  outer = TRUE,
  line = 1,
  cex = 1.02,
  font = 2
)
mtext(
  "Derived construction-stage mapping; it is not a retained final pressure field.",
  side = 1,
  outer = TRUE,
  line = 0.5,
  cex = 0.82
)
dev.off()

message("Wrote figures to ", OutputDirectory, ".")
