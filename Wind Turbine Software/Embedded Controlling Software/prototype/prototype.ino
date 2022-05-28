/*
  prototype_firmware for controlling offshore turbines.
  Created by Martín Fernández de Diego and Belén Sánchez Centeno.
*/

#include "Data.h"
#include "Turbine.h"
#include "Communication.h"

TaskHandle_t controlProcessHandle = NULL;
TaskHandle_t communicationProcessHandle = NULL;

QueueHandle_t commandQueue, statusQueue;

// CONTROL
void controlProcess(void* parameters) {
  Command command;
  Status status;
  Turbine turbine;

  turbine.setup();

  unsigned long loop_time = 0;

  for (;;) {
    if (uxQueueMessagesWaiting(commandQueue) > 0) {
      xQueueReceive(commandQueue, &command, 0);
      turbine.write(command); // < 0ms
    }

    turbine.run(); // aprox 450ms

    if (uxQueueSpacesAvailable(statusQueue) > 0) {
      status = turbine.read(); // < 0ms
      xQueueSend(statusQueue, &status, 0);
    }
    else {
      xQueueReset(statusQueue);
    }

    // Control refresh rate limited to CONTROL_PERIOD seconds
    while (micros() - loop_time < toMicros(CONTROL_PERIOD));
    loop_time = micros();
  }
}

// UPLOAD
void communicationProcess(void* parameters) {
  Command command;
  Status status_array[NUM_STATUS_MESSAGES];
  Communication communication;

  communication.setupScreen();
  communication.setupWiFi();
  communication.setupThingSpeak();
  xQueueReset(statusQueue);

  unsigned long loop_time = 0;

  for (;;) {
    for (int i = 0; i < NUM_STATUS_MESSAGES; ++i) {
      xQueueReceive(statusQueue, &status_array[i], portMAX_DELAY);

      // Screen communication refresh rate limited to CONTROL_PERIOD seconds
      if (micros() - loop_time >= toMicros(CONTROL_PERIOD)) {
        loop_time = micros();

        communication.writeScreen(command, status_array[i]);

        command = communication.readThingSpeak(); // aprox 600ms
        xQueueOverwrite(commandQueue, &command);
      }
    }

    communication.writeThingSpeak(status_array);
  }
}

void setup() {
  Serial.begin(115200);

  commandQueue = xQueueCreate(NUM_COMMAND_MESSAGES, sizeof(Command));
  statusQueue = xQueueCreate(NUM_STATUS_MESSAGES, sizeof(Status));

  xTaskCreatePinnedToCore(
    controlProcess, // Function name
    "Control Process", // Task name
    4000, // Stack size
    NULL, // Parameters
    1, // Priority (0-100)
    &controlProcessHandle, // Task handler
    1 // Core
  );

  xTaskCreatePinnedToCore(
    communicationProcess, // Function name
    "Communication Process", // Task name
    4000, // Stack size
    NULL, // Parameters
    1, // Priority (0-100)
    &communicationProcessHandle, // Task handler
    0 // Core
  );
}

void loop() {
  vTaskDelete(NULL); // loop() function unused
}
