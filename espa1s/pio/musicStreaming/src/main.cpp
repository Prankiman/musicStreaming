//_________LIBRARIES____________________
/*
  https://github.com/pschatzmann/arduino-audio-tools

  https://github.com/pschatzmann/arduino-audiokit

  https://github.com/mobizt/Firebase-ESP32
*/
//__________________________________

//#include <AudioKitHAL.h>
#include <secret.h>

#include <Arduino.h>

#include <Wifi.h>

#include <Wire.h>

#include <SoftwareSerial.h>

#include <base64.h>

#include <AudioTools.h>

#include <AudioCodecs/CodecMP3Helix.h>

#include "AudioLibs/AudioKit.h"

#include <FirebaseESP32.h>

URLStream url(WIFI_SSID, WIFI_PASS);
//I2SStream decoded_stream;
AudioKitStream decoded_stream;

EncodedAudioStream dec(&decoded_stream, new MP3DecoderHelix()); // decoding stream to i2s format
StreamCopy copy_url_stream(dec, url);                           // copy url to decoder

void setup()
{
  pinMode(2, OUTPUT);
  Serial.begin(115200); // set baud rate

  Serial.println("hmm");

  AudioLogger::instance().begin(Serial, AudioLogger::Info); // displaying audiodata to serial monitor

  // setup i2s stream
  auto i2s_config = decoded_stream.defaultConfig(TX_MODE);

  //i2s_config.pin_ws = ; // set word select value
  //i2s_config.pin_bck = ; // set bit clock value
  //i2s_config.pin_data = 12; // set data line

  decoded_stream.begin(i2s_config);

  //dec.setNotifyAudioChange(decoded_stream);
  dec.begin();

  // stream radio from url

  //url.begin("https://http-live.sr.se/p3-aac-192");
  url.begin("https://stream.live.vc.bbcmedia.co.uk/bbc_world_service", "audio/mp3");
}

void loop()
{
  digitalWrite(2, HIGH); // turn the LED on (HIGH is the voltage level)
  //delay(1000);           // wait for a second
  digitalWrite(2, LOW);
  Serial.println("hum");
  copy_url_stream.copy();
}
