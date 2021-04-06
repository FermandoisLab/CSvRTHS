## Description

### Simulink model

- `CSvRTHS_Client.slx`. Simulink model that includes the actuator model, sensors, compensation method, corrective predictor and necessary communication blocks.

### Matlab scripts and functions

- `initializeSimulation.m`. This function is called by the Simulink CSvRTHS_Client model and from this file it loads the necessary variables for correct execution. In this, the variables of the actuator, compensation method, sensors, integration times, among others, are entered.
- `Freq_Resp_Tong.m`. This function based on an input signal, output signal and the sampling frequency, gives the amplitude error between the input/output, phase error, equivalent frequency and delay between the signals.
- `PlotOutput.m`. This script takes the .out files delivered by OpenSees, the reference structure .out files, and simulink results and traces them. Within this script, the Freq_Resp_Tong function is called to calculate the delay between input / output signals. In addition, performance indicators J2 and J4 are calculated.

### OpenSees TCL scripts

In the last line of the server scripts you will find where the TCP communication started. Here you must enter the IP port.

- `ServerBeam1_TCP.tcl`. Server where the beam of the experimental substructure is modeled. The beams are modeled as linear elastic frame elements. 
- `ServerCol1_TCP.tcl`. Server where the right column of the experimental substructure is modeled. A Giuffre-Menegotto-Pinto steel material with isotropic strain hardening is used for his modeling.
- `ServerCol2_TCP.tcl`. Server where the left column of the experimental substructure is modeled. A Giuffre-Menegotto-Pinto steel material with isotropic strain hardening is used for his modeling.
- `SubEstNum.tcl`. Model where the entire numerical substructure is modeled. A Giuffre-Menegotto-Pinto steel material with isotropic strain hardening is used for his modeling. In this file the IP address and port of the NS must be entered. This has to be the same that the entered in the SFun_OPFConect block in the CSvRTHS_Client block in the Simulink model.

### C source code & headers

A C file is a source code file for a C or C++ program. In this case this files are compiled into a Matlab Executable (MEX) file, which is necessary to run user-defined code in Matlab/Simulink. With this mex file its possible to generate the user-defined blocks, called S-Functions, in Simulink.

- `PredictorCorrector.c`. File required for the implemented predictor-corrector method.
- `SFun_OPFConnect.c`. File required for communication between the model in Simulink (CSvRTHS_Client) and the model of the numerical substructure in OpenSees (SubEstNum)
- `SFun_GenericClient.c`. File required for communication between the model in Simulink (CSvRTHS_Client) and the model of the experimental substructure in OpenSees (ServerCol1, ServerCol2, ServerBeam1)
- `TCPSocket.c`. File required to communicate using the TCP/IP protocol.

The header file is called a header file, in computer science, especially in the field of C and C ++ programming languages, to the file, usually in the form of source code, that the compiler automatically includes when processing some other source file.

- `PredictorCorrector.h`.

### Executable files (EXE)

In the field of computing .exe (from the English abbreviation executable) is an extension that refers to an executable file of relocatable code, that is, its memory addresses are relative

- `OpenSees.exe`. OpenSees executable file. This is the console to use to run the CSvRTHS.
- `OpenFresco.exe`. OpenFresco executable file. This is the console to use to run the CSvRTHS.

### Dynamic Link Libraries (DLL)

Some previous definitions:

- A dynamic link library or more commonly DLL (dynamic-link library) is the term that refers to files with executable code that are loaded on demand of a program by the operating system. The files shown below are necessary for the correct execution of OpenFresco. In addition, if it is necessary to compile it or make modifications to its source code, they allow access to all source codes.

- OpenSSL is a robust, commercial-grade, and full-featured toolkit for the Transport Layer Security (TLS) and Secure Sockets Layer (SSL) protocols. It is also a general-purpose cryptography library.

- Dynamic Link Library files are essentially a "guide" that stores information and instructions for executable files (EXE). These files were created so that multiple programs could share the same files, saving valuable memory allocation; therefore, it makes the equipment work more efficiently.

The files uploaded to the repository are listed and explained below.

- `libcrypto-1_1-x64.dll`. File considered a type of OpenSSL library file and is considered a Win64 DLL (Dynamic Link Library) file.
- `libssl-1_1-x64.dll`. File considered a type of OpenSSL library file and is considered a Win64 DLL (Dynamic Link Library) file.
- `msvcr120.dll`. Microsoft C Runtime Library files, such as msvcr120.dll, are considered a type of Win64 DLL (Dynamic Link Library) file.
- `OpenFresco.dll`. This file is necessary for the correct execution of OpenFresco. Similarly, it is necessary if what you want is to compile OpenFresco to make modifications to its source code.
- `Pnpscr64.dll`. This dll is associated with the use of Scramnet shared ram memory, for this simulation it is not used, but it must be included in the folder for the correct execution of OpenFresco.
- `pnpscrd64.dll`. This dll is associated with the use of Scramnet shared ram memory, for this simulation it is not used, but it must be included in the folder for the correct execution of OpenFresco.
- `SubStructure.dll`. dLL file associated with the generation of experimental elements in OpenSees. For more information on this, consult the OpenFresco command manual.
- `xpcapi.dll`. Non-system processes like xpcapi.dll originate from software you installed on your system. The xpcapi.dll is an executable file on your computer's hard drive. This file contains machine code.

Since OpenFresco is taking advantage of and utilizing many existing OpenSees classes, the OpenSees source code needs to be installed and built prior to compiling and building OpenFresco. Finally, Tcl/Tk and OpenSSL need to be installed in order to build and execute OpenFresco.

### Exp files (EXP)

- `OpenFresco.exp`. It is a symbol export file, a kind of developer file used by an Integrated Development Environment (IDE). This type of EXP file contains symbol table data that provides information about a code to support programs for building software. In computational terms, exporting a file consists of transforming data into a format that is compatible with other programs without losing information in the process.

### Lib files (LIB)

- `OpenFresco.lib`. Files that contain the LIB file extension contain a library of static data information. The information in this file is associated with a specific computer application (OpenFresco). LIB files generally store the functions referenced by the application, which is then associated with the library.

### Text File (txt)

- `elcentro.txt`. Text file containing El Centro's 1940 seismic record. This file is read by the numeric substructure model in OpenSees (SubEstNum). In case another seismic record wants to be used, you just have to create the text file and modify the name in the model in OpenSees by the name of the new file. You must know the time spacing of the record and the amount of data to perform enough integration steps to include the entire record.
