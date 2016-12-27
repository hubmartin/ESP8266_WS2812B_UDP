/*

  This is Processing application to render and stream effect over UDP
  to the light devices. Right now the ESP8266 is supported.

  Author: Martin Hubacek
          martinhubacek.cz
          youtube.com/hubmartin
          @hubmartin
  
  License: MIT

*/

void setup() {
  
  // solve error libgles2-mesa
  // failed to open swrast
  // EGLGLXDrawableFactory
  size(900, 200, P2D);
  plasmaSetup();
  dotsInit();
  udpInit();
  
}

int effect = 0;

//process events
void draw() {
  switch(effect)
  {
   case 0: 
    plasmaDraw();
    break;
    
    case 1:
    dotsDraw();
    break;
    
    case 2:
    dotsDrawColor();
    break;
    
    case 3:
    background(255);
    break;
    
    case 4:
    background(255,0,0);
    break;
    
    case 5:
    background(0,255,0);
    break;
    
    case 6:
    background(0,0,255);
    break;
    
    case 7:
    // selected color
    break;
    
  }
  udpSend();
}

void colorSet(color c)
{
  effect = 7;
  background(c);
}

void effectNext()
{
  effectSet(effect + 1);
}

void effectPrev()
{
  effectSet(effect - 1);
}

void effectSet(int i)
{
  effect = i;
  println("Selected effect: " + effect);
}

void keyPressed()
{
 switch(key)
 {
    case '+':
    case 'a':
    effectNext();
    break;
    
    case '-':
    case 's':
    effectPrev();
    break;
 }
 
 
}