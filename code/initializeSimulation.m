%INITIALIZESIMULATION to initialize the parameters needed to build the Simulink model
%
% created by MTS
% modified by Andreas Schellenberg (andreas.schellenberg@gmail.com) 11/2004
% modified by Diego Mera Muñoz (diego.mera@sansano.usm.cl) 03/2021
%

clear;
% close all;
clc;

coef=1.0;
% ic=importdata('ic.mat');
% run('HT_Params_V2.m')
% run('initialize_sim.m')

%%%%%%%%%% HYBRID CONTROLLER PARAMETERS %%%%%%%%%%

% set number of degrees-of-freedom
HybridCtrlParameters.nDOF = 1;

% set time steps
HybridCtrlParameters.upFact   = 1;          % upsample factor
HybridCtrlParameters.dtInt    = 20/1024;    % integration time step (sec)
HybridCtrlParameters.dtSim    = 20/1024;    % simulation time step (sec)
HybridCtrlParameters.dtCon    = 0.5/1024;   % controller time step (sec)
HybridCtrlParameters.delay    = zeros(1,HybridCtrlParameters.nDOF);
HybridCtrlParameters.delay(1) = 10/1024;     % delay compensation DOF 1 (sec)

% update controller time step
HybridCtrlParameters.dtCon = HybridCtrlParameters.dtCon/HybridCtrlParameters.upFact;
% calculate number of substeps
HybridCtrlParameters.N = round(HybridCtrlParameters.dtSim/HybridCtrlParameters.dtCon);
% update simulation time step
HybridCtrlParameters.dtSim = HybridCtrlParameters.N*HybridCtrlParameters.dtCon;

% calculate number of delay steps
HybridCtrlParameters.iDelay = round(HybridCtrlParameters.delay./HybridCtrlParameters.dtCon);

% check that finite state machine does not deadlock
delayRatio = HybridCtrlParameters.iDelay/HybridCtrlParameters.N;
if (delayRatio>0.6 && delayRatio<0.8)
    warndlg(['The delay compensation exceeds 60% of the simulation time step.', ...
        'Please consider increasing the simulation time step in order to avoid oscillations.'], ...
        'WARNING');
elseif (delayRatio>=0.8)
    errordlg(['The delay compensation exceeds 80% of the simulation time step.', ...
        'The simulation time step must be increased in order to avoid deadlock.'], ...
        'ERROR');
    return
end

% update delay time
HybridCtrlParameters.delay = HybridCtrlParameters.iDelay*HybridCtrlParameters.dtCon;

% calculate testing rate
HybridCtrlParameters.Rate = HybridCtrlParameters.dtSim/HybridCtrlParameters.dtInt;

disp('Model Properties:');
disp('=================');
disp(HybridCtrlParameters);

%%%%%%%%%% SIGNAL COUNTS %%%%%%%%%%

nAct    = 8;                                    % number of actuators
nAdcU   = 12;                                   % number of user a/d channels
nDucU   = 8;                                    % number of user ducs
nEncU   = 2;                                    % number of user encoders
nDinp   = 4;                                    % no. of digital inputs written to scramnet
nDout   = 4;                                    % no. of digital outputs driven by scramnet
nUDPOut = 1+7*nAct+nAdcU+nDucU+nEncU+nDinp;     % no. of outputs from simulink bridge
nUDPInp = 1+6*nAct+nAdcU+nDucU+nEncU+nDinp;     % no. of inputs to simulink bridge

%%%%%%%%%% UNITS %%%%%%%%%%

% Define user units and conversion factors to canonical units.
%
% User units are used for entering physical parameters and for viewing output
% signals, but internally all computations are done in "canonical" units.
% Canonical units form a consistent system of units that ultimately derive
% from the units used for displacement and force.  Canonical units should only
% contain displacement, force, and time units.  For example, if displacement is
% inches, then canonical velocity units are inches/s, acceleration units are
% inches/s^2, etc.  If you want to view acceleration in G's, then you must
% provide the conversion factor from G's to canonical acceleration units,
% inches/s^2.
%
% Below, you must enter the conversion factors from your units to canonical
% units, as follows:
% 1) Change the unit names in the "user" and "canonical" columns of the comment
%    text.  Do this not only for documentation purposes, but also to make it
%    clear to you what conversion factors you need to compute.  Pay particular
%    attention to selecting linear displacement and linear force units, because
%    they determine the canonical units of all other physical quantities.
% 2) Compute the conversion factors from user to canonical units for the
%    variables shown (user units = conversion factor x canonical units).
%
% Note about mass user units:  Mass user units are actually force, not mass,
% because it is easier for users to think of mass in terms of weight.  The
% conversion to true mass units is done by embedding the gravity constant in
% the term "massCanon".
%                                            user        canonical

velocCanon  = 1;              % veloc:       in/s        in/s
lengthCanon = 1;              % length:      in          in
areaCanon   = 1;              % area:        in^2        in^2
volumeCanon	= 231;            % volume:      gal         in^3
forceCanon  = 1;              % force:       kip         kip
pressCanon  = 0.001;          % pressure:    psi         kip/in^2
flowCanon   = 3.85;           % flow:        gpm         in^3/s
leakCanon   = flowCanon ...
            / pressCanon;     % leakage:     gpm/psi     in^5/kip-s
massCanon   = 0.002588;       % mass:        kip         kip/in/s^2
springCanon = 1;              % spring:      kip/in      kip/in
damperCanon = 1;              % damper:      kip/in/s    kip/in/s


%%%%%%%%%% ACTUATOR/ACCUMULATOR PARAMETERS %%%%%%%%%%

% (Note: "1" and "2" denote actuator cylinders on either side of
%  the actuator piston.  With positive valve drive, oil is ported
%  into cylinder 1, resulting in positive displacement.)

% hydraulic parameters
supplyPress = 3000;     % psi
returnPress = 50;       % psi
bulkModulus	= 1.0e05;   % psi

% dynamic short actuator parameters
ratedPressA = 1000;     % psi
ratedFlowA  = 250.0;    % gpm
nominFlowA  = 375.0;    % gpm
area1A      = 75.5;     % in^2
area2A      = 75.5;     % in^2
stroke1A    = 20.0;     % in
stroke2A    = 20.0;     % in
endLength1A = 2.0;      % in
endLength2A = 2.0;      % in
leakageA    = 0;        % gpm/psi

% dynamic long actuator parameters
ratedPressB = 1000;     % psi
ratedFlowB  = 250.0;    % gpm
nominFlowB  = 375.0;    % gpm
area1B      = 55.0;     % in^2
area2B      = 55.0;     % in^2
stroke1B    = 40.0;     % in
stroke2B    = 40.0;     % in
endLength1B = 2.0;      % in
endLength2B = 2.0;      % in
leakageB    = 0;        % gpm/psi

% static actuator parameters
ratedPressC = 1000;     % psi
ratedFlowC  = 15.0;     % gpm
nominFlowC  = 22.5;     % gpm
area1C      = 113.1;    % in^2
area2C      = 74.6;     % in^2
stroke1C    = 72.0;     % in
stroke2C    = 72.0;     % in
endLength1C = 0;        % in
endLength2C = 0;        % in
leakageC    = 0;        % gpm/psi

% accumulator parameters
accumVolume = 23;       % gal
accumNumber = 1;        % -
precharge   = 1000;     % psi
gasConstant = 1.8;      % nitrogen
pumpFlow    = 1e10;     % gpm

%%%%%%%%%% PAYLOAD PARAMETERS %%%%%%%%%%

% friction parameters (dynamic short actuator)
frictionA   = 0;        % kip
yieldDisplA = 0.1;      % in

% friction parameters (dynamic long actuator)
frictionB   = 0;        % kip
yieldDisplB = 0.1;      % in

% friction parameters (static actuator)
frictionC   = 0;        % kip
yieldDisplC = 0.1;      % in

% fixture & specimen parameters (dynamic short actuator)
staticForceA = 0;       % kip
springA      = 2.8;     % kip/in
yieldFrcA    = 2.0;     % kip
damperA      = 0;       % kip/in/s
massA        = 4.2;     % kip

% fixture & specimen parameters (dynamic long actuator)
staticForceB = 0;       % kip
springB      = 2.8;     % kip/in
yieldFrcB    = 2.0;     % kip
damperB      = 0;       % kip/in/s
massB        = 2.5;     % kip

% fixture & specimen parameters (static actuator)
staticForceC = 0;       % kip
springC      = 2.8;     % kip/in
yieldFrcC    = 2.0;     % kip
damperC      = 0;       % kip/in/s
massC        = 2.5;     % kip

%%%%%%%%%% COMPUTED QUANTITIES (do not modify!) %%%%%%%%%%

% sample period parameters
samplePeriod = 0.5/1024;  % sec
T            = samplePeriod;

% other parameters
valveDelay = 0.005;     % sec
overlap    = 0.1;       % percent
damping    = 6;         % percent
ratioPorts = 0;         % don't ratio ports

% dynamic short actuator parameters
areaA       = (area1A + area2A) / 2;
halfLengthA = (stroke1A + endLength1A + stroke2A + endLength2A) / 2;
oilColumnA  = sqrt(2 * areaA * areaCanon * bulkModulus * pressCanon ...
   / (halfLengthA * lengthCanon * massA * massCanon)) / (2 * pi);
maxFlowA    = ratedFlowA * sqrt(supplyPress / ratedPressA);
maxDisplA   =  (stroke2A + endLength2A) * lengthCanon;
minDisplA   = -(stroke1A + endLength1A) * lengthCanon;
maxVelocA   =  (maxFlowA * flowCanon / (area1A * areaCanon)) / velocCanon;
minVelocA   = -(maxFlowA * flowCanon / (area2A * areaCanon)) / velocCanon;
maxForceA   =  area1A * areaCanon * (supplyPress-returnPress) * pressCanon;
minForceA   = -area2A * areaCanon * (supplyPress-returnPress) * pressCanon;
dampFactorA = damping * 0.01 * 2 * pi * oilColumnA * massA * massCanon;
actParamsA  = ...
   [bulkModulus * pressCanon;
   valveDelay;
   overlap      * 0.01;
   ratedPressA  * pressCanon;
   ratedFlowA   * flowCanon;
   nominFlowA   * flowCanon;
   area1A       * areaCanon;
   area2A       * areaCanon;
   stroke1A     * lengthCanon;
   stroke2A     * lengthCanon;
   endLength1A  * lengthCanon;
   endLength2A  * lengthCanon;
   dampFactorA;
   leakageA     * leakCanon;
   ratioPorts;
   samplePeriod;
   1;               % displCanon
   velocCanon;
   1;               % forceCanon
   pressCanon;
   flowCanon]';

% dynamic long actuator parameters
areaB       = (area1B + area2B) / 2;
halfLengthB = (stroke1B + endLength1B + stroke2B + endLength2B) / 2;
oilColumnB  = sqrt(2 * areaB * areaCanon * bulkModulus * pressCanon ...
   / (halfLengthB * lengthCanon * massB * massCanon)) / (2 * pi);
maxFlowB    = ratedFlowB * sqrt(supplyPress / ratedPressB);
maxDisplB   =  (stroke2B + endLength2B) * lengthCanon;
minDisplB   = -(stroke1B + endLength1B) * lengthCanon;
maxVelocB   =  (maxFlowB * flowCanon / (area1B * areaCanon)) / velocCanon;
minVelocB   = -(maxFlowB * flowCanon / (area2B * areaCanon)) / velocCanon;
maxForceB   =  area1B * areaCanon * (supplyPress-returnPress) * pressCanon;
minForceB   = -area2B * areaCanon * (supplyPress-returnPress) * pressCanon;
dampFactorB = damping * 0.01 * 2 * pi * oilColumnB * massB * massCanon;
actParamsB  = ...
   [bulkModulus * pressCanon;
   valveDelay;
   overlap      * 0.01;
   ratedPressB  * pressCanon;
   ratedFlowB   * flowCanon;
   nominFlowB   * flowCanon;
   area1B       * areaCanon;
   area2B       * areaCanon;
   stroke1B     * lengthCanon;
   stroke2B     * lengthCanon;
   endLength1B  * lengthCanon;
   endLength2B  * lengthCanon
   dampFactorB;
   leakageB     * leakCanon;
   ratioPorts;
   samplePeriod;
   1;               % displCanon
   velocCanon;
   1;               % forceCanon
   pressCanon;
   flowCanon]';

% static actuator parameters
areaC       = (area1C + area2C) / 2;
halfLengthC = (stroke1C + endLength1C + stroke2C + endLength2C) / 2;
oilColumnC  = sqrt(2 * areaC * areaCanon * bulkModulus * pressCanon ...
   / (halfLengthC * lengthCanon * massC * massCanon)) / (2 * pi);
maxFlowC    = ratedFlowC * sqrt(supplyPress / ratedPressC);
maxDisplC   =  (stroke2C + endLength2C) * lengthCanon;
minDisplC   = -(stroke1C + endLength1C) * lengthCanon;
maxVelocC   =  (maxFlowC * flowCanon / (area1C * areaCanon)) / velocCanon;
minVelocC   = -(maxFlowC * flowCanon / (area2C * areaCanon)) / velocCanon;
maxForceC   =  area1C * areaCanon * (supplyPress-returnPress) * pressCanon;
minForceC   = -area2C * areaCanon * (supplyPress-returnPress) * pressCanon;
dampFactorC = damping * 0.01 * 2 * pi * oilColumnC * massC * massCanon;
actParamsC  = ...
   [bulkModulus * pressCanon;
   valveDelay;
   overlap      * 0.01;
   ratedPressC  * pressCanon;
   ratedFlowC   * flowCanon;
   nominFlowC   * flowCanon;
   area1C       * areaCanon;
   area2C       * areaCanon;
   stroke1C     * lengthCanon;
   stroke2C     * lengthCanon;
   endLength1C  * lengthCanon;
   endLength2C  * lengthCanon;
   dampFactorC;
   leakageC     * leakCanon;
   ratioPorts;
   samplePeriod;
   1;               % displCanon
   velocCanon;
   1;               % forceCanon
   pressCanon;
   flowCanon]';

% accumulator parameters
volume       = accumVolume * accumNumber;
maxOilVolume = volume * (1 - (precharge/supplyPress)^(1/gasConstant));

% actuator envelopes
displRange = [minDisplA maxDisplA; minDisplB maxDisplB; minDisplC maxDisplC];
velocRange = [minVelocA maxVelocA; minVelocB maxVelocB; minVelocC maxVelocC];
forceRange = [minForceA maxForceA; minForceB maxForceB; minForceC maxForceC];
oilColumn  = [oilColumnA; oilColumnB; oilColumnC];

% print physical ranges
disp('Actuator Physical Ranges:');
disp('=========================');
disp('displacement range [in.]:')
disp(displRange);
disp('velocity range [in./sec]:')
disp(velocRange);
disp('force range [kips]:')
disp(forceRange);
disp('oil column frequency [Hz]:')
disp(oilColumn);
disp('discharge [gal]:')
disp(maxOilVolume);

%% PID Controller of the MTS Actuator
% Convert Displacement into Voltage
Kp = maxForceC/areaC;
Ti = 0.0; Ki = Kp*Ti;
Td = 0.0; Kd = Kp*Td;

%%
% ==============================================================================================================================
% Adaptive Time Series (ATS) Compensator
% by Yunbyeong Chae, Old Dominion University
% Ref: Chae, Y., Kazemibidokhti, K., and Ricles, J.M. (2013) 
% “Adaptive time series compensator for delay compensation of servo-hydraulic actuator systems for real-time hybrid simulation”, 
% Earthquake Engineering and Structural Dynamics, 42(11), 1697-1715.
% ==============================================================================================================================
%{
sample = 1/1024;             % sample time step of RTHS [sec]
sample_rate = 1/sample;      % sampling rate of RTHS [Hz]
tl = 1.0;                    % duration of moving window [sec]
Nl = floor(tl*sample_rate);  % number of samples in moving window
SN = 16;                     % skipping number

% threshold value for triggering ATS compensator [in.]
if (HybridCtrlParameters.nDOF >= 1)
    Threshold(1) = 0.01;
end
if (HybridCtrlParameters.nDOF >= 2)
    Threshold(2) = 0.01;
end
if (HybridCtrlParameters.nDOF >= 3)
    Threshold(3) = 0.01;
end

%Par = [1 0.04 0.0008];       % initial a0, a1, a2 values
% Par values can be obtained from predefined displacement tests. However,
% the values for Par can be approximately estimated as follows:
% a0 (amplitude factor) is usually to be around 1
% a1 is about the same as the expected time delay when a0 is close to 1
% ex) if the expected time delay of an actuator is 40 msec, then a1 can be
% set to be 0.04
% a2 can be simply set to be a2=a1^2/2
if (HybridCtrlParameters.nDOF >= 1)
    Par(1,1) = 1;
    Par(2,1) = 0.020;
    Par(3,1) = 0.5*Par(2,1)^2;
end
if (HybridCtrlParameters.nDOF >= 2)
    Par(1,2) = 1;
    Par(2,2) = 0.020;
    Par(3,2) = 0.5*Par(2,2)^2;
end
if (HybridCtrlParameters.nDOF >= 3)
    Par(1,3) = 1;
    Par(2,3) = 0.020;
    Par(3,3) = 0.5*Par(2,3)^2;
end

P_range = [0.7 1.30;
           0.0 0.08;
           0.0 0.0032]; 
% P_range represents the minimum and maximum allowable values for a0, a1, and a2.
% Thus, the identified a0, a1, and a2 values by ATS compensator are always bounded by P_range
% See Table 1 in the paper for more details

MRC = [2 0.05 0.001];  % maximum rate of change (can use these as default values) 

% Butterworth filter
Filter_order = 6;
Cut_off_freq = 20;
[b,a] = butter(Filter_order,2*pi*Cut_off_freq,'s');
dt = 1/sample_rate;
sys = tf(b,a);
zsys = c2d(sys,dt);
ztag = get(zsys);
Znum = ztag.Numerator{1};
Zden = ztag.Denominator{1};
%}


seed = rng(123);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set Sensor RMS noise (Displacement transducer)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rms_noise_DT = 6.25e-13;        % 
Seed_snr = rng(seed);           % Random number generator for noise
Gsnsr_DT = 1;                   % Sensor Gain
rmsD=sqrt(rms_noise_DT/(samplePeriod));   %rms asociado en N

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set Sensor RMS noise (Force transducer)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rms_noise_FT = 1.16e-13;            % 
Seed_snr = rng(seed);           % Random number generator for noise
Gsnsr_FT = 1;                   % Sensor Gain
rmsF=sqrt(rms_noise_FT/(samplePeriod));   %rms asociado en N


%% AMB Cristobal
dtsim = samplePeriod;

%% Controlador 1
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  SET UP A/D and D/A CONVERTERS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Saturation limits 
sat_limit_upper = +3.8;         % Volts
sat_limit_lower = -3.8;         % Volts
% Quantization interval
quantize_int = 1 / 2^18;        % 18 bit channel

%% Propiedades sistema de transferencia y modelo para condiciones iniciales del controlador
%Parámetros problema benchmark
gain=1;      
a1_b0=2.13e13;      
a2=4.23e6;           
a3=3.3;
b1=425;
b2=1e5;

%Subestructura experimental de baja interacción para obtener TF de la
%planta 
meLoadSys=0;
keLoadSys=1; 
ceLoadSys=0;

%Funciones de transferencia
s=tf('s');
Gest = tf(1,[meLoadSys ceLoadSys keLoadSys]);
Ga = tf(1,[1 a3]);
Gs = tf(a1_b0,[1 b1 b2]);
Gcsi = a2*s;
G0 = feedback(Ga*Gest,Gcsi,-1);
GpLoadSys = gain*feedback(Gs*G0,1,-1);

%Nota: En un ensayo real, este modelo del actuador se obtiene mediante
%identificación de sistema.

%% Controlador

%Condiciones iniciales:  actuador sin Especimen 3 orden
[num,den] = tfdata(GpLoadSys,'v');
num = num(end);
AMB = tf(den/num,1);      %controlador inicial en forma de TF impropia
A_amb_i = flip(den/num);   %condiciones iniciales del controlador AMB
% A_amb_i = [1 0.062 0.062^2/2 0.062^3/6];
% Derivadas numéricas para filtro FIR
u = [1 0 0 0];
dudt = [1 -1 0 0]/dtsim;
dudt2 = [1 -2 1 0]/dtsim^2;
dudt3 = [1 -3 3 -1]/dtsim^3;

Derivadas=[u;dudt;dudt2;dudt3];

% Límites para parámetros adaptivos

%Al comparar con ATS... a_0=error de amplitud / a_1=retraso /
%a_2=retraso^2/2 /  a_3=retraso^3/6. Esto puede servir como guía para
%establecer límites. El otro camino es evaluar la función de transferencia
%de la planta con diferentes especimenes

%a0
amb0max=1.5;
amb0min=0;
%a1
amb1max=100/1000;
amb1min=0;
%a2
amb2max=amb1max^2/2;
amb2min=0;
%a3
amb3max=amb1max^3/6;
amb3min=0;

%Límites para los parámetros
max_amb=[amb0max,amb1max,amb2max,amb3max]*1e15;   %Es más seguro poner límites, pero con libre adaptación es más fácil detectar casos donde la adaptación no es convergente.
min_amb=[amb0min,amb1min,amb2min,amb3min];

%Filtro para ruido en desplazamiento 
n = 4;     %orden del filtro
fc = 20;   %frecuencia de corte
fs = 1/dtsim;
[numfilter,denfilter] = butter(n,fc/(fs/2));  %filtro butterworth discreto

% Adaptive gains 
adaptivegain = diag(10.^[6.03 4.23 1.48 -1.10]);    %Gains obtenidos mediante calibración. Se pueden modificar manualmente
% amplitud, retraso, retraso^2, retraso^2
%}

%% Controlador 2
%{
% Derivadas
u = [1 0 0 0];
dudt = [1 -1 0 0]/dtsim;
dudt2 = [1 -2 1 0]/dtsim^2;
dudt3 = [1 -3 3 -1]/dtsim^3;
Derivadas = [u;dudt;dudt2;dudt3];

% Sistema de transferencia y modelo para condiciones iniciales
A_amb_i = [1 20/1000 8e-5 2e-7];
G_act = tf(1,flip(A_amb_i));

% Controlador feedforward
%Filtro
n = 4;
fc = 20;
fs = 1/dtsim;
[numfilter,denfilter] = butter(n,fc/(fs/2));

%Controlador inicial
dAMB_i = A_amb_i*Derivadas;
fir_coef = length(dAMB_i);

%Parametros diseño RLS
forgfact = 1;
P_corr_i = eye(4)*1e10;
%}



%% Parámetros Actuador Carrion & Spencer
% Controller
Kp = 3.0;       % mA/in
% Servovalve
tauv = 0.00332; %s
kv = 1;
Kq = 23.01;     % in^3/s/mA
Kc = 1.36e-5;   %in^3/s/psi
%Actuator
Area = 0.751;   % in^2
Cl = 5.89e-6;   % in^3/s/psi
Vt = 48.66;     % in^3
Be = 95958;     % psi

%Sub. Experimental benchmark
me = 0.023/1000; % kg^2/m
ce = 0.0; % kg/m
ke = 0.0; % kg/m
