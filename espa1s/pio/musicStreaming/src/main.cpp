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

#define i2s_bit_clock_pin 14
#define i2s_word_select_pin 15 // word select or left-right clock
#define i2s_data_out_pin 22

Audio audio;

String radio_station_url;
String current_station;
String name;

FirebaseData fbdo;

//====================================================
// URLStream url(WIFI_SSID, WIFI_PASSWORD);

// AudioKitStream decoded_stream;

// EncodedAudioStream dec(&decoded_stream, new DecoderHelix()); // decoding stream to i2s format

// StreamCopy copy_url_stream(dec, url); // copy url to decoder
//==================================================

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

  audio.setVolume(20);

  audio.connecttohost(radio_station_url.c_str());
  //-------------------------------------------------------------

  //===========================================================

  // stream radio from url

  // setup i2s stream
  //audio_tools::AudioKitStreamConfig i2s_config = decoded_stream.defaultConfig(TX_MODE);

  //i2s_config.pin_ws = ; // set word select value
  //i2s_config.pin_bck = ; // set bit clock value
  //i2s_config.pin_data = ; // set data line

  //decoded_stream.begin(i2s_config);

  //dec.setNotifyAudioChange(decoded_stream);
  //dec.begin();

  //url.begin(radio_station_url.c_str());

  //url.begin("https://http-live.sr.se/p2musik-aac-192");

  //url.begin("http://stream.live.vc.bbcmedia.co.uk/bbc_world_service");

  //AudioLogger::instance().begin(Serial, AudioLogger::Info); // displaying audiodata to serial monitor
  //==================================================================================
}

void loop()
{
  audio.loop();

  //copy_url_stream.copy();
}