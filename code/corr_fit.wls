(* Pseudo scalar *)

(* Import data and choose initial lattice parameters *)

rep = $ScriptCommandLine[[5]];
NT = ToExpression[$ScriptCommandLine[[6]]]; (*number of temporal lattice*)
NS = ToExpression[$ScriptCommandLine[[7]]]; (*number of one of the spatial lattice*)
beta = ToExpression[$ScriptCommandLine[[8]]];

nch = Switch[rep,
             "fun", 17,
             "asy", Switch[NT,
                           24, 17, (* L=24 used older code version with 17 channels *)
                           _, 21],
             _, Message["Unrecognised representation `1`", rep]; 0];
Zcoef = Switch[rep, "fun", 5 / 4, "asy", 2, _, Message["Unrecognised representation `1`", rep]; 0];

plaqimport =
  Import[StringJoin[$ScriptCommandLine[[2]], "/plaq_", $ScriptCommandLine[[3]],
    ".txt"], "Table"];

corrimport =
  Import[StringJoin[$ScriptCommandLine[[2]], "/meson_corr_", rep, "_", $ScriptCommandLine[[3]], ".txt"],
   "Table"]; (*import the correlators for all interpolating operators*)


{ntraj,dev,fstouse,fetouse,nconfstart} = Flatten[
  Import[StringJoin[$ScriptCommandLine[[4]], "/ps_params_", rep, "_", $ScriptCommandLine[[3]], ".txt"],
  "Table"]
];

(* ntraj: Number of trajectories between adjacent configurations would be \
ntraj*4, which take account for the autocorrelation length. There are ntraj \
sets of correlation functions.*)
(* dev: choose one of the possibilities for the choice of correlation functions *)
(* fstouse: starting point of the fit*)
(* fetouse: ending point of the fit*)
(* nconfstart: The initial trajectory at which the thermalization ends.*)

Nconftot = If[
   Length[corrimport]/nch/ntraj - Round[Length[corrimport]/nch/ntraj] >= 0,
   Round[Length[corrimport]/nch/ntraj],
   Round[Length[corrimport]/nch/ntraj] - 1] ;(*number of configurations*)
Nconf = Nconftot - nconfstart

Ntmax = Length[corrimport[[1]]] - 2; (*number of temporal lattice*)

(* Resampling data and plot effective mass plot *)

plaqT = Table[
   plaqimport[[ntraj*(i - 1) + 1 + dev]][[2]], {i, nconfstart + 1, Nconftot}];
{Mean[plaqT], StandardDeviation[plaqT]}

ch = 1;(*meson channel, e.g. ch=1 for the correlator of pseudoscalar meson*)

Do[corrimport[[ntraj*nch*(j - 1) + dev*nch + ch]] =
   Append[corrimport[[ntraj*nch*(j - 1) + dev*nch + ch]],
    corrimport[[ntraj*nch*(j - 1) + dev*nch + ch]][[3]]], {j, nconfstart + 1,
   Nconftot}]; (*copy the correlator at t=0 to that at t=Ntmax to make it \
symmetric.*)

corrg5T =
  Table[Table[
    NS^3 (corrimport[[ntraj*nch*(j - 1) + dev*nch + ch]][[i]] +
        corrimport[[ntraj*nch*(j - 1) + dev*nch + ch]][[Ntmax + 6 - i]])/2, {j,
     nconfstart + 1, Nconftot}], {i,
    3, (Ntmax + 2)/2 + 2}];(*average out the correlators at t and T-t.*)

ch = 17;(*meson channel, e.g. ch=17 for PS - AV correlator*)

Do[corrimport[[ntraj*nch*(j - 1) + dev*nch + ch]] =
   Append[corrimport[[ntraj*nch*(j - 1) + dev*nch + ch]],
    corrimport[[ntraj*nch*(j - 1) + dev*nch + ch]][[3]]], {j, nconfstart + 1,
   Nconftot}];(*copy the correlator at t=0 to that at t=Ntmax to make it \
symmetric.*)

corrg0g5T =
  Table[Table[
    NS^3 (corrimport[[ntraj*nch*(j - 1) + dev*nch + ch]][[i]] -
        corrimport[[ntraj*nch*(j - 1) + dev*nch + ch]][[Ntmax + 6 - i]])/2, {j,
     nconfstart + 1, Nconftot}], {i,
    3, (Ntmax + 2)/2 + 2}]; (*average out the correlators at t and T-t.*)

Nboot = 200; (*number of samples resampled through bootstrapping*)

rndi = Table[
   Table[Round[RandomReal[{0, 1}] (Nconf - 1) + 1], {j, Nboot}], {i,
    Nconftot}]; (*generating random numbers*)

plaqbootT =
  Table[Mean[Table[plaqT[[rndi[[i]][[j]]]], {i, Nconf}]], {j,
    Nboot}]; (*resampled data for plaquettes*)

plaqbootavg = {Mean[plaqbootT], StandardDeviation[plaqbootT]};
{Mean[plaqbootT], StandardDeviation[plaqbootT]} // InputForm
Zv = 1 + Zcoef (-20.57) (8/beta)/(16 Pi^2 plaqbootavg[[1]])
Zav = 1 + Zcoef (-15.82) (8/beta)/(16 Pi^2 plaqbootavg[[1]])

corrg5bootT =
  Table[Table[
    Mean[Table[corrg5T[[k]][[rndi[[i]][[j]]]], {i, Nconf}]], {j, Nboot}], {k,
    Ntmax/2 + 1}]; (*resampled data for pseudoscalar correlators*)

corrg5bootavgT =
  Table[{k - 1, Mean[corrg5bootT[[k]]],
    StandardDeviation[corrg5bootT[[k]]]}, {k,
    Ntmax/2 +
     1}]; (*mean and standard deviation of resampled data for pseudoscalar \
correlators*)

corrg0g5bootT =
  Table[Table[
    Mean[Table[corrg0g5T[[k]][[rndi[[i]][[j]]]], {i, Nconf}]], {j,
     Nboot}], {k, Ntmax/2 + 1}]; (*resampled data for ps-av correlators*)

corrg0g5bootavgT =
  Table[{k - 1, Mean[corrg0g5bootT[[k]]],
    StandardDeviation[corrg0g5bootT[[k]]]}, {k,
    Ntmax/2 +
     1}]; (*mean and standard deviation of resampled data for ps-av \
correlators*)

(*Effective mass of pseudoscalar meson*)

meffg5tab =
  Table[{i,
    Mean[Table[
      ArcCosh[(corrg5bootT[[i]][[j]] +
          corrg5bootT[[i + 2]][[j]])/(2 corrg5bootT[[i + 1]][[j]])], {j,
       Nboot}]],
    StandardDeviation[
     Table[
      ArcCosh[(corrg5bootT[[i]][[j]] +
          corrg5bootT[[i + 2]][[j]])/(2 corrg5bootT[[i + 1]][[j]])], {j,
       Nboot}]]}, {i, 1, Ntmax/2 - 1}];
(*meffg0g5tab=Table[{i,Mean[Table[ArcCosh[(corrg0g5bootT[[i]][[j]]+\
corrg0g5bootT[[i+2]][[j]])/(2 \
corrg0g5bootT[[i+1]][[j]])],{j,Nboot}]],StandardDeviation[Table[ArcCosh[(\
corrg0g5bootT[[i]][[j]]+corrg0g5bootT[[i+2]][[j]])/(2 \
corrg0g5bootT[[i+1]][[j]])],{j,Nboot}]]},{i,1,Ntmax/2-1}];*)

g5mfeffplot =
 ErrorListPlot[
  Table[{{meffg5tab[[t]][[1]], meffg5tab[[t]][[2]]},
    ErrorBar[meffg5tab[[t]][[3]]]}, {t, 2, Ntmax/2 - 1}], Frame -> True,
  PlotRange -> {{0, Ntmax/2 + .5}, {0.3, 0.49}}, AxesStyle -> Thick,
  PlotMarkers -> {"\[EmptySquare]", 18}, PlotStyle -> RGBColor[0, 0, 0],
  AxesStyle -> Black, FrameStyle -> Black,
  FrameLabel -> {"t", "\!\(\*SubscriptBox[\(m\), \(eff\)]\)"},
  LabelStyle -> Directive[22, Black], ImageSize -> 600];(*effective mass plot*)

g5corrplot =
 ErrorListPlot[
  Table[{{corrg5bootavgT[[t]][[1]], corrg5bootavgT[[t]][[2]]},
    ErrorBar[corrg5bootavgT[[t]][[3]]]}, {t, 1, Ntmax/2 + 1}], Frame -> True,
  PlotRange -> {{0, Ntmax + 1}, All}, AxesStyle -> Thick,
  PlotMarkers -> {"\[EmptyCircle]", 15}, PlotStyle -> Red, AxesStyle -> Black,
   FrameStyle -> Black,
  FrameLabel -> {"t",
    "\!\(\*SubscriptBox[\(C\), \(\*SubscriptBox[\(\[Gamma]\), \(5\)], \
\*SubscriptBox[\(\[Gamma]\), \(5\)]\)]\)(t)"},
  LabelStyle -> Directive[22, Black],
  ImageSize -> 600];(*plot of the correlation function of pseudoscalar meson*)

g0g5corrplot =
 ErrorListPlot[
  Table[{{corrg0g5bootavgT[[t]][[1]], corrg0g5bootavgT[[t]][[2]]},
    ErrorBar[corrg0g5bootavgT[[t]][[3]]]}, {t, 1, Ntmax/2 + 1}],
  Frame -> True, PlotRange -> {{0, Ntmax + 1}, All}, AxesStyle -> Thick,
  PlotMarkers -> {"\[EmptyCircle]", 15}, PlotStyle -> Red, AxesStyle -> Black,
   FrameStyle -> Black,
  FrameLabel -> {"t",
    "\!\(\*SubscriptBox[\(C\), \(\*SubscriptBox[\(\[Gamma]\), \(0\)] \
\*SubscriptBox[\(\[Gamma]\), \(5\)], \*SubscriptBox[\(\[Gamma]\), \
\(5\)]\)]\)(t)"}, LabelStyle -> Directive[22, Black],
  ImageSize -> 600];(*plot of the correlation function of ps-av operator*)

(* Fit the data to the correlation function - fit the central values (find best chi-square) *)

Clear[f, g]
f[a_, b_, c_,
   x_] := (a^2/b) (Exp[-b x] +
     Exp[-b (NT -
         x)]); (*fitting function for the ps meson, b is the mass and a is \
the ps amplitude <0|qbar \[Gamma]5 q|PS>*)

g[a_, b_, c_,
   x_] := (a c/Zav) (Exp[-b x] -
     Exp[-b (NT -
         x)]);(*fitting function for the ps-av operator, c is the ps decay \
constant*)

(*extract the fitting parameters throught \[Chi]^2 minimization - center \
values*)
(*we use this analysis to see the quality of the fit and determint \
the fit range*)
Do[
 fe = fetouse(*-l+1*);(*ending point of the fit*)

 fs = fstouse; (*starting point of the fit*)

 np = 2 (fe - fs + 1); (*total number of data points used for the fit*)

 dof = np - 3;
 g5cov = Table[
   Table[Mean[
     Table[(corrg5bootT[[j]][[i]] -
         corrg5bootavgT[[j]][[2]]) (corrg5bootT[[k]][[i]] -
         corrg5bootavgT[[k]][[2]]), {i, Nboot}]], {j, fs, fe}], {k, fs, fe}];
 g0g5cov =
  Table[Table[
    Mean[Table[(corrg0g5bootT[[j]][[i]] -
         corrg0g5bootavgT[[j]][[2]]) (corrg0g5bootT[[k]][[i]] -
         corrg0g5bootavgT[[k]][[2]]), {i, Nboot}]], {j, fs, fe}], {k, fs, fe}];
 invg5cov = Inverse[g5cov];
 invg0g5cov = Inverse[g0g5cov];
 tmp = NMinimize[
   Sum[Sum[(corrg5bootavgT[[j]][[2]] - f[a, b, c, corrg5bootavgT[[j]][[1]]])*
       invg5cov[[j - fs + 1]][[k - fs + 1]]*
                      (corrg5bootavgT[[k]][[2]] -
         f[a, b, c, corrg5bootavgT[[k]][[1]]]) + (corrg0g5bootavgT[[j]][[
          2]] - g[a, b, c, corrg0g5bootavgT[[j]][[1]]])*

       invg0g5cov[[j - fs + 1]][[
        k - fs + 1]]*(corrg0g5bootavgT[[k]][[2]] -
         g[a, b, c, corrg0g5bootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs,
     fe}],
          {a, b, c}, Method -> "DifferentialEvolution"];
 mfit = {a /. tmp[[2]][[1]], b /. tmp[[2]][[2]], c /. tmp[[2]][[3]],
   tmp[[1]]/dof};
 chisquare =
  Sum[Sum[(corrg5bootavgT[[j]][[2]] -
         f[mfit[[1]], mfit[[2]], mfit[[3]], corrg5bootavgT[[j]][[1]]])*
       invg5cov[[j - fs + 1]][[k - fs + 1]]*
                    (corrg5bootavgT[[k]][[2]] -
         f[mfit[[1]], mfit[[2]], mfit[[3]], corrg5bootavgT[[k]][[1]]]) +
                 (corrg0g5bootavgT[[j]][[2]] -
         g[mfit[[1]], mfit[[2]], mfit[[3]], corrg0g5bootavgT[[j]][[1]]])*
       invg0g5cov[[j - fs + 1]][[k - fs + 1]]*
                    (corrg0g5bootavgT[[k]][[2]] -
         g[mfit[[1]], mfit[[2]], mfit[[3]], corrg0g5bootavgT[[k]][[1]]]), {j,
      fs, fe}], {k, fs, fe}]/dof, {l, 1, 10}]

(* Fit the data to the correlation function - defining the fit functions and covariant matrix *)

Clear[f, g]

fe = fetouse;(*ending point of the fit*)
fs = fstouse; (*starting point of the fit*)

np = 2 (fe - fs + 1); (*total number of data points used for the fit*)

dof = np - 3; (*degree of freedom*)

f[a_, b_, c_,
   x_] := (a^2/b) (Exp[-b x] +
     Exp[-b (NT -
         x)]); (*fitting function for the ps meson, b is the mass and a is \
the ps amplitude <0|qbar \[Gamma]5 q|PS>*)

g[a_, b_, c_,
   x_] := (a c/Zav) (Exp[-b x] -
     Exp[-b (NT -
         x)]);(*fitting function for the ps-av operator, c is the ps decay \
constant*)

(*covariant matrix*)

g5cov = Table[
   Table[Mean[
     Table[(corrg5bootT[[j]][[i]] -
         corrg5bootavgT[[j]][[2]]) (corrg5bootT[[k]][[i]] -
         corrg5bootavgT[[k]][[2]]), {i, Nboot}]], {j, fs, fe}], {k, fs, fe}];
g0g5cov =
  Table[Table[
    Mean[Table[(corrg0g5bootT[[j]][[i]] -
         corrg0g5bootavgT[[j]][[2]]) (corrg0g5bootT[[k]][[i]] -
         corrg0g5bootavgT[[k]][[2]]), {i, Nboot}]], {j, fs, fe}], {k, fs,
    fe}];

(*the inverse of the covariant matrix*)
invg5cov = Inverse[g5cov];
invg0g5cov = Inverse[g0g5cov];

(* Fit the data to the correlation function - fit the central values *)

(*extract the fitting parameters throught \[Chi]^2 minimization - center \
values*)
(*we use this analysis to see the quality of the fit and determint \
the fit range*)

tmp = NMinimize[
   Sum[Sum[(corrg5bootavgT[[j]][[2]] - f[a, b, c, corrg5bootavgT[[j]][[1]]])*
       invg5cov[[j - fs + 1]][[k - fs + 1]]*
                      (corrg5bootavgT[[k]][[2]] -
         f[a, b, c, corrg5bootavgT[[k]][[1]]]) + (corrg0g5bootavgT[[j]][[
          2]] - g[a, b, c, corrg0g5bootavgT[[j]][[1]]])*

       invg0g5cov[[j - fs + 1]][[
        k - fs + 1]]*(corrg0g5bootavgT[[k]][[2]] -
         g[a, b, c, corrg0g5bootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs,
     fe}],
          {a, b, c}, Method -> "DifferentialEvolution"];
mfit = {a /. tmp[[2]][[1]], b /. tmp[[2]][[2]], c /. tmp[[2]][[3]],
  tmp[[1]]/dof};
chisquare =
 Sum[Sum[(corrg5bootavgT[[j]][[2]] -
        f[mfit[[1]], mfit[[2]], mfit[[3]], corrg5bootavgT[[j]][[1]]])*
      invg5cov[[j - fs + 1]][[k - fs + 1]]*
                   (corrg5bootavgT[[k]][[2]] -
        f[mfit[[1]], mfit[[2]], mfit[[3]], corrg5bootavgT[[k]][[1]]]) +
                (corrg0g5bootavgT[[j]][[2]] -
        g[mfit[[1]], mfit[[2]], mfit[[3]], corrg0g5bootavgT[[j]][[1]]])*
      invg0g5cov[[j - fs + 1]][[k - fs + 1]]*
                   (corrg0g5bootavgT[[k]][[2]] -
        g[mfit[[1]], mfit[[2]], mfit[[3]], corrg0g5bootavgT[[k]][[1]]]), {j,
     fs, fe}], {k, fs, fe}]/dof;

(*plot the fit results of the central values*)


(* g5fitplot = Plot[f[mfit[[1]], mfit[[2]], mfit[[3]], x], {x, 1, 50}]; *)
(* g0g5fitplot = Plot[g[mfit[[1]], mfit[[2]], mfit[[3]], x], {x, 1, 50}]; *)
(* Show[{g5corrplot, g5fitplot}, PlotRange -> {{10, 24.5}, {-0.0000001, 0.0001}}] *)

(* Fit the data to the correlation function - fit all configurations *)

(*extrac the fitting parameters throught \[Chi]^2 minimization - all \
configurations*)

g5fitT = Table[
   tmp = NMinimize[
     Sum[Sum[(corrg5bootT[[j]][[i]] -
           f[a, b, c, corrg5bootavgT[[j]][[1]]]) invg5cov[[j - fs + 1]][[
          k - fs + 1]] (corrg5bootT[[k]][[i]] -
           f[a, b, c, corrg5bootavgT[[k]][[1]]]) + (corrg0g5bootT[[j]][[i]] -
           g[a, b, c, corrg0g5bootavgT[[j]][[1]]]) invg0g5cov[[j - fs + 1]][[
          k - fs + 1]] (corrg0g5bootT[[k]][[i]] -
           g[a, b, c, corrg0g5bootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs,
       fe}], {a, b, c},
     Method -> {"RandomSearch", "SearchPoints" -> 100}]; {a /. tmp[[2]][[1]],
    b /. tmp[[2]][[2]], c /. tmp[[2]][[3]], tmp[[1]]/dof}, {i, 1, Nboot}];

distplot =
 ListPlot[Table[{g5fitT[[i]][[2]], Abs[g5fitT[[i]][[3]]]}, {i, 1, Nboot}](*,
  PlotRange\[Rule]{{0.2,0.45},{0.0055,0.15}}*),
  PlotStyle -> {Red, Opacity[0.8]}];

(*average and standard deviation of the fit results*)
g5fit =
 Table[{Mean[Table[Abs[g5fitT[[i]][[k]]], {i, 1, Nboot}]],
   StandardDeviation[Table[Abs[g5fitT[[i]][[k]]], {i, 1, Nboot}]]}, {k, 1, 4}];

(* Table[{Mean[Table[Abs[g5fitT[[i]][[k]]], {i, 1, Nboot}]], *)
(*    StandardDeviation[Table[Abs[g5fitT[[i]][[k]]], {i, 1, Nboot}]]}, {k, 1, *)
(*    4}] // InputForm; *)

(*average and standard deviation of the fit results*)
g5sqfit =
 Table[{Mean[Table[g5fitT[[i]][[k]]^2, {i, 1, Nboot}]],
   StandardDeviation[Table[Abs[g5fitT[[i]][[k]]], {i, 1, Nboot}]]}, {k, 1, 4}];

(*Show the effective mass plot with fit results*)

mefffitplot =
  Plot[{g5fit[[2]][[1]] + g5fit[[2]][[2]],
    g5fit[[2]][[1]] - g5fit[[2]][[2]]}, {x, fs - .5, fe + .5},
   Filling -> True, PlotStyle -> Directive[RGBColor[0, 0, 1], Opacity[.3]]];
(* g5mfitplot = Show[g5mfeffplot, mefffitplot] *)

mpiL = {Mean[Table[Abs[g5fitT[[i]][[2]] NS], {i, 1, Nboot}]],
  StandardDeviation[Table[Abs[g5fitT[[i]][[2]] NS], {i, 1, Nboot}]]};

fpiL = {Mean[Table[Abs[g5fitT[[i]][[3]] NS], {i, 1, Nboot}]],
  StandardDeviation[Table[Abs[g5fitT[[i]][[3]] NS], {i, 1, Nboot}]]};

mpifpiR = {Mean[Table[Abs[g5fitT[[i]][[2]]/g5fitT[[i]][[3]]], {i, 1, Nboot}]],
    StandardDeviation[
    Table[Abs[g5fitT[[i]][[2]]/g5fitT[[i]][[3]]], {i, 1, Nboot}]]} //
  InputForm;


(*export fit results: Subscript[f, PS]^2, Subscript[m, ps]^2, <0|qbar \
\[Gamma]5 q|PS(>^2), \[Chi]^2/dof, seperation between adjacent \
trajectoreis/4, choice of the correlators, starting point of the fit ragne, \
ending point of the fit range*)

Export[StringJoin[$ScriptCommandLine[[2]], "/corr_ps_fit_", rep, "_", $ScriptCommandLine[[3]],
   ".txt"], {Table[g5fitT[[i]][[3]]^2, {i, 1, Nboot}],
   Table[g5fitT[[i]][[2]]^2, {i, 1, Nboot}],
   Table[g5fitT[[i]][[1]]^2, {i, 1, Nboot}], chisquare, ntraj, dev, fs, fe,
   nconfstart}, "Table"];

(* Vector meson -Subscript[\[Gamma], 1] *)

(* Import data and choose initial lattice parameters *)

{ntraj,dev,fstouse,fetouse,nconfstart} = Flatten[
  Import[StringJoin[$ScriptCommandLine[[4]], "/v_params_", rep, "_", $ScriptCommandLine[[3]], ".txt"], "Table"]
];

corrimport =
  Import[StringJoin[$ScriptCommandLine[[2]], "/vmeson_corr_", rep, "_", $ScriptCommandLine[[3]], ".txt"],
   "Table"]; (*import the correlators for the vector meson interpolating \
operators*)
(*ntraj=3;*)
(*Number of trajectories between adjacent \
configurations would be ntraj*4, which take account for the autocorrelation \
length. There are ntraj sets of correlation functions.*)

Nconftot = If[
   Length[corrimport]/3/ntraj - Round[Length[corrimport]/3/ntraj] >= 0,
   Round[Length[corrimport]/3/ntraj],
   Round[Length[corrimport]/3/ntraj] -
    1] ;(*number of configurations: 3 is for the three spartial directions*)


Ntmax = Length[corrimport[[1]]] -
   2;(*number of temporal lattice*)
(*nconfstart=13;*)(*The initial \
trajectory at which the thermalization ends.*)

(* Resampling data and plot effective mass plot *)

ch = 1;(*vector meson channel, I already extracted the channel g1, g2, g3 \
from the output file of the measurement by using mk_mesons_with_z2semwall_new \
*)
Do[corrimport[[(j - 1) + ch]] =
   Append[corrimport[[(j - 1) + ch]], corrimport[[(j - 1) + ch]][[3]]], {j,
   nconfstart + 1,
   3 ntraj*
    Nconftot}];(*copy the correlator at t=0 to that at t=Ntmax to make it \
symmetric.*)


corrT = Table[
   Table[NS^3 (corrimport[[ntraj*3*(j - 1) + dev*3 + ch]][[i]] +
         corrimport[[ntraj*3*(j - 1) + dev*3 + ch + 1]][[i]] +
         corrimport[[ntraj*3*(j - 1) + dev*3 + ch + 2]][[i]] +
         corrimport[[ntraj*3*(j - 1) + dev*3 + ch]][[Ntmax + 6 - i]] +
         corrimport[[ntraj*3*(j - 1) + dev*3 + ch + 1]][[Ntmax + 6 - i]] +
         corrimport[[ntraj*3*(j - 1) + dev*3 + ch + 2]][[Ntmax + 6 - i]])/2/
      3, {j, nconfstart + 1, Nconftot}], {i,
    3, (Ntmax + 2)/2 +
     2}]; (*average out the correlators at t and T-t, and also over the three \
spatial directions.*)

(* Histogram[Table[corrT[[20]][[i]], {i, Nconftot}]]; *)

corrbootT =
  Table[Table[
    Mean[Table[corrT[[k]][[rndi[[i]][[j]]]], {i, Nconf}]], {j, Nboot}], {k,
    Ntmax/2 + 1}];(*resampled data for vector correlators*)

corrbootavgT =
  Table[{k - 1, Mean[corrbootT[[k]]], StandardDeviation[corrbootT[[k]]]}, {k,
    Ntmax/2 +
     1}];(*mean and standard deviation of resampled data for vector \
correlators*)


(*Effective mass of vector meson*)

mefftab =
  Table[{i,
    Mean[Table[
      ArcCosh[(corrbootT[[i]][[j]] +
          corrbootT[[i + 2]][[j]])/(2 corrbootT[[i + 1]][[j]])], {j, Nboot}]],
     StandardDeviation[
     Table[
      ArcCosh[(corrbootT[[i]][[j]] +
          corrbootT[[i + 2]][[j]])/(2 corrbootT[[i + 1]][[j]])], {j,
       Nboot}]]}, {i, 1, Ntmax/2 - 1}];

(*effective mass plot*)
g1mfmeffplot =
 ErrorListPlot[
  Table[{{mefftab[[t]][[1]], mefftab[[t]][[2]]},
    ErrorBar[mefftab[[t]][[3]]]}, {t, 1, Ntmax/2 - 1}], Frame -> True,
  PlotRange -> {{3.5, Ntmax/2}, {0.4, 0.64}}, AxesStyle -> Thick,
  PlotMarkers -> {"\[EmptyCircle]", 15}, PlotStyle -> RGBColor[1, 0, 0],
  AxesStyle -> Black, FrameStyle -> Black,
  FrameLabel -> {"\[Tau]", "\!\(\*SubscriptBox[\(m\), \(eff\)]\)"},
  LabelStyle -> Directive[22, Black], ImageSize -> 600];

(*plot of the correlation function of vector meson*)
g1corrplot =
 ErrorListPlot[
  Table[{{corrbootavgT[[t]][[1]], corrbootavgT[[t]][[2]]},
    ErrorBar[corrbootavgT[[t]][[3]]]}, {t, 2, Ntmax/2 + 1}], Frame -> True,
  PlotRange -> {{0, Ntmax + 1}, All}, AxesStyle -> Thick,
  PlotMarkers -> {"\[EmptyCircle]", 15}, PlotStyle -> Red, AxesStyle -> Black,
   FrameStyle -> Black, FrameLabel -> {"t", "C(t)"},
  LabelStyle -> Directive[22, Black], ImageSize -> 600];

(* Fit the data to the correlation function - fit the central values (find best chi-square) *)

Clear[f]
f[a_, b_,
   x_] := (a b/Zv^2) (Exp[-b x] +
     Exp[-b (NT -
         x)]);(*fitting function for the vector meson, b is the mass and a is \
the vector decay constant squared.*)

(*extract the fitting parameters throught \[Chi]^2 minimization - center \
values*)
(*we use this analysis to see the quality of the fit and determint \
the fit range*)
Do[
 fe = fetouse; (*-l+1*);(*ending point of the fit*)

 fs = fstouse; (*starting point of the fit*)

 np = (fe - fs + 1); (*total number of data points used for the fit*)

 dof = np - 2;
 (*covariant matrix*)

 cov = Table[
   Table[Mean[
     Table[(corrbootT[[j]][[i]] -
         corrbootavgT[[j]][[2]]) (corrbootT[[k]][[i]] -
         corrbootavgT[[k]][[2]]), {i, Nboot}]], {j, fs, fe}], {k, fs, fe}];
 (*the inverse of the covariant matrix*)
 invcov = Inverse[cov];
 tmp = NMinimize[
   Sum[Sum[(corrbootavgT[[j]][[2]] - f[a, b, corrbootavgT[[j]][[1]]]) invcov[[
        j - fs + 1]][[
       k - fs + 1]] (corrbootavgT[[k]][[2]] -
        f[a, b, corrbootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs, fe}], {a, b},
   Method -> "DifferentialEvolution"];
 mfit = {a /. tmp[[2]][[1]], b /. tmp[[2]][[2]]};
 chisquare =
  Sum[Sum[(corrbootavgT[[j]][[2]] -
        f[mfit[[1]], mfit[[2]], corrbootavgT[[j]][[1]]]) invcov[[
        j - fs + 1]][[
       k - fs + 1]] (corrbootavgT[[k]][[2]] -
        f[mfit[[1]], mfit[[2]], corrbootavgT[[k]][[1]]]), {j, fs, fe}], {k,
     fs, fe}]/dof, {l, 1, 10}]

(* Fit the data to the correlation function - defining the fit functions and covariant matrix *)

Clear[f]

fe = fetouse;(*ending point of the fit*)
fs = fstouse; (*starting point of the fit*)

np = fe - fs + 1; (*total number of data points used for the fit*)

dof = np - 2;(*degree of freedom*)

f[a_, b_,
   x_] := (a b/Zv^2) (Exp[-b x] +
     Exp[-b (NT -
         x)]);(*fitting function for the vector meson, b is the mass and a is \
the vector decay constant squared.*)

(*covariant matrix*)

cov = Table[
   Table[Mean[
     Table[(corrbootT[[j]][[i]] -
         corrbootavgT[[j]][[2]]) (corrbootT[[k]][[i]] -
         corrbootavgT[[k]][[2]]), {i, Nboot}]], {j, fs, fe}], {k, fs, fe}];

(*the inverse of the covariant matrix*)
invcov = Inverse[cov];

(* Fit the data to the correlation function - fit the central values *)

(*extract the fitting parameters throught \[Chi]^2 minimization - center \
values*)
(*we use this analysis to see the quality of the fit and determint \
the fit range*)

tmp = NMinimize[
   Sum[Sum[(corrbootavgT[[j]][[2]] - f[a, b, corrbootavgT[[j]][[1]]]) invcov[[
        j - fs + 1]][[
       k - fs + 1]] (corrbootavgT[[k]][[2]] -
        f[a, b, corrbootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs, fe}], {a, b},
   Method -> "DifferentialEvolution"];
mfit = {a /. tmp[[2]][[1]], b /. tmp[[2]][[2]], tmp[[1]]/dof};
chisquare =
 Sum[Sum[(corrbootavgT[[j]][[2]] -
       f[mfit[[1]], mfit[[2]], corrbootavgT[[j]][[1]]]) invcov[[j - fs + 1]][[
      k - fs + 1]] (corrbootavgT[[k]][[2]] -
       f[mfit[[1]], mfit[[2]], corrbootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs,
     fe}]/dof;

(*plot the fit results of the central values*)

fitplot = Plot[f[mfit[[1]], mfit[[2]], x], {x, 1, 50}];
(* Show[{g1corrplot, fitplot}, *)
(*  PlotRange -> {{fs - 4, 48 - fs + 3}, {-0.0000001, 0.00001}}] *)

(* Fit the data to the correlation function - fit all configurations *)

(*extract the fitting parameters throught \[Chi]^2 minimization - all \
configurations*)

g1fitT = Table[
   tmp = NMinimize[
     Sum[Sum[(corrbootT[[j]][[i]] - f[a, b, corrbootavgT[[j]][[1]]]) invcov[[
          j - fs + 1]][[
         k - fs + 1]] (corrbootT[[k]][[i]] -
          f[a, b, corrbootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs, fe}], {a,
      b}(*, Method -> "DifferentialEvolution",MaxIterations\[Rule]150*)]; {a /.
     tmp[[2]][[1]], b /. tmp[[2]][[2]]}, {i, 1, Nboot}];

(* ListPlot[Table[{g1fitT[[i]][[2]], Sqrt[g1fitT[[i]][[1]]]}, {i, 1, *)
(*    Nboot}](\*,PlotRange\[Rule]{{0.37,0.53},{0.052,0.115}}*\)] *)

(*average and standard deviation of the fit results*)
g1fit =
 Table[{Mean[Table[Abs[g1fitT[[i]][[k]]], {i, 1, Nboot}]],
   StandardDeviation[Table[Abs[g1fitT[[i]][[k]]], {i, 1, Nboot}]]}, {k, 1, 2}];

Table[{Mean[Table[Abs[g1fitT[[i]][[k]]], {i, 1, Nboot}]],
   StandardDeviation[Table[Abs[g1fitT[[i]][[k]]], {i, 1, Nboot}]]}, {k, 1,
   2}] // InputForm;

(*average and standard deviation of the fit results*)
g1sqfit =
 Table[{Mean[Table[Sqrt[g1fitT[[i]][[k]]], {i, 1, Nboot}]],
   StandardDeviation[Table[Sqrt[g1fitT[[i]][[k]]], {i, 1, Nboot}]]}, {k, 1,
   2}];

(*Show the effective mass plot with fit results*)

mefffitplot =
  Plot[{g1fit[[2]][[1]] + g1fit[[2]][[2]],
    g1fit[[2]][[1]] - g1fit[[2]][[2]]}, {x, fs - .5, fe + .5},
   Filling -> True, PlotStyle -> Directive[RGBColor[1, 0, 0], Opacity[.3]]];
(* g1mfitplot = Show[{g1mfmeffplot, mefffitplot}]; *)

mpimrhoR = {Mean[Table[g5fitT[[i]][[2]]/g1fitT[[i]][[2]], {i, 1, Nboot}]],
   StandardDeviation[
    Table[g5fitT[[i]][[2]]/g1fitT[[i]][[2]], {i, 1, Nboot}]]} // InputForm;

mrhompiR = {Mean[Table[g1fitT[[i]][[2]]/g5fitT[[i]][[2]], {i, 1, Nboot}]],
  StandardDeviation[Table[g1fitT[[i]][[2]]/g5fitT[[i]][[2]], {i, 1, Nboot}]]};

mrhofpiR = {Mean[
    Table[Abs[g1fitT[[i]][[2]]/g5fitT[[i]][[3]]], {i, 1, Nboot}]],
   StandardDeviation[
    Table[Abs[g1fitT[[i]][[2]]/g5fitT[[i]][[3]]], {i, 1, Nboot}]]} //
  InputForm;

mrhofpiR = {Mean[
    Table[Abs[g1fitT[[i]][[2]]/g5fitT[[i]][[3]]/Sqrt[2]], {i, 1, Nboot}]],
   StandardDeviation[
    Table[Abs[g1fitT[[i]][[2]]/g5fitT[[i]][[3]]/Sqrt[2]], {i, 1, Nboot}]]} //
  InputForm;

mrhofrhoR = {Mean[
   Table[Abs[g1fitT[[i]][[2]]/Sqrt[g1fitT[[i]][[1]]]], {i, 1, Nboot}]],
  StandardDeviation[
   Table[Abs[g1fitT[[i]][[2]]/Sqrt[g1fitT[[i]][[1]]]], {i, 1, Nboot}]]};

frhofpiR = {Mean[
   Table[Abs[Sqrt[g1fitT[[i]][[1]]]/g5fitT[[i]][[3]]], {i, 1, Nboot}]],
  StandardDeviation[
   Table[Abs[Sqrt[g1fitT[[i]][[1]]]/g5fitT[[i]][[3]]], {i, 1, Nboot}]]};

mpimrho2R = {Mean[
   Table[(g5fitT[[i]][[2]]/g1fitT[[i]][[2]])^2, {i, 1, Nboot}]],
  StandardDeviation[
   Table[(g5fitT[[i]][[2]]/g1fitT[[i]][[2]])^2, {i, 1, Nboot}]]};

(*export fit results: Subscript[f, PS]^2, Subscript[m, ps]^2, <0|qbar \
\[Gamma]5 q|PS(>^2), \[Chi]^2/dof, seperation between adjacent \
trajectoreis/4, choice of the correlators, starting point of the fit ragne, \
ending point of the fit range*)

Export[StringJoin[$ScriptCommandLine[[2]], "/corr_v_fit_", rep, "_", $ScriptCommandLine[[3]],
   ".txt"], {Table[g1fitT[[i]][[1]], {i, 1, Nboot}],
   Table[g1fitT[[i]][[2]]^2, {i, 1, Nboot}], chisquare, ntraj, dev, fs, fe,
   nconfstart}, "Table"];


(* Scalar meson - S *)

(* Import data and choose initial lattice parameters *)

scalarParamsFile = StringJoin[$ScriptCommandLine[[4]], "/s_params_", rep, "_", $ScriptCommandLine[[3]], ".txt"]
If[FileExistsQ[scalarParamsFile],None,Quit[]];

{ntraj,dev,fstouse,fetouse,nconfstart} = Flatten[Import[scalarParamsFile, "Table"]];

corrimport =
  Import[StringJoin[$ScriptCommandLine[[2]], "/meson_corr_", rep, "_", $ScriptCommandLine[[3]], ".txt"],
   "Table"]; (*import the correlators for all interpolating operators*)

Nconftot = If[
   Length[corrimport]/nch/ntraj - Round[Length[corrimport]/nch/ntraj] >= 0,
   Round[Length[corrimport]/nch/ntraj],
   Round[Length[corrimport]/nch/ntraj] - 1] ;(*number of configurations*)

Ntmax = Length[corrimport[[1]]] - 2;(*number of temporal lattice*)

(* Resampling data and plot effective mass plot *)

ch = 2;(*meson channel, e.g. ch=1 for the correlator of pseudoscalar meson*)

Do[corrimport[[ntraj*nch*(j - 1) + dev*nch + ch]] =
   Append[corrimport[[ntraj*nch*(j - 1) + dev*nch + ch]],
    corrimport[[ntraj*nch*(j - 1) + dev*nch + ch]][[3]]], {j, nconfstart + 1,
   Nconftot}]; (*copy the correlator at t=0 to that at t=Ntmax to make it \
symmetric.*)

corrIT = Table[
   Table[NS^3 (corrimport[[ntraj*nch*(j - 1) + dev*nch + ch]][[i]] +
        corrimport[[ntraj*nch*(j - 1) + dev*nch + ch]][[Ntmax + 6 - i]])/2, {j,
     nconfstart + 1, Nconftot}], {i,
    3, (Ntmax + 2)/2 + 2}];(*average out the correlators at t and T-t.*)

corrbootT =
  Table[Table[
    Mean[Table[corrIT[[k]][[rndi[[i]][[j]]]], {i, Nconf}]], {j, Nboot}], {k,
    Ntmax/2 + 1}];(*resampled data for vector correlators*)

corrbootavgT =
  Table[{k - 1, Mean[corrbootT[[k]]], StandardDeviation[corrbootT[[k]]]}, {k,
    Ntmax/2 +
     1}];(*mean and standard deviation of resampled data for vector \
correlators*)

(*Effective mass of axial-vector meson*)

mefftab =
  Table[{i,
    Mean[Table[
      ArcCosh[(corrbootT[[i]][[j]] +
          corrbootT[[i + 2]][[j]])/(2 corrbootT[[i + 1]][[j]])], {j, Nboot}]],
     StandardDeviation[
     Table[
      ArcCosh[(corrbootT[[i]][[j]] +
          corrbootT[[i + 2]][[j]])/(2 corrbootT[[i + 1]][[j]])], {j,
       Nboot}]]}, {i, 1, Ntmax/2 - 1}];

(*effective mass plot*)
Imeffplot =
 ErrorListPlot[
  Table[{{mefftab[[t]][[1]], mefftab[[t]][[2]]},
    ErrorBar[mefftab[[t]][[3]]]}, {t, 1, Ntmax/2 - 1}], Frame -> True,
  PlotRange -> {{1, Ntmax/2}, {0.4, 0.89}}, AxesStyle -> Thick,
  PlotMarkers -> {"\[EmptyDiamond]", 20}, PlotStyle -> RGBColor[1, 0, 1],
  AxesStyle -> Black, FrameStyle -> Black,
  FrameLabel -> {"\[Tau]", "\!\(\*SubscriptBox[\(m\), \(eff\)]\)"},
  LabelStyle -> Directive[22, Black], ImageSize -> 600];

(*plot of the correlation function of axial-vector meson*)
Icorrplot =
 ErrorListPlot[
  Table[{{corrbootavgT[[t]][[1]], corrbootavgT[[t]][[2]]},
    ErrorBar[corrbootavgT[[t]][[3]]]}, {t, 2, Ntmax/2 + 1}], Frame -> True,
  PlotRange -> {{0, Ntmax + 1}, All}, AxesStyle -> Thick,
  PlotMarkers -> {"\[EmptyCircle]", 15}, PlotStyle -> Red, AxesStyle -> Black,
   FrameStyle -> Black, FrameLabel -> {"t", "C(t)"},
  LabelStyle -> Directive[22, Black], ImageSize -> 600];

(* Fit the data to the correlation function - fit the central values (find best chi-square) *)

Clear[f]
f[a_, b_,
   x_] := (a b) (Exp[-b x] +
     Exp[-b (NT -
         x)]);(*fitting function for the axial-vector meson, b is the mass \
and a is the axial-vector decay constant squared.*)

(*extract the fitting parameters throught \[Chi]^2 minimization - center \
values*)
(*we use this analysis to see the quality of the fit and determint \
the fit range*)
Do[
 fe = fetouse;(*-l+1*);(*ending point of the fit*)

 fs = fstouse; (*starting point of the fit*)

 np = (fe - fs + 1); (*total number of data points used for the fit*)

 dof = np - 2;
 (*covariant matrix*)

 cov = Table[
   Table[Mean[
     Table[(corrbootT[[j]][[i]] -
         corrbootavgT[[j]][[2]]) (corrbootT[[k]][[i]] -
         corrbootavgT[[k]][[2]]), {i, Nboot}]], {j, fs, fe}], {k, fs, fe}];
 (*the inverse of the covariant matrix*)
 invcov = Inverse[cov];
 tmp = NMinimize[
   Sum[Sum[(corrbootavgT[[j]][[2]] - f[a, b, corrbootavgT[[j]][[1]]]) invcov[[
        j - fs + 1]][[
       k - fs + 1]] (corrbootavgT[[k]][[2]] -
        f[a, b, corrbootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs, fe}], {a, b},
   Method -> "DifferentialEvolution"];
 mfit = {a /. tmp[[2]][[1]], b /. tmp[[2]][[2]]};
 chisquare =
  Sum[Sum[(corrbootavgT[[j]][[2]] -
        f[mfit[[1]], mfit[[2]], corrbootavgT[[j]][[1]]]) invcov[[
        j - fs + 1]][[
       k - fs + 1]] (corrbootavgT[[k]][[2]] -
        f[mfit[[1]], mfit[[2]], corrbootavgT[[k]][[1]]]), {j, fs, fe}], {k,
     fs, fe}]/dof, {l, 1, 10}]

(* Fit the data to the correlation function - defining the fit functions and covariant matrix *)

Clear[f]

fe = fetouse;(*ending point of the fit*)
fs = fstouse; (*starting point of the fit*)

np = fe - fs + 1;(*total number of data points used for the fit*)

dof = np - 2;(*degree of freedom*)

f[a_, b_,
   x_] := (a b) (Exp[-b x] +
     Exp[-b (NT -
         x)]);(*fitting function for the axial-vector meson, b is the mass \
and a is the axial-vector decay constant squared.*)

(*covariant matrix*)

cov = Table[
   Table[Mean[
     Table[(corrbootT[[j]][[i]] -
         corrbootavgT[[j]][[2]]) (corrbootT[[k]][[i]] -
         corrbootavgT[[k]][[2]]), {i, Nboot}]], {j, fs, fe}], {k, fs, fe}];

(*the inverse of the covariant matrix*)
invcov = Inverse[cov];

(* Fit the data to the correlation function - fit the central values *)

(*extract the fitting parameters throught \[Chi]^2 minimization - center \
values*)
(*we use this analysis to see the quality of the fit and determint \
the fit range*)

tmp = NMinimize[
   Sum[Sum[(corrbootavgT[[j]][[2]] - f[a, b, corrbootavgT[[j]][[1]]]) invcov[[
        j - fs + 1]][[
       k - fs + 1]] (corrbootavgT[[k]][[2]] -
        f[a, b, corrbootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs, fe}], {a, b},
   Method -> "DifferentialEvolution"];
mfit = {a /. tmp[[2]][[1]], b /. tmp[[2]][[2]]}
chisquare =
 Sum[Sum[(corrbootavgT[[j]][[2]] -
       f[mfit[[1]], mfit[[2]], corrbootavgT[[j]][[1]]]) invcov[[j - fs + 1]][[
      k - fs + 1]] (corrbootavgT[[k]][[2]] -
       f[mfit[[1]], mfit[[2]], corrbootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs,
     fe}]/dof;

(*plot the fit results of the central values*)

fitplot = Plot[f[mfit[[1]], mfit[[2]], x], {x, 1, 50}];
(* Show[{Icorrplot, fitplot}, PlotRange -> {{4, 25}, {-0.000001, 0.00005}}] *)

(* Fit the data to the correlation function - fit all configurations *)

(*extract the fitting parameters throught \[Chi]^2 minimization - all \
configurations*)

IfitT = Table[
   tmp = NMinimize[
     Sum[Sum[(corrbootT[[j]][[i]] - f[a, b, corrbootavgT[[j]][[1]]]) invcov[[
          j - fs + 1]][[
         k - fs + 1]] (corrbootT[[k]][[i]] -
          f[a, b, corrbootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs, fe}], {a,
      b}(*,Method\[Rule]{"RandomSearch","SearchPoints"\[Rule]100}*)]; {a /.
     tmp[[2]][[1]], b /. tmp[[2]][[2]]}, {i, 1, Nboot}];

(*average and standard deviation of the fit results*)
Ifit =
 Table[{Mean[Table[Abs[IfitT[[i]][[k]]], {i, 1, Nboot}]],
   StandardDeviation[Table[Abs[IfitT[[i]][[k]]], {i, 1, Nboot}]]}, {k, 1, 2}]

Table[{Mean[Table[Abs[IfitT[[i]][[k]]], {i, 1, Nboot}]],
   StandardDeviation[Table[Abs[IfitT[[i]][[k]]], {i, 1, Nboot}]]}, {k, 1,
   2}] // InputForm

(*average and standard deviation of the fit results*)
I2fit =
 Table[{Mean[Table[Sqrt[IfitT[[i]][[k]]], {i, 1, Nboot}]],
   StandardDeviation[Table[Abs[IfitT[[i]][[k]]], {i, 1, Nboot}]]}, {k, 1, 2}]

(*Show the effective mass plot with fit results*)

mefffitplot =
  Plot[{Ifit[[2]][[1]] + Ifit[[2]][[2]], Ifit[[2]][[1]] - Ifit[[2]][[2]]}, {x,
     fs - .5, fe + .5}, Filling -> True,
   PlotStyle -> Directive[RGBColor[1, 0, 1], Opacity[0.3]]];
(* Imfitplot = Show[{Imeffplot, mefffitplot}] *)

msfpiR = {Mean[Table[Abs[IfitT[[i]][[2]]/g5fitT[[i]][[3]]], {i, 1, Nboot}]],
   StandardDeviation[
    Table[Abs[IfitT[[i]][[2]]/g5fitT[[i]][[3]]], {i, 1, Nboot}]]} // InputForm

(*export fit results: Subscript[f, PS]^2, Subscript[m, ps]^2, <0|qbar \
\[Gamma]5 q|PS(>^2), \[Chi]^2/dof, seperation between adjacent \
trajectoreis/4, choice of the correlators, starting point of the fit ragne, \
ending point of the fit range*)

Export[StringJoin[$ScriptCommandLine[[2]], "/corr_s_fit_", rep, "_", $ScriptCommandLine[[3]],
   ".txt"], {Table[IfitT[[i]][[1]], {i, 1, Nboot}],
   Table[IfitT[[i]][[2]]^2, {i, 1, Nboot}], chisquare, ntraj, dev, fs, fe,
   nconfstart}, "Table"];


(* Tensor meson -Subscript[\[Gamma], 1] Subscript[\[Gamma], 0] *)

(* Import data and choose initial lattice parameters *)

tensorParamsFile = StringJoin[$ScriptCommandLine[[4]], "/t_params_", rep, "_", $ScriptCommandLine[[3]], ".txt"]
If[FileExistsQ[tensorParamsFile],None,Quit[]];
{ntraj,dev,fstouse,fetouse,nconfstart} = Flatten[Import[tensorParamsFile, "Table"]];

corrimport =
  Import[StringJoin[$ScriptCommandLine[[2]], "/tmeson_corr_", rep, "_", $ScriptCommandLine[[3]], ".txt"],
   "Table"];  (*import the correlators for the vector meson interpolating \
operators*)
(*ntraj=2;*)(*Number of trajectories between adjacent \
configurations would be ntraj*4, which take account for the autocorrelation \
length. There are ntraj sets of correlation functions.*)

Nconftot = If[
   Length[corrimport]/3/ntraj - Round[Length[corrimport]/3/ntraj] >= 0,
   Round[Length[corrimport]/3/ntraj],
   Round[Length[corrimport]/3/ntraj] -
    1] ;(*number of configurations: 3 is for the three spartial directions*)

Ntmax = Length[corrimport[[1]]] - 2;(*number of temporal lattice*)



(* Resampling data and plot effective mass plot *)

ch = 1;(*vector meson channel, I already extracted the channel g1, g2, g3 \
from the output file of the measurement by using mk_mesons_with_z2semwall_new \
*)
Do[corrimport[[(j - 1) + ch]] =
   Append[corrimport[[(j - 1) + ch]], corrimport[[(j - 1) + ch]][[3]]], {j,
   nconfstart + 1,
   3 ntraj*
    Nconftot}];(*copy the correlator at t=0 to that at t=Ntmax to make it \
symmetric.*)

corrT = Table[
   Table[NS^3 (corrimport[[ntraj*3*(j - 1) + dev*3 + ch]][[i]] +
         corrimport[[ntraj*3*(j - 1) + dev*3 + ch + 1]][[i]] +
         corrimport[[ntraj*3*(j - 1) + dev*3 + ch + 2]][[i]] +
         corrimport[[ntraj*3*(j - 1) + dev*3 + ch]][[Ntmax + 6 - i]] +
         corrimport[[ntraj*3*(j - 1) + dev*3 + ch + 1]][[Ntmax + 6 - i]] +
         corrimport[[ntraj*3*(j - 1) + dev*3 + ch + 2]][[Ntmax + 6 - i]])/2/
      3, {j, nconfstart + 1, Nconftot}], {i,
    3, (Ntmax + 2)/2 +
     2}]; (*average out the correlators at t and T-t, and also over the three \
spatial directions.*)

corrbootT =
  Table[Table[
    Mean[Table[corrT[[k]][[rndi[[i]][[j]]]], {i, Nconf}]], {j, Nboot}], {k,
    Ntmax/2 + 1}];(*resampled data for vector correlators*)

corrbootavgT =
  Table[{k - 1, Mean[corrbootT[[k]]], StandardDeviation[corrbootT[[k]]]}, {k,
    Ntmax/2 +
     1}];(*mean and standard deviation of resampled data for vector \
correlators*)

(*Effective mass of vector meson*)

mefftab =
  Table[{i,
    Mean[Table[
      ArcCosh[(corrbootT[[i]][[j]] +
          corrbootT[[i + 2]][[j]])/(2 corrbootT[[i + 1]][[j]])], {j, Nboot}]],
     StandardDeviation[
     Table[
      ArcCosh[(corrbootT[[i]][[j]] +
          corrbootT[[i + 2]][[j]])/(2 corrbootT[[i + 1]][[j]])], {j,
       Nboot}]]}, {i, 1, Ntmax/2 - 1}];

(*effective mass plot*)
g1g0meffplot =
 ErrorListPlot[
  Table[{{mefftab[[t]][[1]], mefftab[[t]][[2]]},
    ErrorBar[mefftab[[t]][[3]]]}, {t, 1, Ntmax/2 - 1}], Frame -> True,
  PlotRange -> {{3.5, Ntmax/2}, {0.38, 0.78}}, AxesStyle -> Thick,
  PlotMarkers -> {"\[EmptyCircle]", 15}, PlotStyle -> RGBColor[0, 0, 1],
  AxesStyle -> Black, FrameStyle -> Black,
  FrameLabel -> {"\[Tau]", "\!\(\*SubscriptBox[\(m\), \(eff\)]\)"},
  LabelStyle -> Directive[22, Black], ImageSize -> 600];

(*plot of the correlation function of vector meson*)
g1g0corrplot =
 ErrorListPlot[
  Table[{{corrbootavgT[[t]][[1]], corrbootavgT[[t]][[2]]},
    ErrorBar[corrbootavgT[[t]][[3]]]}, {t, 2, Ntmax/2 + 1}], Frame -> True,
  PlotRange -> {{0, Ntmax + 1}, All}, AxesStyle -> Thick,
  PlotMarkers -> {"\[EmptyCircle]", 15}, PlotStyle -> Red, AxesStyle -> Black,
   FrameStyle -> Black, FrameLabel -> {"t", "C(t)"},
  LabelStyle -> Directive[22, Black], ImageSize -> 600];

(* Fit the data to the correlation function - definining the fit functions and covariant matrix *)

Clear[f]

f[a_, b_,
   x_] := (a b/Zv^2) (Exp[-b x] +
     Exp[-b (NT -
         x)]);(*fitting function for the vector meson, b is the mass and a is \
the vector decay constant squared.*)

(*extract the fitting parameters throught \[Chi]^2 minimization - center \
values*)
(*we use this analysis to see the quality of the fit and determint \
the fit range*)
Do[
 fe = fetouse;(*-l+1*) (*ending point of the fit*)

 fs = fstouse; (*starting point of the fit*)

 np = (fe - fs + 1); (*total number of data points used for the fit*)

 dof = np - 2;
 (*covariant matrix*)

 cov = Table[
   Table[Mean[
     Table[(corrbootT[[j]][[i]] -
         corrbootavgT[[j]][[2]]) (corrbootT[[k]][[i]] -
         corrbootavgT[[k]][[2]]), {i, Nboot}]], {j, fs, fe}], {k, fs, fe}];
 (*the inverse of the covariant matrix*)
 invcov = Inverse[cov];
 tmp = NMinimize[
   Sum[Sum[(corrbootavgT[[j]][[2]] - f[a, b, corrbootavgT[[j]][[1]]]) invcov[[
        j - fs + 1]][[
       k - fs + 1]] (corrbootavgT[[k]][[2]] -
        f[a, b, corrbootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs, fe}], {a, b},
   Method -> "DifferentialEvolution"];
 mfit = {a /. tmp[[2]][[1]], b /. tmp[[2]][[2]]};
 chisquare =
  Sum[Sum[(corrbootavgT[[j]][[2]] -
        f[mfit[[1]], mfit[[2]], corrbootavgT[[j]][[1]]]) invcov[[
        j - fs + 1]][[
       k - fs + 1]] (corrbootavgT[[k]][[2]] -
        f[mfit[[1]], mfit[[2]], corrbootavgT[[k]][[1]]]), {j, fs, fe}], {k,
     fs, fe}]/dof, {l, 1, 10}]

(* Fit the data to the correlation function - fit the central values *)

fe = fetouse;(*ending point of the fit*)
fs = fstouse; (*starting point of the fit*)

np = fe - fs + 1; (*total number of data points used for the fit*)

dof = np - 2;(*degree of freedom*)

(*covariant matrix*)

cov = Table[
   Table[Mean[
     Table[(corrbootT[[j]][[i]] -
         corrbootavgT[[j]][[2]]) (corrbootT[[k]][[i]] -
         corrbootavgT[[k]][[2]]), {i, Nboot}]], {j, fs, fe}], {k, fs, fe}];

(*the inverse of the covariant matrix*)
invcov = Inverse[cov];

(*extract the fitting parameters throught \[Chi]^2 minimization - center \
values*)
(*we use this analysis to see the quality of the fit and determint \
the fit range*)

tmp = NMinimize[
   Sum[Sum[(corrbootavgT[[j]][[2]] - f[a, b, corrbootavgT[[j]][[1]]]) invcov[[
        j - fs + 1]][[
       k - fs + 1]] (corrbootavgT[[k]][[2]] -
        f[a, b, corrbootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs, fe}], {a, b},
   Method -> "DifferentialEvolution"];
mfit = {a /. tmp[[2]][[1]], b /. tmp[[2]][[2]]}
chisquare =
 Sum[Sum[(corrbootavgT[[j]][[2]] -
       f[mfit[[1]], mfit[[2]], corrbootavgT[[j]][[1]]]) invcov[[j - fs + 1]][[
      k - fs + 1]] (corrbootavgT[[k]][[2]] -
       f[mfit[[1]], mfit[[2]], corrbootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs,
     fe}]/dof;

(*plot the fit results of the central values*)

fitplot = Plot[f[mfit[[1]], mfit[[2]], x], {x, 1, 50}];
(* Show[{g1g0corrplot, fitplot}, *)
(*  PlotRange -> {{fs - 3, 42 - fs + 3}, {-0.0000001, 0.00001}}] *)

(* Fit the data to the correlation function - fit all configurations *)

(*extract the fitting parameters throught \[Chi]^2 minimization - all \
configurations*)

g1g0fitT =
  Table[tmp =
    NMinimize[
     Sum[Sum[(corrbootT[[j]][[i]] - f[a, b, corrbootavgT[[j]][[1]]]) invcov[[
          j - fs + 1]][[
         k - fs + 1]] (corrbootT[[k]][[i]] -
          f[a, b, corrbootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs, fe}], {a,
      b}(*, Method\[Rule]{"RandomSearch","SearchPoints"\[Rule]200}(*, Method ->
     "DifferentialEvolution",MaxIterations\[Rule]150*)*)]; {a /.
     tmp[[2]][[1]], b /. tmp[[2]][[2]]}, {i, 1, Nboot}];

(*average and standard deviation of the fit results*)
g1g0fit =
 Table[{Mean[Table[Abs[g1g0fitT[[i]][[k]]], {i, 1, Nboot}]],
   StandardDeviation[Table[Abs[g1g0fitT[[i]][[k]]], {i, 1, Nboot}]]}, {k, 1,
   2}];

Table[{Mean[Table[Abs[g1g0fitT[[i]][[k]]], {i, 1, Nboot}]],
   StandardDeviation[Table[Abs[g1g0fitT[[i]][[k]]], {i, 1, Nboot}]]}, {k, 1,
   2}] // InputForm;

(*average and standard deviation of the fit results*)
g1g0sqfit =
 Table[{Mean[Table[Sqrt[g1g0fitT[[i]][[k]]], {i, 1, Nboot}]],
   StandardDeviation[Table[Sqrt[g1g0fitT[[i]][[k]]], {i, 1, Nboot}]]}, {k, 1,
   2}];

(*Show the effective mass plot with fit results*)

mefffitplot =
  Plot[{g1g0fit[[2]][[1]] + g1g0fit[[2]][[2]],
    g1g0fit[[2]][[1]] - g1g0fit[[2]][[2]]}, {x, fs - .5, fe - .5},
   Filling -> True];
(* Show[{g1g0meffplot, mefffitplot}] *)

mpimrhog0R = {Mean[Table[g5fitT[[i]][[2]]/g1g0fitT[[i]][[2]], {i, 1, Nboot}]],
   StandardDeviation[
   Table[g5fitT[[i]][[2]]/g1g0fitT[[i]][[2]], {i, 1, Nboot}]]};

mrhog0mpiR = {Mean[Table[g1g0fitT[[i]][[2]]/g5fitT[[i]][[2]], {i, 1, Nboot}]],
   StandardDeviation[
   Table[g1g0fitT[[i]][[2]]/g5fitT[[i]][[2]], {i, 1, Nboot}]]};

mrhog0fpiR = {Mean[
   Table[Abs[g1g0fitT[[i]][[2]]/g5fitT[[i]][[3]]], {i, 1, Nboot}]],
  StandardDeviation[
   Table[Abs[g1g0fitT[[i]][[2]]/g5fitT[[i]][[3]]], {i, 1, Nboot}]]};

mpimrhog02R = {Mean[
   Table[(g5fitT[[i]][[2]]/g1g0fitT[[i]][[2]])^2, {i, 1, Nboot}]],
  StandardDeviation[
   Table[(g5fitT[[i]][[2]]/g1g0fitT[[i]][[2]])^2, {i, 1, Nboot}]]};

(*export fit results: Subscript[f, PS]^2, Subscript[m, ps]^2, <0|qbar \
\[Gamma]5 q|PS(>^2), \[Chi]^2/dof, seperation between adjacent \
trajectoreis/4, choice of the correlators, starting point of the fit ragne, \
ending point of the fit range*)

Export[StringJoin[$ScriptCommandLine[[2]], "/corr_t_fit_", rep, "_", $ScriptCommandLine[[3]],
   ".txt"], {Table[g1g0fitT[[i]][[1]], {i, 1, Nboot}],
   Table[g1g0fitT[[i]][[2]]^2, {i, 1, Nboot}], chisquare, ntraj, dev, fs, fe,
   nconfstart}, "Table"];

(* Axial-Vector meson - Subscript[\[Gamma], 5] Subscript[\[Gamma], i] *)

(* Import data and choose initial lattice parameters *)

{ntraj,dev,fstouse,fetouse,nconfstart} = Flatten[
  Import[StringJoin[$ScriptCommandLine[[4]], "/av_params_", rep, "_", $ScriptCommandLine[[3]], ".txt"], "Table"]
];

corrimport =
  Import[StringJoin[$ScriptCommandLine[[2]], "/avmeson_corr_", rep, "_", $ScriptCommandLine[[3]], ".txt"],
   "Table"]; (*import the correlators for the axial-vector meson \
interpolating operators*)
(*ntraj=3;*)(*Number of trajectories between \
adjacent configurations would be ntraj*4, which take account for the \
autocorrelation length. There are ntraj sets of correlation functions.*)

Nconftot = If[
   Length[corrimport]/3/ntraj - Round[Length[corrimport]/3/ntraj] >= 0,
   Round[Length[corrimport]/3/ntraj],
   Round[Length[corrimport]/3/ntraj] -
    1] ;(*number of configurations: 3 is for the three spartial directions*)

Ntmax = Length[corrimport[[1]]] - 2;(*number of temporal lattice*)

(* Resampling data and plot effective mass plot *)

ch = 1;(*axial-vector meson channel, I already extracted the channel g5g1, \
g5g2, g5g3 from the output file of the measurement by using \
mk_mesons_with_z2semwall_new *)

Do[corrimport[[(j - 1) + ch]] =
   Append[corrimport[[(j - 1) + ch]], corrimport[[(j - 1) + ch]][[3]]], {j,
   nconfstart + 1, 3 ntraj*Nconftot}];
(*copy the correlator at t=0 to that at t=Ntmax to make it symmetric.*)

corrT = Table[
   Table[NS^3 (corrimport[[ntraj*3*(j - 1) + dev*3 + ch]][[i]] +
         corrimport[[ntraj*3*(j - 1) + dev*3 + ch + 1]][[i]] +
         corrimport[[ntraj*3*(j - 1) + dev*3 + ch + 2]][[i]] +
         corrimport[[ntraj*3*(j - 1) + dev*3 + ch]][[Ntmax + 6 - i]] +
         corrimport[[ntraj*3*(j - 1) + dev*3 + ch + 1]][[Ntmax + 6 - i]] +
         corrimport[[ntraj*3*(j - 1) + dev*3 + ch + 2]][[Ntmax + 6 - i]])/2/
      3, {j, nconfstart + 1, Nconftot}], {i,
    3, (Ntmax + 2)/2 +
     2}];(*average out the correlators at t and T-t, and also over the three \
spatial directions.*)

corrbootT =
  Table[Table[
    Mean[Table[corrT[[k]][[rndi[[i]][[j]]]], {i, Nconf}]], {j, Nboot}], {k,
    Ntmax/2 + 1}];(*resampled data for vector correlators*)

corrbootavgT =
  Table[{k - 1, Mean[corrbootT[[k]]], StandardDeviation[corrbootT[[k]]]}, {k,
    Ntmax/2 +
     1}];(*mean and standard deviation of resampled data for vector \
correlators*)

(*Effective mass of axial-vector meson*)

mefftab =
  Table[{i,
    Mean[Table[
      ArcCosh[(corrbootT[[i]][[j]] +
          corrbootT[[i + 2]][[j]])/(2 corrbootT[[i + 1]][[j]])], {j, Nboot}]],
     StandardDeviation[
     Table[
      ArcCosh[(corrbootT[[i]][[j]] +
          corrbootT[[i + 2]][[j]])/(2 corrbootT[[i + 1]][[j]])], {j,
       Nboot}]]}, {i, 1, Ntmax/2 - 1}];

(*effective mass plot*)
g5g1meffplot =
 ErrorListPlot[
  Table[{{mefftab[[t]][[1]], mefftab[[t]][[2]]},
    ErrorBar[mefftab[[t]][[3]]]}, {t, 1, Ntmax/2 - 1}], Frame -> True,
  PlotRange -> {{1, Ntmax/2}, {0.4, 0.9}}, AxesStyle -> Thick,
  PlotMarkers -> {"\[EmptyUpTriangle]", 18}, PlotStyle -> RGBColor[0, .5, 0],
  AxesStyle -> Black, FrameStyle -> Black,
  FrameLabel -> {"\[Tau]", "\!\(\*SubscriptBox[\(m\), \(eff\)]\)"},
  LabelStyle -> Directive[22, Black], ImageSize -> 600];

(*plot of the correlation function of axial-vector meson*)
g5g1corrplot =
 ErrorListPlot[
  Table[{{corrbootavgT[[t]][[1]], corrbootavgT[[t]][[2]]},
    ErrorBar[corrbootavgT[[t]][[3]]]}, {t, 2, Ntmax/2 + 1}], Frame -> True,
  PlotRange -> {{0, Ntmax + 1}, All}, AxesStyle -> Thick,
  PlotMarkers -> {"\[EmptyCircle]", 15}, PlotStyle -> Red, AxesStyle -> Black,
   FrameStyle -> Black, FrameLabel -> {"t", "C(t)"},
  LabelStyle -> Directive[22, Black], ImageSize -> 600];

(* Fit the data to the correlation function - fit the central values (find best chi-square) *)

Clear[f]
f[a_, b_,
   x_] := (a b/Zav^2) (Exp[-b x] +
     Exp[-b (NT -
         x)]);(*fitting function for the vector meson, b is the mass and a is \
the vector decay constant squared.*)

(*extract the fitting parameters throught \[Chi]^2 minimization - center \
values*)
(*we use this analysis to see the quality of the fit and determint \
the fit range*)
Do[
 fe = fetouse;(*-l+1*) (*ending point of the fit*)

 fs = fstouse; (*starting point of the fit*)

 np = (fe - fs + 1); (*total number of data points used for the fit*)

 dof = np - 2;
 (*covariant matrix*)

 cov = Table[
   Table[Mean[
     Table[(corrbootT[[j]][[i]] -
         corrbootavgT[[j]][[2]]) (corrbootT[[k]][[i]] -
         corrbootavgT[[k]][[2]]), {i, Nboot}]], {j, fs, fe}], {k, fs, fe}];
 (*the inverse of the covariant matrix*)
 invcov = Inverse[cov];
 tmp = NMinimize[
   Sum[Sum[(corrbootavgT[[j]][[2]] - f[a, b, corrbootavgT[[j]][[1]]]) invcov[[
        j - fs + 1]][[
       k - fs + 1]] (corrbootavgT[[k]][[2]] -
        f[a, b, corrbootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs, fe}], {a, b},
   Method -> "DifferentialEvolution"];
 mfit = {a /. tmp[[2]][[1]], b /. tmp[[2]][[2]]};
 chisquare =
  Sum[Sum[(corrbootavgT[[j]][[2]] -
        f[mfit[[1]], mfit[[2]], corrbootavgT[[j]][[1]]]) invcov[[
        j - fs + 1]][[
       k - fs + 1]] (corrbootavgT[[k]][[2]] -
        f[mfit[[1]], mfit[[2]], corrbootavgT[[k]][[1]]]), {j, fs, fe}], {k,
     fs, fe}]/dof, {l, 1, 10}]

(* Fit the data to the correlation function - defining the fit functions and covariant matrix *)

fe = fetouse;(*ending point of the fit*)
fs = fstouse; (*starting point of the fit*)

np = fe - fs + 1;(*total number of data points used for the fit*)

dof = np - 2;(*degree of freedom*)

(*covariant matrix*)

cov = Table[
   Table[Mean[
     Table[(corrbootT[[j]][[i]] -
         corrbootavgT[[j]][[2]]) (corrbootT[[k]][[i]] -
         corrbootavgT[[k]][[2]]), {i, Nboot}]], {j, fs, fe}], {k, fs, fe}];

(*the inverse of the covariant matrix*)
invcov = Inverse[cov];

(* Fit the data to the correlation function - fit the central values *)

(*extract the fitting parameters throught \[Chi]^2 minimization - center \
values*)
(*we use this analysis to see the quality of the fit and determint \
the fit range*)

tmp = NMinimize[
   Sum[Sum[(corrbootavgT[[j]][[2]] - f[a, b, corrbootavgT[[j]][[1]]]) invcov[[
        j - fs + 1]][[
       k - fs + 1]] (corrbootavgT[[k]][[2]] -
        f[a, b, corrbootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs, fe}], {a, b},
   Method -> "DifferentialEvolution"];
mfit = {a /. tmp[[2]][[1]], b /. tmp[[2]][[2]]};
chisquare =
 Sum[Sum[(corrbootavgT[[j]][[2]] -
       f[mfit[[1]], mfit[[2]], corrbootavgT[[j]][[1]]]) invcov[[j - fs + 1]][[
      k - fs + 1]] (corrbootavgT[[k]][[2]] -
       f[mfit[[1]], mfit[[2]], corrbootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs,
     fe}]/dof;

(*plot the fit results of the central values*)

fitplot = Plot[f[mfit[[1]], mfit[[2]], x], {x, 1, 50}];
(* Show[{g5g1corrplot, fitplot}, PlotRange -> {{7, 25}, {-0.000001, 0.00002}}] *)

(* Fit the data to the correlation function - fit all configurations *)

(*extract the fitting parameters throught \[Chi]^2 minimization - all \
configurations*)

g5g1fitT =
  Table[tmp =
    NMinimize[
     Sum[Sum[(corrbootT[[j]][[i]] - f[a, b, corrbootavgT[[j]][[1]]]) invcov[[
          j - fs + 1]][[
         k - fs + 1]] (corrbootT[[k]][[i]] -
          f[a, b, corrbootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs, fe}], {a,
      b}(*, Method\[Rule]{"RandomSearch","SearchPoints"\[Rule]200}*)]; {a /.
     tmp[[2]][[1]], b /. tmp[[2]][[2]]}, {i, 1, Nboot}];

(*average and standard deviation of the fit results*)
g5g1fit =
 Table[{Mean[Table[Abs[g5g1fitT[[i]][[k]]], {i, 1, Nboot}]],
   StandardDeviation[Table[Abs[g5g1fitT[[i]][[k]]], {i, 1, Nboot}]]}, {k, 1,
   2}];

Table[{Mean[Table[Abs[g5g1fitT[[i]][[k]]], {i, 1, Nboot}]],
   StandardDeviation[Table[Abs[g5g1fitT[[i]][[k]]], {i, 1, Nboot}]]}, {k, 1,
   2}] // InputForm;

(*average and standard deviation of the fit results*)
g5g1sqfit =
 Table[{Mean[Table[Sqrt[g5g1fitT[[i]][[k]]], {i, 1, Nboot}]],
   StandardDeviation[Table[Abs[g5g1fitT[[i]][[k]]], {i, 1, Nboot}]]}, {k, 1,
   2}];

(*Show the effective mass plot with fit results*)

mefffitplot =
  Plot[{g5g1fit[[2]][[1]] + g5g1fit[[2]][[2]],
    g5g1fit[[2]][[1]] - g5g1fit[[2]][[2]]}, {x, fs - .5, fe - .5},
   Filling -> True, PlotStyle -> Directive[RGBColor[0, .5, 0], Opacity[.3]]];
(* g5g1mfitplot = Show[{g5g1meffplot, mefffitplot}] *)

mavfpiR = {Mean[
   Table[Abs[g5g1fitT[[i]][[2]]/g5fitT[[i]][[3]]], {i, 1, Nboot}]],
  StandardDeviation[
   Table[Abs[g5g1fitT[[i]][[2]]/g5fitT[[i]][[3]]], {i, 1, Nboot}]]};

(*export fit results: Subscript[f, PS]^2, Subscript[m, ps]^2, <0|qbar \
\[Gamma]5 q|PS(>^2), \[Chi]^2/dof, seperation between adjacent \
trajectoreis/4, choice of the correlators, starting point of the fit ragne, \
ending point of the fit range*)

Export[StringJoin[$ScriptCommandLine[[2]], "/corr_av_fit_", rep, "_", $ScriptCommandLine[[3]],
   ".txt"], {Table[g5g1fitT[[i]][[1]], {i, 1, Nboot}],
   Table[g5g1fitT[[i]][[2]]^2, {i, 1, Nboot}], chisquare, ntraj, dev, fs, fe,
   nconfstart}, "Table"];



(* Axial-tensor meson - Subscript[\[Gamma], 0] Subscript[\[Gamma], 5] Subscript[\[Gamma], i] *)

(* Import data and choose initial lattice parameters *)

{ntraj,dev,fstouse,fetouse,nconfstart} = Flatten[
  Import[StringJoin[$ScriptCommandLine[[4]], "/at_params_", rep, "_", $ScriptCommandLine[[3]], ".txt"], "Table"]
];

corrimport =
  Import[StringJoin[$ScriptCommandLine[[2]], "/atmeson_corr_", rep, "_", $ScriptCommandLine[[3]], ".txt"],
   "Table"]; (*import the correlators for the axial-vector meson \
interpolating operators*)
(*ntraj=3;*)(*Number of trajectories between \
adjacent configurations would be ntraj*4, which take account for the \
autocorrelation length. There are ntraj sets of correlation functions.*)

Nconftot = If[
   Length[corrimport]/3/ntraj - Round[Length[corrimport]/3/ntraj] >= 0,
   Round[Length[corrimport]/3/ntraj],
   Round[Length[corrimport]/3/ntraj] -
    1] ;(*number of configurations: 3 is for the three spartial directions*)

Ntmax = Length[corrimport[[1]]] - 2;(*number of temporal lattice*)

(* Resampling data and plot effective mass plot *)

ch = 1;(*axial-vector meson channel, I already extracted the channel g5g1, \
g5g2, g5g3 from the output file of the measurement by using \
mk_mesons_with_z2semwall_new *)

Do[corrimport[[(j - 1) + ch]] =
   Append[corrimport[[(j - 1) + ch]], corrimport[[(j - 1) + ch]][[3]]], {j,
   nconfstart + 1, 3 ntraj*Nconftot}];
(*copy the correlator at t=0 to that at t=Ntmax to make it symmetric.*)

corrT = Table[
   Table[NS^3 (corrimport[[ntraj*3*(j - 1) + dev*3 + ch]][[i]] +
         corrimport[[ntraj*3*(j - 1) + dev*3 + ch + 1]][[i]] +
         corrimport[[ntraj*3*(j - 1) + dev*3 + ch + 2]][[i]] +
         corrimport[[ntraj*3*(j - 1) + dev*3 + ch]][[Ntmax + 6 - i]] +
         corrimport[[ntraj*3*(j - 1) + dev*3 + ch + 1]][[Ntmax + 6 - i]] +
         corrimport[[ntraj*3*(j - 1) + dev*3 + ch + 2]][[Ntmax + 6 - i]])/2/
      3, {j, nconfstart + 1, Nconftot}], {i,
    3, (Ntmax + 2)/2 +
     2}];(*average out the correlators at t and T-t, and also over the three \
spatial directions.*)

corrbootT =
  Table[Table[
    Mean[Table[corrT[[k]][[rndi[[i]][[j]]]], {i, Nconf}]], {j, Nboot}], {k,
    Ntmax/2 + 1}];(*resampled data for vector correlators*)

corrbootavgT =
  Table[{k - 1, Mean[corrbootT[[k]]], StandardDeviation[corrbootT[[k]]]}, {k,
    Ntmax/2 +
     1}];(*mean and standard deviation of resampled data for vector \
correlators*)

(*Effective mass of axial-vector meson*)

mefftab =
  Table[{i,
    Mean[Table[
      ArcCosh[(corrbootT[[i]][[j]] +
          corrbootT[[i + 2]][[j]])/(2 corrbootT[[i + 1]][[j]])], {j, Nboot}]],
     StandardDeviation[
     Table[
      ArcCosh[(corrbootT[[i]][[j]] +
          corrbootT[[i + 2]][[j]])/(2 corrbootT[[i + 1]][[j]])], {j,
       Nboot}]]}, {i, 1, Ntmax/2 - 1}];

(*effective mass plot*)
g5g1g0meffplot =
 ErrorListPlot[
  Table[{{mefftab[[t]][[1]], mefftab[[t]][[2]]},
    ErrorBar[mefftab[[t]][[3]]]}, {t, 1, Ntmax/2 - 1}], Frame -> True,
  PlotRange -> {{1, Ntmax/2}, {0.3, 0.9}}, AxesStyle -> Thick,
  PlotMarkers -> {"\[EmptySquare]", 18}, PlotStyle -> RGBColor[0, .5, 0],
  AxesStyle -> Black, FrameStyle -> Black,
  FrameLabel -> {"\[Tau]", "\!\(\*SubscriptBox[\(m\), \(eff\)]\)"},
  LabelStyle -> Directive[22, Black], ImageSize -> 600];

(*plot of the correlation function of axial-vector meson*)
g5g1g0corrplot =
 ErrorListPlot[
  Table[{{corrbootavgT[[t]][[1]], corrbootavgT[[t]][[2]]},
    ErrorBar[corrbootavgT[[t]][[3]]]}, {t, 2, Ntmax/2 + 1}], Frame -> True,
  PlotRange -> {{0, Ntmax + 1}, All}, AxesStyle -> Thick,
  PlotMarkers -> {"\[EmptyCircle]", 15}, PlotStyle -> Red, AxesStyle -> Black,
   FrameStyle -> Black, FrameLabel -> {"t", "C(t)"},
  LabelStyle -> Directive[22, Black], ImageSize -> 600];

(* Fit the data to the correlation function - fit the central values (find best chi-square) *)

Clear[f]
f[a_, b_,
   x_] := (a b/Zav^2) (Exp[-b x] +
     Exp[-b (NT -
         x)]);(*fitting function for the vector meson, b is the mass and a is \
the vector decay constant squared.*)

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
     Table[(corrbootT[[j]][[i]] -
         corrbootavgT[[j]][[2]]) (corrbootT[[k]][[i]] -
         corrbootavgT[[k]][[2]]), {i, Nboot}]], {j, fs, fe}], {k, fs, fe}];
 (*the inverse of the covariant matrix*)
 invcov = Inverse[cov];
 tmp = NMinimize[
   Sum[Sum[(corrbootavgT[[j]][[2]] - f[a, b, corrbootavgT[[j]][[1]]]) invcov[[
        j - fs + 1]][[
       k - fs + 1]] (corrbootavgT[[k]][[2]] -
        f[a, b, corrbootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs, fe}], {a, b},
   Method -> "DifferentialEvolution"];
 mfit = {a /. tmp[[2]][[1]], b /. tmp[[2]][[2]]};
 chisquare =
  Sum[Sum[(corrbootavgT[[j]][[2]] -
        f[mfit[[1]], mfit[[2]], corrbootavgT[[j]][[1]]]) invcov[[
        j - fs + 1]][[
       k - fs + 1]] (corrbootavgT[[k]][[2]] -
        f[mfit[[1]], mfit[[2]], corrbootavgT[[k]][[1]]]), {j, fs, fe}], {k,
     fs, fe}]/dof, {l, 1, 10}]

(* Fit the data to the correlation function - fit the central values *)

fe = fetouse;(*ending point of the fit*)
fs = fstouse; (*starting point of the fit*)

np = fe - fs + 1;(*total number of data points used for the fit*)

dof = np - 2;(*degree of freedom*)

(*covariant matrix*)

cov = Table[
   Table[Mean[
     Table[(corrbootT[[j]][[i]] -
         corrbootavgT[[j]][[2]]) (corrbootT[[k]][[i]] -
         corrbootavgT[[k]][[2]]), {i, Nboot}]], {j, fs, fe}], {k, fs, fe}];

(*the inverse of the covariant matrix*)
invcov = Inverse[cov];

(*extract the fitting parameters throught \[Chi]^2 minimization - center \
values*)
(*we use this analysis to see the quality of the fit and determint \
the fit range*)

tmp = NMinimize[
   Sum[Sum[(corrbootavgT[[j]][[2]] - f[a, b, corrbootavgT[[j]][[1]]]) invcov[[
        j - fs + 1]][[
       k - fs + 1]] (corrbootavgT[[k]][[2]] -
        f[a, b, corrbootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs, fe}], {a, b},
   Method -> "DifferentialEvolution"];
mfit = {a /. tmp[[2]][[1]], b /. tmp[[2]][[2]]}
chisquare =
 Sum[Sum[(corrbootavgT[[j]][[2]] -
       f[mfit[[1]], mfit[[2]], corrbootavgT[[j]][[1]]]) invcov[[j - fs + 1]][[
      k - fs + 1]] (corrbootavgT[[k]][[2]] -
       f[mfit[[1]], mfit[[2]], corrbootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs,
     fe}]/dof

(*plot the fit results of the central values*)

fitplot = Plot[f[mfit[[1]], mfit[[2]], x], {x, 1, 50}];
(* Show[{g5g1g0corrplot, fitplot}, PlotRange -> {{4, 25}, {-0.000001, 0.00005}}] *)

(* Fit the data to the correlation function - fit all configurations *)

(*extract the fitting parameters throught \[Chi]^2 minimization - all \
configurations*)

g5g1g0fitT =
  Table[tmp =
    NMinimize[
     Sum[Sum[(corrbootT[[j]][[i]] - f[a, b, corrbootavgT[[j]][[1]]]) invcov[[
          j - fs + 1]][[
         k - fs + 1]] (corrbootT[[k]][[i]] -
          f[a, b, corrbootavgT[[k]][[1]]]), {j, fs, fe}], {k, fs, fe}], {a,
      b}(*, Method\[Rule]{"RandomSearch","SearchPoints"\[Rule]200}*)]; {a /.
     tmp[[2]][[1]], b /. tmp[[2]][[2]]}, {i, 1, Nboot}];

(*average and standard deviation of the fit results*)
g5g1g0fit =
 Table[{Mean[Table[Abs[g5g1g0fitT[[i]][[k]]], {i, 1, Nboot}]],
   StandardDeviation[Table[Abs[g5g1g0fitT[[i]][[k]]], {i, 1, Nboot}]]}, {k, 1,
    2}];

Table[{Mean[Table[Abs[g5g1g0fitT[[i]][[k]]], {i, 1, Nboot}]],
   StandardDeviation[Table[Abs[g5g1g0fitT[[i]][[k]]], {i, 1, Nboot}]]}, {k, 1,
    2}] // InputForm;

(*average and standard deviation of the fit results*)
g5g1g0sqfit =
 Table[{Mean[Table[Sqrt[g5g1g0fitT[[i]][[k]]], {i, 1, Nboot}]],
   StandardDeviation[Table[Sqrt[g5g1g0fitT[[i]][[k]]], {i, 1, Nboot}]]}, {k,
   1, 2}];

(*Show the effective mass plot with fit results*)

mefffitplot =
  Plot[{g5g1g0fit[[2]][[1]] + g5g1g0fit[[2]][[2]],
    g5g1g0fit[[2]][[1]] - g5g1g0fit[[2]][[2]]}, {x, fs, fe},
   Filling -> True];
(* av2meffplot = Show[{g5g1g0meffplot, mefffitplot}, PlotRange -> {0.4, 1.99}] *)

mavfpiR = {Mean[
   Table[Abs[g5g1g0fitT[[i]][[2]]/g5fitT[[i]][[3]]], {i, 1, Nboot}]],
  StandardDeviation[
   Table[Abs[g5g1g0fitT[[i]][[2]]/g5fitT[[i]][[3]]], {i, 1, Nboot}]]};

(*export fit results: Subscript[f, PS]^2, Subscript[m, ps]^2, <0|qbar \
\[Gamma]5 q|PS(>^2), \[Chi]^2/dof, seperation between adjacent \
trajectoreis/4, choice of the correlators, starting point of the fit ragne, \
ending point of the fit range*)

Export[StringJoin[$ScriptCommandLine[[2]], "/corr_at_fit_", rep, "_", $ScriptCommandLine[[3]],
   ".txt"], {Table[g5g1g0fitT[[i]][[1]], {i, 1, Nboot}],
   Table[g5g1g0fitT[[i]][[2]]^2, {i, 1, Nboot}], chisquare, ntraj, dev, fs, fe,
   nconfstart}, "Table"];

