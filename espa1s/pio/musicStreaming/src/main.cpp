//_________LIBRARIES____________________
/*
  https://github.com/schreibfaul1/ESP32-audioI2S

  https://github.com/mobizt/Firebase-ESP32
*/
//__________________________________

#include <secret.h>

#include <Arduino.h>

#include <WiFi.h>

#include <Wire.h>

#include <SoftwareSerial.h>

#include <base64.h>

#include <FirebaseESP32.h>

#include <stdio.h>

#include "Audio.h"

#define i2s_bit_clock_pin 14   // -1, 6, 26
#define i2s_word_select_pin 15 // -1, 7, 27 | word select or left-right clock
#define i2s_data_out_pin 22    // -1, 8, 28

Audio audio;

String radio_station_url;
String current_station;
String name;

FirebaseData fbdo;

void setup()
{
  WiFi.disconnect();

  WiFi.mode(WIFI_STA);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print('.');
    delay(10);
  }

  Firebase.begin(DATABASE_URL, API_KEY);

  Serial.begin(115200); // set baud rate

  Serial.println("hmm");

  name = Firebase.RTDB.get(&fbdo, ("/users/123/name")) ? fbdo.to<String>() : String("ajajaj");

  Serial.println(name);

  current_station = Firebase.RTDB.get(&fbdo, ("/currentStation")) ? fbdo.to<String>() : String("ajajaj");

  Serial.println(current_station);

  radio_station_url = Firebase.RTDB.get(&fbdo, (("/stations/" + current_station).c_str())) ? fbdo.to<String>() : String("ajajaj");

  Serial.println(radio_station_url);
  Serial.println(("/stations/" + current_station).c_str());

  //----------------------------AUDIO----STUFF---------------------------------
  audio.setPinout(i2s_bit_clock_pin, i2s_word_select_pin, i2s_data_out_pin);

  audio.setVolume(21);

  audio.connecttohost(radio_station_url.c_str());
  //-------------------------------------------------------------
}

void loop()
{
  audio.loop();
}