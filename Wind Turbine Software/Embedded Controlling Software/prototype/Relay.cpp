/*
  Relay.cpp - Library for control array of relays.
*/

#include "Arduino.h"

#include "Relay.h"

Relay::Relay() { }

/** Attaches array of relays to given pin
   @param pin1 RELAY_PIN1
   @param pin2 RELAY_PIN2
   @param pin3 RELAY_PIN3
   @param pin4 RELAY_PIN4
*/
void Relay::attach(uint8_t pin1, uint8_t pin2, uint8_t pin3, uint8_t pin4) {
  this->pin1 = pin1;
  this->pin2 = pin2;
  this->pin3 = pin3;
  this->pin4 = pin4;

  pinMode(this->pin1, OUTPUT);
  pinMode(this->pin2, OUTPUT);
  pinMode(this->pin3, OUTPUT);
  pinMode(this->pin4, OUTPUT);
}

/** Writes load on array of relays by transforming to raw values
   @param value Decides resistance applied
*/
void Relay::write(int value) {
  bool value_code1, value_code2, value_code3, value_code4;
  this->value = value;

  switch (this->value) {
    case 0:
      value_code1 = 1;
      value_code2 = 1;
      value_code3 = 1;
      value_code4 = 1;
      this->resistance = 500;
      break;
    case 1:
      value_code1 = 1;
      value_code2 = 1;
      value_code3 = 1;
      value_code4 = 0;
      this->resistance = 76.3;
      break;
    case 2:
      value_code1 = 1;
      value_code2 = 1;
      value_code3 = 0;
      value_code4 = 1;
      this->resistance = 21.4;
      break;
    case 3:
      value_code1 = 1;
      value_code2 = 1;
      value_code3 = 0;
      value_code4 = 0;
      this->resistance = 17.5;
      break;
    case 4:
      value_code1 = 1;
      value_code2 = 0;
      value_code3 = 1;
      value_code4 = 1;
      this->resistance = 8.8;
      break;
    case 5:
      value_code1 = 1;
      value_code2 = 0;
      value_code3 = 1;
      value_code4 = 0;
      this->resistance = 8;
      break;
    case 6:
      value_code1 = 1;
      value_code2 = 0;
      value_code3 = 0;
      value_code4 = 1;
      this->resistance = 6.7;
      break;
    case 7:
      value_code1 = 1;
      value_code2 = 0;
      value_code3 = 0;
      value_code4 = 0;
      this->resistance = 6.4;
      break;
    case 8:
      value_code1 = 0;
      value_code2 = 1;
      value_code3 = 1;
      value_code4 = 1;
      this->resistance = 2;
      break;
    case 9:
      value_code1 = 0;
      value_code2 = 1;
      value_code3 = 1;
      value_code4 = 0;
      this->resistance = 1.8;
      break;
    case 10:
      value_code1 = 0;
      value_code2 = 1;
      value_code3 = 0;
      value_code4 = 1;
      this->resistance = 1.7;
      break;
    case 11:
      value_code1 = 0;
      value_code2 = 1;
      value_code3 = 0;
      value_code4 = 0;
      this->resistance = 1.6;
      break;
    case 12:
      value_code1 = 0;
      value_code2 = 0;
      value_code3 = 1;
      value_code4 = 1;
      this->resistance = 1.5;
      break;
    case 13:
      value_code1 = 0;
      value_code2 = 0;
      value_code3 = 1;
      value_code4 = 0;
      this->resistance = 1.5;
      break;
    case 14:
      value_code1 = 0;
      value_code2 = 0;
      value_code3 = 0;
      value_code4 = 1;
      this->resistance = 1.5;
      break;
    case 15:
      value_code1 = 0;
      value_code2 = 0;
      value_code3 = 0;
      value_code4 = 0;
      this->resistance = 1.5;
      break;
    default:
      break;
  }

  digitalWrite(this->pin1, value_code1);
  digitalWrite(this->pin2, value_code2);
  digitalWrite(this->pin3, value_code3);
  digitalWrite(this->pin4, value_code4);
}

/** Reads resistance set on array of relays
   @return resistance set on array of relays
*/
float Relay::readResistance() {
  return this->resistance;
}
