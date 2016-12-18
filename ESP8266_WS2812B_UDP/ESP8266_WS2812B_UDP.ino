

#include <ESP8266WiFi.h>
#include <WiFiUdp.h>
#include <Adafruit_NeoPixel.h>

#include <ArduinoOTA.h>

// Create your config file with WIFI_SSID and WIFI_PASS
#include "config.h"

//#include <OneWire.h>
//#include <DallasTemperature.h>
//OneWire oneWire(D1); // D1 pin
//DallasTemperature DS18B20(&oneWire);

uint32_t actColor = 0x22222222;

const char* ssid = WIFI_SSID;
const char* password = WIFI_PASS;

#define BTN_DEBUG D1

#define LED_BLUE 2
#define LED_RED LED_BUILTIN

#ifndef D7
  #define D7 0
#endif

#define PIN            D6
#define NUMPIXELS     144*3
Adafruit_NeoPixel pixels = Adafruit_NeoPixel(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

WiFiUDP Udp;
unsigned int localUdpPort = 8000;
char udpInPacket[2048];
char  replyPacket[] = "Hi there! Got the message :-)";


void WIFI_Connect()
{
  digitalWrite(LED_RED, LOW);
  WiFi.disconnect();
  
// Connect to WiFi network
  Serial.println();
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  //WiFi.mode(WIFI_AP_STA);
  WiFi.begin(ssid, password);
    // Wait for connection
  for (int i = 0; i < 25; i++)
  {
    if ( WiFi.status() != WL_CONNECTED ) {
      delay ( 250 );
      digitalWrite(LED_RED, LOW);
      Serial.print ( "." );
      delay ( 250 );
      digitalWrite(LED_RED, HIGH);
    }
  }
  digitalWrite(LED_RED, HIGH);

  Serial.println("");
  Serial.println("WiFi connected");
// Print the IP address
  Serial.println(WiFi.localIP());
}

void setup() {
  Serial.begin(115200);
  delay(10);

  pinMode(LED_BUILTIN, OUTPUT);

  // prepare GPIO2
  pinMode(LED_BLUE, OUTPUT);
  digitalWrite(LED_BLUE, LOW);
  
  WIFI_Connect();

  digitalWrite(LED_BLUE, HIGH);
  

  Udp.begin(localUdpPort);

  ArduinoOTA.begin();

  pixels.begin();

  
  pinMode ( BTN_DEBUG, INPUT_PULLUP );
}

int fpsCounter = 0;
int secondTimer = 0;

int redLedTimer = 0;

void loop() {

  if(digitalRead(BTN_DEBUG) == LOW)
  {
    Serial.println("Btn disconnect");
    WiFi.disconnect();
  }
  
  if (WiFi.status() != WL_CONNECTED)
  {
    WIFI_Connect();
  }

  ArduinoOTA.handle();

  int packetSize = Udp.parsePacket();
  
  if (packetSize)
  {
    //Serial.printf("Received %d bytes from %s, port %d\n", packetSize, Udp.remoteIP().toString().c_str(), Udp.remotePort());
    int len = Udp.read(udpInPacket, sizeof(udpInPacket));

    // Set color command
    if(udpInPacket[0] == 0x01)
    {
      int inNumPixels;
      inNumPixels  = udpInPacket[1] << 8;
      inNumPixels |= udpInPacket[2];
      //Serial.printf("SetCmd numPix:%d\n", inNumPixels);
      Serial.print("/");

      pixels.updateLength(inNumPixels);

      for(int i = 0; i < inNumPixels; i++)
      {
        uint32_t pixelColor = pixels.Color(udpInPacket[3 + i*3 + 0], udpInPacket[3 + i*3 + 1], udpInPacket[3 + i*3 + 2]);
        pixels.setPixelColor(i, pixelColor);
      }

      pixels.show();

    }


    // UDP reply command
    if(udpInPacket[0] == 0xff)
    {
      Udp.beginPacket(Udp.remoteIP(), Udp.remotePort());
      Udp.write(replyPacket);
      Udp.endPacket();
    }
    
    //Serial.printf("UDP in len: %d\n", len);
    fpsCounter++;
    
  }


  if(millis() - secondTimer >= 1000)
  {
    secondTimer = millis();

    // Blink red led if packets are comming
    if(fpsCounter > 0)
    {
      digitalWrite(LED_RED, LOW);
      redLedTimer = secondTimer;
    }

    Serial.printf("FPS: %d\n", fpsCounter);
    fpsCounter = 0;
  }

  // Turn RED LED off after few ms
  if(redLedTimer && millis() - redLedTimer >= 2)
  {
    redLedTimer = 0;
    digitalWrite(LED_RED, HIGH);
  }
  

}

