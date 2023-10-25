#include <ESP8266WiFi.h>
#include <FirebaseESP8266.h>
#include <NTPClient.h>
#include <WiFiUdp.h>
#include <list>
#include <ESP8266HTTPClient.h>
#include <ESP8266WebServer.h>
#include <EEPROM.h>

#define FASTLED_ESP8266_RAW_PIN_ORDER
#define FASTLED_ESP8266_NODEMCU_PIN_ORDER
#define FASTLED_ESP8266_D1_PIN_ORDER
#include <FastLED.h>

// Library used for token generation and management
#include <addons/TokenHelper.h>

// Library introduces methods for printing data from Firebase database
#include <addons/RTDBHelper.h>

// API key for FireBase DataBase 
#define API_KEY "" //fill with idividual firebase API key

// URL Firebase DataBase 
#define DATABASE_URL "" //fill with individual firebase url

#define LED_PIN 5 // PIN D1
#define BUTTON 4 // PIN D2
#define NUM_LEDS  11

CRGB leds[NUM_LEDS];

// Constants
static const char guid[] = "";//Fill with User UID for Firebase Authentication
static const String root = "/Users Data/";
static const String rootDevice = "/Device/";
static const char pathMode[] = "/mode";
static const char pathState[] = "/state";
static const char pathColor[] = "/color/value";

// Objects for communication with database
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

// Time equalization to polish time zone
const uint16_t timeOffset = 3600;

// NTP client objects
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org", timeOffset);

enum eventType { CHANGE_COLOR, TURN_ON, TURN_OFF };
enum modeType { ON,OFF, AUTO };

// Time of last modification
uint16_t alarmsLastModification = 0, eventsLastModification = 0;

// Current state of device
bool isTurnOnActual = false;
modeType modeActual = OFF;
unsigned int colorActual = 0;

// Variables for alarms handling
bool isAlarmActive = false;
uint32_t alarmFireTime;

// Variables used for reading data from eeprom and during server building
uint16_t statusCode;
const char* ssid = "text";
const char* passphrase = "text";
String html;

// Variable representing server
ESP8266WebServer server(80);

// Time of last button press
uint32_t previousMillis = 0;

// Flag set by interrupt
volatile bool userPressBt = false;

// Classes used
class Alarm {
  public:
  unsigned long color;
  uint16_t time;
  String id;
  bool isOnce;
  bool days[7];
  bool isExecuted = false;

  Alarm() {}

  friend bool operator== (const Alarm& left, const Alarm& right);

  virtual String toString(){
      return "Alarm : [Color: " + String(color) + ", time: " + String(time)  + ", isOnce: " + String(isOnce) +  ", if: " + id + "]";
    }
};

bool operator== (const Alarm& left, const Alarm& right)
{
	return left.id.compareTo(right.id) == 0;
}

class Event : public Alarm
{
  public:
  eventType type;

  friend bool operator== (const Event& left, const Event& right);

 String toString() override {
      return "Event : [Color: " +   String(color) +  ", type: " + String(type)+ ", time: " + String(time) + ", isOnce: " + String(isOnce) + ", if: " + id + "]";
    }
};

bool operator== (const Event& left, const Event& right)
{
	return left.id.compareTo(right.id) == 0;
}

// Lists of saved alarms and actions(events)
std::list <Alarm> alarms;
std::list <Event> events;

// Methods declarations
bool testWifi(void);
void turnHotSpotOn(void);
void setupAP(void);
void getFireBaseData();
bool isAnyAlarmsModification();
bool isAnyEventsModification();
void getAlarmsList();
void getAlarm(const char* id);
void getEventsList();
void getEvent(const char* id);
void parseJson(FirebaseJson json, bool isEvent = false);
void updateActualState();
inline const char* ToString(modeType value);
bool compareTimes (const Alarm& first, const Alarm& second);
bool checkUniqueTimes (const Alarm& first, const Alarm& second);
void performActions();
void performAlarm(Alarm& alarm);
void performEvent(Event& event);
void disableAlarm(Alarm& alarm);
void disableEvent(Event& event);

// Interrupt function
void IRAM_ATTR handleInterrupt() {

  // counteraction vibrations on button press
  if(millis() - previousMillis >= 500){

    if(isAlarmActive){
      isAlarmActive = false;
      turnOnLight(colorActual);
    }

    Serial.println("pressed");
    previousMillis = millis();
    if(modeActual == OFF){
      if(colorActual == 0) colorActual = 16777215;
      turnOnLight(colorActual);
      modeActual = ON;
    }
    else{
      turnOffLight();
      modeActual = OFF;
    }
      userPressBt = true;
  }
}

void setup()
{
  Serial.begin(115200);

  WiFi.disconnect(); // Disconnect from previously connected Wi-Fi
  EEPROM.begin(512); // Initializind EEPROM memory
  delay(10);

 // Read ssid i password from EEPROM
  String esid;
  for (uint8_t i = 0; i < 32; ++i)
    esid += char(EEPROM.read(i));

  String epass = "";
  for (uint8_t i = 32; i < 96; ++i)
    epass += char(EEPROM.read(i));

  WiFi.begin(esid.c_str(), epass.c_str());

  if (testWifi())
  {
    // Assign database secret
    config.api_key = API_KEY;

    // Assign database URL 
    config.database_url = DATABASE_URL;

    // Assign callback to long operation of token generation
    config.token_status_callback = tokenStatusCallback;

    // Assign database secret
    config.signer.tokens.legacy_token = API_KEY;

    Firebase.begin(&config, &auth);

    Firebase.reconnectWiFi(true);

    timeClient.begin();

    fbdo.setBSSLBufferSize(2048, 2048);

    FastLED.addLeds<WS2812, LED_PIN, GRB>(leds, NUM_LEDS);
    FastLED.setBrightness(40);
    pinMode(BUTTON, INPUT);
    attachInterrupt(digitalPinToInterrupt(BUTTON), handleInterrupt, FALLING);

    // turn off light in first loop
    turnOffLight();
    return;
  }
  else
  {
    // turnHotSpotOn();
    setupAP();// Setup HotSpot
  }
 
  while ((WiFi.status() != WL_CONNECTED))
  {
    Serial.print(".");
    delay(300);
    server.handleClient();
  }
}

void loop()
{
 if ((WiFi.status() == WL_CONNECTED))
  {
    if (Firebase.ready())
    {
      performActions();
      updateActualState();
      delay(500);  
    }
  }
}

void updateActualState(){
  Firebase.setString(fbdo, rootDevice + guid + pathMode,  ModeTypeToString(modeActual));
  Firebase.setString(fbdo, rootDevice + guid + pathState, isTurnOnActual ? "on" : "off");
  Firebase.setFloat(fbdo, rootDevice + guid + pathColor, colorActual);
}

void getFireBaseData(){
  if(isAnyAlarmsModification()){
    getAlarmsList();
  }
  if(isAnyEventsModification()){
    getEventsList();
  }
}

bool isAnyAlarmsModification(){
    String path = "/lastAlarmsModification";
    Firebase.getInt(fbdo, root + guid + path);
    uint16_t time =  fbdo.to<uint16_t>();
    if(time != alarmsLastModification) {
      alarmsLastModification = time;
      return true;
    }
    return false;
}

bool isAnyEventsModification(){
  String path = "/lastEventsModification";
  Firebase.getInt(fbdo, root + guid + path);
  uint16_t time =  fbdo.to<uint16_t>();
  if(time != eventsLastModification) {
    eventsLastModification = time;
    return true;
  }
  return false;
}

void getAlarmsList(){
  alarms.clear();

  Serial.printf("Get... %s\n", Firebase.getJSON(fbdo, root + guid + "/alarmsIDs") ? fbdo.to<FirebaseJson>().raw() : fbdo.errorReason().c_str());

  FirebaseJson jsonList =  fbdo.to<FirebaseJson>();
  size_t len = jsonList.iteratorBegin();
  FirebaseJson::IteratorValue value;
  for (size_t i = 0; i < len; i++)
  {
      value = jsonList.valueAt(i);
      getAlarm(value.key.c_str());
  }
}

void getAlarm(const char* id){
  Firebase.getJSON(fbdo, root + guid + "/alarms/" + id);
  parseJson(fbdo.to<FirebaseJson>());
}

void getEventsList(){
  events.clear();

  Serial.printf("Get... %s\n", Firebase.getJSON(fbdo, root + guid + "/eventsIDs") ? fbdo.to<FirebaseJson>().raw() : fbdo.errorReason().c_str());

  FirebaseJson jsonList =  fbdo.to<FirebaseJson>();
    size_t len = jsonList.iteratorBegin();
      FirebaseJson::IteratorValue value;
      for (size_t i = 0; i < len; i++)
      {
          value = jsonList.valueAt(i);
          getEvent(value.key.c_str());
      }
}

void getEvent(const char* id){
  Firebase.getJSON(fbdo, root + guid + "/events/" + id);
  parseJson(fbdo.to<FirebaseJson>(), true);
}

void parseJson(FirebaseJson json, bool isEvent){
    String id;
    eventType type;
    uint16_t time;
    unsigned long color;
    bool MN, TU, WD, TH, FR, ST, SU, state, isOnce;

    size_t len = json.iteratorBegin();
    FirebaseJson::IteratorValue value;
    for (size_t i = 0; i < len; i++)
    {
        value = json.valueAt(i);
        const char* key = value.key.c_str();
        const char* val = value.value.c_str();

        if( strcmp(key,"value") == 0){
          color = atoi(val);
        }
        else if( strcmp(key,"HandM") == 0){
          time = atoi(val);
        }
          else if( strcmp(key,"id") == 0){
          id = String(val);
        }
        else if( strcmp(key,"eventType") == 0){
          if(strcmp(val, "\"TurnOn\"") == 0){
            type = TURN_ON;
          }
          else if(strcmp(val, "\"TurnOff\"") == 0){
            type = TURN_OFF;
          }
          else if(strcmp(val, "\"ChangeColor\"") == 0){
            type = CHANGE_COLOR;
          }
        }
        else if( strcmp(key,"MN") == 0){
          MN = (strcmp(val,"true")==0)? 1:0;
        }
        else if( strcmp(key,"TU") == 0){
          TU = (strcmp(val,"true")==0)? 1:0;
        }
        else if( strcmp(key,"WD") == 0){
          WD = (strcmp(val,"true")==0)? 1:0;
        }
        else if( strcmp(key,"TH") == 0){
          TH = (strcmp(val,"true")==0)? 1:0;
        }
        else if( strcmp(key,"FR") == 0){
          FR = (strcmp(val,"true")==0)? 1:0;
        }
        else if( strcmp(key,"ST") == 0){
          ST = (strcmp(val,"true")==0)? 1:0;
        }
        else if( strcmp(key,"SU") == 0){
          SU = (strcmp(val,"true")==0)? 1:0;
        }
        else if( strcmp(key,"repeatMode") == 0){
          String value = String(val);
          if(value.compareTo("Once") == 0)
            isOnce = true;
          else
            isOnce = false; 
        }
        else if(!isEvent && strcmp(key,"state") == 0){
          Alarm alarm;
          alarm.id = id;
          alarm.time = time;
          alarm.isOnce = isOnce;
          alarm.color= color;
          alarm.days[0] = SU;
          alarm.days[1] = MN;
          alarm.days[2] = TU;
          alarm.days[3] = WD;
          alarm.days[4] = TH;
          alarm.days[5] = FR;
          alarm.days[6] = ST;
          Serial.println(alarm.toString());
          alarms.push_back(alarm);
        }
        else if(isEvent && strcmp(key,"state") == 0){
          Event event;
          event.id = id;
          event.time = time;
          event.isOnce = isOnce;
          event.color= color;
          event.type = type;
          event.days[0] = SU;
          event.days[1] = MN;
          event.days[2] = TU;
          event.days[3] = WD;
          event.days[4] = TH;
          event.days[5] = FR;
          event.days[6] = ST;
          Serial.println(event.toString());
          events.push_back(event);
        }
    }
}

void turnOnLight(unsigned long color){
  for (uint8_t i = 0; i < NUM_LEDS; i++) 
    leds[i] = CRGB (color);
    
  FastLED.show();
}

void turnOffLight(){
  turnOnLight(0);
}

void performActions(){
  //  Serial.printf("Get... %s\n", Firebase.getJSON(fbdo, root + guid + pathMode) ? fbdo.to<String>() : fbdo.errorReason().c_str());

  // Interrupt code run in normal code course
  if(userPressBt) {
    Firebase.setString(fbdo, root + guid + pathMode,  ModeTypeToString(modeActual));
    userPressBt = false;
    return;
  }

  // Download word mode
  Firebase.getString(fbdo, root + guid + pathMode);
  String mode = fbdo.to<String>();
  Serial.println(mode);

  // Execude code depending on work mode
 if(mode.compareTo("off") == 0){
    if(modeActual != OFF){
      turnOffLight();
      modeActual = OFF;
      colorActual = 0;
   }
    return;
 }
 else if(mode.compareTo("on") == 0){
    Firebase.getString(fbdo, root + guid + pathColor);
    String color = fbdo.to<String>();
    unsigned long colorTmp = std::atol(color.c_str());
    if(modeActual != ON || colorTmp != colorActual){
      modeActual = ON;
      colorActual = colorTmp;
      turnOnLight(colorActual);
    }
 }
 else if(mode.compareTo("auto") == 0){
  getFireBaseData();

  modeActual = AUTO;
 
  timeClient.update();

  uint16_t actualTime = timeClient.getHours() * 60 + timeClient.getMinutes();

  Serial.print("ActualTime: ");
  Serial.println(actualTime);

  if(isAlarmActive && millis() - alarmFireTime > 120000){
    isAlarmActive = false;
    turnOnLight(colorActual);
  }

  // Alarm list handling
  for(auto& alarm : alarms)
  {
    if( alarm.time == actualTime && alarm.days[timeClient.getDay()] && alarm.isExecuted == false ){ 
      performAlarm(alarm);
      break;
    }
    else if(alarm.time != actualTime && alarm.isExecuted == true) {
      alarm.isExecuted = false;
    }
  }

  // Action(event) list handling
  for(auto& event : events)
    {
      if(event.time == actualTime && event.days[timeClient.getDay()]){ 
      performEvent(event);
      break;
      }
    }
  }
}

void performAlarm(Alarm& alarm){
  Serial.println("Executing alarm hour" + String(alarm.time));
 
  alarm.isExecuted  = true;
  isAlarmActive = true;
  alarmFireTime = millis();
  
  turnOnLight(alarm.color);

  if(alarm.isOnce){
    disableAlarm(alarm);
  }
}

void performEvent(Event& event){
  Serial.println("Executing event hour" + String(event.time));

  if(event.type != TURN_OFF){
      colorActual = event.color;
      if(!isAlarmActive){
      turnOnLight(event.color);
    }
  } 
  else{
     colorActual = 0;

    if(!isAlarmActive){
     turnOffLight();
    }
  }
  if(event.isOnce){
    disableEvent(event);
  }
}

void disableAlarm(Alarm& alarm) {
		Serial.println("Turning off alarm");
    alarms.remove(alarm);
  	Firebase.setBool(fbdo, rootDevice + guid + "/alarms" + alarm.id + "/state", false);
   
}

void disableEvent(Event& event){
  	Serial.println("Turnng off event");
    events.remove(event);
  	Firebase.setBool(fbdo, rootDevice + guid + "/events" + event.id + "/state", false);
}

inline const char* ModeTypeToString(modeType value)
{
    switch (value)
    {
        case ON: return "on";
        case OFF: return "off";
        case AUTO: return "auto";
    }
}

bool compareTimes (const Alarm& first, const Alarm& second)
{
  return  first.time < second.time;
}

bool checkUniqueTimes (const Alarm& first, const Alarm& second)
{
   return  first.time == second.time;
}


bool testWifi()
{
  Serial.println("Attempting to connect to Wi-Fi");
  uint8_t attempt = 0;
  while (attempt < 20) {
    if (WiFi.status() == WL_CONNECTED)
    {
      return true;
    }
    delay(500);
    Serial.print("*");
    attempt++;
  }
  Serial.println("Timeout, creating AP");
  return false;
}
 
void turnHotSpotOn()
{
  if (WiFi.status() == WL_CONNECTED)
    Serial.println("Connected to Wi-Fi");

  Serial.print("Local IP: ");
  Serial.println(WiFi.localIP());
  Serial.print("SoftAP IP: ");
  Serial.println(WiFi.softAPIP());

  // Create server
  createWebServer();

  // Run server
  server.begin();
  Serial.println("Server started");
}
 
void setupAP(void)
{
  WiFi.mode(WIFI_STA);
  WiFi.disconnect();

  delay(100);

  WiFi.softAP("smartesp", "");
  Serial.println("softap");
  turnHotSpotOn();
}
 
void createWebServer()
{
    server.on("/", []() {
      html = "<!DOCTYPE HTML>\r\n<html>Enter ssid and Wi-Fi password<p></p> <form method='get' action='cred'><label>SSID: </label><input name='ssid' length=32><input name='pass' length=64><input type='submit'></form> </html>";
      server.send(200, "text/html", html);
    });

    server.on("/cred", []() {
      String argSSID = server.arg("ssid");
      String argPass = server.arg("pass");
      if (argSSID.length() > 0 && argPass.length() > 0) {

        // Cleaning eeprom
        for (uint8_t i = 0; i < 96; ++i) {
          EEPROM.write(i, 0);
        }

        // Saving to eeprom
        for (uint8_t i = 0; i < argSSID.length(); ++i)
        {
          EEPROM.write(i, argSSID[i]);
          Serial.println(argSSID[i]);
        }
        for (uint8_t i = 0; i < argPass.length(); ++i)
        {
          EEPROM.write(32 + i, argPass[i]);
          Serial.println(argPass[i]);
        }
        EEPROM.commit();
        html = "{\"Succes\":\" reset to boot into new Wi-Fi\"}";
        statusCode = 200;
        ESP.reset();
      } else {
        html = "{\"Error\":\"404 not found\"}";
        statusCode = 404;
        Serial.println("Sending 404");
      }
      server.sendHeader("Access-Control-Allow-Origin", "*");
      server.send(statusCode, "application/json", html);
 
    });
}
