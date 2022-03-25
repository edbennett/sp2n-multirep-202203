#!/usr/bin/env wolframscript

Needs["ErrorBarPlots`"];
Needs["PlotLegends`"];

<< MaTeX`

texStyle = {FontFamily -> "Times", FontSize -> 20};


(* b=6.5, mas=-1.01, mf=-0.71 *)

plaqT = Import[StringJoin[$ScriptCommandLine[[2]], "/plaquettes.txt"], "Table"]

(* Fundamental *)

llist = {8, 12, 16, 18, 20, 24, 28};

mfpsT = Import[StringJoin[$ScriptCommandLine[[2]], "/summary_mps_fun.txt"], "Table"];
ffpsT = Import[StringJoin[$ScriptCommandLine[[2]], "/summary_fps_fun.txt"], "Table"];
mvT = Import[StringJoin[$ScriptCommandLine[[2]], "/summary_mv_fun.txt"], "Table"];
mtT = Import[StringJoin[$ScriptCommandLine[[2]], "/summary_mt_fun.txt"], "Table"];
mavT = Import[StringJoin[$ScriptCommandLine[[2]], "/summary_mav_fun.txt"], "Table"];
matT = Import[StringJoin[$ScriptCommandLine[[2]], "/summary_mat_fun.txt"], "Table"];
msT = Import[StringJoin[$ScriptCommandLine[[2]], "/summary_ms_fun.txt"], "Table"];
mchT = Import[StringJoin[$ScriptCommandLine[[2]], "/summary_mch.txt"], "Table"];

(* Plots *)

(* FIGURE 17 lower right *)

plaqplot =
  ErrorListPlot[
   Table[{{mfpsT[[Length[mfpsT]]][[1]]*llist[[j]], plaqT[[j]][[1]]},
     ErrorBar[plaqT[[j]][[2]]]}, {j, 1, Length[llist]}], Frame -> True,
   PlotRange -> {{2, 10.5}, {0.585, 0.58585}}, AxesStyle -> Thick,
   PlotMarkers -> {"\[EmptySquare]", 15}, PlotStyle -> RGBColor[0, 0, 1],
   AxesStyle -> Black, FrameStyle -> Black,
   FrameLabel -> {MaTeX["m_{\\rm{PS}}^{f,\,\\rm{inf}}\,L",
      Magnification -> 2],
     MaTeX["\\langle \\mathcal{P} \\rangle", Magnification -> 2]},
   BaseStyle -> texStyle, ImageSize -> 600];

Export[StringJoin[$ScriptCommandLine[[3]], "/plaq.pdf"], plaqplot]

(* FIGURE 16 upper *)

mpsfplot =
  ErrorListPlot[
   Table[{{mfpsT[[Length[mfpsT]]][[1]]*llist[[j]], mfpsT[[j]][[1]]},
     ErrorBar[mfpsT[[j]][[2]]]}, {j, 1, Length[llist]}], Frame -> True,
   PlotRange -> {{2, 10.5}, {0.3, 0.82}}, AxesStyle -> Thick,
   PlotMarkers -> {"\[EmptySquare]", 15}, PlotStyle -> RGBColor[0, 0, 1],
   AxesStyle -> Black, FrameStyle -> Black,
   FrameLabel -> {MaTeX["m_{\\rm{PS}}^{f,\,\\rm{inf}}\,L",
      Magnification -> 2], MaTeX["a\,m^{f}_{\\rm{PS}}", Magnification -> 2]},
   BaseStyle -> texStyle, ImageSize -> 600];

mpsfzoomplot =
  ErrorListPlot[
   Table[{{mfpsT[[Length[mfpsT]]][[1]]*llist[[j]], mfpsT[[j]][[1]]},
     ErrorBar[mfpsT[[j]][[2]]]}, {j, 1, Length[llist]}], Frame -> True,
   PlotRange -> {{5, 10.5}, {0.355, 0.392}}, AxesStyle -> Thick,
   PlotMarkers -> {"\[EmptySquare]", 15}, PlotStyle -> RGBColor[0, 0, 1],
   AxesStyle -> Black, FrameStyle -> Black,
   BaseStyle -> {FontFamily -> "Times", FontSize -> 15}, ImageSize -> 300];

mpsfplotwithinset =
  ErrorListPlot[
   Table[{{mfpsT[[Length[mfpsT]]][[1]]*llist[[j]], mfpsT[[j]][[1]]},
     ErrorBar[mfpsT[[j]][[2]]]}, {j, 1, Length[llist]}], Frame -> True,
   PlotRange -> {{2, 10.5}, {0.3, 0.82}},
   Epilog -> Inset[mpsfzoomplot, {7.5, 0.63}], AxesStyle -> Thick,
   PlotMarkers -> {"\[EmptySquare]", 15}, PlotStyle -> RGBColor[0, 0, 1],
   AxesStyle -> Black, FrameStyle -> Black,
   FrameLabel -> {MaTeX["m_{\\rm{PS}}^{f,\,\\rm{inf}}\,L",
      Magnification -> 2], MaTeX["a\,m^{f}_{\\rm{PS}}", Magnification -> 2]},
   BaseStyle -> texStyle, ImageSize -> 600];

Export[StringJoin[$ScriptCommandLine[[3]],
   "/m_ps_f_with_inset.pdf"], mpsfplotwithinset];

fpsfplot =
  ErrorListPlot[
   Table[{{mfpsT[[Length[mfpsT]]][[1]]*llist[[j]], ffpsT[[j]][[1]]},
     ErrorBar[ffpsT[[j]][[2]]]}, {j, 1, Length[llist]}], Frame -> True,
   PlotRange -> {{2, 10.5}, {0.03, 0.056}}, AxesStyle -> Thick,
   PlotMarkers -> {"\[EmptySquare]", 15}, PlotStyle -> RGBColor[0, 0, 1],
   AxesStyle -> Black, FrameStyle -> Black,
   FrameLabel -> {MaTeX["m_{\\rm{PS}}^{f,\,\\rm{inf}}\,L",
      Magnification -> 2], MaTeX["a\,f^{f}_{\\rm{PS}}", Magnification -> 2]},
   LabelStyle -> Directive[22, Black],
   BaseStyle -> texStyle, ImageSize -> 600];

mvfplot =
  ErrorListPlot[
   Table[{{mfpsT[[Length[mfpsT]]][[1]]*llist[[j]], mvT[[j]][[1]]},
     ErrorBar[mvT[[j]][[2]]]}, {j, 1, Length[llist]}], Frame -> True,
   PlotRange -> {{2, 10.5}, {0.35, 0.85}}, AxesStyle -> Thick,
   PlotMarkers -> {"\[EmptySquare]", 15}, PlotStyle -> RGBColor[0, 0, 1],
   AxesStyle -> Black, FrameStyle -> Black,
   FrameLabel -> {MaTeX["m_{\\rm{PS}}^{f,\,\\rm{inf}}\,L",
      Magnification -> 2], MaTeX["a\,m^{f}_{\\rm{V}}", Magnification -> 2]},
   LabelStyle -> Directive[22, Black],
   BaseStyle -> texStyle, ImageSize -> 600];

mchfplot =
  ErrorListPlot[
   Table[{{mfpsT[[Length[mfpsT]]][[1]]*llist[[j]], mchT[[j]][[1]]},
     ErrorBar[mchT[[j]][[2]]]}, {j, 1, Length[llist]}], Frame -> True,
   PlotRange -> {{2, 11}, {0.7, 1.12}}, AxesStyle -> Thick,
   PlotMarkers -> {"\[EmptyUpTriangle]", 15}, PlotStyle -> RGBColor[1, 0, 1],
   AxesStyle -> Black, FrameStyle -> Black,
   FrameLabel -> {MaTeX["m_{\\rm{PS}}^{f,\,\\rm{inf}}\,L",
      Magnification -> 2], MaTeX["a\,m^{f}_{\\rm{CB}}", Magnification -> 2]},
   LabelStyle -> Directive[22, Black],
   BaseStyle -> texStyle, ImageSize -> 600];

Export[StringJoin[$ScriptCommandLine[[3]], "/m_ch.pdf"], mchfplot];

(* Antisymmetric *)

mpsT = Import[StringJoin[$ScriptCommandLine[[2]], "/summary_mps_asy.txt"], "Table"];
fpsT = Import[StringJoin[$ScriptCommandLine[[2]], "/summary_fps_asy.txt"], "Table"];
mvT = Import[StringJoin[$ScriptCommandLine[[2]], "/summary_mv_asy.txt"], "Table"];
mtT = Import[StringJoin[$ScriptCommandLine[[2]], "/summary_mt_asy.txt"], "Table"];
mavT = Import[StringJoin[$ScriptCommandLine[[2]], "/summary_mav_asy.txt"], "Table"];
matT = Import[StringJoin[$ScriptCommandLine[[2]], "/summary_mat_asy.txt"], "Table"];
msT = Import[StringJoin[$ScriptCommandLine[[2]], "/summary_ms_asy.txt"], "Table"];

(* Plots *)

mpsasplot =
  ErrorListPlot[
   Table[{{mfpsT[[Length[mpsT]]][[1]]*llist[[j]], mpsT[[j]][[1]]},
     ErrorBar[mpsT[[j]][[2]]]}, {j, 1, Length[llist]}], Frame -> True,
   PlotRange -> {{2, 10.5}, {0, 0.82}}, AxesStyle -> Thick,
   PlotMarkers -> {"\[EmptyCircle]", 15}, PlotStyle -> RGBColor[1, 0, 0],
   AxesStyle -> Black, FrameStyle -> Black,
   FrameLabel -> {MaTeX["m_{\\rm{PS}}^{f,\,\\rm{inf}}\,L",
      Magnification -> 2], MaTeX["a\,m_{\\rm{PS}}", Magnification -> 2]},
   LabelStyle -> Directive[22, Black], ImageSize -> 600];

mpsaszoomplot =
  ErrorListPlot[
   Table[{{mfpsT[[Length[mpsT]]][[1]]*llist[[j]], mpsT[[j]][[1]]},
     ErrorBar[mpsT[[j]][[2]]]}, {j, 1, Length[llist]}], Frame -> True,
   PlotRange -> {{5, 10.5}, {0.58, 0.606}}, AxesStyle -> Thick,
   PlotMarkers -> {"\[EmptyCircle]", 15}, PlotStyle -> RGBColor[1, 0, 0],
   AxesStyle -> Black, FrameStyle -> Black,
   BaseStyle -> {FontFamily -> "Times", FontSize -> 15}, ImageSize -> 300];

(* FIGURE 16 lower *)

mpsasplotwithinset =
 ErrorListPlot[
  Table[{{mfpsT[[Length[mfpsT]]][[1]]*llist[[j]], mpsT[[j]][[1]]},
    ErrorBar[mpsT[[j]][[2]]]}, {j, 1, Length[llist]}], Frame -> True,
  PlotRange -> {{2, 10.5}, {0.4, 0.62}},
  Epilog -> Inset[mpsaszoomplot, {7.5, 0.48}], AxesStyle -> Thick,
  PlotMarkers -> {"\[EmptyCircle]", 15}, PlotStyle -> RGBColor[1, 0, 0],
  AxesStyle -> Black, FrameStyle -> Black,
  FrameLabel -> {MaTeX["m_{\\rm{PS}}^{f,\,\\rm{inf}}\,L", Magnification -> 2],
     MaTeX["a\,m^{as}_{\\rm{PS}}", Magnification -> 2]},
  BaseStyle -> texStyle, ImageSize -> 600];

Export[StringJoin[$ScriptCommandLine[[3]],
   "/m_ps_as_with_inset.pdf"], mpsasplotwithinset];

fpsasplot =
 ErrorListPlot[
  Table[{{mfpsT[[Length[mpsT]]][[1]]*llist[[j]], fpsT[[j]][[1]]},
    ErrorBar[fpsT[[j]][[2]]]}, {j, 1, Length[llist]}], Frame -> True,
  PlotRange -> {{2, 10.5}, {0.0, 0.097}}, FrameStyle -> Black,
  AxesStyle -> Thick, PlotMarkers -> {"\[EmptyCircle]", 15},
  PlotStyle -> RGBColor[1, 0, 0], AxesStyle -> Black,
  FrameLabel -> {MaTeX["m_{\\rm{PS}}^{f,\,\\rm{inf}}\,L", Magnification -> 2],
     MaTeX["af_{\\rm{PS}}", Magnification -> 2]}, BaseStyle -> texStyle,
  ImageSize -> 600];

(* FIGURE 17 lower left *)

Export[StringJoin[$ScriptCommandLine[[3]], "/f_ps.pdf"],
  Show[{fpsfplot, fpsasplot}, PlotRange -> {{2, 10.5}, {0.03, 0.092}}]];

mvasplot =
 ErrorListPlot[
  Table[{{mfpsT[[Length[mpsT]]][[1]]*llist[[j]], mvT[[j]][[1]]},
    ErrorBar[mvT[[j]][[2]]]}, {j, 1, Length[llist]}], Frame -> True,
  PlotRange -> {{2, 10.5}, {0.0, 0.68}}, FrameStyle -> Black,
  AxesStyle -> Thick, PlotMarkers -> {"\[EmptyCircle]", 15},
  PlotStyle -> RGBColor[1, 0, 0],
  FrameLabel -> {MaTeX["m_{\\rm{PS}}^{f,\,\\rm{inf}}\,L", Magnification -> 2],
     MaTeX["a\,m_{\\rm{V}}", Magnification -> 2]}, BaseStyle -> texStyle,
  ImageSize -> 600];

(* FIGURE 17 upper right *)

Export[StringJoin[$ScriptCommandLine[[3]], "/m_v.pdf"],
  Show[{mvfplot, mvasplot}]];
