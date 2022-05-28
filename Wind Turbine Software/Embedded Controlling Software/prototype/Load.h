/*
  Load.h - Library for control load.
*/

#ifndef LOAD_H
#define LOAD_H

#include "Arduino.h"

#include "Data.h"
#include "Control.h"
#include "Relay.h"

class Load {
  public:
    static const int MIN_LOAD = 0;
    static const int MAX_LOAD = 15;

    Load();
    void attach(uint8_t pin1, uint8_t pin2, uint8_t pin3, uint8_t pin4);
    virtual void run(Command const &command, Status const &status) = 0;
    void write(int load);
    int read();
    float readResistance();

  private:
    Relay relay;

  protected:
    int load;
};

#endif
