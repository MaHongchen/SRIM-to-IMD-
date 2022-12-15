 clear;clc,close all;
 
 %%
%参数设置
N_Au=5.903E22; %金的原子密度，单位atoms/cm3；
N_Cr=8.339E22; %铬的原子密度，单位atoms/cm3；
N_Si=4.977E22; %硅的原子密度，单位同上；
thickness_Au=1000; %金层的厚度，单位Ang；
thickness_Cr=50;%单位同上；
%thickness_Si;%500um;
Does=0; %辐照剂量；
FL_range=37; %RANGE.txt的数据第一行(Firsr Line)行号为37；
FL_vacancy=36; %VACANCY.txt的数据第一行(Firsr Line)行号为36；

%%
%导入RANGE.txt，并将数据分割。
inter=' ';
Range=importdata('RANGE.txt',inter,FL_range);
range=Range.data;
depth=range(:,1);
H_dis=range(:,2);
Au_dis=range(:,3);
Cr_dis=range(:,4);
Si_dis=range(:,5);

%%
%导入VACANCY.txt，并将数据分割。
inter=' ';
Vacancy=importdata('VACANCY.txt',inter,FL_vacancy);
vacancy=Vacancy.data;
Au_vac=vacancy(:,3);
Cr_vac=vacancy(:,4);
Si_vac=vacancy(:,5);
total_vac=Au_vac+Cr_vac+Si_vac;

%%
%计算质子的原子密度
N_H=zeros(100,1);
i=1;
while i<=100
    N_H(i,1)=H_dis(i,1)*Does;
    i=i+1;
end

%%
%计算空穴的原子密度
N_vac=zeros(100,1);
i=1;
while i<=100
    N_vac(i,1)=total_vac(i,1)*(10^8)*Does;
    i=i+1;
end

N_in=N_vac+N_H;
FR=zeros(100,1);
i=1;
while i<=100
    if depth(i,1)<thickness_Au
        FR(i,1)=N_in(i,1)/N_Au;
    else
        if depth(i,1)<thickness_Au+thickness_Cr
            FR(i,1)=N_in(i,1)/N_Cr;
        else
            FR(i,1)=N_in(i,1)/N_Si;
        end
    end
    i=i+1;
end

%%
%画图
figure;
p=plot(depth,FR,'LineWidth',2);
titlename=['fvac after Does=',num2str(Does)];
title(titlename);
xlabel('depth/A');
ylabel('fvac');

%%
%输出
A=[depth,FR];
filename=['FR of inclusion Does=',num2str(Does),'.txt'];
fid=fopen(filename,'w');
fprintf(fid,'%10s %10s\n','Depth/ang','FR');
fprintf(fid,'%10.6f %10.6f\n',A');
fclose(fid);
