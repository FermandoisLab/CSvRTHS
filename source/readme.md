## Description

### Simulink model

- `CSvRTHS_Client.slx`. Description: Simulink model that includes the actuator model, sensors, compensation method, corrective predictor and necessary communication blocks.

### Matlab scripts and functions

- `initializeSimulation.m`. Description: This function is called by the Simulink CSvRTHS_Client model and from this file it loads the necessary variables for correct execution. In this, the variables of the actuator, compensation method, sensors, integration times, among others, are entered.
- `Freq_Resp_Tong.m`. Description: This function based on an input signal, output signal and the sampling frequency, gives the amplitude error between the input/output, phase error, equivalent frequency and delay between the signals.
- `PlotOutput.m`. Description: This script takes the .out files delivered by OpenSees, the reference structure .out files, and simulink results and traces them. Within this script, the Freq_Resp_Tong function is called to calculate the delay between input / output signals. In addition, performance indicators J2 and J4 are calculated.

### OpenSees TCL scripts

In the last line of the server scripts you will find where the TCP communication started. Here you must enter the IP port.

- `ServerBeam1_TCP.tcl`. Description: Server where the beam of the experimental substructure is modeled. The beams are modeled as linear elastic frame elements. 
- `ServerCol1_TCP.tcl`. Description: Server where the right column of the experimental substructure is modeled. A Giuffre-Menegotto-Pinto steel material with isotropic strain hardening is used for his modeling.
- `ServerCol2_TCP.tcl`. Description: Server where the left column of the experimental substructure is modeled. A Giuffre-Menegotto-Pinto steel material with isotropic strain hardening is used for his modeling.
- `SubEstNum.tcl`. Description: Model where the entire numerical substructure is modeled. A Giuffre-Menegotto-Pinto steel material with isotropic strain hardening is used for his modeling. In this file the IP address and port of the NS must be entered. This has to be the same that the entered in the SFun_OPFConect block in the CSvRTHS_Client block in the Simulink model.

### C source code & headers

A C file is a source code file for a C or C ++ program. In this case this files are compiled into a Matlab Executable (MEX) file, which is necessary to run user-defined code in Matlab/Simulink. With this mex file its possible to generate the user-defined blocks, called S-Functions, in Simulink.

- `PredictorCorrector.c`. Description: File required for the implemented predictor-corrector method.
- `SFun_OPFConnect.c`. Description: File required for communication between the model in Simulink (CSvRTHS_Client) and the model of the numerical substructure in OpenSees (SubEstNum)
- `SFun_GenericClient.c`. Description: File required for communication between the model in Simulink (CSvRTHS_Client) and the model of the experimental substructure in OpenSees (ServerCol1, ServerCol2, ServerBeam1)
- `TCPSocket.c`. Description: file required to communicate using the TCP/IP protocol.

The header file is called a header file, in computer science, especially in the field of C and C ++ programming languages, to the file, usually in the form of source code, that the compiler automatically includes when processing some other source file.

- `PredictorCorrector.h`.

### Executable files (EXE)

- `OpenSees.exe`. Description: OpenSees executable file. This is the console to use to run the CSvRTHS.
- `OpenFresco.exe`. Description: OpenFresco executable file. This is the console to use to run the CSvRTHS.

### Dynamic Link Libraries (DLL)

Some previous definitions:

- A dynamic link library or more commonly DLL (dynamic-link library) is the term that refers to files with executable code that are loaded on demand of a program by the operating system. The files shown below are necessary for the correct execution of OpenFresco. In addition, if it is necessary to compile it or make modifications to its source code, they allow access to all source codes.

- OpenSSL is a robust, commercial-grade, and full-featured toolkit for the Transport Layer Security (TLS) and Secure Sockets Layer (SSL) protocols. It is also a general-purpose cryptography library.

- Dynamic Link Library files are essentially a "guide" that stores information and instructions for executable files (EXE). These files were created so that multiple programs could share the same files, saving valuable memory allocation; therefore, it makes the equipment work more efficiently.

The files uploaded to the repository are listed and explained below.

- `libcrypto-1_1-x64.dll`. Desciption: Libcrypto-1_1-x64.dll is considered a type of OpenSSL library file and is considered a Win64 DLL (Dynamic Link Library) file.
- `libssl-1_1-x64.dll`. Description: libssl-1_1-x64.dll is considered a type of OpenSSL library file and is considered a Win64 DLL (Dynamic Link Library) file.
- `msvcr120.dll`. Description: Microsoft C Runtime Library files, such as msvcr120.dll, are considered a type of Win64 DLL (Dynamic Link Library) file.
- `OpenFresco.dll`. Description: This file is necessary for the correct execution of OpenFresco. Similarly, it is necessary if what you want is to compile OpenFresco to make modifications to its source code.
- `Pnpscr64.dll`. Description: This dll is associated with the use of Scramnet shared ram memory, for this simulation it is not used, but it must be included in the folder for the correct execution of OpenFresco.
- `pnpscrd64.dll`. Description: This dll is associated with the use of Scramnet shared ram memory, for this simulation it is not used, but it must be included in the folder for the correct execution of OpenFresco.
- `SubStructure.dll`. Description: dLL file associated with the generation of experimental elements in OpenSees. For more information on this, consult the OpenFresco command manual.
- `xpcapi.dll`. Description: Non-system processes like xpcapi.dll originate from software you installed on your system. The xpcapi.dll is an executable file on your computer's hard drive. This file contains machine code.

Since OpenFresco is taking advantage of and utilizing many existing OpenSees classes, the OpenSees source code needs to be installed and built prior to compiling and building OpenFresco. Finally, Tcl/Tk and OpenSSL need to be installed in order to build and execute OpenFresco.

### Text File (txt)

- `elcentro.txt`. Description: Text file containing El Centro's 1940 seismic record. This file is read by the numeric substructure model in OpenSees (SubEstNum). In case another seismic record wants to be used, you just have to create the text file and modify the name in the model in OpenSees by the name of the new file. You must know the time spacing of the record and the amount of data to perform enough integration steps to include the entire record.
