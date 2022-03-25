#!/usr/bin/env wolframscript

Needs["ErrorBarPlots`"];
Needs["PlotLegends`"];

<<MaTeX`

texStyle={FontFamily->"Times",FontSize->20};


(* Chiral RMT *)

Nbeta[b_]:=2 Gamma[b/2+1]^(b+1)/Gamma[(b+1)/2]^(b+2);
cbeta[b_]:=Gamma[b/2+1]^2/Gamma[(b+1)/2]^2;

probf[b_,s_]:=Nbeta[b] s^b Exp[-cbeta[b] s^2];
(*The analytical formula of the unfolded density of eigenvalue spacings predicted by chRMT. b=1,2 and 4 correspond to chGOE, chGUE and chGSE, respectively.*)

Plot[probf[1,s],{s,0,3}]
Plot[probf[4,s],{s,0,3}]
Plot[probf[2,s],{s,0,3}]

(* Numerical results *)

(* Sp(4) fund 3^4(Figs. 14, 15) *)

NT=3; (*number of temporal lattice*)
NS=3; (*number of one of the spatial lattice*)
NC=4;(*number of colors*)
beta=8.0;
beta1=8;beta2="0"; (*lattice coupling*)
m0ND="-0.2"; (*bare fermion mass*)
m0=ToExpression[m0ND];
dr=4;(*dimension of the representation*)
kappa=1/(8+2 m0);

NEIGS=NT NS NS NS NC dr
NCUT=1296

eigimport=Import[StringJoin[$ScriptCommandLine[[2]], "/eigs_sorted_",ToString[NT],"x",ToString[NS],"x",ToString[NS],"x",ToString[NS],"b",ToString[beta1],".",ToString[beta2],"mf",ToString[m0ND]],"Table"];

nconf=Length[eigimport]/(NT NS NS NS NC dr)
neig=Length[eigimport]/nconf

delta=1;

eigsortedT=eigimport;

nstart = NEIGS-NCUT;
Clear[sT];
stmp=Table[1,{j,nconf}];

Do[count=0;
jtmp=NEIGS (l-1)+nstart+1;
nsT=Table[1,{j,neig}];
Do[tmp=eigsortedT[[i]][[1]];count+=1;If[tmp==jtmp,nsT[[jtmp-NEIGS (l-1)-nstart]]=count;jtmp+=1],{i,Length[eigsortedT]}];
stmp[[l]]=Table[Table[N[(nsT[[delta j+k]]-nsT[[delta (j-1)+k]])/(delta nconf)],{j,1,neig/delta-1(*-ucut*)}],{k,1,delta}],{l,1,nconf}]

Show[Table[ListPlot[Table[{j,stmp[[k]][[1]][[j]]},{j,1,Length[stmp[[1]][[1]]]}],PlotRange->{{0,1296},{0,15.5}},Frame->True,FrameLabel->{MaTeX["n",Magnification->2],MaTeX["s",Magnification->2]},FrameStyle->Directive[Black],BaseStyle->texStyle,ImageSize->500],{k,1,nconf}]]

sT=Flatten[stmp];
avg=Mean[sT]
sT=sT/avg;(*normalization*)

\[Delta]sdensity=Plot[PDF[HistogramDistribution[sT,500],x],{x,0,4},PlotRange->{{0,3.6},{0,1.45}},PlotStyle->RGBColor[0,0,0],Filling->None,Exclusions->None,Frame->True,FrameLabel->{MaTeX["s",Magnification->2],MaTeX["\\textrm{P}(s)",Magnification->2]},FrameStyle->Directive[Black],BaseStyle->texStyle,ImageSize->600]

dsmax=3;
Show[{\[Delta]sdensity,Plot[probf[1,s],{s,0,dsmax},PlotStyle->RGBColor[0,0,1]],Plot[probf[2,s],{s,0,dsmax},PlotStyle->RGBColor[0,.5,0]],Plot[probf[4,s],{s,0,dsmax},PlotStyle->Red]},ImageSize->600]


(*Fig. 14*)
Export[
  $ScriptCommandLine[[7]],
  ShowLegend[dsmax=3;
    Show[{\[Delta]sdensity, Plot[probf[1, s], {s, 0, dsmax},
 PlotStyle -> RGBColor[0, 0, 1]], Plot[probf[2, s], {s, 0, dsmax},
 PlotStyle -> RGBColor[0, .5, 0]], Plot[probf[4, s], {s, 0, dsmax},
 PlotStyle -> Red]},ImageSize->600],{{{Graphics[{RGBColor[0,0,1],Line[{{-.8,0},{1.,0}}]}],Text[Style[MaTeX["SU(2N)/Sp(2N)~~~~~~~~~",Magnification->1.5]]]},{Graphics[{RGBColor[0,.5,0],Line[{{-.8,0},{1,0}}]}],Text[Style[MaTeX["SU(N)\\times SU(N)/SU(N)",Magnification->1.5]]]},{Graphics[{RGBColor[1,0,0],Line[{{-.8,0},{1,0}}]}],Text[Style[MaTeX["SU(2N)/SO(2N)~~~~~~~~",Magnification->1.5]]]}},LegendPosition->{-0.03,0.25},LegendTextOffset->{-.45,0},LegendSize->{0.85,.3},ShadowOffset->{0.0,0.0}}]
]

nlcut=200;
nscut=100;
listrange=Flatten[{Table[j,{j,nlcut+1,neig/2-nscut}],Table[j,{j,neig/2+1+nscut,neig-nlcut}]}];

Do[count=0;
jtmp=NEIGS (l-1)+nstart+1;
nsT=Table[1,{j,neig}];
Do[tmp=eigsortedT[[i]][[1]];count+=1;If[tmp==jtmp,nsT[[jtmp-NEIGS (l-1)-nstart]]=count;jtmp+=1],{i,Length[eigsortedT]}];
stmp[[l]]=Table[Table[N[(nsT[[delta j+k]]-nsT[[delta (j-1)+k]])/(delta nconf)],{j,listrange}],{k,1,delta}],{l,1,nconf}]

sT=Flatten[stmp];
avg=Mean[sT]
sT=sT/avg;(*normalization*)


\[Delta]sdensity=Plot[
  PDF[HistogramDistribution[sT,100],x],
  {x,0,4},
  PlotRange->{{0,3.6},{0,1.45}},
  PlotStyle->RGBColor[0,0,0],
  Filling->None,
  Exclusions->None,
  Frame->True,
  FrameLabel->{MaTeX["s",Magnification->2],MaTeX["\\textrm{P}(s)",Magnification->2]},
  FrameStyle->Directive[Black],
  BaseStyle->texStyle,
  ImageSize->600
]


(*Fig. 15*)
Export[
  $ScriptCommandLine[[9]],
  ShowLegend[dsmax=3;
  Show[{\[Delta]sdensity,Plot[probf[1,s],{s,0,dsmax},PlotStyle->RGBColor[0,0,1]],Plot[probf[2,s],{s,0,dsmax},PlotStyle->RGBColor[0,.5,0]],Plot[probf[4,s],{s,0,dsmax},PlotStyle->Red]},ImageSize->600],{{{Graphics[{RGBColor[0,0,1],Line[{{-.8,0},{1.,0}}]}],Text[Style[MaTeX["SU(2N)/Sp(2N)~~~~~~~~~",Magnification->1.5]]]},{Graphics[{RGBColor[0,.5,0],Line[{{-.8,0},{1,0}}]}],Text[Style[MaTeX["SU(N)\\times SU(N)/SU(N)",Magnification->1.5]]]},{Graphics[{RGBColor[1,0,0],Line[{{-.8,0},{1,0}}]}],Text[Style[MaTeX["SU(2N)/SO(2N)~~~~~~~~",Magnification->1.5]]]}},LegendPosition->{-0.03,0.25},LegendTextOffset->{-.45,0},LegendSize->{0.85,.3},ShadowOffset->{0.0,0.0}}]
]

(* Sp(4) fund 4^4(Figs. 12, 13, 15) *)

NT=4; (*number of temporal lattice*)
NS=4; (*number of one of the spatial lattice*)
NC=4;(*number of colors*)
beta=8.0;
beta1=8;beta2="0"; (*lattice coupling*)
m0ND="-0.2"; (*bare fermion mass*)
m0=ToExpression[m0ND];
kappa=1/(8+2 m0);
dr=4;(*dimension of the representation*)

NEIGS=NT NS NS NS NC dr
NCUT=4096

eigimport=Import[StringJoin[$ScriptCommandLine[[2]], "/eigs_sorted_",ToString[NT],"x",ToString[NS],"x",ToString[NS],"x",ToString[NS],"b",ToString[beta1],".",ToString[beta2],"mf",ToString[m0ND]],"Table"];

nconf=Length[eigimport]/(NT NS NS NS NC dr)
neig=Length[eigimport]/nconf

delta=1;

eigsortedT=eigimport;

nstart = NEIGS-NCUT;
Clear[sT];
stmp=Table[1,{j,nconf}];

Do[count=0;
jtmp=NEIGS (l-1)+nstart+1;
nsT=Table[1,{j,neig}];
Do[tmp=eigsortedT[[i]][[1]];count+=1;If[tmp==jtmp,nsT[[jtmp-NEIGS (l-1)-nstart]]=count;jtmp+=1],{i,Length[eigsortedT]}];
stmp[[l]]=Table[Table[N[(nsT[[delta j+k]]-nsT[[delta (j-1)+k]])/(delta nconf)],{j,1,neig/delta-1(*-ucut*)}],{k,1,delta}],{l,1,nconf}]

(*Fig. 13*)
Export[
  $ScriptCommandLine[[6]],
  Show[Table[ListPlot[Table[{j,stmp[[k]][[1]][[j]]},{j,1,Length[stmp[[1]][[1]]]}],PlotRange->{{0,neig},{0,15}},Frame->True,FrameLabel->{MaTeX["n",Magnification->2],MaTeX["s_n",Magnification->2]},FrameStyle->Directive[Black],BaseStyle->texStyle,ImageSize->600],{k,1, nconf}]]
]

sT=Flatten[stmp];
avg=Mean[sT]
sT=sT/avg;(*normalization*)

\[Delta]sdensity=Plot[PDF[HistogramDistribution[sT,300],x],{x,0,4},PlotRange->{{0,3.6},{0,1.45}},PlotStyle->RGBColor[0,0,0],Filling->None,Exclusions->None,Frame->True,FrameLabel->{MaTeX["s",Magnification->2],MaTeX["\\textrm{P}(s)",Magnification->2]},FrameStyle->Directive[Black],BaseStyle->texStyle,ImageSize->600]

dsmax=3;
  Show[{\[Delta]sdensity,Plot[probf[1,s],{s,0,dsmax},PlotStyle->RGBColor[0,0,1]],Plot[probf[2,s],{s,0,dsmax},PlotStyle->RGBColor[0,.5,0]],Plot[probf[4,s],{s,0,dsmax},PlotStyle->Red]},ImageSize->600]


(*Fig. 12*)
Export[
  $ScriptCommandLine[[4]],
  ShowLegend[dsmax=3;
  Show[{\[Delta]sdensity,Plot[probf[1,s],{s,0,dsmax},PlotStyle->RGBColor[0,0,1]],Plot[probf[2,s],{s,0,dsmax},PlotStyle->RGBColor[0,.5,0]],Plot[probf[4,s],{s,0,dsmax},PlotStyle->Red]},ImageSize->600],{{{Graphics[{RGBColor[0,0,1],Line[{{-.8,0},{1.,0}}]}],Text[Style[MaTeX["SU(2N)/Sp(2N)~~~~~~~~~",Magnification->1.5]]]},{Graphics[{RGBColor[0,.5,0],Line[{{-.8,0},{1,0}}]}],Text[Style[MaTeX["SU(N)\\times SU(N)/SU(N)",Magnification->1.5]]]},{Graphics[{RGBColor[1,0,0],Line[{{-.8,0},{1,0}}]}],Text[Style[MaTeX["SU(2N)/SO(2N)~~~~~~~~",Magnification->1.5]]]}},LegendPosition->{-0.03,0.25},LegendTextOffset->{-.45,0},LegendSize->{0.85,.3},ShadowOffset->{0.0,0.0}}]
]

(*cut out small and large eigenvalues*)
nlcut=200;
nscut=100;
listrange=Flatten[{Table[j,{j,nlcut+1,neig/2-nscut}],Table[j,{j,neig/2+1+nscut,neig-nlcut}]}];


(*unfolding procedure after removing small and large eigenvalues*)
Do[count=0;
jtmp=NEIGS (l-1)+nstart+1;
nsT=Table[1,{j,neig}];
Do[tmp=eigsortedT[[i]][[1]];count+=1;If[tmp==jtmp,nsT[[jtmp-NEIGS (l-1)-nstart]]=count;jtmp+=1],{i,Length[eigsortedT]}];
stmp[[l]]=Table[Table[N[(nsT[[delta j+k]]-nsT[[delta (j-1)+k]])/(delta nconf)],{j,listrange}],{k,1,delta}],{l,1,nconf}]

sT=Flatten[stmp];
avg=Mean[sT]
sT=sT/avg;(*normalization*)

\[Delta]sdensity=Plot[PDF[HistogramDistribution[sT,100],x],{x,0,4},PlotRange->{{0,3.6},{0,1.45}},PlotStyle->RGBColor[0,0,0],Filling->None,Exclusions->None,Frame->True,FrameLabel->{MaTeX["s",Magnification->2],MaTeX["\\textrm{P}(s)",Magnification->2]},FrameStyle->Directive[Black],BaseStyle->texStyle,ImageSize->600]

dsmax=3;
Show[{\[Delta]sdensity,Plot[probf[1,s],{s,0,dsmax},PlotStyle->RGBColor[0,0,1]],Plot[probf[2,s],{s,0,dsmax},PlotStyle->RGBColor[0,.5,0]],Plot[probf[4,s],{s,0,dsmax},PlotStyle->Red]},ImageSize->600]


(*Fig. 15*)
Export[
  $ScriptCommandLine[[8]],
  ShowLegend[dsmax=3;
  Show[{\[Delta]sdensity,Plot[probf[1,s],{s,0,dsmax},PlotStyle->RGBColor[0,0,1]],Plot[probf[2,s],{s,0,dsmax},PlotStyle->RGBColor[0,.5,0]],Plot[probf[4,s],{s,0,dsmax},PlotStyle->Red]},ImageSize->600],{{{Graphics[{RGBColor[0,0,1],Line[{{-.8,0},{1.,0}}]}],Text[Style[MaTeX["SU(2N)/Sp(2N)~~~~~~~~~",Magnification->1.5]]]},{Graphics[{RGBColor[0,.5,0],Line[{{-.8,0},{1,0}}]}],Text[Style[MaTeX["SU(N)\\times SU(N)/SU(N)",Magnification->1.5]]]},{Graphics[{RGBColor[1,0,0],Line[{{-.8,0},{1,0}}]}],Text[Style[MaTeX["SU(2N)/SO(2N)~~~~~~~~",Magnification->1.5]]]}},LegendPosition->{-0.03,0.25},LegendTextOffset->{-.45,0},LegendSize->{0.85,.3},ShadowOffset->{0.0,0.0}}]
]


(* Sp(4) antisymmetric 4^4 (Fig. 12) *)

NT=4; (*number of temporal lattice*)
NS=4; (*number of one of the spatial lattice*)
NC=4;(*number of colors*)
beta=8.0;
beta1=8;beta2="0"; (*lattice coupling*)
m0ND="-0.2"; (*bare fermion mass*)
m0=ToExpression[m0ND];
dr=5;(*dimension of the representation*)
kappa=1/(8+2 m0);
dgen=2;

NEIGS=NT NS NS NS NC dr/dgen
NCUT=5120/dgen

eigimport=Import[StringJoin[$ScriptCommandLine[[2]], "/eigs_sorted_",ToString[NT],"x",ToString[NS],"x",ToString[NS],"x",ToString[NS],"b",ToString[beta1],".",ToString[beta2],"mas",ToString[m0ND]],"Table"];

nconf=Length[eigimport]/(NT NS NS NS NC dr) dgen
neig=Length[eigimport]/nconf

delta=1;

eigsortedT=eigimport;

nstart = NEIGS-NCUT;
Clear[sT];
stmp=Table[1,{j,nconf}];

Do[count=0;
jtmp=NEIGS (l-1)+nstart+1;
nsT=Table[1,{j,neig}];
Do[tmp=eigsortedT[[i]][[1]];count+=1;If[tmp==jtmp,nsT[[jtmp-NEIGS (l-1)-nstart]]=count;jtmp+=1],{i,Length[eigsortedT]}];
stmp[[l]]=Table[Table[N[(nsT[[delta j+k]]-nsT[[delta (j-1)+k]])/(delta nconf)],{j,1,neig/delta-1(*-ucut*)}],{k,1,delta}],{l,1,nconf}]

Show[Table[ListPlot[Table[{j,stmp[[k]][[1]][[j]]},{j,1,Length[stmp[[1]][[1]]]}],PlotRange->{{0,neig},{0,5.5}},Frame->True,FrameLabel->{MaTeX["n",Magnification->2],MaTeX["s",Magnification->2]},FrameStyle->Directive[Black],BaseStyle->texStyle,ImageSize->500],{k,1,40}]]

sT=Flatten[stmp];
avg=Mean[sT]
sT=sT/avg;(*normalization*)

\[Delta]sdensity=Plot[PDF[HistogramDistribution[sT,100],x],{x,0,2.5},PlotRange->{{0,3.6},{0,1.45}},PlotStyle->RGBColor[0,0,0],Filling->None,Exclusions->None,Frame->True,FrameLabel->{MaTeX["s",Magnification->2],MaTeX["\\textrm{P}(s)",Magnification->2]},FrameStyle->Directive[Black],BaseStyle->texStyle,ImageSize->600]

dsmax=3;
Show[{\[Delta]sdensity,Plot[probf[1,s],{s,0,dsmax},PlotStyle->RGBColor[0,0,1]],Plot[probf[2,s],{s,0,dsmax},PlotStyle->RGBColor[0,.5,0]],Plot[probf[4,s],{s,0,dsmax},PlotStyle->Red]},ImageSize->600]

Export[
  $ScriptCommandLine[[5]],
  ShowLegend[dsmax=3;
    Show[
      {
        \[Delta]sdensity,
        Plot[probf[1,s],{s,0,dsmax},PlotStyle->RGBColor[0,0,1]],
        Plot[probf[2,s],{s,0,dsmax},PlotStyle->RGBColor[0,.5,0]],
        Plot[probf[4,s],{s,0,dsmax},PlotStyle->Red]
      },
      ImageSize->600
    ],
    {{{
       Graphics[
         {
           RGBColor[0,0,1],
           Line[{{-.8,0},{1.,0}}]
         }
       ],
       Text[
         Style[
           MaTeX[
             "SU(2N)/Sp(2N)~~~~~~~~~",
             Magnification->1.5
           ]
         ]
       ]
      },
      {
       Graphics[
         {
           RGBColor[0,.5,0],
           Line[{{-.8,0},{1,0}}]
         }
       ],
       Text[
         Style[
           MaTeX["SU(N)\\times SU(N)/SU(N)",Magnification->1.5]
         ]
       ]
      },
      {
       Graphics[
         {
           RGBColor[1,0,0],
           Line[{{-.8,0},{1,0}}]
         }
       ],
       Text[
         Style[
           MaTeX["SU(2N)/SO(2N)~~~~~~~~",Magnification->1.5]
         ]
       ]
     }
    },
    LegendPosition->{-0.03,0.25},
    LegendTextOffset->{-.45,0},
    LegendSize->{0.85,.3},
    ShadowOffset->{0.0,0.0}
   }
  ]
]

(* Sp(4) antisymmetric 4^4 (Fig. 11) *)

NT=4; (*extent of temporal lattice*)
NS=4; (*extent of one of the spatial lattice*)
NC=4;(*number of colors*)
beta=8.0;
beta1=8;beta2="0"; (*lattice coupling*)
m0ND="-0.2"; (*bare fermion mass*)
m0=ToExpression[m0ND];
dr=5;(*dimension of the representation)*)
kappa=1/(8+2 m0);

eigimport=Import[StringJoin[$ScriptCommandLine[[2]], "/eigs_",ToString[NT],"x",ToString[NS],"x",ToString[NS],"x",ToString[NS],"b",ToString[beta1],".",ToString[beta2],"mas",ToString[m0ND]],"Table"];

NEIGS=NT NS NS NS NC dr

Export[
  $ScriptCommandLine[[3]],
  ListPlot[Table[{j-2560,eigimport[[j]][[4]]},{j,2561,2592}],PlotRange->{{0,33},All},Frame->True,FrameLabel->{MaTeX["n",Magnification->2],MaTeX["\\lambda_n",Magnification->2]},FrameStyle->Directive[Black],BaseStyle->texStyle,ImageSize->600]
]
