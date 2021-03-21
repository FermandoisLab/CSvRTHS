function [A,phi,feq,d] = Freq_Resp_Tong(InSig,OutSig,fsamp)
%     A    : Error de amplitud (Output/Input)
%     phi  : Error de fase
%     feq  : Frecuencia Equivalente
%       d  : Delay 
%    InSig : Señal de Entrada
%   OutSig : Señal de Salida
%    fsamp : Frecuencia de Sampleo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

l=2;    %Exponente ||fft[I(t)]||^l

%FFT de señales
FI0=fft(InSig);         
FO0=fft(OutSig); 

%Proceso Señal de Entrada
L=length(InSig);                              %Tamaño de señal
FI=FI0(1:ceil(L/2));                          %One Sided Spectrum
FI(2:end-1)=2*FI(2:end-1);
fi=fsamp*(0:ceil(L/2)-1)/L;                   %Frecuencias

feq=sum((abs(FI).^l).*fi')/sum(abs(FI).^l);    %Frecuencia Equivalente

%Proceso Señal de Salida
L=length(InSig);                              %Tamaño de señal
FO=FO0(1:ceil(L/2));                          %One Sided Spectrum
FO(2:end-1)=2*FO(2:end-1);
fo=fsamp*(0:ceil(L/2)-1)/L;                   %Frecuencias       


%FEI
sumFI=sum(abs(FI).^l);          
FEI=FO.*abs(FI).^l./FI/sumFI;   
FEI=sum(FEI);

%Amplitud y Fase
A=abs(FEI);
phi=atan(imag(FEI)/real(FEI));

%Retraso temporal
d=-phi/(2*pi*feq); 

