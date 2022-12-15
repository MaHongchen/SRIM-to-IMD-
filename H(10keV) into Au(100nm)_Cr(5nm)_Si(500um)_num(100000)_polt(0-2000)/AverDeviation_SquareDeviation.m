clc; clear; close all;

%% Parameter setting
Does=[10^15,5*10^15,10^16,2*10^16,4*10^16,6*10^16,8*10^16];



%% 导入未辐照的反射率；
inter=' ';
FL=1;
inputfilename0='maxwell Reflection under Does=0.txt';
R0=importdata(inputfilename0,inter,FL);
ref0=R0.data;
angle=ref0(:,1);
r0=ref0(:,2);

%% 导入Does=1*10^15的反射率；
inputfilename1='maxwell Reflection under Does=1000000000000000.txt';
R1=importdata(inputfilename1,inter,FL);
ref1=R1.data;
r1=ref1(:,2);

%% 导入Does=5*10^15的反射率；
inputfilename2='maxwell Reflection under Does=5000000000000000.txt';
R2=importdata(inputfilename2,inter,FL);
ref2=R2.data;
r2=ref2(:,2);

%% 导入Does=1*10^16的反射率；
inputfilename3='maxwell Reflection under Does=1e+16.txt';
R3=importdata(inputfilename3,inter,FL);
ref3=R3.data;
r3=ref3(:,2);

%% 导入Does=2*10^16的反射率；
inputfilename4='maxwell Reflection under Does=2e+16.txt';
R4=importdata(inputfilename4,inter,FL);
ref4=R4.data;
r4=ref4(:,2);

%% 导入Does=4*10^16的反射率；
inputfilename5='maxwell Reflection under Does=4e+16.txt';
R5=importdata(inputfilename5,inter,FL);
ref5=R5.data;
r5=ref5(:,2);

%% 导入Does=6*10^16的反射率；
inputfilename6='maxwell Reflection under Does=6e+16.txt';
R6=importdata(inputfilename6,inter,FL);
ref6=R6.data;
r6=ref6(:,2);

%% 导入Does=8*10^16的反射率；
inputfilename7='maxwell Reflection under Does=8e+16.txt';
R7=importdata(inputfilename7,inter,FL);
ref7=R7.data;
r7=ref7(:,2);

Reflection=[r1,r2,r3,r4,r5,r6,r7];

%% 求均差和均方根差；
aver=zeros(7,1);
square=zeros(7,1);
for i=1:7
    aver_dev=0;
    square_dev=0;
    for k=1:length(angle)
        aver_dev=aver_dev+abs(Reflection(k,i)-r0(k));
        square_dev=square_dev+(abs(Reflection(k,i)-r0(k)))^2;
    end
    aver(i,1)=aver_dev/length(angle);
    square(i,1)=(square_dev/length(angle))^0.5;
end

figure;
plot(Does,aver,'-o',Does,square,'-*','LineWidth',2);
legend('Aver','Square','Location','best');
%set(gca,'xscale','log');
xlabel('Does');
ylabel('Aver and Square');

%% 画差值分布图

figure;
delta_r1=abs(r1-r0);
delta_r2=abs(r2-r0);
delta_r3=abs(r3-r0);
delta_r4=abs(r4-r0);
delta_r5=abs(r5-r0);
delta_r6=abs(r6-r0);
delta_r7=abs(r7-r0);
plot(angle,delta_r1,angle,delta_r2,angle,delta_r3,angle,delta_r4,...
     angle,delta_r5,angle,delta_r6,angle,delta_r7,'LineWidth',2);
legend('delta(r1)','delta(r2)','delta(r3)','delta(r4)','delta(r5)',...
        'delta(r6)','delta(r7)','Location','best');
xlabel('angle/deg');
ylabel('Delta Reflection');
%set(gca,'yscale','log');






