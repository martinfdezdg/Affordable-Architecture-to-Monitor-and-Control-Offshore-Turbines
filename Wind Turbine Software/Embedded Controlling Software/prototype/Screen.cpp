/*
  Screen.cpp - Library for communicate with peripherical screen.
*/

#include "Arduino.h"

#include "Screen.h"

Screen::Screen()
  : screen(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, SCREEN_RESET) { }

/** Sets Screen connection
*/
void Screen::attach(int address) {
  this->screen.begin(SSD1306_SWITCHCAPVCC, address);

  this->screen.clearDisplay();

  this->screen.setTextSize(1); // Normal 1:1 pixel scale
  this->screen.setTextColor(SSD1306_WHITE); // Draw white text
  this->screen.setCursor(0, 0); // Start at top-left corner
  this->screen.println("Loading");

  this->screen.setTextColor(SSD1306_WHITE);
  this->screen.println("Control process");

  this->screen.setTextSize(2);
  this->screen.setTextColor(SSD1306_WHITE);
  this->screen.print("...");

  this->screen.display();
}

/** Writes array of status on screen
   @param status_array arrays of status of turbine
*/
void Screen::write(Command const &command, Status const &status) {
  this->screen.clearDisplay();

  if (status.phase == Phase::STOP && status.time % 2 == 0) {
    this->screen.setTextSize(1);
    this->screen.setTextColor(SSD1306_WHITE);
    this->screen.setCursor(0, 0);
    this->screen.println("EMERGENCY STOP");
  }
  else {
    this->screen.setTextSize(1);
    this->screen.setTextColor(SSD1306_WHITE);
    this->screen.setCursor(0, 0);
    this->screen.print("Pitch: ");
    this->screen.print((int) status.pitch);
    this->screen.setCursor(60, 0);
    this->screen.print("Load: ");
    this->screen.println(status.load);
  }

  this->screen.setTextColor(SSD1306_WHITE);
  this->screen.print("Power: ");
  this->screen.print(status.power);
  this->screen.println("mW");

  this->screen.setTextSize(2);
  this->screen.setTextColor(SSD1306_WHITE);
  this->screen.print("RPM: ");
  this->screen.print((int) status.rpm);

  this->screen.display();
}
