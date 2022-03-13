#!/usr/bin/env wolframscript

Needs["ErrorBarPlots`"]
Needs["PlotLegends`"]

texStyle = {FontFamily -> "Times", FontSize -> 20}
<<MaTeX`

(* L8, b6.0 *)

Ls=8;

betaT={"6.0"};
masT={-1.25};
mf="-0.6";

plaqRimport=Table[mas=masT[[j]];beta=betaT[[j]];Import[StringJoin["processed_data/plaq_",ToString[Ls],"x",ToString[Ls],"x",ToString[Ls],"x",ToString[Ls],"b",ToString[beta],"mas",ToString[mas],"mf",ToString[mf],"_random.txt"],"Table"],{j,1,Length[masT]}];
plaqUimport=Table[mas=masT[[j]];beta=betaT[[j]];Import[StringJoin["processed_data/plaq_",ToString[Ls],"x",ToString[Ls],"x",ToString[Ls],"x",ToString[Ls],"b",ToString[beta],"mas",ToString[mas],"mf",ToString[mf],"_unit.txt"],"Table"],{j,1,Length[masT]}];
Table[ListPlot[{Table[plaqUimport[[j]][[i]][[2]],{i,1,Length[plaqUimport[[j]]]}],Table[plaqRimport[[j]][[i]][[2]],{i,1,Length[plaqRimport[[j]]]}]},Frame->True,Joined->True,PlotRange->All],{j,1,Length[masT]}]

traj0T={51};
Do[traj0=traj0T[[j]];dtraj=2;
plaqimport=Table[plaqUimport[[j]][[dtraj*i+traj0]][[2]],{i,1,(Length[plaqUimport[[j]]]-traj0)/dtraj}];plaqmean=Mean[plaqimport];(*plaqsuscept=Table[(plaqimport[[i]]-plaqmean)^2,{i,1,Length[plaqimport]}];*)
Nconf=Length[plaqimport];
Nboot=200;
rndi=Table[Table[Round[RandomReal[{0,1}] (Nconf-1)+1],{j,Nboot}],{i,Nconf}];
plaqbootT=Table[Mean[Table[plaqimport[[rndi[[i]][[j]]]],{i,Nconf}]],{j,Nboot}];plaqsusbootT=Table[Mean[Table[12^4 (plaqimport[[rndi[[i]][[j]]]]-plaqmean)^2,{i,Nconf}]],{j,Nboot}];
plaqUdata[j]={masT[[j]],Mean[plaqbootT],StandardDeviation[plaqbootT]};plaqsusUdata[j]={masT[[j]],Mean[plaqsusbootT],StandardDeviation[plaqsusbootT]},{j,1,Length[masT]}]

Table[plaqUdata[i],{i,Length[masT]}]
Table[plaqsusUdata[i],{i,Length[masT]}]

traj0T={151};
Do[traj0=traj0T[[j]];dtraj=5;
plaqimport=Table[plaqRimport[[j]][[dtraj*i+traj0]][[2]],{i,1,(Length[plaqRimport[[j]]]-traj0)/dtraj}];plaqmean=Mean[plaqimport];
Nconf=Length[plaqimport];
Nboot=200;
rndi=Table[Table[Round[RandomReal[{0,1}] (Nconf-1)+1],{j,Nboot}],{i,Nconf}];
plaqbootT=Table[Mean[Table[plaqimport[[rndi[[i]][[j]]]],{i,Nconf}]],{j,Nboot}];plaqsusbootT=Table[Mean[Table[12^4 (plaqimport[[rndi[[i]][[j]]]]-plaqmean)^2,{i,Nconf}]],{j,Nboot}];
plaqRdata[j]={masT[[j]],Mean[plaqbootT],StandardDeviation[plaqbootT]};plaqsusRdata[j]={masT[[j]],Mean[plaqsusbootT],StandardDeviation[plaqsusbootT]},{j,1,Length[masT]}]

Table[plaqRdata[i],{i,Length[masT]}]
Table[plaqsusRdata[i],{i,Length[masT]}]
deltaplaqT=Table[{plaqUdata[i][[1]],plaqUdata[i][[2]]-plaqRdata[i][[2]],Sqrt[plaqUdata[i][[3]]^2+plaqRdata[i][[3]]^2]},{i,Length[masT]}]

(* L8, b6.1 *)

Ls=8;

betaT={6.1};
masT={-1.2};
mf="-0.6";

plaqRimport=Table[mas=masT[[j]];beta=betaT[[j]];Import[StringJoin["processed_data/plaq_",ToString[Ls],"x",ToString[Ls],"x",ToString[Ls],"x",ToString[Ls],"b",ToString[beta],"mas",ToString[mas],"mf",ToString[mf],"_random.txt"],"Table"],{j,1,Length[masT]}];
plaqUimport=Table[mas=masT[[j]];beta=betaT[[j]];Import[StringJoin["processed_data/plaq_",ToString[Ls],"x",ToString[Ls],"x",ToString[Ls],"x",ToString[Ls],"b",ToString[beta],"mas",ToString[mas],"mf",ToString[mf],"_unit.txt"],"Table"],{j,1,Length[masT]}];
Table[ListPlot[{Table[plaqUimport[[j]][[i]][[2]],{i,1,Length[plaqUimport[[j]]]}],Table[plaqRimport[[j]][[i]][[2]],{i,1,Length[plaqRimport[[j]]]}]},Frame->True,Joined->True,PlotRange->All],{j,1,Length[masT]}]
traj0T={101};
Do[traj0=traj0T[[j]];dtraj=2;
plaqimport=Table[plaqUimport[[j]][[dtraj*i+traj0]][[2]],{i,1,(Length[plaqUimport[[j]]]-traj0)/dtraj}];plaqmean=Mean[plaqimport];(*plaqsuscept=Table[(plaqimport[[i]]-plaqmean)^2,{i,1,Length[plaqimport]}];*)
Nconf=Length[plaqimport];
Nboot=200;
rndi=Table[Table[Round[RandomReal[{0,1}] (Nconf-1)+1],{j,Nboot}],{i,Nconf}];
plaqbootT=Table[Mean[Table[plaqimport[[rndi[[i]][[j]]]],{i,Nconf}]],{j,Nboot}];plaqsusbootT=Table[Mean[Table[12^4 (plaqimport[[rndi[[i]][[j]]]]-plaqmean)^2,{i,Nconf}]],{j,Nboot}];
plaqUdata[j]={masT[[j]],Mean[plaqbootT],StandardDeviation[plaqbootT]};plaqsusUdata[j]={masT[[j]],Mean[plaqsusbootT],StandardDeviation[plaqsusbootT]},{j,1,Length[masT]}]

Table[plaqUdata[i],{i,Length[masT]}]
Table[plaqsusUdata[i],{i,Length[masT]}]

traj0T={101};
Do[traj0=traj0T[[j]];dtraj=6;
plaqimport=Table[plaqRimport[[j]][[dtraj*i+traj0]][[2]],{i,1,(Length[plaqRimport[[j]]]-traj0)/dtraj}];plaqmean=Mean[plaqimport];
Nconf=Length[plaqimport];
Nboot=200;
rndi=Table[Table[Round[RandomReal[{0,1}] (Nconf-1)+1],{j,Nboot}],{i,Nconf}];
plaqbootT=Table[Mean[Table[plaqimport[[rndi[[i]][[j]]]],{i,Nconf}]],{j,Nboot}];plaqsusbootT=Table[Mean[Table[12^4 (plaqimport[[rndi[[i]][[j]]]]-plaqmean)^2,{i,Nconf}]],{j,Nboot}];
plaqRdata[j]={masT[[j]],Mean[plaqbootT],StandardDeviation[plaqbootT]};plaqsusRdata[j]={masT[[j]],Mean[plaqsusbootT],StandardDeviation[plaqsusbootT]},{j,1,Length[masT]}]

Table[plaqRdata[i],{i,Length[masT]}]
Table[plaqsusRdata[i],{i,Length[masT]}]
deltaplaqT=Table[{plaqUdata[i][[1]],plaqUdata[i][[2]]-plaqRdata[i][[2]],Sqrt[plaqUdata[i][[3]]^2+plaqRdata[i][[3]]^2]},{i,Length[masT]}]


(* L8, b6.2 *)

Ls=8;

beta=6.2;
masT={-1.15};
mf="-0.6";

plaqRimport=Table[mas=masT[[j]];Import[StringJoin["processed_data/plaq_",ToString[Ls],"x",ToString[Ls],"x",ToString[Ls],"x",ToString[Ls],"b",ToString[beta],"mas",ToString[mas],"mf",ToString[mf],"_random.txt"],"Table"],{j,1,Length[masT]}];
plaqUimport=Table[mas=masT[[j]];Import[StringJoin["processed_data/plaq_",ToString[Ls],"x",ToString[Ls],"x",ToString[Ls],"x",ToString[Ls],"b",ToString[beta],"mas",ToString[mas],"mf",ToString[mf],"_unit.txt"],"Table"],{j,1,Length[masT]}];
Table[ListPlot[{Table[plaqUimport[[j]][[i]][[2]],{i,51,Length[plaqUimport[[j]]]}],Table[plaqRimport[[j]][[i]][[2]],{i,51,Length[plaqRimport[[j]]]}]},Frame->True,Joined->True,PlotRange->All],{j,1,Length[masT]}]

traj0T={51};
Do[traj0=traj0T[[j]];dtraj=5;
plaqimport=Table[plaqUimport[[j]][[dtraj*i+traj0]][[2]],{i,1,(Length[plaqUimport[[j]]]-traj0)/dtraj}];plaqmean=Mean[plaqimport];(*plaqsuscept=Table[(plaqimport[[i]]-plaqmean)^2,{i,1,Length[plaqimport]}];*)
Nconf=Length[plaqimport];
Nboot=200;
rndi=Table[Table[Round[RandomReal[{0,1}] (Nconf-1)+1],{j,Nboot}],{i,Nconf}];
plaqbootT=Table[Mean[Table[plaqimport[[rndi[[i]][[j]]]],{i,Nconf}]],{j,Nboot}];plaqsusbootT=Table[Mean[Table[8^4 (plaqimport[[rndi[[i]][[j]]]]-plaqmean)^2,{i,Nconf}]],{j,Nboot}];
plaqUdata[j]={masT[[j]],Mean[plaqbootT],StandardDeviation[plaqbootT]};plaqsusUdata[j]={masT[[j]],Mean[plaqsusbootT],StandardDeviation[plaqsusbootT]},{j,1,Length[masT]}]

Table[plaqUdata[i],{i,Length[masT]}]
Table[plaqsusUdata[i],{i,Length[masT]}]

traj0T={51};
Do[traj0=traj0T[[j]];dtraj=7;
plaqimport=Table[plaqRimport[[j]][[dtraj*i+traj0]][[2]],{i,1,(Length[plaqRimport[[j]]]-traj0)/dtraj}];plaqmean=Mean[plaqimport];
Nconf=Length[plaqimport];
Nboot=200;
rndi=Table[Table[Round[RandomReal[{0,1}] (Nconf-1)+1],{j,Nboot}],{i,Nconf}];
plaqbootT=Table[Mean[Table[plaqimport[[rndi[[i]][[j]]]],{i,Nconf}]],{j,Nboot}];plaqsusbootT=Table[Mean[Table[8^4 (plaqimport[[rndi[[i]][[j]]]]-plaqmean)^2,{i,Nconf}]],{j,Nboot}];
plaqRdata[j]={masT[[j]],Mean[plaqbootT],StandardDeviation[plaqbootT]};plaqsusRdata[j]={masT[[j]],Mean[plaqsusbootT],StandardDeviation[plaqsusbootT]},{j,1,Length[masT]}]

Table[plaqRdata[i],{i,Length[masT]}]
Table[plaqsusRdata[i],{i,Length[masT]}]
deltaplaqT=Table[{plaqUdata[i][[1]],plaqUdata[i][[2]]-plaqRdata[i][[2]],Sqrt[plaqUdata[i][[3]]^2+plaqRdata[i][[3]]^2]},{i,Length[masT]}]

ErrorListPlot[Table[{{deltaplaqT[[j]][[1]],deltaplaqT[[j]][[2]]},ErrorBar[deltaplaqT[[j]][[3]]]},{j,1,Length[masT]}],PlotRange->{{-0.9,-0.4},{0,.12}},Frame->True,AxesStyle->Black,LabelStyle->Directive[20,Black],FrameStyle->Black,FrameLabel->{"\!\(\*SubsuperscriptBox[\(am\), \(0\), \(as\)]\)","<\[EmptySquare]>"},PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[1,0,1],ImageSize->500]

plaqL8b6p2plot=Show[ErrorListPlot[Table[{{plaqUdata[j][[1]],plaqUdata[j][[2]]},ErrorBar[plaqUdata[j][[3]]]},{j,1,Length[masT]}],PlotRange->{{-1.3,-1.1},{0.47,.61}},Frame->True,AxesStyle->Black,LabelStyle->Directive[20,Black],FrameStyle->Black,FrameLabel->{"\!\(\*SubsuperscriptBox[\(am\), \(0\), \(as\)]\)","<\[EmptySquare]>"},PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[1,0,1],ImageSize->500],ErrorListPlot[Table[{{plaqRdata[j][[1]],plaqRdata[j][[2]]},ErrorBar[plaqRdata[j][[3]]]},{j,1,Length[masT]}],PlotRange->{{-1.7,.1},{.3,.65}},Frame->True,AxesStyle->Black,LabelStyle->Directive[24,Black],FrameStyle->{Black},FrameLabel->{"\!\(\*SubscriptBox[\(am\), \(0\)]\)","<\[EmptySquare]>"},PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[0,.5,0],ImageSize->600]]
plaqsusL8b6p4mf0p5plot=Show[ErrorListPlot[Table[{{plaqsusUdata[j][[1]],plaqsusUdata[j][[2]]},ErrorBar[plaqsusUdata[j][[3]]]},{j,1,Length[masT]}],PlotRange->{{-1.15,-1.075},{0,1.0}},Frame->True,AxesStyle->Black,LabelStyle->Directive[20,Black],FrameStyle->Black,FrameLabel->{"\!\(\*SubsuperscriptBox[\(am\), \(0\), \(as\)]\)","<\[EmptySquare]>"},PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[1,0,1],ImageSize->500],ErrorListPlot[Table[{{plaqsusRdata[j][[1]],plaqsusRdata[j][[2]]},ErrorBar[plaqsusRdata[j][[3]]]},{j,1,Length[masT]}],PlotRange->{{-1.7,.1},{0,.55}},Frame->True,AxesStyle->Black,LabelStyle->Directive[24,Black],FrameStyle->{Black},FrameLabel->{"\!\(\*SubscriptBox[\(am\), \(0\)]\)","<\[EmptySquare]>"},PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[0,.5,0],ImageSize->600]]


(* L12, b6.28 *)

Ls=12;

beta=6.28;
masT={-1.108};
mf="-0.6";

plaqRimport=Table[mas=masT[[j]];Import[StringJoin["processed_data/plaq_",ToString[Ls],"x",ToString[Ls],"x",ToString[Ls],"x",ToString[Ls],"b",ToString[beta],"mas",ToString[mas],"mf",ToString[mf],"_random.txt"],"Table"],{j,1,Length[masT]}];
plaqUimport=Table[mas=masT[[j]];Import[StringJoin["processed_data/plaq_",ToString[Ls],"x",ToString[Ls],"x",ToString[Ls],"x",ToString[Ls],"b",ToString[beta],"mas",ToString[mas],"mf",ToString[mf],"_unit.txt"],"Table"],{j,1,Length[masT]}];
Table[ListPlot[{Table[plaqUimport[[j]][[i]][[2]],{i,51,Length[plaqUimport[[j]]]}],Table[plaqRimport[[j]][[i]][[2]],{i,51,Length[plaqRimport[[j]]]}]},Frame->True,Joined->True,PlotRange->All],{j,1,Length[masT]}]

traj0T={500};
Do[traj0=traj0T[[j]];dtraj=10;
plaqimport=Table[plaqUimport[[j]][[dtraj*i+traj0]][[2]],{i,1,(Length[plaqUimport[[j]]]-traj0)/dtraj}];plaqmean=Mean[plaqimport];(*plaqsuscept=Table[(plaqimport[[i]]-plaqmean)^2,{i,1,Length[plaqimport]}];*)
Nconf=Length[plaqimport];
Nboot=200;
rndi=Table[Table[Round[RandomReal[{0,1}] (Nconf-1)+1],{j,Nboot}],{i,Nconf}];
plaqbootT=Table[Mean[Table[plaqimport[[rndi[[i]][[j]]]],{i,Nconf}]],{j,Nboot}];plaqsusbootT=Table[Mean[Table[12^4 (plaqimport[[rndi[[i]][[j]]]]-plaqmean)^2,{i,Nconf}]],{j,Nboot}];
plaqUdata[j]={masT[[j]],Mean[plaqbootT],StandardDeviation[plaqbootT]};plaqsusUdata[j]={masT[[j]],Mean[plaqsusbootT],StandardDeviation[plaqsusbootT]},{j,1,Length[masT]}]

Table[plaqUdata[i],{i,Length[masT]}]
Table[plaqsusUdata[i],{i,Length[masT]}]

traj0T={500};
Do[traj0=traj0T[[j]];dtraj=10;
plaqimport=Table[plaqRimport[[j]][[dtraj*i+traj0]][[2]],{i,1,(Length[plaqRimport[[j]]]-traj0)/dtraj}];plaqmean=Mean[plaqimport];
Nconf=Length[plaqimport];
Nboot=200;
rndi=Table[Table[Round[RandomReal[{0,1}] (Nconf-1)+1],{j,Nboot}],{i,Nconf}];
plaqbootT=Table[Mean[Table[plaqimport[[rndi[[i]][[j]]]],{i,Nconf}]],{j,Nboot}];plaqsusbootT=Table[Mean[Table[12^4 (plaqimport[[rndi[[i]][[j]]]]-plaqmean)^2,{i,Nconf}]],{j,Nboot}];
plaqRdata[j]={masT[[j]],Mean[plaqbootT],StandardDeviation[plaqbootT]};plaqsusRdata[j]={masT[[j]],Mean[plaqsusbootT],StandardDeviation[plaqsusbootT]},{j,1,Length[masT]}]

Table[plaqRdata[i],{i,Length[masT]}]
Table[plaqsusRdata[i],{i,Length[masT]}]
deltaplaqT=Table[{plaqUdata[i][[1]],plaqUdata[i][[2]]-plaqRdata[i][[2]],Sqrt[plaqUdata[i][[3]]^2+plaqRdata[i][[3]]^2]},{i,Length[masT]}]


(* L12, b6.3 *)

Ls=12;

beta=6.3;
masT={-1.098};
mf="-0.6";

plaqRimport=Table[mas=masT[[j]];Import[StringJoin["processed_data/plaq_",ToString[Ls],"x",ToString[Ls],"x",ToString[Ls],"x",ToString[Ls],"b",ToString[beta],"mas",ToString[mas],"mf",ToString[mf],"_random.txt"],"Table"],{j,1,Length[masT]}];
plaqUimport=Table[mas=masT[[j]];Import[StringJoin["processed_data/plaq_",ToString[Ls],"x",ToString[Ls],"x",ToString[Ls],"x",ToString[Ls],"b",ToString[beta],"mas",ToString[mas],"mf",ToString[mf],"_unit.txt"],"Table"],{j,1,Length[masT]}];
Table[ListPlot[{Table[plaqUimport[[j]][[i]][[2]],{i,51,Length[plaqUimport[[j]]]}],Table[plaqRimport[[j]][[i]][[2]],{i,51,Length[plaqRimport[[j]]]}]},Frame->True,Joined->True,PlotRange->All],{j,1,Length[masT]}]

traj0T={801};
Do[traj0=traj0T[[j]];dtraj=20;
plaqimport=Table[plaqUimport[[j]][[dtraj*i+traj0]][[2]],{i,1,(Length[plaqUimport[[j]]]-traj0)/dtraj}];plaqmean=Mean[plaqimport];(*plaqsuscept=Table[(plaqimport[[i]]-plaqmean)^2,{i,1,Length[plaqimport]}];*)
Nconf=Length[plaqimport];
Nboot=200;
rndi=Table[Table[Round[RandomReal[{0,1}] (Nconf-1)+1],{j,Nboot}],{i,Nconf}];
plaqbootT=Table[Mean[Table[plaqimport[[rndi[[i]][[j]]]],{i,Nconf}]],{j,Nboot}];plaqsusbootT=Table[Mean[Table[12^4 (plaqimport[[rndi[[i]][[j]]]]-plaqmean)^2,{i,Nconf}]],{j,Nboot}];
plaqUdata[j]={masT[[j]],Mean[plaqbootT],StandardDeviation[plaqbootT]};plaqsusUdata[j]={masT[[j]],Mean[plaqsusbootT],StandardDeviation[plaqsusbootT]},{j,1,Length[masT]}]

Table[plaqUdata[i],{i,Length[masT]}]
Table[plaqsusUdata[i],{i,Length[masT]}]

traj0T={801};
Do[traj0=traj0T[[j]];dtraj=20;
plaqimport=Table[plaqRimport[[j]][[dtraj*i+traj0]][[2]],{i,1,(Length[plaqRimport[[j]]]-traj0)/dtraj}];plaqmean=Mean[plaqimport];
Nconf=Length[plaqimport];
Nboot=200;
rndi=Table[Table[Round[RandomReal[{0,1}] (Nconf-1)+1],{j,Nboot}],{i,Nconf}];
plaqbootT=Table[Mean[Table[plaqimport[[rndi[[i]][[j]]]],{i,Nconf}]],{j,Nboot}];plaqsusbootT=Table[Mean[Table[12^4 (plaqimport[[rndi[[i]][[j]]]]-plaqmean)^2,{i,Nconf}]],{j,Nboot}];
plaqRdata[j]={masT[[j]],Mean[plaqbootT],StandardDeviation[plaqbootT]};plaqsusRdata[j]={masT[[j]],Mean[plaqsusbootT],StandardDeviation[plaqsusbootT]},{j,1,Length[masT]}]

Table[plaqRdata[i],{i,Length[masT]}]
Table[plaqsusRdata[i],{i,Length[masT]}]
deltaplaqT=Table[{plaqUdata[i][[1]],Abs[plaqUdata[i][[2]]-plaqRdata[i][[2]]],Sqrt[plaqUdata[i][[3]]^2+plaqRdata[i][[3]]^2]},{i,Length[masT]}]


(* Plot *)

DPT={{6.0,0.10624469677755427`,0.0007743652803297571`},{6.1,0.09027853517379925`,0.0005404913299829856`},{6.2,0.06749452464696648`,0.0005730320614556248`}};
DPL8plot=ErrorListPlot[Table[{{DPT[[j]][[1]],DPT[[j]][[2]]},ErrorBar[DPT[[j]][[3]]]},{j,1,Length[DPT]}],PlotRange->{{5.9,6.42},{0,.125}},Frame->True,AxesStyle->Black,LabelStyle->Directive[22,FontFamily->"Helvetica"],FrameStyle->Black,FrameLabel->{MaTeX["\\beta",Magnification->2],MaTeX["\\delta_{\\langle \\mathcal{P} \\rangle}",Magnification->2]},PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[1,0,0],ImageSize->600]
DPT={{6.28,0.03299430235309997`,0.0008022680588982607`},{6.3,0.001179472777758761`,0.0006605620881986803`}};
DPL12plot=ErrorListPlot[Table[{{DPT[[j]][[1]],DPT[[j]][[2]]},ErrorBar[DPT[[j]][[3]]]},{j,1,Length[DPT]}],PlotRange->{{5.9,6.42},{0,.125}},Frame->True,AxesStyle->Black,FrameStyle->Black,FrameLabel->{MaTeX["\\beta",Magnification->2],MaTeX["\\delta_{\\langle \\mathcal{P} \\rangle}",Magnification->2]},PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[1,0,0],BaseStyle->texStyle,ImageSize->600]

Export[$ScriptCommandLine[[2]], Show[DPL12plot,DPL8plot]]
