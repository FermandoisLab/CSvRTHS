function [A,phi,feq,d] = Freq_Resp_Tong(InSig,OutSig,fsamp)
%     A    : Amplitude error (Output/Input)
%     phi  : Phase error
%     feq  : Equivalent frequency
%       d  : Time delay 
%    InSig : Input signal
%   OutSig : Output signal
%    fsamp : Sampling Frequency

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

l=2;    %Exponent ||fft[I(t)]||^l

%Signals FFT
FI0=fft(InSig);         
FO0=fft(OutSig); 

%Input Signal Process
L=length(InSig);                              %signal length
FI=FI0(1:ceil(L/2));                          %One Sided Spectrum
FI(2:end-1)=2*FI(2:end-1);
fi=fsamp*(0:ceil(L/2)-1)/L;                   %Frequencies

feq=sum((abs(FI).^l).*fi')/sum(abs(FI).^l);    %Equivalent frequency

%Output Signal Process
L=length(InSig);                              %signal length
FO=FO0(1:ceil(L/2));                          %One Sided Spectrum
FO(2:end-1)=2*FO(2:end-1);
fo=fsamp*(0:ceil(L/2)-1)/L;                   %Frequencies      


%FEI
sumFI=sum(abs(FI).^l);          
FEI=FO.*abs(FI).^l./FI/sumFI;   
FEI=sum(FEI);

%Amplitude and phase
A=abs(FEI);
phi=atan(imag(FEI)/real(FEI));

%Time delay
d=-phi/(2*pi*feq); 

