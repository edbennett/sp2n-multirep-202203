#!/usr/bin/env wolframscript

Needs["ErrorBarPlots`"];
Needs["PlotLegends`"];
<<MaTeX`
texStyle={FontFamily->"Times",FontSize->20};


(* b=6.5, mas=-1.01, mf=-0.71 *)

plaqT={{0.5856444248118751,0.00009118133189125046},{0.5853687010225385,0.000047539884988940834},{0.5852364427846428,0.00003233223862962421},\!\(TraditionalForm\`{0.5852350796266389, 0.000020983559624546043}\),{0.5851386936651923,0.00001941836142313486},{0.5851455725389394,0.00001481849417115954},{0.5851428681934722,0.000010940362187780525}}

(* Fundamental *)

llist={8,12,16,18,20,24,28};
mfpsT={{0.7500762985498306,0.006716141520956011},{0.5151481322954767,0.004344333014271951},{0.3847414416730477,0.004597427365772505},{0.37771520752388915,0.002473456593547889},{0.37059065427023713,0.0014776930883335774},{0.36378075467305593,0.001736845260851307},{0.3600658769766959,0.0009442804413520569}};
Table[mfpsT[[Length[mfpsT]]] llist[[j]],{j,1,Length[llist]}](*m_{ps}^{f,inf} x L*)
ffpsT={{0.03631017067894233,0.001984858715950782},{0.04266062498140521,0.001537469311333081},{0.04272512384951556,0.001372520228761969},{0.04588088397460737,0.001160859558564511},{0.05145314109847964,0.0008089028344696913},{0.04994115008573572,0.000825969421623907},{0.05036606875530627,0.000590636223030993}};
mvT={{0.7970849745293966,0.007567047939097054},{0.5675819625388853,0.004602368863853577},{0.42397775523959536,0.006122767879388348},{0.42861080461560247,0.0025609722159883924},{0.41526287173103654,0.002227079663151703},{0.40672726196796427,0.0018827846985597664},{0.4011714781688548,0.0012131747911769501}};
mtT={{-1,0.01},{-1,0.01},{-1,0.01},{-1,0.01},{-1,0.01},{-1,0.01},{0.4005459771529264,0.0015220200571542531}};
mavT={{-1,0.01},{-1,0.01},{-1,0.01},{-1,0.01},{-1,0.01},{-1,0.01},{0.5451194548641807,0.00897040405384497}};
matT={{-1,0.01},{-1,0.01},{-1,0.01},{-1,0.01},{-1,0.01},{-1,0.01},{0.5377309147085125,0.011898949567466115}};
msT={{-1,0.01},{-1,0.01},{-1,0.01},{-1,0.01},{-1,0.01},{-1,0.01},{0.5030005781190493,0.011076356915902887}};
mchT={{1.0024943376578899,0.02772588065642536},{0.9643355244796271,0.020210865899086876},{0.7857445891798898,0.016166159337901987},{0.7980466364853186,0.007655083320728259},{0.7743340094670675,0.005754898518055846},{0.7684014521910065,0.005284834106561256},{0.7657862494158045,0.0041172707554857964}};

(* Plots *)
plaqplot=ErrorListPlot[Table[{{mfpsT[[Length[mfpsT]]][[1]]*llist[[j]],plaqT[[j]][[1]]},ErrorBar[plaqT[[j]][[2]]]},{j,1,Length[llist]}],Frame->True,PlotRange->{{2,10.5},{0.585,0.58585}},AxesStyle->Thick,PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[0,0,1],AxesStyle->Black,FrameStyle->Black,FrameLabel->{MaTeX["m_{\\rm{PS}}^{f,\,\\rm{inf}}\,L",Magnification->2],MaTeX["\\langle \\mathcal{P} \\rangle",Magnification->2]},BaseStyle->texStyle,ImageSize->500]
mpsfplot=ErrorListPlot[Table[{{mfpsT[[Length[mfpsT]]][[1]]*llist[[j]],mfpsT[[j]][[1]]},ErrorBar[mfpsT[[j]][[2]]]},{j,1,Length[llist]}],Frame->True,PlotRange->{{2,10.5},{0.3,0.82}},AxesStyle->Thick,PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[0,0,1],AxesStyle->Black,FrameStyle->Black,FrameLabel->{MaTeX["m_{\\rm{PS}}^{f,\,\\rm{inf}}\,L",Magnification->2],MaTeX["a\,m^{f}_{\\rm{PS}}",Magnification->2]},BaseStyle->texStyle,ImageSize->600]
mpsfzoomplot=ErrorListPlot[Table[{{mfpsT[[Length[mfpsT]]][[1]]*llist[[j]],mfpsT[[j]][[1]]},ErrorBar[mfpsT[[j]][[2]]]},{j,1,Length[llist]}],Frame->True,PlotRange->{{5,10.5},{0.355,0.392}},AxesStyle->Thick,PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[1,0,0],AxesStyle->Black,FrameStyle->Black,BaseStyle->{FontFamily->"Helvetica",FontSize->15},ImageSize->300]
ErrorListPlot[Table[{{mfpsT[[Length[mfpsT]]][[1]]*llist[[j]],mfpsT[[j]][[1]]},ErrorBar[mfpsT[[j]][[2]]]},{j,1,Length[llist]}],Frame->True,PlotRange->{{2,10.5},{0.3,0.82}},Epilog->Inset[mpsfzoomplot,{7.5,0.63}],AxesStyle->Thick,PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[0,0,1],AxesStyle->Black,FrameStyle->Black,FrameLabel->{MaTeX["m_{\\rm{PS}}^{f,\,\\rm{inf}}\,L",Magnification->2],MaTeX["a\,m^{f}_{\\rm{PS}}",Magnification->2]},BaseStyle->texStyle,ImageSize->600]
fpsfplot=ErrorListPlot[Table[{{mfpsT[[Length[mfpsT]]][[1]]*llist[[j]],ffpsT[[j]][[1]]},ErrorBar[ffpsT[[j]][[2]]]},{j,1,Length[llist]}],Frame->True,PlotRange->{{2,10.5},{0.03,0.056}},AxesStyle->Thick,PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[0,0,1],AxesStyle->Black,FrameStyle->Black,FrameLabel->{MaTeX["m_{\\rm{PS}}^{f,\,\\rm{inf}}\,L",Magnification->2],MaTeX["a\,f^{f}_{\\rm{PS}}",Magnification->2]},LabelStyle->Directive[22,Black],ImageSize->600]
mvfplot=ErrorListPlot[Table[{{mfpsT[[Length[mfpsT]]][[1]]*llist[[j]],mvT[[j]][[1]]},ErrorBar[mvT[[j]][[2]]]},{j,1,Length[llist]}],Frame->True,PlotRange->{{2,10.5},{0.35,0.85}},AxesStyle->Thick,PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[0,0,1],AxesStyle->Black,FrameStyle->Black,FrameLabel->{MaTeX["m_{\\rm{PS}}^{f,\,\\rm{inf}}\,L",Magnification->2],MaTeX["a\,m^{f}_{\\rm{V}}",Magnification->2]},LabelStyle->Directive[22,Black],ImageSize->600]
mchfplot=ErrorListPlot[Table[{{mfpsT[[Length[mfpsT]]][[1]]*llist[[j]],mchT[[j]][[1]]},ErrorBar[mchT[[j]][[2]]]},{j,1,Length[llist]}],Frame->True,PlotRange->{{2,11},{0.7,1.12}},AxesStyle->Thick,PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[0,0,1],AxesStyle->Black,FrameStyle->Black,FrameLabel->{MaTeX["m_{\\rm{PS}}^{f,\,\\rm{inf}}\,L",Magnification->2],MaTeX["a\,m^{f}_{\\rm{CB}}",Magnification->2]},LabelStyle->Directive[22,Black],ImageSize->500]

(* Antisymmetric *)

llist={8,12,16,18,20,24,28};
mpsT={{0.42559481419339307,0.005534322466998464},{0.5501071481683801,0.004097096637793709},{0.5856415227690528,0.002370183041846478},{0.5960426351197107,0.0013937392419132904},{0.6016069624122053,0.0010863396084860835},{0.6022699381847226,0.0011911000410461082},{0.601736693939171,0.0007938443429643054}};

Table[mpsT[[Length[mpsT]]] llist[[j]],{j,1,Length[llist]}](*m_{ps}^{as,inf} x L*)
fpsT={{0.08211638162269647,0.0029278127741394736},{0.07791629188748396,0.002294524748645802},{0.07685507588941971,0.0017048323879029976},{0.07953941567587286,0.0010621564093143293},{0.08296497614433773,0.0009936252592970104},{0.08084091281831393,0.0012241995821166561},{0.08294770154895711,0.0008736129238066534}};
mvT={{0.440211024089437,0.006394275397227266},{0.5806852130110408,0.005342722418241199},{0.6239721869636499,0.0033403548453998745},{0.639741903420833,0.0021754676362704855},{0.649177765620191,0.001518638204038209},{0.6488091258115023,0.0014810539909287303},{0.6447534603385424,0.0012014862430626706}};
mtT={{-1,0.01},{-1,0.01},{-1,0.01},{-1,0.01},{-1,0.01},{-1,0.01},{0.6461447675299132,0.0011530961997999203}};
mavT={{-1,0.01},{-1,0.01},{-1,0.01},{-1,0.01},{-1,0.01},{-1,0.01},{0.8619986555771664,0.012120832281548439}};
matT={{-1,0.01},{-1,0.01},{-1,0.01},{-1,0.01},{-1,0.01},{-1,0.01},{0.8921314226352753,0.014230733152654542}};
msT={{-1,0.01},{-1,0.01},{-1,0.01},{-1,0.01},{-1,0.01},{-1,0.01},{0.843816712811318,0.010115658426345816}};


(* Plots *)

mpsasplot=ErrorListPlot[Table[{{mfpsT[[Length[mpsT]]][[1]]*llist[[j]],mpsT[[j]][[1]]},ErrorBar[mpsT[[j]][[2]]]},{j,1,Length[llist]}],Frame->True,PlotRange->{{2,10.5},{0,0.82}},AxesStyle->Thick,PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[1,0,0],AxesStyle->Black,FrameStyle->Black,FrameLabel->{MaTeX["m_{\\rm{PS}}^{f,\,\\rm{inf}}\,L",Magnification->2],MaTeX["a\,m_{\\rm{PS}}",Magnification->2]},LabelStyle->Directive[22,Black],ImageSize->600]
mpsaszoomplot=ErrorListPlot[Table[{{mfpsT[[Length[mpsT]]][[1]]*llist[[j]],mpsT[[j]][[1]]},ErrorBar[mpsT[[j]][[2]]]},{j,1,Length[llist]}],Frame->True,PlotRange->{{5,10.5},{0.58,0.606}},AxesStyle->Thick,PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[1,0,0],AxesStyle->Black,FrameStyle->Black,BaseStyle->{FontFamily->"Helvetica",FontSize->15},ImageSize->300]
ErrorListPlot[Table[{{mfpsT[[Length[mfpsT]]][[1]]*llist[[j]],mpsT[[j]][[1]]},ErrorBar[mpsT[[j]][[2]]]},{j,1,Length[llist]}],Frame->True,PlotRange->{{2,10.5},{0.4,0.62}},Epilog->Inset[mpsaszoomplot,{7.5,0.48}],AxesStyle->Thick,PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[0,0,1],AxesStyle->Black,FrameStyle->Black,FrameLabel->{MaTeX["m_{\\rm{PS}}^{f,\,\\rm{inf}}\,L",Magnification->2],MaTeX["a\,m^{as}_{\\rm{PS}}",Magnification->2]},BaseStyle->texStyle,ImageSize->600]
fpsasplot=ErrorListPlot[Table[{{mfpsT[[Length[mpsT]]][[1]]*llist[[j]],fpsT[[j]][[1]]},ErrorBar[fpsT[[j]][[2]]]},{j,1,Length[llist]}],Frame->True,PlotRange->{{2,10.5},{0.0,0.097}},FrameStyle->Black,AxesStyle->Thick,PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[1,0,0],AxesStyle->Black,FrameLabel->{MaTeX["m_{\\rm{PS}}^{f,\,\\rm{inf}}\,L",Magnification->2],MaTeX["af_{\\rm{PS}}",Magnification->2]},BaseStyle->texStyle,ImageSize->600]
mvasplot=ErrorListPlot[Table[{{mfpsT[[Length[mpsT]]][[1]]*llist[[j]],mvT[[j]][[1]]},ErrorBar[mvT[[j]][[2]]]},{j,1,Length[llist]}],Frame->True,PlotRange->{{2,10.5},{0.0,0.68}},FrameStyle->Black,AxesStyle->Thick,PlotMarkers->{"\[EmptyCircle]",15},PlotStyle->RGBColor[1,0,0],FrameLabel->{MaTeX["m_{\\rm{PS}}^{f,\,\\rm{inf}}\,L",Magnification->2],MaTeX["a\,m_{\\rm{V}}",Magnification->2]},BaseStyle->texStyle,ImageSize->600]
