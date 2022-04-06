Needs["ErrorBarPlots`"]
Needs["PlotLegends`"]

<<MaTeX`


texStyle={FontFamily->"Times",FontSize->20};


(*\[Beta]=6.4*)

(*E(fig 4)*)

beta=6.4;
masT={-1.115,-1.12,-1.125,-1.13,-1.135,-1.14,-1.145};
mf="3.0";


plaqRimport=Table[mas=masT[[j]];Import[StringJoin["processed_data/plaq_8x8x8x8b",ToString[beta],"mas",ToString[mas],"mf",ToString[mf],"_random.txt"],"Table"],{j,1,Length[masT]}];
plaqUimport=Table[mas=masT[[j]];Import[StringJoin["processed_data/plaq_8x8x8x8b",ToString[beta],"mas",ToString[mas],"mf",ToString[mf],"_unit.txt"],"Table"],{j,1,Length[masT]}];
Table[ListPlot[{Table[plaqUimport[[j]][[i]][[2]],{i,1,Length[plaqUimport[[j]]]}],Table[plaqRimport[[j]][[i]][[2]],{i,1,Length[plaqRimport[[j]]]}]},Frame->True,Joined->True,PlotRange->All],{j,1,Length[masT]}]

DtrajT={4,5,5,8,2,5,2};(*The number of trajectories between adjacent configuration, corresponding to an autocorrelation length*)

traj0T={51,101,71,101,51,51,51};(*The number of trajectories required for thermalization*)
Do[traj0=traj0T[[j]];dtraj=DtrajT[[j]];
plaqimport=Table[plaqUimport[[j]][[dtraj*i+traj0]][[2]],{i,1,(Length[plaqUimport[[j]]]-traj0)/dtraj}];
Nconf=Length[plaqimport];
Nboot=200;
rndi=Table[Table[Round[RandomReal[{0,1}] (Nconf-1)+1],{j,Nboot}],{i,Nconf}];
plaqbootT=Table[Mean[Table[plaqimport[[rndi[[i]][[j]]]],{i,Nconf}]],{j,Nboot}];
plaqUdata[j]={masT[[j]],Mean[plaqbootT],StandardDeviation[plaqbootT]},{j,1,Length[masT]}]


Table[plaqUdata[i],{i,Length[masT]}]

DtrajT={4,4,5,7,5,12,2};(*The number of trajectories between adjacent configuration, corresponding to an autocorrelation length*)

traj0T={71,71,51,51,71,71,181};(*The number of trajectories required for thermalization*)
Do[traj0=traj0T[[j]];dtraj=DtrajT[[j]];
plaqimport=Table[plaqRimport[[j]][[dtraj*i+traj0]][[2]],{i,1,(Length[plaqRimport[[j]]]-traj0)/dtraj}];
Nconf=Length[plaqimport];
Nboot=200;
rndi=Table[Table[Round[RandomReal[{0,1}] (Nconf-1)+1],{j,Nboot}],{i,Nconf}];
plaqbootT=Table[Mean[Table[plaqimport[[rndi[[i]][[j]]]],{i,Nconf}]],{j,Nboot}];
plaqRdata[j]={masT[[j]],Mean[plaqbootT],StandardDeviation[plaqbootT]},{j,1,Length[masT]}]



Table[plaqRdata[i],{i,Length[masT]}]


plaqb6p4Eplot=Show[ErrorListPlot[Table[{{plaqUdata[j][[1]],plaqUdata[j][[2]]},ErrorBar[plaqUdata[j][[3]]]},{j,1,Length[masT]}],PlotRange->{{-1.155,-1.1075},{0.5,.59}},Frame->True,FrameLabel->{MaTeX["am_0^{as}",Magnification->2],MaTeX["\\langle \\mathcal{P} \\rangle",Magnification->2]},PlotMarkers->{"\[EmptySquare]",15},PlotStyle->{Thickness[0.004],RGBColor[0,0,1]},FrameStyle->Directive[Black],BaseStyle->texStyle,ImageSize->500],ErrorListPlot[Table[{{plaqRdata[j][[1]],plaqRdata[j][[2]]},ErrorBar[plaqRdata[j][[3]]]},{j,1,Length[masT]}],PlotRange->{{-1.7,.1},{.3,.65}},Frame->True,AxesStyle->Black,LabelStyle->Directive[24,Black],FrameStyle->{Black},FrameLabel->{"\!\(\*SubsuperscriptBox[\(am\), \(0\), \(as\)]\)","<\[EmptySquare]>"},PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[1,0,0],ImageSize->600]]

Export["plots/Fig4-5_mass_scan/mass_scan_avg_E.pdf", plaqb6p4Eplot]


(* D(figs 4 and 5) *)

beta=6.4;
masT={-1.095,-1.105(*,-1.108*),-1.109,-1.11(*,-1.111*),-1.112,-1.115,-1.12,-1.13,-1.14};
mf="0.0";

plaqRimport=Table[mas=masT[[j]];Import[StringJoin["processed_data/plaq_8x8x8x8b",ToString[beta],"mas",ToString[mas],"mf",ToString[mf],"_random.txt"],"Table"],{j,1,Length[masT]}];
plaqUimport=Table[mas=masT[[j]];Import[StringJoin["processed_data/plaq_8x8x8x8b",ToString[beta],"mas",ToString[mas],"mf",ToString[mf],"_unit.txt"],"Table"],{j,1,Length[masT]}];
Table[ListPlot[{Table[plaqUimport[[j]][[i]][[2]],{i,51,Length[plaqUimport[[j]]]}],Table[plaqRimport[[j]][[i]][[2]],{i,51,Length[plaqRimport[[j]]]}]},Frame->True,Joined->True,PlotRange->All],{j,1,Length[masT]}]

DtrajT={10,16,400,800(*,11*),7,7,5,2,2};(*The number of trajectories between adjacent configuration, corresponding to an autocorrelation length*)

traj0T={251,301,201,201(*,201*),201,201,101,51,51};(*The number of trajectories required for thermalization*)
Do[traj0=traj0T[[j]];dtraj=DtrajT[[j]];
plaqimport=Table[plaqUimport[[j]][[dtraj*i+traj0]][[2]],{i,1,(Length[plaqUimport[[j]]]-traj0)/dtraj}];(*plaqmean=Mean[plaqimport];*)(*plaqsuscept=Table[(plaqimport[[i]]-plaqmean)^2,{i,1,Length[plaqimport]}];*)
Nconf=Length[plaqimport];
Nboot=200;
rndi=Table[Table[Round[RandomReal[{0,1}] (Nconf-1)+1],{j,Nboot}],{i,Nconf}];
plaqbootT=Table[Mean[Table[plaqimport[[rndi[[i]][[j]]]],{i,Nconf}]],{j,Nboot}];(*plaqsusbootT=Table[Mean[Table[8^4 (plaqimport[[rndi[[i]][[j]]]]-plaqmean)^2,{i,Nconf}]],{j,Nboot}];*)
plaqUdata[j]={masT[[j]],Mean[plaqbootT],StandardDeviation[plaqbootT]}(*;plaqsusUdata[j]={masT[[j]],Mean[plaqsusbootT],StandardDeviation[plaqsusbootT]}*),{j,1,Length[masT]}]

Table[plaqUdata[i],{i,Length[masT]}]

DtrajT={9,14,400,800(*,17*),2,4,4,2,3};(*The number of trajectories between adjacent configuration, corresponding to an autocorrelation length*)

traj0T={201,201,201,201(*,701*),1201,201,201,81,71};(*The number of trajectories required for thermalization*)
Do[traj0=traj0T[[j]];dtraj=DtrajT[[j]];
plaqimport=Table[plaqRimport[[j]][[dtraj*i+traj0]][[2]],{i,1,(Length[plaqRimport[[j]]]-traj0)/dtraj}];(*plaqmean=Mean[plaqimport];*)
Nconf=Length[plaqimport];
Nboot=200;
rndi=Table[Table[Round[RandomReal[{0,1}] (Nconf-1)+1],{j,Nboot}],{i,Nconf}];
plaqbootT=Table[Mean[Table[plaqimport[[rndi[[i]][[j]]]],{i,Nconf}]],{j,Nboot}];(*plaqsusbootT=Table[Mean[Table[8^4 (plaqimport[[rndi[[i]][[j]]]]-plaqmean)^2,{i,Nconf}]],{j,Nboot}];*)
plaqRdata[j]={masT[[j]],Mean[plaqbootT],StandardDeviation[plaqbootT]}(*;plaqsusRdata[j]={masT[[j]],Mean[plaqsusbootT],StandardDeviation[plaqsusbootT]}*),{j,1,Length[masT]}]

Table[plaqRdata[i],{i,Length[masT]}]

plaqL8b6p4Dplot=Show[ErrorListPlot[Table[{{plaqUdata[j][[1]],plaqUdata[j][[2]]},ErrorBar[plaqUdata[j][[3]]]},{j,1,Length[masT]}],PlotRange->{{-1.15,-1.085},{0.5,.605}},Frame->True,FrameLabel->{MaTeX["am_0^{as}",Magnification->2],MaTeX["\\langle \\mathcal{P} \\rangle",Magnification->2]},PlotMarkers->{"\[EmptySquare]",15},PlotStyle->{Thickness[0.004],RGBColor[0,0,1]},FrameStyle->Directive[Black],BaseStyle->texStyle,ImageSize->500],ErrorListPlot[Table[{{plaqRdata[j][[1]],plaqRdata[j][[2]]},ErrorBar[plaqRdata[j][[3]]]},{j,1,Length[masT]}],PlotRange->{{-1.7,.1},{.3,.65}},Frame->True,AxesStyle->Black,LabelStyle->Directive[24,Black],FrameStyle->{Black},FrameLabel->{"\!\(\*SubscriptBox[\(am\), \(0\)]\)","<\[EmptySquare]>"},PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[1,0,0],ImageSize->600]]
plaqsusL8b6p4Dplot=Show[ErrorListPlot[Table[{{plaqsusUdata[j][[1]],plaqsusUdata[j][[2]]},ErrorBar[plaqsusUdata[j][[3]]]},{j,1,Length[masT]}],PlotRange->{{-1.15,-1.075},{0,0.55}},Frame->True,AxesStyle->Black,LabelStyle->Directive[20,Black],FrameStyle->Black,BaseStyle->texStyle,FrameLabel->{"\!\(\*SubsuperscriptBox[\(am\), \(0\), \(as\)]\)","<\[EmptySquare]>"},PlotMarkers->{"\[EmptySquare]",15},PlotStyle->RGBColor[0,0,1],ImageSize->500],ErrorListPlot[Table[{{plaqsusRdata[j][[1]],plaqsusRdata[j][[2]]},ErrorBar[plaqsusRdata[j][[3]]]},{j,1,Length[masT]}],PlotRange->{{-1.7,.1},{0,0.55}},Frame->True,AxesStyle->Black,LabelStyle->Directive[24,Black],FrameStyle->{Black},BaseStyle->texStyle,FrameLabel->{"\!\(\*SubscriptBox[\(am\), \(0\)]\)","<\[EmptySquare]>"},PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[1,0,0],ImageSize->600]]

plaqL8b6p4Dhistplot = Show[ ListPlot[Table[{4*i,plaqUimport[[4]][[i]][[2]]},{i,1,Length[plaqUimport[[4]]]}],PlotRange->{{-200,32300},{0.5,.61}},Frame->True,Joined->True,PlotRange->All,Frame->True,FrameLabel->{MaTeX["{\\rm{Trajectory}}",Magnification->2],MaTeX["\\mathcal{P}",Magnification->2]},PlotStyle->{Thickness[0.004],RGBColor[0,0,1]},FrameStyle->Directive[Black],BaseStyle->texStyle,ImageSize->500],ListPlot[Table[{4*i,plaqRimport[[4]][[i]][[2]]},{i,1,Length[plaqRimport[[4]]]}],Frame->True,Joined->True,PlotRange->All,Frame->True,FrameLabel->{MaTeX["am_0^{as}",Magnification->2],MaTeX["\\langle \\mathcal{P} \\rangle",Magnification->2]},PlotStyle->{Thickness[0.004],RGBColor[1,0,0]},FrameStyle->Directive[Black],BaseStyle->texStyle,ImageSize->500]]

Export["plots/Fig4-5_mass_scan/mass_scan_avg_D.pdf", plaqL8b6p4Dplot]
Export["plots/Fig4-5_mass_scan/mass_scan_hist_D.pdf", plaqL8b6p4Dhistplot]


(* C(figs 4 and 5) *)

beta=6.4;
masT={-0.79,-0.81,-0.82,-0.83,(*-0.833,*)-0.8335,(*-0.834,*)-0.835,-0.84,-0.85,-0.87};
mfT={-0.89,-0.91,-0.92,-0.93,(*-0.933,*)-0.9335,(*-0.934,*)-0.935,-0.94,-0.95,-0.97};

plaqRimport=Table[mas=masT[[j]];mf=mfT[[j]];Import[StringJoin["processed_data/plaq_8x8x8x8b",ToString[beta],"mas",ToString[mas],"mf",ToString[mf],"_random.txt"],"Table"],{j,1,Length[masT]}];

plaqUimport=Table[mas=masT[[j]];mf=mfT[[j]];Import[StringJoin["processed_data/plaq_8x8x8x8b",ToString[beta],"mas",ToString[mas],"mf",ToString[mf],"_unit.txt"],"Table"],{j,1,Length[masT]}];

Table[ListPlot[{Table[plaqUimport[[j]][[i]][[2]],{i,51,Length[plaqUimport[[j]]]}],Table[plaqRimport[[j]][[i]][[2]],{i,51,Length[plaqRimport[[j]]]}]},Frame->True,Joined->True,PlotRange->All],{j,1,Length[masT]}]

DtrajT={5,3,10,7,100,140,8,2,2};(*The number of trajectories between adjacent configuration, corresponding to an autocorrelation length*)

traj0T={51,81,101,351,201,201,101,51,51};(*The number of trajectories required for thermalization*)
Do[traj0=traj0T[[j]];dtraj=DtrajT[[j]];
plaqimport=Table[plaqUimport[[j]][[dtraj*i+traj0]][[2]],{i,1,(Length[plaqUimport[[j]]]-traj0)/dtraj}];
Nconf=Length[plaqimport];
Nboot=200;
rndi=Table[Table[Round[RandomReal[{0,1}] (Nconf-1)+1],{j,Nboot}],{i,Nconf}];
plaqbootT=Table[Mean[Table[plaqimport[[rndi[[i]][[j]]]],{i,Nconf}]],{j,Nboot}];
plaqUdata[j]={masT[[j]],mfT[[j]],Mean[plaqbootT],StandardDeviation[plaqbootT]},{j,1,Length[masT]}]

Table[plaqUdata[i],{i,Length[masT]}]

DtrajT={3,3,8,8,100,100,6,2,2};(*The number of trajectories between adjacent configuration, corresponding to an autocorrelation length*)

traj0T={51,81,101,251,201,201,101,71,71};(*The number of trajectories required for thermalization*)
Do[traj0=traj0T[[j]];dtraj=DtrajT[[j]];
plaqimport=Table[plaqRimport[[j]][[dtraj*i+traj0]][[2]],{i,1,(Length[plaqRimport[[j]]]-traj0)/dtraj}];
Nconf=Length[plaqimport];
Nboot=200;
rndi=Table[Table[Round[RandomReal[{0,1}] (Nconf-1)+1],{j,Nboot}],{i,Nconf}];
plaqbootT=Table[Mean[Table[plaqimport[[rndi[[i]][[j]]]],{i,Nconf}]],{j,Nboot}];
plaqRdata[j]={masT[[j]],mfT[[j]],Mean[plaqbootT],StandardDeviation[plaqbootT]},{j,1,Length[masT]}]

Table[plaqRdata[i],{i,Length[masT]}]

plaqL8b6p4Cplot=Show[ErrorListPlot[Table[{{plaqUdata[j][[1]],plaqUdata[j][[3]]},ErrorBar[plaqUdata[j][[4]]]},{j,1,Length[masT]}],PlotRange->{{-0.89,-0.77},{0.5,.585}},Frame->True,AxesStyle->Black,LabelStyle->Directive[20,Black],FrameStyle->Black,BaseStyle->texStyle,FrameLabel->{{MaTeX["\\langle \\mathcal{P} \\rangle",Magnification->2],None},{MaTeX["am_0^{as}",Magnification->2],MaTeX["am_0^{f}",Magnification->2]}},FrameTicks->{{Automatic,Automatic},{Automatic,{{-0.78,-0.88},{-0.8,-0.9},{-0.82,-0.92},{-0.84,-0.94},{-0.86,-0.96},{-0.88,-0.98}}}},PlotMarkers->{"\[EmptySquare]",15},PlotStyle->RGBColor[0,0,1],ImageSize->500],ErrorListPlot[Table[{{plaqRdata[j][[1]],plaqRdata[j][[3]]},ErrorBar[plaqRdata[j][[4]]]},{j,1,Length[masT]}],PlotRange->{{-1.7,.1},{.3,.65}},Frame->True,AxesStyle->Black,LabelStyle->Directive[24,Black],FrameStyle->{Black},BaseStyle->texStyle,FrameLabel->{"\!\(\*SubscriptBox[\(am\), \(0\)]\)","<\[EmptySquare]>"},PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[1,0,0],ImageSize->600]]

plaqL8b6p4Chistplot = Show[ ListPlot[Table[{4*i,plaqUimport[[5]][[i]][[2]]},{i,1,Length[plaqUimport[[5]]]}],PlotRange->{{-200,32300},{0.51,.585}},Frame->True,Joined->True,PlotRange->All,Frame->True,FrameLabel->{MaTeX["{\\rm{Trajectory}}",Magnification->2],MaTeX["\\mathcal{P}",Magnification->2]},PlotStyle->{Thickness[0.004],RGBColor[0,0,1]},FrameStyle->Directive[Black],BaseStyle->texStyle,BaseStyle->texStyle,ImageSize->500],ListPlot[Table[{4*i,plaqRimport[[5]][[i]][[2]]},{i,1,Length[plaqRimport[[5]]]}],Frame->True,Joined->True,PlotRange->All,Frame->True,FrameLabel->{MaTeX["am_0^{as}",Magnification->2],MaTeX["\\langle \\mathcal{P} \\rangle",Magnification->2]},PlotStyle->{Thickness[0.004],RGBColor[1,0,0]},FrameStyle->Directive[Black],BaseStyle->texStyle,ImageSize->500]]

Export["plots/Fig4-5_mass_scan/mass_scan_avg_C.pdf", plaqL8b6p4Cplot]
Export["plots/Fig4-5_mass_scan/mass_scan_hist_C.pdf", plaqL8b6p4Chistplot]





(* B(fig 4) *)

beta=6.4;
masT={"0.0"};
mfT={-1.1,-1.12,-1.13,-1.14,-1.15,-1.16,-1.18};

plaqRimport=Table[mas=masT[[1]];mf=mfT[[j]];Import[StringJoin["processed_data/plaq_8x8x8x8b",ToString[beta],"mas",ToString[mas],"mf",ToString[mf],"_random.txt"],"Table"],{j,1,Length[mfT]}];

mfT={-1.1,-1.12,-1.13,-1.14,-1.15,-1.16,-1.18};

plaqUimport=Table[mas=masT[[1]];mf=mfT[[j]];Import[StringJoin["processed_data/plaq_8x8x8x8b",ToString[beta],"mas",ToString[mas],"mf",ToString[mf],"_unit.txt"],"Table"],{j,1,Length[mfT]}];

Table[ListPlot[{Table[plaqUimport[[j]][[i]][[2]],{i,1,Length[plaqUimport[[j]]]}],Table[plaqRimport[[j]][[i]][[2]],{i,1,Length[plaqRimport[[j]]]}]},Frame->True,Joined->True,PlotRange->All],{j,1,Length[mfT]}]

DtrajT={4,6,5,5,5,2,2};(*The number of trajectories between adjacent configuration, corresponding to an autocorrelation length*)

traj0T={101,101,301,101,101,101,51};(*The number of trajectories required for thermalization*)
Do[traj0=traj0T[[j]];dtraj=DtrajT[[j]];
plaqimport=Table[plaqUimport[[j]][[dtraj*i+traj0]][[2]],{i,1,(Length[plaqUimport[[j]]]-traj0)/dtraj}];
Nconf=Length[plaqimport];
Nboot=200;
rndi=Table[Table[Round[RandomReal[{0,1}] (Nconf-1)+1],{j,Nboot}],{i,Nconf}];
plaqbootT=Table[Mean[Table[plaqimport[[rndi[[i]][[j]]]],{i,Nconf}]],{j,Nboot}];
plaqUdata[j]={masT[[1]],mfT[[j]],Mean[plaqbootT],StandardDeviation[plaqbootT]},{j,1,Length[mfT]}]

Table[plaqUdata[i],{i,Length[mfT]}]

DtrajT={4,5,6,6,4,2,2};(*The number of trajectories between adjacent configuration, corresponding to an autocorrelation length*)

traj0T={101,101,101,101,151,101,51};(*The number of trajectories required for thermalization*)
Do[traj0=traj0T[[j]];dtraj=DtrajT[[j]];
plaqimport=Table[plaqRimport[[j]][[dtraj*i+traj0]][[2]],{i,1,(Length[plaqRimport[[j]]]-traj0)/dtraj}];
Nconf=Length[plaqimport];
Nboot=200;
rndi=Table[Table[Round[RandomReal[{0,1}] (Nconf-1)+1],{j,Nboot}],{i,Nconf}];
plaqbootT=Table[Mean[Table[plaqimport[[rndi[[i]][[j]]]],{i,Nconf}]],{j,Nboot}];
plaqRdata[j]={masT[[1]],mfT[[j]],Mean[plaqbootT],StandardDeviation[plaqbootT]},{j,1,Length[mfT]}]

Table[plaqRdata[i],{i,Length[mfT]}]

plaqb6p4Bplot=Show[ErrorListPlot[Table[{{plaqUdata[j][[2]],plaqUdata[j][[3]]},ErrorBar[plaqUdata[j][[4]]]},{j,1,5}],PlotRange->{{-1.19,-1.09},{0.48,.565}},Frame->True,AxesStyle->Black,LabelStyle->Directive[20,Black],FrameStyle->Black,BaseStyle->texStyle,FrameLabel->{MaTeX["am_0^{f}",Magnification->2],MaTeX["\\langle \\mathcal{P} \\rangle",Magnification->2]},PlotMarkers->{"\[EmptySquare]",15},PlotStyle->RGBColor[0,0,1],ImageSize->500],ErrorListPlot[Table[{{plaqRdata[j][[2]],plaqRdata[j][[3]]},ErrorBar[plaqRdata[j][[4]]]},{j,2,Length[mfT]}],PlotRange->{{-1.7,.1},{.3,.65}},Frame->True,AxesStyle->Black,LabelStyle->Directive[24,Black],FrameStyle->{Black},BaseStyle->texStyle,FrameLabel->{"\!\(\*SubscriptBox[\(am\), \(0\)]\)","<\[EmptySquare]>"},PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[1,0,0],ImageSize->600](*,Epilog\[Rule]{Inset[Style["B",17],{-1.05,0.56}]}*)]

Export["plots/Fig4-5_mass_scan/mass_scan_avg_B.pdf", plaqb6p4Bplot]


(* A(fig 4) *)

beta=6.4;
masT={"3.0"};
mfT={-1.18,-1.19,-1.2,-1.21};

plaqRimport=Table[mas=masT[[1]];mf=mfT[[j]];Import[StringJoin["processed_data/plaq_8x8x8x8b",ToString[beta],"mas",ToString[mas],"mf",ToString[mf],"_random.txt"],"Table"],{j,1,Length[mfT]}];

plaqUimport=Table[mas=masT[[1]];mf=mfT[[j]];Import[StringJoin["processed_data/plaq_8x8x8x8b",ToString[beta],"mas",ToString[mas],"mf",ToString[mf],"_unit.txt"],"Table"],{j,1,Length[mfT]}];

Table[ListPlot[{Table[plaqUimport[[j]][[i]][[2]],{i,1,Length[plaqUimport[[j]]]}],Table[plaqRimport[[j]][[i]][[2]],{i,1,Length[plaqRimport[[j]]]}]},Frame->True,Joined->True,PlotRange->All],{j,1,Length[mfT]}]

DtrajT={6,2,3,2};(*The number of trajectories between adjacent configuration, corresponding to an autocorrelation length*)

traj0T={201,81,51,81};(*The number of trajectories required for thermalization*)
Do[traj0=traj0T[[j]];dtraj=DtrajT[[j]];
plaqimport=Table[plaqUimport[[j]][[dtraj*i+traj0]][[2]],{i,1,(Length[plaqUimport[[j]]]-traj0)/dtraj}];
Nconf=Length[plaqimport];
Nboot=200;
rndi=Table[Table[Round[RandomReal[{0,1}] (Nconf-1)+1],{j,Nboot}],{i,Nconf}];
plaqbootT=Table[Mean[Table[plaqimport[[rndi[[i]][[j]]]],{i,Nconf}]],{j,Nboot}];
plaqUdata[j]={masT[[1]],mfT[[j]],Mean[plaqbootT],StandardDeviation[plaqbootT]},{j,1,Length[mfT]}]

Table[plaqUdata[i],{i,Length[mfT]}]

DtrajT={5,5,3,2};(*The number of trajectories between adjacent configuration, corresponding to an autocorrelation length*)

traj0T={101,81,141,71};(*The number of trajectories required for thermalization*)
Do[traj0=traj0T[[j]];dtraj=DtrajT[[j]];
plaqimport=Table[plaqRimport[[j]][[dtraj*i+traj0]][[2]],{i,1,(Length[plaqRimport[[j]]]-traj0)/dtraj}];
Nconf=Length[plaqimport];
Nboot=200;
rndi=Table[Table[Round[RandomReal[{0,1}] (Nconf-1)+1],{j,Nboot}],{i,Nconf}];
plaqbootT=Table[Mean[Table[plaqimport[[rndi[[i]][[j]]]],{i,Nconf}]],{j,Nboot}];
plaqRdata[j]={masT[[1]],mfT[[j]],Mean[plaqbootT],StandardDeviation[plaqbootT]},{j,1,Length[mfT]}]

Table[plaqRdata[i],{i,Length[mfT]}]

plaqb6p4Aplot=Show[ErrorListPlot[Table[{{plaqUdata[j][[2]],plaqUdata[j][[3]]},ErrorBar[plaqUdata[j][[4]]]},{j,1,Length[mfT]}],PlotRange->{{-1.215,-1.175},{0.48,.555}},Frame->True,AxesStyle->Black,LabelStyle->Directive[20,Black],FrameStyle->Black,BaseStyle->texStyle,FrameLabel->{MaTeX["am_0^{f}",Magnification->2],MaTeX["\\langle \\mathcal{P} \\rangle",Magnification->2]},PlotMarkers->{"\[EmptySquare]",15},PlotStyle->RGBColor[0,0,1],ImageSize->500],ErrorListPlot[Table[{{plaqRdata[j][[2]],plaqRdata[j][[3]]},ErrorBar[plaqRdata[j][[4]]]},{j,1,Length[mfT]}],PlotRange->{{-1.7,.1},{.3,.65}},Frame->True,AxesStyle->Black,LabelStyle->Directive[24,Black],FrameStyle->{Black},BaseStyle->texStyle,FrameLabel->{"\!\(\*SubscriptBox[\(am\), \(0\)]\)","<\[EmptySquare]>"},PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[1,0,0],ImageSize->600]]

Export["plots/Fig4-5_mass_scan/mass_scan_avg_A.pdf", plaqb6p4Aplot]
