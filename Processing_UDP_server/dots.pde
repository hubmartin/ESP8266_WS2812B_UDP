

public class EffectDots implements Effect
{
  String mode;

  public void init()
  {
    
    
  }
  
  public String getName()
  {
    return "dots";
  }
  
  public void setParams(XML xml)
  {
    // test to change params
    //xml.setString("mode","color");
    
    this.mode = xml.getString("mode");
  }
  
  
  public void draw()
  {
     if(this.mode.equals("color"))
     {  
       this.drawColor();
     } else {
       this.drawBaw(); 
     }
  }
  
  // Effect made by user Ribster, looks great on christmas tree. Thanks
  public void drawColor()
  {
    loadPixels();
    
    for (int pixelCount = 0; pixelCount < width; pixelCount++)
    {                    
      float b = blue(pixels[pixelCount]);
      float r = red(pixels[pixelCount]);
      float g = green(pixels[pixelCount]);
      
      b -= b * 0.001;
      r -= r * 0.001;
      g -= g * 0.001;
      
      pixels[pixelCount] =  color(r,g,b);
    }
  
    
    int gSize = (int)random(2,10);
    
    int canDraw = (int)random(0,5);
    if((canDraw & 1) == 1)
    {
      int r = (int)random(0,width);
      color c = color((int)random(0,255),(int)random(0,255),(int)random(0,255));
      for(int i = r - gSize; i < r + gSize; i++)
      {
       if(i >= 0 && i < width)
       {
        color b = pixels[i];
        pixels[i] =  lerpColor(c, b, map(abs(i - r), 0, gSize, 0, 1));
       }
      }
    }
    
    updatePixels();
    
    /*
    for(int x = 0; x < width; x++)
    {
      stroke(pixels[x]);
      line(x,1,x,height);
    }*/
    
    // Copy first line to the whole screen to see the effect
    copy(0, 0, width, 1, 0, 1, width, height);
    
    
  }
  
  
  public void drawBaw()
  {
    loadPixels();
    
    for (int pixelCount = 0; pixelCount < width; pixelCount++)
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

}