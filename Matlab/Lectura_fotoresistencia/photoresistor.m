clear;
a=arduino('COM4','Uno');
fotoresistencia='A0'; %Defino el pin de lectura de la fotoresistencia
lightCal=readVoltage(a, fotoresistencia);

%Generamos la ventana donde aparece la representacion grafica
tmax=59;	%Duración del muestreo
figure(1),
grid on,
xlabel('Tiempo(s)'),ylabel('Luminosidad(Lx)');
axis([0 tmax+1 0 10000]); %Ejes, de 0s a tmax, y de 0 a 5V.

k=0; %Indice
v=0; %Voltaje
t=0; %Tiempo
lum=0;

Ro = 1000;   %Resistencia en oscuridad en K?
Rl = 15;     %Resistencia a la luz (10 Lux) en K?
Rc = 10;    %Resistencia calibracion en K?

tic	%Inicio del timer
while toc <=tmax
	k=k+1;
	v(k)=readVoltage(a, fotoresistencia);	%A0 es la entrada analogica escogida
	t(k)=toc;
    %Tengo el voltaje, quiero comvertirlo a lúmenes
    lum(k)=(v(k)*Ro*10)/(Rl*Rc*(5-v(k)));%5 es el voltaje de la fuente.
	%Dibujamos los datos
	if k>1
		line([t(k-1) t(k)],[lum(k-1) lum(k)]);
		drawnow;
	end
end