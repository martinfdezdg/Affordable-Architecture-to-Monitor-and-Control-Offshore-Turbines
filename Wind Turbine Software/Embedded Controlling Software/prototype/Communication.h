/*
  Communication.h - Library for communicate with periphericals.
*/

#ifndef STREAM_COMMUNICATION_H
#define STREAM_COMMUNICATION_H

#include "Arduino.h"

#include <Wire.h>
#include <WiFi.h>
#include <HTTPClient.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include "ThingSpeak.h"
#include "Data.h"

#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 32 // OLED display height, in pixels
#define SCREEN_RESET -1
#define SCREEN_ADDRESS 0x3C // See datasheet for Address; 0x3D for 128x64, 0x3C for 128x32

class Communication {
  public:
    Communication();
    void setupWiFi();
    void setupThingSpeak();
    void writeThingSpeak(Status const status_array[]);
    Command readThingSpeak();
    void setupScreen();
    void writeScreen(Command const& command, Status const &status);

  private:
    WiFiClient wifi_client;
    HTTPClient state_http_client;
    HTTPClient acc_rot_http_client;
    Adafruit_SSD1306 screen;
};

#endif
