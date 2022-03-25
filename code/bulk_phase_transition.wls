#!/usr/bin/env wolframscript

Needs["ErrorBarPlots`"];
Needs["PlotLegends`"];

<<MaTeX`
texStyle={FontFamily->"Times",FontSize->20};


(* L8, b6.4 *)

Ls=8;

beta=6.4;
masT={-1.01,-1.02,-1.025,-1.03,-1.035,-1.04,-1.045,-1.05,-1.06};
mf="-0.6";

plaqRimport=Table[mas=masT[[j]];Import[StringJoin["processed_data/plaq_",ToString[Ls],"x",ToString[Ls],"x",ToString[Ls],"x",ToString[Ls],"b",ToString[beta],"mas",ToString[mas],"mf",ToString[mf],"_random.txt"],"Table"],{j,1,Length[masT]}];
Table[ListPlot[{Table[plaqRimport[[j]][[i]][[2]],{i,101,Length[plaqRimport[[j]]]}]},Frame->True,Joined->True,PlotRange->All],{j,1,Length[masT]}]

traj0T={101,101,101,101,101,101,101,101,101};dtrajT={9,16,17,20,22,17,28,10,5};
Do[traj0=traj0T[[j]];dtraj=dtrajT[[j]];
plaqimport=Table[plaqRimport[[j]][[dtraj*i+traj0]][[2]],{i,1,(Length[plaqRimport[[j]]]-traj0)/dtraj}];plaqmean=Mean[plaqimport];
Nconf=Length[plaqimport];
Nboot=100;
rndi=Table[Table[Round[RandomReal[{0,1}] (Nconf-1)+1],{j,Nboot}],{i,Nconf}];
plaqbootT=Table[Mean[Table[plaqimport[[rndi[[i]][[j]]]],{i,Nconf}]],{j,Nboot}];plaqsusbootT=Table[Mean[Table[8^4 (plaqimport[[rndi[[i]][[j]]]]-plaqmean)^2,{i,Nconf}]],{j,Nboot}];
plaqRdata[j]={masT[[j]],Mean[plaqbootT],StandardDeviation[plaqbootT]};plaqsusRdata[j]={masT[[j]],Mean[plaqsusbootT],StandardDeviation[plaqsusbootT]},{j,1,Length[masT]}]


Table[plaqRdata[i],{i,Length[masT]}]
Table[plaqsusRdata[i],{i,Length[masT]}]
plaqL8b6p4plot=Show[(*ErrorListPlot[Table[{{plaqUdata[j][[1]],plaqUdata[j][[2]]},ErrorBar[plaqUdata[j][[3]]]},{j,1,Length[masT]}],PlotRange\[Rule]{{-1.1,-1.0},{0.47,.61}},Frame\[Rule]True,AxesStyle\[Rule]Black,LabelStyle\[Rule]Directive[20,Black],FrameStyle\[Rule]Black,FrameLabel\[Rule]{"Subsuperscript[am, 0, as]","<\[EmptySquare]>"},PlotMarkers\[Rule]{"\[EmptyCircle]",15},PlotStyle\[Rule]RGBColor[1,0,1],ImageSize\[Rule]500],*)ErrorListPlot[Table[{{plaqRdata[j][[1]],plaqRdata[j][[2]]},ErrorBar[plaqRdata[j][[3]]]},{j,1,Length[masT]}],PlotRange->{{-1.08,-1.005},{.52,.585}},Frame->True,FrameLabel->{MaTeX["am_0^{as}",Magnification->2],MaTeX["\\langle \\mathcal{P} \\rangle",Magnification->2]},PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[1,0,0],FrameStyle->Directive[Black],BaseStyle->texStyle,ImageSize->600]]
plaqsusL8b6p4plot=Show[ErrorListPlot[Table[{{plaqsusRdata[j][[1]],plaqsusRdata[j][[2]]},ErrorBar[plaqsusRdata[j][[3]]]},{j,1,Length[masT]}],PlotRange->{{-1.08,-1.0},{0,0.3}},Frame->True,AxesStyle->Black,LabelStyle->Directive[24,Black],FrameStyle->{Black},FrameLabel->{MaTeX["a\,m_0^{as}",Magnification->2],MaTeX["\\chi_{\\textrm{plaq}}",Magnification->2]},PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[1,0,0],ImageSize->600]]


(* L12, b6.4 *)

Ls=12;

beta=6.4;
masT={-1.01,-1.02,-1.025,-1.03,-1.035,-1.04,-1.045,-1.05,-1.06};
mf="-0.6";

plaqRimport=Table[mas=masT[[j]];Import[StringJoin["processed_data/plaq_",ToString[Ls],"x",ToString[Ls],"x",ToString[Ls],"x",ToString[Ls],"b",ToString[beta],"mas",ToString[mas],"mf",ToString[mf],"_random.txt"],"Table"],{j,1,Length[masT]}];
Table[ListPlot[{Table[plaqRimport[[j]][[i]][[2]],{i,101,Length[plaqRimport[[j]]]}]},Frame->True,Joined->True,PlotRange->All],{j,1,Length[masT]}]

traj0T={651,101,101,101,101,101,101,551,101};dtrajT={9,8,14,10,18,24,28,18,9};
Do[traj0=traj0T[[j]];dtraj=dtrajT[[j]];
plaqimport=Table[plaqRimport[[j]][[dtraj*i+traj0]][[2]],{i,1,(Length[plaqRimport[[j]]]-traj0)/dtraj}];plaqmean=Mean[plaqimport];
Nconf=Length[plaqimport];
Nboot=100;Print[Nconf];
rndi=Table[Table[Round[RandomReal[{0,1}] (Nconf-1)+1],{j,Nboot}],{i,Nconf}];
plaqbootT=Table[Mean[Table[plaqimport[[rndi[[i]][[j]]]],{i,Nconf}]],{j,Nboot}];plaqsusbootT=Table[Mean[Table[12^4 (plaqimport[[rndi[[i]][[j]]]]-plaqmean)^2,{i,Nconf}]],{j,Nboot}];
plaqRdata[j]={masT[[j]],Mean[plaqbootT],StandardDeviation[plaqbootT]};plaqsusRdata[j]={masT[[j]],Mean[plaqsusbootT],StandardDeviation[plaqsusbootT]},{j,1,Length[masT]}]


Table[plaqRdata[i],{i,Length[masT]}]
Table[plaqsusRdata[i],{i,Length[masT]}]
plaqL12b6p4plot=Show[(*ErrorListPlot[Table[{{plaqUdata[j][[1]],plaqUdata[j][[2]]},ErrorBar[plaqUdata[j][[3]]]},{j,1,Length[masT]}],PlotRange\[Rule]{{-1.1,-1.0},{0.47,.61}},Frame\[Rule]True,AxesStyle\[Rule]Black,LabelStyle\[Rule]Directive[20,Black],FrameStyle\[Rule]Black,FrameLabel\[Rule]{"Subsuperscript[am, 0, as]","<\[EmptySquare]>"},PlotMarkers\[Rule]{"\[EmptyCircle]",15},PlotStyle\[Rule]RGBColor[1,0,1],ImageSize\[Rule]500],*)ErrorListPlot[Table[{{plaqRdata[j][[1]],plaqRdata[j][[2]]},ErrorBar[plaqRdata[j][[3]]]},{j,1,Length[masT]}],PlotRange->{{-1.08,-1.005},{.52,.585}},Frame->True,FrameLabel->{MaTeX["am_0^{as}",Magnification->2],MaTeX["\\langle \\mathcal{P} \\rangle",Magnification->2]},PlotMarkers->{"\[EmptySquare]",18},PlotStyle->{Thickness[0.004],RGBColor[0,0,1]},FrameStyle->Directive[Black],BaseStyle->texStyle,ImageSize->600]]
plaqsusL12b6p4plot=Show[ErrorListPlot[Table[{{plaqsusRdata[j][[1]],plaqsusRdata[j][[2]]},ErrorBar[plaqsusRdata[j][[3]]]},{j,1,Length[masT]}],PlotRange->{{-1.08,-1.005},{0,.27}},Frame->True,FrameLabel->{MaTeX["am_0^{as}",Magnification->2],MaTeX["\\chi_{\\textrm{plaq}}",Magnification->2]},PlotMarkers->{"\[EmptySquare]",18},PlotStyle->{Thickness[0.004],RGBColor[0,0,1]},FrameStyle->Directive[Black],BaseStyle->texStyle,ImageSize->600]]


(* L16, b6.4 *)

Ls=16;

beta=6.4;
masT={-1.01,-1.02,-1.025,-1.03,-1.035,-1.04,-1.045,-1.05,-1.06};
mf="-0.6";

plaqRimport=Table[mas=masT[[j]];Import[StringJoin["processed_data/plaq_",ToString[Ls],"x",ToString[Ls],"x",ToString[Ls],"x",ToString[Ls],"b",ToString[beta],"mas",ToString[mas],"mf",ToString[mf],"_random.txt"],"Table"],{j,1,Length[masT]}];
Table[ListPlot[{Table[plaqRimport[[j]][[i]][[2]],{i,101,Length[plaqRimport[[j]]]}]},Frame->True,Joined->True,PlotRange->All],{j,1,Length[masT]}]

traj0T={101,101,101,101,101,101,101,401,101};dtrajT={13,11,13,16,16,23,20,16,12};
Do[traj0=traj0T[[j]];dtraj=dtrajT[[j]];
plaqimport=Table[plaqRimport[[j]][[dtraj*i+traj0]][[2]],{i,1,(Length[plaqRimport[[j]]]-traj0)/dtraj}];plaqmean=Mean[plaqimport];
Nconf=Length[plaqimport];
Nboot=100;Print[Nconf];
rndi=Table[Table[Round[RandomReal[{0,1}] (Nconf-1)+1],{j,Nboot}],{i,Nconf}];
plaqbootT=Table[Mean[Table[plaqimport[[rndi[[i]][[j]]]],{i,Nconf}]],{j,Nboot}];plaqsusbootT=Table[Mean[Table[16^4 (plaqimport[[rndi[[i]][[j]]]]-plaqmean)^2,{i,Nconf}]],{j,Nboot}];
plaqRdata[j]={masT[[j]],Mean[plaqbootT],StandardDeviation[plaqbootT]};plaqsusRdata[j]={masT[[j]],Mean[plaqsusbootT],StandardDeviation[plaqsusbootT]},{j,1,Length[masT]}]


Table[plaqRdata[i],{i,Length[masT]}]
Table[plaqsusRdata[i],{i,Length[masT]}]

plaqL16b6p4plot=Show[(*ErrorListPlot[Table[{{plaqUdata[j][[1]],plaqUdata[j][[2]]},ErrorBar[plaqUdata[j][[3]]]},{j,1,Length[masT]}],PlotRange\[Rule]{{-1.1,-1.0},{0.47,.61}},Frame\[Rule]True,AxesStyle\[Rule]Black,LabelStyle\[Rule]Directive[20,Black],FrameStyle\[Rule]Black,FrameLabel\[Rule]{"Subsuperscript[am, 0, as]","<\[EmptySquare]>"},PlotMarkers\[Rule]{"\[EmptyCircle]",15},PlotStyle\[Rule]RGBColor[1,0,1],ImageSize\[Rule]500],*)ErrorListPlot[Table[{{plaqRdata[j][[1]],plaqRdata[j][[2]]},ErrorBar[plaqRdata[j][[3]]]},{j,1,Length[masT]}],PlotRange->{{-1.08,-1.005},{.52,.585}},Frame->True,FrameLabel->{MaTeX["am_0^{as}",Magnification->2],MaTeX["\\langle \\mathcal{P} \\rangle",Magnification->2]},PlotMarkers->{"\[EmptyUpTriangle]",18},PlotStyle->{Thickness[0.004],RGBColor[0,.5,0]},FrameStyle->Directive[Black],BaseStyle->texStyle,ImageSize->600]]
plaqsusL16b6p4plot=Show[ErrorListPlot[Table[{{plaqsusRdata[j][[1]],plaqsusRdata[j][[2]]},ErrorBar[plaqsusRdata[j][[3]]]},{j,1,Length[masT]}],PlotRange->{{-1.08,-1.005},{0,.27}},Frame->True,FrameLabel->{MaTeX["a\,m_0^{as}",Magnification->2],MaTeX["\\chi_{\\textrm{plaq}}",Magnification->2]},PlotMarkers->{"\[EmptyUpTriangle]",18},PlotStyle->{Thickness[0.004],RGBColor[0,.5,0]},FrameStyle->Directive[Black],BaseStyle->texStyle,ImageSize->600]]

Export[$ScriptCommandLine[[2]], ShowLegend[Show[plaqsusL12b6p4plot,plaqsusL8b6p4plot,plaqsusL16b6p4plot],{{{Graphics[{RGBColor[1,0,0],Text[Style["\[EmptyCircle]",15]]}],Text[Style[MaTeX["{~8^4}",Magnification->1.7]]]},{Graphics[{RGBColor[0,0,1],Text[Style["\[EmptySquare]",18]]}],Text[Style[MaTeX["{12^4}",Magnification->1.7]]]},{Graphics[{RGBColor[0,.5,0],Text[Style["\[EmptyUpTriangle]",18]]}],Text[Style[MaTeX["{16^4}",Magnification->1.7]]]}},LegendPosition->{-0.63,0.2},LegendTextOffset->{-1.2,0},LegendSize->{0.25,.33},ShadowOffset->{0.0,0.0}}]](*final*)
Export[$ScriptCommandLine[[3]], ShowLegend[Show[plaqL12b6p4plot,plaqL8b6p4plot,plaqL16b6p4plot],{{{Graphics[{RGBColor[1,0,0],Text[Style["\[EmptyCircle]",15]]}],Text[Style[MaTeX["{~8^4}",Magnification->1.7]]]},{Graphics[{RGBColor[0,0,1],Text[Style["\[EmptySquare]",18]]}],Text[Style[MaTeX["{12^4}",Magnification->1.7]]]},{Graphics[{RGBColor[0,.5,0],Text[Style["\[EmptyUpTriangle]",18]]}],Text[Style[MaTeX["{16^4}",Magnification->1.7]]]}},LegendPosition->{-0.63,-0.3},LegendTextOffset->{-1.2,0},LegendSize->{0.25,.33},ShadowOffset->{0.0,0.0}}]](*final*)
