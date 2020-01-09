function [Pot, tita, phi ] = calculaPotenciaRecibidaTodoslosreflectores(Antena, posiciones_reflectores, RCS)

X = posiciones_reflectores(:,1);
Y = posiciones_reflectores(:,2);
Z = posiciones_reflectores(:,3);

%%%Convierto a sistema esferico

R= sqrt(X.^2 + Y.^2 + Z.^2);
R = R.';
for nx=1:length(X)
    if Z(nx)>0
        phi(nx) = atan(sqrt(X(nx)^2+Y(nx)^2)/Z(nx));
    elseif Z(nx)<0
        phi(nx) = pi + atan(sqrt(X(nx)^2+Y(nx)^2)/Z(nx));
    else
        phi(nx) = pi/2;
    end
    
    if X(nx)>0 && Y(nx)>0
        tita(nx) = atan(Y(nx)/X(nx));
    elseif X(nx)>0 && Y(nx)<0
        tita(nx) = 2*pi + atan(Y(nx)/X(nx));
    elseif X(nx)==0
        tita(nx) = pi/2 * sign(Y(nx));
    elseif X(nx)<0
        tita(nx) = pi + atan(Y(nx)/X(nx));
    end
    
end
    
    delta_tita = min(abs(Antena.angTita-tita), 2*pi-abs(Antena.angTita-tita) );
    delta_phi =  abs(Antena.angElevacion - phi);
    
    aux = delta_tita < 4*pi/180 & delta_phi< 4*pi/180; 
    
        
    Etita = sin(pi*(Antena.D/Antena.lambda).*sin(delta_tita))./(pi*(Antena.D/Antena.lambda).*sin(delta_tita)).*aux ;
    Ephi = sin(pi*(Antena.D/Antena.lambda).*sin(delta_phi))./(pi*(Antena.D/Antena.lambda).*sin(delta_phi)).*aux ;
    
        
    
    

%Potencia recibida por la antena proveniente del reflector
%faltan varias constantes

cte = Antena.Pt*Antena.ganancia^2*Antena.lambda^2/(64*pi^3)*RCS.';

Pot = cte.*Etita.^4.*Ephi.^4./ R.^4 ;