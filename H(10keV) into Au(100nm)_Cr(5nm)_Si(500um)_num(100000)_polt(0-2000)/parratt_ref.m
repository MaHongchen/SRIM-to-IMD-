function [RR] = parratt_ref(Q,wavelength,optdelta,beta,thickness,sigma,polarization)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculate the reflectivity as function of incidence angle      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if length(lambda) == 1
    % Q: wavevector transfer   [1*n]                     1/Angs   
    % lambda: wavelength of radiation    [1*1]           Angs
    % delta: refractive index for each layer [n*1]
    % beta: attentuation index for each layer [n*1]
    % s wave: polarization = 1; p wave: polarization = -1; unpolarized light: polarization = 0
    NLayers=length(optdelta); % 
    NAngles = length(Q);
    Q=reshape(Q,1,NAngles);
    indexTemp = find(Q==0);
    if ~isempty(indexTemp)
        Q(indexTemp)=1e-30;
    end
    incidentAngle = pi/2 - asin(Q./(2*pi/wavelength));

    optdelta = reshape(optdelta, NLayers,1);
    beta = reshape(beta, NLayers,1);
    thickness = reshape(thickness, NLayers, 1);
    sigma = reshape(sigma, NLayers-1, 1);
    nn = 1 - optdelta - 1i.*beta; % revised on 2011-4-1

    rpp = NaN(NLayers-1,NAngles);
    rss = NaN(NLayers-1,NAngles);
    tpp = NaN(NLayers-1,NAngles);
    tss = NaN(NLayers-1,NAngles);
%     sinnn = NaN(NLayers,NAngles);
    cosnn = NaN(NLayers,NAngles);
    deltaK = NaN(NLayers-2,NAngles);
    cosnn=sqrt(1-(1./nn*sin(incidentAngle)).^2);
    indexTemp = find(cosnn==0);
    if ~isempty(indexTemp)
        cosnn(indexTemp)=1e-30;
    end

for kk=1:NLayers % dletaK 是光在每一层介质（不包括空气和基板）的二分之一位相变化
   deltaK(kk,:)=2.0*pi*nn(kk)*thickness(kk)*cosnn(kk,:)/wavelength;         %算δk
end

for kk=1:NLayers-1
    tmp1 = nn(kk)./cosnn(kk,:);
    tmp2 = nn(kk+1)./cosnn(kk+1,:);
    tmp3 = nn(kk).*cosnn(kk,:);
    tmp4 = nn(kk+1).*cosnn(kk+1,:);
    tmp5 = exp(-2*(2*pi*sigma(kk)/wavelength).^2.*cosnn(kk,:).*cosnn(kk+1,:));
%     tmp6 = exp(0.5*(2*pi*sigma(kk)/wavelength)^2.*(cosnn(kk,:)-cosnn(kk+1,:)).^2);
    tmp6 = 1;
    rpp(kk,:)=(tmp1-tmp2)./(tmp1+tmp2).*tmp5;    %算rk（对p光）
    rss(kk,:)=(tmp3-tmp4)./(tmp3+tmp4).*tmp5;     %算rk（对s光）
    tpp(kk,:)=2.0.*tmp3./(nn(kk).*cosnn(kk+1,:)+nn(kk+1).*cosnn(kk,:)).*tmp6;    %算rk（对p光）!加粗糙度因子
    tss(kk,:)=2.0.*tmp3./(tmp3+tmp4).*tmp6;     %算rk（对s光）!加粗糙度因子
      
end
%**************上面把δk，rk都算好了，最后用菲涅耳公式从最后一层递推到第一层即可。*********
for jj = NLayers-2:-1:1
%     tmp = exp((2.0).*i.*deltaK(jj+1,:));
%     rpp(jj,:)=(rpp(jj,:)+rpp(jj+1,:).*tmp)./(1+rpp(jj,:).*rpp(jj+1,:).*tmp);
%     rss(jj,:)=(rss(jj,:)+rss(jj+1,:).*tmp)./(1+rss(jj,:).*rss(jj+1,:).*tmp);
    
    tmp1 = exp(-(2.0).*1i.*deltaK(jj+1,:)); % revised on 2011-4-1
    tmp2 = exp(-1i.*deltaK(jj+1,:)); % revised on 2011-4-1
    rpp(jj,:)=(rpp(jj,:)+rpp(jj+1,:).*tmp1)./(1+rpp(jj,:).*rpp(jj+1,:).*tmp1);
    rss(jj,:)=(rss(jj,:)+rss(jj+1,:).*tmp1)./(1+rss(jj,:).*rss(jj+1,:).*tmp1);
    tpp(jj,:)=(tpp(jj,:).*tpp(jj+1,:).*tmp2)./(1+rpp(jj,:).*rpp(jj+1,:).*tmp1);
    tss(jj,:)=(tss(jj,:).*tss(jj+1,:).*tmp2)./(1+rss(jj,:).*rss(jj+1,:).*tmp1);
end   
Rp=abs(rpp(1,:)).^2;
Rs=abs(rss(1,:)).^2; 
RR=(Rs*(1+polarization) + Rp*(1-polarization))/2;
    


