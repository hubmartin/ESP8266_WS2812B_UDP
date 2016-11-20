

#include <ESP8266WiFi.h>
#include <WiFiUdp.h>

#include <Adafruit_NeoPixel.h>

//#include <OneWire.h>
//#include <DallasTemperature.h>
//OneWire oneWire(D1); // D1 pin
//DallasTemperature DS18B20(&oneWire);

uint32_t actColor = 0x22222222;

const char* ssid = "Internet";
const char* password = "heslojeheslo";

#define PIN            D7
#define NUMPIXELS     144*3
Adafruit_NeoPixel pixels = Adafruit_NeoPixel(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

WiFiUDP Udp;
unsigned int localUdpPort = 8000;
char udpInPacket[2048];
char  replyPacket[] = "Hi there! Got the message :-)";

void setup() {
  Serial.begin(115200);
  delay(10);

  // prepare GPIO2
  pinMode(2, OUTPUT);
  digitalWrite(2, 0);
  
  // Connect to WiFi network
  Serial.println();
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);
  
  WiFi.begin(ssid, password);
  
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");


  // Print the IP address
  Serial.println(WiFi.localIP());

  Udp.begin(localUdpPort);

  pixels.begin();
}

int fpsCounter = 0;
int secondTimer = 0;

void loop() {


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
      Serial.printf("Set color command, numpixels %d\n", inNumPixels);

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

    Serial.printf("FPS: %d\n", fpsCounter);
    fpsCounter = 0;
  }

}

