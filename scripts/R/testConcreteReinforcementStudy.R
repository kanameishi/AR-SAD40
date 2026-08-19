# Regression for the discrete symmetric circumferential-reinforcement family.

Arguments <- commandArgs(trailingOnly = FALSE)
FileArgument <- grep("^--file=", Arguments, value = TRUE)
if (length(FileArgument) != 1L) {
  stop(
    "Run with Rscript scripts/R/testConcreteReinforcementStudy.R.",
    call. = FALSE
  )
}
ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
projectRoot <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
source(
  file.path(projectRoot, "scripts", "setup", "calculationFunctions.R"),
  local = TRUE
)

Manifest <- readCalculationJson(file.path(projectRoot, "calculation.json"))
Inputs <- Manifest[["inputs", exact = TRUE]]
Context <- prepareCoverCaseContext(
  inputs = Inputs,
  projectRoot = projectRoot,
  methodID = Manifest[["methodID", exact = TRUE]]
)
Sample <- evaluateCoverSample(inputs = Inputs, context = Context)
stopifnot(is.null(Sample[["reinforcementStudy", exact = TRUE]]))
Study <- .evaluateCoverReinforcementStudy(
  config = Context[["baselineResolved", exact = TRUE]][[
    "config",
    exact = TRUE
  ]],
  additionalLinings = Sample[["additionalLinings", exact = TRUE]],
  steelSection = Sample[["section", exact = TRUE]]
)

stopifnot(identical(
  names(Study),
  c("domains", "summary", "governingDemands", "limitChecks")
))
Domains <- Study[["domains", exact = TRUE]]
Summary <- Study[["summary", exact = TRUE]]
GoverningDemands <- Study[["governingDemands", exact = TRUE]]
LimitChecks <- Study[["limitChecks", exact = TRUE]]
ExpectedDiameters <- c(8, 10, 12)
ExpectedSpacings <- rep(150, 3L)
stopifnot(
  is.data.frame(Domains),
  is.data.frame(Summary),
  is.data.frame(GoverningDemands),
  is.data.frame(LimitChecks),
  nrow(Summary) == 2L * (length(ExpectedDiameters) + 1L),
  setequal(unique(Summary$liningID), c("shotcrete", "reinforcedConcrete")),
  sum(Summary$isParametricCase) == 2L * length(ExpectedDiameters),
  sum(!Summary$isParametricCase) == 2L,
  all(Summary$calculationStatus == "calculated"),
  all(Summary$demandReuseStatus == "satisfied"),
  nrow(GoverningDemands) == 2L * (length(ExpectedDiameters) + 1L) * 2L,
  nrow(LimitChecks) == 2L * (length(ExpectedDiameters) + 1L) * 2L,
  setequal(
    unique(LimitChecks$checkID),
    c("one-way-shear", "radial-tension-without-radial-stirrups")
  ),
  all(GoverningDemands$selectionBasisID ==
    "reinforcement-domain-interface-envelope")
)
for (LiningID in c("shotcrete", "reinforcedConcrete")) {
  S <- Summary[Summary$liningID == LiningID, , drop = FALSE]
  D <- Domains[Domains$liningID == LiningID, , drop = FALSE]
  G <- GoverningDemands[GoverningDemands$liningID == LiningID, , drop = FALSE]
  L <- LimitChecks[LimitChecks$liningID == LiningID, , drop = FALSE]
  Groups <- split(D, D$reinforcementCaseID)
  Parametric <- S$isParametricCase
  ExpectedAreas <- 2 * pi * ExpectedDiameters^2 / 4 *
    1000 / ExpectedSpacings
  ThicknessMm <- if (LiningID == "shotcrete") 100 else 150
  ExpectedRatios <- ExpectedAreas / (1000 * ThicknessMm)
  stopifnot(
    identical(
      S$reinforcementCaseOrder,
      seq_len(length(ExpectedDiameters) + 1L)
    ),
    identical(S$barDiameterMm[Parametric], ExpectedDiameters),
    identical(S$barSpacingMm[Parametric], ExpectedSpacings),
    isTRUE(all.equal(
      S$reinforcementRatio[Parametric],
      ExpectedRatios,
      tolerance = 1e-12
    )),
    all(diff(S$maximumRadialUtilization[Parametric]) <= 0.02),
    S$reinforcementCaseID[!Parametric] ==
      "existing-sheet-plus-interior-d8-s150",
    S$demandReuseBasisID[!Parametric] ==
      "full-composite-recalculated-demands",
    length(Groups) == nrow(S),
    all(vapply(Groups, function(x) {
      identical(x$domainPointIndex, seq_len(nrow(x))) &&
        length(unique(x$domainPrimitiveID)) == 1L
    }, logical(1))),
    nrow(G) == 2L * (length(ExpectedDiameters) + 1L),
    identical(
      G$demandOrder,
      seq_len(2L * (length(ExpectedDiameters) + 1L))
    ),
    all(table(G$reinforcementCaseID) == 2L),
    all(table(G$interfaceID) == length(ExpectedDiameters) + 1L),
    nrow(L) == 2L * (length(ExpectedDiameters) + 1L),
    all(table(L$reinforcementCaseID) == 2L)
  )
}

cat("PASS: three physical P-M mesh domains, one composite case and separate checks per thickness.\n")
