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
#include "Screen.h"

#define PITCH_PIN 5

#define RELAY_PIN1 33
#define RELAY_PIN2 25
#define RELAY_PIN3 26
#define RELAY_PIN4 27

#define BRUSHLESS_PIN 36
#define OPT_PIN1 18
#define OPT_PIN2 19

#define IMU_ADDRESS 0x68

#define SCREEN_ADDRESS 0x3C // See datasheet for Address; 0x3D for 128x64, 0x3C for 128x32

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
    Screen screen;
};

#endif
