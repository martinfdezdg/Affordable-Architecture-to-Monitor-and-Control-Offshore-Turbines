/*
  Pitch.cpp - Library for control pitch.
*/

#include "Arduino.h"

#include "Pitch.h"

Pitch::Pitch() {
  this->pitch = MIN_PITCH;
}

/** Attaches servo to given pin and writes initial pitch
   @param pin PITCH_PIN
*/
void Pitch::attach(uint8_t pin) {
  this->servo.attach(pin);
  
  write(this->pitch);
}

/** Writes pitch angle on servo
   @param pitch Tested correctness inside
*/
void Pitch::write(float pitch) {
  if (MIN_PITCH <= pitch && pitch <= MAX_PITCH) {
    this->pitch = pitch;
    this->servo.write(toServoAngle(this->pitch));
  }
}

/** Reads pitch angle set on servo
   @return pitch angle set on servo
*/
float Pitch::read() {
  return this->pitch;
}
