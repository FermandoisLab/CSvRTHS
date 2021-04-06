
%% Created by: Diego Mera Muñoz
% Universidad Técnica Federico Santa María, Chile
% diego.mera@sansano.usm.cl

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             POST-PROCESSING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% x_r vs x_m
x_mC = load('output/Node_Dsp.out');
x_r = load('output/Node_Dsp_Ref.out');
data = load('output/Elmt_Frc.out');
f_mC = data(:,4);
data = load('output/Elmt_Frc_Ref.out');
f_r = data(:,4);
totaltime = x_mC(end,1);

J4=rms(x_r(:,2)-x_mC(:,2))/rms(x_r(:,2))*100;

figure
subplot(2,1,1)
plot(x_mC(:,1),-x_mC(:,2),'k','LineWidth',1.5)
title('Reference v/s Measured','FontSize',15)
hold on
plot(x_r(:,1),-x_r(:,2),'r--','LineWidth',1.5)
legend('x_{Measured}','x_{Reference}','Orientation','Horizontal','Location','best','FontSize',12)
ylabel('Disp. [in]','FontSize',15)
xlim([0 totaltime])
grid on

subplot(2,1,2)
plot(x_mC(:,1),abs(x_r(:,2)-x_mC(:,2)),'k','LineWidth',1.5)
hold on
legend(['J_4 = ',num2str(J4),' %'],'FontSize',12)%  ; Delay = ',num2str(delaytotal*1000), ' ms']) 
xlabel('Time [sec]','FontSize',15)
ylabel('|error| [in]','FontSize',15)
grid on

figure, hold on
plot(x_mC(:,2),f_mC,'k','LineWidth',1.5)
plot(x_r(:,2),f_r,'r--','LineWidth',1.5)
xlabel ('Displacement [in]','FontSize',15);
ylabel('Lateral Force [kip]','FontSize',15);
title('Hysteresis Loop','FontSize',15);
legend('Measured','Reference','Location','best','FontSize',12)
grid on


%%
%Displacement Results
t_t = x_t.Time;
x_t = x_t.Data;     %Target
t_t1 = x_t1.Time;
x_t1 = x_t1.Data;   %Commanded
t_m = x_m.Time;
x_m = x_m.Data;     %Measured
t_c = x_c.Time;
x_c = x_c.Data;     %Compensated

totaltime = t_t(end);
fs = 1024;
dtsim = 0.5/fs;
J2=rms(x_t-x_m)/rms(x_t)*100;
[Amptotal,phitotal,feqtotal,delaytotal] = Freq_Resp_Tong(x_t,x_m,1/dtsim);

%% x_t vs x_m

figure
subplot(2,4,[1,2,3])
plot(t_t,x_t,'k','LineWidth',1.5)
hold on
plot(t_m,x_m,'r--','LineWidth',1.5)
legend('x_{Target}','x_{Measured}','Orientation','Horizontal','Location','best','FontSize',12)
xlabel('Time [sec]','FontSize',15)
ylabel('Disp. [in]','FontSize',15)
xlim([0 totaltime])
grid on

subplot(2,4,[5,6,7])
plot(t_t,abs(x_t-x_m),'k','LineWidth',1.5)
hold on
plot(t_t(1,1),abs(x_t(1,1)-x_m(1,1)),'k','LineWidth',1.5)
legend(['J_2 = ',num2str(J2),' %'],['Delay = ',num2str(delaytotal*1000), ' ms'],'FontSize',12)  
xlabel('Time [sec]','FontSize',15)
ylabel('|error| [in]','FontSize',15)
xlim([0 totaltime])
grid on

subplot(2,4,[4,8])
plot(t_t,x_t,'k','LineWidth',1.5)
hold on
plot(t_m,x_m,'r--','LineWidth',1.5)
legend('x_{Target}','x_{Measured}','Orientation','Vertical','Location','best','FontSize',12)
xlabel('Time [sec]','FontSize',15)
ylabel('Disp. [in]','FontSize',15)
xlim([4.5 6])
suptitle('Synchronization')
grid on

%% Parameters AMBC
%Adaptive parameters in time

amb0=amb.Data(:,1);
amb1=amb.Data(:,2);
amb2=amb.Data(:,3);
amb3=amb.Data(:,4);

figure
subplot(2,2,1)
plot(t_t,amb0,'k')
xlabel('Time [sec]')
ylabel('a_0')
xlim([0 totaltime])
grid on

subplot(2,2,2)
plot(t_t,amb1,'k')
xlabel('Time [sec]')
ylabel('a_1  [sec]')
xlim([0 totaltime])
grid on

subplot(2,2,3)
plot(t_t,amb2,'k')
xlabel('Time [sec]')
ylabel('a_2  [sec^2]')
xlim([0 totaltime])
grid on

subplot(2,2,4)
plot(t_t,amb3,'k')
xlabel('Time [sec]')
ylabel('a_3   [sec^3]')
xlim([0 totaltime])
grid on

suptitle('Adaptive parameters in time')
%% x_m v/s x_Slave

x_S = load('output/Slave_Node_Dsp.out');

w = 1.5;
FT = 15;
FTL = 12;

t1 = x_mC(find(x_mC(:,2)==min((x_mC(:,2)))),1);
t2 = x_S(find(x_S(:,2)==max((x_S(:,2)))),1);
t2 = 0.5/1024*t2;
dt = min(t2-t1);

figure
subplot(2,4,[1,2,3,5,6,7])
plot(0:0.5/1024:0.5/1024*(length(x_S(:,1))-1),x_S(:,2),'k','LineWidth',w)
hold on
plot(x_mC(:,1)+dt,-x_mC(:,2),'r--','LineWidth',w)
legend('x_{ES}','x_{NS}','Orientation','Horizontal','Location','best','FontSize',FTL)
xlabel('Time [sec]','FontSize',FT)
ylabel('Disp. [in]','FontSize',FT)
xlim([0 35])
grid on

subplot(2,4,[4,8])
plot(0:0.5/1024:0.5/1024*(length(x_S(:,1))-1),x_S(:,2),'k','LineWidth',w)
hold on
plot(x_mC(:,1)+dt,-x_mC(:,2),'r--','LineWidth',w)
legend('x_{ES}','x_{NS}','Orientation','Vertical','Location','best','FontSize',FTL)
xlabel('Time [sec]','FontSize',FT)
ylabel('Disp. [in]','FontSize',FT)
xlim([4.5 6])
suptitle('Interface Node')
grid on


%% Predictor-Corrector Algorithm

t1 = x_mC(find(x_mC(:,2)==min((x_mC(:,2)))),1);
t2 = t_t(find(x_t==max((x_t))));

dt = t2-t1;

figure
hold on
plot(t_t,-x_t,'k','Linewidth',1.5)
plot(t_t1,-x_t1,'r','Linewidth',1.5)
legend('x_{Target}','x_{OpenSees}','Location','best','FontSize',12)
xlabel('Time [sec]','FontSize',15)
ylabel('Disp. [in]','FontSize',15)
title('Predictor-Corrector Algorithm')
xlim([5.5 6])
grid on

%% Base Shear v/s Roof Story Displacement
V = sum(load('output/Vbase.out').');
d = x_mC(:,3);
V_R = sum(load('output/Vbase_Ref.out').');
d_R = x_r(:,3);

var = 2047;
figure
plot(-d_R([1:var],1),V_R(1:var),'k','LineWidth',1.5)
hold on
plot(-d([1:var],1),V(1:var),'r--','LineWidth',1.5)
ylabel('Base Shear [kips]','FontSize',15)
xlabel('Roof Story Displacement [in]','FontSize',15)
legend('Reference','Measured','FontSize',12)
title('Base Shear v/s Roof Story Displacement')
grid on

%% Missed Ticks
time = M_T.Time;
ticks = M_T.Data;

figure
plot(time,ticks,'k','LineWidth',1.5)
hold on
plot(time(find(ticks==max(abs(ticks)))),max(ticks),'*r','LineWidth',1.5)
xlabel('Time [sec]','FontSize',15)
ylabel('Missed Ticks','FontSize',15)
legend('Missed Ticks',['Max_{MT} = ',num2str(max(ticks))],'FontSize',12)
grid on

%% Outcome indicators
Ticks = max(M_T.Data);
Ji = ["J2 [%]";"J4 [%]";"delay [ms]"];
Ji = cellstr(Ji);
results=[J2;J4;delaytotal*1000];
table(results,'VariableNames',{'Results'},'RowNames',Ji)

