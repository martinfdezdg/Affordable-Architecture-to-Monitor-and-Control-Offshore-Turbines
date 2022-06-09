/*
  PitchControl.h - Library for control pitch algorithms.
*/

#ifndef PITCH_CONTROL_H
#define PITCH_CONTROL_H

#include "Arduino.h"

#include "Data.h"
#include "Pitch.h"
#include "Control.h"

class PitchControl: public Pitch {
  public:
    static constexpr double ALPHA = 0.95;
    static constexpr double P_GAIN = 0.007;
    static constexpr double D_GAIN = 0.03;
    static constexpr double I_GAIN = 0.01;

    PitchControl();
    void run(Command const &command, Status const &status);

  private:
    void init(Status const &status);
    void start(Status const &status);
    void stop(Status const &status);
    void pid(Status const &status);
};

#endif
