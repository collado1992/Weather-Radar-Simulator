%test del simulador

clear;
%%%%%%%%%%%%%%%%%%%%%Datos para simular%%%%%%%%%%%%%%%%%%%%%%%
addpath('lib/');

%Receptor%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Receptor.Tsimulacion = 5; %[s]
Receptor.tr = 100e-6 ; % tamano de la ventana de recepcion
Receptor.T = 5e-6 ; % tamano del pulso transmitido 
Receptor.c = 3e8; % velocidad de la luz en el vacio
Receptor.te = 2*1000/(3e8); %tiempo de inicio de laventana de recepcion
Receptor.Tu = 0.5e-3; % [s] tiempo de repeticion de pulso para el caso uniforme
Receptor.T1 = 0.8e-3 ; %[s] para el caso staggered
Receptor.T2 = 1.2e-3; %[s] para el caso staggered 3T1 = 2T2
Receptor.fs = 50e6; %frecuencia de muestreo
Receptor.Fc = 5.6e9 ; % [Hz] frecuencia portadora
Receptor.M = 64; %Numero de muestras en acimut dentro de los 3dB de la antena
Receptor.modalidad = "S"; %S de staggered, U de uniforme
%Antena%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Antena.x = 0;
Antena.y = 0;
Antena.z = 0;
Antena.ang3dBacimut = 1/180*pi; % angulo 3 dB en acimut de la antena
Antena.angElevacion = 84.4*pi/180 ; %angulo de elevacion [radianes] eje esferico
Antena.angTita = 0 ; % angulo en el plano x-y
Antena.Pt = 30000000 ; %potencia transmitida
Antena.D = 2.6; %diametro [m]
Antena.lambda = Receptor.c/Receptor.Fc;
Antena.ganancia = 1;
Antena.NoiseLevel = 10^-8 ;


%%%%%%%%Creo los reflectores%%%%%%%%%%%%%%
rng('default');
rng(1);
% Reflectores1 = reflectores(2000,160000,[-5000,10000,1100], 1000,0,0); %%Aproximo a una nuve con distribucion gaussiana en la velocidad, para la DEP
Reflectores2 = reflectores(1000,100000,[5000,10000,1100], 700,0,0);
Reflectores3 = reflectores(800,1000,[5000,10000,1100], 2000,-40,3);
Reflectores4 = reflectores(800,1000,[0,10000,1100], 1000,35,2);
% Reflectores5 = reflectores(2000,1000,[-5000,10000,1100], 1500,-10,4);

% figure; scatter3(Reflectores2.positionX, Reflectores2.positionY, Reflectores2.positionZ);
%Uno todos los reflectores
 Reflectores = UneReflectores([Reflectores2, Reflectores3, Reflectores4 ]); 
% Reflectores = UneReflectores(Reflectores1 ); 
clear Reflectores1 Reflectores2 Reflectores3 Reflectores4  ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%comienza la simulacion
[DataIQreshape, DatosIQ,anguloacimut] = SimuladorRM(Antena, Receptor, Reflectores);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%salvamos el archivo%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Nrango = round(Receptor.tr*Receptor.fs);
tr = Receptor.te + 1/Receptor.fs .*(1:Nrango) ;
r_v = tr*Receptor.c/2; %discretizacion del rango de la ventana (una sola ventana)

%salvamos todo en el archivo simulacion.mat

if Receptor.modalidad == "S"
    save('simulacionS.mat')
elseif Receptor.modalidad == "U"
    PRF = 1/Receptor.Tu;
    save('simulacionU.mat')
end

disp('termino la simulacion');
