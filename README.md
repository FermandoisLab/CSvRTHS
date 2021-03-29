# Client-Server application for vRTHS

## Description

The example provided here is a four-story planar frame with three bays, with a total of 52 degrees of freedom (16 lateral, 16 vertical, and 20 rotational). The beams are modeled with linear elastic frame elements, while the columns are modeled with frame elements using Giuffre-Menegotto-Pinto steel material with isotropic strain hardening with an initial stiffness of 5.6 [kip/in]. Consequently, the first-mode fundamental period is T1=1.9 [s]. The reference structure is divided into the numerical substructure (NS) and experimental substructure (ES). One bay of the first story is taken as the ES, while the rest is modeled as NS. Since it is intended to work only with a uniaxial actuator, the boundary degrees of freedom are set to be only horizontal displacements.

It is important to mention that these substructures, numerical and experimental, can be replaced by the substructures desired by the user.

<img src="figures/NSES.png" alt="Reference Structure" width="800"/>


## Requirements

- Windows 7 or superior
- Matlab version 2019a or superior
- Simulink Desktop real-time
- OpenSees version 3.1.0 of 2016 - 64 bits
- OpenFresco version 2.7.1 of 2006 - 64 bits

## Instructions

For the execution of this model, the following instructions must be followed.

## Instalation

### Real-time desktop installation

The Simulink Desktop Real-Time software requires a real-time kernel that interfaces with the operating system. Users may refere to https://www.mathworks.com/help/sldrt/ug/real-time-windows-target-kernel.html where detailed instructions on how to install Real-Time Kernel are provided. The following paragraph is a summary of the instruction provided by MathWorks. 
WARNING: Failing to run a real-time simulation without having installed the kernel may cause a major crash of the computer due to insuﬃcient computational resources that may lead to loss of data or unsaved work.

1. Previously save all data and work and close all applications except MATLAB.
2. In the MATLAB Command Window, type: 
    sldrtkernel -install 
    The MATLAB Command Window displays one of these messages: 
    users are going to install the Simulink Desktop Real-Time kernel. Do you want to proceed? [y] :
4. Type y to continue installing the kernel, or n to cancel without changing the current conﬁguration.
5. After installing the kernel, check the installation by typing:

       rtwho 
    
If installed successfully, users should see the following message: 
    
    Simulink Desktop Real-Time version xxxx (C) 
    
    The Mathworks, Inc. 1994-20xx 
    
    Running on 64-bit computer, (xxxx indicates users’ system version and year)

If their computer crashes after installing the kernel there is a patch available from Mathworks that needs to be installed. This can be downloaded directly from the Mathworks website (https://www.mathworks.com/support/bugreports/1719571).

### Mex compiler

If you do not have a Windows operating system, it will be necessary to compile the MEX files again. This can be done directly from Matlab using Matlab's own compiler, MinGW64. To use it must be installed as a complement to Matlab. Information regarding this is available at the following link: https://www.mathworks.com/matlabcentral/fileexchange/52848-matlab-support-for-mingw-w64-c-c-compiler

If you are used to working with other editors such as Visual Studio, it will be necessary to modify the selected compiler to work in Matlab. For that, the following is written in the command window:

    mex -setup
    
Then, users should see the following message: 
    
    MEX configured to use 'xxxx' for C language compilation. (xxxx indicates users’ C compiler that it's selected)
    
    To choose a different C compiler, select one from the following:
    
    MinGW64 Compiler (C)  mex -setup:'folder where the compiler is located on your computer' C
    
    Microsoft Visual C++ 2019 (C)  mex -setup:folder where the compiler is located on your computer C
    
    To choose a different language, select one from the following: 
    
    mex -setup C++ 
    
    mex -setup FORTRAN

To compile an S function in C language, enter the following command in the MATLAB command window:

    mex sfun_name.c

where sfun_name.c is the name of the C source file. The mex command will generate the compiler and linker commands necessary to produce the S-Function executable file. In the event of an error in the compiler, these will be displayed in the MATLAB windows.

### Simulation

The implementation of CSvRTHS is illustrated in the next figure. Briefly, the first requirement is to start the ES-FE server, which is waiting for the resolution to start. Then, Simulink Client must be executed (The integration scheme used in Simulink was ode8 (Dormand-Prince)), which requests a displacement to OpenSees for the execution of the first temporary step. So finally, the OpenSees file (NS-FE Server) that contains the NS and where the integration of the equation of motion is performed is executed. An explicit integration scheme, as Newmark Explicit, is recommended. Here the sampling intervals used for the fast and slow processes are 1/1024 and 2/100 [s], respectively. To summarize, the loops need to be run from the inside to the outside layers: (1) ES-FE server (green); (2) Simulink client (orange); and (3) the NS-FE server (blue-gray).

<img src="figures/Loops.png" alt="Loops of resolution" width="800"/>

Before running, the Simulink model "HybridControllerD2D2" must be open, the address in Matlab must match the address where this file is located since to start it calls a function called "initializeSimulation".

1. Open OpenFresco and type "source ServerBeam1_TCP.tcl"
2. Open OpenFresco and type "source ServerCol2_TCP.tcl"
3. Open OpenSees and type "source ServerCol1_Adapter.tcl"
4. Execute the Simulink model "CSvRTHS_Client", it will load and will be waiting. Additionally, a tab will be displayed showing the movement of the column named Col1. This is optional, if you want to delete you must modify the ServerCol1_Adapter.
5. Open OpenSees and type "source SubEstNum.tcl". This will start the process and a message will be displayed in the OpenSees window. You must press "Enter" three times for vRTHS to start.
6. Once the simulation is finished, the OpenSees and OpenFresco windows will close. Model execution in Simulink should be stopped.

### Post-processing

To check the correct performance of the vRTHS, the following steps must be followed:
1. Open the file called "PlotOutput.m" located in the output folder (folder created by the NS in OpenSees, the name its selectec by the user).
2. If everything was executed correctly, a series of graphs will be shown together with some tables with performance criteria.

<img src="figures/targetvsmeasured.png" alt="Results" width="800"/>

## How to cite
