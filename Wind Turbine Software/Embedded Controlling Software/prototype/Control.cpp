/*
  Control.cpp - Library for control phases of auto mode.
*/

#include "Arduino.h"
#include "Control.h"

Control::Control() { }

/** Decides next phase of control in auto mode based on command and status turbine
   @param command last command read by turbine
   @param status status of turbine
   @return Next phase of control in auto mode
*/
Phase Control::nextPhase(Command const &command, Status const &status) {
  if (command.stop) {
    return Phase::STOP;
  }
  else if (status.rpm < MIN_RPM) {
    return Phase::INIT;
  }
  else if (MIN_RPM <= status.rpm && status.rpm < OPT_RPM - ERR_RPM && status.phase <= Phase::START) {
    return Phase::START;
  }
  else if (OPT_RPM - ERR_RPM <= status.rpm && status.rpm <= OPT_RPM + ERR_RPM) {
    return Phase::PITCH_CONTROL;
  }
  else if (status.rpm < OPT_RPM - ERR_RPM || OPT_RPM + ERR_RPM < status.rpm && status.rpm < MAX_RPM) {
    return Phase::LOAD_CONTROL;
  }
  else if (command.mode == 0 && MAX_RPM <= status.rpm) {
    return Phase::STOP;
  }
}
