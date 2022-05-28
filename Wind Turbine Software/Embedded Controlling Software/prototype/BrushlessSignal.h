/*
  BrushlessSignal.cpp - Library for reading brushless signal.
*/

#ifndef BRUSHLESS_SIGNAL_H
#define BRUSHLESS_SIGNAL_H

#include "Arduino.h"

#include <arduinoFFT.h>
#include "Data.h"
#include "Brushless.h"
#include "Optocoupler.h"

class BrushlessSignal {
  public:
    static const int SAMPLES = 128;
    static const int SAMPLE_RATE = 300;
    static constexpr float SAMPLE_PERIOD = 1 / SAMPLE_RATE;
    static constexpr float OFFSET = 1.5;
    static const int HIGH_PASS_FILTER = 5;
    static const int SCALE = 1;

    double real_voltage[SAMPLES];
    double imaginary_voltage[SAMPLES];
    double peak_voltage = 0;
    double rms_voltage = 0;

    BrushlessSignal();
    void attach(uint8_t analog_pin, uint8_t opt_pin1, uint8_t opt_pin2);
    void run();
    float readFrequency();
    float readPower(Status const &status);

  private:
    Brushless brushless;
    Optocoupler optocoupler1, optocoupler2;
    arduinoFFT FFT;
};

#endif
