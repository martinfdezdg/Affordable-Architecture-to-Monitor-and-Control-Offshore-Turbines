/*
  LoadControl.cpp - Library for control load algorithms.
*/


#include "Arduino.h"

#include "LoadControl.h"

LoadControl::LoadControl()
  : Load() { }

/** Runs the right load function depending on actual phase
   @param command last command read by turbine
   @param status status of turbine
*/
void LoadControl::run(Command const &command, Status const &status) {
  switch (command.mode) {
    case Mode::AUTO:
      switch (status.phase) {
        case Phase::INIT:
          pid(status);
          break;
        case Phase::START:
          start(status);
          break;
        case Phase::PITCH_CONTROL:
          break;
        case Phase::LOAD_CONTROL:
          pid(status);
          break;
        case Phase::STOP:
          stop(status);
          break;
        default:
          break;
      }
      break;
    case Mode::MANUAL:
      if (status.phase == Phase::STOP) {
        stop(status);
      }
      else {
        write(command.load);
      }
      break;
    default:
      break;
  }
}

/** Writes load applying D control based on status
   @param status status of turbine
*/
void LoadControl::start(Status const &status) {
  write(round(this->load + ((status.rpm - status.prev_rpm) / (toMicros(CONTROL_TIME) * 1e-6)) * D1_GAIN));
}

/** Writes load to MAX_LOAD to slow as much as possible revolutions
   @param status status of turbine
*/
void LoadControl::stop(Status const &status) {
  write(Load::MAX_LOAD);
}

/** Writes load applying PD control based on status
   @param status status of turbine
*/
void LoadControl::pid(Status const &status) {
  write(round(this->load - (Control::OPT_RPM - status.rpm) * P_GAIN + ((status.rpm - status.prev_rpm) / (toMicros(CONTROL_TIME) * 1e-6)) * D2_GAIN)); // PD control
}
