// Uniendo

#include <Wire.h>
#include <MPU6050.h>
#include <ESP32Servo.h>

#include <WiFi.h>

#include <HTTPClient.h>
#include <ArduinoJson.h>

#include "time.h"

#include "credentials.h"
#include "print.h"


#define UPLOAD_DELAY 15

#define QUEUE_SIZE 30
#define DATA_QUEUE_SIZE 7*sizeof(int)

#define DIM 3

#define IMU_ADDRESS 0x68


class imuRead {
  public:
    int numReads;
    int timeEpoch;
    int acc[DIM];
    int gyr[DIM];

    imuRead() {
      this->numReads = 0;
      this->timeEpoch = 0;
      for (int i = 0; i < DIM; ++i) {
        this->acc[i] = 0;
        this->gyr[i] = 0;
      }
    }

    void addRead(int16_t acc[], int16_t gyr[]) {
      this->numReads++;
      for (int i = 0; i < DIM; ++i) {
        this->acc[i] += acc[i];
        this->gyr[i] += gyr[i];
      }
    }

    void endRead(int timeEpoch) {
      for (int i = 0; i < DIM; ++i) {
        this->acc[i] /= this->numReads;
        this->gyr[i] /= this->numReads;
      }
      this->timeEpoch = timeEpoch;
    }

    void rstRead() {
      this->numReads = 0;
      for (int i = 0; i < DIM + 1; ++i) {
        this->acc[i] = 0;
        this->gyr[i] = 0;
      }
    }
};

TaskHandle_t controlProcessHandle = NULL;
TaskHandle_t uploadProcessHandle = NULL;

QueueHandle_t msgQueue;



unsigned long getTime() {
  time_t now;
  struct tm timeinfo;
  if (!getLocalTime(&timeinfo)) {
    //Serial.println("Failed to obtain time");
    return 0;
  }
  time(&now);
  return now;
}

void controlProcess(void* parameters) {
  MPU6050 mpu(IMU_ADDRESS);
  Servo servo;

  int16_t acc[DIM];
  int16_t gyr[DIM];
  imuRead imuData;

  unsigned long avgTime1, avgTime2;

  Wire.begin();
  mpu.initialize();
  servo.attach(14);

  configTime(0, 0, NTP_SERVER);

  avgTime1 = millis();

  for (;;) {
    mpu.getAcceleration(&acc[0], &acc[1], &acc[2]);
    mpu.getRotation(&gyr[0], &gyr[1], &gyr[2]);

    servo.write(map(acc[1], -16384, 16384, 0, 180));
    // printAccRAW(&acc[0], &acc[1], &acc[2]);

    imuData.addRead(acc, gyr);

    avgTime2 = millis();
    if (avgTime2 - avgTime1 > 1000) {
      imuData.endRead(getTime());

      if (xQueueSend(msgQueue, (void*) &imuData, 0) != pdTRUE) {
        //Serial.println("La cola está llena");
      }

      imuData.rstRead();

      avgTime1 = millis();
    }

    vTaskDelay(10 / portTICK_PERIOD_MS); // Evita errores por no discretizar
  }
}



void toJson(imuRead imuDataArray[], String &json) {
  DynamicJsonDocument doc(32768);
  doc["write_api_key"] = WRITE_APIKEY;

  JsonArray updateArray = doc.createNestedArray("updates");

  for (int i = 0; i < UPLOAD_DELAY; ++i) {
    JsonObject updateObject = updateArray.createNestedObject();
    updateObject["created_at"] = String(imuDataArray[i].timeEpoch);
    updateObject["field1"] = String(imuDataArray[i].acc[0]);
    updateObject["field2"] = String(imuDataArray[i].acc[1]);
    updateObject["field3"] = String(imuDataArray[i].acc[2]);
    updateObject["field4"] = String(imuDataArray[i].gyr[0]);
    updateObject["field5"] = String(imuDataArray[i].gyr[1]);
    updateObject["field6"] = String(imuDataArray[i].gyr[2]);
  }

  serializeJsonPretty(doc, json);
}

void uploadProcess(void* parameters) {
  WiFiClient client;
  HTTPClient http;

  String json;
  imuRead imuDataArray[UPLOAD_DELAY];

  for (;;) {
    for (int i = 0; i < UPLOAD_DELAY; ++i) {
      xQueueReceive(msgQueue, (void *) &imuDataArray[i], portMAX_DELAY);
    }

    json = "";
    toJson(imuDataArray, json);
    //Serial.println(json);

    // Cargar JSON a ThingSpeak
    http.begin(client, SERVER_NAME);

    http.addHeader("Content-Type", "application/json");
    http.POST(json);
    //Serial.print("HTTP Response: ");
    //Serial.println(http.getString());

    http.end();

    vTaskDelay(10 / portTICK_PERIOD_MS); // Evitar errores por no discretizar
  }
}



void initWiFi() {
  Serial.print("\nConnecting to ");
  Serial.println(WIFI_SSID);

  WiFi.begin(WIFI_SSID, WIFI_PASS);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\nWiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void setup() {
  Serial.begin(9600);

  initWiFi();

  msgQueue = xQueueCreate(QUEUE_SIZE, DATA_QUEUE_SIZE);

  xTaskCreatePinnedToCore(
    controlProcess, // Nombre de funcion
    "Control Process", // Nombre de la tarea
    2048, // Tamaño de pila
    NULL, // Parametros
    1, // Prioridad (0-100)
    &controlProcessHandle, // Manejador de la tarea
    1 // Core
  );

  xTaskCreatePinnedToCore(
    uploadProcess, // Nombre de funcion
    "Upload Process", // Nombre de la tarea
    4096, // Tamaño de pila
    NULL, // Parametros
    1, // Prioridad (0-100)
    &uploadProcessHandle, // Manejador de la tarea
    0 // Core
  );
}

void loop() {
  vTaskDelete(NULL); // Funcion loop() no se usa
}
