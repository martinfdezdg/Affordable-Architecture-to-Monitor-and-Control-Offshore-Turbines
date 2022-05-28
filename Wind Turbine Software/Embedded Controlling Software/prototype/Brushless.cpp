/*
  Brushless.cpp - Library for reading brushless signal.
*/

#include "Arduino.h"

#include "Brushless.h"

Brushless::Brushless() { }

/** Attaches brushless to given pin
   @param analog_pin BRUSHLESS_PIN
*/
void Brushless::attach(uint8_t analog_pin) {
  this->pin = analog_pin;
  pinMode(this->pin, INPUT);
}

/** Reads raw value from analog pin
   @return raw value of brushless
*/
int Brushless::read() {
  this->value = analogRead(this->pin);
  return this->value;
}
