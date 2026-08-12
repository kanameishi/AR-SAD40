(* ::Package:: *)

(*
  Non-FEM circular-ring engine for prescribed radial and tangential tractions.

  Convention:
    theta = 0 at crown and increases clockwise;
    radial traction is positive outward;
    tangential traction is positive with increasing theta;
    normal force N is positive in tension.

  The isotropic ring is the primary model. Orthotropy and corrugation are not
  introduced here. Source adapters return only the quantities supported by
  the cited source; unsupported resultants remain Missing["NotSupported"].
*)

ClearAll[
  $ringFailureTag,
  ringCatch,
  ringFail,
  ringEnsure,
  ringRequire,
  finiteRealQ,
  nonEmptyStringQ,
  ringMetadata,
  withRingMetadata,
  newRingSpectrum,
  validateRingSpectrum,
  setRingCoefficient,
  combineRingSpectra,
  scaleRingSpectrum,
  fitRingSpectrum,
  evaluateRingLoad,
  ringGlobalLoads,
  solveRingSpectrum,
  validateRingResponse,
  evaluateRingResponse,
  ringEquilibriumResidual,
  summarizeRingResponse,
  bakerDiametricLoadSpectrum,
  k0NormallyConsolidated,
  k0Overconsolidated,
  layeredEffectiveVerticalStress,
  ringVerticalStressOrdinates,
  atRestFreeFieldSpectrum,
  usace2020ServiceThrust,
  usace2020DesignThrust,
  usaceEquivalentUniformSpectrum,
  fhwa1999CompactionPressure,
  fhwa1999PrismLoad,
  fhwa1999CompactionStageSpectrum,
  nunez2014Resultants,
  nunez2000CircularResultants,
  nunez2014SymmetricProjection,
  fixedParameter,
  uniformParameter,
  normalParameter,
  lognormalParameter,
  triangularParameter,
  discreteParameter,
  sampleIndependentParameters,
  quantileType7,
  runRingMonteCarlo,
  runRingStageMonteCarlo,
  runOutputMonteCarlo
];

$ringFailureTag = "RingMethodologyFailure";

SetAttributes[ringCatch, HoldFirst];
ringCatch[expression_] := Catch[expression, $ringFailureTag];

ringFail[tag_String, message_String, data_: <||>] := Throw[
  Failure[tag, Join[<|"MessageTemplate" -> message|>, data]],
  $ringFailureTag
];

ringEnsure[value_] := If[
  FailureQ[value],
  Throw[value, $ringFailureTag],
  value
];

ringRequire[condition_, tag_String, message_String, data_: <||>] := If[
  ! TrueQ[condition],
  ringFail[tag, message, data]
];

finiteRealQ[value_] := Quiet @ Check[
  NumericQ[value] &&
    TrueQ[Im[N[value]] == 0] &&
    FreeQ[N[value], Indeterminate | ComplexInfinity | DirectedInfinity[_]],
  False
];

nonEmptyStringQ[value_] := StringQ[value] && StringLength[value] > 0;

ringMetadata[value_Association] := Lookup[value, "Metadata", <||>];

withRingMetadata[value_Association, metadata_Association] := Join[
  value,
  <|"Metadata" -> Join[ringMetadata[value], metadata]|>
];

newRingSpectrum[maxMode_] := ringCatch @ Module[
  {Modes},
  ringRequire[
    IntegerQ[maxMode] && maxMode >= 0,
    "InvalidMode",
    "maxMode must be a non-negative integer."
  ];
  Modes = Range[0, maxMode];
  <|
    "Type" -> "RingLoadSpectrum",
    "Modes" -> Modes,
    "RadialCos" -> ConstantArray[0., Length[Modes]],
    "RadialSin" -> ConstantArray[0., Length[Modes]],
    "TangentialCos" -> ConstantArray[0., Length[Modes]],
    "TangentialSin" -> ConstantArray[0., Length[Modes]],
    "Metadata" -> <||>
  |>
];

validateRingSpectrum[spectrum_] := ringCatch @ Module[
  {Required, Coefficients, MissingKeys, Modes, MaxMode, Metadata},
  Required = {
    "Modes", "RadialCos", "RadialSin", "TangentialCos", "TangentialSin"
  };
  Coefficients = Rest[Required];
  ringRequire[
    AssociationQ[spectrum],
    "InvalidSpectrum",
    "spectrum must be an Association."
  ];
  MissingKeys = Complement[Required, Keys[spectrum]];
  ringRequire[
    MissingKeys === {},
    "InvalidSpectrum",
    "spectrum is missing required keys.",
    <|"MissingKeys" -> MissingKeys|>
  ];
  Modes = spectrum["Modes"];
  ringRequire[
    ListQ[Modes] && Length[Modes] > 0 &&
      AllTrue[Modes, IntegerQ[#] && # >= 0 &] &&
      DuplicateFreeQ[Modes],
    "InvalidSpectrum",
    "Modes must be unique non-negative integers."
  ];
  MaxMode = Max[Modes];
  ringRequire[
    Modes === Range[0, MaxMode],
    "InvalidSpectrum",
    "spectrum must contain every mode from zero through Max[Modes]."
  ];
  ringRequire[
    And @@ Map[
      Function[Key,
        ListQ[spectrum[Key]] &&
          Length[spectrum[Key]] == Length[Modes] &&
          AllTrue[spectrum[Key], finiteRealQ]
      ],
      Coefficients
    ],
    "InvalidSpectrum",
    "All coefficient arrays must be finite real vectors matching Modes."
  ];
  ringRequire[
    spectrum["RadialSin"][[1]] == 0 &&
      spectrum["TangentialSin"][[1]] == 0,
    "InvalidSpectrum",
    "Sine coefficients for mode zero must be zero."
  ];
  Metadata = Lookup[spectrum, "Metadata", <||>];
  ringRequire[
    AssociationQ[Metadata],
    "InvalidSpectrum",
    "Metadata must be an Association."
  ];
  Join[
    <|"Type" -> Lookup[spectrum, "Type", "RingLoadSpectrum"]|>,
    KeyTake[spectrum, Required],
    <|"Metadata" -> Metadata|>
  ]
];

setRingCoefficient[spectrum_, key_, mode_, value_] := ringCatch @ Module[
  {Spectrum, CoefficientKeys, Coefficients},
  Spectrum = ringEnsure[validateRingSpectrum[spectrum]];
  CoefficientKeys = {
    "RadialCos", "RadialSin", "TangentialCos", "TangentialSin"
  };
  ringRequire[
    MemberQ[CoefficientKeys, key],
    "InvalidCoefficient",
    "key is not a ring-load coefficient name.",
    <|"Key" -> key|>
  ];
  ringRequire[
    IntegerQ[mode] && MemberQ[Spectrum["Modes"], mode],
    "InvalidCoefficient",
    "mode is not present in the spectrum.",
    <|"Mode" -> mode|>
  ];
  ringRequire[
    finiteRealQ[value],
    "InvalidCoefficient",
    "coefficient value must be finite and real."
  ];
  Coefficients = Spectrum[key];
  Coefficients[[mode + 1]] = value;
  Join[Spectrum, <|key -> Coefficients|>]
];

combineRingSpectra[spectra_] := ringCatch @ Module[
  {
    Validated, MaxMode, CoefficientKeys, Coefficients, Metadata,
    Components, MomentSupported, ShearSupported, RadialScale,
    TangentialScale, OUT
  },
  ringRequire[
    ListQ[spectra] && Length[spectra] > 0,
    "InvalidSpectra",
    "spectra must be a non-empty list."
  ];
  Validated = ringEnsure /@ (validateRingSpectrum /@ spectra);
  MaxMode = Max[Last /@ Lookup[Validated, "Modes"]];
  CoefficientKeys = {
    "RadialCos", "RadialSin", "TangentialCos", "TangentialSin"
  };
  Coefficients = AssociationMap[
    Function[Key,
      Total[PadRight[#[Key], MaxMode + 1, 0.] & /@ Validated]
    ],
    CoefficientKeys
  ];
  Components = Map[
    Function[Spectrum,
      <|
        "Source" -> Lookup[ringMetadata[Spectrum], "Source", Missing["Unknown"]],
        "Representation" -> Lookup[
          ringMetadata[Spectrum],
          "Representation",
          Missing["Unknown"]
        ]
      |>
    ],
    Validated
  ];
  MomentSupported = And @@ Lookup[
    ringMetadata /@ Validated,
    "MomentSupported",
    True
  ];
  ShearSupported = And @@ Lookup[
    ringMetadata /@ Validated,
    "ShearSupported",
    True
  ];
  RadialScale = Total @ Lookup[
    ringMetadata /@ Validated,
    "FitRadialLoadScale",
    0.
  ];
  TangentialScale = Total @ Lookup[
    ringMetadata /@ Validated,
    "FitTangentialLoadScale",
    0.
  ];
  Metadata = <|
    "Components" -> Components,
    "MomentSupported" -> MomentSupported,
    "ShearSupported" -> ShearSupported
  |>;
  If[RadialScale > 0, AssociateTo[Metadata, "FitRadialLoadScale" -> RadialScale]];
  If[
    TangentialScale > 0,
    AssociateTo[Metadata, "FitTangentialLoadScale" -> TangentialScale]
  ];
  OUT = ringEnsure[newRingSpectrum[MaxMode]];
  Join[OUT, Coefficients, <|"Metadata" -> Metadata|>]
];

scaleRingSpectrum[spectrum_, factor_] := ringCatch @ Module[
  {Spectrum, CoefficientKeys, Coefficients, Metadata},
  Spectrum = ringEnsure[validateRingSpectrum[spectrum]];
  ringRequire[
    finiteRealQ[factor],
    "InvalidScale",
    "factor must be finite and real."
  ];
  CoefficientKeys = {
    "RadialCos", "RadialSin", "TangentialCos", "TangentialSin"
  };
  Coefficients = AssociationMap[factor Spectrum[#] &, CoefficientKeys];
  Metadata = ringMetadata[Spectrum];
  If[
    KeyExistsQ[Metadata, "FitRadialLoadScale"],
    AssociateTo[
      Metadata,
      "FitRadialLoadScale" -> Abs[factor] Metadata["FitRadialLoadScale"]
    ]
  ];
  If[
    KeyExistsQ[Metadata, "FitTangentialLoadScale"],
    AssociateTo[
      Metadata,
      "FitTangentialLoadScale" ->
        Abs[factor] Metadata["FitTangentialLoadScale"]
    ]
  ];
  AssociateTo[Metadata, "ScaleFactor" -> factor];
  Join[Spectrum, Coefficients, <|"Metadata" -> Metadata|>]
];

Options[fitRingSpectrum] = {"GridTolerance" -> 1.*^-10};

fitRingSpectrum[
  theta_,
  radialOutward_,
  tangentialPositive_,
  maxMode_,
  OptionsPattern[]
] := ringCatch @ Module[
  {
    GridTolerance, Count, Wrapped, Order, Radial, Tangential, Target,
    GridError, Modes, RadialCos, RadialSin, TangentialCos,
    TangentialSin, Spectrum
  },
  GridTolerance = OptionValue["GridTolerance"];
  ringRequire[
    IntegerQ[maxMode] && maxMode >= 0,
    "InvalidMode",
    "maxMode must be a non-negative integer."
  ];
  ringRequire[
    finiteRealQ[GridTolerance] && GridTolerance > 0,
    "InvalidTolerance",
    "GridTolerance must be positive and finite."
  ];
  ringRequire[
    ListQ[theta] && ListQ[radialOutward] && ListQ[tangentialPositive],
    "InvalidGrid",
    "theta and both load vectors must be lists."
  ];
  Count = Length[theta];
  ringRequire[
    Count == Length[radialOutward] && Count == Length[tangentialPositive],
    "InvalidGrid",
    "theta and both load vectors must have the same length."
  ];
  ringRequire[
    Count >= 2 maxMode + 1,
    "AliasedGrid",
    "The angular grid is too short for maxMode without aliasing."
  ];
  ringRequire[
    AllTrue[Join[theta, radialOutward, tangentialPositive], finiteRealQ],
    "InvalidGrid",
    "theta and both load vectors must contain only finite real values."
  ];
  Wrapped = N[Mod[theta, 2 Pi]];
  Order = Ordering[Wrapped];
  Wrapped = Wrapped[[Order]];
  Radial = N[radialOutward[[Order]]];
  Tangential = N[tangentialPositive[[Order]]];
  Target = N[Range[0, Count - 1] 2 Pi/Count];
  GridError = Max[Abs[Wrapped - Target]];
  ringRequire[
    GridError <= GridTolerance,
    "InvalidGrid",
    "theta must be one complete equally spaced grid beginning at zero; do not include both zero and 2 Pi.",
    <|"GridError" -> GridError|>
  ];
  Modes = Range[1, maxMode];
  RadialCos = Join[
    {Mean[Radial]},
    Table[2 Mean[Radial Cos[n Target]], {n, Modes}]
  ];
  RadialSin = Join[
    {0.},
    Table[2 Mean[Radial Sin[n Target]], {n, Modes}]
  ];
  TangentialCos = Join[
    {Mean[Tangential]},
    Table[2 Mean[Tangential Cos[n Target]], {n, Modes}]
  ];
  TangentialSin = Join[
    {0.},
    Table[2 Mean[Tangential Sin[n Target]], {n, Modes}]
  ];
  Spectrum = ringEnsure[newRingSpectrum[maxMode]];
  Join[
    Spectrum,
    <|
      "RadialCos" -> RadialCos,
      "RadialSin" -> RadialSin,
      "TangentialCos" -> TangentialCos,
      "TangentialSin" -> TangentialSin,
      "Metadata" -> <|
        "FitRadialLoadScale" -> Max[Abs[Radial]],
        "FitTangentialLoadScale" -> Max[Abs[Tangential]]
      |>
    |>
  ]
];

evaluateRingLoad[spectrum_, theta_] := ringCatch @ Module[
  {Spectrum, Theta, Angles},
  Spectrum = ringEnsure[validateRingSpectrum[spectrum]];
  ringRequire[
    ListQ[theta] && AllTrue[theta, finiteRealQ],
    "InvalidAngle",
    "theta must be a finite real list."
  ];
  Theta = N[theta];
  Angles = Outer[Times, Theta, Spectrum["Modes"]];
  <|
    "Theta" -> Mod[Theta, 2 Pi],
    "RadialOutward" ->
      Cos[Angles].Spectrum["RadialCos"] + Sin[Angles].Spectrum["RadialSin"],
    "TangentialPositive" ->
      Cos[Angles].Spectrum["TangentialCos"] +
        Sin[Angles].Spectrum["TangentialSin"],
    "Metadata" -> ringMetadata[Spectrum]
  |>
];

ringGlobalLoads[spectrum_, radius_] := ringCatch @ Module[
  {Spectrum, RadialCos, RadialSin, TangentialCos, TangentialSin},
  Spectrum = ringEnsure[validateRingSpectrum[spectrum]];
  ringRequire[
    finiteRealQ[radius] && radius > 0,
    "InvalidRadius",
    "radius must be positive and finite."
  ];
  If[
    Last[Spectrum["Modes"]] >= 1,
    RadialCos = Spectrum["RadialCos"][[2]];
    RadialSin = Spectrum["RadialSin"][[2]];
    TangentialCos = Spectrum["TangentialCos"][[2]];
    TangentialSin = Spectrum["TangentialSin"][[2]],
    RadialCos = RadialSin = TangentialCos = TangentialSin = 0.
  ];
  <|
    "ForceX" -> Pi radius (RadialSin + TangentialCos),
    "ForceZ" -> Pi radius (-RadialCos + TangentialSin),
    "MomentCenter" -> 2 Pi radius^2 Spectrum["TangentialCos"][[1]]
  |>
];

Options[solveRingSpectrum] = {
  "Thickness" -> Missing["NotSpecified"],
  "UniformMoment" -> "Membrane",
  "RigidModeTolerance" -> 1.*^-10
};

solveRingSpectrum[spectrum_, radius_, OptionsPattern[]] := ringCatch @ Module[
  {
    Spectrum, Metadata, Thickness, UniformMoment, RigidTolerance,
    EquivalentRadius, RadiusError, RadiusTolerance, MaxMode, Count,
    RadialCosOne, RadialSinOne, TangentialCosOne, TangentialSinOne,
    FitRadialScale, FitTangentialScale, FloatingFactor, TorqueScale,
    TorqueTolerance, ForceXScale, ForceZScale, ForceXTolerance,
    ForceZTolerance, Global, NormalCos, NormalSin, MomentCos, MomentSin,
    ShearCos, ShearSin, CurvatureRatio, Denominator, i,
    MomentSupported, ShearSupported, ResponseMetadata
  },
  Spectrum = ringEnsure[validateRingSpectrum[spectrum]];
  Metadata = ringMetadata[Spectrum];
  Thickness = OptionValue["Thickness"];
  UniformMoment = OptionValue["UniformMoment"];
  RigidTolerance = OptionValue["RigidModeTolerance"];
  ringRequire[
    finiteRealQ[radius] && radius > 0,
    "InvalidRadius",
    "radius must be positive and finite."
  ];
  ringRequire[
    MemberQ[{"Membrane", "Baker"}, UniformMoment],
    "InvalidUniformMoment",
    "UniformMoment must be \"Membrane\" or \"Baker\"."
  ];
  ringRequire[
    finiteRealQ[RigidTolerance] && RigidTolerance > 0,
    "InvalidTolerance",
    "RigidModeTolerance must be positive and finite."
  ];
  If[
    UniformMoment == "Baker",
    ringRequire[
      finiteRealQ[Thickness] && Thickness > 0,
      "MissingThickness",
      "Thickness is required and must be positive for the Baker uniform-moment correction."
    ]
  ];
  If[
    KeyExistsQ[Metadata, "EquivalentRadius"],
    EquivalentRadius = Metadata["EquivalentRadius"];
    ringRequire[
      finiteRealQ[EquivalentRadius] && EquivalentRadius > 0,
      "InvalidRadius",
      "Metadata EquivalentRadius must be positive and finite."
    ];
    RadiusError = Abs[radius - EquivalentRadius];
    RadiusTolerance = RigidTolerance Max[Abs[EquivalentRadius], 1.*^-300];
    ringRequire[
      RadiusError <= RadiusTolerance,
      "RadiusMismatch",
      "radius does not match the spectrum EquivalentRadius; rebuild the projection after unit conversion.",
      <|"Radius" -> radius, "EquivalentRadius" -> EquivalentRadius|>
    ]
  ];
  MaxMode = Last[Spectrum["Modes"]];
  Count = MaxMode + 1;
  If[
    MaxMode >= 1,
    RadialCosOne = Spectrum["RadialCos"][[2]];
    RadialSinOne = Spectrum["RadialSin"][[2]];
    TangentialCosOne = Spectrum["TangentialCos"][[2]];
    TangentialSinOne = Spectrum["TangentialSin"][[2]],
    RadialCosOne = RadialSinOne = TangentialCosOne = TangentialSinOne = 0.
  ];
  FitRadialScale = Lookup[Metadata, "FitRadialLoadScale", 0.];
  FitTangentialScale = Lookup[Metadata, "FitTangentialLoadScale", 0.];
  ringRequire[
    finiteRealQ[FitRadialScale] && FitRadialScale >= 0 &&
      finiteRealQ[FitTangentialScale] && FitTangentialScale >= 0,
    "InvalidFitScale",
    "Fourier fit scales must be finite and non-negative."
  ];
  FloatingFactor = 64 $MachineEpsilon;
  TorqueScale = Max[
    Abs[Spectrum["TangentialCos"][[1]]],
    FitTangentialScale,
    0.
  ];
  TorqueTolerance = Max[RigidTolerance, FloatingFactor TorqueScale];
  ForceXScale = Abs[RadialSinOne] + Abs[TangentialCosOne] +
    FitRadialScale + FitTangentialScale;
  ForceZScale = Abs[RadialCosOne] + Abs[TangentialSinOne] +
    FitRadialScale + FitTangentialScale;
  ForceXTolerance = If[
    MaxMode >= 1,
    Max[RigidTolerance, FloatingFactor ForceXScale],
    RigidTolerance
  ];
  ForceZTolerance = If[
    MaxMode >= 1,
    Max[RigidTolerance, FloatingFactor ForceZScale],
    RigidTolerance
  ];
  ringRequire[
    Abs[Spectrum["TangentialCos"][[1]]] <= TorqueTolerance,
    "NetTorque",
    "A non-zero mean tangential load has a net torque and requires an explicit reaction."
  ];
  If[
    MaxMode >= 1 && (
      Abs[TangentialSinOne - RadialCosOne] > ForceZTolerance ||
      Abs[TangentialCosOne + RadialSinOne] > ForceXTolerance
    ),
    Global = ringEnsure[ringGlobalLoads[Spectrum, radius]];
    ringFail[
      "NetForce",
      "Mode n=1 has a non-zero global force; define body force, support, or contact reactions first.",
      Global
    ]
  ];
  NormalCos = ConstantArray[0., Count];
  NormalSin = ConstantArray[0., Count];
  MomentCos = ConstantArray[0., Count];
  MomentSin = ConstantArray[0., Count];
  ShearCos = ConstantArray[0., Count];
  ShearSin = ConstantArray[0., Count];
  NormalCos[[1]] = radius Spectrum["RadialCos"][[1]];
  If[
    UniformMoment == "Baker",
    CurvatureRatio = Thickness^2/(12 radius^2);
    MomentCos[[1]] = radius^2 CurvatureRatio/(1 + CurvatureRatio) *
      Spectrum["RadialCos"][[1]]
  ];
  If[
    MaxMode >= 1,
    NormalCos[[2]] = radius RadialCosOne;
    NormalSin[[2]] = radius RadialSinOne
  ];
  Do[
    i = n + 1;
    Denominator = n^2 - 1;
    NormalCos[[i]] = radius (
      n Spectrum["TangentialSin"][[i]] - Spectrum["RadialCos"][[i]]
    )/Denominator;
    MomentCos[[i]] = radius^2 (
      Spectrum["TangentialSin"][[i]]/n - Spectrum["RadialCos"][[i]]
    )/Denominator;
    ShearSin[[i]] = radius (
      n Spectrum["RadialCos"][[i]] - Spectrum["TangentialSin"][[i]]
    )/Denominator;
    NormalSin[[i]] = -radius (
      Spectrum["RadialSin"][[i]] + n Spectrum["TangentialCos"][[i]]
    )/Denominator;
    MomentSin[[i]] = -radius^2 (
      Spectrum["RadialSin"][[i]] + Spectrum["TangentialCos"][[i]]/n
    )/Denominator;
    ShearCos[[i]] = -radius (
      n Spectrum["RadialSin"][[i]] + Spectrum["TangentialCos"][[i]]
    )/Denominator,
    {n, 2, MaxMode}
  ];
  MomentSupported = Lookup[Metadata, "MomentSupported", True];
  ShearSupported = Lookup[Metadata, "ShearSupported", True];
  If[
    ! TrueQ[MomentSupported],
    MomentCos = MomentSin = ConstantArray[Missing["NotSupported"], Count]
  ];
  If[
    ! TrueQ[ShearSupported],
    ShearCos = ShearSin = ConstantArray[Missing["NotSupported"], Count]
  ];
  ResponseMetadata = Join[
    Metadata,
    <|
      "Radius" -> radius,
      "UniformMoment" -> UniformMoment,
      "Thickness" -> Thickness,
      "MomentSupported" -> TrueQ[MomentSupported],
      "ShearSupported" -> TrueQ[ShearSupported]
    |>
  ];
  <|
    "Type" -> "RingResponseSpectrum",
    "Modes" -> Spectrum["Modes"],
    "NormalCos" -> NormalCos,
    "NormalSin" -> NormalSin,
    "MomentCos" -> MomentCos,
    "MomentSin" -> MomentSin,
    "ShearCos" -> ShearCos,
    "ShearSin" -> ShearSin,
    "Metadata" -> ResponseMetadata
  |>
];

validateRingResponse[response_] := ringCatch @ Module[
  {Required, MissingKeys, Modes, Metadata, MomentSupported, ShearSupported},
  Required = {
    "Modes", "NormalCos", "NormalSin", "MomentCos", "MomentSin",
    "ShearCos", "ShearSin"
  };
  ringRequire[
    AssociationQ[response],
    "InvalidResponse",
    "response must be an Association."
  ];
  MissingKeys = Complement[Required, Keys[response]];
  ringRequire[
    MissingKeys === {},
    "InvalidResponse",
    "response is missing required keys.",
    <|"MissingKeys" -> MissingKeys|>
  ];
  Modes = response["Modes"];
  ringRequire[
    ListQ[Modes] && Length[Modes] > 0 && Modes === Range[0, Max[Modes]],
    "InvalidResponse",
    "response Modes must contain every integer from zero through Max[Modes]."
  ];
  ringRequire[
    AllTrue[{"NormalCos", "NormalSin"},
      ListQ[response[#]] && Length[response[#]] == Length[Modes] &&
        AllTrue[response[#], finiteRealQ] &
    ],
    "InvalidResponse",
    "normal-force coefficients must be finite real vectors."
  ];
  Metadata = Lookup[response, "Metadata", <||>];
  ringRequire[
    AssociationQ[Metadata],
    "InvalidResponse",
    "response Metadata must be an Association."
  ];
  MomentSupported = Lookup[Metadata, "MomentSupported", True];
  ShearSupported = Lookup[Metadata, "ShearSupported", True];
  ringRequire[
    AllTrue[{"MomentCos", "MomentSin"},
      ListQ[response[#]] && Length[response[#]] == Length[Modes] &&
        If[
          TrueQ[MomentSupported],
          AllTrue[response[#], finiteRealQ],
          AllTrue[response[#], finiteRealQ[#] || MissingQ[#] &]
        ] &
    ],
    "InvalidResponse",
    "moment coefficients are inconsistent with MomentSupported."
  ];
  ringRequire[
    AllTrue[{"ShearCos", "ShearSin"},
      ListQ[response[#]] && Length[response[#]] == Length[Modes] &&
        If[
          TrueQ[ShearSupported],
          AllTrue[response[#], finiteRealQ],
          AllTrue[response[#], finiteRealQ[#] || MissingQ[#] &]
        ] &
    ],
    "InvalidResponse",
    "shear coefficients are inconsistent with ShearSupported."
  ];
  Join[
    <|"Type" -> Lookup[response, "Type", "RingResponseSpectrum"]|>,
    KeyTake[response, Required],
    <|"Metadata" -> Metadata|>
  ]
];

evaluateRingResponse[response_, theta_] := ringCatch @ Module[
  {Response, Theta, Angles, Metadata, MomentSupported, ShearSupported},
  Response = ringEnsure[validateRingResponse[response]];
  ringRequire[
    ListQ[theta] && AllTrue[theta, finiteRealQ],
    "InvalidAngle",
    "theta must be a finite real list."
  ];
  Theta = N[theta];
  Angles = Outer[Times, Theta, Response["Modes"]];
  Metadata = ringMetadata[Response];
  MomentSupported = Lookup[Metadata, "MomentSupported", True];
  ShearSupported = Lookup[Metadata, "ShearSupported", True];
  <|
    "Theta" -> Mod[Theta, 2 Pi],
    "NormalForce" ->
      Cos[Angles].Response["NormalCos"] + Sin[Angles].Response["NormalSin"],
    "BendingMoment" -> If[
      TrueQ[MomentSupported],
      Cos[Angles].Response["MomentCos"] + Sin[Angles].Response["MomentSin"],
      ConstantArray[Missing["NotSupported"], Length[Theta]]
    ],
    "ShearForce" -> If[
      TrueQ[ShearSupported],
      Cos[Angles].Response["ShearCos"] + Sin[Angles].Response["ShearSin"],
      ConstantArray[Missing["NotSupported"], Length[Theta]]
    ],
    "Metadata" -> Metadata
  |>
];

ringEquilibriumResidual[spectrum_, response_, radius_, theta_] :=
  ringCatch @ Module[
    {
      Spectrum, Response, Metadata, Loads, Resultants, Theta, Angles,
      Modes, MomentDerivative, NormalDerivative, ShearDerivative
    },
    Spectrum = ringEnsure[validateRingSpectrum[spectrum]];
    Response = ringEnsure[validateRingResponse[response]];
    ringRequire[
      Spectrum["Modes"] === Response["Modes"],
      "ModeMismatch",
      "load and response spectra must contain the same modes."
    ];
    ringRequire[
      finiteRealQ[radius] && radius > 0,
      "InvalidRadius",
      "radius must be positive and finite."
    ];
    ringRequire[
      ListQ[theta] && AllTrue[theta, finiteRealQ],
      "InvalidAngle",
      "theta must be a finite real list."
    ];
    Metadata = ringMetadata[Response];
    ringRequire[
      TrueQ[Lookup[Metadata, "MomentSupported", True]] &&
        TrueQ[Lookup[Metadata, "ShearSupported", True]],
      "EquilibriumUnavailable",
      "M and Q must be supported to evaluate all three ring-equilibrium equations."
    ];
    Theta = N[theta];
    Loads = ringEnsure[evaluateRingLoad[Spectrum, Theta]];
    Resultants = ringEnsure[evaluateRingResponse[Response, Theta]];
    Angles = Outer[Times, Theta, Response["Modes"]];
    Modes = Response["Modes"];
    MomentDerivative =
      (-Sin[Angles]).(Modes Response["MomentCos"]) +
        Cos[Angles].(Modes Response["MomentSin"]);
    NormalDerivative =
      (-Sin[Angles]).(Modes Response["NormalCos"]) +
        Cos[Angles].(Modes Response["NormalSin"]);
    ShearDerivative =
      (-Sin[Angles]).(Modes Response["ShearCos"]) +
        Cos[Angles].(Modes Response["ShearSin"]);
    <|
      "Theta" -> Mod[Theta, 2 Pi],
      "MomentBalance" -> radius Resultants["ShearForce"] - MomentDerivative,
      "RadialBalance" -> radius Loads["RadialOutward"] -
        Resultants["NormalForce"] - ShearDerivative,
      "TangentialBalance" -> NormalDerivative - Resultants["ShearForce"] +
        radius Loads["TangentialPositive"]
    |>
  ];

Options[summarizeRingResponse] = {"ScanPoints" -> Automatic};

summarizeRingResponse[response_, OptionsPattern[]] := ringCatch @ Module[
  {
    Response, RequestedScan, Definitions, Supported, ActiveModes,
    MaxMode, ScanPoints, MinimumScan, Theta, Step, x, Rows, Definition,
    Resultant, CosKey, SinKey, CoefficientsCos, CoefficientsSin,
    ConstantResponse, Expression, GridValues, MinIndex, MaxIndex,
    MinCenter, MaxCenter, Minimum, Maximum, MinValue, MaxValue,
    MinAngle, MaxAngle, AbsValue, AbsAngle
  },
  Response = ringEnsure[validateRingResponse[response]];
  RequestedScan = OptionValue["ScanPoints"];
  Definitions = {
    <|"Resultant" -> "N", "CosKey" -> "NormalCos", "SinKey" -> "NormalSin"|>,
    <|"Resultant" -> "M", "CosKey" -> "MomentCos", "SinKey" -> "MomentSin"|>,
    <|"Resultant" -> "Q", "CosKey" -> "ShearCos", "SinKey" -> "ShearSin"|>
  };
  Supported = <|
    "N" -> True,
    "M" -> TrueQ[Lookup[ringMetadata[Response], "MomentSupported", True]],
    "Q" -> TrueQ[Lookup[ringMetadata[Response], "ShearSupported", True]]
  |>;
  ActiveModes = Select[
    Response["Modes"],
    Function[n,
      AnyTrue[
        {
          Response["NormalCos"][[n + 1]], Response["NormalSin"][[n + 1]],
          If[Supported["M"], Response["MomentCos"][[n + 1]], 0],
          If[Supported["M"], Response["MomentSin"][[n + 1]], 0],
          If[Supported["Q"], Response["ShearCos"][[n + 1]], 0],
          If[Supported["Q"], Response["ShearSin"][[n + 1]], 0]
        },
        finiteRealQ[#] && Abs[#] > 0 &
      ]
    ]
  ];
  MaxMode = If[ActiveModes === {}, 0, Max[ActiveModes]];
  If[
    RequestedScan === Automatic,
    ScanPoints = Max[720, 64 Max[MaxMode, 1]],
    MinimumScan = Max[16, 16 Max[MaxMode, 1]];
    ringRequire[
      IntegerQ[RequestedScan] && RequestedScan >= MinimumScan,
      "AliasedExtremaGrid",
      "ScanPoints must be an integer large enough for the active Fourier modes.",
      <|"MinimumScanPoints" -> MinimumScan|>
    ];
    ScanPoints = RequestedScan
  ];
  Theta = N[Range[0, ScanPoints - 1] 2 Pi/ScanPoints];
  Step = 2 Pi/ScanPoints;
  Rows = {};
  Do[
    Definition = Definitions[[i]];
    Resultant = Definition["Resultant"];
    If[
      ! Supported[Resultant],
      Rows = Join[
        Rows,
        Map[
          <|
            "Resultant" -> Resultant,
            "Statistic" -> #,
            "Value" -> Missing["NotSupported"],
            "Theta" -> Missing["NotSupported"],
            "ThetaDeg" -> Missing["NotSupported"],
            "ScanPoints" -> ScanPoints
          |> &,
          {"Minimum", "Maximum", "AbsoluteMaximum"}
        ]
      ];
      Continue[]
    ];
    CosKey = Definition["CosKey"];
    SinKey = Definition["SinKey"];
    CoefficientsCos = Response[CosKey];
    CoefficientsSin = Response[SinKey];
    ConstantResponse = AllTrue[
      Range[2, Length[CoefficientsCos]],
      CoefficientsCos[[#]] == 0 && CoefficientsSin[[#]] == 0 &
    ];
    Expression = Total[
      CoefficientsCos Cos[Response["Modes"] x] +
        CoefficientsSin Sin[Response["Modes"] x]
    ];
    GridValues = N[Expression /. x -> #] & /@ Theta;
    If[
      ConstantResponse,
      MinValue = MaxValue = First[GridValues];
      MinAngle = MaxAngle = 0.,
      MinIndex = First[Ordering[GridValues, 1]];
      MaxIndex = First[Ordering[GridValues, -1]];
      MinCenter = Theta[[MinIndex]];
      MaxCenter = Theta[[MaxIndex]];
      Minimum = Quiet @ Check[
        FindMinimum[
          {Expression, MinCenter - Step <= x <= MinCenter + Step},
          {x, MinCenter},
          AccuracyGoal -> 10,
          PrecisionGoal -> 8
        ],
        $Failed
      ];
      Maximum = Quiet @ Check[
        FindMaximum[
          {Expression, MaxCenter - Step <= x <= MaxCenter + Step},
          {x, MaxCenter},
          AccuracyGoal -> 10,
          PrecisionGoal -> 8
        ],
        $Failed
      ];
      ringRequire[
        Minimum =!= $Failed && Maximum =!= $Failed,
        "ExtremaFailure",
        "Continuous extrema refinement failed."
      ];
      MinValue = First[Minimum];
      MinAngle = Mod[x /. Last[Minimum], 2 Pi];
      MaxValue = First[Maximum];
      MaxAngle = Mod[x /. Last[Maximum], 2 Pi]
    ];
    If[
      Abs[MaxValue] >= Abs[MinValue],
      AbsValue = MaxValue;
      AbsAngle = MaxAngle,
      AbsValue = MinValue;
      AbsAngle = MinAngle
    ];
    Rows = Join[
      Rows,
      {
        <|
          "Resultant" -> Resultant,
          "Statistic" -> "Minimum",
          "Value" -> MinValue,
          "Theta" -> MinAngle,
          "ThetaDeg" -> MinAngle 180/Pi,
          "ScanPoints" -> ScanPoints
        |>,
        <|
          "Resultant" -> Resultant,
          "Statistic" -> "Maximum",
          "Value" -> MaxValue,
          "Theta" -> MaxAngle,
          "ThetaDeg" -> MaxAngle 180/Pi,
          "ScanPoints" -> ScanPoints
        |>,
        <|
          "Resultant" -> Resultant,
          "Statistic" -> "AbsoluteMaximum",
          "Value" -> AbsValue,
          "Theta" -> AbsAngle,
          "ThetaDeg" -> AbsAngle 180/Pi,
          "ScanPoints" -> ScanPoints
        |>
      }
    ],
    {i, Length[Definitions]}
  ];
  Rows
];

Options[bakerDiametricLoadSpectrum] = {
  "LoadPerPatch" -> 1.,
  "Radius" -> 1.,
  "RingWidth" -> 1.
};

bakerDiametricLoadSpectrum[
  halfAngleDeg_,
  maxMode_,
  OptionsPattern[]
] := ringCatch @ Module[
  {LoadPerPatch, Radius, RingWidth, Spectrum, RadialCos, HalfAngle, Shape},
  LoadPerPatch = OptionValue["LoadPerPatch"];
  Radius = OptionValue["Radius"];
  RingWidth = OptionValue["RingWidth"];
  ringRequire[
    finiteRealQ[halfAngleDeg] && 0 <= halfAngleDeg < 90,
    "InvalidHalfAngle",
    "halfAngleDeg must lie in [0, 90)."
  ];
  ringRequire[
    IntegerQ[maxMode] && maxMode >= 2,
    "InvalidMode",
    "maxMode must be an integer of at least two."
  ];
  ringRequire[
    And @@ (finiteRealQ[#] && # > 0 & /@ {LoadPerPatch, Radius, RingWidth}),
    "InvalidLoad",
    "LoadPerPatch, Radius, and RingWidth must be positive and finite."
  ];
  Spectrum = ringEnsure[newRingSpectrum[maxMode]];
  RadialCos = Spectrum["RadialCos"];
  RadialCos[[1]] = -LoadPerPatch/(Pi Radius RingWidth);
  HalfAngle = halfAngleDeg Pi/180;
  Do[
    If[
      EvenQ[n],
      Shape = If[halfAngleDeg == 0, 1., Sin[n HalfAngle]/(n HalfAngle)];
      RadialCos[[n + 1]] = -2 LoadPerPatch/(Pi Radius RingWidth) Shape
    ],
    {n, 2, maxMode}
  ];
  Join[Spectrum, <|"RadialCos" -> RadialCos|>]
];

(* Soil-state and source adapters. *)

k0NormallyConsolidated[frictionAngleDeg_] := ringCatch @ Module[{},
  ringRequire[
    finiteRealQ[frictionAngleDeg] && 0 <= frictionAngleDeg < 90,
    "InvalidFrictionAngle",
    "frictionAngleDeg must lie in [0, 90)."
  ];
  1 - Sin[frictionAngleDeg Pi/180]
];

k0Overconsolidated[frictionAngleDeg_, ocr_] := ringCatch @ Module[{K0Nc},
  ringRequire[
    finiteRealQ[frictionAngleDeg] && 0 <= frictionAngleDeg < 90,
    "InvalidFrictionAngle",
    "frictionAngleDeg must lie in [0, 90)."
  ];
  ringRequire[
    finiteRealQ[ocr] && ocr >= 1,
    "InvalidOCR",
    "ocr must be finite and at least one."
  ];
  K0Nc = ringEnsure[k0NormallyConsolidated[frictionAngleDeg]];
  K0Nc ocr^Sin[frictionAngleDeg Pi/180]
];

layeredEffectiveVerticalStress[
  depth_,
  layerBottom_,
  effectiveUnitWeight_,
  effectiveSurcharge_
] := ringCatch @ Module[{LayerTop},
  ringRequire[
    ListQ[depth] && Length[depth] > 0 &&
      AllTrue[depth, finiteRealQ[#] && # >= 0 &],
    "InvalidDepth",
    "depth must be a non-empty finite non-negative list."
  ];
  ringRequire[
    ListQ[layerBottom] && Length[layerBottom] > 0 &&
      Last[layerBottom] === Infinity &&
      AllTrue[Most[layerBottom], finiteRealQ[#] && # > 0 &] &&
      And @@ Thread[Rest[layerBottom] > Most[layerBottom]],
    "InvalidLayers",
    "layerBottom must be strictly increasing, positive, and end at Infinity."
  ];
  ringRequire[
    ListQ[effectiveUnitWeight] &&
      Length[effectiveUnitWeight] == Length[layerBottom] &&
      AllTrue[effectiveUnitWeight, finiteRealQ[#] && # >= 0 &],
    "InvalidUnitWeight",
    "effectiveUnitWeight must be finite, non-negative, and match layerBottom."
  ];
  ringRequire[
    finiteRealQ[effectiveSurcharge] && effectiveSurcharge >= 0,
    "InvalidSurcharge",
    "effectiveSurcharge must be finite and non-negative."
  ];
  LayerTop = Prepend[Most[layerBottom], 0];
  Map[
    Function[CurrentDepth,
      effectiveSurcharge + Total[
        effectiveUnitWeight MapThread[
          Max[0, Min[CurrentDepth, #1] - #2] &,
          {layerBottom, LayerTop}
        ]
      ]
    ],
    depth
  ]
];

ringVerticalStressOrdinates[
  coverCrown_,
  radius_,
  layerBottom_,
  effectiveUnitWeight_,
  effectiveSurcharge_,
  waterTableDepth_,
  waterUnitWeight_
] := ringCatch @ Module[{Depth, Effective, Pore},
  ringRequire[
    finiteRealQ[coverCrown] && coverCrown >= 0,
    "InvalidCover",
    "coverCrown must be finite and non-negative."
  ];
  ringRequire[
    finiteRealQ[radius] && radius > 0,
    "InvalidRadius",
    "radius must be positive and finite."
  ];
  ringRequire[
    waterTableDepth === Infinity ||
      (finiteRealQ[waterTableDepth] && waterTableDepth >= 0),
    "InvalidWaterTable",
    "waterTableDepth must be non-negative or Infinity."
  ];
  ringRequire[
    finiteRealQ[waterUnitWeight] && waterUnitWeight >= 0,
    "InvalidWaterUnitWeight",
    "waterUnitWeight must be finite and non-negative."
  ];
  Depth = coverCrown + {0, radius, 2 radius};
  Effective = ringEnsure[layeredEffectiveVerticalStress[
    Depth,
    layerBottom,
    effectiveUnitWeight,
    effectiveSurcharge
  ]];
  Pore = If[
    waterTableDepth === Infinity,
    ConstantArray[0., Length[Depth]],
    waterUnitWeight Map[Max[0, # - waterTableDepth] &, Depth]
  ];
  MapThread[
    <|
      "Location" -> #1,
      "Depth" -> #2,
      "EffectiveVertical" -> #3,
      "PorePressure" -> #4,
      "TotalVertical" -> #3 + #4
    |> &,
    {{"Crown", "Axis", "Invert"}, Depth, Effective, Pore}
  ]
];

Options[atRestFreeFieldSpectrum] = {"InterfaceBranch" -> "FullTraction"};

atRestFreeFieldSpectrum[
  effectiveVertical_,
  k0_,
  porePressure_,
  residualHorizontal_,
  OptionsPattern[]
] := ringCatch @ Module[
  {InterfaceBranch, EffectiveHorizontal, MeanPressure, Difference, Spectrum},
  InterfaceBranch = OptionValue["InterfaceBranch"];
  ringRequire[
    And @@ (finiteRealQ[#] && # >= 0 & /@
      {effectiveVertical, k0, porePressure, residualHorizontal}),
    "InvalidPressure",
    "all pressure-state inputs must be finite and non-negative."
  ];
  ringRequire[
    MemberQ[{"FullTraction", "NormalOnly"}, InterfaceBranch],
    "InvalidInterface",
    "InterfaceBranch must be \"FullTraction\" or \"NormalOnly\"."
  ];
  EffectiveHorizontal = k0 effectiveVertical + residualHorizontal;
  MeanPressure = porePressure + (effectiveVertical + EffectiveHorizontal)/2;
  Difference = effectiveVertical - EffectiveHorizontal;
  Spectrum = ringEnsure[newRingSpectrum[2]];
  Spectrum = ringEnsure[setRingCoefficient[
    Spectrum,
    "RadialCos",
    0,
    -MeanPressure
  ]];
  Spectrum = ringEnsure[setRingCoefficient[
    Spectrum,
    "RadialCos",
    2,
    -Difference/2
  ]];
  If[
    InterfaceBranch == "FullTraction",
    Spectrum = ringEnsure[setRingCoefficient[
      Spectrum,
      "TangentialSin",
      2,
      Difference/2
    ]]
  ];
  withRingMetadata[
    Spectrum,
    <|
      "Source" -> "derived free-field tensor projection",
      "Representation" -> InterfaceBranch,
      "EffectiveVertical" -> effectiveVertical,
      "EffectiveHorizontal" -> EffectiveHorizontal,
      "PorePressure" -> porePressure,
      "AngularTractionAvailable" -> True
    |>
  ]
];

usace2020ServiceThrust[
  unitWeight_,
  coverCrown_,
  span_,
  livePressure_,
  liveWidth_,
  liveShapeFactor_,
  unitSystem_,
  lengthUnit_,
  forceUnit_,
  liveInputSource_,
  liveCriteriaConfirmed_
] := ringCatch @ Module[
  {ValidUnitPair, LiveInputs, LiveOmitted, EightFeet, DeadPressure, DeadThrust, LiveThrust},
  ringRequire[
    And @@ (finiteRealQ[#] && # >= 0 & /@
      {unitWeight, coverCrown, livePressure, liveWidth, liveShapeFactor}) &&
      finiteRealQ[span] && span > 0,
    "InvalidUSACEInput",
    "USACE load inputs must be finite and non-negative, with positive span."
  ];
  ringRequire[
    MemberQ[{"SI", "US"}, unitSystem],
    "InvalidUnitSystem",
    "unitSystem must be \"SI\" or \"US\"."
  ];
  ringRequire[
    nonEmptyStringQ[lengthUnit] && nonEmptyStringQ[forceUnit] &&
      nonEmptyStringQ[liveInputSource],
    "InvalidSource",
    "unit and live-load source strings must be non-empty."
  ];
  ringRequire[
    TrueQ[liveCriteriaConfirmed],
    "UnconfirmedLiveLoad",
    "liveCriteriaConfirmed must be True after checking USACE Eq. 4-20 and its AASHTO conditions."
  ];
  ValidUnitPair = If[
    unitSystem == "SI",
    lengthUnit == "m" && MemberQ[{"N", "kN"}, forceUnit],
    lengthUnit == "ft" && MemberQ[{"lb", "kip"}, forceUnit]
  ];
  ringRequire[
    ValidUnitPair,
    "InvalidUnits",
    "Use SI with m and N/kN, or US with ft and lb/kip; convert inputs before calling the adapter."
  ];
  LiveInputs = {livePressure, liveWidth, liveShapeFactor};
  LiveOmitted = AllTrue[LiveInputs, # == 0 &];
  ringRequire[
    LiveOmitted || AllTrue[LiveInputs, # > 0 &],
    "InvalidLiveLoad",
    "livePressure, liveWidth, and liveShapeFactor must all be positive or all zero under a documented omission."
  ];
  ringRequire[
    LiveOmitted || liveWidth <= span,
    "InvalidLiveWidth",
    "liveWidth must not exceed span under USACE Eq. 4-20."
  ];
  ringRequire[
    LiveOmitted || liveShapeFactor >= 1,
    "InvalidLiveFactor",
    "liveShapeFactor must be at least 1.0 under the audited USACE limits."
  ];
  EightFeet = If[unitSystem == "US", 8., 8. 0.3048];
  ringRequire[
    ! LiveOmitted || (coverCrown > EightFeet && coverCrown > span),
    "InvalidLiveOmission",
    "USACE live load may be omitted only when cover exceeds both 8 ft (2.4384 m) and span."
  ];
  DeadPressure = unitWeight coverCrown;
  DeadThrust = DeadPressure span/2;
  LiveThrust = livePressure liveWidth liveShapeFactor/2;
  <|
    "Type" -> "USACE2020Thrust",
    "Source" -> "USACE EM 1110-2-2902 (2020)",
    "SourceLocation" -> "Appendix D4 p. 332/PDF 346; Eq. 4-20 p. 86/PDF 100",
    "Representation" -> "ScalarThrust",
    "DeadCrownPressure" -> DeadPressure,
    "DeadThrust" -> DeadThrust,
    "LiveThrust" -> LiveThrust,
    "ServiceThrust" -> DeadThrust + LiveThrust,
    "Span" -> span,
    "EquivalentRadius" -> span/2,
    "UnitSystem" -> unitSystem,
    "LengthUnit" -> lengthUnit,
    "ForceUnit" -> forceUnit,
    "UnitWeightUnit" -> forceUnit <> "/" <> lengthUnit <> "^3",
    "PressureUnit" -> forceUnit <> "/" <> lengthUnit <> "^2",
    "ThrustUnit" -> forceUnit <> "/" <> lengthUnit,
    "LiveInputSource" -> liveInputSource,
    "LiveCriteriaConfirmed" -> True,
    "LiveLoadOmitted" -> LiveOmitted,
    "AngularTractionAvailable" -> False,
    "MomentSupported" -> False,
    "ShearSupported" -> False
  |>
];

usace2020DesignThrust[
  serviceThrust_,
  deadLoadFactor_,
  liveLoadFactor_,
  demandModifier_,
  factorSource_,
  modifierSource_
] := ringCatch @ Module[{DesignBeforeModifier},
  ringRequire[
    AssociationQ[serviceThrust] &&
      Lookup[serviceThrust, "Type", Missing["Unknown"]] == "USACE2020Thrust",
    "InvalidUSACEThrust",
    "serviceThrust must be returned by usace2020ServiceThrust."
  ];
  ringRequire[
    And @@ (finiteRealQ[#] && # >= 0 & /@
      {deadLoadFactor, liveLoadFactor, demandModifier}),
    "InvalidFactor",
    "USACE factors must be finite and non-negative."
  ];
  ringRequire[
    nonEmptyStringQ[factorSource] && nonEmptyStringQ[modifierSource],
    "InvalidSource",
    "factorSource and modifierSource must be non-empty."
  ];
  DesignBeforeModifier = deadLoadFactor serviceThrust["DeadThrust"] +
    liveLoadFactor serviceThrust["LiveThrust"];
  Join[
    serviceThrust,
    <|
      "DeadLoadFactor" -> deadLoadFactor,
      "LiveLoadFactor" -> liveLoadFactor,
      "DemandModifier" -> demandModifier,
      "FactorSource" -> factorSource,
      "ModifierSource" -> modifierSource,
      "DesignThrustBeforeModifier" -> DesignBeforeModifier,
      "DesignThrust" -> demandModifier DesignBeforeModifier
    |>
  ]
];

Options[usaceEquivalentUniformSpectrum] = {"Demand" -> "Service"};

usaceEquivalentUniformSpectrum[thrustResult_, OptionsPattern[]] :=
  ringCatch @ Module[{Demand, Thrust, Radius, Spectrum},
    Demand = OptionValue["Demand"];
    ringRequire[
      AssociationQ[thrustResult] &&
        Lookup[thrustResult, "Type", Missing["Unknown"]] == "USACE2020Thrust",
      "InvalidUSACEThrust",
      "thrustResult must be returned by a USACE thrust adapter."
    ];
    ringRequire[
      MemberQ[{"Service", "Design"}, Demand],
      "InvalidDemand",
      "Demand must be \"Service\" or \"Design\"."
    ];
    If[
      Demand == "Design",
      ringRequire[
        KeyExistsQ[thrustResult, "DesignThrust"],
        "MissingDesignThrust",
        "Run usace2020DesignThrust before requesting the design projection."
      ]
    ];
    Thrust = If[Demand == "Service", thrustResult["ServiceThrust"], thrustResult["DesignThrust"]];
    Radius = thrustResult["Span"]/2;
    Spectrum = ringEnsure[newRingSpectrum[0]];
    Spectrum = ringEnsure[setRingCoefficient[
      Spectrum,
      "RadialCos",
      0,
      -Thrust/Radius
    ]];
    withRingMetadata[
      Spectrum,
      <|
        "Source" -> thrustResult["Source"],
        "Representation" -> "uniform equivalent for scalar thrust",
        "Equivalence" -> "N0 only",
        "EquivalentRadius" -> Radius,
        "LengthUnit" -> thrustResult["LengthUnit"],
        "ForceUnit" -> thrustResult["ForceUnit"],
        "PressureUnit" -> thrustResult["PressureUnit"],
        "ResultantUnit" -> thrustResult["ThrustUnit"],
        "AngularTractionAvailable" -> False,
        "MomentSupported" -> False,
        "ShearSupported" -> False
      |>
    ]
  ];

fhwa1999CompactionPressure[
  totalCompactorForceKn_,
  frictionAngleDeg_,
  centroidalDiameterMm_
] := ringCatch @ Module[
  {EffectiveForceKn, PressureKpa, PublishedConfigurations, Matches, Within},
  ringRequire[
    finiteRealQ[totalCompactorForceKn] && totalCompactorForceKn >= 0,
    "InvalidCompactorForce",
    "totalCompactorForceKn must be finite and non-negative."
  ];
  ringRequire[
    finiteRealQ[frictionAngleDeg] && 0 <= frictionAngleDeg < 90,
    "InvalidFrictionAngle",
    "frictionAngleDeg must lie in [0, 90)."
  ];
  ringRequire[
    finiteRealQ[centroidalDiameterMm] && centroidalDiameterMm > 250,
    "InvalidDiameter",
    "centroidalDiameterMm must exceed 250 mm."
  ];
  EffectiveForceKn = Max[totalCompactorForceKn, 4.];
  PressureKpa = 1.3 EffectiveForceKn (
    1 - Sin[frictionAngleDeg Pi/180]
  )^3 (970/(centroidalDiameterMm - 250))^2;
  PublishedConfigurations = {
    {20.5, 36., 970.}, {20.5, 28., 970.},
    {5.2, 36., 970.}, {5.2, 28., 970.},
    {5.2, 36., 1575.}, {5.2, 28., 1575.},
    {4., 36., 970.}, {4., 28., 970.}, {4., 36., 1575.}
  };
  Matches = AnyTrue[
    PublishedConfigurations,
    Abs[#[[1]] - totalCompactorForceKn] < 1.*^-12 &&
      Abs[#[[2]] - frictionAngleDeg] < 1.*^-12 &&
      Abs[#[[3]] - centroidalDiameterMm] < 1.*^-9 &
  ];
  Within = 970 <= centroidalDiameterMm <= 1575 &&
    28 <= frictionAngleDeg <= 36 &&
    4 <= totalCompactorForceKn <= 20.5;
  <|
    "Type" -> "FHWA1999CompactionPressure",
    "Source" -> "FHWA-RD-98-191 (1999)",
    "SourceLocation" -> "Eq. 5.1, printed p. 177/PDF 192",
    "Representation" -> "scalar CANDE nodal pressure",
    "InputCompactorForceKn" -> totalCompactorForceKn,
    "EffectiveForceKn" -> EffectiveForceKn,
    "FrictionAngleDeg" -> frictionAngleDeg,
    "CentroidalDiameterMm" -> centroidalDiameterMm,
    "PressureKpa" -> PressureKpa,
    "OutsideTestedDiameterRange" -> ! (970 <= centroidalDiameterMm <= 1575),
    "OutsideTestedFrictionRange" -> ! (28 <= frictionAngleDeg <= 36),
    "WithinMarginalRanges" -> Within,
    "MatchesPublishedTableConfiguration" -> Matches,
    "CalibrationStatus" -> If[
      Matches,
      "published Table 5.5 configuration",
      "interpolation or extrapolation; not a published tested configuration"
    ],
    "CalibrationSoils" -> {"No. 57 stone", "silty sand"},
    "AngularTractionAvailable" -> False,
    "MomentSupported" -> False,
    "ShearSupported" -> False
  |>
];

fhwa1999PrismLoad[
  unitWeight_,
  outsideDiameter_,
  coverCrown_,
  verticalArchingFactor_,
  verticalArchingFactorSource_,
  applicability_
] := ringCatch @ Module[{SoilPrismLoad, PipeLoad},
  ringRequire[
    finiteRealQ[unitWeight] && unitWeight >= 0 &&
      finiteRealQ[outsideDiameter] && outsideDiameter > 0 &&
      finiteRealQ[coverCrown] && coverCrown >= 0 &&
      finiteRealQ[verticalArchingFactor] && verticalArchingFactor > 0,
    "InvalidFHWAPrismInput",
    "FHWA prism inputs must be finite; diameter and VAF must be positive."
  ];
  ringRequire[
    nonEmptyStringQ[verticalArchingFactorSource] && nonEmptyStringQ[applicability],
    "InvalidSource",
    "VAF source and applicability must be non-empty."
  ];
  SoilPrismLoad = unitWeight outsideDiameter (
    coverCrown + 0.11 outsideDiameter
  );
  PipeLoad = verticalArchingFactor SoilPrismLoad;
  <|
    "Type" -> "FHWA1999PrismLoad",
    "Source" -> "FHWA-RD-98-191 (1999)",
    "SourceLocation" -> "Eqs. 2.1-2.3, printed p. 12/PDF 28",
    "Representation" -> "global prism load and springline thrust",
    "SoilPrismLoad" -> SoilPrismLoad,
    "PipeLoad" -> PipeLoad,
    "SpringlineThrust" -> PipeLoad/2,
    "VerticalArchingFactor" -> verticalArchingFactor,
    "VerticalArchingFactorSource" -> verticalArchingFactorSource,
    "Applicability" -> applicability,
    "AngularTractionAvailable" -> False,
    "MomentSupported" -> False,
    "ShearSupported" -> False
  |>
];

Options[fhwa1999CompactionStageSpectrum] = {
  "BandDepthM" -> 0.300,
  "AngleCount" -> Automatic
};

fhwa1999CompactionStageSpectrum[
  compactionPressure_,
  radiusM_,
  liftSurfaceZM_,
  maxMode_,
  OptionsPattern[]
] := ringCatch @ Module[
  {
    BandDepthM, AngleCount, ExpectedDiameterMm, DiameterError, Theta,
    X, Z, BoundaryTolerance, Active, Side, HorizontalTraction,
    RadialOutward, TangentialPositive, Spectrum
  },
  BandDepthM = OptionValue["BandDepthM"];
  AngleCount = OptionValue["AngleCount"];
  ringRequire[
    AssociationQ[compactionPressure] &&
      Lookup[compactionPressure, "Type", Missing["Unknown"]] ==
        "FHWA1999CompactionPressure",
    "InvalidFHWACompaction",
    "compactionPressure must be returned by fhwa1999CompactionPressure."
  ];
  ringRequire[
    finiteRealQ[radiusM] && radiusM > 0 && finiteRealQ[liftSurfaceZM],
    "InvalidGeometry",
    "radiusM must be positive and liftSurfaceZM finite."
  ];
  ringRequire[
    IntegerQ[maxMode] && maxMode >= 2,
    "InvalidMode",
    "maxMode must be an integer of at least two."
  ];
  ringRequire[
    finiteRealQ[BandDepthM] && Abs[BandDepthM - 0.300] <= 1.*^-12,
    "InvalidBandDepth",
    "The audited FHWA construction-stage adapter requires BandDepthM = 0.300 m."
  ];
  ExpectedDiameterMm = 2 radiusM 1000;
  DiameterError = Abs[
    compactionPressure["CentroidalDiameterMm"] - ExpectedDiameterMm
  ];
  ringRequire[
    DiameterError <= 1.*^-8 Max[ExpectedDiameterMm, 1.],
    "DiameterMismatch",
    "radiusM and the centroidal diameter used in FHWA Eq. 5.1 are inconsistent."
  ];
  If[
    AngleCount === Automatic,
    AngleCount = Max[4096, 32 (maxMode + 1)],
    ringRequire[
      IntegerQ[AngleCount] && AngleCount >= 2 maxMode + 1,
      "AliasedGrid",
      "AngleCount must be an integer of at least 2 maxMode + 1."
    ]
  ];
  Theta = N[Range[0, AngleCount - 1] 2 Pi/AngleCount];
  X = radiusM Sin[Theta];
  Z = -radiusM Cos[Theta];
  BoundaryTolerance = 100 $MachineEpsilon Max[
    radiusM,
    Abs[liftSurfaceZM],
    BandDepthM,
    1.*^-300
  ];
  Active = Map[
    Boole[liftSurfaceZM - BoundaryTolerance <= # <=
      liftSurfaceZM + BandDepthM + BoundaryTolerance] &,
    Z
  ];
  Side = Map[If[Abs[#] <= BoundaryTolerance, 0., Sign[#]] &, X];
  HorizontalTraction = -compactionPressure["PressureKpa"] Side Active;
  RadialOutward = HorizontalTraction Sin[Theta];
  TangentialPositive = HorizontalTraction Cos[Theta];
  Spectrum = ringEnsure[fitRingSpectrum[
    Theta,
    RadialOutward,
    TangentialPositive,
    maxMode
  ]];
  withRingMetadata[
    Spectrum,
    <|
      "Source" -> compactionPressure["Source"],
      "SourceLocation" -> "Eq. 5.1 and construction stage, printed pp. 173-178/PDF 188-193",
      "Representation" -> "derived horizontal stage band",
      "PublishedAngularTraction" -> False,
      "LiftSurfaceZM" -> liftSurfaceZM,
      "BandDepthM" -> BandDepthM,
      "PublishedBandDepthM" -> 0.300,
      "UsesPublishedBandDepth" -> True,
      "BandIntersectsRing" -> AnyTrue[Active, # == 1 &],
      "ResidualFinalPressureAvailable" -> False,
      "WithinMarginalRanges" -> compactionPressure["WithinMarginalRanges"],
      "MatchesPublishedTableConfiguration" ->
        compactionPressure["MatchesPublishedTableConfiguration"],
      "CalibrationStatus" -> compactionPressure["CalibrationStatus"]
    |>
  ]
];

nunez2014Resultants[
  diameter_,
  depthAxis_,
  unitWeight_,
  surfaceLoad_,
  k0_,
  eta_,
  interactionRatio_,
  interactionRatioSource_
] := ringCatch @ Module[
  {
    VerticalGeostatic, InteractionFraction, MomentMaximum,
    NormalSpringline, NormalCrown, NormalInvert
  },
  ringRequire[
    finiteRealQ[diameter] && diameter > 0 &&
      And @@ (finiteRealQ[#] && # >= 0 & /@
        {depthAxis, unitWeight, surfaceLoad, k0, interactionRatio}) &&
      finiteRealQ[eta] && 0 <= eta <= 1,
    "InvalidNunezInput",
    "Nunez inputs must be finite and non-negative; diameter is positive and eta lies in [0,1]."
  ];
  ringRequire[
    nonEmptyStringQ[interactionRatioSource],
    "InvalidSource",
    "interactionRatioSource must be non-empty."
  ];
  VerticalGeostatic = unitWeight depthAxis + surfaceLoad;
  InteractionFraction = interactionRatio/(1 + interactionRatio);
  MomentMaximum = eta (1 - k0) VerticalGeostatic diameter^2/16 *
    InteractionFraction;
  NormalSpringline = eta diameter VerticalGeostatic/2;
  NormalCrown = eta diameter VerticalGeostatic/2 (
    k0 + (2/3) (1 - k0)/(1 + interactionRatio)
  ) - k0 unitWeight diameter^2/12;
  NormalInvert = eta diameter VerticalGeostatic/2 (
    k0 + (4/3) (1 - k0)/(1 + interactionRatio)
  ) + k0 unitWeight diameter^2/12;
  <|
    "Type" -> "Nunez2014Resultants",
    "Source" -> "Nunez, Sfriso and Laiun (2014)",
    "SourceLocation" -> "Eqs. 22-25, PDF p. 6",
    "Domain" -> "excavated tunnel with shotcrete support",
    "OutOfDomainForBackfilledPipe" -> True,
    "GeometryOutsideBuriedDomain" -> depthAxis < diameter/2,
    "Representation" -> "published point resultants",
    "NormalResultantSignConvention" -> "compression positive in source",
    "SolverNormalConversion" -> "N_solver = -N_source",
    "MomentSignConvention" -> "positive at crown and negative at springline per 2014",
    "InteractionRatioSource" -> interactionRatioSource,
    "VerticalGeostatic" -> VerticalGeostatic,
    "MomentCrown" -> MomentMaximum,
    "MomentSpringline" -> -MomentMaximum,
    "MomentInvert" -> Missing["Unknown"],
    "NormalCrown" -> NormalCrown,
    "NormalSpringline" -> NormalSpringline,
    "NormalInvert" -> NormalInvert,
    "Shear" -> Missing["Unknown"],
    "AngularTractionAvailable" -> False
  |>
];

nunez2000CircularResultants[
  diameter_,
  depthAxis_,
  thickness_,
  unitWeight_,
  surfaceLoad_,
  waterUnitWeight_,
  waterHead_,
  k0_,
  eta_,
  chi_,
  planeModulusRatio_,
  planeModulusRatioSource_
] := ringCatch @ Module[
  {
    Geostatic, WaterPressure, ReducedVertical, InteractionRatio,
    InteractionFraction, HorizontalReaction, Moment, NormalCrown,
    NormalSpringline
  },
  ringRequire[
    finiteRealQ[diameter] && diameter > 0 &&
      finiteRealQ[thickness] && thickness > 0 &&
      finiteRealQ[chi] && chi > 0 &&
      finiteRealQ[planeModulusRatio] && planeModulusRatio > 0 &&
      And @@ (finiteRealQ[#] && # >= 0 & /@
        {depthAxis, unitWeight, surfaceLoad, waterUnitWeight, waterHead, k0}) &&
      finiteRealQ[eta] && 0 <= eta <= 1,
    "InvalidNunezInput",
    "Nunez inputs violate positivity or eta-domain requirements."
  ];
  ringRequire[
    nonEmptyStringQ[planeModulusRatioSource],
    "InvalidSource",
    "planeModulusRatioSource must be non-empty."
  ];
  Geostatic = unitWeight depthAxis + surfaceLoad;
  WaterPressure = waterUnitWeight waterHead;
  ReducedVertical = eta (1 - k0) Geostatic;
  InteractionRatio = 16/chi planeModulusRatio (thickness/diameter)^3;
  InteractionFraction = InteractionRatio/(1 + InteractionRatio);
  HorizontalReaction = ReducedVertical/(1 + InteractionRatio);
  Moment = ReducedVertical diameter^2 InteractionFraction/16;
  NormalCrown = diameter/2 (
    k0 ReducedVertical + HorizontalReaction + WaterPressure
  );
  NormalSpringline = diameter/2 (Geostatic + WaterPressure);
  <|
    "Type" -> "Nunez2000CircularResultants",
    "Source" -> "Nunez (2000)",
    "SourceLocation" -> "circular specialization, PDF pp. 13-15",
    "Domain" -> "excavated tunnel with shotcrete support",
    "OutOfDomainForBackfilledPipe" -> True,
    "GeometryOutsideBuriedDomain" -> depthAxis < diameter/2,
    "Representation" -> "published circular point resultants",
    "NormalResultantSignConvention" -> "compression positive in source",
    "SolverNormalConversion" -> "N_solver = -N_source",
    "MomentSignConvention" -> "published 2000 values are magnitudes; algebraic sign is UNKNOWN",
    "PlaneModulusRatioSource" -> planeModulusRatioSource,
    "InteractionRatio" -> InteractionRatio,
    "InteractionFraction" -> InteractionFraction,
    "ReducedVerticalPressure" -> ReducedVertical,
    "HorizontalReaction" -> HorizontalReaction,
    "MomentCrown" -> Moment,
    "MomentSpringline" -> Missing["Unknown"],
    "MomentCrownMagnitude" -> Moment,
    "MomentSpringlineMagnitude" -> Moment,
    "NormalCrown" -> NormalCrown,
    "NormalSpringline" -> NormalSpringline,
    "NormalInvert" -> Missing["Unknown"],
    "Shear" -> Missing["Unknown"],
    "AngularTractionAvailable" -> False
  |>
];

nunez2014SymmetricProjection[
  diameter_,
  depthAxis_,
  unitWeight_,
  surfaceLoad_,
  k0_,
  eta_,
  interactionRatio_,
  interactionRatioSource_
] := ringCatch @ Module[
  {
    Published, Vertical, HorizontalEquivalent, Difference, MeanPressure,
    Spectrum, CrownInvertResidual
  },
  Published = ringEnsure[nunez2014Resultants[
    diameter,
    depthAxis,
    unitWeight,
    surfaceLoad,
    k0,
    eta,
    interactionRatio,
    interactionRatioSource
  ]];
  Vertical = eta Published["VerticalGeostatic"];
  HorizontalEquivalent = eta Published["VerticalGeostatic"] (
    k0 + (1 - k0)/(1 + interactionRatio)
  );
  Difference = Vertical - HorizontalEquivalent;
  MeanPressure = (Vertical + HorizontalEquivalent)/2;
  Spectrum = ringEnsure[newRingSpectrum[2]];
  Spectrum = ringEnsure[setRingCoefficient[
    Spectrum,
    "RadialCos",
    0,
    -MeanPressure
  ]];
  Spectrum = ringEnsure[setRingCoefficient[
    Spectrum,
    "RadialCos",
    2,
    -Difference/2
  ]];
  Spectrum = ringEnsure[setRingCoefficient[
    Spectrum,
    "TangentialSin",
    2,
    Difference/2
  ]];
  Spectrum = withRingMetadata[
    Spectrum,
    <|
      "Source" -> "derived projection of Nunez 2014 Eqs. 9-10 and 18-25",
      "Representation" -> "Nunez 2014 symmetric n=0+n=2 projection",
      "AngularTractionAvailable" -> True,
      "PublishedByNunez" -> False
    |>
  ];
  CrownInvertResidual = (Published["NormalInvert"] - Published["NormalCrown"])/2;
  <|
    "Type" -> "Nunez2014SymmetricProjection",
    "Spectrum" -> Spectrum,
    "PublishedResultants" -> Published,
    "CrownInvertResidual" -> CrownInvertResidual,
    "ProjectionChecks" -> {
      <|"Check" -> "M_crown", "TargetSourceConvention" -> Published["MomentCrown"]|>,
      <|"Check" -> "N_springline", "TargetSourceConvention" -> Published["NormalSpringline"]|>,
      <|
        "Check" -> "mean_N_crown_invert",
        "TargetSourceConvention" ->
          Mean[{Published["NormalCrown"], Published["NormalInvert"]}]
      |>
    },
    "Source" -> Published["Source"],
    "Representation" -> "derived symmetric projection",
    "OutOfDomainForBackfilledPipe" -> True
  |>
];

(* Monte Carlo orchestration. No engineering priors or correlations are
   introduced by these helpers. Wolfram-native RNG sequences intentionally
   differ from R; deterministic mechanics are benchmarked separately. *)

fixedParameter[value_] := <|"Distribution" -> "Fixed", "Value" -> value|>;
uniformParameter[minimum_, maximum_] := <|
  "Distribution" -> "Uniform",
  "Minimum" -> minimum,
  "Maximum" -> maximum
|>;
normalParameter[mean_, standardDeviation_] := <|
  "Distribution" -> "Normal",
  "Mean" -> mean,
  "StandardDeviation" -> standardDeviation
|>;
lognormalParameter[meanlog_, sdlog_] := <|
  "Distribution" -> "Lognormal",
  "Meanlog" -> meanlog,
  "Sdlog" -> sdlog
|>;
triangularParameter[minimum_, mode_, maximum_] := <|
  "Distribution" -> "Triangular",
  "Minimum" -> minimum,
  "Mode" -> mode,
  "Maximum" -> maximum
|>;
discreteParameter[values_, probabilities_] := <|
  "Distribution" -> "Discrete",
  "Values" -> values,
  "Probabilities" -> probabilities
|>;

sampleIndependentParameters[
  specification_,
  sampleCount_,
  seed_,
  independenceConfirmed_
] := ringCatch @ Module[
  {Names, sampleOne, Columns},
  ringRequire[
    AssociationQ[specification] && Length[specification] > 0,
    "InvalidSpecification",
    "specification must be a non-empty Association."
  ];
  ringRequire[
    IntegerQ[sampleCount] && sampleCount >= 1 && IntegerQ[seed] && seed >= 0,
    "InvalidSamplingControl",
    "sampleCount must be positive and seed a non-negative integer."
  ];
  ringRequire[
    TrueQ[independenceConfirmed],
    "UnconfirmedIndependence",
    "Set independenceConfirmed to True only after documenting independence; otherwise construct correlated draws externally."
  ];
  Names = Keys[specification];
  sampleOne[Parameter_, Name_] := Module[
    {Distribution, Minimum, Mode, Maximum, Uniform, BreakPoint, Values, Probabilities},
    ringRequire[
      AssociationQ[Parameter] && KeyExistsQ[Parameter, "Distribution"],
      "InvalidParameter",
      "Each parameter needs a Distribution declaration.",
      <|"Parameter" -> Name|>
    ];
    Distribution = Parameter["Distribution"];
    Switch[
      Distribution,
      "Fixed",
        ringRequire[finiteRealQ[Parameter["Value"]], "InvalidParameter", "Fixed value must be finite."];
        ConstantArray[Parameter["Value"], sampleCount],
      "Uniform",
        Minimum = Parameter["Minimum"];
        Maximum = Parameter["Maximum"];
        ringRequire[
          finiteRealQ[Minimum] && finiteRealQ[Maximum] && Maximum > Minimum,
          "InvalidParameter",
          "Uniform parameters require finite Minimum < Maximum."
        ];
        RandomReal[{Minimum, Maximum}, sampleCount],
      "Normal",
        ringRequire[
          finiteRealQ[Parameter["Mean"]] &&
            finiteRealQ[Parameter["StandardDeviation"]] &&
            Parameter["StandardDeviation"] > 0,
          "InvalidParameter",
          "Normal parameters require finite mean and positive standard deviation."
        ];
        RandomVariate[
          NormalDistribution[Parameter["Mean"], Parameter["StandardDeviation"]],
          sampleCount
        ],
      "Lognormal",
        ringRequire[
          finiteRealQ[Parameter["Meanlog"]] && finiteRealQ[Parameter["Sdlog"]] &&
            Parameter["Sdlog"] > 0,
          "InvalidParameter",
          "Lognormal parameters require finite meanlog and positive sdlog."
        ];
        RandomVariate[
          LogNormalDistribution[Parameter["Meanlog"], Parameter["Sdlog"]],
          sampleCount
        ],
      "Triangular",
        Minimum = Parameter["Minimum"];
        Mode = Parameter["Mode"];
        Maximum = Parameter["Maximum"];
        ringRequire[
          And @@ (finiteRealQ /@ {Minimum, Mode, Maximum}) &&
            Minimum <= Mode <= Maximum && Minimum < Maximum,
          "InvalidParameter",
          "Triangular parameters require Minimum <= Mode <= Maximum and Minimum < Maximum."
        ];
        Uniform = RandomReal[{0, 1}, sampleCount];
        BreakPoint = (Mode - Minimum)/(Maximum - Minimum);
        Map[
          If[
            # <= BreakPoint,
            Minimum + Sqrt[# (Maximum - Minimum) (Mode - Minimum)],
            Maximum - Sqrt[(1 - #) (Maximum - Minimum) (Maximum - Mode)]
          ] &,
          Uniform
        ],
      "Discrete",
        Values = Parameter["Values"];
        Probabilities = Parameter["Probabilities"];
        ringRequire[
          ListQ[Values] && Length[Values] > 0 && AllTrue[Values, finiteRealQ] &&
            ListQ[Probabilities] && Length[Probabilities] == Length[Values] &&
            AllTrue[Probabilities, finiteRealQ[#] && # >= 0 &] &&
            Total[Probabilities] > 0,
          "InvalidParameter",
          "Discrete values and probabilities are invalid."
        ];
        RandomChoice[(Probabilities/Total[Probabilities]) -> Values, sampleCount],
      _,
        ringFail[
          "InvalidDistribution",
          "Unsupported distribution declaration.",
          <|"Parameter" -> Name, "Distribution" -> Distribution|>
        ]
    ]
  ];
  Columns = BlockRandom[
    SeedRandom[seed, Method -> "MersenneTwister"];
    MapThread[sampleOne, {Values[specification], Names}]
  ];
  Map[
    AssociationThread[Names, #] &,
    Transpose[Columns]
  ]
];

quantileType7[values_, probability_] := ringCatch @ Module[
  {Sorted, Count, h, j, Fraction},
  ringRequire[
    ListQ[values] && Length[values] > 0 && AllTrue[values, finiteRealQ],
    "InvalidQuantileData",
    "quantile data must be a non-empty finite real list."
  ];
  ringRequire[
    finiteRealQ[probability] && 0 <= probability <= 1,
    "InvalidProbability",
    "probability must lie in [0,1]."
  ];
  Sorted = Sort[N[values]];
  Count = Length[Sorted];
  If[Count == 1, Return[First[Sorted]]];
  h = (Count - 1) probability + 1;
  j = Floor[h];
  Fraction = h - j;
  If[
    j >= Count,
    Last[Sorted],
    Sorted[[j]] + Fraction (Sorted[[j + 1]] - Sorted[[j]])
  ]
];

Options[runRingMonteCarlo] = {
  "ExtremaScanPoints" -> Automatic,
  "KeepSampleCurves" -> False
};

runRingMonteCarlo[
  draws_,
  scenarioFunction_,
  theta_,
  probabilities_,
  modelLabel_,
  OptionsPattern[]
] := ringCatch @ Module[
  {
    ExtremaScanPoints, KeepSampleCurves, Probabilities, SampleCount,
    AngleCount, NormalCurves, MomentCurves, ShearCurves, ExtremaSamples,
    ScenarioMetadata, LoadSpectra, ResponseSpectra, ExpectedSupported,
    Draw, Scenario, Spectrum, Radius, Thickness, UniformMoment,
    Response, Values, Supported, Summary, PointwiseRows, Curves,
    ExtremaQuantiles, Group, GroupValues, OUT
  },
  ExtremaScanPoints = OptionValue["ExtremaScanPoints"];
  KeepSampleCurves = OptionValue["KeepSampleCurves"];
  ringRequire[
    ListQ[draws] && Length[draws] > 0 && AllTrue[draws, AssociationQ],
    "InvalidDraws",
    "draws must be a non-empty list of Associations."
  ];
  ringRequire[
    Head[scenarioFunction] === Function ||
      MatchQ[scenarioFunction, _Symbol],
    "InvalidScenarioFunction",
    "scenarioFunction must be callable."
  ];
  ringRequire[
    ListQ[theta] && Length[theta] >= 3 && AllTrue[theta, finiteRealQ] &&
      And @@ Thread[Differences[N[theta]] > 0] &&
      Min[theta] >= 0 && Max[theta] < 2 Pi,
    "InvalidAngle",
    "theta must be strictly increasing on [0, 2 Pi) with at least three points."
  ];
  ringRequire[
    ListQ[probabilities] && Length[probabilities] > 0 &&
      AllTrue[probabilities, finiteRealQ[#] && 0 <= # <= 1 &],
    "InvalidProbability",
    "probabilities must be a non-empty list in [0,1]."
  ];
  ringRequire[
    nonEmptyStringQ[modelLabel] && BooleanQ[KeepSampleCurves],
    "InvalidMonteCarloControl",
    "modelLabel must be non-empty and KeepSampleCurves Boolean."
  ];
  Probabilities = Sort[DeleteDuplicates[N[probabilities]]];
  SampleCount = Length[draws];
  AngleCount = Length[theta];
  NormalCurves = ConstantArray[Missing["NotSupported"], {SampleCount, AngleCount}];
  MomentCurves = ConstantArray[Missing["NotSupported"], {SampleCount, AngleCount}];
  ShearCurves = ConstantArray[Missing["NotSupported"], {SampleCount, AngleCount}];
  ExtremaSamples = {};
  ScenarioMetadata = ConstantArray[<||>, SampleCount];
  LoadSpectra = ConstantArray[Missing["NotKept"], SampleCount];
  ResponseSpectra = ConstantArray[Missing["NotKept"], SampleCount];
  ExpectedSupported = Missing["Unset"];
  Do[
    Draw = draws[[i]];
    Scenario = scenarioFunction[Draw];
    ringRequire[
      AssociationQ[Scenario] && KeyExistsQ[Scenario, "Spectrum"] &&
        KeyExistsQ[Scenario, "Radius"],
      "InvalidScenario",
      "scenarioFunction must return Spectrum and Radius.",
      <|"SampleID" -> i|>
    ];
    Spectrum = ringEnsure[validateRingSpectrum[Scenario["Spectrum"]]];
    Radius = Scenario["Radius"];
    Thickness = Lookup[Scenario, "Thickness", Missing["NotSpecified"]];
    UniformMoment = Lookup[Scenario, "UniformMoment", "Membrane"];
    Response = ringEnsure[solveRingSpectrum[
      Spectrum,
      Radius,
      "Thickness" -> Thickness,
      "UniformMoment" -> UniformMoment
    ]];
    Supported = Lookup[Scenario, "SupportedResultants", {"N", "M", "Q"}];
    ringRequire[
      ListQ[Supported] && DuplicateFreeQ[Supported] &&
        AllTrue[Supported, MemberQ[{"N", "M", "Q"}, #] &],
      "InvalidSupportedResultants",
      "SupportedResultants must contain unique values drawn from N, M, Q."
    ];
    If[
      ! TrueQ[Lookup[ringMetadata[Response], "MomentSupported", True]],
      Supported = DeleteCases[Supported, "M"]
    ];
    If[
      ! TrueQ[Lookup[ringMetadata[Response], "ShearSupported", True]],
      Supported = DeleteCases[Supported, "Q"]
    ];
    Supported = Select[{"N", "M", "Q"}, MemberQ[Supported, #] &];
    If[
      MissingQ[ExpectedSupported],
      ExpectedSupported = Supported,
      ringRequire[
        Supported === ExpectedSupported,
        "ChangingSupportedResultants",
        "SupportedResultants must remain constant within one model branch."
      ]
    ];
    Values = ringEnsure[evaluateRingResponse[Response, theta]];
    If[MemberQ[Supported, "N"], NormalCurves[[i]] = Values["NormalForce"]];
    If[MemberQ[Supported, "M"], MomentCurves[[i]] = Values["BendingMoment"]];
    If[MemberQ[Supported, "Q"], ShearCurves[[i]] = Values["ShearForce"]];
    Summary = ringEnsure[summarizeRingResponse[
      Response,
      "ScanPoints" -> ExtremaScanPoints
    ]];
    Summary = Map[
      If[
        MemberQ[Supported, #["Resultant"]],
        #,
        Join[
          #,
          <|
            "Value" -> Missing["NotSupported"],
            "Theta" -> Missing["NotSupported"],
            "ThetaDeg" -> Missing["NotSupported"]
          |>
        ]
      ] &,
      Summary
    ];
    Summary = Map[
      Join[
        #,
        <|
          "Model" -> modelLabel,
          "SampleID" -> i
        |>
      ] &,
      Summary
    ];
    ExtremaSamples = Join[ExtremaSamples, Summary];
    ScenarioMetadata[[i]] = Lookup[Scenario, "Metadata", <||>];
    If[
      KeepSampleCurves,
      LoadSpectra[[i]] = Spectrum;
      ResponseSpectra[[i]] = Response
    ],
    {i, SampleCount}
  ];
  Curves = <|
    "N" -> NormalCurves,
    "M" -> MomentCurves,
    "Q" -> ShearCurves
  |>;
  PointwiseRows = Flatten @ Table[
    Table[
      <|
        "Model" -> modelLabel,
        "Theta" -> theta[[j]],
        "ThetaDeg" -> theta[[j]] 180/Pi,
        "Resultant" -> Resultant,
        "Probability" -> Probability,
        "Value" -> If[
          MemberQ[ExpectedSupported, Resultant],
          ringEnsure[quantileType7[Curves[Resultant][[All, j]], Probability]],
          Missing["NotSupported"]
        ]
      |>,
      {j, AngleCount}
    ],
    {Resultant, {"N", "M", "Q"}},
    {Probability, Probabilities}
  ];
  ExtremaQuantiles = Flatten @ Table[
    Group = Select[
      ExtremaSamples,
      #["Resultant"] == Resultant && #["Statistic"] == Statistic &
    ];
    GroupValues = Lookup[Group, "Value"];
    Table[
      <|
        "Model" -> modelLabel,
        "Resultant" -> Resultant,
        "Statistic" -> Statistic,
        "Probability" -> Probability,
        "Value" -> If[
          MemberQ[ExpectedSupported, Resultant],
          ringEnsure[quantileType7[GroupValues, Probability]],
          Missing["NotSupported"]
        ]
      |>,
      {Probability, Probabilities}
    ],
    {Resultant, {"N", "M", "Q"}},
    {Statistic, {"Minimum", "Maximum", "AbsoluteMaximum"}}
  ];
  OUT = <|
    "Type" -> "RingMonteCarlo",
    "Model" -> modelLabel,
    "SampleCount" -> SampleCount,
    "Theta" -> theta,
    "Probabilities" -> Probabilities,
    "QuantileMethod" -> "Hyndman-Fan type 7",
    "SupportedResultants" -> ExpectedSupported,
    "PointwiseQuantiles" -> PointwiseRows,
    "ExtremaSamples" -> ExtremaSamples,
    "ExtremaQuantiles" -> ExtremaQuantiles,
    "Draws" -> draws,
    "ScenarioMetadata" -> ScenarioMetadata
  |>;
  If[
    KeepSampleCurves,
    OUT = Join[
      OUT,
      <|
        "SampleCurves" -> Curves,
        "LoadSpectra" -> LoadSpectra,
        "ResponseSpectra" -> ResponseSpectra
      |>
    ]
  ];
  OUT
];

Options[runRingStageMonteCarlo] = {
  "ExtremaScanPoints" -> Automatic,
  "KeepSampleEnvelopes" -> False
};

runRingStageMonteCarlo[
  draws_,
  stageScenarioFunction_,
  theta_,
  probabilities_,
  modelLabel_,
  OptionsPattern[]
] := ringCatch @ Module[
  {
    ExtremaScanPoints, KeepSampleEnvelopes, AllStages, StageNames,
    IndexedDraws, InternalKey, StageResults, Probabilities, SampleCount,
    AngleCount, Resultants, Supported, SampleEnvelopes, PointwiseRows,
    StageCube, Lower, Upper, EnvelopeValues, StageExtrema, ExtremaSamples,
    Membership, Candidates, Metric, ExtremeMetric, TieTolerance, Tied,
    Selected, ThetaValues, ThetaSpread, ExtremaQuantiles, Group,
    GroupValues, Counts, OUT
  },
  ExtremaScanPoints = OptionValue["ExtremaScanPoints"];
  KeepSampleEnvelopes = OptionValue["KeepSampleEnvelopes"];
  ringRequire[
    ListQ[draws] && Length[draws] > 0 && AllTrue[draws, AssociationQ],
    "InvalidDraws",
    "draws must be a non-empty list of Associations."
  ];
  ringRequire[
    nonEmptyStringQ[modelLabel] && BooleanQ[KeepSampleEnvelopes],
    "InvalidMonteCarloControl",
    "modelLabel must be non-empty and KeepSampleEnvelopes Boolean."
  ];
  AllStages = Map[stageScenarioFunction, draws];
  ringRequire[
    AllTrue[AllStages, AssociationQ[#] && Length[#] > 0 &],
    "InvalidStages",
    "stageScenarioFunction must return a non-empty Association of scenarios."
  ];
  StageNames = Keys[First[AllStages]];
  ringRequire[
    AllTrue[StageNames, nonEmptyStringQ] && DuplicateFreeQ[StageNames] &&
      AllTrue[AllStages, Keys[#] === StageNames &],
    "ChangingStages",
    "Every sample must return the same ordered, non-empty, unique stage names."
  ];
  SampleCount = Length[draws];
  InternalKey = "RingStageSampleID";
  While[AnyTrue[draws, KeyExistsQ[#, InternalKey] &], InternalKey = InternalKey <> "X"];
  IndexedDraws = MapIndexed[Append[#1, InternalKey -> First[#2]] &, draws];
  StageResults = AssociationMap[
    Function[StageName,
      ringEnsure[runRingMonteCarlo[
        IndexedDraws,
        Function[Draw, AllStages[[Draw[InternalKey]]][StageName]],
        theta,
        probabilities,
        modelLabel <> "::" <> StageName,
        "ExtremaScanPoints" -> ExtremaScanPoints,
        "KeepSampleCurves" -> True
      ]]
    ],
    StageNames
  ];
  Probabilities = First[Values[StageResults]]["Probabilities"];
  AngleCount = Length[theta];
  Resultants = {"N", "M", "Q"};
  Supported = Select[
    Resultants,
    Function[Resultant,
      AllTrue[
        Values[StageResults],
        MemberQ[#["SupportedResultants"], Resultant] &
      ]
    ]
  ];
  SampleEnvelopes = <||>;
  PointwiseRows = {};
  Do[
    StageCube = Lookup[Lookup[Values[StageResults], "SampleCurves"], Resultant];
    If[
      MemberQ[Supported, Resultant],
      Lower = Table[
        Min[StageCube[[All, i, j]]],
        {i, SampleCount},
        {j, AngleCount}
      ];
      Upper = Table[
        Max[StageCube[[All, i, j]]],
        {i, SampleCount},
        {j, AngleCount}
      ],
      Lower = Upper = ConstantArray[
        Missing["NotSupported"],
        {SampleCount, AngleCount}
      ]
    ];
    AssociateTo[
      SampleEnvelopes,
      Resultant -> <|"Minimum" -> Lower, "Maximum" -> Upper|>
    ];
    Do[
      EnvelopeValues = If[Bound == "Minimum", Lower, Upper];
      PointwiseRows = Join[
        PointwiseRows,
        Table[
          <|
            "Model" -> modelLabel,
            "Bound" -> Bound,
            "Theta" -> theta[[j]],
            "ThetaDeg" -> theta[[j]] 180/Pi,
            "Resultant" -> Resultant,
            "Probability" -> Probability,
            "Value" -> If[
              MemberQ[Supported, Resultant],
              ringEnsure[quantileType7[EnvelopeValues[[All, j]], Probability]],
              Missing["NotSupported"]
            ]
          |>,
          {j, AngleCount}
        ]
      ],
      {Bound, {"Minimum", "Maximum"}},
      {Probability, Probabilities}
    ],
    {Resultant, Resultants}
  ];
  StageExtrema = Flatten @ Map[
    Function[StageName,
      Map[Append[#, "Stage" -> StageName] &, StageResults[StageName]["ExtremaSamples"]]
    ],
    StageNames
  ];
  ExtremaSamples = {};
  Membership = {};
  Do[
    Candidates = Select[
      StageExtrema,
      #["SampleID"] == i && #["Resultant"] == Resultant &&
        #["Statistic"] == Statistic &
    ];
    If[
      ! MemberQ[Supported, Resultant],
      Selected = <|
        "Model" -> modelLabel,
        "SampleID" -> i,
        "Resultant" -> Resultant,
        "Statistic" -> Statistic,
        "Value" -> Missing["NotSupported"],
        "Theta" -> Missing["NotSupported"],
        "ThetaDeg" -> Missing["NotSupported"],
        "Stage" -> Missing["NotSupported"],
        "StageStatus" -> "Unsupported",
        "ControllingStages" -> {},
        "CoControllingStageCount" -> 0,
        "ScanPoints" -> First[Lookup[Candidates, "ScanPoints"]]
      |>,
      Metric = If[
        Statistic == "AbsoluteMaximum",
        Abs[Lookup[Candidates, "Value"]],
        Lookup[Candidates, "Value"]
      ];
      ExtremeMetric = If[Statistic == "Minimum", Min[Metric], Max[Metric]];
      TieTolerance = 64 $MachineEpsilon Max[Max[Abs[Metric]], 1.];
      Tied = Pick[
        Candidates,
        Map[# <= TieTolerance &, Abs[Metric - ExtremeMetric]]
      ];
      Selected = First[Tied];
      Selected = Join[
        Selected,
        <|
          "Model" -> modelLabel,
          "Stage" -> If[Length[Tied] == 1, First[Tied]["Stage"], Missing["Tie"]],
          "StageStatus" -> If[Length[Tied] == 1, "Unique", "Tie"],
          "ControllingStages" -> Lookup[Tied, "Stage"],
          "CoControllingStageCount" -> Length[Tied]
        |>
      ];
      If[
        Length[Tied] > 1,
        ThetaValues = Lookup[Tied, "Theta"];
        ThetaSpread = If[
          AllTrue[ThetaValues, finiteRealQ],
          Max[Abs[Arg[Exp[I (ThetaValues - First[ThetaValues])]]]],
          Infinity
        ];
        If[
          ! finiteRealQ[ThetaSpread] || ThetaSpread > 1.*^-12,
          Selected = Join[
            Selected,
            <|
              "Theta" -> Missing["Tie"],
              "ThetaDeg" -> Missing["Tie"]
            |>
          ]
        ]
      ];
      Membership = Join[
        Membership,
        Map[
          <|
            "SampleID" -> i,
            "Resultant" -> Resultant,
            "Statistic" -> Statistic,
            "Stage" -> #["Stage"]
          |> &,
          Tied
        ]
      ]
    ];
    AppendTo[ExtremaSamples, Selected],
    {i, SampleCount},
    {Resultant, Resultants},
    {Statistic, {"Minimum", "Maximum", "AbsoluteMaximum"}}
  ];
  ExtremaQuantiles = Flatten @ Table[
    Group = Select[
      ExtremaSamples,
      #["Resultant"] == Resultant && #["Statistic"] == Statistic &
    ];
    GroupValues = Lookup[Group, "Value"];
    Table[
      <|
        "Model" -> modelLabel,
        "Resultant" -> Resultant,
        "Statistic" -> Statistic,
        "Probability" -> Probability,
        "Value" -> If[
          MemberQ[Supported, Resultant],
          ringEnsure[quantileType7[GroupValues, Probability]],
          Missing["NotSupported"]
        ]
      |>,
      {Probability, Probabilities}
    ],
    {Resultant, Resultants},
    {Statistic, {"Minimum", "Maximum", "AbsoluteMaximum"}}
  ];
  Counts = Map[
    <|
      "Resultant" -> #[[1, 1]],
      "Statistic" -> #[[1, 2]],
      "Stage" -> #[[1, 3]],
      "Count" -> Length[#[[2]]]
    |> &,
    Normal @ GroupBy[
      Membership,
      {#["Resultant"], #["Statistic"], #["Stage"]} &
    ]
  ];
  OUT = <|
    "Type" -> "RingStageMonteCarlo",
    "Model" -> modelLabel,
    "SampleCount" -> SampleCount,
    "StageNames" -> StageNames,
    "Theta" -> theta,
    "Probabilities" -> Probabilities,
    "QuantileMethod" -> "Hyndman-Fan type 7",
    "SupportedResultants" -> Supported,
    "UnsupportedResultants" -> Complement[Resultants, Supported],
    "PointwiseStageEnvelopeQuantiles" -> PointwiseRows,
    "ExtremaSamples" -> ExtremaSamples,
    "ExtremaQuantiles" -> ExtremaQuantiles,
    "ControllingStageCounts" -> Counts,
    "ControllingStageCountMeaning" ->
      "Co-controlling count; each tied stage is counted once, so totals may exceed SampleCount.",
    "Draws" -> draws,
    "StageScenarioMetadata" -> AssociationMap[
      Lookup[StageResults[#], "ScenarioMetadata"] &,
      StageNames
    ]
  |>;
  If[
    KeepSampleEnvelopes,
    OUT = Join[
      OUT,
      <|
        "SampleStageEnvelopes" -> SampleEnvelopes,
        "StageSampleCurves" -> AssociationMap[
          StageResults[#]["SampleCurves"] &,
          StageNames
        ],
        "StageLoadSpectra" -> AssociationMap[
          StageResults[#]["LoadSpectra"] &,
          StageNames
        ],
        "StageResponseSpectra" -> AssociationMap[
          StageResults[#]["ResponseSpectra"] &,
          StageNames
        ]
      |>
    ]
  ];
  OUT
];

Options[runOutputMonteCarlo] = {"KeepSamples" -> True};

runOutputMonteCarlo[
  draws_,
  outputFunction_,
  probabilities_,
  modelLabel_,
  OptionsPattern[]
] := ringCatch @ Module[
  {KeepSamples, Probabilities, Outputs, OutputNames, Quantiles, OUT},
  KeepSamples = OptionValue["KeepSamples"];
  ringRequire[
    ListQ[draws] && Length[draws] > 0 && AllTrue[draws, AssociationQ],
    "InvalidDraws",
    "draws must be a non-empty list of Associations."
  ];
  ringRequire[
    ListQ[probabilities] && Length[probabilities] > 0 &&
      AllTrue[probabilities, finiteRealQ[#] && 0 <= # <= 1 &] &&
      nonEmptyStringQ[modelLabel] && BooleanQ[KeepSamples],
    "InvalidOutputMonteCarlo",
    "probabilities, modelLabel, or KeepSamples are invalid."
  ];
  Probabilities = Sort[DeleteDuplicates[N[probabilities]]];
  Outputs = Map[outputFunction, draws];
  ringRequire[
    AllTrue[Outputs, AssociationQ] &&
      AllTrue[Outputs, AllTrue[Values[#], finiteRealQ] &],
    "InvalidOutput",
    "outputFunction must return an Association of finite numeric outputs."
  ];
  OutputNames = Keys[First[Outputs]];
  ringRequire[
    AllTrue[Outputs, Keys[#] === OutputNames &],
    "ChangingOutputs",
    "outputFunction must return the same ordered names for every sample."
  ];
  Quantiles = Flatten @ Table[
    <|
      "Model" -> modelLabel,
      "Output" -> Name,
      "Probability" -> Probability,
      "Value" -> ringEnsure[quantileType7[Lookup[Outputs, Name], Probability]]
    |>,
    {Name, OutputNames},
    {Probability, Probabilities}
  ];
  OUT = <|
    "Type" -> "OutputMonteCarlo",
    "Model" -> modelLabel,
    "SampleCount" -> Length[draws],
    "Probabilities" -> Probabilities,
    "QuantileMethod" -> "Hyndman-Fan type 7",
    "Quantiles" -> Quantiles,
    "Draws" -> draws
  |>;
  If[KeepSamples, OUT = Join[OUT, <|"Samples" -> Outputs|>]];
  OUT
];
