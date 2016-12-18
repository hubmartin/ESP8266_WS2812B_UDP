

// import UDP library
import hypermedia.net.*;
import mqtt.*;


public class NetworkDevice
{
   public String ip;
   public int ledCount;
   public PVector positionOffset;
   public PVector positionIncrement;
   
   public NetworkDevice(String ip, int ledCount, int y)
   {
     this.ip = ip;
     this.ledCount = ledCount;
     this.positionOffset = new PVector(0,y);
     this.positionIncrement = new PVector(2,0);
   }
}

ArrayList<NetworkDevice> deviceList = new ArrayList<NetworkDevice>();


UDP udp;  // define the UDP object
int port        = 8000;    // the destination port
    
MQTTClient client;

void mouseDragged()
{
  NetworkDevice device = deviceList.get(1);
  device.positionOffset.x = mouseX;
  device.positionOffset.y = mouseY;
}
    
void udpInit()
{
  udp = new UDP( this );
  //udp.listen( true );
 
  deviceList.add(new NetworkDevice("192.168.100.110", 267,0)); // obyvak
  deviceList.add(new NetworkDevice("192.168.100.111", 216,5)); // jidelna  
   deviceList.add(new NetworkDevice("192.168.100.100", 216,5)); // sklep test
  
  client = new MQTTClient(this);
  client.connect("mqtt://192.168.100.131", "processing");
  client.subscribe("/effect/#");
  
}

void messageReceived(String topic, byte[] payload) {
  
  if(topic.equals("/effect/next")) //<>// //<>//
    effectNext();
    
  if(topic.equals("/effect/prev"))
    effectPrev();
    
  if(topic.equals("/effect/set"))
  {
    effectSet(Integer.parseInt(new String(payload)));
  }
  
  if(topic.equals("/effect/rgb"))
  {
    colorSet(unhex((new String(payload)).replace("#","")));
  }
    
  println("new message: ." + topic + ". - " + new String(payload));
}
    
void udpSend()
{
  
    for(NetworkDevice device : deviceList)
{
  
  color pix[] = new color[device.ledCount];
   
  for(int i = 0; i < pix.length; i++)
  {
      //pix[i] = pixels[i * 5];
      float x = device.positionOffset.x + device.positionIncrement.x * i;
      float y = device.positionOffset.y + device.positionIncrement.y * i;
      pix[i] = get((int)x, (int)y);
      //noFill();
      ellipse(x, y + 10, 2, 2);
  }
  
  sendData(device, pix);
  
  }
  
}

void sendData(NetworkDevice device, color[] dataPixels)
{
  
  
  byte header[] = new byte[] {0x01, ((byte)(dataPixels.length/256)), (byte)dataPixels.length};
  
  // RGB array
  byte data[] = new byte[dataPixels.length * 3];
  
  byte brightnessDiv = 10; 
  
  for(int i = 0; i < dataPixels.length; i++)
  {
    color black = color(0,0,0);
    color srcColor = lerpColor(black,dataPixels[i] , .2);
    data[i*3 + 0] = ((byte)red(srcColor));
    data[i*3 + 1] = ((byte)green(srcColor));
    data[i*3 + 2] = ((byte)blue(srcColor));
  }
  
  byte[] byteSend = new byte[header.length + data.length];
  System.arraycopy(header, 0, byteSend, 0, header.length);
  System.arraycopy(data, 0, byteSend, header.length, data.length);
  
    udp.send( byteSend, device.ip , port );
}

/**
 * To perform any action on datagram reception, you need to implement this 
 * handler in your code. This method will be automatically called by the UDP 
 * object each time he receive a nonnull message.
 * By default, this method have just one argument (the received message as 
 * byte[] array), but in addition, two arguments (representing in order the 
 * sender IP address and his port) can be set like below.
 */
// void receive( byte[] data ) {       // <-- default handler
void receive( byte[] data, String ip, int port ) {  // <-- extended handler
  
  
  // get the "real" message =
  // forget the ";\n" at the end <-- !!! only for a communication with Pd !!!
  data = subset(data, 0, data.length-2);
  String message = new String( data );
  
  // print the result
  println( "receive: \""+message+"\" from "+ip+" on port "+port );
}