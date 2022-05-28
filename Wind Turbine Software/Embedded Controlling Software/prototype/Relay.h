/*
  Relay.h - Library for control array of relays.
*/

#ifndef RELAY_H
#define RELAY_H

#include "Arduino.h"

class Relay {
  public:
    static const int MIN_RELAY = 0;
    static const int MAX_RELAY = 15;

    Relay();
    void attach(uint8_t pin1, uint8_t pin2, uint8_t pin3, uint8_t pin4);
    void write(int value);
    float readResistance();

  private:
    uint8_t pin1, pin2, pin3, pin4;
    int value;
    float resistance;
};

#endif
