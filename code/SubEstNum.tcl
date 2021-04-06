# File: OneBayFrame_Local.tcl (use with Simulink control system model)
# Units: [kip,in.]
#
# $Revision$
# $Date$
# $URL$
#
# Written: Andreas Schellenberg (andreas.schellenberg@gmail.com)
# Created: 11/06
# Revision: A
#
# Purpose: this file contains the tcl input to perform
# a local hybrid simulation of a one bay frame with
# two experimental twoNodeLink elements.
# The specimens are simulated using the SimUniaxialMaterials
# controller.


# ------------------------------
# Start of model generation
# ------------------------------
# create ModelBuilder (with two-dimensions and 2 DOF/node)
model BasicBuilder -ndm 2 -ndf 2

# Load OpenFresco package
# -----------------------
# (make sure all dlls are in the same folder as openSees.exe)
loadPackage OpenFresco

# Define geometry for model
# -------------------------
set mass3 0.5
set mass4 1.0
# node $tag $xCrd $yCrd $mass
node  1     0.0    0.00
node  2   100.0    0.00
node  3     0.0   54.00  -mass $mass3 $mass3
node  4   100.0   54.00  -mass $mass4 $mass4
node  5     0.0  108.00  -mass $mass3 $mass3
node  6   100.0  108.00  -mass $mass4 $mass4
node  7     0.0  162.00  -mass $mass3 $mass3
node  8   100.0  162.00  -mass $mass4 $mass4
node  9   200.0    0.00
node  10  200.0   54.00  -mass $mass4 $mass4
node  11  200.0  108.00  -mass $mass4 $mass4
node  12  200.0  162.00  -mass $mass4 $mass4
node  13  300.0    0.00
node  14  300.0   54.00  -mass $mass3 $mass3
node  15  300.0  108.00  -mass $mass3 $mass3
node  16  300.0  162.00  -mass $mass3 $mass3
node  17    0.0  216.00  -mass $mass3 $mass3
node  18  100.0  216.00  -mass $mass4 $mass4
node  19  200.0  216.00  -mass $mass4 $mass4
node  20  300.0  216.00  -mass $mass3 $mass3

# set the boundary conditions
# fix $tag $DX $DY
fix 1   1  1
fix 2   1  1
fix 3   0  1
fix 4   0  1
fix 5   0  1
fix 6   0  1
fix 9   1  1
fix 10  0  1
fix 11  0  1
fix 12  0  1
fix 13  1  1
fix 14  0  1
fix 15  0  1
fix 16  0  1
fix 17  0  1
fix 18  0  1
fix 19  0  1
fix 20  0  1

# Define materials
# ----------------
# uniaxialMaterial Elastic $matTag $E <$eta> 
#uniaxialMaterial Elastic 2 5.6
uniaxialMaterial Steel02 2 3.0 5.6 0.01 18.5 0.925 0.15 0.0 1.0 0.0 1.0 
uniaxialMaterial Elastic 3 [expr 2.0*100.0/1.0]

# Define experimental control
# ---------------------------
# expControl SimSimulink $tag ipAddr $ipPort
expControl SimSimulink 1 "127.0.0.1" 8090
# expControl SimUniaxialMaterials $tag $matTags
#expControl SimUniaxialMaterials  1 2
expControl SimUniaxialMaterials  2 2
expControl SimUniaxialMaterials  3 2
expControl SimUniaxialMaterials  4 2
expControl SimUniaxialMaterials  5 2
expControl SimUniaxialMaterials  6 2
expControl SimUniaxialMaterials  7 2
expControl SimUniaxialMaterials  8 2
expControl SimUniaxialMaterials  9 2
expControl SimUniaxialMaterials 10 2
expControl SimUniaxialMaterials 11 2
expControl SimUniaxialMaterials 12 2
expControl SimUniaxialMaterials 13 2
expControl SimUniaxialMaterials 15 2
expControl SimUniaxialMaterials 16 2

# Define experimental setup
# -------------------------
# expSetup OneActuator $tag <-control $ctrlTag> $dir -sizeTrialOut $t $o <-trialDispFact $f> ...
expSetup OneActuator  1 -control  1 1 -sizeTrialOut 1 1
expSetup OneActuator  2 -control  2 1 -sizeTrialOut 1 1
expSetup OneActuator  3 -control  3 1 -sizeTrialOut 1 1
expSetup OneActuator  4 -control  4 1 -sizeTrialOut 1 1
expSetup OneActuator  5 -control  5 1 -sizeTrialOut 1 1
expSetup OneActuator  6 -control  6 1 -sizeTrialOut 1 1
expSetup OneActuator  7 -control  7 1 -sizeTrialOut 1 1
expSetup OneActuator  8 -control  8 1 -sizeTrialOut 1 1
expSetup OneActuator  9 -control  9 1 -sizeTrialOut 1 1
expSetup OneActuator 10 -control 10 1 -sizeTrialOut 1 1
expSetup OneActuator 11 -control 11 1 -sizeTrialOut 1 1
expSetup OneActuator 12 -control 12 1 -sizeTrialOut 1 1
expSetup OneActuator 13 -control 13 1 -sizeTrialOut 1 1
expSetup OneActuator 14 -control 13 1 -sizeTrialOut 1 1
expSetup OneActuator 15 -control 15 1 -sizeTrialOut 1 1
expSetup OneActuator 16 -control 16 1 -sizeTrialOut 1 1

# Define experimental site
# ------------------------
# expSite LocalSite $tag $setupTag
expSite LocalSite 1 1
expSite LocalSite 2 2
expSite LocalSite 3 3
expSite LocalSite 4 4
expSite LocalSite 5 5
expSite LocalSite 6 6
expSite LocalSite 7 7
expSite LocalSite 8 8
expSite LocalSite 9 9
expSite LocalSite 10 10
expSite LocalSite 11 11
expSite LocalSite 12 12
expSite LocalSite 13 13
expSite LocalSite 14 14
expSite LocalSite 15 15 
expSite LocalSite 16 16

# Define experimental elements
# ----------------------------
# left and right columns
# expElement twoNodeLink $eleTag $iNode $jNode -dir $dirs -site $siteTag -initStif $Kij <-orient <$x1 $x2 $x3> $y1 $y2 $y3> <-pDelta Mratios> <-iMod> <-mass $m>
expElement twoNodeLink 1   1  3 -dir 2 -site 1 -initStif 5.6
#expElement twoNodeLink 2   2  4 -dir 2 -site 2 -initStif 5.6
expElement twoNodeLink 2 2 4 -dir 2 -server 8091 127.0.0.2 -tcp -initStif 5.6;  # use with SimAppSiteServer
expElement twoNodeLink 4   3  5 -dir 2 -site 3 -initStif 5.6
expElement twoNodeLink 5   4  6 -dir 2 -site 4 -initStif 5.6
expElement twoNodeLink 7   5  7 -dir 2 -site 5 -initStif 5.6
expElement twoNodeLink 8   6  8 -dir 2 -site 6 -initStif 5.6
expElement twoNodeLink 10  9 10 -dir 2 -site 7 -initStif 5.6
expElement twoNodeLink 12 10 11 -dir 2 -site 8 -initStif 5.6
expElement twoNodeLink 14 11 12 -dir 2 -site 9 -initStif 5.6
expElement twoNodeLink 16 13 14 -dir 2 -site 10 -initStif 5.6
expElement twoNodeLink 18 14 15 -dir 2 -site 11 -initStif 5.6
expElement twoNodeLink 20 15 16 -dir 2 -site 12 -initStif 5.6
expElement twoNodeLink 22 16 20 -dir 2 -site 13 -initStif 5.6
expElement twoNodeLink 23  7 17 -dir 2 -site 14 -initStif 5.6
expElement twoNodeLink 25  8 18 -dir 2 -site 15 -initStif 5.6
expElement twoNodeLink 27 12 19 -dir 2 -site 16 -initStif 5.6

# Define numerical elements
# -------------------------
# spring
# element truss $eleTag $iNode $jNode $A $matTag
expElement twoNodeLink 3 3 4 -dir 1 -server 8092 127.0.0.3 -tcp -initStif 2.0;  # use with SimAppSiteServer
#element truss 3  3  4 1.0 3
element truss  6  5  6 1.0 3
element truss  9  7  8 1.0 3
element truss 11  4 10 1.0 3
element truss 13  6 11 1.0 3
element truss 15  8 12 1.0 3
element truss 17 10 14 1.0 3
element truss 19 11 15 1.0 3
element truss 21 12 16 1.0 3
element truss 24 17 18 1.0 3
element truss 26 18 19 1.0 3
element truss 28 19 20 1.0 3

# Define dynamic loads
# --------------------
# set time series to be passed to uniform excitation
set dt 0.02
set scale 1.0
timeSeries Path 1 -filePath elcentro.txt -dt $dt -factor [expr 386.1*$scale]

# create UniformExcitation load pattern
# pattern UniformExcitation $tag $dir -accel $tsTag <-vel0 $vel0>
pattern UniformExcitation 1 1 -accel 1

# ------------ define & apply damping
# RAYLEIGH damping parameters, Where to put M/K-prop damping, switches (http://opensees.berkeley.edu/OpenSees/manuals/usermanual/1099.htm)
#          D=$alphaM*M + $betaKcurr*Kcurrent + $betaKcomm*KlastCommit + $beatKinit*$Kinitial
set xDamp 0.05;                 # damping ratio
set MpropSwitch 1.0;
set KcurrSwitch 0.0;
set KcommSwitch 1.0;
set KinitSwitch 0.0;
set nEigenI 1;      # mode 1
set nEigenJ 2;      # mode 2
set lambdaN [eigen [expr $nEigenJ]];            # eigenvalue analysis for nEigenJ modes
set lambdaI [lindex $lambdaN [expr $nEigenI-1]];        # eigenvalue mode i
set lambdaJ [lindex $lambdaN [expr $nEigenJ-1]];    # eigenvalue mode j
set omegaI [expr pow($lambdaI,0.5)];
set omegaJ [expr pow($lambdaJ,0.5)];
set alphaM [expr $MpropSwitch*$xDamp*(2*$omegaI*$omegaJ)/($omegaI+$omegaJ)];    # M-prop. damping; D = alphaM*M
set betaKcurr [expr $KcurrSwitch*2.*$xDamp/($omegaI+$omegaJ)];              # current-K;      +beatKcurr*KCurrent
set betaKcomm [expr $KcommSwitch*2.*$xDamp/($omegaI+$omegaJ)];          # last-committed K;   +betaKcomm*KlastCommitt
set betaKinit [expr $KinitSwitch*2.*$xDamp/($omegaI+$omegaJ)];                  # initial-K;     +beatKinit*Kini

# define damping
rayleigh $alphaM $betaKcurr $betaKinit $betaKcomm;              # RAYLEIGH damping
puts "Los valores son $alphaM $betaKcurr $betaKinit $betaKcomm"
# ------------------------------
# End of model generation
# ------------------------------


# ------------------------------
# Start of analysis generation
# ------------------------------
# create the system of equations
system BandGeneral
# create the DOF numberer
numberer Plain
# create the constraint handler
constraints Plain
# create the convergence test
test EnergyIncr 1.0e-6 10
# create the integration scheme
integrator NewmarkExplicit 0.5
#integrator AlphaOS 1.0
#integrator Newmark 0.5 0.25
# create the solution algorithm
algorithm Linear
#algorithm Newton
# create the analysis object 
analysis Transient
# ------------------------------
# End of analysis generation
# ------------------------------


# ------------------------------
# Start of recorder generation
# ------------------------------
# create the recorder objects
recorder Node -file output/Node_Dsp.out -time -node 3 17 -dof 1 disp
#recorder Node -file output/Node_Vel.out -time -node 3 4 -dof 1 vel
#recorder Node -file output/Node_Acc.out -time -node 3 4 -dof 1 accel

recorder Node -file output/Vbase.out -node 1 2 9 13 -dof 1 reaction;

recorder Element -file output/Elmt_Frc.out     -time -ele 1 2 3 forces
#recorder Element -file output/Elmt_ctrlDsp.out -time -ele 1 2   ctrlDisp
#recorder Element -file output/Elmt_daqDsp.out  -time -ele 1 2   daqDisp
# --------------------------------
# End of recorder generation
# --------------------------------


# ------------------------------
# Finally perform the analysis
# ------------------------------
# perform an eigenvalue analysis
set pi [expr acos(-1.0)]
set lambda [eigen -fullGenLapack 2]
puts "\nEigenvalues at start of transient:"
puts "|   lambda   |  omega   |  period | frequency |"
foreach lambda $lambda {
    set omega [expr pow($lambda,0.5)]
    set period [expr 2.0*$pi/$omega]
    set frequ [expr 1.0/$period]
    puts [format "| %5.3e | %8.4f | %7.4f | %9.4f |" $lambda $omega $period $frequ]
}

# open output file for writing
set outFileID [open output/elapsedTime.txt w]
# perform the transient analysis
set tTot [time {
    for {set i 1} {$i < 2048} {incr i} {
        set t [time {analyze  1  [expr 20.0/1024.0]}]
        puts $outFileID $t
        #puts "step $i"
    }
}]
puts "\nElapsed Time = $tTot \n"
# close the output file
close $outFileID

wipe
exit
# --------------------------------
# End of analysis
# --------------------------------
