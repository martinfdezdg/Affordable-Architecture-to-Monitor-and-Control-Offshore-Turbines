// credentials.h


// WiFi credentials
//#define WIFI_SSID "Android_Giordy"
//#define WIFI_PASS "mobile98"

//#define WIFI_SSID "iPhone de Martín"
//#define WIFI_PASS "ojdvg0ke5thv1"

//#define WIFI_SSID "Casa"
//#define WIFI_PASS "6yxjbmiPa"

//#define WIFI_SSID "Piso"
//#define WIFI_PASS "6yxjbmiPa"

#define WIFI_SSID "pc2"
#define WIFI_PASS "20222022"


// Time credentials
#define NTP_SERVER "pool.ntp.org"


// Command ThingSpeak credentials
#define COMMAND_READ_CHANNEL_ID 1695953
#define COMMAND_READ_APIKEY "T21L0ZFM18CZR710"

// State ThingSpeak credentials
#define STATE_WRITE_CHANNEL_ID 1694179
#define STATE_WRITE_APIKEY "4LMAXES0BC3077IF"
#define STATE_WRITE_SERVER "http://api.thingspeak.com/channels/" + String(STATE_WRITE_CHANNEL_ID) + "/bulk_update.json"

// Acc/Rot ThingSpeak credentials
#define ACC_ROT_WRITE_CHANNEL_ID 1710531
#define ACC_ROT_WRITE_APIKEY "0QD6M7UATQLSUY8J"
#define ACC_ROT_WRITE_SERVER "http://api.thingspeak.com/channels/" + String(ACC_ROT_WRITE_CHANNEL_ID) + "/bulk_update.json"
