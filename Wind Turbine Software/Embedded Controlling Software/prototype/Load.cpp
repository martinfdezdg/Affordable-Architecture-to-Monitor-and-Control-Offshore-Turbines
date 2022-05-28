/*
  Load.cpp - Library for control load.
*/

#include "Arduino.h"

#include "Load.h"

Load::Load() {
  this->load = MIN_LOAD;
}

/** Attaches array of relays to given pins and writes initial load
   @param pin1 RELAY_PIN1
   @param pin2 RELAY_PIN2
   @param pin3 RELAY_PIN3
   @param pin4 RELAY_PIN4
*/
void Load::attach(uint8_t pin1, uint8_t pin2, uint8_t pin3, uint8_t pin4) {
  this->relay.attach(pin1, pin2, pin3, pin4);
  
  write(this->load);
}

/** Writes load on array of relays
   @param load Tested correctness inside
*/
void Load::write(int load) {
  if (MIN_LOAD <= load && load <= MAX_LOAD) {
    this->load = load;
    this->relay.write(this->load);
  }
}

/** Reads load set on array of relays
   @return load set on array of relays
*/
int Load::read() {
  return this->load;
}

/** Reads resistance set on array of relays
   @return resistance set on array of relays
*/
float Load::readResistance() {
  return relay.readResistance();
}
