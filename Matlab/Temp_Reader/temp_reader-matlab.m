%Inicializamos el area y creamos un objeto arduino.
clear all;
a=arduino();

%Generamos la tempentana donde aparece la representacion grafica
tmax=180;	%Duración del muestreo
figure(1),
grid on,
xlabel('Tiempo(s)'),ylabel('Temperatura(ºC)');
axis([0 tmax+1 15 40]); %Ejes, de 0s a tmax, y de 0 a 5temp.

k=0; %Indice
t=0; %tiempo
temp=0; %temperatura

tic	%Inicio del timer
while toc <=tmax
	k=k+1;
	temp(k)=(readVoltage(a,'A0')*100);	%Se lee el voltaje. (10mV = 1ºC)
	t(k)=toc;
	%Dibujamos los datos
	if k>1
		line([t(k-1) t(k)],[temp(k-1) temp(k)]);
		drawnow;
	end
end