/*

  This is Processing application to render and stream effect over UDP
  to the light devices. Right now the ESP8266 is supported.

  Author: Martin Hubacek
          martinhubacek.cz
          youtube.com/hubmartin
          @hubmartin
  
  License: MIT

*/


//
// Add new effect here, then add their string name to the <effects> element in data/config.xml
//
Effect[] effect = { new EffectPlasma(), new EffectDots() };


EffectManager em;

void setup() {
  
  // solve error libgles2-mesa
  // failed to open swrast
  // EGLGLXDrawableFactory
  size(900, 200, P2D);
    
  // Init ESP UDP streaming
  espLibInit();
  
  em = new EffectManager(effect);
  
  em.init();
  
}

int actualEffect = 0;

//process events
void draw() {
  
  em.draw();

  espLibSend();
}

void colorSet(color c)
{
  actualEffect = 7;
  background(c);
}

void keyPressed()
{
 switch(key)
 {
    case '+':
    case 'a':
    em.next();
    break;
    
    case '-':
    case 's':
    em.prev();
    break;
 }
 
 
}