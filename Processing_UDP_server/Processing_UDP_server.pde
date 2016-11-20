/*
http://pixelinvaders.ch/?page_id=160
http://www.live-leds.de/features/ Jinx! – LED Matrix Control
http://www.lightjams.com/sacn.html
http://www.lightjams.com/getIt.html


*/



void setup() {
  size(900, 200);
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
    
  }
  udpSend();
}

void keyPressed()
{
 switch(key)
 {
    case 'a':
    effect++;
    break;
    
    case 's':
    effect--;
    break;
 }
 
 println(effect);
}