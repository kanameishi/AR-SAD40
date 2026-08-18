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
  additionalLinings = Sample[["additionalLinings", exact = TRUE]]
)

stopifnot(identical(
  names(Study),
  c("domains", "summary", "governingDemands")
))
Domains <- Study[["domains", exact = TRUE]]
Summary <- Study[["summary", exact = TRUE]]
GoverningDemands <- Study[["governingDemands", exact = TRUE]]
ExpectedRatios <- c(0.0018, 0.01, 0.02, 0.03)
stopifnot(
  is.data.frame(Domains),
  is.data.frame(Summary),
  is.data.frame(GoverningDemands),
  nrow(Summary) == 2L * length(ExpectedRatios),
  setequal(unique(Summary$liningID), c("shotcrete", "reinforcedConcrete")),
  all(Summary$isParametricCase),
  all(Summary$calculationStatus == "calculated"),
  all(Summary$demandReuseStatus == "satisfied"),
  nrow(GoverningDemands) == 8L,
  all(GoverningDemands$selectionBasisID == "lower-reference-domain")
)
for (LiningID in c("shotcrete", "reinforcedConcrete")) {
  S <- Summary[Summary$liningID == LiningID, , drop = FALSE]
  D <- Domains[Domains$liningID == LiningID, , drop = FALSE]
  G <- GoverningDemands[GoverningDemands$liningID == LiningID, , drop = FALSE]
  Groups <- split(D, D$reinforcementCaseID)
  stopifnot(
    identical(S$reinforcementCaseOrder, seq_along(ExpectedRatios)),
    isTRUE(all.equal(S$reinforcementRatio, ExpectedRatios, tolerance = 1e-12)),
    sum(S$isLowerReferenceCase) == 1L,
    all(diff(S$maximumRadialUtilization) <= 0.02),
    length(Groups) == nrow(S),
    all(vapply(Groups, function(x) {
      identical(x$domainPointIndex, seq_len(nrow(x))) &&
        length(unique(x$domainPrimitiveID)) == 1L
    }, logical(1))),
    nrow(G) == 4L,
    identical(G$demandOrder, 1:4)
  )
}

cat("PASS: four P-M domains and four governing demands for each thickness.\n")
