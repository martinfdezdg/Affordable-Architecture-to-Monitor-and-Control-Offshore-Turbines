/*
  Communication.h - Library for communicate with periphericals.
*/

#ifndef STREAM_COMMUNICATION_H
#define STREAM_COMMUNICATION_H

#include "Arduino.h"

#include <Wire.h>
#include <WiFi.h>
#include <HTTPClient.h>
#include "ThingSpeak.h"
#include "Data.h"

class Communication {
  public:
    Communication();
    void setupWiFi();
    void setupThingSpeak();
    Command readThingSpeak();
    void writeThingSpeak(Status const status_array[]);

  private:
    WiFiClient wifi_client;
    HTTPClient state_http_client;
    HTTPClient acc_rot_http_client;
};

#endif
