/*
  Optocoupler.cpp - Library for setting optocoupler.
*/

#include "Arduino.h"

#include "Optocoupler.h"

Optocoupler::Optocoupler() { }

/** Attaches optocoupler to given pin
   @param analog_pin OPT_PIN
*/
void Optocoupler::attach(uint8_t opt_pin) {
  this->pin = opt_pin;
  pinMode(this->pin, OUTPUT);
}

/** Writes configuration value on optocoupler
   @param value Boolean on/off
*/
void Optocoupler::write(bool value) {
  this->value = value;
  digitalWrite(this->pin, this->value);
}
