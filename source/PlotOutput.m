
Dsp = load('Node_Dsp.out');
Vel = load('Node_Vel.out');
Acc = load('Node_Acc.out');
Reac = load('Node_Reac.out');
Dsp_Unc = load('Node_Dsp_Unc.out');
g10 = load('g10.txt');
t = 0:0.02:0.02*(length(g10)-1);

EC = load('elcentro.txt');
tEC = (0:0.02:0.02*(length(EC)-1)).';
% ElCentroInterp = [tEC EC];
% save('ElCentro.mat','ElCentroInterp')


figure, hold on
plot(t,g10)
plot(tEC,EC)
legend('g10','El Centro')

figure, hold on
plot(Dsp(:,1),-Dsp(:,2))
plot(Dsp_Unc(:,1),-Dsp_Unc(:,2))
legend('Passive On','Uncontrolled')
xlim([0 12])
grid on

x1 = max(abs(Dsp_Unc(:,2)))
x2 = max(abs(Dsp_Unc(:,3)-Dsp_Unc(:,2)))
x3 = max(abs(Dsp_Unc(:,4)-Dsp_Unc(:,3)))
%%
%Resultados desplazamientos
t_t = x_t.Time;
x_t = x_t.Data;     %Target
t_m = x_m.Time;
x_m = x_m.Data;     %Medido
t_v = x_v.Time;
x_v = x_v.Data;     %Medido
totaltime = t_t(end);
fs = 1024;
dtsim = 1/fs;
% Indicadores de resultados
J2=rms(x_t-x_m)/rms(x_t)*100;
J22=rms(x_t-x_v)/rms(x_t)*100;
[Amptotal,phitotal,feqtotal,delaytotal] = Freq_Resp_Tong(x_t,x_m,1/dtsim);

Ji = ["J2 [%]";"delay [ms]"];
Ji = cellstr(Ji);
results=[J2;delaytotal*1000];
table(results,'VariableNames',{'Results'},'RowNames',Ji)


%% x_t vs x_m
figure
subplot(2,1,1)
plot(t_t,x_t*1000,'k')
title('Synchronization')
hold on
plot(t_m,x_m*1000,'r--')
legend('x_t','x_m','Orientation','Horizontal','Location','best')
xlabel('Time [sec]')
ylabel('Disp. [mm]')
xlim([0 totaltime])
grid on

subplot(2,1,2)
plot(t_t,abs(x_t*1000-x_m*1000),'k')
hold on
legend(['J_2 = ',num2str(J2),' %'])%  ; Delay = ',num2str(delaytotal*1000), ' ms']) 
xlabel('Time [sec]')
ylabel('|error| [mm]')
xlim([0 totaltime])
grid on

%% x_t vs x_v
figure
subplot(2,1,1)
plot(t_t,x_t*1000,'k')
title('Synchronization')
hold on
plot(t_v,x_v*1000,'r--')
legend('x_t','x_v','Orientation','Horizontal','Location','best')
xlabel('Time [sec]')
ylabel('Disp. [mm]')
xlim([0 totaltime])
grid on

subplot(2,1,2)
plot(t_t,abs(x_t*1000-x_v*1000),'k')
hold on
legend(['J_2 = ',num2str(J22),' %'])%  ; Delay = ',num2str(delaytotal*1000), ' ms']) 
xlabel('Time [sec]')
ylabel('|error| [mm]')
xlim([0 totaltime])
grid on