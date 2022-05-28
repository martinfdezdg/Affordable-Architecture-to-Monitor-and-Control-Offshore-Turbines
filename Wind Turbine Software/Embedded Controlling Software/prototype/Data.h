/*
  Data.h - Library for storing data structures and generic functions.
*/

#ifndef DATA_H
#define DATA_H

#include "Arduino.h"

#include <WiFi.h>
#include <ArduinoJson.h>

#include "credentials.h"



#define NUM_COMMAND_MESSAGES 1
#define NUM_STATUS_MESSAGES 20

#define CONTROL_PERIOD 1
#define CONTROL_TIME 0.5



enum Phase {INIT, START, PITCH_CONTROL, LOAD_CONTROL, STOP};
enum Mode {AUTO, MANUAL};

struct Point {
  int16_t x = 0, y = 0, z = 0;
};

struct Status {
  unsigned long time;
  float pitch = 0;
  int load = 0;
  int rpm = 0;
  int prev_rpm = 0;
  float power = 0;
  float resistance = 0;
  Point acc;
  Point rot;
  Phase phase = Phase::INIT;
};

struct Command {
  Mode mode = Mode::AUTO;
  int pitch = 0;
  int load = 0;
  int stop = 0;
};



static unsigned long getTime() {
  time_t now;
  struct tm time_info;
  if (WiFi.status() != WL_CONNECTED || !getLocalTime(&time_info)) {
    return 0;
  }
  else {
    time(&now);
    return now;
  }
}

static String stateToJson(String write_apikey, Status const status_array[]) {
  DynamicJsonDocument doc(4096);
  doc["write_api_key"] = write_apikey;
  JsonArray update_array = doc.createNestedArray("updates");
  for (int i = 0; i < NUM_STATUS_MESSAGES; ++i) {
    JsonObject update_object = update_array.createNestedObject();
    update_object["created_at"] = String(status_array[i].time);
    update_object["field1"] = String(status_array[i].pitch);
    update_object["field2"] = String(status_array[i].load);
    update_object["field3"] = String(status_array[i].rpm);
    update_object["field4"] = String(status_array[i].power);
    update_object["field5"] = String(status_array[i].phase);
  }
  String json;
  serializeJsonPretty(doc, json);
  return json;
}

static String accRotToJson(String write_apikey, Status const status_array[]) {
  DynamicJsonDocument doc(4096);
  doc["write_api_key"] = write_apikey;
  JsonArray update_array = doc.createNestedArray("updates");
  for (int i = 0; i < NUM_STATUS_MESSAGES; ++i) {
    JsonObject update_object = update_array.createNestedObject();
    update_object["created_at"] = String(status_array[i].time);
    update_object["field1"] = String(status_array[i].acc.x);
    update_object["field2"] = String(status_array[i].acc.y);
    update_object["field3"] = String(status_array[i].acc.z);
    update_object["field4"] = String(status_array[i].rot.x);
    update_object["field5"] = String(status_array[i].rot.y);
    update_object["field6"] = String(status_array[i].rot.z);
  }
  String json;
  serializeJsonPretty(doc, json);
  return json;
}

static float toServoAngle(float value) {
  return ((-70.0 * value) / 45.0) + 115.0;
}

static float toMillis(float value) {
  return value * 1e3;
}

static float toMicros(float value) {
  return value * 1e6;
}

#endif
