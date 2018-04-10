s = serial('COM4');
time=100;
i=1;
while(i<time)

    fopen(s)
    fprintf(s, 'Datos serie')
    out = fscanf(s)

    Temp(i)=str2double(out(1:5));
    subplot(211);
    plot(Temp,'g');
    axis([0,time,20,50]);
    title('Gráfico de Temperatura');
    xlabel('---> Tiempo x*0.02 segundos');
    ylabel('---> Temperatura en ºC');
    grid


    Humi(i)=str2double(out(6:10));
    subplot(212);
    plot(Humi,'m');
    axis([0,time,25,100]);
    title('Gráfico de Humedad');
    xlabel('---> Tiempo x*0.02 segundos');
    ylabel('---> % de Humedad ');
    grid

    fclose(s)
    i=i+1;
    drawnow;
end
delete(s)
clear s

