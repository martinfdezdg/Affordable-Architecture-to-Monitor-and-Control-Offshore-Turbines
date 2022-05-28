/*
  Control.h - Library for control phases of auto mode.
*/

#ifndef CONTROL_H
#define CONTROL_H

#include "Arduino.h"

#include "Data.h"

class Control {
  public:
    static const int MIN_RPM = 100;
    static const int MAX_RPM = 650;
    static const int OPT_RPM = 500;
    static const int ERR_RPM = 0.2 * OPT_RPM;

    Control();
    static Phase nextPhase(Command const &command, Status const &status);
};

#endif
