%Eliminar puerto anterior
clear all;
delete(instrfind({'Port'},{'COM4'}));
%Crear una conexion serie
s = serial('COM4','BaudRate',9600);
warning('off','MATLAB:serial:fscanf:unsuccessfulRead');
%Abrir el puerto
fopen(s);

%Generamos la tempentana donde aparece la representacion grafica
tmax=50;	%Duración del muestreo
figure(1),
grid on,
xlabel('Tiempo(s)'),ylabel('Temperatura(ºC)');
axis([0 tmax+1 15 40]); %Ejes, de 0s a tmax, y de 0 a 5temp.

k=0; %Indice
temp=0; %tempoltaje
t=0; %tiempo

tic	%Inicio del timer
while toc <=tmax
	k=k+1;
	temp(k)=fscanf(s,'%f.%f')';	%El codigo C imprime por consola. Yo lo leo.
	t(k)=toc;
	%Dibujamos los datos
	if k>1
		line([t(k-1) t(k)],[temp(k-1) temp(k)]);
		drawnow;
	end
end