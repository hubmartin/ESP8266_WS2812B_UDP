

// import UDP library
import hypermedia.net.*;


UDP udp;  // define the UDP object
    String ip       = "192.168.100.106";  // the remote IP address
    int port        = 8000;    // the destination port
    
    
    
void udpInit()
{
    udp = new UDP( this, 6000 );
  //udp.log( true );     // <-- printout the connection activity
  udp.listen( true );
}
    
void udpSend()
{
  color pix[] = new color[267];
   
  for(int i = 0; i < pix.length; i++)
  {
      //pix[i] = pixels[i * 5];
      int x = 1 * i;
      int y = 0;
      pix[i] = get(x, y);
      //noFill();
      //ellipse(x, y, 2, 2);
  }
  
  sendData(pix);
  
}

void sendData(color[] dataPixels)
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
  
  udp.send( byteSend, ip, port );
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