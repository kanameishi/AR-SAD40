Needs["RLink`"];

ClearAll[
  toRConfig,
  rRows,
  readRRows,
  readRRecord,
  readCoverProducts,
  readAdditionalLiningProducts,
  runCoverCalculation,
  associationLeafRows,
  coverCaseDefinitionView,
  engineeringTable,
  formatValue,
  checkName,
  scopeReasonName,
  caseName,
  strengthCaseName,
  resultantName,
  statisticName,
  quantityName,
  forceEffectBasisName,
  statusName,
  groundStressAndSteelSectionView,
  interactionExtremaView,
  prepareCircularResultantGeometry,
  circularResultantPlot,
  resultantsView,
  prismThrustView,
  aashtoView,
  concreteAlternativeView,
  concreteCommonView,
  concreteLiningView,
  pmReinforcementFamilyPlot,
  reinforcementStudyView,
  rObjectCatalogRows,
  rObjectExplorerView
];

toRConfig[a_Association] := RObject[
  RList[toRConfig /@ Values[a], RAttributes[]],
  RAttributes["names" :> Keys[a]]
];
toRConfig[x_List /; AllTrue[x, AssociationQ]] :=
  RList[toRConfig /@ x, RAttributes[]];
toRConfig[x_] := x;

rRows[df_] := AssociationThread[RGetNames[df], #] & /@
  Transpose[RGetData[df]];
readRRows[expression_String] := rRows @ REvaluate[expression];
readRRecord[expression_String] := First @ readRRows[expression];

readCoverProducts[] := <|
  "theta" -> readRRows["workbookProducts$theta"],
  "stress" -> readRRows[
    "workbookProducts$stress[c('coverCrownM','depthM','effectiveUnitWeightKnPerM3','upperLayerHeightM','upperLayerUnitWeightKnPerM3','effectiveSurchargeKPa','effectiveVerticalStressKPa','effectiveHorizontalStressKPa','k0Applied')]"
  ],
  "section" -> readRRows["workbookProducts$section"],
  "interaction" -> readRRows["workbookProducts$interaction"],
  "schwartzEinstein" -> readRRows[
    "workbookProducts$schwartzEinsteinComparison"
  ],
  "hybridGradient" -> readRRows["workbookProducts$hybridGradient"],
  "resultants" -> readRRows["workbookProducts$resultants"],
  "extrema" -> readRRows["workbookProducts$extrema"],
  "controls" -> readRRows["workbookProducts$controls"],
  "aashto" -> <|
    "inputs" -> readRRows["workbookProducts$aashto$inputs"],
    "thrust" -> readRRows["workbookProducts$aashto$thrust"],
    "calculation" -> readRRows["workbookProducts$aashto$calculation"],
    "checks" -> readRRows["workbookProducts$aashto$checks"],
    "summary" -> readRRows["workbookProducts$aashto$summary"]
  |>
|>;

readAdditionalLiningProducts[name_String] := (
  RSet["workbookLiningID", name];
  <|
    "section" -> readRRows[
      "workbookProducts$additionalLinings[[workbookLiningID]]$section"
    ],
    "schwartzEinstein" -> readRRows[
      "workbookProducts$additionalLinings[[workbookLiningID]]$schwartzEinsteinComparison"
    ],
    "hybridGradient" -> readRRows[
      "workbookProducts$additionalLinings[[workbookLiningID]]$hybridGradient"
    ],
    "resultants" -> readRRows[
      "workbookProducts$additionalLinings[[workbookLiningID]]$resultants"
    ],
    "assessment" -> <|
      "aci" -> <|
        "checks" -> readRRows[
          "workbookProducts$additionalLinings[[workbookLiningID]]$assessment$aci$checks"
        ],
        "controls" -> readRRows[
          "workbookProducts$additionalLinings[[workbookLiningID]]$assessment$aci$controls"
        ],
        "summary" -> readRRows[
          "workbookProducts$additionalLinings[[workbookLiningID]]$assessment$aci$summary"
        ]
      |>
    |>,
    "summary" -> readRRows[
      "workbookProducts$additionalLinings[[workbookLiningID]]$summary"
    ],
    "reinforcementStudy" -> <|
      "domains" -> readRRows[
        "workbookProducts$reinforcementStudy$domains[workbookProducts$reinforcementStudy$domains$liningID == workbookLiningID, , drop = FALSE]"
      ],
      "summary" -> readRRows[
        "workbookProducts$reinforcementStudy$summary[workbookProducts$reinforcementStudy$summary$liningID == workbookLiningID, , drop = FALSE]"
      ],
      "governingDemands" -> readRRows[
        "workbookProducts$reinforcementStudy$governingDemands[workbookProducts$reinforcementStudy$governingDemands$liningID == workbookLiningID, , drop = FALSE]"
      ],
      "limitChecks" -> readRRows[
        "workbookProducts$reinforcementStudy$limitChecks[workbookProducts$reinforcementStudy$limitChecks$liningID == workbookLiningID, , drop = FALSE]"
      ]
    |>
  |>
);

readAdditionalLiningProducts[
  name_String,
  _String
] := readAdditionalLiningProducts[name];

runCoverCalculation[inputs_Association] := Module[
  {
    projectRoot, coverProducts, additionalProducts, rootSummary,
    methodBasis, derived, graphics, aashtoProfile, seamProfile
  },
  projectRoot = ExpandFileName @ FileNameJoin[{
    NotebookDirectory[], "..", ".."
  }];
  Once[
    RLink`InstallR[];
    RLink`REvaluate["options(verbose = FALSE)"];
    RLink`RSet["projectRoot", projectRoot];
    RLink`REvaluate[
      "source(file.path(projectRoot, 'scripts', 'setup', 'calculationFunctions.R'))"
    ];
  ];
  RLink`REvaluate["workbookProducts <- NULL"];
  RLink`RSet["workbookInputs", toRConfig[inputs]];
  If[
    RLink`REvaluate[
      "{ workbookProducts <- evaluateCoverCase(inputs = workbookInputs, projectRoot = projectRoot); invisible(NULL) }"
    ] === $Failed,
    Return[$Failed]
  ];
  coverProducts = readCoverProducts[];
  additionalProducts = <|
    "shotcrete" -> readAdditionalLiningProducts[
      "shotcrete", "plain-concrete"
    ],
    "reinforcedConcrete" -> readAdditionalLiningProducts[
      "reinforcedConcrete", "reinforced-concrete"
    ]
  |>;
  rootSummary = readRRecord[
    "data.frame(contractVersion = workbookProducts$contractVersion, scenarioID = workbookProducts$scenarioID, check.names = FALSE)"
  ];
  methodBasis = readRRecord[
    "as.data.frame(workbookProducts$methodBasis[c('requestedMethodID','methodProfileID','methodProfileVersion')], check.names = FALSE)"
  ];
  derived = readRRecord[
    "as.data.frame(workbookProducts$derived[c('scenarioID','steelSpanM','totalUnitWeightKnPerM3','plainConcreteCentroidalRadiusM','reinforcedConcreteCentroidalRadiusM','reinforcedClearCoverMm','reinforcedLayerCentroidCoverMm','reinforcedInteriorLayerCoordinateMm','reinforcedExteriorLayerCoordinateMm','reinforcementYieldStrengthMPa')], check.names = FALSE)"
  ];
  graphics = readRRecord[
    "as.data.frame(workbookProducts$derived$resolvedConfig$graphics[c('graphicAmplification','radialFraction','ordinateCount')], check.names = FALSE)"
  ];
  aashtoProfile = readRRecord[
    "as.data.frame(workbookProducts$derived$resolvedConfig$aashto[c('standardID','editionID','specificationStatus','demandSourceKey','demandSourceLocator','wallSourceKey','wallSourceLocator','seamFactorSourceKey','seamFactorSourceLocator')], check.names = FALSE)"
  ];
  seamProfile = readRRecord[
    "as.data.frame(workbookProducts$derived$resolvedConfig$aashto$seam[c('sourceKey','sourceLocator')], check.names = FALSE)"
  ];
  <|
    "contractVersion" -> rootSummary["contractVersion"],
    "scenarioID" -> rootSummary["scenarioID"],
    "inputs" -> inputs,
    "methodBasis" -> methodBasis,
    "derived" -> derived,
    "resolvedConfig" -> <|
      "graphics" -> graphics,
      "aashto" -> Append[aashtoProfile, "seam" -> seamProfile]
    |>,
    "cover" -> coverProducts,
    "additionalLinings" -> additionalProducts
  |>
];

engineeringTable[headers_List, rows_List, alignments_List] := With[
  {
    header = Item[Style[#, White, Bold], Background -> RGBColor[0.14, 0.20, 0.28]] & /@ headers,
    body = MapIndexed[
      Function[{row, index},
        Item[
          #,
          Background -> If[
            OddQ[First[index]],
            White,
            RGBColor[0.965, 0.972, 0.98]
          ]
        ] & /@ row
      ],
      rows
    ]
  },
  Grid[
    Prepend[body, header],
    Alignment -> {alignments, Center},
    Dividers -> {None, All -> RGBColor[0.82, 0.85, 0.88]},
    ItemSize -> Full,
    Spacings -> {{1.1, 1.1}, {0.55, 0.55}}
  ]
];

formatValue[_Missing, ___] := "\[LongDash]";
formatValue[x_?NumericQ, decimals_:3] := ToString @ NumberForm[
  N[x],
  {20, decimals},
  NumberPadding -> {"", "0"},
  DigitBlock -> {3, Infinity},
  NumberSeparator -> {",", ""},
  ExponentFunction -> (Null &)
];
formatValue[x_, ___] := x;

associationLeafRows[value_Association, path_List : {}] := Flatten[
  KeyValueMap[
    associationLeafRows[#2, Append[path, #1]] &,
    value
  ],
  1
];
associationLeafRows[value_, path_List : {}] := {{
  StringRiffle[path, " / "],
  formatValue[value, 6]
}};

coverCaseDefinitionView[evaluation_Association] := OpenerView[{
  Style["Resolved inputs, method basis, and derived values", Bold],
  Column[{
    Style["Resolved engineering inputs", Bold],
    engineeringTable[
      {"Input path", "Value"},
      associationLeafRows[evaluation["inputs"]],
      {Left, Left}
    ],
    Style["Method basis", Bold],
    engineeringTable[
      {"Method path", "Resolved value"},
      associationLeafRows[evaluation["methodBasis"]],
      {Left, Left}
    ],
    Style["Derived values", Bold],
    engineeringTable[
      {"Derived path", "Value"},
      associationLeafRows[evaluation["derived"]],
      {Left, Left}
    ]
  }, Spacings -> 1.2]
}, False];

checkName[id_] := Lookup[
  <|
    "wall-yield" -> "Wall yield",
    "wall-buckling" -> "Wall buckling",
    "seam" -> "Seam or connection",
    "flexibility" -> "Installation flexibility",
    "minimum-cover" -> "Minimum cover",
    "tension-face" -> "Tension face",
    "compression-face" -> "Compression face",
    "one-way-shear" -> "One-way shear",
    "axial-flexure" -> "Axial force and bending",
    "minimum-circumferential-reinforcement" -> "Minimum circumferential reinforcement",
    "minimum-longitudinal-reinforcement" -> "Minimum longitudinal reinforcement",
    "equal-reinforcement-at-opposite-faces" -> "Equal reinforcement at opposite faces",
    "minimum-concrete-strength" -> "Minimum concrete strength",
    "structural-classification" -> "Structural classification",
    "plain-concrete-permission" -> "Plain-concrete permission",
    "longitudinal-action" -> "Longitudinal action",
    "reinforcement-detailing" -> "Reinforcement detailing",
    "current-shell-code" -> "Current thin-shell code",
    "global-stability" -> "Global shell stability",
    "durability" -> "Durability",
    "serviceability" -> "Serviceability"
  |>,
  id,
  id
];

scopeReasonName[id_] := Lookup[
  <|
    "longitudinal-boundary-condition-not-characterized" -> "Longitudinal boundary action is not characterized",
    "reinforced-one-way-shear-not-implemented" -> "Reinforced one-way shear is outside the implemented check",
    "bar-size-spacing-cover-and-development-not-provided" -> "Bar size, spacing, cover, and development are not provided",
    "aci-318.2-25-operative-text-required" -> "Operative ACI CODE-318.2-25 provisions are not available in the project evidence set",
    "global-shell-stability-not-evaluated" -> "Global shell stability is outside the local section check",
    "exposure-classes-not-provided" -> "Exposure classes are not provided",
    "service-combination-and-crack-model-not-provided" -> "Service combinations and a cracking model are not provided",
    "structural-classification-not-characterized" -> "The structural classification required by ACI 318-25 Section 1.4.4 is not established",
    "plain-concrete-permission-not-characterized" -> "The qualifying support condition for plain concrete under ACI 318-25 Section 14.1.2 is not established"
  |>,
  id,
  id
];

caseName[id_] := Lookup[
  <|
    "slip" -> "Slip (S)",
    "no-slip" -> "No Slip (NS)",
    "full-traction" -> "Tangential projection included",
    "normal-only" -> "Normal projection only",
    "full-slip" -> "Slip (S)"
  |>,
  id,
  id
];

strengthCaseName[id_] := Lookup[
  <|
    "ev130-eh135" -> "Vertical earth pressure EV x1.30; horizontal earth pressure EH x1.35",
    "ev130-eh090" -> "Vertical earth pressure EV x1.30; horizontal earth pressure EH x0.90",
    "ev090-eh135" -> "Vertical earth pressure EV x0.90; horizontal earth pressure EH x1.35",
    "ev090-eh090" -> "Vertical earth pressure EV x0.90; horizontal earth pressure EH x0.90"
  |>,
  id,
  id
];

resultantName[id_] := Lookup[
  <|"N" -> "N(\[Theta])", "M" -> "M(\[Theta])", "Q" -> "Q(\[Theta])"|>,
  id,
  id
];

statisticName[id_] := Lookup[
  <|
    "minimum" -> "Minimum",
    "maximum" -> "Maximum",
    "absolute-maximum" -> "Absolute maximum"
  |>,
  id,
  id
];

quantityName[id_] := Lookup[
  <|
    "dead-crown-pressure" -> "Dead crown pressure",
    "dead-service-thrust" -> "Dead service thrust",
    "live-service-thrust" -> "Live service thrust",
    "factored-thrust" -> "Factored thrust",
    "modified-demand" -> "Modified factored prism-thrust demand, Tu"
  |>,
  id,
  id
];

forceEffectBasisName[id_] := Lookup[
  <|
    "unfactored-input" -> "Unfactored input",
    "unfactored-service" -> "Unfactored service",
    "factored-demand" -> "Factored demand",
    "modified-factored-demand" -> "Modified factored demand"
  |>,
  id,
  id
];

statusName[id_] := Lookup[
  <|
    "satisfied" -> "Satisfied",
    "not-satisfied" -> "Not satisfied",
    "incomplete" -> "Incomplete",
    "not-evaluated" -> "Not evaluated",
    "not-evaluated-inputs" -> "Not evaluated \[LongDash] missing inputs",
    "not-evaluated-specification" -> "Not evaluated \[LongDash] current specification not verified",
    "inside-supplied-domain" -> "Within supplied domain",
    "outside-supplied-domain" -> "Outside supplied domain",
    "not-evaluated-code-basis" -> "Not evaluated \[LongDash] code basis",
    "not-evaluated-convergence" -> "Not evaluated \[LongDash] no convergence",
    "not-applicable" -> "Not applicable",
    "not-applied" -> "Not applicable",
    "applied" -> "Applied",
    "blocked" -> "Outside evaluated scope",
    "historical" -> "Historical",
    "reference-basis-not-current" -> "Reference basis \[LongDash] not current",
    "minimum-shell-reinforcement-only" -> "Minimum shell reinforcement only"
  |>,
  id,
  id
];

groundStressAndSteelSectionView[products_Association] := With[
  {
    stress = First[products["stress"]],
    section = First[products["section"]]
  },
  Column[{
    Style["Shared free-field geostatic effective stress at the reference position", Bold],
    engineeringTable[
      {"Ground-stress quantity", "Value", "Unit"},
      {
        {"Lower compacted-fill height above crown", formatValue[stress["coverCrownM"]], "m"},
        {"Reference depth", formatValue[stress["depthM"]], "m"},
        {"Lower compacted-fill unit weight", formatValue[stress["effectiveUnitWeightKnPerM3"]], "kN/m^3"},
        {"Upper mud-layer height", formatValue[stress["upperLayerHeightM"]], "m"},
        {"Upper mud-layer unit weight", formatValue[stress["upperLayerUnitWeightKnPerM3"]], "kN/m^3"},
        {"Permanent pressure from upper layer, qD", formatValue[stress["effectiveSurchargeKPa"]], "kPa"},
        {"Effective vertical stress", formatValue[stress["effectiveVerticalStressKPa"]], "kPa"},
        {"Effective horizontal stress", formatValue[stress["effectiveHorizontalStressKPa"]], "kPa"},
        {"Applied K0", formatValue[stress["k0Applied"]], "\[LongDash]"}
      },
      {Left, Right, Center}
    ],
    Spacer[10],
    Style["Corrugated-steel section properties and circumferential stiffness", Bold],
    engineeringTable[
      {"Corrugated-steel property", "Value", "Unit"},
      {
        {"Specified nominal thickness", formatValue[section["specifiedThicknessMm"], 1], "mm"},
        {"Published design base thickness", formatValue[section["designBaseThicknessMm"], 2], "mm"},
        {"Remaining analyzed thickness", formatValue[section["remainingBaseThicknessMm"], 1], "mm"},
        {"Area per projected width", formatValue[section["areaMm2PerMm"]], "mm^2/mm"},
        {"Second moment per projected width", formatValue[section["inertiaMm4PerMm"]], "mm^4/mm"},
        {"Extensional stiffness, EA", formatValue[section["extensionalRigidityKnPerM"], 0], "kN/m"},
        {"Flexural stiffness, EI", formatValue[section["flexuralRigidityKnM2PerM"], 0], "kN\[CenterDot]m^2/m"}
      },
      {Left, Right, Center}
    ]
  }, Spacings -> 1.2]
];

interactionExtremaView[products_Association] := With[
  {
    caseIDs = DeleteDuplicates @ Lookup[products["extrema"], "caseID"],
    resultantIDs = {"N", "M", "Q"},
    extrema = products["extrema"]
  },
  Column[{
    Style["Prescribed-load direct-integration control", Bold],
    engineeringTable[
      {"Projection", "Tangential multiplier", "[Eta]s", "Mean N [kN/m]", "Cosine N [kN/m]", "Mean M [kN\[CenterDot]m/m]", "Cosine M [kN\[CenterDot]m/m]", "Sine Q [kN/m]"},
      ({
        caseName[#1["interfaceID"]],
        formatValue[#1["tangentialMultiplier"], 0],
        formatValue[#1["sectionRatio"], 6],
        formatValue[#1["normalMeanKnPerM"], 0],
        formatValue[#1["normalCosineKnPerM"], 0],
        formatValue[#1["momentMeanKnMPerM"], 0],
        formatValue[#1["momentCosineKnMPerM"], 0],
        formatValue[#1["shearSineKnPerM"], 0]
      } &) /@ products["interaction"],
      {Left, Right, Right, Right, Right, Right, Right, Right}
    ],
    Spacer[10],
    Style["Schwartz-Einstein uniform-field interaction coefficients", Bold],
    engineeringTable[
      {"Interface", "C*", "F*", "t0", "t2", "m2", "Mean N [kN/m]", "Cosine N [kN/m]", "Cosine M [kN[CenterDot]m/m]", "Sine Q [kN/m]"},
      ({
        caseName[#1["interfaceID"]],
        formatValue[#1["cStar"], 6],
        formatValue[#1["fStar"], 3],
        formatValue[#1["t0"], 6],
        formatValue[#1["t2"], 6],
        formatValue[#1["m2"], 6],
        formatValue[#1["normalMeanKnPerM"], 0],
        formatValue[#1["normalCosineKnPerM"], 0],
        formatValue[#1["momentCosineKnMPerM"], 0],
        formatValue[#1["shearSineKnPerM"], 0]
      } &) /@ products["schwartzEinstein"],
      {Left, Right, Right, Right, Right, Right, Right, Right, Right, Right}
    ],
    Spacer[10],
    Style["Balanced geostatic-gradient correction", Bold],
    engineeringTable[
      {"Interface", "Vertical gradient [kPa/m]", "Horizontal gradient [kPa/m]", "Radial n=1 reaction [kPa]", "N1 [kN/m]", "N3 [kN/m]", "M3 [kN m/m]", "Q3 [kN/m]", "Minimum compression [kPa]", "Equilibrium"},
      ({
        caseName[#1["interfaceID"]],
        formatValue[#1["verticalStressGradientKPaPerM"], 0],
        formatValue[#1["horizontalStressGradientKPaPerM"], 0],
        formatValue[#1["supportRadialMode1KPa"], 0],
        formatValue[#1["normalMode1KnPerM"], 0],
        formatValue[#1["normalMode3KnPerM"], 0],
        formatValue[#1["momentMode3KnMPerM"], 0],
        formatValue[#1["shearMode3KnPerM"], 0],
        formatValue[#1["minimumPrescribedCompressivePressureKPa"], 0],
        statusName[#1["equilibriumStatus"]]
      } &) /@ products["hybridGradient"],
      {Left, Right, Right, Right, Right, Right, Right, Right, Right, Center}
    ],
    Spacer[10],
    Style["Hybrid design extrema: E-S uniform field plus balanced gradient", Bold],
    engineeringTable[
      {"Projection", "Resultant", "Minimum", "\[Theta] at min [deg]", "Maximum", "\[Theta] at max [deg]", "Absolute maximum", "\[Theta] at |max| [deg]", "Unit"},
      Flatten[
        Table[
          With[
            {
              stats = AssociationThread[
                Lookup[Select[extrema, #1["caseID"] === case && #1["resultantID"] === resultant &], "statisticID"],
                Select[extrema, #1["caseID"] === case && #1["resultantID"] === resultant &]
              ]
            },
            {
              caseName[case],
              resultantName[resultant],
              formatValue[stats["minimum"]["signedValue"], 0],
              formatValue[stats["minimum"]["thetaDeg"], 1],
              formatValue[stats["maximum"]["signedValue"], 0],
              formatValue[stats["maximum"]["thetaDeg"], 1],
              formatValue[stats["absolute-maximum"]["value"], 0],
              formatValue[stats["absolute-maximum"]["thetaDeg"], 1],
              stats["minimum"]["unit"]
            }
          ],
          {case, caseIDs},
          {resultant, resultantIDs}
        ],
        1
      ],
      {Left, Center, Right, Right, Right, Right, Right, Right, Center}
    ]
  }, Spacings -> 1.2]
];

prepareCircularResultantGeometry[
  rows_List,
  referenceRadius_,
  graphics_Association,
  resultantID_
] := With[
  {
    selected = Select[rows, #1["resultantID"] === resultantID &],
    caseIDs = DeleteDuplicates @ Lookup[rows, "caseID"],
    ordinateCount = graphics["ordinateCount"]
  },
  With[
    {
      caseRows = AssociationMap[
        Function[case,
          SortBy[
            Select[selected, Function[row, row["caseID"] === case]],
            #1["thetaIndex"] &
          ]
        ],
        caseIDs
      ],
      maximum = Max[Abs @ Lookup[selected, "value"]]
    },
    With[
      {
        baseScale = graphics["radialFraction"] referenceRadius/maximum,
        phase = AssociationThread[
          caseIDs,
          Range[0, Length[caseIDs] - 1] Pi/ordinateCount
        ]
      },
      With[
        {
          displayScale = graphics["graphicAmplification"] baseScale,
          limit = referenceRadius (
            1 + graphics["graphicAmplification"] graphics["radialFraction"] + 0.18
          )
        },
        <|
          "resultantID" -> resultantID,
          "unit" -> First @ Lookup[selected, "unit"],
          "caseIDs" -> caseIDs,
          "referenceRadius" -> referenceRadius,
          "maximum" -> maximum,
          "baseScale" -> baseScale,
          "displayScale" -> displayScale,
          "graphicAmplification" -> graphics["graphicAmplification"],
          "radialFraction" -> graphics["radialFraction"],
          "limit" -> limit,
          "curves" -> AssociationMap[
            Function[case,
              With[
                {
                  points = Function[row,
                    (referenceRadius + displayScale row["value"])
                      {Sin[row["thetaRad"]], Cos[row["thetaRad"]]}
                  ] /@ caseRows[case]
                },
                Append[points, First[points]]
              ]
            ],
            caseIDs
          ],
          "rays" -> AssociationMap[
            Function[case,
              With[
                {
                  current = caseRows[case],
                  targets = Sort @ Mod[
                    Range[0, ordinateCount - 1] 2 Pi/ordinateCount + phase[case],
                    2 Pi
                  ]
                },
                Function[row,
                  With[
                    {direction = {Sin[row["thetaRad"]], Cos[row["thetaRad"]]}},
                    <|
                      "thetaDeg" -> row["thetaDeg"],
                      "value" -> row["value"],
                      "sectionPoint" -> referenceRadius direction,
                      "curvePoint" ->
                        (referenceRadius + displayScale row["value"]) direction
                    |>
                  ]
                ] /@ current[[
                  (First @ Ordering[
                    Abs[Lookup[current, "thetaRad"] - #1],
                    1
                  ] &) /@ targets
                ]]
              ]
            ],
            caseIDs
          ]
        |>
      ]
    ]
  ]
];

circularResultantPlot[diagram_Association, title_] := With[
  {
    blue = RGBColor[0, 114/255, 178/255],
    orange = RGBColor[213/255, 94/255, 0],
    sectionGray = RGBColor[55/255, 65/255, 81/255],
    caseIDs = diagram["caseIDs"],
    radius = diagram["referenceRadius"],
    limit = diagram["limit"],
    curveStyles = {
      Directive[GrayLevel[0.18], AbsoluteThickness[1.8], AbsoluteDashing[{5, 3}]],
      Directive[GrayLevel[0.48], AbsoluteThickness[1.8], AbsoluteDashing[{10, 4}]]
    },
    rayDashes = {AbsoluteDashing[{5, 3}], AbsoluteDashing[{10, 4}]},
    rayOpacities = {0.70, 0.50}
  },
  With[
    {
      scaleOrigin = {-limit + 0.18 radius, -limit + 0.22 radius},
      scaleEnd = {
        -limit + 0.18 radius + diagram["displayScale"] diagram["maximum"],
        -limit + 0.22 radius
      },
      caseLegend = LineLegend[
        curveStyles,
        caseName /@ caseIDs,
        LegendLabel -> "Projection \[LongDash] curve style",
        LegendLayout -> "Row",
        LabelStyle -> 10
      ],
      signLegend = LineLegend[
        {
          Directive[blue, AbsoluteThickness[2]],
          Directive[orange, AbsoluteThickness[2]]
        },
        {"Positive: outward", "Negative: inward"},
        LegendLabel -> "Ordinate sign \[LongDash] ray colour",
        LegendLayout -> "Row",
        LabelStyle -> 10
      ]
    },
    Column[{
      Legended[
        Graphics[
          {
            MapIndexed[
              Function[{case, index},
                {
                  Directive[
                    blue,
                    Opacity[rayOpacities[[First[index]]]],
                    AbsoluteThickness[0.65],
                    rayDashes[[First[index]]]
                  ],
                  Line[
                    ({#1["sectionPoint"], #1["curvePoint"]} &) /@
                      Select[diagram["rays"][case], #1["value"] >= 0 &]
                  ],
                  Directive[
                    orange,
                    Opacity[rayOpacities[[First[index]]]],
                    AbsoluteThickness[0.65],
                    rayDashes[[First[index]]]
                  ],
                  Line[
                    ({#1["sectionPoint"], #1["curvePoint"]} &) /@
                      Select[diagram["rays"][case], #1["value"] < 0 &]
                  ]
                }
              ],
              caseIDs
            ],
            MapIndexed[
              Function[{case, index},
                {
                  curveStyles[[First[index]]],
                  Line[diagram["curves"][case]]
                }
              ],
              caseIDs
            ],
            Directive[sectionGray, AbsoluteThickness[2.4]],
            Circle[{0, 0}, radius],
            AxisObject[
              Line[{scaleOrigin, scaleEnd}],
              {0, diagram["maximum"]},
              TickPositions -> {{{0, diagram["maximum"]/2, diagram["maximum"]}}},
              TickLabels -> {{
                formatValue[0, 0],
                formatValue[diagram["maximum"]/2, 0],
                formatValue[diagram["maximum"], 0]
              }},
              TickDirection -> "Down",
              AxisLabel -> Placed[
                Row[{resultantName[diagram["resultantID"]], " [", diagram["unit"], "]"}],
                Below
              ],
              AxisStyle -> Directive[GrayLevel[0.25], AbsoluteThickness[1.2]],
              LabelStyle -> Directive[9, GrayLevel[0.25]],
              TicksStyle -> Directive[GrayLevel[0.25]]
            ],
            Style[
              {
                Text["Crown", {0, limit - 0.07 radius}],
                Text["Right side", {limit - 0.07 radius, 0}],
                Text["Invert", {0, -limit + 0.07 radius}],
                Text["Left side", {-limit + 0.07 radius, 0}]
              },
              9,
              GrayLevel[0.38]
            ]
          },
          Axes -> False,
          Frame -> False,
          AspectRatio -> 1,
          PlotRange -> {{-limit, limit}, {-limit, limit}},
          PlotRangePadding -> None,
          PlotRangeClipping -> False,
          ImagePadding -> {{50, 50}, {55, 55}},
          ImageSize -> 520,
          Background -> White,
          PlotLabel -> Style[Row[{title, " [", diagram["unit"], "]"}], 13, Bold]
        ],
        Placed[
          Grid[{{caseLegend}, {signLegend}}, Alignment -> Left, Spacings -> {1, 0.4}],
          Below
        ]
      ],
      Style[
        Row[{
          "Radial scale: ",
          "\[CapitalDelta]r = k_g ", resultantName[diagram["resultantID"]],
          "; k_g = ", formatValue[diagram["displayScale"], 6],
          " m/(", diagram["unit"], "); ruler spans 0 to max |",
          resultantName[diagram["resultantID"]], "|."
        }],
        9,
        GrayLevel[0.35]
      ]
    }, Alignment -> Center, Spacings -> 0.7]
  ]
];

resultantsView[
  products_Association,
  graphics_Association,
  liningTitle_
] := With[
  {
    radius = First[products["section"]]["centroidalRadiusM"],
    rows = products["resultants"],
    titles = <|
      "N" -> "Circumferential normal force, N(\[Theta])",
      "M" -> "Bending moment, M(\[Theta])",
      "Q" -> "Shear force, Q(\[Theta])"
    |>
  },
  Column[
    Join[
      {
        Style[Row[{liningTitle, " \[LongDash] circular section-resultant diagrams"}], Bold],
        Style[
          "Radial ordinates: blue is positive and orange is negative. Slip (S) and No Slip (NS) interfaces are distinguished by grey curve shade and dash pattern; every curve includes the balanced geostatic-gradient correction returned by R.",
          GrayLevel[0.30]
        ]
      },
      (circularResultantPlot[
        prepareCircularResultantGeometry[rows, radius, graphics, #1],
        titles[#1]
      ] &) /@ {"N", "M", "Q"},
      {
        Style[
          "Each resultant and lining has its own display scale. Compare physical magnitudes in the extrema tables, not by radial amplitude between diagrams. These curves are result diagrams, not deformed shapes.",
          GrayLevel[0.30]
        ]
      }
    ],
    Spacings -> 1.5
  ]
];

prismThrustView[products_Association] := Column[{
  engineeringTable[
    {"Quantity", "Value", "Unit", "Force-effect basis"},
    ({
      quantityName[#1["quantityID"]],
      formatValue[#1["value"], If[StringContainsQ[#1["unit"], "kN"], 0, 3]],
      #1["unit"],
      forceEffectBasisName[#1["forceEffectBasis"]]
    } &) /@ products["aashto"]["thrust"],
    {Left, Right, Center, Left}
  ],
  Spacer[6],
  Style[
    "This scalar relation defines no angular contact-pressure distribution, bending moment, or shear force.",
    GrayLevel[0.30]
  ]
}];

aashtoView[products_Association, evaluatedAashto_Association] := With[
  {
    inputs = First[products["aashto"]["inputs"]],
    calculation = First[products["aashto"]["calculation"]],
    checks = products["aashto"]["checks"],
    summary = First[products["aashto"]["summary"]]
  },
  Column[{
    Style["Check summary", Bold],
    engineeringTable[
      {"Result", "Value"},
      {
        {"Scalar prism-thrust demand, Tu", Row[{formatValue[calculation["designThrustKnPerM"], 0], " kN/m"}]},
        {"Governing check", checkName[summary["governingCheckID"]]},
        {"Governing utilization ratio", formatValue[summary["governingUtilization"]]},
        {"Wall mechanical status", statusName[summary["wallStatus"]]},
        {"Seam mechanical status", statusName[summary["seamStatus"]]},
        {"Calculation status", statusName[summary["calculationStatus"]]}
      },
      {Left, Left}
    ],
    Spacer[10],
    Style["Limit-state comparisons", Bold],
    engineeringTable[
      {"Check", "Demand / calculated / required", "Resistance / limit / provided", "Unit", "Utilization ratio", "Mechanical result"},
      ({
        If[#1["checkID"] === summary["governingCheckID"], Style[checkName[#1["checkID"]], Bold], checkName[#1["checkID"]]],
        formatValue[#1["observedValue"], If[StringContainsQ[#1["unit"], "kN"], 0, 3]],
        formatValue[#1["limitValue"], If[StringContainsQ[#1["unit"], "kN"], 0, 3]],
        #1["unit"],
        formatValue[#1["utilization"]],
        statusName[#1["checkStatus"]]
      } &) /@ checks,
      {Left, Right, Right, Center, Right, Center}
    ],
    Spacer[10],
    Style["Reference seam sensitivity", Bold],
    engineeringTable[
      {"Property", "Value", "Unit"},
      {
        {"Published reference seam", inputs["seamID"], "\[LongDash]"},
        {"Initial nominal resistance, Rn,0", formatValue[calculation["referenceSeamNominalResistanceKnPerM"], 0], "kN/m"},
        {"Seam resistance factor, \[Phi]s", formatValue[inputs["seamResistanceFactor"]], "\[LongDash]"},
        {"Initial fastener diameter, d0", formatValue[calculation["fastenerDiameterMm"], 0], "mm"},
        {"Relative diameter loss, \[Delta]d", formatValue[100 calculation["fastenerDiameterLossRatio"]], "%"},
        {"Remaining fastener diameter, dr", formatValue[calculation["remainingFastenerDiameterMm"], 0], "mm"},
        {"Remaining area ratio, Ar/A0", formatValue[calculation["fastenerAreaRatio"]], "\[LongDash]"},
        {"Reduced nominal resistance, Rn,c", formatValue[calculation["corrodedSeamNominalResistanceKnPerM"], 0], "kN/m"},
        {"Factored seam resistance, \[Phi]s Rn,c", formatValue[calculation["factoredSeamResistanceKnPerM"], 0], "kN/m"},
        {"Utilization at zero diameter loss", formatValue[calculation["seamUtilizationAtZeroLoss"]], "\[LongDash]"},
        {"Utilization at declared diameter loss", formatValue[First[Select[checks, #1["checkID"] === "seam" &]]["utilization"]], "\[LongDash]"},
        {"Limiting diameter loss for U = 1", formatValue[100 calculation["criticalFastenerDiameterLossRatio"]], "%"}
      },
      {Left, Right, Center}
    ],
    Spacer[8],
    Style[
      "Scope \[LongDash] Prior-edition numerical reproduction. Current-edition compliance and equivalence of the observed bolted seam are not established.",
      GrayLevel[0.30]
    ],
    OpenerView[{
      Style["Assumptions and provenance \[LongDash] corrugated steel / AASHTO", Bold],
      engineeringTable[
        {"Item", "Declared basis"},
        {
          {"Standard", evaluatedAashto["standardID"]},
          {"Edition identifier", evaluatedAashto["editionID"]},
          {"Specification status", statusName[evaluatedAashto["specificationStatus"]]},
          {"Demand source", Row[{evaluatedAashto["demandSourceKey"], ": ", evaluatedAashto["demandSourceLocator"]}]},
          {"Wall source", Row[{evaluatedAashto["wallSourceKey"], ": ", evaluatedAashto["wallSourceLocator"]}]},
          {"Seam-factor source", Row[{evaluatedAashto["seamFactorSourceKey"], ": ", evaluatedAashto["seamFactorSourceLocator"]}]},
          {"Reference seam source", Row[{evaluatedAashto["seam"]["sourceKey"], ": ", evaluatedAashto["seam"]["sourceLocator"]}]}
        },
        {Left, Left}
      ]
    }, False]
  }, Spacings -> 1.2]
];

concreteAlternativeView[
  name_,
  products_Association,
  graphics_Association
] := concreteLiningView[
  First[products["summary"]]["concreteTypeID"],
  name,
  products,
  graphics
];

concreteCommonView[
  _,
  liningTitle_,
  products_Association,
  graphics_Association
] := With[
  {
    section = First[products["section"]],
    summary = products["summary"]
  },
  Column[{
    Style[Row[{liningTitle, " section: ", section["sectionID"]}], Bold],
    Style[
      Row[{liningTitle, " gross-section properties and circumferential stiffness"}],
      Bold
    ],
    engineeringTable[
      {StringJoin[liningTitle, " property"], "Value", "Unit"},
      {
        {"Centroidal radius", formatValue[section["centroidalRadiusM"]], "m"},
        {"Thickness", formatValue[section["thicknessM"]], "m"},
        {"Young's modulus", formatValue[section["youngModulusKPa"], 0], "kPa"},
        {"Area per metre", formatValue[section["areaM2PerM"], 6], "m^2/m"},
        {"Second moment per metre", formatValue[section["inertiaM4PerM"], 6], "m^4/m"},
        {"Extensional stiffness, EA", formatValue[section["extensionalRigidityKnPerM"], 0], "kN/m"},
        {"Flexural stiffness, EI", formatValue[section["flexuralRigidityKnM2PerM"], 0], "kN\[CenterDot]m^2/m"}
      },
      {Left, Right, Center}
    ],
    Spacer[10],
    Style[
      "Unfactored hybrid section resultants by interface",
      Bold
    ],
    resultantsView[products, graphics, liningTitle],
    Spacer[10],
    Style["Unfactored hybrid extrema by interface", Bold],
    engineeringTable[
      {"Projection", "|N|max [kN/m]", "|M|max [kN\[CenterDot]m/m]", "|Q|max [kN/m]"},
      ({
        caseName[#1["interfaceID"]],
        formatValue[#1["normalAbsoluteMaxKnPerM"], 0],
        formatValue[#1["momentAbsoluteMaxKnMPerM"], 0],
        formatValue[#1["shearAbsoluteMaxKnPerM"], 0]
      } &) /@ summary,
      {Left, Right, Right, Right}
    ],
    Style[
      "The diagrams and extrema above combine the Schwartz-Einstein uniform-field interaction recomputed by R for this lining stiffness with the balanced n=1,n=3 geostatic-gradient correction. Strength checks below use separately recomputed LRFD actions from the same R model.",
      GrayLevel[0.30]
    ]
  }, Spacings -> 1.2]
];

concreteLiningView[
  "plain-concrete",
  name_,
  products_Association,
  graphics_Association
] := With[
  {
    summary = products["summary"],
    aciSummary = products["assessment"]["aci"]["summary"],
    applicabilityChecks = DeleteDuplicatesBy[
      Select[
        products["assessment"]["aci"]["checks"],
        MemberQ[
          {"structural-classification", "plain-concrete-permission"},
          #1["checkID"]
        ] &
      ],
      #1["checkID"] &
    ],
    checks = Select[
      products["assessment"]["aci"]["checks"],
      #1["calculationStatus"] === "calculated" &&
        MemberQ[{"tension-face", "compression-face", "one-way-shear"}, #1["checkID"]] &
    ]
  },
  Column[{
    concreteCommonView[name, "Plain shotcrete", products, graphics],
    Spacer[10],
    Style["Conditional plain-concrete local-strength result by projection", Bold],
    engineeringTable[
      {"Projection", "Governing LRFD combination", "Governing check", "Utilization", "Local strength", "Overall ACI assessment"},
      ({
        caseName[#1["interfaceID"]],
        strengthCaseName[#1["shotcreteGoverningStrengthCaseID"]],
        checkName[#1["shotcreteGoverningCheckID"]],
        formatValue[#1["shotcreteLocalStrengthUtilization"]],
        statusName[#1["shotcreteLocalStrengthStatus"]],
        statusName[#1["shotcreteNormativeStatus"]]
      } &) /@ summary,
      {Left, Center, Left, Right, Center, Center}
    ],
    Spacer[10],
    Style["Conditional ACI 318-25 local-strength summary by LRFD combination", Bold],
    engineeringTable[
      {"Projection", "LRFD combination", "fEV", "fEH", "Governing check", "Utilization", "Local strength", "Overall ACI assessment"},
      ({
        caseName[#1["interfaceID"]],
        strengthCaseName[#1["strengthCaseID"]],
        formatValue[#1["verticalStressFactor"], 1],
        formatValue[#1["horizontalStressFactor"], 1],
        checkName[#1["governingCheckID"]],
        formatValue[#1["governingUtilization"]],
        statusName[#1["localStrengthStatus"]],
        statusName[#1["normativeStatus"]]
      } &) /@ aciSummary,
      {Left, Center, Right, Right, Left, Right, Center, Center}
    ],
    Spacer[10],
    Style["ACI 318-25 Chapter 14 applicability prerequisites", Bold],
    engineeringTable[
      {"Requirement", "Clause", "Evaluation", "Reason"},
      ({
        checkName[#1["checkID"]],
        #1["clauseID"],
        statusName[#1["calculationStatus"]],
        scopeReasonName[#1["blockReason"]]
      } &) /@ applicabilityChecks,
      {Left, Center, Center, Left}
    ],
    Spacer[10],
    Style["Calculated local checks at concurrent section resultants", Bold],
    engineeringTable[
      {"Projection", "LRFD combination", "Check", "\[Theta] [deg]", "Concurrent N / M / Q", "Demand", "Capacity", "Unit", "Utilization", "Result"},
      ({
        caseName[#1["interfaceID"]],
        strengthCaseName[#1["strengthCaseID"]],
        checkName[#1["checkID"]],
        formatValue[#1["thetaDeg"], 1],
        Column[{
          Row[{"N = ", formatValue[#1["normalForceKnPerM"], 0], " kN/m"}],
          Row[{"M = ", formatValue[#1["bendingMomentKnMPerM"], 0], " kN\[CenterDot]m/m"}],
          Row[{"Q = ", formatValue[#1["shearForceKnPerM"], 0], " kN/m"}]
        }, Spacings -> 0.1],
        formatValue[#1["demandValue"], If[StringContainsQ[#1["unit"], "kN"], 0, 3]],
        formatValue[#1["capacityValue"], If[StringContainsQ[#1["unit"], "kN"], 0, 3]],
        #1["unit"],
        formatValue[#1["utilization"]],
        statusName[#1["checkStatus"]]
      } &) /@ checks,
      {Left, Center, Left, Right, Left, Right, Right, Center, Right, Center}
    ],
    Spacer[8],
    Style[
      "Scope \[LongDash] The local tension-face and one-way-shear comparisons are calculated conditionally for the declared LRFD combinations. ACI 318-25 Chapter 14 applicability is not established because the structural classification and qualifying plain-concrete support condition are not characterized; the overall ACI assessment therefore remains Not evaluated.",
      GrayLevel[0.30]
    ],
    Spacer[10],
    Style["Parametric reinforced-section comparison at this thickness", Bold],
    reinforcementStudyView[products["reinforcementStudy"]]
  }, Spacings -> 1.2]
];

pmReinforcementFamilyPlot[study_Association] := Module[
  {
    orderedSummary, domains, demands, domainSeries, curveColors,
    curveColorByCase, demandColors, curveLabels, demandPrimitives, allPoints,
    symmetricCaseCount,
    xTickValues, yTickValues
  },
  orderedSummary = SortBy[
    study["summary"],
    #1["reinforcementCaseOrder"] &
  ];
  symmetricCaseCount = Count[
    orderedSummary,
    row_ /; TrueQ[row["isParametricCase"]]
  ];
  domains = study["domains"];
  demands = SortBy[
    study["governingDemands"],
    #1["demandOrder"] &
  ];
  domainSeries = Table[
    ({
      #1["bendingStrengthKnMPerM"],
      #1["axialStrengthKnPerM"]
    } &) /@ SortBy[
      Select[
        domains,
        #1["reinforcementCaseID"] === row["reinforcementCaseID"] &
      ],
      #1["domainPointIndex"] &
    ],
    {row, orderedSummary}
  ];
  curveColors = Table[ColorData[97][index], {index, Length[domainSeries]}];
  curveColorByCase = AssociationThread[
    (#1["reinforcementCaseID"] &) /@ orderedSummary,
    curveColors
  ];
  demandColors = Lookup[
    curveColorByCase,
    (#1["reinforcementCaseID"] &) /@ demands
  ];
  curveLabels = (If[
    TrueQ[#1["isParametricCase"]],
    {
      Row[{"S", formatValue[#1["barDiameterMm"], 0], " · Ø", formatValue[#1["barDiameterMm"], 0], "/", formatValue[#1["barSpacingMm"], 0]}],
      Row[{"rho = ", NumberForm[100 #1["reinforcementRatio"], {5, 3}], "%"}],
      Row[{"As,total = ", NumberForm[#1["circumferentialAreaTotalMm2PerM"]/100, {7, 2}], " cm^2/m"}]
    },
    {"A8 · full-composite sensitivity", "Existing sheet + Ø8/150 interior"}
  ] &) /@ orderedSummary;
  demandPrimitives = MapThread[
    {
      #2,
      PointSize[If[
        #1["reinforcementCaseOrder"] <= symmetricCaseCount,
        0.026 - 0.004 #1["reinforcementCaseOrder"],
        0.018
      ]],
      Tooltip[
        Point[{#1["bendingDemandKnMPerM"], #1["axialDemandKnPerM"]}],
        Row[{
          caseName[#1["interfaceID"]], " / ",
          strengthCaseName[#1["strengthCaseID"]],
          "; theta = ", formatValue[#1["thetaDeg"], 1], " deg"
        }]
      ]
    } &,
    {demands, demandColors}
  ];
  allPoints = Join[
    Flatten[domainSeries, 1],
    ({#1["bendingDemandKnMPerM"], #1["axialDemandKnPerM"]} &) /@ demands
  ];
  xTickValues = DeleteDuplicates @ Round @ FindDivisions[
    MinMax[allPoints[[All, 1]]],
    7
  ];
  yTickValues = DeleteDuplicates @ Round @ FindDivisions[
    MinMax[allPoints[[All, 2]]],
    7
  ];
  ListLinePlot[
    domainSeries,
    Frame -> True,
    FrameLabel -> {"M [kN m/m]", "P [kN/m]"},
    FrameTicks -> {
      {Thread[{yTickValues, yTickValues}], None},
      {Thread[{xTickValues, xTickValues}], None}
    },
    PlotRange -> All,
    PlotStyle -> (Directive[#, AbsoluteThickness[2]] & /@ curveColors),
    PlotLegends -> Placed[
      LineLegend[curveColors, curveLabels, LegendLayout -> "Column"],
      Right
    ],
    Epilog -> demandPrimitives,
    GridLines -> Automatic,
    GridLinesStyle -> Directive[GrayLevel[0.88], Thin],
    ImageSize -> 720,
    AspectRatio -> 0.72
  ]
];

reinforcementStudyView[study_Association] := Module[
  {summary, demands, curveColors, curveColorByCase, demandColors},
  summary = SortBy[study["summary"], #1["reinforcementCaseOrder"] &];
  demands = SortBy[
    study["governingDemands"],
    #1["demandOrder"] &
  ];
  curveColors = Table[ColorData[97][index], {index, Length[summary]}];
  curveColorByCase = AssociationThread[
    (#1["reinforcementCaseID"] &) /@ summary,
    curveColors
  ];
  demandColors = Lookup[
    curveColorByCase,
    (#1["reinforcementCaseID"] &) /@ demands
  ];
  Column[{
    Style["P-M interaction domains for the evaluated reinforcement configurations", Bold],
    pmReinforcementFamilyPlot[study],
    Style[
      "The Ø8/150, Ø10/150, and Ø12/150 symmetric curves share the cracked-concrete stiffness, so their two demand coordinates coincide; nested marker sizes keep the three colors visible.",
      GrayLevel[0.30]
    ],
    Spacer[8],
    engineeringTable[
      {"ID", "phi/s", "rho [%]", "As,total [cm^2/m]", "U_PM", "E_PM", "U_V", "E_V", "U_r*", "E_r*"},
      ({
        If[
          TrueQ[#1["isParametricCase"]],
          Row[{"S", formatValue[#1["barDiameterMm"], 0]}],
          "A8"
        ],
        Row[{formatValue[#1["barDiameterMm"], 0], "/", formatValue[#1["barSpacingMm"], 0]}],
        formatValue[100 #1["reinforcementRatio"], 3],
        formatValue[#1["circumferentialAreaTotalMm2PerM"]/100, 2],
        formatValue[#1["maximumRadialUtilization"]],
        If[#1["localPMStatus"] === "satisfied", "OK", "FAIL"],
        formatValue[#1["maximumShearUtilization"]],
        If[#1["shearStatus"] === "satisfied", "OK", "FAIL"],
        formatValue[#1["radialTensionUtilization"]],
        If[#1["radialTensionStatus"] === "satisfied", "OK", "FAIL"]
      } &) /@ summary,
      {Center, Center, Right, Right, Right, Center, Right, Center, Right, Center}
    ],
    Spacer[8],
    Style[Row[{Length[demands], " governing demands for the reinforcement family"}], Bold],
    engineeringTable[
      {"Marker", "rho [%]", "Projection", "LRFD combination", "theta [deg]", "N [kN/m]", "M [kN m/m]", "Utilization"},
      MapThread[
        {
          Style[If[#1["interfaceID"] === "full-slip", "\[FilledCircle]", "\[FilledDiamond]"], #2, 16],
          formatValue[100 #1["reinforcementRatio"], 3],
          caseName[#1["interfaceID"]],
          strengthCaseName[#1["strengthCaseID"]],
          formatValue[#1["thetaDeg"], 1],
          formatValue[#1["axialDemandKnPerM"], 0],
          formatValue[#1["bendingDemandKnMPerM"], 0],
          formatValue[#1["radialUtilization"]]
        } &,
        {demands, demandColors}
      ],
      {Center, Right, Left, Center, Right, Right, Right, Right}
    ],
    Style[
      "OK means U <= 1; FAIL means U > 1. E_PM is flexure-compression, E_V is one-way shear, and E_r* is the separate conditional cover-splitting check for curved circumferential bars. Change reinforcementCases, concrete strength, thickness, or compositeCase in calculation.json; then reevaluate the single R calculation cell.",
      GrayLevel[0.30]
    ]
  }, Spacings -> 1.2]
];

concreteLiningView[
  "reinforced-concrete",
  name_,
  products_Association,
  graphics_Association
] := With[
  {
    study = products["reinforcementStudy"],
    outsideScope = DeleteDuplicatesBy[
      Select[
        products["assessment"]["aci"]["checks"],
        #1["checkStatus"] === "blocked" &
      ],
      #1["checkID"] &
    ]
  },
  Column[{
    concreteCommonView[
      name,
      "Shotcrete for the parametric P-M study",
      products,
      graphics
    ],
    Spacer[10],
    reinforcementStudyView[study],
    Spacer[8],
    Style[
      "Scope \[LongDash] ACI 318-25 governs the implemented local axial-force and bending check. The displayed family is parametric and does not select a bar diameter, spacing, or final reinforcement detail. This is not a full current-code shell assessment.",
      GrayLevel[0.30]
    ],
    OpenerView[{
      Style["Outside the evaluated reinforced-concrete scope", Bold],
      engineeringTable[
        {"Item", "Reason"},
        ({
          checkName[#1["checkID"]],
          scopeReasonName[#1["blockReason"]]
        } &) /@ outsideScope,
        {Left, Left}
      ]
    }, False]
  }, Spacings -> 1.2]
];

rObjectCatalogRows[additionalIDs_List] := Join[
  {
    {"workbookProducts$theta", "Angular mesh"},
    {"workbookProducts$stress", "Free-field stress"},
    {"workbookProducts$section", "Corrugated-steel section"},
    {"workbookProducts$interaction", "Prescribed-load control coefficients"},
    {"workbookProducts$schwartzEinsteinComparison", "Schwartz-Einstein design coefficients"},
    {"workbookProducts$hybridGradient", "Balanced geostatic-gradient coefficients and checks"},
    {"workbookProducts$resultants", "Angular N/M/Q rows"},
    {"workbookProducts$extrema", "Section-resultant extrema"},
    {"workbookProducts$controls", "Numerical controls"},
    {"workbookProducts$aashto$inputs", "Resolved conduit-check inputs"},
    {"workbookProducts$aashto$thrust", "Scalar prism-thrust stages"},
    {"workbookProducts$aashto$calculation", "Derived AASHTO quantities"},
    {"workbookProducts$aashto$checks", "Limit-state comparisons"},
    {"workbookProducts$aashto$summary", "Governing statuses"},
    {"workbookProducts$reinforcementStudy$domains", "P-M domains for the discrete reinforcement family"},
    {"workbookProducts$reinforcementStudy$summary", "Reinforcement-family utilizations and statuses"},
    {"workbookProducts$reinforcementStudy$governingDemands", "Two governing demands per reinforcement configuration and lining thickness"},
    {"workbookProducts$reinforcementStudy$limitChecks", "Governing shear and radial-tension checks for every configuration"}
  },
  Flatten[
    Table[
      ({
        StringJoin[
          "workbookProducts$additionalLinings$",
          name,
          "$",
          StringRiffle[#1, "$"]
        ],
        StringJoin["Additional lining: ", StringRiffle[#1, "/"]]
      } &) /@ {
        {"stress"},
        {"section"},
        {"interaction"},
        {"schwartzEinsteinComparison"},
        {"hybridGradient"},
        {"resultants"},
        {"extrema"},
        {"controls"},
        {"assessment", "aci", "actions"},
        {"assessment", "aci", "checks"},
        {"assessment", "aci", "controls"},
        {"assessment", "aci", "summary"},
        {"summary"}
      },
      {name, additionalIDs}
    ],
    1
  ]
];

rObjectExplorerView[path_List, additionalIDs_List] := Module[
  {selectedRRows},
  RSet["workbookExplorerPath", path];
  selectedRRows = readRRows[
    "{ selected <- Reduce(function(x, key) x[[key]], workbookExplorerPath, init = workbookProducts); if (is.null(selected)) selected <- data.frame(status = 'NULL - not available for this case'); if (!is.data.frame(selected)) stop('The selected R object is not a table.', call. = FALSE); utils::head(selected, 50L) }"
  ];
  OpenerView[{
    Style["Data explorer \[LongDash] returned R products", Bold],
    Column[{
      engineeringTable[
        {"R object path", "Engineering content"},
        rObjectCatalogRows[additionalIDs],
        {Left, Left}
      ],
      Spacer[10],
      Style[Row[{"Selected path: ", StringRiffle[path, "/"]}], Bold],
      Dataset[selectedRRows],
      Style[
        "The explorer shows at most 50 rows and reads only the selected table. The complete return remains available as workbookProducts in the persistent R session.",
        GrayLevel[0.35]
      ]
    }, Spacings -> 1.2]
  }, False]
];
