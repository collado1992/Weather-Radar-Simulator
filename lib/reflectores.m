function P = reflectores(N,RCS,mainPosition,radius, meanVelocity, sigmaVelocity)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Funcion que genera un conjunto de N reflectores puntuales cada uno con la
%radar cross section (RCS). La idea es crear estructuras de muchos
%reflectores, en este caso esfericos de radio radius donde el centro del cumulo estara en
%mainPosition y sobre la esfera se posicionaran reflectores, cada uno con
%una velocidad media meanVelocity + deltaVelocity , la cual tendra una
%distribucion Gaussiana (para simular una nube por ejemplo).:

%mainPosition es un vector con [x,y,z].
%Autor: ACR 4/06/2019

%creo un vector de angulos tita y angulos phi (tita, angulo en el sistema esferico ente eje x  y eje y, phi angulo entre eje z y r)
tita = 2*pi*rand(N,1);
phi = pi*rand(N,1);
%defino la estructura de los reflectores
P = struct;
P.N = N; 
P.RCS = RCS;

x = mainPosition(1) + rand(N,1).*radius.*sin(phi).*cos(tita);
y = mainPosition(2) + rand(N,1).*radius.*sin(phi).*sin(tita);
z = mainPosition(3) + rand(N,1).*radius.*cos(phi);

P.positionX = x;
P.positionY = y;
P.positionZ = z;
% P.deltaVelocidad = ones(N,1)*sigmaVelocity;
% P.velocidad = ones(N,1).*meanVelocity;% + P.deltaVelocidad ;
P.deltaVelocidad = randn(N,1)*sigmaVelocity;
P.velocidad = ones(N,1).*meanVelocity + P.deltaVelocidad ;


