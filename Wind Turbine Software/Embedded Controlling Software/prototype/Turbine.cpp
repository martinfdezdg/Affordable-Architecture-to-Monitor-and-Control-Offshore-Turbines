/*
  Turbine.cpp - Library for running every turbine control operations.
*/

#include "Arduino.h"

#include "Turbine.h"

Turbine::Turbine() { }

/** Initializes every turbine elements
*/
void Turbine::setup() {
  this->pitch.attach(PITCH_PIN);
  this->load.attach(RELAY_PIN1, RELAY_PIN2, RELAY_PIN3, RELAY_PIN4);
  this->brushless.attach(BRUSHLESS_PIN, OPT_PIN1, OPT_PIN2);
  this->imu.attach(IMU_ADDRESS);
  this->screen.attach(SCREEN_ADDRESS);
}

/** Runs every turbine elements
*/
void Turbine::run() {
  this->brushless.run();
  //Serial.print("Command: ");
  //Serial.println((int) this->command.mode);
  this->status.time = getTime();
  //Serial.println(this->status.time);
  this->status.rpm = this->brushless.readFrequency() * 10;
  //Serial.print("RPM: ");
  //Serial.println(this->status.rpm);
  //Serial.print("Prev_RPM: ");
  //Serial.println(this->status.prev_rpm);
  this->pitch.run(this->command, this->status);
  this->status.pitch = this->pitch.read();
  //Serial.print("Pitch: ");
  //Serial.println(this->status.pitch);
  this->load.run(this->command, this->status);
  this->status.load = this->load.read();
  //Serial.print("Load: ");
  //Serial.println(this->status.load);
  this->status.resistance = this->load.readResistance();
  //Serial.print("Resistance: ");
  //Serial.println(this->status.resistance);
  this->status.power = this->brushless.readPower(this->status);
  //Serial.print("Power: ");
  //Serial.println(this->status.power);
  this->status.acc = this->imu.readAcceleration();
  this->status.rot = this->imu.readRotation();
  this->status.phase = Control::nextPhase(this->command, this->status);
  //Serial.print("Phase: ");
  //Serial.println((int) this->status.phase);
  this->status.prev_rpm = this->status.rpm;
  this->screen.write(this->command, this->status);
}

/** Reads turbine elements information
   @return turbine elements information
*/
Status Turbine::read() {
  return this->status;
}

/** Writes turbine orders
   @param command orders
*/
void Turbine::write(Command const &command) {
  this->command = command;
}
