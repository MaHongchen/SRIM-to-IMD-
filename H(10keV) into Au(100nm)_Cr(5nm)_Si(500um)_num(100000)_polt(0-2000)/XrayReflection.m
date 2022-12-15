clc
close all
clear

%%Parameter Setting?
angleParam = 0:0.001:4; % unit is degree, for example [0,1,2]
radParam=angleParam/180*pi; % unit is rad
depth_inSub = 50; % A the depth inside the substrate
wavelength = 1.542; % unit is A
Does=8*10^16; %unit is (atoms/cm2)
n_Si=0.99999243;
k_Si=1.7235086e-07;
Thickness_UpAir=500; %unit is A;
Thickness_DownSi=4000000; %unit is A;

%%Input layer nk
inter=' ';
filename=['maxwell nk_eff under Does=',num2str(Does),'.txt'];
FL=1; %Line number of FirstLine Date
NK=importdata(filename,inter,FL);
nk=NK.data;
depth=nk(:,1);
Thickness=ones(length(depth),1)*20; %Thickness Matrix
n=nk(:,2); %Real Part of Index of Layers;
k=nk(:,3); %Imaginary Part of Index of Layers;

layer=[Thickness_UpAir;Thickness;Thickness_DownSi]; %With Air and Sub;
n_UpDown=[1;n;n_Si]; 
k_UpDown=[0;k;k_Si];

%%
XrayWavelength=wavelength;
k_PartI=2*pi./XrayWavelength;
Q_Parm =k_PartI*sin(radParam);

roughness_layers = zeros(1,length(n_UpDown)); %  unit is A; interface roughness
roughness_layers(1) = 0;
roughness_layers(end) = 0;
polarization=0; % s wave: polarization = 1; p wave: polarization = -1; unpolarized light: polarization = 0

delta_layers = 1-n_UpDown;
beta_layers = k_UpDown;
thickness_layers = layer;%unit is A
NLayers=length(delta_layers);

RR = NaN(1,length(Q_Parm));
for ii=1:length(Q_Parm)
RR(1,ii) = parratt_ref(Q_Parm(ii),XrayWavelength,delta_layers,beta_layers,thickness_layers,roughness_layers(2:end), polarization);
end

figure
plot(angleParam, RR,'LineWidth',1);
set(gca,'yscale','log');
titlename=['Reflection under Does=',num2str(Does)];
title(titlename);
xlabel('ang/deg');
ylabel('Reflection');

data = [angleParam' RR'];

%%Output data
Outputfilename=['maxwell Reflection under Does=',num2str(Does),'.txt'];
fid=fopen(Outputfilename,'w');
fprintf(fid,'%15s %15s\n','Angular/deg','Reflction');
fprintf(fid,'%15.14f  %15.14f\n',data');
fclose(fid);


return
%%%%%%%%%%%%%%%%%%%%%%






















