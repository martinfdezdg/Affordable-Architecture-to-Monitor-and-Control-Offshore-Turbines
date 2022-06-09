
#ifndef BRUSHLESS_SIGNAL_H
#define BRUSHLESS_SIGNAL_H

#include "Arduino.h"

#include <arduinoFFT.h>
#include "Brushless.h"
#include "Optocoupler.h"
#include "Data.h"

#define SAMPLES 128

class BrushlessSignal {
  public:
    // FFT PUBLIC VARIABLES
    static constexpr int SAMPLE_RATE = 300; // sample rate = 100x3
    static constexpr float SAMPLE_PERIOD = 1e6 / SAMPLE_RATE; // sample time in microsecond
    int scale = 1;

    // ANALOG READ PUBLIC VARIABLES
    double real_voltage[SAMPLES];
    double imaginary_voltage[SAMPLES];
    double peak_voltage = 0;
    double rms_voltage = 0;

    // FUNCTIONS
    BrushlessSignal();
    void attach(uint8_t analog_pin, uint8_t opt1_pin, uint8_t opt2_pin);
    void run();
    double readFrequency();
    double readPower(Status const &status);

  private:
    // FFT PRIVATE VARIABLES
    const double HIGH_PASS_FILTER = 5;
    // ANALOG READ PRIVATE VARIABLES
    const double VOffset = 1.5; // default value offset

    Brushless brushless;
    Optocoupler optocoupler1, optocoupler2;
    arduinoFFT FFT;
};

#endif
