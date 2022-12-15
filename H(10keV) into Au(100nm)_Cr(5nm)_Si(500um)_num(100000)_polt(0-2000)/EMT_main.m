clear;clc;close all;
%%
%参数设置
Energy=8.04;%keV
wavelength=12.398/Energy;%Angstron
Does=8*10^16;
[n_Au,k_Au]=Au_nk(wavelength);
[n_Cr,k_Cr]=Cr_nk(wavelength);
[n_Si,k_Si]=Si_nk(wavelength);
n_in=1;
k_in=0;
thickness_Au=1000;
thickness_Cr=50;
%%
%导入填充比
inter=' ';
inputfilename=['FR of inclusion Does=',num2str(Does),'.txt'];
FR=importdata(inputfilename,inter,1);
fr=FR.data;
depth=fr(:,1);
f=fr(:,2);

%%
%调用主函数进行计算；
% [n_eff,k_eff] = lewis(f_v,n_pigment,k_pigment,n_medium,k_medium); 函数调用格式。

i=1;
n_eff=zeros(100,1);
k_eff=zeros(100,1);
while i<=100
    if depth(i,1)<thickness_Au
        [n_eff(i,1),k_eff(i,1)]=maxwell(f(i,1),n_in,k_in,n_Au,k_Au);
    else
        if depth(i,1)<thickness_Au+thickness_Cr
            [n_eff(i,1),k_eff(i,1)]=maxwell(f(i,1),n_in,k_in,n_Cr,k_Cr);
        else
            [n_eff(i,1),k_eff(i,1)]=maxwell(f(i,1),n_in,k_in,n_Si,k_Si);
        end
    end
    i=i+1;
end

%%
%画图
figure;
p=semilogy(depth,n_Au,depth,k_Au,depth,n_Cr,depth,k_Cr,depth,n_Si,depth,k_Si,depth,n_eff,depth,k_eff,'LineWidth',2);
axis([0,2000,0.9999,1.0001]);
titlename=['Effictive n under Does=',num2str(Does)];
title(titlename);
xlabel('depth/A');
ylabel('Real Part of Index(n)');
%%
%输出
A=[depth,n_eff,k_eff];
filename=['Maxwell nk_eff under Does=',num2str(Does),'.txt'];
fid=fopen(filename,'w');
fprintf(fid,'%15s %15s %15s\n','Depth/ang','n_eff','k_eff');
fprintf(fid,'%15.13f  %15.14f  %15.14f\n',A');
fclose(fid);
