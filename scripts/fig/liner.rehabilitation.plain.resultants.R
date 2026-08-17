source(file.path(root, "scripts", "fig", "linerResultants.R"), local = TRUE)

PLOT <- buildLinerResultantsPlot(
  pathCurves = Calculation$paths$shotcreteResultants,
  pathScales = Calculation$paths$shotcreteScales,
  radius = Calculation$shotcrete$section$centroidalRadiusM,
  graphicAmplification = Calculation$shotcrete$display$graphicAmplification,
  raysPerCircle = Calculation$shotcrete$display$raysPerCircle,
  liningID = "shotcrete"
)
