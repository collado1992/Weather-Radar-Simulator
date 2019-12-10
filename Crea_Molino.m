function molino = Crea_Molino(X,Y,Z, altura_mastil, helice_tamano, Nr, RCS,vel_ang)

molino = struct;

helice1 = struct;

helice1.Nr = Nr;
helice1.tita = 0;
helice1.RCS = RCS;

r1 = linspace(0.1,helice_tamano,Nr);
helice1.x = X + 0;
helice1.y = Y + r1.* cos(helice1.tita);
helice1.z = Z + r1.* sin(helice1.tita);
helice1.vel_ang = vel_ang;

molino.r = r1;


helice2 = struct;

helice2.Nr = Nr;
helice2.tita = 120;
helice2.RCS = RCS;

r2 = linspace(0.1,helice_tamano,Nr);
helice2.x = X + 0;
helice2.y = Y + r2.* cos(helice2.tita);
helice2.z = Z + r2.* sin(helice2.tita);
helice2.vel_ang = vel_ang;


helice3 = struct;

helice3.Nr = Nr;
helice3.tita = 240;
helice3.RCS = RCS;

r3 = linspace(0.1,helice_tamano,Nr);
helice3.x = X + 0;
helice3.y = Y + r3.* cos(helice3.tita);
helice3.z = Z + r3.* sin(helice3.tita);
helice3.vel_ang = vel_ang;

molino.helice1 = helice1;
molino.helice2 = helice2;
molino.helice3 = helice3;


