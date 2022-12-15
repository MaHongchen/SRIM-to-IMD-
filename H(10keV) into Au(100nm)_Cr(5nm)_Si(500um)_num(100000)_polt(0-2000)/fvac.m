 clear;clc,close all;
 
 %%
%��������
N_Au=5.903E22; %���ԭ���ܶȣ���λatoms/cm3��
N_Cr=8.339E22; %����ԭ���ܶȣ���λatoms/cm3��
N_Si=4.977E22; %���ԭ���ܶȣ���λͬ�ϣ�
thickness_Au=1000; %���ĺ�ȣ���λAng��
thickness_Cr=50;%��λͬ�ϣ�
%thickness_Si;%500um;
Does=0; %���ռ�����
FL_range=37; %RANGE.txt�����ݵ�һ��(Firsr Line)�к�Ϊ37��
FL_vacancy=36; %VACANCY.txt�����ݵ�һ��(Firsr Line)�к�Ϊ36��

%%
%����RANGE.txt���������ݷָ
inter=' ';
Range=importdata('RANGE.txt',inter,FL_range);
range=Range.data;
depth=range(:,1);
H_dis=range(:,2);
Au_dis=range(:,3);
Cr_dis=range(:,4);
Si_dis=range(:,5);

%%
%����VACANCY.txt���������ݷָ
inter=' ';
Vacancy=importdata('VACANCY.txt',inter,FL_vacancy);
vacancy=Vacancy.data;
Au_vac=vacancy(:,3);
Cr_vac=vacancy(:,4);
Si_vac=vacancy(:,5);
total_vac=Au_vac+Cr_vac+Si_vac;

%%
%�������ӵ�ԭ���ܶ�
N_H=zeros(100,1);
i=1;
while i<=100
    N_H(i,1)=H_dis(i,1)*Does;
    i=i+1;
end

%%
%�����Ѩ��ԭ���ܶ�
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
%��ͼ
figure;
p=plot(depth,FR,'LineWidth',2);
titlename=['fvac after Does=',num2str(Does)];
title(titlename);
xlabel('depth/A');
ylabel('fvac');

%%
%���
A=[depth,FR];
filename=['FR of inclusion Does=',num2str(Does),'.txt'];
fid=fopen(filename,'w');
fprintf(fid,'%10s %10s\n','Depth/ang','FR');
fprintf(fid,'%10.6f %10.6f\n',A');
fclose(fid);
