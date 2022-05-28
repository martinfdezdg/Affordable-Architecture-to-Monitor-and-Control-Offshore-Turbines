// imu-servo-thingspeak

#include "I2Cdev.h"
#include "MPU6050.h"
#include "Wire.h"
#include <Servo.h>

#include "ThingSpeak.h"

#include <ESP8266WiFi.h>
#include <LittleFS.h>
#include <WiFiSettings.h>

#include "credentials.h"
#include "ui.h"


// Credenciales de Thingspeak
unsigned long myChannelNumber = SECRET_CH_ID;
const char* myWriteAPIKey = SECRET_WRITE_APIKEY;


WiFiClient  client;

const int mpuAddress = 0x68;

MPU6050 mpu(mpuAddress);
Servo servo;


int16_t ax, ay, az;
int16_t gx, gy, gz;

int rotacion = 0;

unsigned long tiempo1;
unsigned long tiempo2;


void setup() {
  Serial.begin(115200);
  delay(100);

  LittleFS.begin();
  WiFiSettings.connect();

  ThingSpeak.begin(client);

  Wire.begin();

  mpu.initialize();
  servo.attach(0, 544, 2400);

  tiempo1 = millis();
}

void loop() {
  // Leer las aceleraciones y velocidades angulares
  mpu.getAcceleration(&ax, &ay, &az);
  mpu.getRotation(&gx, &gy, &gz);

  // Mostrar datos en el monitor
  printRAW(ax, ay, az, gx, gy, gz);

  // Mapear la rotacion sobre el intervalo (0,180)
  rotacion = map(ay * accScale, -9.81, 9.81, 0, 180);
  servo.write(rotacion);

  tiempo2 = millis();
  if (tiempo2 > tiempo1 + 16000) {
    tiempo1 = millis();
    Serial.println("Inicial: " + millis());

    // Escribir valores en los campos 1-6 de un canal de ThingSpeak
    ThingSpeak.setField(1, ax);
    ThingSpeak.setField(2, ay);
    ThingSpeak.setField(3, az);
    ThingSpeak.setField(4, gx);
    ThingSpeak.setField(5, gy);
    ThingSpeak.setField(6, gz);

    int httpCode = ThingSpeak.writeFields(myChannelNumber, myWriteAPIKey);

    if (httpCode == 200) {
      Serial.println("CORRECTO: Escrito en el canal");
    }
    else {
      Serial.println("ERROR: Imposible escribir en el canal (HTTP error " + String(httpCode) + ")");
    }
  }
}
