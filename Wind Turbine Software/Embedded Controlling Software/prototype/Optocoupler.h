/*
  Optocoupler.h - Library for setting optocoupler.
*/

#ifndef OPTOCOUPLER_H
#define OPTOCOUPLER_H

#include "Arduino.h"

#include "Data.h"

class Optocoupler {
  public:
    Optocoupler();
    void attach(uint8_t opt_pin);
    void write(bool value);

  private:
    uint8_t pin;
    int value;
};

#endif
