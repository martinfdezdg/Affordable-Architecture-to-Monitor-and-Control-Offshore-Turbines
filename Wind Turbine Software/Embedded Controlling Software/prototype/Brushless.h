/*
  Brushless.h - Library for reading brushless signal.
*/

#ifndef BRUSHLESS_H
#define BRUSHLESS_H

#include "Arduino.h"

#include "Data.h"

class Brushless {
  public:
    Brushless();
    void attach(uint8_t analog_pin);
    int read();

  private:
    uint8_t pin;
    int value;
};

#endif
