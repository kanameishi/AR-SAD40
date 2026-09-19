# nolint start
# Master index of published products, derived from manifest.json.
knitTocContents <- function(root, scope = "main", language = "en") {
  # El índice se deriva de manifest.json: ahí está lo que el propietario
  # decidió publicar, con el dominio de cada artefacto ya declarado. Mantener una
  # lista propia duplicaba esa verdad y dejaba enlaces muertos en los proyectos
  # que publican un subconjunto (AR-SAC00 no publica selección de sismos).
  FILE <- file.path(root, "manifest.json")
  if (!file.exists(FILE)) {
    stop("manifest.json not found at the project root; the index is built from it.", call. = FALSE)
  }
  TOC <- jsonlite::fromJSON(FILE, simplifyVector = FALSE)$artifacts

  # Orden del índice maestro. Para cambiarlo, se cambia esta línea. Un alias que
  # no figure acá se lista al final, en el orden del manifest, de modo que un
  # producto nuevo aparece sin tener que tocar nada.
  # Un solo alias de reporte, como gmdp: se renderizan los dos idiomas y se
  # publica el que el proyecto declara en su manifest.
  GMDP <- c("ts", "dn", "kmax", "kh")
  ORDER <- c("report", "sha", "sdc", "gmdp", "srs", GMDP)

  # Nombre visible por alias, en el idioma del documento. Los decks de la
  # familia SRS se publican solo en ingles —son galerias de figuras sin prosa—
  # pero el indice los nombra en español cuando corresponde. Un alias sin
  # entrada usa su propio alias.
  NAMES <- if (identical(language, "es")) c(
    report    = "Reporte Ejecutivo",
    sha       = "Evaluación de Amenaza Sísmica",
    sdc       = "Criterios de Diseño Sísmico",
    gmdp      = "Parámetros de Diseño Sísmico",
    srs       = "Selección de Registros Sísmicos",
    ts        = "Períodos fundamentales",
    dn        = "Desplazamientos de Newmark",
    kmax      = "Coeficiente sísmico $k_{max}$",
    kh        = "Coeficiente sísmico $k_h$",
    at        = "Historias de aceleración",
    vt        = "Historias de velocidad",
    dt        = "Historias de desplazamiento",
    ai        = "Intensidad de Arias",
    cav       = "Velocidad absoluta acumulada",
    cav5      = "CAV5",
    psa       = "Aceleración pseudo-espectral",
    psv       = "Velocidad pseudo-espectral",
    sd        = "Desplazamiento espectral",
    its       = "Historias modales VMD retenidas",
    ipsa      = "Espectros de respuesta modales VMD retenidos"
  ) else c(
    report    = "Executive Report",
    sha       = "Seismic Hazard Assessment",
    sdc       = "Seismic Design Criteria",
    gmdp      = "Ground-Motion Design Parameters",
    srs       = "Seismic Record Selection",
    ts        = "Fundamental Periods",
    dn        = "Newmark Displacements",
    kmax      = "Seismic Coefficient $k_{max}$",
    kh        = "Seismic Coefficient $k_h$",
    at        = "Acceleration time series",
    vt        = "Velocity time series",
    dt        = "Displacement time series",
    ai        = "Arias intensity",
    cav       = "Cumulative absolute velocity",
    cav5      = "CAV5",
    psa       = "Pseudo-spectral acceleration",
    psv       = "Pseudo-spectral velocity",
    sd        = "Spectral displacement",
    its       = "Intensity-target spectra",
    ipsa      = "Individual PSA matches"
  )

  # Los once productos de selección de sismos son maestros aparte por tamaño, no
  # por tema: cuelgan de srs.qmd y no del índice maestro. Se reconocen porque su
  # maestro lleva su propio alias (srs.at.qmd para at); el maestro de idioma
  # (srs.es.qmd) lleva el alias srs y queda en el índice maestro.
  .spectrum <- function(a) identical(basename(as.character(a$renderSource)), sprintf("srs.%s.qmd", a$alias))

  TOC <- Filter(function(a) !identical(a$alias, "toc"), TOC)
  SCOPE <- scope
  if (identical(SCOPE, "srs")) TOC <- Filter(.spectrum, TOC)
  if (identical(SCOPE, "gmdp")) {
    TOC <- Filter(function(a) a$alias %in% GMDP, TOC)
    AUX <- vapply(TOC, function(a) a$alias, character(1))
    if (length(AUX) != length(GMDP) || !setequal(AUX, GMDP)) {
      stop("GMDP requires one manifest entry for each of ts, dn, kmax and kh.", call. = FALSE)
    }
  }
  if (!SCOPE %in% c("srs", "gmdp")) {
    TOC <- Filter(function(a) !.spectrum(a) && !a$alias %in% GMDP, TOC)
  }
  TOC <- TOC[order(match(vapply(TOC, function(a) a$alias, character(1)), ORDER, nomatch = length(ORDER) + 1L))]

  OUT <- character(0)
  for (a in TOC) {
    if (is.null(a$domain) || !nzchar(a$domain)) {
      if (identical(SCOPE, "gmdp")) {
        stop("GMDP manifest entry requires a domain: ", a$alias, call. = FALSE)
      }
      next
    }
    # Los dos niveles llevan el mismo formato: sólo el nombre del producto. Un
    # alias sin nombre declarado se muestra por su alias.
    LABEL <- if (a$alias %in% names(NAMES)) NAMES[[a$alias]] else a$alias
    OUT <- c(OUT, sprintf('- [ ] [%s](https://%s){target="_blank"}', LABEL, a$domain))
  }
  cat(OUT, sep = "\n")
  cat("\n")
  invisible(NULL)
}
# nolint end
