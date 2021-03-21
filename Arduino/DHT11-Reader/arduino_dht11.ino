#include "DHT11.h"

int pin=7;      //pin al que va conectado la salida del sensor.
DHT11 dht11(pin); 
void setup(){
  Serial.begin(9600);
  while (!Serial) {
      ; //Espera a conectar el puerto serie.
  }
}


void loop(){
  int err;
  float temp, hum;
  
  if((err=dht11.read(hum, temp))==0){
    //imprime temperatura
    Serial.print(temp);

    //Imprime humedad
    Serial.print(hum);
    Serial.println();
  }else{
    Serial.println();
    Serial.print("Error: ");
    Serial.print(err);
    Serial.println();    
  }
  delay(DHT11_RETRY_DELAY); //Retardo para volver a leer.
}
