# Static renderer for already prepared circular-section geometry.

buildRingStaticPlot <- function(
  geometry,
  baselineRadius,
  raysPerCircle = 36L
) {
  assertFigureColumns(
    geometry,
    c(
      "case", "prescription", "resultant", "theta", "value", "unit",
      "x", "y", "radialFraction", "displayClosed"
    ),
    "geometry"
  )
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package ggplot2 is required.", call. = FALSE)
  }

  rays <- prepareRingRays(
    geometry = geometry,
    baselineRadius = baselineRadius,
    raysPerCircle = raysPerCircle
  )
  resultants <- c(
    N = "Fuerza normal, Nθ [kN/m]",
    M = "Momento flector, Mθ [kN·m/m]",
    Q = "Fuerza cortante, Qθ [kN/m]"
  )
  missingResultants <- setdiff(unique(geometry$resultant), names(resultants))
  if (length(missingResultants) > 0L) {
    stop("The public resultant labels are incomplete.", call. = FALSE)
  }
  prescriptionOrder <- unique(geometry$prescription)
  geometry$resultantLabel <- factor(
    unname(resultants[geometry$resultant]),
    levels = unname(resultants)
  )
  rays$resultantLabel <- factor(
    unname(resultants[rays$resultant]),
    levels = unname(resultants)
  )
  geometry$prescriptionLabel <- factor(
    geometry$prescription,
    levels = prescriptionOrder
  )
  rays$prescriptionLabel <- factor(
    rays$prescription,
    levels = prescriptionOrder
  )

  circleTheta <- seq(0, 2 * pi, length.out = 361L)
  referenceCircle <- data.frame(
    x = baselineRadius * sin(circleTheta),
    y = baselineRadius * cos(circleTheta)
  )
  maximumRadialFraction <- max(geometry$radialFraction)
  labelRadius <- baselineRadius * (1 + maximumRadialFraction + 0.07)
  plotLimit <- baselineRadius * (1 + maximumRadialFraction + 0.20)
  positionLabels <- data.frame(
    x = c(0, 1, 0, -1) * labelRadius,
    y = c(1, 0, -1, 0) * labelRadius,
    label = c("Clave", "Lateral der.", "Fondo", "Lateral izq.")
  )

  ggplot2::ggplot() +
    ggplot2::geom_path(
      data = referenceCircle,
      mapping = ggplot2::aes(x = x, y = y),
      colour = "#59636E",
      linewidth = 0.45
    ) +
    ggplot2::geom_segment(
      data = rays,
      mapping = ggplot2::aes(
        x = xSection,
        y = ySection,
        xend = x,
        yend = y,
        colour = sign
      ),
      linewidth = 0.35,
      alpha = 0.82
    ) +
    ggplot2::geom_path(
      data = geometry,
      mapping = ggplot2::aes(
        x = x,
        y = y,
        group = interaction(case, resultant)
      ),
      colour = "#1F2933",
      linewidth = 0.65,
      lineend = "round"
    ) +
    ggplot2::geom_text(
      data = positionLabels,
      mapping = ggplot2::aes(x = x, y = y, label = label),
      colour = "#4B5563",
      size = 2.6
    ) +
    ggplot2::facet_grid(
      rows = ggplot2::vars(prescriptionLabel),
      cols = ggplot2::vars(resultantLabel)
    ) +
    ggplot2::scale_colour_manual(
      values = c(positive = "#0072B2", negative = "#D55E00"),
      breaks = c("positive", "negative"),
      labels = c("Positiva", "Negativa"),
      name = "Ordenada"
    ) +
    ggplot2::coord_fixed(
      xlim = c(-plotLimit, plotLimit),
      ylim = c(-plotLimit, plotLimit),
      expand = FALSE,
      clip = "off"
    ) +
    ggplot2::theme_void(base_size = 10) +
    ggplot2::theme(
      strip.text.x = ggplot2::element_text(
        colour = "#1F2933",
        face = "bold",
        size = 9.5,
        margin = ggplot2::margin(b = 5)
      ),
      strip.text.y = ggplot2::element_text(
        colour = "#1F2933",
        face = "bold",
        size = 9,
        angle = 0,
        margin = ggplot2::margin(r = 7)
      ),
      strip.background = ggplot2::element_blank(),
      panel.spacing.x = grid::unit(1.2, "lines"),
      panel.spacing.y = grid::unit(1.0, "lines"),
      legend.position = "bottom",
      legend.title = ggplot2::element_text(face = "bold"),
      legend.key.width = grid::unit(1.4, "lines"),
      plot.margin = ggplot2::margin(8, 12, 6, 12)
    )
}
