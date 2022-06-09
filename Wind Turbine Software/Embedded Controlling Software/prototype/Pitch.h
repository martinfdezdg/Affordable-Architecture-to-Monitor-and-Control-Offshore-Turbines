/*
  Pitch.h - Library for control pitch.
*/

#ifndef PITCH_H
#define PITCH_H

#include "Arduino.h"

#include <ESP32Servo.h>
#include "Data.h"
#include "Control.h"

class Pitch {
  public:
    static const int MIN_PITCH = 0;
    static const int MAX_PITCH = 45;
    static const int OPT_PITCH = 15;

    Pitch();
    void attach(uint8_t pin);
    void write(float pitch);
    virtual void run(Command const &command, Status const &status) = 0;
    float read();

  private:
    Servo servo;

  protected:
    float pitch;
};

#endif
