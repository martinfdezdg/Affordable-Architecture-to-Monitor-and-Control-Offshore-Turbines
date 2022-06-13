/*
  Communication.cpp - Library for communicate with periphericals.
*/

#include "Arduino.h"

#include "Communication.h"

Communication::Communication() { }

// WIFI
/** Sets WiFi connection
*/
void Communication::setupWiFi() {
  //Serial.print("\nConnecting to ");
  //Serial.println(WIFI_SSID);
  WiFi.begin(WIFI_SSID, WIFI_PASS);
  while (WiFi.status() != WL_CONNECTED) {
    vTaskDelay(500);
  }
  //Serial.println("\nWiFi connected");
  configTime(0, 0, NTP_SERVER); // IMPORTANT
}

// THINGSPEAK
/** Sets ThingSpeak connections
*/
void Communication::setupThingSpeak() {
  state_http_client.begin(wifi_client, STATE_WRITE_SERVER);
  acc_rot_http_client.begin(wifi_client, ACC_ROT_WRITE_SERVER);
  ThingSpeak.begin(wifi_client);
}

/** Writes array of status on multiple ThingSpeak channels
   @param status_array arrays of status of turbine
*/
void Communication::writeThingSpeak(Status const status_array[]) {
  state_http_client.addHeader("Content-Type", "application/json");
  state_http_client.POST(stateToJson(STATE_WRITE_APIKEY, status_array));
  //Serial.print("HTTP_status Response: ");
  //Serial.println(state_http_client.getString());
  acc_rot_http_client.addHeader("Content-Type", "application/json");
  acc_rot_http_client.POST(accRotToJson(ACC_ROT_WRITE_APIKEY, status_array));
  //Serial.print("HTTP_acc_rot Response: ");
  //Serial.println(acc_rot_http_client.getString());
}

/** Reads command of ThingSpeak channel
*/
Command Communication::readThingSpeak() {
  Command command;
  ThingSpeak.readMultipleFields(COMMAND_READ_CHANNEL_ID, COMMAND_READ_APIKEY);
  command.mode = (Mode) ThingSpeak.getFieldAsInt(1);
  command.pitch = ThingSpeak.getFieldAsInt(2);
  command.load = ThingSpeak.getFieldAsInt(3);
  command.stop = ThingSpeak.getFieldAsInt(4);
  return command;
}
