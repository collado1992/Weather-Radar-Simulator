%estudi del patron de antena

tita = linspace(0,2*pi,10000);
phi = linspace(0,pi,length(tita));
Etita = sin(pi*(Antena.D/Antena.lambda).*sin(tita))./(pi*(Antena.D/Antena.lambda).*sin(tita));
Ephi = sin(pi*(Antena.D/Antena.lambda).*sin(phi))./(pi*(Antena.D/Antena.lambda).*sin(phi));


figure; plot(tita,10*log10(abs(Etita).^2));
figure; plot(phi,10*log10(abs(Ephi).^2));