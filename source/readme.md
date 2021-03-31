## Description

### Simulink model

- `CSvRTHS_Client.slx`. Description: Simulink model that includes the actuator model, compensation method, corrective predictor and necessary communication blocks.

### Matlab scripts and functions

- `initializeSimulation.m`. Description
- `Freq_Resp_Tong.m`. Description
- `PlotOutput.m`. Description 

### OpenSees TCL scripts

- `ServerBeam1_TCP.tcl`. Description
- `ServerCol1_TCP.tcl`. Description
- `ServerCol2_TCP.tcl`. Description
- `SubEstNum.tcl`. Description

### C source code & headers

- `PredictorCorrector.c`. Description
- `SFun_OPFConnect.c`. Description
- `TCPSocket.c`. Description
- `PredictorCorrector.h`. Description
- `File2.h`. Description

### Executable files (EXE)

- `OpenSees.exe`. Description: OpenSees executable file. This is the console to use to run the CSvRTHS.
- `OpenFresco.exe`. Description: OpenFresco executable file. This is the console to use to run the CSvRTHS.

### Dynamic Link Libraries (DLL)

A dynamic link library or more commonly DLL (dynamic-link library) is the term that refers to files with executable code that are loaded on demand of a program by the operating system. The files shown below are necessary for the correct execution of OpenFresco. In addition, if it is necessary to compile it or make modifications to its source code, they allow access to all source codes.

- `libcrypto-1_1-x64.dll`.
- `libssl-1_1-x64.dll`.
- `msvcr120.dll`.
- `OpenFresco.dll`.
- `Pnpscr64.dll`.
- `pnpscrd64.dll`.
- `SubStructure.dll`.
- `xpcapi.dll`.

### Text File (txt)

- `elcentro.txt`. Description
