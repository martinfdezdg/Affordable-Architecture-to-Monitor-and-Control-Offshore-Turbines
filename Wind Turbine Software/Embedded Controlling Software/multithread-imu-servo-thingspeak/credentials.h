// credentials.h

// Credenciales WiFi 
//#define WIFI_SSID "Piso"
//#define WIFI_PASS "6yxjbmiPa"

#define WIFI_SSID "iPhone de Martín"
#define WIFI_PASS "ojdvg0ke5thv1"

/*
#define WIFI_SSID "MOVISTAR_1AE0"
#define WIFI_PASS "A8E9FF5739FD278247D4"
*/

// Credenciales de ThingSpeak
#define CH_ID 1583694
#define WRITE_APIKEY "6KFXONUAM6O4O4KE"

#define NTP_SERVER "pool.ntp.org"
#define SERVER_NAME "http://api.thingspeak.com/channels/" + String(CH_ID) + "/bulk_update.json"
