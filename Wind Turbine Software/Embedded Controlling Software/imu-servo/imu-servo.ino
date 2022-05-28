// imu-servo

#include "I2Cdev.h"
#include "MPU6050.h"
#include "Wire.h"
#include <Servo.h>

#include "ui.h"

const int mpuAddress = 0x68;  // Pines SCL-D1 SDA-D2

MPU6050 mpu(mpuAddress);
Servo servo;


int16_t ax, ay, az;
int16_t gx, gy, gz;

int rotacion = 0;


void setup() {
  Serial.begin(115200);

  Wire.begin();

  // Inicializacion de los perifericos
  mpu.initialize();
  servo.attach(0, 544, 2400); // Pin D3
}

void loop() {
  // Leer las aceleraciones y velocidades angulares
  mpu.getAcceleration(&ax, &ay, &az);
  mpu.getRotation(&gx, &gy, &gz);

  // Mostrar datos en el monitor
  printSI(ax, ay, az, gx, gy, gz);

  // Mapear la rotacion sobre el intervalo (0,180)
  rotacion = map(ay * accScale, -9.81, 9.81, 0, 180);
  servo.write(rotacion);
}
