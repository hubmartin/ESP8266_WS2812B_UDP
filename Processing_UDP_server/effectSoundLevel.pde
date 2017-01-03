

import ddf.minim.*;


public class EffectSoundLevel implements Effect
{
  
  Minim minim;
  AudioInput in;
  
  public String getName()
  {
    return "soundLevel";
  }

  public void init()
  {
      minim = new Minim(this);
      minim.debugOn();
      
      // get a line in from Minim, default bit depth is 16
      in = minim.getLineIn(Minim.STEREO, 512);
  }
  

  public void setParams(XML xml)
  {
    // test to change params
    //xml.setString("mode","color");
    //this.mode = xml.getString("mode");
  }
  
  
  public void draw()
  {
  
  
    background(0);
    
    stroke( 255 );
    
    // draw the waveforms
    // the values returned by left.get() and right.get() will be between -1 and 1,
    // so we need to scale them up to see the waveform
    // note that if the file is MONO, left.get() and right.get() will return the same value
    for(int i = 0; i < in.bufferSize() - 1; i++)
    {
      float x1 = map( i, 0, in.bufferSize(), 0, width );
      float x2 = map( i+1, 0, in.bufferSize(), 0, width );
      line( x1, 50 + in.left.get(i)*50, x2, 50 + in.left.get(i+1)*50 );
      line( x1, 150 + in.right.get(i)*50, x2, 150 + in.right.get(i+1)*50 );
    }
    
    noStroke();
    fill( 255 );
    
    // the value returned by the level method is the RMS (root-mean-square) 
    // value of the current buffer of audio.
    // see: http://en.wikipedia.org/wiki/Root_mean_square
    rect( 0, 0, in.left.level()*width, 100 );
    rect( 0, 100, in.right.level()*width, 100 );
    
    loadPixels();
  
  }
  
  
  

}

/*
void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop();
  super.stop();
}
*/