function ReflectoresTotal = UneReflectores(Reflectores)

dim = length(Reflectores);

ReflectoresTotal = struct;
ReflectoresTotal.N = 0; 
ReflectoresTotal.RCS = [] ;


ReflectoresTotal.positionX =[];
ReflectoresTotal.positionY = [];
ReflectoresTotal.positionZ = [];
ReflectoresTotal.deltaVelocidad = [];
ReflectoresTotal.velocidad = [] ;


for i=1:dim
    ReflectoresTotal.N = ReflectoresTotal.N + Reflectores(i).N ;
    ReflectoresTotal.positionX =[ReflectoresTotal.positionX ; Reflectores(i).positionX ];
    ReflectoresTotal.positionY = [ReflectoresTotal.positionY ; Reflectores(i).positionY];
    ReflectoresTotal.positionZ = [ReflectoresTotal.positionZ ; Reflectores(i).positionZ];
    ReflectoresTotal.deltaVelocidad = [ReflectoresTotal.deltaVelocidad ; Reflectores(i).deltaVelocidad ];
    ReflectoresTotal.velocidad = [ReflectoresTotal.velocidad ; Reflectores(i).velocidad ] ;
    ReflectoresTotal.RCS = [ReflectoresTotal.RCS ; ones(Reflectores(i).N,1)*Reflectores(i).RCS ];
end