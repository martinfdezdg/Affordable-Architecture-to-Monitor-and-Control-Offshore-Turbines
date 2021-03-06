/*
  BrushlessSignal.cpp - Library for reading brushless signal.
*/

#include "Arduino.h"

#include "BrushlessSignal.h"

BrushlessSignal::BrushlessSignal() {}

/** Attaches brushless to given pin and initializes it
   @param analog_pin STEPPER_PIN
*/
void BrushlessSignal::attach(uint8_t analog_pin, uint8_t opt1_pin, uint8_t opt2_pin) {
  brushless.attach(analog_pin);
  optocoupler1.attach(opt1_pin);
  optocoupler2.attach(opt2_pin);
  optocoupler1.write(LOW);
  optocoupler2.write(HIGH);

  FFT = arduinoFFT();
}

/** Runs some iterations to obtain reliable voltages from the brushless
*/
void BrushlessSignal::run() {
  unsigned long loop_time = 0;
  this->peak_voltage = 0;
  for (int i = 0; i < SAMPLES; ++i) {
    this->real_voltage[i] = (brushless.read() * (3.3 / 4096.0) - VOffset) / scale;
    this->imaginary_voltage[i] = 0;
    this->peak_voltage = max(this->real_voltage[i], this->peak_voltage);
    // regulate to approximately "SAMPLE_PERIOD" (max depends on BAUD and computer speed)
    while ((micros() - loop_time) < SAMPLE_PERIOD);
    loop_time = micros();
  }
}

/** Reads revolutions frequency generated by the brushless
   @return frequency generated by the brushless
*/
double BrushlessSignal::readFrequency() {
  FFT.Windowing(this->real_voltage, SAMPLES, FFT_WIN_TYP_HAMMING, FFT_FORWARD);
  FFT.Compute(this->real_voltage, this->imaginary_voltage, SAMPLES, FFT_FORWARD);
  FFT.ComplexToMagnitude(this->real_voltage, this->imaginary_voltage, SAMPLES);
  FFT.DCRemoval(this->real_voltage, SAMPLES);
  double frequency = FFT.MajorPeak(this->real_voltage, SAMPLES, SAMPLE_RATE);
  // High pass filter
  if (frequency < HIGH_PASS_FILTER) {
    frequency = 0;
  }
  return frequency;
}

/** Reads power generated by the brushless
   @param status status of turbine
   @return power generated in mW
*/
double BrushlessSignal::readPower(Status const &status) {
  this->rms_voltage = this->peak_voltage / sqrt(2);
  return toMillis(pow(this->rms_voltage, 2) / status.resistance);  // power in mW
}
