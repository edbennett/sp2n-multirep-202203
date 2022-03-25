#!/usr/bin/env wolframscript

Needs["ErrorBarPlots`"]
Needs["PlotLegends`"]

\[Beta]=6.35

<<MaTeX`
texStyle = {FontFamily -> "Times", FontSize -> 20};

(* Initial parameters *)

beta=6.35;
beta1=6;
beta2=35;
M0T={-1.055,-1.06,-1.063,-1.064,-1.065,-1.066,-1.067,-1.068,-1.069,-1.07,-1.072,-1.075};

(* Import Data *)

Do[
m0=M0T[[j]];
suffix=StringJoin["24x12x12x12b",ToString[beta1],".",ToString[beta2],"mas",ToString[m0],"mf-0.6.txt"];
pstmp=Import[StringJoin[$ScriptCommandLine[[2]], "/corr_ps_fit_asy_",suffix],"Table"];
ps2T[j]={pstmp[[2]],pstmp[[1]]};
stmp=Import[StringJoin[$ScriptCommandLine[[2]], "/corr_s_fit_asy_",suffix],"Table"];
s2T[j]={stmp[[2]]};
vtmp=Import[StringJoin[$ScriptCommandLine[[2]], "/corr_v_fit_asy_",suffix],"Table"];
v2T[j]={vtmp[[2]],vtmp[[1]]},{j,Length[M0T]}];

(*import data in lattice units: (m^2, f^2)*)


(* Data tables *)

pstab=Table[{{Mean[Sqrt[ps2T[j][[1]]]],StandardDeviation[Sqrt[ps2T[j][[1]]]]},{Mean[Sqrt[ps2T[j][[2]]]],StandardDeviation[Sqrt[ps2T[j][[2]]]]},{Mean[Sqrt[ps2T[j][[1]]/ps2T[j][[2]]]],StandardDeviation[Sqrt[ps2T[j][[1]]/ps2T[j][[2]]]]}},{j,Length[M0T]}]
ps2tab=Table[{{Mean[ps2T[j][[1]]],StandardDeviation[ps2T[j][[1]]]},{Mean[ps2T[j][[2]]],StandardDeviation[ps2T[j][[2]]]},{Mean[ps2T[j][[1]]/ps2T[j][[2]]],StandardDeviation[ps2T[j][[1]]/ps2T[j][[2]]]},{Mean[ps2T[j][[1]] ps2T[j][[2]]],StandardDeviation[ps2T[j][[1]] ps2T[j][[2]]]}},{j,Length[M0T]}]
vtab=Table[{{Mean[Sqrt[v2T[j][[1]]]],StandardDeviation[Sqrt[v2T[j][[1]]]]},{Mean[Sqrt[v2T[j][[2]]]],StandardDeviation[Sqrt[v2T[j][[2]]]]},{Mean[Sqrt[v2T[j][[1]]/ps2T[j][[2]]]],StandardDeviation[Sqrt[v2T[j][[1]]/ps2T[j][[2]]]]},{Mean[Sqrt[v2T[j][[1]]/ps2T[j][[1]]]],StandardDeviation[Sqrt[v2T[j][[1]]/ps2T[j][[1]]]]},{Mean[Sqrt[ps2T[j][[1]]/v2T[j][[1]]]],StandardDeviation[Sqrt[ps2T[j][[1]]/v2T[j][[1]]]]},{Mean[Sqrt[v2T[j][[1]]/v2T[j][[2]]]],StandardDeviation[Sqrt[v2T[j][[1]]/v2T[j][[2]]]]},{Mean[Sqrt[v2T[j][[2]]/ps2T[j][[2]]]],StandardDeviation[Sqrt[v2T[j][[2]]/ps2T[j][[2]]]]},{Mean[Sqrt[v2T[j][[2]]/v2T[j][[1]]]],StandardDeviation[Sqrt[v2T[j][[2]]/v2T[j][[1]]]]},{Mean[Sqrt[(v2T[j][[2]]/Sqrt[2])/ps2T[j][[2]]]],StandardDeviation[Sqrt[(v2T[j][[2]]/v2T[j][[1]])/Sqrt[2]]]}},{j,Length[M0T]}]
v2tab=Table[{{Mean[v2T[j][[1]]],StandardDeviation[v2T[j][[1]]]},{Mean[v2T[j][[2]]],StandardDeviation[v2T[j][[2]]]},{Mean[v2T[j][[1]]/ps2T[j][[2]]],StandardDeviation[v2T[j][[1]]/ps2T[j][[2]]]},{Mean[v2T[j][[1]]/ps2T[j][[1]]],StandardDeviation[v2T[j][[1]]/ps2T[j][[1]]]},{Mean[ps2T[j][[1]]/v2T[j][[1]]],StandardDeviation[ps2T[j][[1]]/v2T[j][[1]]]},{Mean[v2T[j][[1]]/v2T[j][[2]]],StandardDeviation[v2T[j][[1]]/v2T[j][[2]]]},{Mean[v2T[j][[2]]/ps2T[j][[2]]],StandardDeviation[v2T[j][[2]]/ps2T[j][[2]]]}},{j,Length[M0T]}]
stab=Table[{{Mean[Sqrt[s2T[j][[1]]]],StandardDeviation[Sqrt[s2T[j][[1]]]]},{Mean[Sqrt[s2T[j][[1]]/ps2T[j][[2]]]],StandardDeviation[Sqrt[s2T[j][[1]]/ps2T[j][[2]]]]},{Mean[Sqrt[s2T[j][[1]]/ps2T[j][[1]]]],StandardDeviation[Sqrt[s2T[j][[1]]/ps2T[j][[1]]]]}},{j,Length[M0T]}]
s2tab=Table[{{Mean[s2T[j][[1]]],StandardDeviation[s2T[j][[1]]]},{Mean[s2T[j][[1]]/ps2T[j][[2]]],StandardDeviation[s2T[j][[1]]/ps2T[j][[2]]]},{Mean[s2T[j][[1]]/ps2T[j][[1]]],StandardDeviation[s2T[j][[1]]/ps2T[j][[1]]]}},{j,Length[M0T]}]

(* Data plots - spectrum *)

xmin=-1.053;
xmax=-1.077;
ymin=0.12;
ymax=0.245;
dx=(xmax-xmin)/300;
dy=(ymax-ymin)/200;
E1f2PSplot=ErrorListPlot[Table[{{M0T[[i]],pstab[[i]][[2]][[1]]},ErrorBar[pstab[[i]][[2]][[2]]]},{i,1,Length[M0T]}],PlotRange->{{xmin,xmax},{ymin,ymax}},PlotMarkers->{"\[EmptyCircle]",15},Frame->True,FrameLabel->{MaTeX["am^{as}_{0}",Magnification->2],MaTeX["af^{as}_{\\rm{PS}}",Magnification->2]},PlotStyle->{Thickness[0.004],RGBColor[1,0,0]},FrameStyle->Directive[Black],FrameTicks->{{({#,NumberForm[#,{3,2}]}& /@Range[0.0,2.0,0.02]),None},{({#,NumberForm[#,{4,3}]}& /@Range[-3.0,-0.0,0.005]),None}},(*ErrorBarFunction\[Rule]Function[{coords,errs},{Line[{{coords+{0,errs[[2,2]]},coords},{coords+{0,errs[[2,1]]},coords}}],Line[{{coords+{errs[[1,2]],0},coords},{coords+{errs[[1,1]],0},coords}}]}],*)BaseStyle->texStyle,ImageSize->600]
Export[$ScriptCommandLine[[4]], E1f2PSplot];

xmin=-1.053;
xmax=-1.077;
ymin=0.8;
ymax=1.35;
dx=(xmax-xmin)/300;
dy=(ymax-ymin)/200;
E1m2PSplot=ErrorListPlot[Table[{{M0T[[i]],pstab[[i]][[1]][[1]]},ErrorBar[pstab[[i]][[1]][[2]]]},{i,1,Length[M0T]}],PlotRange->{{xmin,xmax},{ymin,ymax}},PlotMarkers->{"\[EmptyCircle]",15},Frame->True,FrameLabel->{MaTeX["am^{as}_{0}",Magnification->2],MaTeX["am^{as}_{\\rm{M}}",Magnification->2]},PlotStyle->{Thickness[0.004],RGBColor[1,0,0]},FrameStyle->Directive[Black],FrameTicks->{{({#,NumberForm[#,{2,1}]}& /@Range[0.0,5.0,0.1]),None},{({#,NumberForm[#,{4,3}]}& /@Range[-3.0,-0.0,0.005]),None}},(*ErrorBarFunction\[Rule]Function[{coords,errs},{Line[{{coords+{0,errs[[2,2]]},coords},{coords+{0,errs[[2,1]]},coords}}],Line[{{coords+{errs[[1,2]],0},coords},{coords+{errs[[1,1]],0},coords}}]}],*)BaseStyle->texStyle,ImageSize->600]

xmin=-1.053;
xmax=-1.077;
ymin=0.9;
ymax=1.43;
dx=(xmax-xmin)/300;
dy=(ymax-ymin)/200;
E1m2Vplot=ErrorListPlot[Table[{{M0T[[i]],vtab[[i]][[1]][[1]]},ErrorBar[vtab[[i]][[1]][[2]]]},{i,1,Length[M0T]}],PlotRange->{{xmin,xmax},{ymin,ymax}},PlotMarkers->{"\[EmptySquare]",15},Frame->True,FrameLabel->{MaTeX["am^{as}_{0}",Magnification->2],MaTeX["am^{as}_{\\rm{V}}",Magnification->2]},PlotStyle->{Thickness[0.004],RGBColor[0,0,1]},FrameStyle->Directive[Black],FrameTicks->{{({#,NumberForm[#,{2,1}]}& /@Range[0.0,2.0,0.1]),None},{({#,NumberForm[#,{4,3}]}& /@Range[-3.0,-0.0,0.005]),None}},(*ErrorBarFunction\[Rule]Function[{coords,errs},{Line[{{coords+{0,errs[[2,2]]},coords},{coords+{0,errs[[2,1]]},coords}}],Line[{{coords+{errs[[1,2]],0},coords},{coords+{errs[[1,1]],0},coords}}]}],*)BaseStyle->texStyle,ImageSize->600]

xmin=-1.053;
xmax=-1.077;
ymin=1.058;
ymax=1.122;
dx=(xmax-xmin)/300;
dy=(ymax-ymin)/200;
E1mVmPSplot=ErrorListPlot[Table[{{M0T[[i]],vtab[[i]][[4]][[1]]},ErrorBar[vtab[[i]][[4]][[2]]]},{i,1,Length[M0T]}],PlotRange->{{xmin,xmax},{ymin,ymax}},Frame->True,FrameLabel->{MaTeX["am^{as}_0",Magnification->2],MaTeX["m^{as}_{\\rm{V}}/m^{as}_{\\rm{PS}}",Magnification->2]},PlotMarkers->{"\[EmptySquare]",15},PlotStyle->{Thickness[0.004],RGBColor[0,0,1]},FrameStyle->Directive[Black],FrameTicks->{{({#,NumberForm[#,{3,2}]}& /@Range[0.0,2.0,0.01]),None},{({#,NumberForm[#,{4,3}]}& /@Range[-3.0,-0.0,0.005]),None}},(*ErrorBarFunction\[Rule]Function[{coords,errs},{Line[{{coords+{0,errs[[2,2]]},coords},{coords+{0,errs[[2,1]]},coords}}],Line[{{coords+{errs[[1,2]],0},coords},{coords+{errs[[1,1]],0},coords}}]}],*)BaseStyle->texStyle,ImageSize->600]
Export[$ScriptCommandLine[[6]], E1mVmPSplot];

xmin=-1.053;
xmax=-1.077;
ymin=0.2;
ymax=2.45;
dx=(xmax-xmin)/300;
dy=(ymax-ymin)/200;
E1m2Splot=ErrorListPlot[Table[{{M0T[[i]],stab[[i]][[1]][[1]]},ErrorBar[stab[[i]][[1]][[2]]]},{i,1,Length[M0T]}],PlotRange->{{xmin,xmax},{ymin,ymax}},PlotMarkers->{"\[EmptyUpTriangle]",15},Frame->True,FrameLabel->{MaTeX["m^{as}_{0}",Magnification->2],MaTeX["am^{as}_{\\rm{M}}",Magnification->2]},PlotStyle->{Thickness[0.004],RGBColor[0,.5,0]},FrameStyle->Directive[Black],FrameTicks->{{({#,NumberForm[#,{2,1}]}& /@Range[0.0,5.0,0.2]),None},{({#,NumberForm[#,{4,3}]}& /@Range[-3.0,-0.0,0.005]),None}},(*ErrorBarFunction\[Rule]Function[{coords,errs},{Line[{{coords+{0,errs[[2,2]]},coords},{coords+{0,errs[[2,1]]},coords}}],Line[{{coords+{errs[[1,2]],0},coords},{coords+{errs[[1,1]],0},coords}}]}],*)BaseStyle->texStyle,ImageSize->600]

mpsmvmsplot=Show[{E1m2Splot,E1m2Vplot,E1m2PSplot(*,ContourPlot[x\[Equal]-1.068,{x,-1.05,-1.08},{y,0,3},ContourStyle\[Rule]Dashed]*)},PlotRange->{{-1.053,-1.077},{0.75,2.45}}]
Export[$ScriptCommandLine[[3]], mpsmvmsplot];

ShowLegend[mpsmvmsplot,{{{Graphics[{RGBColor[0,.5,0],Text[Style["\[EmptySquare]",15]]}],Text[Style[MaTeX["~\\rm{S}",Magnification->2],18]]},{Graphics[{RGBColor[0,0,1],Text[Style["\[EmptyCircle]",15]]}],Text[Style[MaTeX["\,\\rm{V}",Magnification->2],18]]},{Graphics[{RGBColor[1,0,0],Text[Style["\[EmptyCircle]",15]]}],Text[Style[MaTeX["\\rm{PS}",Magnification->2],18]]}},LegendPosition->{-0.66,0.23},LegendTextOffset->{-1.5,0},LegendSize->{0.3,.3},ShadowOffset->{0.0,0.0}}]

xmin=-1.053;
xmax=-1.077;
ymin=6.45;
ymax=5.5;
dx=(xmax-xmin)/300;
dy=(ymax-ymin)/200;
E1fPSmPSplot=ErrorListPlot[Table[{{M0T[[i]],pstab[[i]][[3]][[1]]},ErrorBar[pstab[[i]][[3]][[2]]]},{i,1,Length[M0T]}],PlotRange->{{xmin,xmax},{ymin,ymax}},PlotMarkers->{"\[EmptyCircle]",15},Frame->True,FrameLabel->{MaTeX["am^{as}_0",Magnification->2],MaTeX["m_{\\rm{M}}/f_{\\rm{PS}}",Magnification->2]},PlotStyle->{Thickness[0.004],RGBColor[1,0,0]},FrameStyle->Directive[Black],FrameTicks->{{({#,NumberForm[#,{2,1}]}& /@Range[2.0,10.0,0.2]),None},{({#,NumberForm[#,{4,3}]}& /@Range[-3.0,-0.0,0.005]),None}},(*ErrorBarFunction\[Rule]Function[{coords,errs},{Line[{{coords+{0,errs[[2,2]]},coords},{coords+{0,errs[[2,1]]},coords}}],Line[{{coords+{errs[[1,2]],0},coords},{coords+{errs[[1,1]],0},coords}}]}],*)BaseStyle->texStyle,ImageSize->600]

xmin=-1.053;
xmax=-1.077;
ymin=7.25;
ymax=5.8;
dx=(xmax-xmin)/300;
dy=(ymax-ymin)/200;
E1fPSmVplot=ErrorListPlot[Table[{{M0T[[i]],vtab[[i]][[3]][[1]]},ErrorBar[vtab[[i]][[3]][[2]]]},{i,1,Length[M0T]}],PlotRange->{{xmin,xmax},{ymin,ymax}},PlotMarkers->{"\[EmptySquare]",15},Frame->True,FrameLabel->{MaTeX["am^{as}_0",Magnification->2],MaTeX["m_{\\rm{V}}/f_{\\rm{PS}}",Magnification->2]},PlotStyle->{Thickness[0.004],RGBColor[0,0,1]},FrameStyle->Directive[Black],FrameTicks->{{({#,NumberForm[#,{2,1}]}& /@Range[3.0,9.0,0.2]),None},{({#,NumberForm[#,{4,3}]}& /@Range[-3.0,-0.0,0.005]),None}},(*ErrorBarFunction\[Rule]Function[{coords,errs},{Line[{{coords+{0,errs[[2,2]]},coords},{coords+{0,errs[[2,1]]},coords}}],Line[{{coords+{errs[[1,2]],0},coords},{coords+{errs[[1,1]],0},coords}}]}],*)BaseStyle->texStyle,ImageSize->600]

xmin=-1.053;
xmax=-1.077;
ymin=10.45;
ymax=0.0;
dx=(xmax-xmin)/300;
dy=(ymax-ymin)/200;
E1fPSmSplot=ErrorListPlot[Table[{{M0T[[i]],stab[[i]][[2]][[1]]},ErrorBar[stab[[i]][[2]][[2]]]},{i,1,Length[M0T]}],PlotRange->{{xmin,xmax},{ymin,ymax}},PlotMarkers->{"\[EmptyUpTriangle]",15},Frame->True,FrameLabel->{MaTeX["am^{as}_0",Magnification->2],MaTeX["m_{\\rm{M}}/f_{\\rm{PS}}",Magnification->2]},PlotStyle->{Thickness[0.004],RGBColor[0,.5,0]},FrameStyle->Directive[Black],FrameTicks->{{({#,NumberForm[#,{2,1}]}& /@Range[0,19,1]),None},{({#,NumberForm[#,{4,3}]}& /@Range[-3.0,-0.0,0.005]),None}},(*ErrorBarFunction\[Rule]Function[{coords,errs},{Line[{{coords+{0,errs[[2,2]]},coords},{coords+{0,errs[[2,1]]},coords}}],Line[{{coords+{errs[[1,2]],0},coords},{coords+{errs[[1,1]],0},coords}}]}],*)BaseStyle->texStyle,ImageSize->600]

mpsmvmsfpsplot=Show[{E1fPSmSplot,E1fPSmVplot,E1fPSmPSplot(*,ContourPlot[x\[Equal]-1.068,{x,-1.05,-1.08},{y,0,3},ContourStyle\[Rule]Dashed]*)},PlotRange->{{-1.053,-1.077},{5.0,10.5}}]
Export[$ScriptCommandLine[[5]], mpsmvmsfpsplot];
