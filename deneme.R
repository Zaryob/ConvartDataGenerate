if(!require('tcltk')) {
  install.packages('tcltk')
  library('tcltk')
}

## Main Frame
base <- tktoplevel()
tkwm.title(base, "Parameter setzen")

## First Frame: Monthly or quarterly data?
quart  <- tclVar(FALSE)
frame1 <- tkframe(base, relief="groove", borderwidth=2)
buton1 <- tkradiobutton(frame1, text="Monthly",   valu=FALSE, vari=quart)
buton2 <- tkradiobutton(frame1, text="Quarterly", value=TRUE, vari=quart)
tkpack(tklabel(frame1, text="Monthly or quarterly data?"), anchor="w")
tkpack(buton1, anchor="w")
tkpack(buton2, anchor="w")


## Second Frame: Integration order of the series
dd     <- tclVar(0)
frame2 <- tkframe(base, relief="groove", borderwidth=2)
buton1 <- tkradiobutton(frame2, text="0", value=0, variable=dd)
buton2 <- tkradiobutton(frame2, text="1", value=1, variable=dd)
buton3 <- tkradiobutton(frame2, text="2", value=2, variable=dd)
tkpack(tklabel(frame2, text="Integration order of the series"), anch="w")
tkpack(buton1, anchor="w")
tkpack(buton2, anchor="w")
tkpack(buton3, anchor="w")

## Third Frame: Type of filter?
tpfilter <- tclVar(FALSE)
frame3   <- tkframe(base, relief="groove", borderwidth=2)
txt1     <- "Turning Point"
txt2     <- "Best Level"
buton1   <- tkradiobutton(frame3, text=txt1, valu=FALSE, variab=tpfilter)
buton2   <- tkradiobutton(frame3, text=txt2, valu=TRUE,  variab=tpfilter)
tkpack(tklabel(frame3, text="Type of filter?"), anchor="w")
tkpack(buton1, anchor="w")
tkpack(buton2, anchor="w")

## Fourth Frame: Lagrange parameter for phase restriction
lambda  <- tclVar(1)
frame4  <- tkframe(base, relief="groove", borderwidth=2)
tkpack(tklabel(frame4, text="Lagrange parameter for phase restriction"))
tkpack(tkscale(frame4, from=1, to=20, showvalue=TRUE, variable=lambda,
               resolution=1, orient="horiz"))

## Fifth Frame: Shape of the frequency weighting function
expweight <- tclVar(0.8)
frame5    <- tkframe(base, relief="groove", borderwidth=2)
txt       <- "Shape of the frequency weighting function"
tkpack(tklabel(frame5,text=txt))
tkpack(tkscale(frame5, from=0.5, to=2, showvalue=TRUE,
               variable=expweight, resolution=0.05, orient="horiz"))

## Sixth Frame: Regularity constraint for moduli of poles
pbd     <- tclVar(1.01)
frame6  <- tkframe(base, relief="groove", borderwidth=2)
tkpack(tklabel(frame6, text="Regularity constraint for moduli of poles"))
tkpack(tkscale(frame6, from=1.01, to=3, showvalue=TRUE, variable=pbd,
               resolution=0.01, orient="horiz"))

## Seventh Frame: Number of optimization loops
n.loops <- tclVar(10)
frame7  <- tkframe(base, relief="groove", borderwidth=2)
tkpack(tklabel(frame7, text="Number of optimization loops"))
tkpack(tkscale(frame7, from=1, to=20, showvalue=TRUE, variable=n.loops,
               resolution=1, orient="horiz"))

## Eigth Frame: Text output for run-time control?
verbose <- tclVar(FALSE)
frame8  <- tkframe(base, relief="groove", borderwidth=2)
buton1  <- tkradiobutton(frame8, text="None",   valu=0,  variab=verbose)
buton2  <- tkradiobutton(frame8, text="Minimal",valu=1,  variab=verbose)
buton3  <- tkradiobutton(frame8, text="Full",   valu=2,  variab=verbose)
tkpack(tklabel(frame8,text="Text output for run-time control?"),anch="w")
tkpack(buton1, anchor="w")
tkpack(buton2, anchor="w")
tkpack(buton3, anchor="w")

## OK button
OnOK   <- function() {
  out <<- c(tclvalue(quart),     tclvalue(dd),        tclvalue(tpfilter),
            tclvalue(lambda),    tclvalue(expweight), tclvalue(pbd),
            tclvalue(n.loops),   tclvalue(verbose))
  tkdestroy(base)
}

q.but <- tkbutton(base, text="OK", command=OnOK)

## Do it!
tkpack(frame1, frame2, frame3, frame4, frame5, frame6, frame7, frame8,
       q.but, fill="x")

print(out)
