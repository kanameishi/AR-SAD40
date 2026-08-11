# Geometry preparation for parametric diagrams on a circular section.
# This file does not calculate loads, structural response, extrema or quantiles.

assertFigureColumns <- function(data, required, name = "data") {
  if (!is.data.frame(data)) {
    stop(name, " must be a data frame.", call. = FALSE)
  }
  missing <- setdiff(required, names(data))
  if (length(missing) > 0L) {
    stop(
      name,
      " is missing columns: ",
      paste(missing, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  invisible(data)
}

prepareRingDiagram <- function(
  curves,
  displayScales,
  baselineRadius,
  graphicAmplification = 1
) {
  assertFigureColumns(
    curves,
    c(
      "case", "prescription", "resultant", "thetaIndex", "theta",
      "thetaDeg", "value", "unit"
    ),
    "curves"
  )
  assertFigureColumns(
    displayScales,
    c("resultant", "displayScale", "radialFraction"),
    "displayScales"
  )
  if (!is.numeric(baselineRadius) || length(baselineRadius) != 1L ||
      !is.finite(baselineRadius) || baselineRadius <= 0) {
    stop("baselineRadius must be one positive finite number.", call. = FALSE)
  }
  if (any(!is.finite(curves$theta)) || any(curves$theta < 0) ||
      any(curves$theta >= 2 * pi) || any(!is.finite(curves$value))) {
    stop("curves must contain finite theta in [0, 2*pi) and finite values.", call. = FALSE)
  }
  if (anyDuplicated(displayScales$resultant)) {
    stop("displayScales must contain one row per resultant.", call. = FALSE)
  }
  Resultants <- unique(as.character(curves$resultant))
  if (!is.numeric(graphicAmplification) ||
      any(!is.finite(graphicAmplification)) ||
      any(graphicAmplification <= 0)) {
    stop("graphicAmplification must contain positive finite values.", call. = FALSE)
  }
  if (length(graphicAmplification) == 1L) {
    Amplification <- stats::setNames(
      rep(graphicAmplification, length(Resultants)),
      Resultants
    )
  } else {
    if (is.null(names(graphicAmplification)) ||
        !setequal(names(graphicAmplification), Resultants) ||
        length(graphicAmplification) != length(Resultants)) {
      stop(
        paste(
          "graphicAmplification must be one value or a named vector",
          "with one value for every resultant."
        ),
        call. = FALSE
      )
    }
    Amplification <- graphicAmplification[Resultants]
  }

  splitKey <- interaction(
    curves$resultant,
    curves$case,
    drop = TRUE,
    lex.order = TRUE
  )
  prepared <- lapply(split(curves, splitKey), function(current) {
    current <- current[order(current$thetaIndex), , drop = FALSE]
    if (anyDuplicated(current$thetaIndex) || any(diff(current$theta) <= 0)) {
      stop("Each case/resultant series must have unique ordered angles.", call. = FALSE)
    }
    scaleRow <- displayScales[
      displayScales$resultant == current$resultant[1L],
      ,
      drop = FALSE
    ]
    if (nrow(scaleRow) != 1L || !is.finite(scaleRow$displayScale) ||
        scaleRow$displayScale <= 0) {
      stop("Each resultant requires one positive displayScale.", call. = FALSE)
    }
    CurrentAmplification <- unname(Amplification[current$resultant[1L]])
    BaseDisplayScale <- scaleRow$displayScale
    EffectiveDisplayScale <- BaseDisplayScale * CurrentAmplification
    radius <- baselineRadius + EffectiveDisplayScale * current$value
    if (any(radius <= 0)) {
      stop(
        "The amplified display scale crosses the section centre.",
        call. = FALSE
      )
    }
    current$plotRadius <- radius
    current$x <- radius * sin(current$theta)
    current$y <- radius * cos(current$theta)
    current$baseDisplayScale <- BaseDisplayScale
    current$graphicAmplification <- CurrentAmplification
    current$displayScale <- EffectiveDisplayScale
    current$radialFraction <-
      scaleRow$radialFraction * CurrentAmplification
    current$displayClosed <- FALSE

    closure <- current[1L, , drop = FALSE]
    closure$theta <- closure$theta + 2 * pi
    closure$thetaDeg <- closure$thetaDeg + 360
    closure$thetaIndex <- max(current$thetaIndex) + 1L
    closure$displayClosed <- TRUE
    rbind(current, closure)
  })
  geometry <- do.call(rbind, prepared)
  rownames(geometry) <- NULL
  geometry
}

prepareRingRays <- function(
  geometry,
  baselineRadius,
  raysPerCircle = 36L,
  phaseDegByCase = NULL
) {
  assertFigureColumns(
    geometry,
    c(
      "case", "prescription", "resultant", "thetaIndex", "theta",
      "value", "x", "y", "displayClosed"
    ),
    "geometry"
  )
  if (!is.numeric(baselineRadius) || length(baselineRadius) != 1L ||
      !is.finite(baselineRadius) || baselineRadius <= 0) {
    stop("baselineRadius must be one positive finite number.", call. = FALSE)
  }
  if (!is.numeric(raysPerCircle) || length(raysPerCircle) != 1L ||
      !is.finite(raysPerCircle) || raysPerCircle < 4 ||
      raysPerCircle != as.integer(raysPerCircle)) {
    stop("raysPerCircle must be one integer not smaller than four.", call. = FALSE)
  }

  OpenGeometry <- geometry[!geometry$displayClosed, , drop = FALSE]
  Cases <- unique(OpenGeometry$case)
  if (is.null(phaseDegByCase)) {
    Phase <- stats::setNames(rep(0, length(Cases)), Cases)
  } else {
    if (!is.numeric(phaseDegByCase) || is.null(names(phaseDegByCase)) ||
        !setequal(names(phaseDegByCase), Cases) ||
        any(!is.finite(phaseDegByCase)) || any(phaseDegByCase < 0) ||
        any(phaseDegByCase >= 360)) {
      stop(
        "phaseDegByCase must assign one angle in [0, 360) to every case.",
        call. = FALSE
      )
    }
    Phase <- phaseDegByCase[Cases]
  }
  splitKey <- interaction(
    OpenGeometry$resultant,
    OpenGeometry$case,
    drop = TRUE,
    lex.order = TRUE
  )
  Rays <- lapply(split(OpenGeometry, splitKey), function(current) {
    current <- current[order(current$thetaIndex), , drop = FALSE]
    Case <- current$case[1L]
    TargetAngles <- seq(
      0,
      2 * pi,
      length.out = as.integer(raysPerCircle) + 1L
    )
    TargetAngles <- TargetAngles[-length(TargetAngles)]
    TargetAngles <- sort((TargetAngles + Phase[Case] * pi / 180) %% (2 * pi))
    indices <- vapply(TargetAngles, function(angle) {
      which.min(abs(current$theta - angle))
    }, integer(1))
    selected <- current[indices, , drop = FALSE]
    selected$xSection <- baselineRadius * sin(selected$theta)
    selected$ySection <- baselineRadius * cos(selected$theta)
    selected$sign <- factor(
      ifelse(selected$value < 0, "negative", "positive"),
      levels = c("positive", "negative")
    )
    selected
  })
  OUT <- do.call(rbind, Rays)
  rownames(OUT) <- NULL
  OUT
}

prepareRingEnvelope <- function(quantiles, displayScale, baselineRadius) {
  assertFigureColumns(
    quantiles,
    c(
      "model", "resultant", "probability", "thetaIndex", "theta",
      "thetaDeg", "value", "unit", "statisticScope"
    ),
    "quantiles"
  )
  if (any(quantiles$statisticScope != "pointwise")) {
    stop("Only pointwise quantiles can form an angular envelope.", call. = FALSE)
  }
  probabilities <- sort(unique(quantiles$probability))
  if (length(probabilities) < 3L) {
    stop("At least lower, central and upper probabilities are required.", call. = FALSE)
  }
  lower <- probabilities[1L]
  central <- probabilities[which.min(abs(probabilities - 0.5))]
  upper <- probabilities[length(probabilities)]
  selected <- quantiles[quantiles$probability %in% c(lower, central, upper), ]
  selected$case <- paste0("q", format(selected$probability, trim = TRUE))
  selected$prescription <- selected$case
  scales <- data.frame(
    resultant = unique(selected$resultant),
    displayScale = displayScale,
    radialFraction = max(abs(displayScale * selected$value)) / baselineRadius,
    stringsAsFactors = FALSE
  )
  geometry <- prepareRingDiagram(selected, scales, baselineRadius)
  list(
    geometry = geometry,
    probabilities = c(lower = lower, central = central, upper = upper)
  )
}
