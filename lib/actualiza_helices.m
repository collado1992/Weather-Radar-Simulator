function posiciones = actualiza_helices(T, molinos)

N = length(molinos) %cantidad de molinos

for i=1:N
    %helice1
   molinos(i).helice1.tita = molinos(i).helice1.tita + molinos(i).helice1.vel_ang*T; 
   molinos(i).helice1.x = molinos[i].helice1.x
   molinos(i).helice1.y = molinos[i].helice1.y + cos(pi/180*molinos[i].helice1.tita).*molinos[i].r;
   molinos(i).helice1.z = molinos[i].helice1.z + sin(pi/180*molinos[i].helice1.tita).*molinos[i].r;
   
   %helice2
   molinos(i).helice2.tita = molinos(i).helice2.tita + molinos(i).helice2.vel_ang*T; 
   molinos(i).helice2.x = molinos[i].helice2.x
   molinos(i).helice2.y = molinos[i].helice2.y + cos(pi/180*molinos[i].helice2.tita).*molinos[i].r;
   molinos(i).helice2.z = molinos[i].helice2.z + sin(pi/180*molinos[i].helice2.tita).*molinos[i].r;
   
   %helice3
   molinos(i).helice3.tita = molinos(i).helice3.tita + molinos(i).helice3.vel_ang*T; 
   molinos(i).helice3.x = molinos[i].helice3.x
   molinos(i).helice3.y = molinos[i].helice3.y + cos(pi/180*molinos[i].helice3.tita).*molinos[i].r;
   molinos(i).helice3.z = molinos[i].helice3.z + sin(pi/180*molinos[i].helice3.tita).*molinos[i].r;
   
end

