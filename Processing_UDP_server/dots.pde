

void dotsInit()
{
  
  
}



void dotsDraw()
{
  loadPixels();
  for (int pixelCount = 0; pixelCount < width*height; pixelCount++)
  {                    
    float b = brightness(pixels[pixelCount]);
    b -= b * 0.01;
    pixels[pixelCount] =  color(b,b,b);
  }
  
  /*int i = (int)random(0,width);
  pixels[i] =  color(255,255,255);*/
  
  int gSize = 3;
  
  int canDraw = (int)random(0,10);
  if(canDraw != 0)
  {
    int r = (int)random(0,width);
    for(int i = r - gSize; i < r + gSize; i++)
    {
     if(i >= 0 && i < width)
     {
       color c = color(255,255,255);
       color b = pixels[i]; //color(0,0,0);
       
       pixels[i] =  lerpColor(c, b, map(abs(i - r), 0, gSize, 0.0, 1.0));
       
     }
    }
  }
  
  updatePixels();
  
  for(int x = 0; x < width; x++)
  {
    stroke(pixels[x]);
    line(x,1,x,height);
  }
}