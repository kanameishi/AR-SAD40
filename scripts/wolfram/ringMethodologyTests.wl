(* Deterministic regression checks for ringMethodology.wl. *)

ClearAll[ringTestNear, ringTestTrue, ringTestEqual, runRingMethodologyTests];

ringTestNear[label_, actual_, expected_, tolerance_] := Module[
  {ActualValues, ExpectedValues, Error, Passed},
  If[
    FailureQ[actual],
    Return[<|
      "Test" -> label,
      "Passed" -> False,
      "Error" -> Infinity,
      "Diagnostic" -> actual
    |>]
  ];
  ActualValues = Flatten[{actual}];
  ExpectedValues = Flatten[{expected}];
  Passed = Length[ActualValues] == Length[ExpectedValues] &&
    AllTrue[Join[ActualValues, ExpectedValues], finiteRealQ];
  Error = If[
    Passed,
    Max[Abs[N[ActualValues] - N[ExpectedValues]]],
    Infinity
  ];
  <|
    "Test" -> label,
    "Passed" -> TrueQ[Passed && Error <= tolerance],
    "Error" -> Error,
    "Tolerance" -> tolerance
  |>
];

ringTestTrue[label_, value_] := <|
  "Test" -> label,
  "Passed" -> TrueQ[value],
  "Observed" -> value
|>;

ringTestEqual[label_, actual_, expected_] := <|
  "Test" -> label,
  "Passed" -> SameQ[actual, expected],
  "Observed" -> actual,
  "Expected" -> expected
|>;

runRingMethodologyTests[] := Module[
  {
    Tests, UniformPressure, Radius, UniformSpectrum, UniformResponse,
    UniformValues, GeneralSpectrum, GeneralResponse, Residual,
    FitTheta, FitLoads, FittedSpectrum, FittedTorque, FullSpectrum,
    FullResponse, Cardinal, NormalSpectrum, NormalResponse, NormalCardinal,
    BakerPublished, BakerAngles, BakerSpectrum, BakerResponse, BakerValues,
    UsaceService, UsaceDesign, UsaceSpectrum, UsaceResponse, UsaceValues,
    FhwaCases, FhwaCalculated, FhwaPressure, FhwaStage, FhwaStageResponse,
    FhwaResidual, NunezPrimary, NunezFinal, Draws, Scenario,
    MonteCarlo, MedianPointwise, MedianN, StageDraws, StageScenario,
    StageMonteCarlo, StageMedianN, UnsupportedScenario,
    UnsupportedMonteCarlo, UnsupportedPointwise, UnsupportedExtrema,
    UnsupportedExtremaQuantiles, TieStageScenario, TieStageMonteCarlo,
    TieNMinimum, SamplerSpecification, SampleOne, SampleTwo
  },
  Tests = {};

  UniformPressure = 12.3;
  Radius = 2.1;
  UniformSpectrum = newRingSpectrum[0];
  UniformSpectrum = setRingCoefficient[
    UniformSpectrum,
    "RadialCos",
    0,
    -UniformPressure
  ];
  UniformResponse = solveRingSpectrum[UniformSpectrum, Radius];
  UniformValues = evaluateRingResponse[
    UniformResponse,
    N[Range[0, 36] 2 Pi/37]
  ];
  AppendTo[Tests, ringTestNear[
    "uniform pressure N",
    UniformValues["NormalForce"],
    ConstantArray[-UniformPressure Radius, 37],
    1.*^-12
  ]];
  AppendTo[Tests, ringTestNear[
    "uniform pressure M",
    UniformValues["BendingMoment"],
    ConstantArray[0., 37],
    1.*^-12
  ]];
  AppendTo[Tests, ringTestNear[
    "uniform pressure Q",
    UniformValues["ShearForce"],
    ConstantArray[0., 37],
    1.*^-12
  ]];

  GeneralSpectrum = newRingSpectrum[5];
  GeneralSpectrum = Fold[
    setRingCoefficient[#1, #2[[1]], #2[[2]], #2[[3]]] &,
    GeneralSpectrum,
    {
      {"RadialCos", 0, -7.}, {"RadialCos", 2, 3.},
      {"RadialCos", 3, -2.}, {"RadialCos", 5, 0.4},
      {"RadialSin", 2, 1.2}, {"RadialSin", 3, -0.7},
      {"RadialSin", 4, 2.1}, {"TangentialCos", 2, -1.1},
      {"TangentialCos", 4, 0.8}, {"TangentialCos", 5, -0.3},
      {"TangentialSin", 2, 2.2}, {"TangentialSin", 3, -0.9},
      {"TangentialSin", 5, 0.6}
    }
  ];
  GeneralResponse = solveRingSpectrum[GeneralSpectrum, 1.7];
  Residual = ringEquilibriumResidual[
    GeneralSpectrum,
    GeneralResponse,
    1.7,
    N[Range[0, 300] 2 Pi/300]
  ];
  AppendTo[Tests, ringTestNear[
    "modal equilibrium",
    Join[
      Residual["MomentBalance"],
      Residual["RadialBalance"],
      Residual["TangentialBalance"]
    ],
    ConstantArray[0., 3 Length[Residual["Theta"]]],
    3.*^-12
  ]];

  FitTheta = N[Range[0, 511] 2 Pi/512];
  FitLoads = evaluateRingLoad[GeneralSpectrum, FitTheta];
  FittedSpectrum = fitRingSpectrum[
    FitTheta,
    FitLoads["RadialOutward"],
    FitLoads["TangentialPositive"],
    5
  ];
  AppendTo[Tests, ringTestNear[
    "Fourier coefficient recovery",
    Flatten[Lookup[
      FittedSpectrum,
      {"RadialCos", "RadialSin", "TangentialCos", "TangentialSin"}
    ]],
    Flatten[Lookup[
      GeneralSpectrum,
      {"RadialCos", "RadialSin", "TangentialCos", "TangentialSin"}
    ]],
    3.*^-13
  ]];

  FittedTorque = fitRingSpectrum[
    FitTheta,
    1.*^12 Cos[2 FitTheta],
    ConstantArray[1., Length[FitTheta]],
    2
  ];
  AppendTo[Tests, ringTestTrue[
    "fitted torque channel separation",
    FailureQ[solveRingSpectrum[FittedTorque, 1.]]
  ]];

  FullSpectrum = atRestFreeFieldSpectrum[
    100.,
    0.5,
    20.,
    0.,
    "InterfaceBranch" -> "FullTraction"
  ];
  FullResponse = solveRingSpectrum[FullSpectrum, 2.];
  Cardinal = evaluateRingResponse[
    FullResponse,
    {0., Pi/4, Pi/2, 3 Pi/4, Pi}
  ];
  AppendTo[Tests, ringTestNear[
    "full-traction N",
    Cardinal["NormalForce"],
    {-140., -190., -240., -190., -140.},
    3.*^-12
  ]];
  AppendTo[Tests, ringTestNear[
    "full-traction M",
    Cardinal["BendingMoment"],
    {50., 0., -50., 0., 50.},
    3.*^-12
  ]];
  AppendTo[Tests, ringTestNear[
    "full-traction Q",
    Cardinal["ShearForce"],
    {0., -50., 0., 50., 0.},
    3.*^-12
  ]];

  NormalSpectrum = atRestFreeFieldSpectrum[
    100.,
    0.5,
    20.,
    0.,
    "InterfaceBranch" -> "NormalOnly"
  ];
  NormalResponse = solveRingSpectrum[NormalSpectrum, 2.];
  NormalCardinal = evaluateRingResponse[NormalResponse, {0., Pi/4, Pi/2}];
  AppendTo[Tests, ringTestNear[
    "normal-only N",
    NormalCardinal["NormalForce"],
    {-173.333333333333, -190., -206.666666666667},
    3.*^-12
  ]];
  AppendTo[Tests, ringTestNear[
    "normal-only M",
    NormalCardinal["BendingMoment"],
    {33.3333333333333, 0., -33.3333333333333},
    3.*^-12
  ]];

  BakerPublished = <|
    0 -> <|
      "N" -> {0.000, -0.250, -0.433, -0.500},
      "M" -> {0.318, 0.068, -0.115, -0.182}
    |>,
    30 -> <|
      "N" -> {-0.128, -0.239, -0.413, -0.477},
      "M" -> {0.190, 0.080, -0.095, -0.159}
    |>,
    60 -> <|
      "N" -> {-0.239, -0.271, -0.358, -0.413},
      "M" -> {0.080, 0.048, -0.040, -0.095}
    |>
  |>;
  BakerAngles = N[{0, 30, 60, 90} Pi/180];
  Do[
    BakerSpectrum = bakerDiametricLoadSpectrum[HalfAngle, 8000];
    BakerResponse = solveRingSpectrum[BakerSpectrum, 1.];
    BakerValues = evaluateRingResponse[BakerResponse, BakerAngles];
    AppendTo[Tests, ringTestNear[
      "Baker N half-angle " <> ToString[HalfAngle],
      BakerValues["NormalForce"],
      BakerPublished[HalfAngle]["N"],
      5.1*^-4
    ]];
    AppendTo[Tests, ringTestNear[
      "Baker M half-angle " <> ToString[HalfAngle],
      BakerValues["BendingMoment"],
      BakerPublished[HalfAngle]["M"],
      5.1*^-4
    ]],
    {HalfAngle, {0, 30, 60}}
  ];

  UsaceService = usace2020ServiceThrust[
    120., 30., 3., 0., 0., 0.,
    "US", "ft", "lb",
    "USACE D4: live load omitted at H=30 ft > 8 ft and H>S",
    True
  ];
  UsaceDesign = usace2020DesignThrust[
    UsaceService,
    1.95,
    1.75,
    1.10,
    "D4 published regression",
    "D4 published regression"
  ];
  AppendTo[Tests, ringTestNear[
    "USACE D4 service thrust",
    UsaceService["ServiceThrust"],
    5400.,
    1.*^-12
  ]];
  AppendTo[Tests, ringTestNear[
    "USACE D4 design thrust",
    UsaceDesign["DesignThrust"],
    11583.,
    1.*^-9
  ]];
  AppendTo[Tests, ringTestEqual[
    "USACE thrust units",
    UsaceService["ThrustUnit"],
    "lb/ft"
  ]];
  UsaceSpectrum = usaceEquivalentUniformSpectrum[UsaceService];
  UsaceResponse = solveRingSpectrum[UsaceSpectrum, 1.5];
  UsaceValues = evaluateRingResponse[UsaceResponse, {0., Pi/2}];
  AppendTo[Tests, ringTestNear[
    "USACE N0 projection",
    UsaceValues["NormalForce"],
    {-5400., -5400.},
    1.*^-12
  ]];
  AppendTo[Tests, ringTestTrue[
    "USACE M and Q unsupported",
    AllTrue[
      Join[UsaceValues["BendingMoment"], UsaceValues["ShearForce"]],
      MissingQ
    ]
  ]];

  FhwaCases = {
    {20.5, 36., 970., 3.4}, {20.5, 28., 970., 7.2},
    {5.2, 36., 970., 0.9}, {5.2, 28., 970., 1.8},
    {5.2, 36., 1575., 0.3}, {5.2, 28., 1575., 0.5},
    {4., 36., 970., 0.7}, {4., 28., 970., 1.4},
    {4., 36., 1575., 0.2}
  };
  FhwaCalculated = Map[
    fhwa1999CompactionPressure[#[[1]], #[[2]], #[[3]]]["PressureKpa"] &,
    FhwaCases
  ];
  AppendTo[Tests, ringTestNear[
    "FHWA Table 5.5",
    Round[FhwaCalculated, 0.1],
    FhwaCases[[All, 4]],
    1.*^-12
  ]];
  FhwaPressure = fhwa1999CompactionPressure[20.5, 36., 970.];
  FhwaStage = fhwa1999CompactionStageSpectrum[
    FhwaPressure,
    0.485,
    0.,
    40
  ];
  FhwaStageResponse = solveRingSpectrum[FhwaStage, 0.485];
  FhwaResidual = ringEquilibriumResidual[
    FhwaStage,
    FhwaStageResponse,
    0.485,
    N[Range[0, 256] 2 Pi/256]
  ];
  AppendTo[Tests, ringTestNear[
    "FHWA stage equilibrium",
    Join[
      FhwaResidual["MomentBalance"],
      FhwaResidual["RadialBalance"],
      FhwaResidual["TangentialBalance"]
    ],
    ConstantArray[0., 3 Length[FhwaResidual["Theta"]]],
    3.*^-12
  ]];

  NunezPrimary = nunez2000CircularResultants[
    10., 15., 0.15, 1.9, 1., 0., 0., 0.5, 0.5, 1., 500.,
    "Nunez 2000 example"
  ];
  AppendTo[Tests, ringTestNear[
    "Nunez 2000 primary interaction",
    NunezPrimary["InteractionRatio"],
    0.027,
    1.*^-14
  ]];
  AppendTo[Tests, ringTestNear[
    "Nunez 2000 primary M",
    NunezPrimary["MomentCrown"],
    1.2118,
    5.*^-5
  ]];
  AppendTo[Tests, ringTestNear[
    "Nunez 2000 primary N",
    NunezPrimary["NormalCrown"],
    54.343,
    5.*^-4
  ]];
  NunezFinal = nunez2000CircularResultants[
    10., 15., 0.35, 1.9, 1., 0., 0., 0.5, 1., 2., 320.,
    "Nunez 2000 example"
  ];
  AppendTo[Tests, ringTestNear[
    "Nunez 2000 final M",
    NunezFinal["MomentCrown"],
    9.118,
    5.*^-4
  ]];
  AppendTo[Tests, ringTestNear[
    "Nunez 2000 final N springline",
    NunezFinal["NormalSpringline"],
    147.5,
    1.*^-12
  ]];

  Draws = {
    <|"EffectiveVertical" -> 80., "K0" -> 0.5, "Radius" -> 2.|>,
    <|"EffectiveVertical" -> 100., "K0" -> 0.5, "Radius" -> 2.|>,
    <|"EffectiveVertical" -> 120., "K0" -> 0.5, "Radius" -> 2.|>
  };
  Scenario = Function[Draw,
    <|
      "Spectrum" -> atRestFreeFieldSpectrum[
        Draw["EffectiveVertical"], Draw["K0"], 0., 0.,
        "InterfaceBranch" -> "FullTraction"
      ],
      "Radius" -> Draw["Radius"],
      "SupportedResultants" -> {"N", "M", "Q"},
      "Metadata" -> <|"Fixture" -> True|>
    |>
  ];
  MonteCarlo = runRingMonteCarlo[
    Draws,
    Scenario,
    {0., Pi/2, Pi, 3 Pi/2},
    {0.05, 0.5, 0.95},
    "algorithmic fixture",
    "ExtremaScanPoints" -> 720,
    "KeepSampleCurves" -> True
  ];
  MedianPointwise = Select[
    MonteCarlo["PointwiseQuantiles"],
    #["Probability"] == 0.5 &
  ];
  MedianN = Lookup[
    Select[MedianPointwise, #["Resultant"] == "N" &],
    "Value"
  ];
  AppendTo[Tests, ringTestNear[
    "Monte Carlo pointwise N",
    MedianN,
    {-100., -200., -100., -200.},
    2.*^-12
  ]];

  UnsupportedScenario = Function[Draw,
    Join[
      Scenario[Draw],
      <|"SupportedResultants" -> {"N"}|>
    ]
  ];
  UnsupportedMonteCarlo = runRingMonteCarlo[
    Draws,
    UnsupportedScenario,
    {0., Pi/2, Pi, 3 Pi/2},
    {0.5},
    "unsupported-resultant fixture",
    "ExtremaScanPoints" -> 720
  ];
  UnsupportedPointwise = Select[
    UnsupportedMonteCarlo["PointwiseQuantiles"],
    MemberQ[{"M", "Q"}, #["Resultant"]] &
  ];
  UnsupportedExtrema = Select[
    UnsupportedMonteCarlo["ExtremaSamples"],
    MemberQ[{"M", "Q"}, #["Resultant"]] &
  ];
  UnsupportedExtremaQuantiles = Select[
    UnsupportedMonteCarlo["ExtremaQuantiles"],
    MemberQ[{"M", "Q"}, #["Resultant"]] &
  ];
  AppendTo[Tests, ringTestTrue[
    "unsupported MC resultants remain Missing everywhere",
    AllTrue[UnsupportedPointwise, MissingQ[#["Value"]] &] &&
      AllTrue[
        UnsupportedExtrema,
        MissingQ[#["Value"]] && MissingQ[#["Theta"]] &&
          MissingQ[#["ThetaDeg"]] &
      ] &&
      AllTrue[UnsupportedExtremaQuantiles, MissingQ[#["Value"]] &]
  ]];

  StageDraws = {
    <|"StageAPressure" -> 0., "StageBPressure" -> 100.|>,
    <|"StageAPressure" -> 100., "StageBPressure" -> 0.|>
  };
  StageScenario = Function[Draw,
    AssociationMap[
      Function[StageName,
        Module[{Pressure, Spectrum},
          Pressure = If[
            StageName == "StageA",
            Draw["StageAPressure"],
            Draw["StageBPressure"]
          ];
          Spectrum = newRingSpectrum[0];
          Spectrum = setRingCoefficient[Spectrum, "RadialCos", 0, -Pressure];
          <|
            "Spectrum" -> Spectrum,
            "Radius" -> 2.,
            "SupportedResultants" -> {"N", "M", "Q"},
            "Metadata" -> <|"Source" -> "crossed-stage fixture"|>
          |>
        ]
      ],
      {"StageA", "StageB"}
    ]
  ];
  StageMonteCarlo = runRingStageMonteCarlo[
    StageDraws,
    StageScenario,
    {0., Pi/2, Pi, 3 Pi/2},
    {0.5},
    "stage fixture",
    "ExtremaScanPoints" -> 720,
    "KeepSampleEnvelopes" -> True
  ];
  StageMedianN = Select[
    StageMonteCarlo["PointwiseStageEnvelopeQuantiles"],
    #["Resultant"] == "N" && #["Probability"] == 0.5 &
  ];
  AppendTo[Tests, ringTestNear[
    "stage MC lower envelope before quantile",
    Lookup[Select[StageMedianN, #["Bound"] == "Minimum" &], "Value"],
    ConstantArray[-200., 4],
    2.*^-12
  ]];
  AppendTo[Tests, ringTestNear[
    "stage MC upper envelope before quantile",
    Lookup[Select[StageMedianN, #["Bound"] == "Maximum" &], "Value"],
    ConstantArray[0., 4],
    2.*^-12
  ]];

  TieStageScenario = Function[Draw,
    AssociationMap[
      Function[StageName,
        Module[{Spectrum},
          Spectrum = newRingSpectrum[2];
          Spectrum = setRingCoefficient[
            Spectrum,
            If[StageName == "Cosine", "RadialCos", "RadialSin"],
            2,
            3.
          ];
          <|
            "Spectrum" -> Spectrum,
            "Radius" -> 1.,
            "SupportedResultants" -> {"N"},
            "Metadata" -> <|"Source" -> "angle-tie fixture"|>
          |>
        ]
      ],
      {"Cosine", "Sine"}
    ]
  ];
  TieStageMonteCarlo = runRingStageMonteCarlo[
    {<|"Fixture" -> True|>},
    TieStageScenario,
    N[Range[0, 7] Pi/4],
    {0.5},
    "stage-angle-tie fixture",
    "ExtremaScanPoints" -> 720
  ];
  TieNMinimum = First @ Select[
    TieStageMonteCarlo["ExtremaSamples"],
    #["Resultant"] == "N" && #["Statistic"] == "Minimum" &
  ];
  AppendTo[Tests, ringTestTrue[
    "stage tie with distinct angles invalidates controlling angle",
    TieNMinimum["StageStatus"] == "Tie" &&
      TieNMinimum["CoControllingStageCount"] == 2 &&
      MissingQ[TieNMinimum["Stage"]] &&
      MissingQ[TieNMinimum["Theta"]] &&
      MissingQ[TieNMinimum["ThetaDeg"]]
  ]];
  AppendTo[Tests, ringTestTrue[
    "stage extrema retain a homogeneous ScanPoints schema",
    AllTrue[
      TieStageMonteCarlo["ExtremaSamples"],
      KeyExistsQ[#, "ScanPoints"] &&
        #["ScanPoints"] == 720 &
    ]
  ]];

  SamplerSpecification = <|
    "FixedValue" -> fixedParameter[3.],
    "UniformValue" -> uniformParameter[0., 1.],
    "TriangularValue" -> triangularParameter[0., 0.25, 1.],
    "DiscreteValue" -> discreteParameter[{1., 2.}, {0.4, 0.6}]
  |>;
  SampleOne = sampleIndependentParameters[
    SamplerSpecification,
    20,
    20260809,
    True
  ];
  SampleTwo = sampleIndependentParameters[
    SamplerSpecification,
    20,
    20260809,
    True
  ];
  AppendTo[Tests, ringTestEqual[
    "Wolfram-native sampler deterministic replay",
    SampleOne,
    SampleTwo
  ]];

  <|
    "Passed" -> AllTrue[Tests, TrueQ[#["Passed"]] &],
    "TestCount" -> Length[Tests],
    "FailedCount" -> Count[Lookup[Tests, "Passed"], False],
    "Results" -> Tests
  |>
];
