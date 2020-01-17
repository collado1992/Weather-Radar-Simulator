 function posiciones = actualizaReflectores(T, Reflectores, tita, phi)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 05/06/2019
tita = tita(:);
phi = phi(:);
% deltaVelocidad = randn(Reflectores.N,1).*Reflectores.deltaVelocidad;
%Mejorar esta funcion para que haga lo que realmente quiero
% posiciones.x = Reflectores.positionX + (Reflectores.velocidad + deltaVelocidad ) .*sin(phi).*cos(tita)*T ;
% posiciones.y = Reflectores.positionY + (Reflectores.velocidad + deltaVelocidad ) .*sin(phi).*sin(tita)*T ;
% posiciones.z = Reflectores.positionZ + (Reflectores.velocidad + deltaVelocidad ) .*cos(tita)*T  ;

posiciones.x = Reflectores.positionX + (Reflectores.velocidad  ) .*sin(phi).*cos(tita)*T ;
posiciones.y = Reflectores.positionY + (Reflectores.velocidad  ) .*sin(phi).*sin(tita)*T ;
posiciones.z = Reflectores.positionZ + (Reflectores.velocidad  ) .*cos(tita)*T  ;