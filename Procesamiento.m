%Scrip para procesar los datos simulados, modo uniforme o staggered

clear;
addpath('/home/euler/Desktop/GIT/ASPASSyGMAP-TD/GMAP_S');
addpath('/home/euler/Desktop/GIT/ASPASSyGMAP-TD/libreria');
addpath('/home/euler/Desktop/GIT/espectralmomentestimation/StandardMethods');
addpath('/home/euler/Desktop/GIT/GMAP/');
load('simulacionS.mat')

% Receptor.modalidad = 'S'
%Calculo la velocidad angular del radar.
if strcmp(Receptor.modalidad,"S")
    Antena.w = Antena.ang3dBacimut/(Receptor.M/2*(Receptor.T1 + Receptor.T2) ) ; %velovidad angular
elseif strcmp(Receptor.modalidad,"U")
    Antena.w = Antena.ang3dBacimut/(Receptor.M*Receptor.Tu) ; %velovidad angular
end

sigma_c = Antena.w * Antena.lambda * sqrt(log(2))/(2*pi*Antena.ang3dBacimut); % m/s
sigma_c_f = sigma_c * 2/Antena.lambda;


if strcmp(Receptor.modalidad,"U")

%%Procesamiento uniforme
va = Antena.lambda/4/Receptor.Tu;
vindex = linspace(-va,va,Receptor.M);
% [PGMAP(j,i),vmGMAP(j,i),sigmaGMAP(j,i), CSR_EstimadoGMAP(j,i)] = GMAP(DataIQreshape(:,3200,90).',1/Receptor.Tu,Antena.lambda, sigma_c_f,0,0, 'Blackman');
 wai = waitbar(0,'Comienza el procesamiento doppler uniforme');
for i=1:size(DataIQreshape,3)
   waitbar(i/size(DataIQreshape,3),wai);
    for j=1:size(DataIQreshape,2)
        Ry = DataIQreshape(:,j,i) * DataIQreshape(:,j,i)'; 
        [P(j,i),vm(j,i),sigma(j,i)] = PPPuniforme(Ry,0,1/Receptor.Tu,Antena.lambda);
%         if j==3500 && i ==63
%             
%         end
        
        [PGMAP(j,i),vmGMAP(j,i),sigmaGMAP(j,i), CSR_EstimadoGMAP(j,i)] = GMAP(DataIQreshape(:,j,i).',1/Receptor.Tu,Antena.lambda, sigma_c_f,0,0, 'Blackman');
   end
end
close(wai);

va = Antena.lambda/4/Receptor.Tu;
Rref = (r_v(end))/1000;
angulo_A = anguloacimut(1:Receptor.M:end);
angulo_A = angulo_A(1:size(DataIQreshape,3));
ppi_plot(vm,r_v,angulo_A*180/pi,'vel',va);
axis([-Rref Rref -Rref Rref]);xlabel('[km]');ylabel('[km]');
title('velocidad fenomeno sin filtrar clutter');

Reflectividad = 10*log10(P) + 20*log10(repmat(r_v.',[1,size(P,2)])) +90;
ppi_plot(Reflectividad,r_v,angulo_A*180/pi,'ref');
axis([-Rref Rref -Rref Rref]);xlabel('[km]');ylabel('[km]');
title('Reflectividad antes de filtrar');

ppi_plot(sigma,r_v,angulo_A*180/pi,'wid',8);
axis([-Rref Rref -Rref Rref]);xlabel('[km]');ylabel('[km]');
title('ancho espectral fenomeno sin filtrar clutter');

%GMAP plots

ReflectividadGMAP = 10*log10(real(PGMAP)) + 20*log10(repmat(r_v.',[1,size(PGMAP,2)])) +90;
ppi_plot(ReflectividadGMAP,r_v,angulo_A*180/pi,'ref');
axis([-Rref Rref -Rref Rref]);xlabel('[km]');ylabel('[km]');
title('Reflectividad GMAP');

ppi_plot(vmGMAP,r_v,angulo_A*180/pi,'vel',va);
axis([-Rref Rref -Rref Rref]);xlabel('[km]');ylabel('[km]');
title('velocidad fenomeno GMAP');


ppi_plot(sigmaGMAP,r_v,angulo_A*180/pi,'wid',8);
axis([-Rref Rref -Rref Rref]);xlabel('[km]');ylabel('[km]');
title('ancho espectral fenomeno GMAP');


elseif strcmp(Receptor.modalidad,"S")
  %Procesamiento staggered  
intStagg = [2 3];
% Receptor.M = 64; %%%Borrar esto despues
numSampUnif = round((Receptor.M - 1)*sum(intStagg)/numel(intStagg)) + 1;
% indices de las muestras cada Tu
indSampUnif = 0:(numSampUnif - 1);

% indices de las muestras no uniformes
indSampNonUnif = cumsum([1 repmat(intStagg,1,round(Receptor.M/numel(intStagg)))]);  
indSampNonUnif = indSampNonUnif(1:Receptor.M);  
    
va = Antena.lambda/4/(Receptor.T2-Receptor.T1);
vindex = linspace(-va,va,64);
% [SpE(j,i), vpE(j,i), sigmapE(j,i), NL(j,i), salida(j,i)] = ASPASS1(DataIQreshape(:,3372,63).',Antena.lambda,Receptor.T1, Receptor.T2,sigma_c_f,numSampUnif,indSampNonUnif,[2 3], 'kaiser',8);
 wai = waitbar(0,'Comienza el procesamiento doppler staggered');
 
for i=1:size(DataIQreshape,3)
   waitbar(i/size(DataIQreshape,3),wai);
    for j=1:size(DataIQreshape,2)
        Ry = DataIQreshape(:,j,i) * DataIQreshape(:,j,i)'; 
        
%         if j==3600 && i ==62
%             
%         end
        
        [P(j,i),vm(j,i),sigma(j,i)] = PPPStaggered(Ry,0,Receptor.T1, Receptor.T2 ,Antena.lambda);
        [SpE(j,i), vpE(j,i), sigmapE(j,i), NL(j,i), salida(j,i), CNR(i,j), Nclutter(i,j)] = ASPASS1(DataIQreshape(:,j,i).',Antena.lambda,Receptor.T1, Receptor.T2,sigma_c_f,numSampUnif,indSampNonUnif,[2 3], 'kaiser',8);
    end
end
close(wai);

Rref = (r_v(end))/1000;
angulo_A = anguloacimut(1:Receptor.M:end);
angulo_A = angulo_A(1:size(DataIQreshape,3));
%Antes de filtrar

ReflectividadS = 10*log10(P) + 20*log10(repmat(r_v.',[1,size(P,2)])) +90;
ppi_plot(ReflectividadS,r_v,angulo_A*180/pi,'ref');
axis([-Rref Rref -Rref Rref]);xlabel('[km]');ylabel('[km]');
title('Reflectividad ');

ppi_plot(vm,r_v,angulo_A*180/pi,'vel',va);
axis([-Rref Rref -Rref Rref]);xlabel('[km]');ylabel('[km]');
title('velocidad fenomeno PPP-S');

ppi_plot(sigma,r_v,angulo_A*180/pi,'wid',8);
axis([-Rref Rref -Rref Rref]);xlabel('[km]');ylabel('[km]');
title('ancho espectral fenomeno PPP-S');


%Despues de filtrar

ReflectividadSGMAP_S = 10*log10(abs(SpE)) + 20*log10(repmat(r_v.',[1,size(SpE,2)])) +90;
ppi_plot(ReflectividadSGMAP_S,r_v,angulo_A*180/pi,'ref');
axis([-Rref Rref -Rref Rref]);xlabel('[km]');ylabel('[km]');
title('Reflectividad fenomeno GMAP-S');

ppi_plot(vpE,r_v,angulo_A*180/pi,'vel',va);
axis([-Rref Rref -Rref Rref]);xlabel('[km]');ylabel('[km]');
title('velocidad fenomeno GMAP-S');

ppi_plot(sigmapE,r_v,angulo_A*180/pi,'wid',8);
axis([-Rref Rref -Rref Rref]);xlabel('[km]');ylabel('[km]');
title('ancho espectral fenomeno GMAP-S');
end


% if strcmp(Receptor.modalidad,"U")
%     w = blackman(Receptor.M);
% %     w = ones(Receptor.M,1);
%     xdata = DataIQreshape(:,1500,64).*w;
% %     xdata = DataIQreshape(:,2200,112);
%     DEP = estimaDEP(xdata.', 1/Receptor.Tu,w);
%     figure; plot(10*log10(fftshift(DEP)));
% elseif strcmp(Receptor.modalidad,"S")
%     graficaDEPstaggered(DataIQreshape(:,1700,64).',Receptor.T1, Receptor.T2, numSampUnif, indSampNonUnif, 'kaiser', 8);
% end


