/*
  LoadControl.h - Library for control load algorithms.
*/

#ifndef LOAD_CONTROL_H
#define LOAD_CONTROL_H

#include "Arduino.h"

#include "Data.h"
#include "Load.h"
#include "Control.h"

class LoadControl: public Load {
  public:
    static constexpr double P_GAIN  = 0.003;
    static constexpr double D1_GAIN = 0.01;
    static constexpr double D2_GAIN = 0.01;

    LoadControl();
    void run(Command const &command, Status const &status);

  private:
    void start(Status const &status);
    void pid(Status const &status);
    void stop(Status const &status);
};

#endif
