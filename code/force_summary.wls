#!/usr/bin/env wolframscript

forceimport=Import[$ScriptCommandLine[[2]],"Table"];

Export[$ScriptCommandLine[[3]], ListPlot[Table[Table[forceimport[[i]][[j]],{i,1,Length[forceimport]}],{j,2,5}],Frame->True,Joined->True,PlotRange->All, LabelStyle->{FontSize->16, FontFamily->"Times", Black}, FrameLabel->{"MD Trajectory", "MD Force"}]]

(*For each HMC force we perform the average over the configurations after thermalization (100 initial configurations).*)
forceavgT=Table[tab=Table[forceimport[[i]][[j]]/forceimport[[i]][[4]],{i,101,400}];{Mean[tab],StandardDeviation[tab]},{j,2,5}]

Export[$ScriptCommandLine[[4]], BarChart[{Table[forceavgT[[j]][[1]],{j,1,4}]},Frame->True,AxesStyle->Black,FrameStyle->Black,FrameLabel->{None,"MD Force"},ChartLabels->{"Gauge","AS (HMC)","AS (RHMC)","F (HMC)"},ImageSize->600, LabelStyle->{FontSize->16, FontFamily->"Times", Black}]]
