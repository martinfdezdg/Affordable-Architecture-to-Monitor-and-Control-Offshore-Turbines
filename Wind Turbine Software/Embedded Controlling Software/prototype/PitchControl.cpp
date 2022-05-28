/*
  PitchControl.cpp - Library for control pitch algorithms.
*/

#include "Arduino.h"

#include "PitchControl.h"

PitchControl::PitchControl()
  : Pitch() { }

/** Runs the right pitch function depending on actual phase
   @param command last command read by turbine
   @param status status of turbine
*/
void PitchControl::run(Command const &command, Status const &status) {
  switch (command.mode) {
    case Mode::AUTO:
      switch (status.phase) {
        case Phase::INIT:
          init(status);
          break;
        case Phase::START:
          start(status);
          break;
        case Phase::PITCH_CONTROL:
          pid(status);
          break;
        case Phase::LOAD_CONTROL:
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
        write(command.pitch);
      }
      break;
    default:
      break;
  }
}

/** Writes pitch to MIN_PITCH to help start revolutions
   @param status status of turbine
*/
void PitchControl::init(Status const &status) {
  write(Pitch::MAX_PITCH);
}

/** Writes pitch to achieve OPT_PITCH exponentionally
   @param status status of turbine
*/
void PitchControl::start(Status const &status) {
  write(ALPHA * this->pitch + (1 - ALPHA) * Pitch::OPT_PITCH);
}

/** Writes pitch applying PID control based on status
   @param status status of turbine
*/
void PitchControl::pid(Status const &status) {
  float valid_pitch = this->pitch - (Control::OPT_RPM - status.rpm) * P_GAIN + ((status.rpm - status.prev_rpm) / (toMicros(CONTROL_TIME) * 1e-6)) * D_GAIN + ((status.rpm - status.prev_rpm) * (toMicros(CONTROL_TIME) * 1e-6)) * I_GAIN;
  if (valid_pitch >= Pitch::OPT_PITCH) {
    write(valid_pitch);
  }
}

/** Writes pitch to MAX_PITCH to slow as much as possible revolutions
   @param status status of turbine
*/
void PitchControl::stop(Status const &status) {
  write(Pitch::MIN_PITCH);
}
