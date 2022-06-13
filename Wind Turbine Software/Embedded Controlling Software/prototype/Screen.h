/*
  Screen.h - Library for communicate with periphericals.
*/

#ifndef SCREEN_H
#define SCREEN_H

#include "Arduino.h"

#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include "Data.h"

#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 32 // OLED display height, in pixels
#define SCREEN_RESET -1

class Screen {
  public:
    Screen();
    void attach(int address);
    void write(Command const& command, Status const &status);

  private:
    Adafruit_SSD1306 screen;
};

#endif
