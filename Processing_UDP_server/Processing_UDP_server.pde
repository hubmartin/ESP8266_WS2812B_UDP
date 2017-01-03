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
Effect[] effect = { new EffectPlasma(), new EffectDots(), new EffectSoundLevel() };


EffectManager em;





void setup() {
  
  // solve error libgles2-mesa
  // failed to open swrast
  // EGLGLXDrawableFactory
  size(900, 200, P2D);
  
  frameRate(25);
    
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
  
    //background(0);
  // draw the waveforms
  /*
  for(int i = 0; i < in.bufferSize() - 1; i++)
  {
    stroke((1+in.left.get(i))*50,100,100);
    line(i, 50 + in.left.get(i)*50, i+1, 50 + in.left.get(i+1)*50);
    stroke(white);
    line(i, 150 + in.right.get(i)*50, i+1, 150 + in.right.get(i+1)*50);
  }*/
  
  
  
  
  //println(in.getGain());  
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