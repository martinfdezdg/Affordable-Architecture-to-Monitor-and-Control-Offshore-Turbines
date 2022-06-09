/*
  ImuSignal.cpp - Library for reading IMU signal.
*/

#include "Arduino.h"

#include "ImuSignal.h"

ImuSignal::ImuSignal() { }

/** Attaches IMU to given pin and initializes it
   @param address_pin IMU_PIN
*/
void ImuSignal::attach(int address_pin) {
  // Wire.begin(); // If this is uncommented, auxiliar display may not work
  imu.initialize();
}

/** Reads acceleration of turbine stability
   @return Point of accelerations converted
*/
Point ImuSignal::readAcceleration() {
  Point acc;
  int16_t ax, ay, az;
  imu.getAcceleration(&ax, &ay, &az);
  acc.x = ax;
  acc.y = ay;
  acc.z = az;
  Serial.println(ax);
  return acc;
}

/** Reads rotation speed of turbine stability
   @return Point of rotation speeds converted
*/
Point ImuSignal::readRotation() {
  Point rot;
  int16_t rx, ry, rz;
  imu.getRotation(&rx, &ry, &rz);
  rot.x = rx;
  rot.y = ry;
  rot.z = rz;
  return rot;
}
