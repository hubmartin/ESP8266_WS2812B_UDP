# ESP8266_WS2812B_UDP
Light effects over network with Processing and ESP8266.

Distribute your Processing animation from your computer to different rooms/places.

Thanks to ESP8266 you can display effects on WS2812B LED strips which are rendered on your PC and transfered over WIFI UDP packets.

UDP packet has simple format:
- 1 byte command (0x01 - to write to LEDs)
- 2 byte little endian number of LEDs
- 3 byte RGB value per LED

ESP8266 desitnation port is 8000
