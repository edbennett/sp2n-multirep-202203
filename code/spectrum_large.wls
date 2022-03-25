Needs["ErrorBarPlots`"];
Needs["PlotLegends`"];

<< MaTeX`

texStyle = {FontFamily -> "Times", FontSize -> 20};

mfT = Import[StringJoin[$ScriptCommandLine[[2]], "/large_fun.txt"], "Table"];

mfallplot =
 ErrorListPlot[
  Table[{{j, mfT[[j]][[1]]}, ErrorBar[mfT[[j]][[2]]]}, {j, 1, 6}],
  Frame -> True,
  FrameTicks -> {{Automatic,
     Automatic}, {{{1, MaTeX["\\textrm{PS}", Magnification -> 2]}, {2,
        MaTeX["\\textrm{V}", Magnification -> 2]}, {3,
       MaTeX["\\textrm{T}", Magnification -> 2]}, {4,
       MaTeX["\\textrm{AV}", Magnification -> 2]}, {5,
       MaTeX["\\textrm{AT}", Magnification -> 2]}, {6,
       MaTeX["\\textrm{S}", Magnification -> 2]}, {7,
       MaTeX["\\textrm{CB}", Magnification -> 2]}}, Automatic}},
  PlotRange -> {{0, 7.5}, {0.3, 1.15}}, AxesStyle -> Thick,
  PlotMarkers -> {"\[EmptyCircle]", 15},
  PlotStyle -> RGBColor[0, 0, 1], AxesStyle -> Black,
  FrameStyle -> Black,
  FrameLabel -> {"", MaTeX["a m", Magnification -> 2]},
  LabelStyle -> Directive[22, Black], ImageSize -> 600];

mchT = Import[StringJoin[$ScriptCommandLine[[2]], "/large_ch.txt"], "Table"];

mchallplot =
 ErrorListPlot[
  Table[{{7, mchT[[1]][[1]]},
    ErrorBar[mchT[[1]][[2]]]}, {j, 1, 1}], Frame -> True,
  FrameTicks -> {{Automatic,
     Automatic}, {{{1, MaTeX["\\textrm{PS}", Magnification -> 2]}, {2,
        MaTeX["\\textrm{V}", Magnification -> 2]}, {3,
       MaTeX["\\textrm{T}", Magnification -> 2]}, {4,
       MaTeX["\\textrm{AV}", Magnification -> 2]}, {5,
       MaTeX["\\textrm{AT}", Magnification -> 2]}, {6,
       MaTeX["\\textrm{S}", Magnification -> 2]}, {7,
       MaTeX["\\textrm{CB}", Magnification -> 2]}}, Automatic}},
  PlotRange -> {{0, 7.5}, {0.3, 1.15}}, AxesStyle -> Thick,
  PlotMarkers -> {"\[EmptyCircle]", 15},
  PlotStyle -> RGBColor[1, 0, 1], AxesStyle -> Black,
  FrameStyle -> Black,
  FrameLabel -> {"", MaTeX["a m", Magnification -> 2]},
  LabelStyle -> Directive[22, Black], ImageSize -> 600];

masT = Import[StringJoin[$ScriptCommandLine[[2]], "/large_asy.txt"], "Table"];

masallplot = 
 ErrorListPlot[
  Table[{{j, masT[[j]][[1]]}, ErrorBar[masT[[j]][[2]]]}, {j, 1, 6}],
  Frame -> True,
  FrameTicks -> {{Automatic,
     Automatic}, {{{1, MaTeX["\\textrm{PS}", Magnification -> 2]}, {2,
        MaTeX["\\textrm{V}", Magnification -> 2]}, {3,
       MaTeX["\\textrm{T}", Magnification -> 2]}, {4,
       MaTeX["\\textrm{AV}", Magnification -> 2]}, {5,
       MaTeX["\\textrm{AT}", Magnification -> 2]}, {6,
       MaTeX["\\textrm{S}", Magnification -> 2]}, {7,
       MaTeX["\\textrm{CB}", Magnification -> 2]}}, Automatic}},
  PlotRange -> {{0, 7.5}, {0.3, 1.15}}, AxesStyle -> Thick,
  PlotMarkers -> {"\[EmptySquare]", 15},
  PlotStyle -> RGBColor[1, 0, 0], AxesStyle -> Black,
  FrameStyle -> Black,
  FrameLabel -> {"", MaTeX["a m", Magnification -> 2]},
  LabelStyle -> Directive[22, Black], ImageSize -> 600];

Export[StringJoin[$ScriptCommandLine[[3]], "/spectrum.pdf"],
 Show[{masallplot, mfallplot, mchallplot},
 PlotRange -> {{0, 7.5}, {0.3, 0.95}}, ImageSize -> 700]];
