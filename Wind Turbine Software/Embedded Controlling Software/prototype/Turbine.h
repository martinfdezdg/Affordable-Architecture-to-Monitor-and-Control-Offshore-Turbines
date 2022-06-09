/*
  Turbine.h - Library for running every turbine control operations.
*/

#ifndef TURBINE_H
#define TURBINE_H

#include "Arduino.h"

#include "Control.h"
#include "PitchControl.h"
#include "LoadControl.h"
#include "BrushlessSignal.h"
#include "ImuSignal.h"

#define PITCH_PIN 5

#define RELAY_PIN1 33
#define RELAY_PIN2 25
#define RELAY_PIN3 26
#define RELAY_PIN4 27

#define BRUSHLESS_PIN 36
#define OPT_PIN1 18
#define OPT_PIN2 19

#define IMU_PIN 0x68

class Turbine {
  public:
    Turbine();
    void setup();
    void run();
    Status read();
    void write(Command const &command);

  private:
    Status status;
    Command command;
    PitchControl pitch;
    LoadControl load;
    BrushlessSignal brushless;
    ImuSignal imu;
};

#endif
