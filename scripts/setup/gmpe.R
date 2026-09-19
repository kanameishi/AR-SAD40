# nolint start
# Hydrated GMM products in the reference-rock condition. The producer
# stores the weighted-mixture mean and quantiles by Mw/Repi/depth/period
# cell; this helper selects the same cells used by the chapter figures.
GMPE.ref <- NULL
GMPE.atten <- NULL
GMPE.spectrum <- NULL

if (exists("GMPETable", inherits = TRUE) &&
    !is.null(GMPETable) && nrow(GMPETable)) {
  .GMPE.products <- local({
    REQUIRED <- c(
      "ID", "TRT", "model", "Mw", "Repi", "dep", "Tn", "p", "Sa"
    )
    COLS <- setdiff(REQUIRED, names(GMPETable))
    if (length(COLS)) {
      stop(
        sprintf("gmpe.R: GMPETable is missing: %s.", paste(COLS, collapse = ", ")),
        call. = FALSE
      )
    }

    DT <- data.table::as.data.table(GMPETable)[
      !is.na(ID) & nzchar(ID) & !is.na(TRT) & nzchar(TRT) &
        is.finite(Mw) & is.finite(Repi) & Repi > 0 &
        is.finite(dep) & is.finite(Tn)
    ]
    if (!nrow(DT)) {
      stop("gmpe.R: no valid GMM grid rows.", call. = FALSE)
    }

    getHook <- function(name, trt, default) {
      if (!exists(name, inherits = TRUE)) return(default)
      OUT <- get(name, inherits = TRUE)
      if (!length(OUT)) return(default)
      if (!is.null(names(OUT))) {
        if (!trt %in% names(OUT)) return(default)
        OUT <- OUT[[trt]]
      } else {
        OUT <- OUT[[1L]]
      }
      OUT <- as.numeric(OUT)
      if (length(OUT) != 1L || !is.finite(OUT) || OUT <= 0) {
        stop(sprintf("gmpe.R: %s must provide one positive value for %s.", name, trt), call. = FALSE)
      }
      OUT
    }

    snap <- function(target, grid, logScale = FALSE) {
      AUX <- sort(unique(grid[is.finite(grid)]))
      if (!length(AUX)) stop("gmpe.R: empty producer grid.", call. = FALSE)
      if (logScale) AUX[which.min(abs(log(AUX) - log(target)))] else AUX[which.min(abs(AUX - target))]
    }

    getValue <- function(x, probability, context) {
      OUT <- x[.matchP(p, probability), Sa]
      if (length(OUT) != 1L || !is.finite(OUT) || OUT <= 0) {
        stop(
          sprintf("gmpe.R: expected one positive %s ordinate at %s.", probability, context),
          call. = FALSE
        )
      }
      OUT[[1L]]
    }

    Products <- lapply(sort(unique(DT$TRT)), function(trt) {
      Grid <- DT[TRT == trt]
      if (data.table::uniqueN(Grid$ID) != 1L) {
        stop(sprintf("gmpe.R: %s must resolve to one GMM grid ID.", trt), call. = FALSE)
      }

      MwTarget <- snap(getHook("Mw.gmm", trt, 6.5), Grid$Mw)
      RepiTarget <- snap(getHook("Repi.gmm", trt, 100), Grid$Repi, logScale = TRUE)
      DepTarget <- min(Grid$dep)
      Ensemble <- Grid[model == "ensemble" & is.finite(Sa) & Sa > 0]
      if (!nrow(Ensemble)) {
        stop(sprintf("gmpe.R: no valid ensemble rows for %s.", trt), call. = FALSE)
      }
      Context <- sprintf(
        "%s, Mw %.2f, Repi %.2f km, depth %.2f km",
        trt, MwTarget, RepiTarget, DepTarget
      )

      AUX <- Ensemble[Mw == MwTarget & Repi == RepiTarget & dep == DepTarget & Tn == 0]
      Ref <- data.table::data.table(
        TRT = trt,
        Mw = MwTarget,
        Repi = RepiTarget,
        dep = DepTarget,
        PGA.mean = getValue(AUX, "mean", Context),
        PGA.p50 = getValue(AUX, "0.50", Context),
        PGA.p84 = getValue(AUX, "0.84", Context),
        PGA.p05 = getValue(AUX, "0.05", Context),
        PGA.p95 = getValue(AUX, "0.95", Context)
      )
      OK <- with(Ref, PGA.p05 < PGA.p50 & PGA.p50 < PGA.p84 & PGA.p84 < PGA.p95)
      if (!OK) stop(sprintf("gmpe.R: unordered PGA mixture quantiles for %s.", trt), call. = FALSE)

      AUX <- Ensemble[
        Mw == MwTarget & dep == DepTarget & Tn == 0 & .matchP(p, "0.50")
      ][order(Repi)]
      OK <- nrow(AUX) >= 2L && data.table::uniqueN(AUX$Repi) >= 2L &&
        !nrow(AUX[, .N, by = Repi][N != 1L])
      if (!OK) stop(sprintf("gmpe.R: invalid attenuation grid for %s.", trt), call. = FALSE)
      Attenuation <- data.table::data.table(
        TRT = trt,
        Mw = MwTarget,
        dep = DepTarget,
        Repi.near = AUX$Repi[[1L]],
        Repi.far = AUX$Repi[[nrow(AUX)]],
        PGA.p50.near = AUX$Sa[[1L]],
        PGA.p50.far = AUX$Sa[[nrow(AUX)]]
      )

      AUX <- Ensemble[
        Mw == MwTarget & Repi == RepiTarget & dep == DepTarget & .matchP(p, "0.50")
      ][order(Tn)]
      OK <- nrow(AUX) >= 2L && data.table::uniqueN(AUX$Tn) >= 2L &&
        !nrow(AUX[, .N, by = Tn][N != 1L])
      if (!OK) stop(sprintf("gmpe.R: invalid response-spectrum grid for %s.", trt), call. = FALSE)
      Peak <- AUX[which.max(Sa)]
      TnPeak <- Peak$Tn[[1L]]
      Band <- Ensemble[Mw == MwTarget & Repi == RepiTarget & dep == DepTarget & Tn == TnPeak]
      Spectrum <- data.table::data.table(
        TRT = trt,
        Mw = MwTarget,
        Repi = RepiTarget,
        dep = DepTarget,
        Tn.peak = TnPeak,
        Sa.p50.peak = Peak$Sa[[1L]],
        Sa.p05.peak = getValue(Band, "0.05", paste(Context, "spectral peak")),
        Sa.p95.peak = getValue(Band, "0.95", paste(Context, "spectral peak"))
      )
      Spectrum[, Sa.band.factor := Sa.p95.peak / Sa.p05.peak]
      OK <- with(Spectrum, Sa.p05.peak < Sa.p50.peak & Sa.p50.peak < Sa.p95.peak)
      if (!OK) stop(sprintf("gmpe.R: unordered spectral mixture quantiles for %s.", trt), call. = FALSE)

      list(ref = Ref, atten = Attenuation, spectrum = Spectrum)
    })

    list(
      ref = data.table::rbindlist(lapply(Products, function(x) x$ref)),
      atten = data.table::rbindlist(lapply(Products, function(x) x$atten)),
      spectrum = data.table::rbindlist(lapply(Products, function(x) x$spectrum))
    )
  })

  GMPE.ref <- .GMPE.products$ref
  GMPE.atten <- .GMPE.products$atten
  GMPE.spectrum <- .GMPE.products$spectrum
  rm(.GMPE.products)
}
# nolint end
