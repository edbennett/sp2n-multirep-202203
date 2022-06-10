SeedRandom[StringJoin[$ScriptCommandLine]];

Needs["ErrorBarPlots`"]

Needs["PlotLegends`"]

<< MaTeX`

texStyle = {FontFamily -> "Times", FontSize -> 20};

(* Chimera baryon *)

(* Import data and choose initial lattice parameters - without parity projection *)

NT = ToExpression[$ScriptCommandLine[[6]]]; (*number of temporal lattice*)
NS = ToExpression[$ScriptCommandLine[[7]]]; (*number of one of the spatial lattice*)
beta = ToExpression[$ScriptCommandLine[[8]]];


corrimport =
  Import[StringJoin[$ScriptCommandLine[[2]], "/ch_corr_", $ScriptCommandLine[[3]], "_unprojected.txt"],
   "Table"]; (*import the correlators for 17 interpolating operators*)

{ntraj,dev,fstouse,fetouse,nconfstart} = Flatten[
  Import[StringJoin[$ScriptCommandLine[[4]], "/ch_params_", $ScriptCommandLine[[3]], ".txt"], "Table"]
];


Nconf = If[
   Length[corrimport]/(NT)/ntraj - Round[Length[corrimport]/ntraj] >= 0,
   Round[Length[corrimport]/(NT)/ntraj],
   Round[Length[corrimport]/(NT)/ntraj] - 1] ;(*number of configurations*)

Ntmax = Length[corrimport[[1]]] - 2; (*number of temporal lattice*)


corrchreT =
  Table[Table[
    NS^3 (corrimport[[NT*(ntraj*(j - 1) + dev) + (i - 1) + 1]][[3]] +
       corrimport[[NT*(ntraj*(j - 1) + dev) + (i - 1) + 1]][[5]] +
       corrimport[[NT*(ntraj*(j - 1) + dev) + (i - 1) + 1]][[7]] +
       corrimport[[NT*(ntraj*(j - 1) + dev) + (i - 1) + 1]][[9]]), {j,
     nconfstart + 1, Nconf}], {i, 1, NT}];
corrchimT =
  Table[Table[
    NS^3 (corrimport[[NT*(ntraj*(j - 1) + dev) + (i - 1) + 1]][[4]] +
       corrimport[[NT*(ntraj*(j - 1) + dev) + (i - 1) + 1]][[6]] +
       corrimport[[NT*(ntraj*(j - 1) + dev) + (i - 1) + 1]][[8]] +
       corrimport[[NT*(ntraj*(j - 1) + dev) + (i - 1) + 1]][[10]]), {j,
     nconfstart + 1, Nconf}], {i, 1, NT}];

corrchT = corrchreT;

Do[corrchT[[j]] = -corrchT[[j]], {j, 1,
   24}];(*used for the computation of the log plot and effective mass plot*)

nconf = Nconf - nconfstart; (*number of correlators used for the analysis*)

Nboot = 200; (*number of samples resampled through bootstrapping*)

rndi = Table[
   Table[Round[RandomReal[{0, 1}] (nconf - 1) + 1], {j, Nboot}], {i,
    nconf}]; (*generating random numbers*)

corrchrebootT =
  Table[Table[
    Mean[Table[corrchreT[[k]][[rndi[[i]][[j]]]], {i, nconf}]], {j,
     Nboot}], {k, NT}]; (*resampled data for chimera correlators - real*)

corrchrebootavgT =
  Table[{k - 1, Mean[corrchrebootT[[k]]],
    StandardDeviation[corrchrebootT[[k]]]}, {k,
    NT}]; (*mean and standard deviation of resampled data for chimera correlators \
correlators*)

corrchimbootT =
  Table[Table[
    Mean[Table[corrchimT[[k]][[rndi[[i]][[j]]]], {i, nconf}]], {j,
     Nboot}], {k, NT}]; (*resampled data for chimera correlators - imaginary*)

corrchimbootavgT =
  Table[{k - 1, Mean[corrchimbootT[[k]]],
    StandardDeviation[corrchimbootT[[k]]]}, {k,
    NT}]; (*mean and standard deviation of resampled data for chimera correlators \
correlators*)

corrchbootT =
  Table[Table[
    Mean[Table[corrchT[[k]][[rndi[[i]][[j]]]], {i, nconf}]], {j,
     Nboot}], {k, NT}]; (*resampled data for chimera correlators - real and absolute values*)

corrchbootavgT =
  Table[{k - 1, Mean[corrchbootT[[k]]],
    StandardDeviation[corrchbootT[[k]]]}, {k,
    NT}]; (*mean and standard deviation of resampled data for chimera correlators \
correlators*)


corrchlogbootT =
  Table[Table[
    Log[Mean[Table[corrchT[[k]][[rndi[[i]][[j]]]], {i, nconf}]]], {j,
     Nboot}], {k, NT}]; (*resampled data for chimera correlators - logarithm*)

corrchlogbootavgT =
  Table[{k - 1, Mean[corrchlogbootT[[k]]],
    StandardDeviation[corrchlogbootT[[k]]]}, {k,
    NT}]; (*mean and standard deviation of resampled data for chimera correlators \
correlators*)


chcorrlogreplot = ErrorListPlot[
 Table[{{corrchlogbootavgT[[t]][[1]] - 1, corrchlogbootavgT[[t]][[2]]},
   ErrorBar[corrchlogbootavgT[[t]][[3]]]}, {t, 4, NT}], Frame -> True,
 PlotRange -> {{0, NT - 1}, {All, 1}}, AxesStyle -> Thick,
 PlotMarkers -> {"\[EmptyCircle]", 18}, PlotStyle -> RGBColor[0, 0, 1],
 AxesStyle -> Black,
 FrameLabel -> {MaTeX["t", Magnification -> 2],
   MaTeX["{\\rm Log}\\left[\,|C_{\\rm CB}^{\,\\rm{re}}(t)|\,\\right]",
    Magnification -> 2]}, LabelStyle -> Directive[22, Black],
 FrameStyle -> Directive[Thickness[0.002], Black], BaseStyle -> texStyle,
 ImageSize -> 600];(*effective mass plot*)

Export[StringJoin[$ScriptCommandLine[[5]], "/chcorrlogre.pdf"], chcorrlogreplot];

chcorrreplot =
 ErrorListPlot[
  Table[{{corrchrebootavgT[[t]][[1]], corrchrebootavgT[[t]][[2]]},
    ErrorBar[corrchrebootavgT[[t]][[3]]]}, {t, 2, NT - 2}], Frame -> True,
  PlotRange -> {{9.5, 38.5}, {-0.000055, .000055}}, AxesStyle -> Thick,
  PlotMarkers -> {"\[EmptyCircle]", 18}, PlotStyle -> RGBColor[0, 0, 1],
  AxesStyle -> Black,
  FrameLabel -> {MaTeX["t", Magnification -> 2],
    MaTeX["C_{\\rm CB}^{\,\\rm re}(t)\,(\\times 10^{-5})",
     Magnification -> 2]},
  FrameTicks -> {{{{0, 0}, {1 10^(-5), 1}, {2 10^(-5), 2}, {3 10^(-5),
       3}, {4 10^(-5), 4}, {5 10^(-5),
       5}, {-1 10^(-5), -1}, {-2 10^(-5), -2}, {-3 10^(-5), -3}, {-4 10^(-5), \
-4}, {-5 10^(-5), -5}}, Automatic}, {Automatic, Automatic}},
  FrameStyle -> Directive[Thickness[0.002], Black], BaseStyle -> texStyle,
  ImageSize -> 600];(*effective mass plot*)

Export[StringJoin[$ScriptCommandLine[[5]], "/chcorrre.pdf"], chcorrreplot];


chcorrimplot =
 ErrorListPlot[
  Table[{{corrchimbootavgT[[t]][[1]], corrchimbootavgT[[t]][[2]]},
    ErrorBar[corrchimbootavgT[[t]][[3]]]}, {t, 2, NT - 2}], Frame -> True,
  PlotRange -> {{9.5, 38.5}, {-0.00000000000000007, .00000000000000007}},
  AxesStyle -> Thick,
  PlotMarkers -> {"\[EmptyCircle]", 18}, PlotStyle -> RGBColor[0, 0, 1],
  AxesStyle -> Black,
  FrameLabel -> {MaTeX["t", Magnification -> 2],
    MaTeX["C_{\\rm CB}^{\,\\rm im}(t)\,(\\times 10^{-17})",
     Magnification -> 2]},
  FrameTicks -> {{{{0, 0}, {2 10^(-17), 2}, {4 10^(-17), 4}, {6 10^(-17), 6},
       {-6 10^(-17), -6}, {-4 10^(-17), -4}, {-2 10^(-17), -2}}, Automatic},
       {Automatic, Automatic}},
  FrameStyle -> Directive[Thickness[0.002], Black], BaseStyle -> texStyle,
  ImageSize -> 600];(*effective mass plot*)

Export[StringJoin[$ScriptCommandLine[[5]], "/chcorrim.pdf"], chcorrimplot];

(*Effective mass of chimera baryon*)
dt = 1;
meffchtab =
  Table[{i,
    Mean[Table[
      ArcCosh[(corrchrebootT[[i]][[j]] +
           corrchrebootT[[i + 2*dt]][[j]])/(2 corrchrebootT[[i + dt]][[j]])]/
       dt, {j, Nboot}]],
    StandardDeviation[
     Table[
      ArcCosh[(corrchrebootT[[i]][[j]] +
           corrchrebootT[[i + 2*dt]][[j]])/(2 corrchrebootT[[i + dt]][[j]])]/
       dt, {j, Nboot}]]}, {i, 1, NT - 2*dt}];

chmeffplot =
 ErrorListPlot[
  Table[{{meffchtab[[t]][[1]], meffchtab[[t]][[2]]},
    ErrorBar[meffchtab[[t]][[3]]]}, {t, 1, NT - 2*dt}], Frame -> True,
  PlotRange -> {{0, NT}, {0.6, 1.65}}, AxesStyle -> Thick,
  PlotMarkers -> {"\[EmptyCircle]", 15}, PlotStyle -> RGBColor[0, 0, 1],
  AxesStyle -> Black,
  FrameLabel -> {MaTeX["t", Magnification -> 2],
    MaTeX["m_{\\rm eff}", Magnification -> 2]},
  LabelStyle -> Directive[22, Black],
  FrameStyle -> Directive[Thickness[0.002], Black], BaseStyle -> texStyle,
  ImageSize -> 600];(*effective mass plot*)

Export[StringJoin[$ScriptCommandLine[[5]], "/chmeff.pdf"], chmeffplot];


(* Import data and choose initial lattice parameters - parity projected *)

corrimport =
  Import[StringJoin[$ScriptCommandLine[[2]], "/ch_corr_", $ScriptCommandLine[[3]], ".txt"],
   "Table"]; (*import the correlators for 17 interpolating operators*)

Nconf = If[
   Length[corrimport]/(NT)/ntraj - Round[Length[corrimport]/ntraj] >= 0,
   Round[Length[corrimport]/(NT)/ntraj],
   Round[Length[corrimport]/(NT)/ntraj] - 1] ;(*number of configurations*)

Ntmax = Length[corrimport[[1]]] - 2; (*number of temporal lattice*)

nconf = Nconf - nconfstart; (*number of correlators used for the analysis*)

Nboot = 200; (*number of samples resampled through bootstrapping*)

rndi = Table[
   Table[Round[RandomReal[{0, 1}] (nconf - 1) + 1], {j, Nboot}], {i,
    nconf}]; (*generating random numbers*)


(* Correlation functions and effective mass - even *)

(*parity even*)

corrchreT =
  Table[Table[
    NS^3 corrimport[[NT*(ntraj*(j - 1) + dev) + (i - 1) + 1]][[3]], {j,
     nconfstart + 1, Nconf}], {i, 1, NT}];
corrchimT =
  Table[Table[
    NS^3 corrimport[[NT*(ntraj*(j - 1) + dev) + (i - 1) + 1]][[4]], {j,
     nconfstart + 1, Nconf}], {i, 1, NT}];

corrchrebootT =
  Table[Table[
    Mean[Table[corrchreT[[k]][[rndi[[i]][[j]]]], {i, nconf}]], {j,
     Nboot}], {k, NT}]; (*resampled data for chimera correlators - real*)

corrchrebootavgT =
  Table[{k - 1, Mean[corrchrebootT[[k]]],
    StandardDeviation[corrchrebootT[[k]]]}, {k,
    NT}]; (*mean and standard deviation of resampled data for chimera correlators \
correlators*)

corrchimbootT =
  Table[Table[
    Mean[Table[corrchimT[[k]][[rndi[[i]][[j]]]], {i, nconf}]], {j,
     Nboot}], {k, NT}]; (*resampled data for chimera correlators - imaginary*)

corrchimbootavgT =
  Table[{k - 1, Mean[corrchimbootT[[k]]],
    StandardDeviation[corrchimbootT[[k]]]}, {k,
    NT}]; (*mean and standard deviation of resampled data for chimera correlators \
correlators*)

corrchbootT = corrchrebootT;
corrchbootavgT = corrchrebootavgT;

chppcorrreplot = ErrorListPlot[
 Table[{{corrchrebootavgT[[t]][[1]], corrchrebootavgT[[t]][[2]]},
   ErrorBar[corrchrebootavgT[[t]][[3]]]}, {t, 2, NT - 2}], Frame -> True,
 PlotRange -> {{9.5, 38.5}, {0.000007, -.000055}}, AxesStyle -> Thick,
 PlotMarkers -> {"\[EmptyCircle]", 18}, PlotStyle -> RGBColor[0, 0, 1],
 AxesStyle -> Black,
 FrameLabel -> {MaTeX["t", Magnification -> 2],
   MaTeX["C_{\\rm CB}^{+\,\\rm{re}}(t)\,(\\times 10^{-5})",
    Magnification -> 2]},
 FrameTicks -> {{{{0,
      0}, {-1 10^(-5), -1}, {-2 10^(-5), -2}, {-3 10^(-5), -3}, {-4 10^(-5), \
-4}, {-5 10^(-5), -5}}, Automatic}, {Automatic, Automatic}},
 FrameStyle -> Directive[Thickness[0.002], Black], BaseStyle -> texStyle,
 ImageSize -> 600];(*effective mass plot*)

Export[StringJoin[$ScriptCommandLine[[5]], "/chppcorrre.pdf"], chppcorrreplot];


chppcorrimplot = ErrorListPlot[
 Table[{{corrchimbootavgT[[t]][[1]], corrchimbootavgT[[t]][[2]]},
   ErrorBar[corrchimbootavgT[[t]][[3]]]}, {t, 1, NT}], Frame -> True,
 PlotRange -> {{9.5, 38.5}, {-0.00000000000000007, .00000000000000007}},
 AxesStyle -> Thick,
 FrameLabel -> {MaTeX["t", Magnification -> 2],
   MaTeX["C_{\\rm CB}^{+\,\\rm{im}}(t)\,(\\times 10^{-17})",
    Magnification -> 2]},
 FrameTicks -> {{{{-6 10^(-17), -6}, {-4 10^(-17), -4}, {-2 10^(-17), -2}, {0,
       0}, {2 10^(-17), 2}, {4 10^(-17), 4}, {6 10^(-17), 6}},
    Automatic}, {Automatic, Automatic}},
 PlotMarkers -> {"\[EmptyCircle]", 18}, PlotStyle -> RGBColor[0, 0, 1],
 FrameStyle -> Directive[Thickness[0.002], Black], BaseStyle -> texStyle,
 ImageSize -> 600];(*effective mass plot*)

Export[StringJoin[$ScriptCommandLine[[5]], "/chppcorrim.pdf"], chppcorrimplot];


(*Effective mass of chimera baryon*)
dt = 1;
meffchtab =
  Table[{i,
    Mean[Table[
      ArcCosh[(corrchbootT[[i]][[j]] +
           corrchbootT[[i + 2*dt]][[j]])/(2 corrchbootT[[i + dt]][[j]])]/
       dt, {j, Nboot}]],
    StandardDeviation[
     Table[
      ArcCosh[(corrchbootT[[i]][[j]] +
           corrchbootT[[i + 2*dt]][[j]])/(2 corrchbootT[[i + dt]][[j]])]/
       dt, {j, Nboot}]]}, {i, 1, NT - 2*dt}];

chevenmeffplot =
 ErrorListPlot[
  Table[{{meffchtab[[t]][[1]], meffchtab[[t]][[2]]},
    ErrorBar[meffchtab[[t]][[3]]]}, {t, 1, NT - 2*dt}], Frame -> True,
  PlotRange -> {{0, NT}, {0.5, 1.65}}, AxesStyle -> Thick,
  PlotMarkers -> {"\[EmptyCircle]", 15}, PlotStyle -> RGBColor[0, 0, 1],
  AxesStyle -> Black,
  FrameLabel -> {MaTeX["t", Magnification -> 2],
    MaTeX["m_{\\rm eff}", Magnification -> 2]},
  LabelStyle -> Directive[22, Black],
  FrameStyle -> Directive[Thickness[0.002], Black], BaseStyle -> texStyle,
  ImageSize -> 600];(*effective mass plot*)

(* Correlation functions and effective mass - odd *)

(*parity odd*)

corrchreT =
  Table[Table[
    NS^3 corrimport[[NT*(ntraj*(j - 1) + dev) + (i - 1) + 1]][[5]], {j,
     nconfstart + 1, Nconf}], {i, 1, NT}];
corrchimT =
  Table[Table[
    NS^3 corrimport[[NT*(ntraj*(j - 1) + dev) + (i - 1) + 1]][[6]], {j,
     nconfstart + 1, Nconf}], {i, 1, NT}];

corrchrebootT =
  Table[Table[
    Mean[Table[corrchreT[[k]][[rndi[[i]][[j]]]], {i, nconf}]], {j,
     Nboot}], {k, NT}]; (*resampled data for chimera correlators - real*)

corrchrebootavgT =
  Table[{k - 1, Mean[corrchrebootT[[k]]],
    StandardDeviation[corrchrebootT[[k]]]}, {k,
    NT}]; (*mean and standard deviation of resampled data for chimera correlators \
correlators*)

corrchimbootT =
  Table[Table[
    Mean[Table[corrchimT[[k]][[rndi[[i]][[j]]]], {i, nconf}]], {j,
     Nboot}], {k, NT}]; (*resampled data for chimera correlators*)

corrchimbootavgT =
  Table[{k - 1, Mean[corrchimbootT[[k]]],
    StandardDeviation[corrchimbootT[[k]]]}, {k,
    NT}]; (*mean and standard deviation of resampled data for chimera correlators - imaginary \
correlators*)

corrchbootT = corrchrebootT;
corrchbootavgT = corrchrebootavgT;

ErrorListPlot[
 Table[{{corrchrebootavgT[[t]][[1]], corrchrebootavgT[[t]][[2]]},
   ErrorBar[corrchrebootavgT[[t]][[3]]]}, {t, 2, NT - 2}], Frame -> True,
 PlotRange -> {{9.5, 38.5}, {-0.000007, .000055}}, AxesStyle -> Thick,
 PlotMarkers -> {"\[EmptyCircle]", 18}, PlotStyle -> RGBColor[0, 0, 1],
 AxesStyle -> Black,
 FrameLabel -> {MaTeX["t", Magnification -> 2],
   MaTeX["C_{\\rm CB}^{-\,\\rm{re}}(t)\,(\\times 10^{-5})",
    Magnification -> 2]},
 FrameTicks -> {{{{0, 0}, {1 10^(-5), 1}, {2 10^(-5), 2}, {3 10^(-5),
      3}, {4 10^(-5), 4}, {5 10^(-5), 5}}, Automatic}, {Automatic,
    Automatic}}, FrameStyle -> Directive[Thickness[0.002], Black],
 BaseStyle -> texStyle, ImageSize -> 600](*effective mass plot*)

ErrorListPlot[
 Table[{{corrchimbootavgT[[t]][[1]], corrchimbootavgT[[t]][[2]]},
   ErrorBar[corrchimbootavgT[[t]][[3]]]}, {t, 1, NT}], Frame -> True,
 PlotRange -> {{9.5, 38.5}, {-0.00000000000000007, .00000000000000007}},
 AxesStyle -> Thick,
 FrameLabel -> {MaTeX["t", Magnification -> 2],
   MaTeX["C_{\\rm CB}^{-\,\\rm{im}}(t)\,(\\times 10^{-17})",
    Magnification -> 2]},
 FrameTicks -> {{{{-6 10^(-17), -6}, {-4 10^(-17), -4}, {-2 10^(-17), -2}, {0,
       0}, {2 10^(-17), 2}, {4 10^(-17), 4}, {6 10^(-17), 6}},
    Automatic}, {Automatic, Automatic}},
 PlotMarkers -> {"\[EmptyCircle]", 18}, PlotStyle -> RGBColor[0, 0, 1],
 FrameStyle -> Directive[Thickness[0.002], Black], BaseStyle -> texStyle,
 ImageSize -> 600](*effective mass plot*)

(*Effective mass of chimera baryon*)
dt = 1;
meffchtab =
  Table[{i,
    Mean[Table[
      ArcCosh[(corrchbootT[[i]][[j]] +
           corrchbootT[[i + 2*dt]][[j]])/(2 corrchbootT[[i + dt]][[j]])]/
       dt, {j, Nboot}]],
    StandardDeviation[
     Table[
      ArcCosh[(corrchbootT[[i]][[j]] +
           corrchbootT[[i + 2*dt]][[j]])/(2 corrchbootT[[i + dt]][[j]])]/
       dt, {j, Nboot}]]}, {i, 1, NT - 2*dt}];

choddmeffplot =
 ErrorListPlot[
  Table[{{meffchtab[[t]][[1]], meffchtab[[t]][[2]]},
    ErrorBar[meffchtab[[t]][[3]]]}, {t, 1, NT - 2*dt}], Frame -> True,
  PlotRange -> {{0, NT}, {0.6, 1.65}}, AxesStyle -> Thick,
  PlotMarkers -> {"\[EmptyCircle]", 15}, PlotStyle -> RGBColor[1, 0, 0],
  AxesStyle -> Black,
  FrameLabel -> {MaTeX["t", Magnification -> 2],
    MaTeX["m_{\\rm eff}", Magnification -> 2]},
  LabelStyle -> Directive[22, Black],
  FrameStyle -> Directive[Thickness[0.002], Black], BaseStyle -> texStyle,
  ImageSize -> 600];(*effective mass plot*)

(* Log of correlation functions - even *)

(*parity even*)

corrchreT =
  Table[Table[
    NS^3 corrimport[[NT*(ntraj*(j - 1) + dev) + (i - 1) + 1]][[3]], {j,
     nconfstart + 1, Nconf}], {i, 1, NT}];

Do[corrchreT[[j]] = -corrchreT[[j]];
  corrchimT[[j]] = -corrchimT[[j]], {j, 1,
   NT}];(*used for the computation of the log plot in the case of even parity*)

corrchrelogbootT =
  Table[Table[
    Log[Mean[Table[corrchreT[[k]][[rndi[[i]][[j]]]], {i, nconf}]]], {j,
     Nboot}], {k, NT}]; (*resampled data for chimera correlators - real*)

corrchrelogbootavgT =
  Table[{k - 1, Mean[corrchrelogbootT[[k]]],
    StandardDeviation[corrchrelogbootT[[k]]]}, {k,
    NT}]; (*mean and standard deviation of resampled data for chimera correlators \
correlators*)


  logcorrevenplot =
 ErrorListPlot[
  Table[{{corrchrelogbootavgT[[t]][[1]] - 1, corrchrelogbootavgT[[t]][[2]]},
    ErrorBar[corrchrelogbootavgT[[t]][[3]]]}, {t, 4, NT}], Frame -> True,
  PlotRange -> {{0, NT - 1}, {All, All}}, AxesStyle -> Thick,
  PlotMarkers -> {"\[EmptyCircle]", 17}, PlotStyle -> RGBColor[0, 0, 1],
  AxesStyle -> Black,
  FrameLabel -> {MaTeX["t", Magnification -> 2],
    MaTeX["{\\rm Log}\\left[\,|C_{\\rm CB}^{\,\\rm{re}}(t)|\,\\right]",
     Magnification -> 2]}, LabelStyle -> Directive[22, Black],
  FrameStyle -> Directive[Thickness[0.002], Black], BaseStyle -> texStyle,
  ImageSize -> 600](*effective mass plot*)

(* Log of correlation functions - odd *)

(*parity odd*)

corrchreT =
  Table[Table[
    NS^3 corrimport[[NT*(ntraj*(j - 1) + dev) + (i - 1) + 1]][[5]], {j,
     nconfstart + 1, Nconf}], {i, 1, NT}];

corrchrelogbootT =
  Table[Table[
    Log[Mean[Table[corrchreT[[k]][[rndi[[i]][[j]]]], {i, nconf}]]], {j,
     Nboot}], {k, NT}]; (*resampled data for chimera correlators - real*)

corrchrelogbootavgT =
  Table[{k - 1, Mean[corrchrelogbootT[[k]]],
    StandardDeviation[corrchrelogbootT[[k]]]}, {k,
    NT}]; (*mean and standard deviation of resampled data for chimera correlators \
correlators*)


 logcorroddplot =
 ErrorListPlot[
  Table[{{corrchrelogbootavgT[[t]][[1]] - 1, corrchrelogbootavgT[[t]][[2]]},
    ErrorBar[corrchrelogbootavgT[[t]][[3]]]}, {t, 4, NT}], Frame -> True,
  PlotRange -> {{0, NT - 1}, {-26, 1}}, AxesStyle -> Thick,
  PlotMarkers -> {"\[EmptyCircle]", 17}, PlotStyle -> RGBColor[1, 0, 0],
  AxesStyle -> Black,
  FrameLabel -> {MaTeX["t", Magnification -> 2],
    MaTeX["{\\rm Log}\\left[\,|C_{\\rm CB}^{\,\\rm{re}}(t)|\,\\right]",
     Magnification -> 2]}, LabelStyle -> Directive[22, Black],
  FrameStyle -> Directive[Thickness[0.002], Black], BaseStyle -> texStyle,
  ImageSize -> 600](*effective mass plot*)

(* Combined plots *)

Export[StringJoin[$ScriptCommandLine[[5]], "/chpplogcorr.pdf"],
  Show[logcorroddplot, logcorrevenplot]
];

Export[StringJoin[$ScriptCommandLine[[5]], "/chppmeff.pdf"],
  Show[{choddmeffplot, chevenmeffplot}, PlotRange -> {{0, NT}, {0.5, 1.65}}]
];
