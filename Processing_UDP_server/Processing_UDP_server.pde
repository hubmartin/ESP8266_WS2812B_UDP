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

int effect = 1;

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
    background(0);
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
 effect++; 
}

void effectPrev()
{
  effect--;
}

void effectSet(int i)
{
  effect = i;
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