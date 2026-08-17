source(file.path(root, "scripts", "fig", "linerResultants.R"), local = TRUE)

PLOT <- buildLinerResultantsPlot(
  pathCurves = Calculation$paths$shotcreteResultants,
  pathScales = Calculation$paths$shotcreteScales,
  radius = Calculation$reinforcedConcrete$section$centroidalRadiusM,
  graphicAmplification =
    Calculation$reinforcedConcrete$display$graphicAmplification,
  raysPerCircle = Calculation$reinforcedConcrete$display$raysPerCircle,
  liningID = "reinforcedConcrete"
)
