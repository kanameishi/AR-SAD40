(* Evaluate every Input cell in 0.nb without a front end. *)

ClearAll[
  ScriptDir, TargetFile, SourceText, SourceParts, LoadMarker,
  MonteCarloMarker, TestText, ExpectedCode, NotebookExpression, InputCode,
  CellResults, PrototypeChecks
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
TestText = Import[
  FileNameJoin[{ScriptDir, "ringMethodologyTests.wl"}],
  "Text"
];
If[
  Length[SourceParts] =!= 3,
  Print["Unable to split ringMethodology.wl into notebook sections."];
  Exit[1]
];
ExpectedCode = {
  SourceParts[[1]],
  LoadMarker <> SourceParts[[2]],
  MonteCarloMarker <> SourceParts[[3]],
  TestText
};

If[
  ! FileExistsQ[TargetFile],
  Print["Notebook not found: ", TargetFile];
  Exit[1]
];

NotebookExpression = Quiet @ Check[Get[TargetFile], $Failed];
If[
  NotebookExpression === $Failed || Head[NotebookExpression] =!= Notebook,
  Print["Notebook expression is invalid: ", TargetFile];
  Exit[1]
];

InputCode = Cases[
  NotebookExpression,
  Cell[BoxData[Code_String], "Input", ___] :> Code,
  Infinity
];
If[
  Length[InputCode] =!= 14,
  Print["Expected fourteen Input cells; found ", Length[InputCode], "."];
  Exit[1]
];
If[
  Take[InputCode, 4] =!= ExpectedCode,
  Print["Notebook source cells do not match the current .wl sources."];
  Exit[1]
];

CellResults = Map[
  Function[Code, Check[ToExpression[Code, InputForm], $Failed]],
  InputCode
];
If[
  MemberQ[CellResults, $Failed],
  Print["At least one notebook Input cell failed to evaluate."];
  Exit[1]
];

PrototypeChecks = <|
  "UniformPressure" -> (
    Max[Abs[P1Values["NormalForce"] + P1Pressure P1Radius]] <= 1.*^-12 &&
      Max[Abs[P1Values["BendingMoment"]]] <= 1.*^-12 &&
      Max[Abs[P1Values["ShearForce"]]] <= 1.*^-12
  ),
  "AtRestK0" -> (
    AssociationQ[P2Spectrum] && AssociationQ[P2Response] &&
      AssociationQ[P2Values] && ListQ[P2Summary] && Length[P2Summary] == 9
  ),
  "PublishedAdapters" -> (
    Abs[P4UsaceService["ServiceThrust"] - 5400.] <= 1.*^-12 &&
      Abs[P4UsaceDesign["DesignThrust"] - 11583.] <= 1.*^-9 &&
      Abs[Round[P4FhwaPressure["PressureKpa"], 0.1] - 3.4] <= 1.*^-12 &&
      Abs[P4Nunez["MomentCrown"] - 1.2118] <= 5.*^-5
  ),
  "MonteCarlo" -> (
    AssociationQ[P3Result] && P3Result["SampleCount"] == P3SampleCount &&
      Length[P3NRows] == Length[P3Theta] Length[P3Probabilities] &&
      AllTrue[Lookup[P3NRows, "Value"], finiteRealQ]
  )
|>;
If[
  ! And @@ Values[PrototypeChecks],
  Print["At least one notebook prototype failed its output checks."];
  Print[InputForm @ Select[PrototypeChecks, ! TrueQ[#] &]];
  Exit[1]
];

If[
  ! AssociationQ[RingTestReport] || ! TrueQ[RingTestReport["Passed"]],
  Print["Notebook regression tests failed."];
  Print[InputForm[RingTestReport]];
  Exit[1]
];

Print[InputForm[KeyTake[
  RingTestReport,
  {"Passed", "TestCount", "FailedCount"}
]]];
Print["Notebook Input cells evaluated successfully: ", Length[InputCode], "."];
Print["Notebook prototype checks passed: ", Length[PrototypeChecks], "."];
Exit[0];
