/*
  ImuSignal.h - Library for reading IMU signal.
*/

#ifndef IMU_SIGNAL_H
#define IMU_SIGNAL_H

#include "Arduino.h"

#include "Wire.h"
#include "MPU6050.h"
#include "Data.h"

class ImuSignal {
  public:
    static constexpr float ACC_SCALE = 2.0 * 9.81 / 32768.0;
    static constexpr float ROT_SCALE = 250.0 / 32768.0;

    ImuSignal();
    void attach(int address);
    Point readAcceleration();
    Point readRotation();

  private:
    MPU6050 imu;
};

#endif
