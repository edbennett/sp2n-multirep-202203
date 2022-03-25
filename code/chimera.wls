(* Extraction of mass from the Chimera baryon correlation function *)

NT = ToExpression[$ScriptCommandLine[[5]]]; (*number of temporal lattice*)
NS = ToExpression[$ScriptCommandLine[[6]]]; (*number of one of the spatial lattice*)
beta = ToExpression[$ScriptCommandLine[[7]]];

corrimport =
  Import[StringJoin[$ScriptCommandLine[[2]], "/ch_corr_", $ScriptCommandLine[[3]], ".txt"],
   "Table"]; (*import the correlators for 17 interpolating operators*)

{ntraj,dev,fstouse,fetouse,nconfstart} = Flatten[
  Import[StringJoin[$ScriptCommandLine[[4]], "/ch_params_", $ScriptCommandLine[[3]], ".txt"], "Table"]
];

Nconf = If[
    Length[corrimport]/(NT)/ntraj - Round[Length[corrimport]/ntraj] >= 0,
    Round[Length[corrimport]/(NT)/ntraj],
    Round[Length[corrimport]/(NT)/ntraj]] - 1 ;(*number of configurations*)

Ntmax = Length[corrimport[[1]]] - 2; (*number of temporal lattice*)

corrchT =
  Table[Table[
    corrimport[[NT*(ntraj*(j - 1) + dev) + (i - 1) + 1]][[3]], {j,
     nconfstart + 1, Nconf}], {i, 1, NT}];

nconf = Nconf - nconfstart; (*number of correlators used for the analysis*)

Nboot = 200; (*number of samples resampled through bootstrapping*)

rndi = Table[
   Table[Round[RandomReal[{0, 1}] (nconf - 1) + 1], {j, Nboot}], {i,
    nconf}]; (*generating random numbers*)

corrchbootT =
  Table[Table[
    Mean[Table[corrchT[[k]][[rndi[[i]][[j]]]], {i, nconf}]], {j, Nboot}], {k,
    NT}]; (*resampled data for pseudoscalar correlators*)

corrchbootavgT =
  Table[{k - 1, Mean[corrchbootT[[k]]],
    StandardDeviation[corrchbootT[[k]]]}, {k,
    NT}]; (*mean and standard deviation of resampled data for pseudoscalar \
correlators*)

(*corrchimbootT=Table[Table[Mean[Table[corrchimT[[k]][[rndi[[i]][[j]]]],{i,\
nconf}]],{j,Nboot}],{k,NT}]; (*resampled data for pseudoscalar correlators*)

corrchimbootavgT=Table[{k-1,Mean[corrchimbootT[[k]]],StandardDeviation[\
corrchimbootT[[k]]]},{k,NT}]; *)(*mean and standard deviation of resampled \
data for pseudoscalar correlators*)

(*Effective mass of chimera baryon*)
dt = 1;
meffchT =
  Table[Table[
    ArcCosh[(corrchbootT[[i]][[j]] +
         corrchbootT[[i + 2*dt]][[j]])/(2 corrchbootT[[i + dt]][[j]])]/dt, {j,
      Nboot}], {i, 1, NT - 1 - 2*dt}];
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
       dt, {j, Nboot}]]}, {i, 1, NT - 1 - 2*dt}];

chmeffplot =
 ErrorListPlot[
  Table[{{meffchtab[[t]][[1]], meffchtab[[t]][[2]]},
    ErrorBar[meffchtab[[t]][[3]]]}, {t, 2, NT - 1 - 2*dt}], Frame -> True,
  PlotRange -> {{0, NT}, {0.6, 1.5}}, AxesStyle -> Thick,
  PlotMarkers -> {"\[EmptyUpTriangle]", 18}, PlotStyle -> RGBColor[1, 0, 0],
  AxesStyle -> Black, FrameStyle -> Black,
  FrameLabel -> {"t", "\!\(\*SubscriptBox[\(m\), \(eff\)]\)"},
  LabelStyle -> Directive[22, Black], ImageSize -> 600](*effective mass plot*)

(*plot of the correlation function of chimera baryon*)
chcorrplot =
 ErrorListPlot[
  Table[{{corrchbootavgT[[t]][[1]], corrchbootavgT[[t]][[2]]},
    ErrorBar[corrchbootavgT[[t]][[3]]]}, {t, 4, NT/2}], Frame -> True,
  PlotRange -> {{0, NT/2 + 1}, All}, AxesStyle -> Thick,
  PlotMarkers -> {"\[EmptyCircle]", 15}, PlotStyle -> Red, AxesStyle -> Black,
   FrameStyle -> Black, FrameLabel -> {"t", "C(t)"},
  LabelStyle -> Directive[22, Black], ImageSize -> 600]

(*plot of the logarithm of the correlation function of chimera baryon*)
\
chlogcorrplot =
 ErrorListPlot[
  Table[{{corrchbootavgT[[t]][[1]], Log[-corrchbootavgT[[t]][[2]]]},
    ErrorBar[corrchbootavgT[[t]][[3]]]}, {t, 4, NT/2}], Frame -> True,
  PlotRange -> {{0, NT/2 + 1}, All}, AxesStyle -> Thick,
  PlotMarkers -> {"\[EmptyCircle]", 15}, PlotStyle -> Red, AxesStyle -> Black,
   FrameStyle -> Black, FrameLabel -> {"t", "C(t)"},
  LabelStyle -> Directive[22, Black], ImageSize -> 600]

(* Single exponential fit *)

(* Finding fitting range *)

Clear[f]
f[a_, b_, x_] := a Exp[-b x](*+a Exp[-b(NT-x)]*);

(*extract the fitting parameters throught \[Chi]^2 minimization - center \
values*)
(*we use this analysis to see the quality of the fit and determint \
the fit range*)
Do[
 fe = fetouse(*-l+1*);(*ending point of the fit*)

 fs = fstouse; (*starting point of the fit*)

 np = (fe - fs + 1); (*total number of data points used for the fit*)

 dof = np - 2;
 (*covariant matrix*)

 cov = Table[
   Table[Mean[
     Table[(corrchbootT[[j]][[i]] -
         corrchbootavgT[[j]][[2]]) (corrchbootT[[k]][[i]] -
         corrchbootavgT[[k]][[2]]), {i, Nboot}]], {j, fs, fe}], {k, fs, fe}];
 (*the inverse of the covariant matrix*)
 invcov = Inverse[cov];
 tmp = NMinimize[
   Sum[Sum[(corrchbootavgT[[j]][[2]] -
        f[a, b, corrchbootavgT[[j]][[1]]]) invcov[[j - fs + 1]][[
       k - fs + 1]] (corrchbootavgT[[k]][[2]] -
        f[a, b, corrchbootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs, fe}], {a,
    b}, Method -> "DifferentialEvolution"];
 mfit = {a /. tmp[[2]][[1]], b /. tmp[[2]][[2]]};
 chisquare =
  Sum[Sum[(corrchbootavgT[[j]][[2]] -
        f[mfit[[1]], mfit[[2]], corrchbootavgT[[j]][[1]]]) invcov[[
        j - fs + 1]][[
       k - fs + 1]] (corrchbootavgT[[k]][[2]] -
        f[mfit[[1]], mfit[[2]], corrchbootavgT[[k]][[1]]]), {j, fs, fe}], {k,
     fs, fe}]/dof, {l, 1, 10}]

(* Fit the data to the correlation function - defining the fit functions and covariant matrix *)

Clear[f]

fe = fetouse;(*ending point of the fit*)
fs = fstouse; (*starting point of the fit*)

np = fe - fs + 1; (*total number of data points used for the fit*)

dof = np - 2;(*degree of freedom*)

f[a_, b_, x_] := a Exp[-b x];

(*covariant matrix*)

cov = Table[
   Table[Mean[
     Table[(corrchbootT[[j]][[i]] -
         corrchbootavgT[[j]][[2]]) (corrchbootT[[k]][[i]] -
         corrchbootavgT[[k]][[2]]), {i, Nboot}]], {j, fs, fe}], {k, fs, fe}];

(*the inverse of the covariant matrix*)
invcov = Inverse[cov];

Fit the data to the correlation function - fit the central values

(*extract the fitting parameters throught \[Chi]^2 minimization - center values*)
(*we use this analysis to see the quality of the fit and determint the fit range*)

tmp = NMinimize[
   Sum[Sum[(corrchbootavgT[[j]][[2]] -
        f[a, b, corrchbootavgT[[j]][[1]]]) invcov[[j - fs + 1]][[
       k - fs + 1]] (corrchbootavgT[[k]][[2]] -
        f[a, b, corrchbootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs, fe}], {a,
    b}, Method -> "DifferentialEvolution"];
mfit = {a /. tmp[[2]][[1]], b /. tmp[[2]][[2]], tmp[[1]]/dof}
chisquare =
 Sum[Sum[(corrchbootavgT[[j]][[2]] -
       f[mfit[[1]], mfit[[2]], corrchbootavgT[[j]][[1]]]) invcov[[
       j - fs + 1]][[
      k - fs + 1]] (corrchbootavgT[[k]][[2]] -
       f[mfit[[1]], mfit[[2]], corrchbootavgT[[k]][[1]]]), {j, fs, fe}], {k,
    fs, fe}]/dof

(*plot the fit results of the central values*)

fitplot = Plot[f[mfit[[1]], mfit[[2]], x], {x, 0, 50}];
(* Show[{chcorrplot, fitplot}, *)
(*  PlotRange -> {{fs - 7, 24}, {-0.000000000008, 0.0000000000001}}] *)

(*plot the fit results of the central values*)

fitplot = Plot[Log[-f[mfit[[1]], mfit[[2]], x]], {x, 0, 25}];
(* Show[{chlogcorrplot, fitplot}, PlotRange -> {{fs - 7, 25}, {-30, -19}}] *)

(*extract the fitting parameters throught \[Chi]^2 minimization - all configurations*)

chfitT = Table[
   tmp = NMinimize[
     Sum[Sum[(corrchbootT[[j]][[i]] -
          f[a, b, corrchbootavgT[[j]][[1]]]) invcov[[j - fs + 1]][[
         k - fs + 1]] (corrchbootT[[k]][[i]] -
          f[a, b, corrchbootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs, fe}], {a,
      b}, Method -> {"RandomSearch", "SearchPoints" -> 100}]; {a /.
     tmp[[2]][[1]], b /. tmp[[2]][[2]]}, {i, 1, Nboot}];

(*average and standard deviation of the fit results*)
chfit =
 Table[{Mean[Table[Abs[chfitT[[i]][[k]]], {i, 1, Nboot}]],
   StandardDeviation[Table[Abs[chfitT[[i]][[k]]], {i, 1, Nboot}]]}, {k, 1, 2}]

chfit // InputForm

(*Show the effective mass plot with fit results*)

meffchplot =
  Plot[{chfit[[2]][[1]] + chfit[[2]][[2]],
    chfit[[2]][[1]] - chfit[[2]][[2]]}, {x, fs - .5, fe + .5},
   Filling -> True, PlotStyle -> Directive[RGBColor[0, 0, 1], Opacity[.3]]];
(* chmfitplot = Show[chmeffplot, meffchplot] *)

(* Show[chmfitplot, chmeffplot] *)

mchfpiR = {Mean[Table[Abs[chfitT[[i]][[2]]/g5fitT[[i]][[3]]], {i, 1, Nboot}]],
   StandardDeviation[
   Table[Abs[chfitT[[i]][[2]]/g5fitT[[i]][[3]]], {i, 1, Nboot}]]}

(*export fit results: Subscript[f, PS]^2, Subscript[m, ps]^2, <0|qbar \
\[Gamma]5 q|PS(>^2), \[Chi]^2/dof, seperation between adjacent \
trajectoreis/4, choice of the correlators, starting point of the fit ragne, \
ending point of the fit range*)

Export[StringJoin[$ScriptCommandLine[[2]], "/corr_ch_fit_", $ScriptCommandLine[[3]],
   ".txt"], {Table[chfitT[[i]][[1]], {i, 1, Nboot}],
   Table[chfitT[[i]][[2]], {i, 1, Nboot}], chisquare, ntraj, dev, fs, fe,
   nconfstart}, "Table"];
