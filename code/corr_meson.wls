#!/usr/bin/env wolframscript

Needs["ErrorBarPlots`"]


Needs["PlotLegends`"]


(* Extraction of mass and decay constants from two-point mesonic correlation function *)


(* Pseudo scalar *)


(* Import data and choose initial lattice parameters *)


NT=24; (*number of temporal lattice*)
NS=12; (*number of one of the spatial lattice*)
beta=6.35;
beta1=6;beta2=35; (*lattice coupling*)

suffix=StringJoin[ToString[NT],"x",ToString[NS],"x",ToString[NS],"x",ToString[NS],"b",ToString[beta1],".",ToString[beta2],"mas",$ScriptCommandLine[[2]],"mf-0.6.txt"]

plaqimport=Import[StringJoin["processed_data/plaq_",suffix],"Table"];

{ntraj,dev,fstouse,fetouse,nconfstart} = Flatten[Import[StringJoin["fit_params/ps_params_", suffix], "Table"]];

corrimport=Import[StringJoin["processed_data/meson_corr_",suffix(*,"_LCH"*)],"Table"]; (*import the correlators for 17 interpolating operators*)
Nconf=If[Length[corrimport]/17/ntraj-Round[Length[corrimport]/17/ntraj]>=0,Round[Length[corrimport]/17/ntraj],Round[Length[corrimport]/17/ntraj]-1] ;(*number of configurations*)
Ntmax=Length[corrimport[[1]]]-2; (*number of temporal lattice*)
Nconf-nconfstart


(*Nconf=200;*)


(* Resampling data and plot effective mass plot *)


(*ntraj1=6;*)
(*only for \beta=7.2 and m0=-0.6*)


plaqT=Table[plaqimport[[ntraj*(i-1)+1+dev]][[2]],{i,nconfstart+1,Nconf}];
{Mean[plaqT],StandardDeviation[plaqT]}


ch=1;(*meson channel, e.g. ch=1 for the correlator of pseudoscalar meson*)
Do[corrimport[[ntraj*17*(j-1)+dev*17+ch]]=Append[corrimport[[ntraj*17*(j-1)+dev*17+ch]],corrimport[[ntraj*17*(j-1)+dev*17+ch]][[3]]],{j,nconfstart+1,Nconf}]; (*copy the correlator at t=0 to that at t=Ntmax to make it symmetric.*)
corrg5T=Table[Table[NS^3 (corrimport[[ntraj*17*(j-1)+dev*17+ch]][[i]]+corrimport[[ntraj*17*(j-1)+dev*17+ch]][[Ntmax+6-i]])/2,{j,nconfstart+1,Nconf}],{i,3,(Ntmax+2)/2+2}];(*average out the correlators at t and T-t.*)


ch=17;(*meson channel, e.g. ch=17 for PS - AV correlator*)
Do[corrimport[[ntraj*17*(j-1)+dev*17+ch]]=Append[corrimport[[ntraj*17*(j-1)+dev*17+ch]],corrimport[[ntraj*17*(j-1)+dev*17+ch]][[3]]],{j,nconfstart+1,Nconf}];(*copy the correlator at t=0 to that at t=Ntmax to make it symmetric.*)
corrg0g5T=Table[Table[NS^3 (corrimport[[ntraj*17*(j-1)+dev*17+ch]][[i]]-corrimport[[ntraj*17*(j-1)+dev*17+ch]][[Ntmax+6-i]])/2,{j,nconfstart+1,Nconf}],{i,3,(Ntmax+2)/2+2}]; (*average out the correlators at t and T-t.*)


nconf=Nconf-nconfstart; (*number of correlators used for the analysis*)
Nboot=200; (*number of samples resampled through bootstrapping*)
rndi=Table[Table[Round[RandomReal[{0,1}] (nconf-1)+1],{j,Nboot}],{i,nconf}]; (*generating random numbers*)


plaqbootT=Table[Mean[Table[plaqT[[rndi[[i]][[j]]]],{i,nconf}]],{j,Nboot}]; (*resampled data for plaquettes*)
plaqbootavg={Mean[plaqbootT],StandardDeviation[plaqbootT]}
Zv=1+2 (-20.57) (8/beta)/(16 Pi^2 plaqbootavg[[1]])
Zav=1+2 (-15.82) (8/beta)/(16 Pi^2 plaqbootavg[[1]])



corrg5bootT=Table[Table[Mean[Table[corrg5T[[k]][[rndi[[i]][[j]]]],{i,nconf}]],{j,Nboot}],{k,Ntmax/2+1}]; (*resampled data for pseudoscalar correlators*)
corrg5bootavgT=Table[{k-1,Mean[corrg5bootT[[k]]],StandardDeviation[corrg5bootT[[k]]]},{k,Ntmax/2+1}]; (*mean and standard deviation of resampled data for pseudoscalar correlators*)
corrg0g5bootT=Table[Table[Mean[Table[corrg0g5T[[k]][[rndi[[i]][[j]]]],{i,nconf}]],{j,Nboot}],{k,Ntmax/2+1}]; (*resampled data for ps-av correlators*)
corrg0g5bootavgT=Table[{k-1,Mean[corrg0g5bootT[[k]]],StandardDeviation[corrg0g5bootT[[k]]]},{k,Ntmax/2+1}]; (*mean and standard deviation of resampled data for ps-av correlators*)


(*Effective mass of pseudoscalar meson*)
meffg5tab=Table[{i,Mean[Table[ArcCosh[(corrg5bootT[[i]][[j]]+corrg5bootT[[i+2]][[j]])/(2 corrg5bootT[[i+1]][[j]])],{j,Nboot}]],StandardDeviation[Table[ArcCosh[(corrg5bootT[[i]][[j]]+corrg5bootT[[i+2]][[j]])/(2 corrg5bootT[[i+1]][[j]])],{j,Nboot}]]},{i,1,Ntmax/2-1}];
(*meffg0g5tab=Table[{i,Mean[Table[ArcCosh[(corrg0g5bootT[[i]][[j]]+corrg0g5bootT[[i+2]][[j]])/(2 corrg0g5bootT[[i+1]][[j]])],{j,Nboot}]],StandardDeviation[Table[ArcCosh[(corrg0g5bootT[[i]][[j]]+corrg0g5bootT[[i+2]][[j]])/(2 corrg0g5bootT[[i+1]][[j]])],{j,Nboot}]]},{i,1,Ntmax/2-1}];*)


g5meffplot=ErrorListPlot[Table[{{meffg5tab[[t]][[1]],meffg5tab[[t]][[2]]},ErrorBar[meffg5tab[[t]][[3]]]},{t,2,Ntmax/2-1}],Frame->True,PlotRange->{{0,Ntmax/2+.5},{1.2,1.35}},AxesStyle->Thick,PlotMarkers->{"\[EmptySquare]",18},PlotStyle->RGBColor[0,0,1],AxesStyle->Black,FrameStyle->Black,FrameLabel->{"t","\!\(\*SubscriptBox[\(m\), \(eff\)]\)"},LabelStyle->Directive[22,Black],ImageSize->600](*effective mass plot*)


g5corrplot=ErrorListPlot[Table[{{corrg5bootavgT[[t]][[1]],corrg5bootavgT[[t]][[2]]},ErrorBar[corrg5bootavgT[[t]][[3]]]},{t,1,Ntmax/2+1}],Frame->True,PlotRange->{{0,Ntmax+1},All},AxesStyle->Thick,PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->Red,AxesStyle->Black,FrameStyle->Black,FrameLabel->{"t","\!\(\*SubscriptBox[\(C\), \(\*SubscriptBox[\(\[Gamma]\), \(5\)], \*SubscriptBox[\(\[Gamma]\), \(5\)]\)]\)(t)"},LabelStyle->Directive[22,Black],ImageSize->600](*plot of the correlation function of pseudoscalar meson*)


g0g5corrplot=ErrorListPlot[Table[{{corrg0g5bootavgT[[t]][[1]],corrg0g5bootavgT[[t]][[2]]},ErrorBar[corrg0g5bootavgT[[t]][[3]]]},{t,1,Ntmax/2+1}],Frame->True,PlotRange->{{0,Ntmax+1},All},AxesStyle->Thick,PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->Red,AxesStyle->Black,FrameStyle->Black,FrameLabel->{"t","\!\(\*SubscriptBox[\(C\), \(\*SubscriptBox[\(\[Gamma]\), \(0\)] \*SubscriptBox[\(\[Gamma]\), \(5\)], \*SubscriptBox[\(\[Gamma]\), \(5\)]\)]\)(t)"},LabelStyle->Directive[22,Black],ImageSize->600](*plot of the correlation function of ps-av operator*)


(* Fit the data to the correlation function - fit the central values (find best chi-square) *)


Clear[f,g]
f[a_,b_,c_,x_]:=(a^2/b) (Exp[-b x]+Exp[-b (NT-x)]); (*fitting function for the ps meson, b is the mass and a is the ps amplitude <0|qbar \[Gamma]5 q|PS>*)
g[a_,b_,c_,x_]:=(a c/Zav) (Exp[-b x]-Exp[-b (NT-x)]);(*fitting function for the ps-av operator, c is the ps decay constant*)


(*extract the fitting parameters throught \[Chi]^2 minimization - center values*)
(*we use this analysis to see the quality of the fit and determint the fit range*)
Do[
fe=12(*-l+1*);(*ending point of the fit*)
fs=6+l; (*starting point of the fit*)
np=2 (fe-fs+1); (*total number of data points used for the fit*)
dof=np-3;
g5cov=Table[Table[Mean[Table[(corrg5bootT[[j]][[i]]-corrg5bootavgT[[j]][[2]]) (corrg5bootT[[k]][[i]]-corrg5bootavgT[[k]][[2]]),{i,Nboot}]],{j,fs,fe}],{k,fs,fe}];
g0g5cov=Table[Table[Mean[Table[(corrg0g5bootT[[j]][[i]]-corrg0g5bootavgT[[j]][[2]]) (corrg0g5bootT[[k]][[i]]-corrg0g5bootavgT[[k]][[2]]),{i,Nboot}]],{j,fs,fe}],{k,fs,fe}];
invg5cov = Inverse[g5cov];
invg0g5cov = Inverse[g0g5cov];
tmp = NMinimize[Sum[Sum[(corrg5bootavgT[[j]][[2]] - f[a, b, c, corrg5bootavgT[[j]][[1]]])*invg5cov[[j - fs + 1]][[k - fs + 1]]*
               (corrg5bootavgT[[k]][[2]] - f[a, b, c, corrg5bootavgT[[k]][[1]]]) + (corrg0g5bootavgT[[j]][[2]] - g[a, b, c, corrg0g5bootavgT[[j]][[1]]])*
               invg0g5cov[[j - fs + 1]][[k - fs + 1]]*(corrg0g5bootavgT[[k]][[2]] - g[a, b, c, corrg0g5bootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs, fe}],
       {a, b, c}, Method -> "DifferentialEvolution"];
mfit = {a /. tmp[[2]][[1]], b /. tmp[[2]][[2]], c /. tmp[[2]][[3]],tmp[[1]]/dof};
chisquare = Sum[Sum[(corrg5bootavgT[[j]][[2]] - f[mfit[[1]], mfit[[2]], mfit[[3]], corrg5bootavgT[[j]][[1]]])*invg5cov[[j - fs + 1]][[k - fs + 1]]*
             (corrg5bootavgT[[k]][[2]] - f[mfit[[1]], mfit[[2]], mfit[[3]], corrg5bootavgT[[k]][[1]]]) +
           (corrg0g5bootavgT[[j]][[2]] - g[mfit[[1]], mfit[[2]], mfit[[3]], corrg0g5bootavgT[[j]][[1]]])*invg0g5cov[[j - fs + 1]][[k - fs + 1]]*
             (corrg0g5bootavgT[[k]][[2]] - g[mfit[[1]], mfit[[2]], mfit[[3]], corrg0g5bootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs, fe}]/dof;Print[{fs,fe,chisquare}],{l,1,6}]


(* Fit the data to the correlation function - defining the fit functions and covariant matrix *)


Clear[f,g]

fs=fstouse;
fe=fetouse;
np=2 (fe-fs+1); (*total number of data points used for the fit*)
dof=np-3; (*degree of freedom*)


f[a_,b_,c_,x_]:=(a^2/b) (Exp[-b x]+Exp[-b (NT-x)]); (*fitting function for the ps meson, b is the mass and a is the ps amplitude <0|qbar \[Gamma]5 q|PS>*)
g[a_,b_,c_,x_]:=(a c/Zav) (Exp[-b x]-Exp[-b (NT-x)]);(*fitting function for the ps-av operator, c is the ps decay constant*)


(*covariant matrix*)
g5cov=Table[Table[Mean[Table[(corrg5bootT[[j]][[i]]-corrg5bootavgT[[j]][[2]]) (corrg5bootT[[k]][[i]]-corrg5bootavgT[[k]][[2]]),{i,Nboot}]],{j,fs,fe}],{k,fs,fe}];
g0g5cov=Table[Table[Mean[Table[(corrg0g5bootT[[j]][[i]]-corrg0g5bootavgT[[j]][[2]]) (corrg0g5bootT[[k]][[i]]-corrg0g5bootavgT[[k]][[2]]),{i,Nboot}]],{j,fs,fe}],{k,fs,fe}];


(*the inverse of the covariant matrix*)
invg5cov = Inverse[g5cov];
invg0g5cov = Inverse[g0g5cov];


(* Fit the data to the correlation function - fit the central values *)


(*extract the fitting parameters throught \[Chi]^2 minimization - center values*)
(*we use this analysis to see the quality of the fit and determint the fit range*)
tmp = NMinimize[Sum[Sum[(corrg5bootavgT[[j]][[2]] - f[a, b, c, corrg5bootavgT[[j]][[1]]])*invg5cov[[j - fs + 1]][[k - fs + 1]]*
               (corrg5bootavgT[[k]][[2]] - f[a, b, c, corrg5bootavgT[[k]][[1]]]) + (corrg0g5bootavgT[[j]][[2]] - g[a, b, c, corrg0g5bootavgT[[j]][[1]]])*
               invg0g5cov[[j - fs + 1]][[k - fs + 1]]*(corrg0g5bootavgT[[k]][[2]] - g[a, b, c, corrg0g5bootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs, fe}],
       {a, b, c}, Method -> "DifferentialEvolution"];
mfit = {a /. tmp[[2]][[1]], b /. tmp[[2]][[2]], c /. tmp[[2]][[3]],tmp[[1]]/dof}
chisquare = Sum[Sum[(corrg5bootavgT[[j]][[2]] - f[mfit[[1]], mfit[[2]], mfit[[3]], corrg5bootavgT[[j]][[1]]])*invg5cov[[j - fs + 1]][[k - fs + 1]]*
             (corrg5bootavgT[[k]][[2]] - f[mfit[[1]], mfit[[2]], mfit[[3]], corrg5bootavgT[[k]][[1]]]) +
           (corrg0g5bootavgT[[j]][[2]] - g[mfit[[1]], mfit[[2]], mfit[[3]], corrg0g5bootavgT[[j]][[1]]])*invg0g5cov[[j - fs + 1]][[k - fs + 1]]*
             (corrg0g5bootavgT[[k]][[2]] - g[mfit[[1]], mfit[[2]], mfit[[3]], corrg0g5bootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs, fe}]/dof


(*plot the fit results of the central values*)
g5fitplot=Plot[f[mfit[[1]],mfit[[2]],mfit[[3]],x],{x,1,50}];
g0g5fitplot=Plot[g[mfit[[1]],mfit[[2]],mfit[[3]],x],{x,1,50}];
Show[{g5corrplot,g5fitplot},PlotRange->{{5,12.5},{-0.000001,0.001}}]


(* Fit the data to the correlation function - fit all configurations *)


(*extrac the fitting parameters throught \[Chi]^2 minimization - all configurations*)
g5fitT = Table[tmp = NMinimize[Sum[Sum[(corrg5bootT[[j]][[i]] - f[a,b,c,corrg5bootavgT[[j]][[1]]]) invg5cov[[j - fs + 1]][[k - fs + 1]] (corrg5bootT[[k]][[i]] - f[a,b,c,corrg5bootavgT[[k]][[1]]])+(corrg0g5bootT[[j]][[i]] - g[a,b,c,corrg0g5bootavgT[[j]][[1]]]) invg0g5cov[[j - fs + 1]][[k - fs + 1]] (corrg0g5bootT[[k]][[i]] - g[a,b,c,corrg0g5bootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs, fe}], {a,b,c}(*, Method\[Rule]{"RandomSearch","SearchPoints"\[Rule]100}*)]; {a/. tmp[[2]][[1]], b /. tmp[[2]][[2]],c/.tmp[[2]][[3]],tmp[[1]]/dof}, {i, 1, Nboot}];


distplot=ListPlot[Table[{g5fitT[[i]][[2]],Abs[g5fitT[[i]][[3]]]},{i,1,Nboot}](*,PlotRange\[Rule]{{0.2,0.45},{0.0055,0.15}}*),PlotStyle->{Red,Opacity[0.8]}]


(*average and standard deviation of the fit results*)
g5fit=Table[{Mean[Table[Abs[g5fitT[[i]][[k]]],{i,1,Nboot}]],StandardDeviation[Table[Abs[g5fitT[[i]][[k]]],{i,1,Nboot}]]},{k,1,4}]


(*average and standard deviation of the fit results*)
g5sqfit=Table[{Mean[Table[g5fitT[[i]][[k]]^2,{i,1,Nboot}]],StandardDeviation[Table[Abs[g5fitT[[i]][[k]]],{i,1,Nboot}]]},{k,1,4}]


(*Show the effective mass plot with fit results*)
mefffitplot=Plot[{g5fit[[2]][[1]]+g5fit[[2]][[2]],g5fit[[2]][[1]]-g5fit[[2]][[2]]},{x,fs-.5,fe-.5},Filling->True,PlotStyle->Directive[RGBColor[0,0,1],Opacity[.3]]];
g5mfitplot=Show[g5meffplot,mefffitplot]


mpiL={Mean[Table[Abs[g5fitT[[i]][[2]] NS],{i,1,Nboot}]],StandardDeviation[Table[Abs[g5fitT[[i]][[2]] NS],{i,1,Nboot}]]}


fpiL={Mean[Table[Abs[g5fitT[[i]][[3]] NS],{i,1,Nboot}]],StandardDeviation[Table[Abs[g5fitT[[i]][[3]] NS],{i,1,Nboot}]]}


mpifpiR={Mean[Table[Abs[g5fitT[[i]][[2]]/g5fitT[[i]][[3]]],{i,1,Nboot}]],StandardDeviation[Table[Abs[g5fitT[[i]][[2]]/g5fitT[[i]][[3]]],{i,1,Nboot}]]}


(*export fit results: Subscript[f, PS]^2, Subscript[m, ps]^2, <0|qbar \[Gamma]5 q|PS(>^2), \[Chi]^2/dof, seperation between adjacent trajectoreis/4, choice of the correlators, starting point of the fit ragne, ending point of the fit range*)
Export[StringJoin["processed_data/corr_ps_fit_",suffix],{Table[g5fitT[[i]][[3]]^2,{i,1,Nboot}],Table[g5fitT[[i]][[2]]^2,{i,1,Nboot}],Table[g5fitT[[i]][[1]]^2,{i,1,Nboot}],chisquare,ntraj,dev,fs,fe,nconfstart},"Table"];


(* Vector meson -Subscript[\[Gamma], 1] *)


(* Import data and choose initial lattice parameters *)

{ntraj,dev,fstouse,fetouse,nconfstart} = Flatten[Import[StringJoin["fit_params/v_params_", suffix], "Table"]]

corrimport=Import[StringJoin["processed_data/vmeson_corr_",suffix(*,"_LCH"*)],"Table"]; (*import the correlators for the vector meson interpolating operators*)
Nconf=If[Length[corrimport]/3/ntraj-Round[Length[corrimport]/3/ntraj]>=0,Round[Length[corrimport]/3/ntraj],Round[Length[corrimport]/3/ntraj]-1] ;(*number of configurations: 3 is for the three spartial directions*)
Ntmax=Length[corrimport[[1]]]-2;(*number of temporal lattice*)
(*nconfstart=20;*)(*The initial trajectory at which the thermalization ends.*)
Nconf-nconfstart


(* Resampling data and plot effective mass plot *)



ch=1;(*vector meson channel, I already extracted the channel g1, g2, g3 from the output file of the measurement by using mk_mesons_with_z2semwall_new *)
Do[corrimport[[(j-1)+ch]]=Append[corrimport[[(j-1)+ch]],corrimport[[(j-1)+ch]][[3]]],{j,nconfstart+1,3 ntraj*Nconf}];(*copy the correlator at t=0 to that at t=Ntmax to make it symmetric.*)
corrT=Table[Table[NS^3 (corrimport[[ntraj*3*(j-1)+dev*3+ch]][[i]]+corrimport[[ntraj*3*(j-1)+dev*3+ch+1]][[i]]+corrimport[[ntraj*3*(j-1)+dev*3+ch+2]][[i]]+corrimport[[ntraj*3*(j-1)+dev*3+ch]][[Ntmax+6-i]]+corrimport[[ntraj*3*(j-1)+dev*3+ch+1]][[Ntmax+6-i]]+corrimport[[ntraj*3*(j-1)+dev*3+ch+2]][[Ntmax+6-i]])/2/3,{j,nconfstart+1,Nconf}],{i,3,(Ntmax+2)/2+2}]; (*average out the correlators at t and T-t, and also over the three spatial directions.*)


corrbootT=Table[Table[Mean[Table[corrT[[k]][[rndi[[i]][[j]]]],{i,nconf}]],{j,Nboot}],{k,Ntmax/2+1}];(*resampled data for vector correlators*)
corrbootavgT=Table[{k-1,Mean[corrbootT[[k]]],StandardDeviation[corrbootT[[k]]]},{k,Ntmax/2+1}];(*mean and standard deviation of resampled data for vector correlators*)


(*Effective mass of vector meson*)
mefftab=Table[{i,Mean[Table[ArcCosh[(corrbootT[[i]][[j]]+corrbootT[[i+2]][[j]])/(2 corrbootT[[i+1]][[j]])],{j,Nboot}]],StandardDeviation[Table[ArcCosh[(corrbootT[[i]][[j]]+corrbootT[[i+2]][[j]])/(2 corrbootT[[i+1]][[j]])],{j,Nboot}]]},{i,1,Ntmax/2-1}];


(*effective mass plot*)
g1meffplot=ErrorListPlot[Table[{{mefftab[[t]][[1]],mefftab[[t]][[2]]},ErrorBar[mefftab[[t]][[3]]]},{t,1,Ntmax/2-1}],Frame->True,PlotRange->{{3.5,Ntmax/2},{1.2,1.45}},AxesStyle->Thick,PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[1,0,0],AxesStyle->Black,FrameStyle->Black,FrameLabel->{"\[Tau]","\!\(\*SubscriptBox[\(m\), \(eff\)]\)"},LabelStyle->Directive[22,Black],ImageSize->600]


(*plot of the correlation function of vector meson*)
g1corrplot=ErrorListPlot[Table[{{corrbootavgT[[t]][[1]],corrbootavgT[[t]][[2]]},ErrorBar[corrbootavgT[[t]][[3]]]},{t,2,Ntmax/2+1}],Frame->True,PlotRange->{{0,Ntmax+1},All},AxesStyle->Thick,PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->Red,AxesStyle->Black,FrameStyle->Black,FrameLabel->{"t","C(t)"},LabelStyle->Directive[22,Black],ImageSize->600]


(* Fit the data to the correlation function - fit the central values (find best chi-square) *)


Clear[f]
f[a_,b_,x_]:=(a b/Zv^2) (Exp[-b x]+Exp[-b (NT-x)]);(*fitting function for the vector meson, b is the mass and a is the vector decay constant squared.*)


(*extract the fitting parameters throught \[Chi]^2 minimization - center values*)
(*we use this analysis to see the quality of the fit and determint the fit range*)
Do[
fe=12(*-l+1*);(*ending point of the fit*)
fs=6+l; (*starting point of the fit*)
np=(fe-fs+1); (*total number of data points used for the fit*)
dof=np-2;
(*covariant matrix*)
cov=Table[Table[Mean[Table[(corrbootT[[j]][[i]]-corrbootavgT[[j]][[2]]) (corrbootT[[k]][[i]]-corrbootavgT[[k]][[2]]),{i,Nboot}]],{j,fs,fe}],{k,fs,fe}];
(*the inverse of the covariant matrix*)
invcov=Inverse[cov];
tmp=NMinimize[Sum[Sum[(corrbootavgT[[j]][[2]]-f[a,b,corrbootavgT[[j]][[1]]]) invcov[[j-fs+1]][[k-fs+1]] (corrbootavgT[[k]][[2]]-f[a,b,corrbootavgT[[k]][[1]]]),{j,fs,fe}],{k,fs,fe}],{a,b},Method->"DifferentialEvolution"];
mfit={a/.tmp[[2]][[1]],b/.tmp[[2]][[2]]};
chisquare=Sum[Sum[(corrbootavgT[[j]][[2]]-f[mfit[[1]],mfit[[2]],corrbootavgT[[j]][[1]]]) invcov[[j-fs+1]][[k-fs+1]] (corrbootavgT[[k]][[2]]-f[mfit[[1]],mfit[[2]],corrbootavgT[[k]][[1]]]),{j,fs,fe}],{k,fs,fe}]/dof;Print[{fs,fe,chisquare}],{l,1,5}]


(* Fit the data to the correlation function - defining the fit functions and covariant matrix *)


Clear[f]

fs=fstouse;
fe=fetouse;
np=fe-fs+1; (*total number of data points used for the fit*)
dof=np-2;(*degree of freedom*)


f[a_,b_,x_]:=(a b/Zv^2) (Exp[-b x]+Exp[-b (NT-x)]);(*fitting function for the vector meson, b is the mass and a is the vector decay constant squared.*)


(*covariant matrix*)
cov=Table[Table[Mean[Table[(corrbootT[[j]][[i]]-corrbootavgT[[j]][[2]]) (corrbootT[[k]][[i]]-corrbootavgT[[k]][[2]]),{i,Nboot}]],{j,fs,fe}],{k,fs,fe}];


(*the inverse of the covariant matrix*)
invcov=Inverse[cov];


(* Fit the data to the correlation function - fit the central values *)


(*extract the fitting parameters throught \[Chi]^2 minimization - center values*)
(*we use this analysis to see the quality of the fit and determint the fit range*)
tmp=NMinimize[Sum[Sum[(corrbootavgT[[j]][[2]]-f[a,b,corrbootavgT[[j]][[1]]]) invcov[[j-fs+1]][[k-fs+1]] (corrbootavgT[[k]][[2]]-f[a,b,corrbootavgT[[k]][[1]]]),{j,fs,fe}],{k,fs,fe}],{a,b},Method->"DifferentialEvolution"];
mfit={a/.tmp[[2]][[1]],b/.tmp[[2]][[2]],tmp[[1]]/dof}
chisquare=Sum[Sum[(corrbootavgT[[j]][[2]]-f[mfit[[1]],mfit[[2]],corrbootavgT[[j]][[1]]]) invcov[[j-fs+1]][[k-fs+1]] (corrbootavgT[[k]][[2]]-f[mfit[[1]],mfit[[2]],corrbootavgT[[k]][[1]]]),{j,fs,fe}],{k,fs,fe}]/dof


(*plot the fit results of the central values*)
fitplot=Plot[f[mfit[[1]],mfit[[2]],x],{x,1,50}];
Show[{g1corrplot,fitplot},PlotRange->{{fs-4,24-fs+3},{-0.0000001,0.0001}}]


(* Fit the data to the correlation function - fit all configurations *)


(*extract the fitting parameters throught \[Chi]^2 minimization - all configurations*)
g1fitT = Table[tmp = NMinimize[Sum[Sum[(corrbootT[[j]][[i]] - f[a, b, corrbootavgT[[j]][[1]]]) invcov[[j - fs + 1]][[k - fs + 1]] (corrbootT[[k]][[i]] - f[a, b, corrbootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs, fe}], {a, b}(*, Method -> "DifferentialEvolution",MaxIterations\[Rule]150*)]; {a /. tmp[[2]][[1]], b /. tmp[[2]][[2]]}, {i, 1, Nboot}];


ListPlot[Table[{g1fitT[[i]][[2]],Sqrt[g1fitT[[i]][[1]]]},{i,1,Nboot}](*,PlotRange\[Rule]{{0.37,0.53},{0.052,0.115}}*)]


(*average and standard deviation of the fit results*)
g1fit=Table[{Mean[Table[Abs[g1fitT[[i]][[k]]],{i,1,Nboot}]],StandardDeviation[Table[Abs[g1fitT[[i]][[k]]],{i,1,Nboot}]]},{k,1,2}]


(*average and standard deviation of the fit results*)
g1sqfit=Table[{Mean[Table[Sqrt[g1fitT[[i]][[k]]],{i,1,Nboot}]],StandardDeviation[Table[Sqrt[g1fitT[[i]][[k]]],{i,1,Nboot}]]},{k,1,2}]


(*Show the effective mass plot with fit results*)
mefffitplot=Plot[{g1fit[[2]][[1]]+g1fit[[2]][[2]],g1fit[[2]][[1]]-g1fit[[2]][[2]]},{x,fs-.5,fe-.5},Filling->True,PlotStyle->Directive[RGBColor[1,0,0],Opacity[.3]]];
g1mfitplot=Show[{g1meffplot,mefffitplot}]


mpimrhoR={Mean[Table[g5fitT[[i]][[2]]/g1fitT[[i]][[2]],{i,1,Nboot}]],StandardDeviation[Table[g5fitT[[i]][[2]]/g1fitT[[i]][[2]],{i,1,Nboot}]]}


mrhompiR={Mean[Table[g1fitT[[i]][[2]]/g5fitT[[i]][[2]],{i,1,Nboot}]],StandardDeviation[Table[g1fitT[[i]][[2]]/g5fitT[[i]][[2]],{i,1,Nboot}]]}


mrhofpiR={Mean[Table[Abs[g1fitT[[i]][[2]]/g5fitT[[i]][[3]]],{i,1,Nboot}]],StandardDeviation[Table[Abs[g1fitT[[i]][[2]]/g5fitT[[i]][[3]]],{i,1,Nboot}]]}


mrhofpiR={Mean[Table[Abs[g1fitT[[i]][[2]]/g5fitT[[i]][[3]]/Sqrt[2]],{i,1,Nboot}]],StandardDeviation[Table[Abs[g1fitT[[i]][[2]]/g5fitT[[i]][[3]]/Sqrt[2]],{i,1,Nboot}]]}


mrhofrhoR={Mean[Table[Abs[g1fitT[[i]][[2]]/Sqrt[g1fitT[[i]][[1]]]],{i,1,Nboot}]],StandardDeviation[Table[Abs[g1fitT[[i]][[2]]/Sqrt[g1fitT[[i]][[1]]]],{i,1,Nboot}]]}


frhofpiR={Mean[Table[Abs[Sqrt[g1fitT[[i]][[1]]]/g5fitT[[i]][[3]]],{i,1,Nboot}]],StandardDeviation[Table[Abs[Sqrt[g1fitT[[i]][[1]]]/g5fitT[[i]][[3]]],{i,1,Nboot}]]}


mpimrho2R={Mean[Table[(g5fitT[[i]][[2]]/g1fitT[[i]][[2]])^2,{i,1,Nboot}]],StandardDeviation[Table[(g5fitT[[i]][[2]]/g1fitT[[i]][[2]])^2,{i,1,Nboot}]]}


(*export fit results: Subscript[f, PS]^2, Subscript[m, ps]^2, <0|qbar \[Gamma]5 q|PS(>^2), \[Chi]^2/dof, seperation between adjacent trajectoreis/4, choice of the correlators, starting point of the fit ragne, ending point of the fit range*)
Export[StringJoin["processed_data/corr_v_fit_",suffix],{Table[g1fitT[[i]][[1]],{i,1,Nboot}],Table[g1fitT[[i]][[2]]^2,{i,1,Nboot}],chisquare,ntraj,dev,fs,fe,nconfstart},"Table"];


(* Axial-Vector meson - S *)

{ntraj,dev,fstouse,fetouse,nconfstart} = Flatten[Import[StringJoin["fit_params/I_params_", suffix], "Table"]]


(* Import data and choose initial lattice parameters *)


corrimport=Import[StringJoin["processed_data/meson_corr_",suffix(*,"_LCH"*)],"Table"];(*import the correlators for the axial-vector meson interpolating operators*)
Nconf=If[Length[corrimport]/17/ntraj-Round[Length[corrimport]/17/ntraj]>=0,Round[Length[corrimport]/17/ntraj],Round[Length[corrimport]/17/ntraj]-1] ;(*number of configurations*)
Ntmax=Length[corrimport[[1]]]-2;(*number of temporal lattice*)
(*nconfstart=0;*)(*The initial trajectory at which the thermalization ends.*)
Nconf-nconfstart


(* Resampling data and plot effective mass plot *)



ch=2;(*meson channel, e.g. ch=1 for the correlator of pseudoscalar meson*)
Do[corrimport[[ntraj*17*(j-1)+dev*17+ch]]=Append[corrimport[[ntraj*17*(j-1)+dev*17+ch]],corrimport[[ntraj*17*(j-1)+dev*17+ch]][[3]]],{j,nconfstart+1,Nconf}]; (*copy the correlator at t=0 to that at t=Ntmax to make it symmetric.*)
corrIT=Table[Table[NS^3 (corrimport[[ntraj*17*(j-1)+dev*17+ch]][[i]]+corrimport[[ntraj*17*(j-1)+dev*17+ch]][[Ntmax+6-i]])/2,{j,nconfstart+1,Nconf}],{i,3,(Ntmax+2)/2+2}];(*average out the correlators at t and T-t.*)


corrbootT=Table[Table[Mean[Table[corrIT[[k]][[rndi[[i]][[j]]]],{i,nconf}]],{j,Nboot}],{k,Ntmax/2+1}];(*resampled data for vector correlators*)
corrbootavgT=Table[{k-1,Mean[corrbootT[[k]]],StandardDeviation[corrbootT[[k]]]},{k,Ntmax/2+1}];(*mean and standard deviation of resampled data for vector correlators*)


(*Effective mass of axial-vector meson*)
mefftab=Table[{i,Mean[Table[ArcCosh[(corrbootT[[i]][[j]]+corrbootT[[i+2]][[j]])/(2 corrbootT[[i+1]][[j]])],{j,Nboot}]],StandardDeviation[Table[ArcCosh[(corrbootT[[i]][[j]]+corrbootT[[i+2]][[j]])/(2 corrbootT[[i+1]][[j]])],{j,Nboot}]]},{i,1,Ntmax/2-1}];


(*effective mass plot*)
Imeffplot=ErrorListPlot[Table[{{mefftab[[t]][[1]],mefftab[[t]][[2]]},ErrorBar[mefftab[[t]][[3]]]},{t,1,Ntmax/2-1}],Frame->True,PlotRange->{{1,Ntmax/2},{1.2,2.95}},AxesStyle->Thick,PlotMarkers->{"\[EmptyDiamond]",20},PlotStyle->RGBColor[1,0,1],AxesStyle->Black,FrameStyle->Black,FrameLabel->{"\[Tau]","\!\(\*SubscriptBox[\(m\), \(eff\)]\)"},LabelStyle->Directive[22,Black],ImageSize->600]


(*plot of the correlation function of axial-vector meson*)
Icorrplot=ErrorListPlot[Table[{{corrbootavgT[[t]][[1]],corrbootavgT[[t]][[2]]},ErrorBar[corrbootavgT[[t]][[3]]]},{t,2,Ntmax/2+1}],Frame->True,PlotRange->{{0,Ntmax+1},All},AxesStyle->Thick,PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->Red,AxesStyle->Black,FrameStyle->Black,FrameLabel->{"t","C(t)"},LabelStyle->Directive[22,Black],ImageSize->600]


(* Fit the data to the correlation function - fit the central values (find best chi-square) *)


Clear[f]
f[a_,b_,x_]:=(a b) (Exp[-b x]+Exp[-b (NT-x)]);(*fitting function for the axial-vector meson, b is the mass and a is the axial-vector decay constant squared.*)


(*extract the fitting parameters throught \[Chi]^2 minimization - center values*)
(*we use this analysis to see the quality of the fit and determint the fit range*)
Do[
fe=7(*-l+1*);(*ending point of the fit*)
fs=2+l; (*starting point of the fit*)
np=(fe-fs+1); (*total number of data points used for the fit*)
dof=np-2;
(*covariant matrix*)
cov=Table[Table[Mean[Table[(corrbootT[[j]][[i]]-corrbootavgT[[j]][[2]]) (corrbootT[[k]][[i]]-corrbootavgT[[k]][[2]]),{i,Nboot}]],{j,fs,fe}],{k,fs,fe}];
(*the inverse of the covariant matrix*)
invcov=Inverse[cov];
tmp=NMinimize[Sum[Sum[(corrbootavgT[[j]][[2]]-f[a,b,corrbootavgT[[j]][[1]]]) invcov[[j-fs+1]][[k-fs+1]] (corrbootavgT[[k]][[2]]-f[a,b,corrbootavgT[[k]][[1]]]),{j,fs,fe}],{k,fs,fe}],{a,b},Method->"DifferentialEvolution"];
mfit={a/.tmp[[2]][[1]],b/.tmp[[2]][[2]]};
chisquare=Sum[Sum[(corrbootavgT[[j]][[2]]-f[mfit[[1]],mfit[[2]],corrbootavgT[[j]][[1]]]) invcov[[j-fs+1]][[k-fs+1]] (corrbootavgT[[k]][[2]]-f[mfit[[1]],mfit[[2]],corrbootavgT[[k]][[1]]]),{j,fs,fe}],{k,fs,fe}]/dof;Print[{fs,fe,chisquare}],{l,1,5}]


(* Fit the data to the correlation function - defining the fit functions and covariant matrix *)


Clear[f]

fs=fstouse;
fe=fetouse;
np=fe-fs+1;(*total number of data points used for the fit*)
dof=np-2;(*degree of freedom*)


f[a_,b_,x_]:=(a b) (Exp[-b x]+Exp[-b (NT-x)]);(*fitting function for the axial-vector meson, b is the mass and a is the axial-vector decay constant squared.*)


(*covariant matrix*)
cov=Table[Table[Mean[Table[(corrbootT[[j]][[i]]-corrbootavgT[[j]][[2]]) (corrbootT[[k]][[i]]-corrbootavgT[[k]][[2]]),{i,Nboot}]],{j,fs,fe}],{k,fs,fe}];


(*the inverse of the covariant matrix*)
invcov=Inverse[cov];


(* Fit the data to the correlation function - fit the central values *)


(*extract the fitting parameters throught \[Chi]^2 minimization - center values*)
(*we use this analysis to see the quality of the fit and determint the fit range*)
tmp=NMinimize[Sum[Sum[(corrbootavgT[[j]][[2]]-f[a,b,corrbootavgT[[j]][[1]]]) invcov[[j-fs+1]][[k-fs+1]] (corrbootavgT[[k]][[2]]-f[a,b,corrbootavgT[[k]][[1]]]),{j,fs,fe}],{k,fs,fe}],{a,b},Method->"DifferentialEvolution"];
mfit={a/.tmp[[2]][[1]],b/.tmp[[2]][[2]]}
chisquare=Sum[Sum[(corrbootavgT[[j]][[2]]-f[mfit[[1]],mfit[[2]],corrbootavgT[[j]][[1]]]) invcov[[j-fs+1]][[k-fs+1]] (corrbootavgT[[k]][[2]]-f[mfit[[1]],mfit[[2]],corrbootavgT[[k]][[1]]]),{j,fs,fe}],{k,fs,fe}]/dof


(*plot the fit results of the central values*)
fitplot=Plot[f[mfit[[1]],mfit[[2]],x],{x,1,50}];
Show[{Icorrplot,fitplot},PlotRange->{{4,25},{-0.000001,0.00005}}]


(* Fit the data to the correlation function - fit all configurations *)


(*extract the fitting parameters throught \[Chi]^2 minimization - all configurations*)
IfitT = Table[tmp = NMinimize[Sum[Sum[(corrbootT[[j]][[i]] - f[a, b, corrbootavgT[[j]][[1]]]) invcov[[j - fs + 1]][[k - fs + 1]] (corrbootT[[k]][[i]] - f[a, b, corrbootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs, fe}], {a, b}, Method->{"RandomSearch","SearchPoints"->100}]; {a /. tmp[[2]][[1]], b /. tmp[[2]][[2]]}, {i, 1, Nboot}];


(*average and standard deviation of the fit results*)
Ifit=Table[{Mean[Table[Abs[IfitT[[i]][[k]]],{i,1, Nboot}]],StandardDeviation[Table[Abs[IfitT[[i]][[k]]],{i,1,Nboot}]]},{k,1,2}]


(*average and standard deviation of the fit results*)
I2fit=Table[{Mean[Table[Sqrt[IfitT[[i]][[k]]],{i,1,Nboot}]],StandardDeviation[Table[Abs[IfitT[[i]][[k]]],{i,1, Nboot}]]},{k,1,2}]


(*Show the effective mass plot with fit results*)
mefffitplot=Plot[{Ifit[[2]][[1]]+Ifit[[2]][[2]],Ifit[[2]][[1]]-Ifit[[2]][[2]]},{x,fs-.5,fe+.5},Filling->True,PlotStyle->Directive[RGBColor[1,0,1],Opacity[0.3]]];
Imfitplot=Show[{Imeffplot,mefffitplot}]


mrhofpiR={Mean[Table[Abs[IfitT[[i]][[2]]/g5fitT[[i]][[3]]],{i,1, Nboot}]],StandardDeviation[Table[Abs[IfitT[[i]][[2]]/g5fitT[[i]][[3]]],{i,1, Nboot}]]}


(*export fit results: Subscript[f, PS]^2, Subscript[m, ps]^2, <0|qbar \[Gamma]5 q|PS(>^2), \[Chi]^2/dof, seperation between adjacent trajectoreis/4, choice of the correlators, starting point of the fit ragne, ending point of the fit range*)
Export[StringJoin["processed_data/corr_I_fit_",suffix],{Table[IfitT[[i]][[1]],{i,1, Nboot}],Table[IfitT[[i]][[2]]^2,{i,1,Nboot}],chisquare,ntraj,dev,fs,fe,nconfstart},"Table"];
