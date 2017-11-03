%Graphical voltimeter for Arduino and MATLAB.

%Inicializamos el area y creamos un objeto arduino.
clear all;
a=arduino();

%Generamos la ventana donde aparece la representacion grafica
tmax=50;	%Duración del muestreo
figure(1),
grid on,
xlabel('Tiempo(s)'),ylabel('Voltaje(V)');
axis([0 tmax+1 0 5]); %Ejes, de 0s a tmax, y de 0 a 5V.

k=0; %Indice
v=0; %Voltaje
t=0; %tiempo

tic	%Inicio del timer
while toc <=tmax
	k=k+1;
	v(k)=readVoltage(a,'A0');	%A0 es la entrada analogica escogida
	t(k)=toc;
	%Dibujamos los datos
	if k>1
		line([t(k-1) t(k)],[v(k-1) v(k)]);
		drawnow;
	end
end