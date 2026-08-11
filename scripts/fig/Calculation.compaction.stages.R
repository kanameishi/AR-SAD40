source("scripts/R/ringFigureData.R")
source("scripts/fig/ringParametric.R")

buildCalculationCompactionStages <- function(
  pathCurves,
  pathScales,
  resultant,
  radius
) {
  if (!file.exists(pathCurves) || !file.exists(pathScales)) {
    stop("The construction-stage files are not available.", call. = FALSE)
  }
  curves <- utils::read.csv(pathCurves, check.names = FALSE)
  scales <- utils::read.csv(pathScales, check.names = FALSE)
  required <- c("stage", "resultant")
  if (length(setdiff(required, names(curves))) > 0L) {
    stop("Construction curves require stage and resultant columns.", call. = FALSE)
  }
  curves <- curves[curves$resultant == resultant, , drop = FALSE]
  curves$case <- paste(curves$case, curves$stage, sep = " — ")
  curves$prescription <- curves$stage
  geometry <- prepareRingDiagram(curves, scales, radius)
  buildRingParametricPlot(
    geometry = geometry,
    title = paste("Etapas constructivas —", resultant),
    baselineRadius = radius
  )
}
