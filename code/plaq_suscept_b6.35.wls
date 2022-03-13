#!/usr/bin/env wolframscript

Needs["ErrorBarPlots`"]
Needs["PlotLegends`"]

<<MaTeX`
texStyle = {FontFamily -> "Times", FontSize -> 20}

(* T24L12, b6.35 *)

Lt=24;
Ls=12;

beta=6.35;
masT={-1.055,-1.06,-1.063,-1.064,-1.065,-1.066,-1.067,-1.068,-1.069,-1.07,-1.072,-1.075};
mf="-0.6";
Length[masT]

plaqRimport=Table[mas=masT[[j]];Import[StringJoin["processed_data/plaq_",ToString[Lt],"x",ToString[Ls],"x",ToString[Ls],"x",ToString[Ls],"b",ToString[beta],"mas",ToString[mas],"mf",ToString[mf],".txt"],"Table"],{j,1,Length[masT]}];
Table[ListPlot[Table[plaqRimport[[j]][[i]][[2]],{i,1,Length[plaqRimport[[j]]]}],Frame->True,Joined->True,PlotRange->All],{j,1,Length[masT]}]

DtrajT={16,20,27,27,36,40,25,34,43,32,(*16,*)22,30};
dtrajT=Round[DtrajT/3-1]

traj0T={201,201,401,401,401,201,101,101,301,101,(*201,*)201,201};
Do[traj0=traj0T[[j]];dtraj=DtrajT[[j]];
plaqimport=Table[plaqRimport[[j]][[dtraj*i+traj0]][[2]],{i,1,(Length[plaqRimport[[j]]]-traj0)/dtraj}];plaqmean=Mean[plaqimport];(*plaqsuscept=Table[(plaqimport[[i]]-plaqmean)^2,{i,1,Length[plaqimport]}];*)
Nconf=Length[plaqimport];
Nboot=200;
rndi=Table[Table[Round[RandomReal[{0,1}] (Nconf-1)+1],{j,Nboot}],{i,Nconf}];
plaqbootT=Table[Mean[Table[plaqimport[[rndi[[i]][[j]]]],{i,Nconf}]],{j,Nboot}];plaqsusbootT=Table[Mean[Table[24 12^3 (plaqimport[[rndi[[i]][[j]]]]-plaqmean)^2,{i,Nconf}]],{j,Nboot}];
plaqRdata[j]={masT[[j]],Mean[plaqbootT],StandardDeviation[plaqbootT]};plaqsusRdata[j]={masT[[j]],Mean[plaqsusbootT],StandardDeviation[plaqsusbootT]},{j,1,Length[masT]}]

Table[plaqRdata[i],{i,Length[masT]}]
Table[plaqsusRdata[i],{i,Length[masT]}]

plaqT24L12b6p35plot=ErrorListPlot[Table[{{plaqRdata[j][[1]],plaqRdata[j][[2]]},ErrorBar[plaqRdata[j][[3]]]},{j,1,Length[masT]}],PlotRange->{{-1.077,-1.053},{.52,.568}},Frame->True,FrameLabel->{MaTeX["am_0^{as}",Magnification->2],MaTeX["\\langle \\mathcal{P} \\rangle",Magnification->2]},PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->{Thickness[0.004],RGBColor[0,0,1]},FrameStyle->Directive[Black],BaseStyle->texStyle,ImageSize->500]
plaqsusT24L12b6p35plot=ErrorListPlot[Table[{{plaqsusRdata[j][[1]],plaqsusRdata[j][[2]]},ErrorBar[plaqsusRdata[j][[3]]]},{j,1,Length[masT]}],PlotRange->{{-1.077,-1.053},{0,.42}},Frame->True,FrameLabel->{MaTeX["am_0^{as}",Magnification->2],MaTeX["\\chi_{\\textrm{plaq}}",Magnification->2]},PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->{Thickness[0.004],RGBColor[0,0,1]},FrameStyle->Directive[Black],BaseStyle->texStyle,ImageSize->500]

Export[$ScriptCommandLine[[2]],plaqT24L12b6p35plot]
Export[$ScriptCommandLine[[3]],plaqsusT24L12b6p35plot]
