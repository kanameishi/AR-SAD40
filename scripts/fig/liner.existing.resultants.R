source(file.path(root, "scripts", "fig", "linerResultants.R"), local = TRUE)

PLOT <- buildLinerResultantsPlot(
  pathCurves = Calculation$paths$resultants,
  pathScales = Calculation$paths$scales,
  radius = Calculation$geometry$radiusM,
  graphicAmplification = Calculation$display$graphicAmplification,
  raysPerCircle = Calculation$display$raysPerCircle
)
