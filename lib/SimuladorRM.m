function [DataIQreshape,DatosIQ, anguloacimut] = SimuladorRM(Antena, Receptor, Reflectores)
%Funcion principal del simulador.
%Parametros de entrada:
% 1- Antena -> estructura que contiene datos de la antena
% 2- Receptor -> estructura que contiene datos del receptor
% 3- Reflectore -> estructura que tiene informacion de todos los
% reflectores a ser simulados

%Salidas:
% 1-DataIQreshape -> Matriz de dimensiones MxNrxN , donde M es el numero de muestras en acimut de un dwell, 
%   Nr es el numero de celdas de rango, N es el numero total de dwell durante
%   el varido ( grados).
% 2-DatosIQ -> Matriz de dimensiones M*N x Nr, donde M*N es el numero total
%   de puslsos transmitidos durante el tiempo de simulacion
% 3-anguloacimut -> angulo acimutal del radar

%Calculo la velocidad angular del radar.
if strcmp(Receptor.modalidad,"S")
    Antena.w = Antena.ang3dBacimut/(Receptor.M/2*(Receptor.T1 + Receptor.T2) ) ; %velovidad angular
elseif strcmp(Receptor.modalidad,"U")
    Antena.w = Antena.ang3dBacimut/(Receptor.M*Receptor.Tu) ; %velovidad angular
end


Nrango = round(Receptor.tr*Receptor.fs);
tr = Receptor.te + 1/Receptor.fs .*(1:Nrango) ;
%%%%%%%%%%%%%Simulacion%%%%%%%%%%%%%%Caso Uniforme

if strcmp(Receptor.modalidad,"U")
   celdasAcimutTotal = Receptor.Tsimulacion/Receptor.Tu;
   %%%Comienza la simulacion
   DatosIQ = single(zeros(celdasAcimutTotal,Nrango));
%    Signal_recibida = single(zeros(Reflectores.N,Nrango)); %inicializo una matriz
   tic;
   anguloacimut = zeros(1,celdasAcimutTotal);
   
   wai = waitbar(0,'Comienza la simulacion uniforme');
    for Nx = 1:celdasAcimutTotal %Nx representa cada pulso transmitido
       waitbar(Nx/celdasAcimutTotal,wai);
       anguloacimut(Nx) = Antena.angTita;
       
       
       %3er nivel de modificacion. casi todo matricial
       
       dnr = sqrt(Reflectores.positionX.^2 + Reflectores.positionY.^2 + Reflectores.positionZ.^2 ); %distancia del los reflectores respecto a la antena
       [Pot_recibida, tita, phi ]= calculaPotenciaRecibidaTodoslosreflectores(Antena, [Reflectores.positionX, Reflectores.positionY, Reflectores.positionZ], Reflectores.RCS);
       aux = tr >= 2*dnr/Receptor.c & tr <=2*dnr/Receptor.c + Receptor.T;
       Signal_recibida = sqrt(0.5*Pot_recibida.') .*PulsoRectangular(dnr, Receptor.Fc, Receptor.c, 0).*aux;
       
       %      for nr = 1:Reflectores.N %nr es cada uno de los reflectores
%                       
%             dnr = sqrt(Reflectores.positionX(nr)^2 + Reflectores.positionY(nr)^2 + Reflectores.positionZ(nr)^2 ); %distancia del reflector nr respecto a la antena
%             Pot_recibida = calculaPotenciaRecibida(Antena, [Reflectores.positionX(nr), Reflectores.positionY(nr),Reflectores.positionZ(nr)]);
%             aux = tr >= 2*dnr/c & tr <=2*dnr/c + Receptor.T;
%             Signal_recibida(nr,:) = Pot_recibida*PulsoRectangular(dnr, Receptor.Fc, c, 0)*aux;
%                      
%             
%         end
        
        DatosIQ(Nx,:) = sum(Signal_recibida);
        
        %Actualizo la posicion de la antena y la de los reflectores
        position = actualizaReflectores(Receptor.Tu,Reflectores, tita, phi); %Posicion reflectores actualizada
        Reflectores.positionX = position.x;
        Reflectores.positionY = position.y;
        Reflectores.positionZ = position.z;
        Antena.angTita = mod(Antena.angTita + Antena.w*Receptor.Tu,2*pi); % angulo acimutal de la antena actualizado        
    end
    
    close(wai);
    toc;
    
elseif  strcmp(Receptor.modalidad,"S")
   %%%Simulacion Staggered
   celdasAcimutTotal = 2*round(Receptor.Tsimulacion/(Receptor.T1 + Receptor.T2));    
   DatosIQ = single(zeros(celdasAcimutTotal,Nrango));
%    Signal_recibida = single(zeros(Reflectores.N,Nrango)); %inicializo una matriz
   tic;
   anguloacimut = zeros(1,celdasAcimutTotal);
   
   wai = waitbar(0,'Comienza la simulacion staggered');
    for Nx = 1:celdasAcimutTotal %Nx representa cada pulso transmitido
       waitbar(Nx/celdasAcimutTotal,wai);
       anguloacimut(Nx) = Antena.angTita;
       
       
       %3er nivel de modificacion. casi todo matricial
       
       dnr = sqrt(Reflectores.positionX.^2 + Reflectores.positionY.^2 + Reflectores.positionZ.^2 ); %distancia del los reflectores respecto a la antena
       [Pot_recibida, tita, phi ] = calculaPotenciaRecibidaTodoslosreflectores(Antena, [Reflectores.positionX, Reflectores.positionY, Reflectores.positionZ], Reflectores.RCS);
       aux = tr >= 2*dnr/Receptor.c & tr <=2*dnr/Receptor.c + Receptor.T;
       Signal_recibida = sqrt(0.5*Pot_recibida.') .*PulsoRectangular(dnr, Receptor.Fc, Receptor.c, 0).*aux;
       
       DatosIQ(Nx,:) = sum(Signal_recibida);
        
        %Actualizo la posicion de la antena y la de los reflectores
        if mod(Nx,2)== 1
            position = actualizaReflectores(Receptor.T1,Reflectores, tita, phi); %Posicion reflectores actualizada
            Antena.angTita = mod(Antena.angTita + Antena.w*Receptor.T1,2*pi); % angulo acimutal de la antena actualizado
        else
            position = actualizaReflectores(Receptor.T2,Reflectores, tita, phi); %Posicion reflectores actualizada
            Antena.angTita = mod(Antena.angTita + Antena.w*Receptor.T2,2*pi); % angulo acimutal de la antena actualizado
        end
        Reflectores.positionX = position.x;
        Reflectores.positionY = position.y;
        Reflectores.positionZ = position.z;
               
    end
    
    close(wai);
    toc;
    
end
%Agrego ruido blanco
noise = Antena.NoiseLevel*(randn(size(DatosIQ)) + 1i*randn(size(DatosIQ)));
DatosIQ = DatosIQ + noise;


DataIQreshape = organizaDatosIQ(DatosIQ,floor(celdasAcimutTotal/Receptor.M), Receptor.M , Nrango);


