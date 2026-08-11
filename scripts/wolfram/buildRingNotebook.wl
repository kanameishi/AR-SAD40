(* Build the self-contained Wolfram notebook from the audited kernel sources. *)

ClearAll[
  ScriptDir, TargetFile, SourceText, SourceParts, CoreText, LoadText,
  MonteCarloText, LoadMarker, MonteCarloMarker, TestText,
  UniformInputsText, UniformRunText, AtRestInputsText, AtRestRunText,
  InteractiveText, AdapterExamplesText, MonteCarloInputsText,
  MonteCarloRunText, MonteCarloPlotText, NotebookData, NotebookText
];

ScriptDir = DirectoryName[ExpandFileName[$InputFileName]];
TargetFile = FileNameJoin[{ScriptDir, "0.nb"}];
SourceText = Import[
  FileNameJoin[{ScriptDir, "ringMethodology.wl"}],
  "Text"
];
LoadMarker = "(* Soil-state and source adapters. *)";
MonteCarloMarker = "(* Monte Carlo orchestration. No engineering priors or correlations are\n   introduced by these helpers. Wolfram-native RNG sequences intentionally\n   differ from R; deterministic mechanics are benchmarked separately. *)";
SourceParts = StringSplit[SourceText, {LoadMarker, MonteCarloMarker}];
If[
  Length[SourceParts] =!= 3,
  Print["Unable to split ringMethodology.wl into notebook sections."];
  Exit[1]
];
CoreText = SourceParts[[1]];
LoadText = LoadMarker <> SourceParts[[2]];
MonteCarloText = MonteCarloMarker <> SourceParts[[3]];
TestText = Import[
  FileNameJoin[{ScriptDir, "ringMethodologyTests.wl"}],
  "Text"
];

UniformInputsText = StringRiffle[{
  "P1Radius = 2.10;",
  "P1Pressure = 12.30;",
  "P1Theta = N[Range[0, 359] 2 Pi/360];"
}, "\n"];

UniformRunText = StringRiffle[{
  "P1Spectrum = newRingSpectrum[0];",
  "P1Spectrum = setRingCoefficient[P1Spectrum, \"RadialCos\", 0, -P1Pressure];",
  "P1Response = solveRingSpectrum[P1Spectrum, P1Radius];",
  "P1Values = evaluateRingResponse[P1Response, P1Theta];",
  "P1Summary = summarizeRingResponse[P1Response];",
  "Column[{",
  "  Dataset[P1Summary],",
  "  ListLinePlot[",
  "    Transpose[{P1Theta 180/Pi, P1Values[\"NormalForce\"]}],",
  "    Frame -> True, FrameLabel -> {\"theta [deg]\", \"N\"},",
  "    PlotLabel -> \"Presion uniforme: N(theta)\", PlotRange -> All,",
  "    ImageSize -> Large",
  "  ]",
  "}]"
}, "\n"];

AtRestInputsText = StringRiffle[{
  "P2CoverCrown = 3.00;",
  "P2Radius = 1.00;",
  "P2LayerBottom = {Infinity};",
  "P2EffectiveUnitWeight = {18.0};",
  "P2EffectiveSurcharge = 0.0;",
  "P2WaterTableDepth = Infinity;",
  "P2WaterUnitWeight = 9.81;",
  "P2K0 = 0.50;",
  "P2ResidualHorizontal = 0.0;",
  "P2InterfaceBranch = \"FullTraction\";",
  "P2Theta = N[Range[0, 359] 2 Pi/360];"
}, "\n"];

AtRestRunText = StringRiffle[{
  "P2StressOrdinates = ringVerticalStressOrdinates[",
  "  P2CoverCrown, P2Radius, P2LayerBottom, P2EffectiveUnitWeight,",
  "  P2EffectiveSurcharge, P2WaterTableDepth, P2WaterUnitWeight",
  "];",
  "P2AxisState = First @ Select[P2StressOrdinates, #[\"Location\"] == \"Axis\" &];",
  "P2Spectrum = atRestFreeFieldSpectrum[",
  "  P2AxisState[\"EffectiveVertical\"], P2K0,",
  "  P2AxisState[\"PorePressure\"], P2ResidualHorizontal,",
  "  \"InterfaceBranch\" -> P2InterfaceBranch",
  "];",
  "P2Response = solveRingSpectrum[P2Spectrum, P2Radius];",
  "P2Loads = evaluateRingLoad[P2Spectrum, P2Theta];",
  "P2Values = evaluateRingResponse[P2Response, P2Theta];",
  "P2Summary = summarizeRingResponse[P2Response];",
  "Column[{",
  "  Dataset[P2StressOrdinates],",
  "  Dataset[P2Summary],",
  "  ListLinePlot[",
  "    {",
  "      Transpose[{P2Theta 180/Pi, P2Loads[\"RadialOutward\"]}],",
  "      Transpose[{P2Theta 180/Pi, P2Loads[\"TangentialPositive\"]}]",
  "    },",
  "    PlotLegends -> {\"Pr hacia afuera\", \"Pt con theta\"},",
  "    Frame -> True, FrameLabel -> {\"theta [deg]\", \"traccion perimetral\"},",
  "    PlotLabel -> \"Carga proyectada sobre el anillo\", PlotRange -> All,",
  "    ImageSize -> Large",
  "  ],",
  "  ListLinePlot[",
  "    Transpose[{P2Theta 180/Pi, P2Values[\"NormalForce\"]}],",
  "    Frame -> True, FrameLabel -> {\"theta [deg]\", \"N\"},",
  "    PlotLabel -> \"Esfuerzo normal; traccion positiva\", PlotRange -> All,",
  "    ImageSize -> Large",
  "  ],",
  "  ListLinePlot[",
  "    Transpose[{P2Theta 180/Pi, P2Values[\"BendingMoment\"]}],",
  "    Frame -> True, FrameLabel -> {\"theta [deg]\", \"M\"},",
  "    PlotLabel -> \"Momento flector\", PlotRange -> All, ImageSize -> Large",
  "  ],",
  "  ListLinePlot[",
  "    Transpose[{P2Theta 180/Pi, P2Values[\"ShearForce\"]}],",
  "    Frame -> True, FrameLabel -> {\"theta [deg]\", \"Q\"},",
  "    PlotLabel -> \"Corte\", PlotRange -> All, ImageSize -> Large",
  "  ]",
  "}]"
}, "\n"];

InteractiveText = StringRiffle[{
  "Manipulate[",
  "  Module[{Spectrum, Response, Theta, Values, Summary},",
  "    Spectrum = atRestFreeFieldSpectrum[",
  "      VerticalStress, K0Value, PorePressure, 0.,",
  "      \"InterfaceBranch\" -> InterfaceBranch",
  "    ];",
  "    Response = solveRingSpectrum[Spectrum, Radius];",
  "    Theta = N[Range[0, 359] 2 Pi/360];",
  "    Values = evaluateRingResponse[Response, Theta];",
  "    Summary = summarizeRingResponse[Response];",
  "    Column[{",
  "      Dataset[Summary],",
  "      ListLinePlot[",
  "        Transpose[{Theta 180/Pi, Values[\"NormalForce\"]}],",
  "        Frame -> True, FrameLabel -> {\"theta [deg]\", \"N\"},",
  "        PlotLabel -> \"N(theta)\", PlotRange -> All, ImageSize -> Large",
  "      ],",
  "      ListLinePlot[",
  "        Transpose[{Theta 180/Pi, Values[\"BendingMoment\"]}],",
  "        Frame -> True, FrameLabel -> {\"theta [deg]\", \"M\"},",
  "        PlotLabel -> \"M(theta)\", PlotRange -> All, ImageSize -> Large",
  "      ],",
  "      ListLinePlot[",
  "        Transpose[{Theta 180/Pi, Values[\"ShearForce\"]}],",
  "        Frame -> True, FrameLabel -> {\"theta [deg]\", \"Q\"},",
  "        PlotLabel -> \"Q(theta)\", PlotRange -> All, ImageSize -> Large",
  "      ]",
  "    }]",
  "  ],",
  "  {{VerticalStress, 100., \"sigma_v efectiva en el eje\"}, 10., 300., 5.},",
  "  {{K0Value, 0.50, \"K0\"}, 0.20, 1.20, 0.05},",
  "  {{PorePressure, 0., \"presion de poros\"}, 0., 200., 5.},",
  "  {{Radius, 2., \"radio\"}, 0.50, 5.00, 0.10},",
  "  {{InterfaceBranch, \"FullTraction\", \"interfaz\"},",
  "    {\"FullTraction\", \"NormalOnly\"}},",
  "  SaveDefinitions -> True",
  "]"
}, "\n"];

AdapterExamplesText = StringRiffle[{
  "P4UsaceService = usace2020ServiceThrust[",
  "  120., 30., 3., 0., 0., 0., \"US\", \"ft\", \"lb\",",
  "  \"USACE D4: live load omitted at H=30 ft > 8 ft and H>S\", True",
  "];",
  "P4UsaceDesign = usace2020DesignThrust[",
  "  P4UsaceService, 1.95, 1.75, 1.10,",
  "  \"D4 published regression\", \"D4 published regression\"",
  "];",
  "P4FhwaPressure = fhwa1999CompactionPressure[20.5, 36., 970.];",
  "P4Nunez = nunez2000CircularResultants[",
  "  10., 15., 0.15, 1.9, 1., 0., 0., 0.5, 0.5, 1., 500.,",
  "  \"Nunez 2000 example\"",
  "];",
  "Column[{",
  "  Dataset[<|",
  "    \"USACE D4 service\" -> KeyTake[P4UsaceService,",
  "      {\"DeadCrownPressure\", \"ServiceThrust\", \"ThrustUnit\"}],",
  "    \"USACE D4 design\" -> KeyTake[P4UsaceDesign,",
  "      {\"DesignThrustBeforeModifier\", \"DesignThrust\", \"ThrustUnit\"}]",
  "  |>],",
  "  Dataset[KeyTake[P4FhwaPressure,",
  "    {\"PressureKpa\", \"CalibrationStatus\", \"SourceLocation\"}]],",
  "  Dataset[KeyTake[P4Nunez,",
  "    {\"InteractionRatio\", \"MomentCrown\", \"NormalCrown\",",
  "      \"NormalSpringline\", \"Source\"}]]",
  "}]"
}, "\n"];

MonteCarloInputsText = StringRiffle[{
  "P3SampleCount = 100;",
  "P3Seed = 20260809;",
  "P3Probabilities = {0.05, 0.50, 0.95};",
  "P3Theta = N[Range[0, 179] 2 Pi/180];",
  "P3CoverCrown = 3.00;",
  "P3Radius = 1.00;",
  "P3LayerBottom = {Infinity};",
  "P3WaterTableDepth = Infinity;",
  "P3WaterUnitWeight = 9.81;",
  "P3Specification = <|",
  "  \"EffectiveUnitWeight\" -> triangularParameter[17.0, 18.0, 20.0],",
  "  \"EffectiveSurcharge\" -> triangularParameter[0.0, 5.0, 15.0],",
  "  \"K0\" -> uniformParameter[0.40, 0.65]",
  "|>;",
  "P3IndependenceConfirmed = True;"
}, "\n"];

MonteCarloRunText = StringRiffle[{
  "P3Draws = sampleIndependentParameters[",
  "  P3Specification, P3SampleCount, P3Seed, P3IndependenceConfirmed",
  "];",
  "P3Scenario = Function[Draw,",
  "  Module[{StressOrdinates, AxisState, Spectrum},",
  "    StressOrdinates = ringVerticalStressOrdinates[",
  "      P3CoverCrown, P3Radius, P3LayerBottom,",
  "      {Draw[\"EffectiveUnitWeight\"]}, Draw[\"EffectiveSurcharge\"],",
  "      P3WaterTableDepth, P3WaterUnitWeight",
  "    ];",
  "    AxisState = First @ Select[",
  "      StressOrdinates, #[\"Location\"] == \"Axis\" &",
  "    ];",
  "    Spectrum = atRestFreeFieldSpectrum[",
  "      AxisState[\"EffectiveVertical\"], Draw[\"K0\"],",
  "      AxisState[\"PorePressure\"], 0.,",
  "      \"InterfaceBranch\" -> \"FullTraction\"",
  "    ];",
  "    <|",
  "      \"Spectrum\" -> Spectrum,",
  "      \"Radius\" -> P3Radius,",
  "      \"SupportedResultants\" -> {\"N\", \"M\", \"Q\"},",
  "      \"Metadata\" -> <|\"StressOrdinates\" -> StressOrdinates|>",
  "    |>",
  "  ]",
  "];",
  "P3Result = runRingMonteCarlo[",
  "  P3Draws, P3Scenario, P3Theta, P3Probabilities,",
  "  \"synthetic K0 prototype\", \"ExtremaScanPoints\" -> 720",
  "];",
  "KeyTake[P3Result,",
  "  {\"Model\", \"SampleCount\", \"Probabilities\", \"QuantileMethod\"}]"
}, "\n"];

MonteCarloPlotText = StringRiffle[{
  "P3NRows = Select[",
  "  P3Result[\"PointwiseQuantiles\"], #[\"Resultant\"] == \"N\" &",
  "];",
  "P3NSeries = Table[",
  "  With[{Rows = Select[P3NRows, #[\"Probability\"] == Probability &]},",
  "    Transpose[{Lookup[Rows, \"ThetaDeg\"], Lookup[Rows, \"Value\"]}]",
  "  ],",
  "  {Probability, P3Probabilities}",
  "];",
  "Column[{",
  "  ListLinePlot[",
  "    P3NSeries,",
  "    PlotLegends -> (\"p=\" <> ToString[#] & /@ P3Probabilities),",
  "    Frame -> True, FrameLabel -> {\"theta [deg]\", \"N\"},",
  "    PlotLabel -> \"Cuantiles puntuales de N(theta)\", PlotRange -> All,",
  "    ImageSize -> Large",
  "  ],",
  "  Dataset @ Select[",
  "    P3Result[\"ExtremaQuantiles\"], #[\"Resultant\"] == \"N\" &",
  "  ]",
  "}]"
}, "\n"];

NotebookData = Notebook[
  {
    Cell[
      "Prototipo no-FEM para un liner circular",
      "Title"
    ],
    Cell[
      "Ejemplos ejecutables: carga uniforme, campo K0, fuentes publicadas y Monte Carlo",
      "Subtitle"
    ],
    Cell[
      "Este notebook es autocontenido: no carga archivos externos al ejecutarse. Los bloques internos están plegados para dejar visibles los parámetros y resultados de los prototipos.",
      "Text"
    ],
    Cell["Inicio rápido", "Section"],
    Cell[
      "Primero ejecute Evaluation > Evaluate Initialization Cells. Después edite únicamente las celdas 'Entradas editables' y evalúe el bloque correspondiente. Evaluation > Evaluate Notebook ejecuta también las 36 pruebas y todos los ejemplos.",
      "Text"
    ],
    Cell[
      "Convención: theta=0 en clave y sentido horario; Pr positiva hacia afuera; Pt positiva con theta creciente; N positiva a tracción. Todas las entradas de cada ejemplo deben usar un sistema de unidades coherente.",
      "Text"
    ],
    CellGroupData[
      {
        Cell["Motor interno autocontenido", "Section"],
        Cell[
          "Definiciones del operador Fourier, adaptadores de carga y Monte Carlo. No es necesario abrir ni editar estas celdas para usar los prototipos.",
          "Text"
        ],
        Cell[
          BoxData[CoreText],
          "Input",
          InitializationCell -> True,
          CellTags -> {"RingCore"}
        ],
        Cell[
          BoxData[LoadText],
          "Input",
          InitializationCell -> True,
          CellTags -> {"RingLoads"}
        ],
        Cell[
          BoxData[MonteCarloText],
          "Input",
          InitializationCell -> True,
          CellTags -> {"RingMonteCarlo"}
        ]
      },
      Closed
    ],
    CellGroupData[
      {
        Cell["Verificación interna", "Section"],
        Cell[
          "Este bloque define y ejecuta 36 pruebas determinísticas. Es opcional durante la exploración y queda plegado por defecto.",
          "Text"
        ],
        Cell[
          BoxData[TestText],
          "Input",
          InitializationCell -> True,
          CellTags -> {"RingTests"}
        ],
        Cell[
          BoxData[
            "RingTestReport = runRingMethodologyTests[];\nKeyTake[RingTestReport, {\"Passed\", \"TestCount\", \"FailedCount\"}]"
          ],
          "Input",
          CellTags -> {"RingVerification"}
        ]
      },
      Closed
    ],
    Cell["Prototipo 1 — presión uniforme", "Section"],
    Cell[
      "Caso mínimo para verificar signos: debe obtenerse N=-p R constante, M=0 y Q=0.",
      "Text"
    ],
    Cell["Entradas editables", "Subsection"],
    Cell[
      BoxData[UniformInputsText],
      "Input",
      CellTags -> {"Prototype1Inputs"}
    ],
    Cell["Cálculo y resultados", "Subsection"],
    Cell[
      BoxData[UniformRunText],
      "Input",
      CellTags -> {"Prototype1Run"}
    ],
    Cell["Prototipo 2 — relleno estratificado y campo K0", "Section"],
    Cell[
      "Ejemplo sintético completo: calcula las ordenadas verticales en clave, eje y solera; proyecta el estado geostático sobre el perímetro; y obtiene N(theta), M(theta) y Q(theta). Los números son demostrativos, no parámetros del proyecto.",
      "Text"
    ],
    Cell["Entradas editables", "Subsection"],
    Cell[
      BoxData[AtRestInputsText],
      "Input",
      CellTags -> {"Prototype2Inputs"}
    ],
    Cell["Cálculo, tablas y curvas", "Subsection"],
    Cell[
      BoxData[AtRestRunText],
      "Input",
      CellTags -> {"Prototype2Run"}
    ],
    Cell["Explorador interactivo", "Section"],
    Cell[
      "Los controles permiten observar directamente la sensibilidad a sigma'_v, K0, presión de poros, radio y rama de interfaz. Este explorador recibe el estado de presión en el eje; el Prototipo 2 muestra cómo obtenerlo desde la tapada.",
      "Text"
    ],
    Cell[
      BoxData[InteractiveText],
      "Input",
      CellTags -> {"InteractivePrototype"}
    ],
    Cell["Ejemplos publicados de los adaptadores", "Section"],
    Cell[
      "Ejecuta los valores de regresión USACE D4, FHWA Tabla 5.5 y Núñez (2000). Son benchmarks de las fuentes, no una combinación de modelos ni datos del proyecto.",
      "Text"
    ],
    Cell[
      BoxData[AdapterExamplesText],
      "Input",
      CellTags -> {"SourceBenchmarks"}
    ],
    Cell["Prototipo 3 — Monte Carlo", "Section"],
    Cell[
      "Ejemplo sintético con marginales declaradas. P3IndependenceConfirmed=True sólo documenta la hipótesis del prototipo: para datos reales debe confirmarse la independencia o construirse externamente un conjunto de realizaciones correlacionadas.",
      "Text"
    ],
    Cell["Entradas editables", "Subsection"],
    Cell[
      BoxData[MonteCarloInputsText],
      "Input",
      CellTags -> {"Prototype3Inputs"}
    ],
    Cell["Simulación", "Subsection"],
    Cell[
      BoxData[MonteCarloRunText],
      "Input",
      CellTags -> {"Prototype3Run"}
    ],
    Cell["Envolventes y extremos", "Subsection"],
    Cell[
      BoxData[MonteCarloPlotText],
      "Input",
      CellTags -> {"Prototype3Results"}
    ],
    Cell["Límite de esta etapa", "Section"],
    Cell[
      "El prototipo resuelve el anillo isotrópico bajo tracciones prescritas. No resuelve todavía interacción suelo-estructura dependiente de rigidez, ortotropía, chapa ondulada ni pernos. Los resultantes que una fuente no respalda permanecen Missing[\"NotSupported\"].",
      "Text"
    ]
  },
  WindowTitle -> "Prototipo de liner circular: Fourier y Monte Carlo",
  TaggingRules -> <|
    "Artifact" -> "self-contained isotropic circular-ring prototype",
    "KernelVersion" -> $Version,
    "SelfContained" -> True,
    "PrototypeCount" -> 3
  |>,
  StyleDefinitions -> "Default.nb"
];

Put[NotebookData, TargetFile];
NotebookText = Import[TargetFile, "Text"];
NotebookText = StringReplace[
  NotebookText,
  RegularExpression["(?m)[ \\t]+$"] -> ""
];
Export[TargetFile, NotebookText, "Text"];
If[
  ! FileExistsQ[TargetFile] || FileByteCount[TargetFile] == 0,
  Print["Notebook build failed: ", TargetFile];
  Exit[1]
];
Print["Wrote ", TargetFile, " (", FileByteCount[TargetFile], " bytes)."];
