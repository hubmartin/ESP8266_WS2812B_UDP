

public interface Effect
{
  public void init();
  public void draw();
  
  public String getName();
  
  public void setParams(XML xml);
}

public class EffectManager
{
  
  int effectXMLIndex;
  int effectRealIndex;
  XML[] xmlEffect;
    
  private Effect[] effect;
  
   EffectManager(Effect[] effect)
   {
     this.effect = effect;
   }
  
  public void select(XML xml) 
  {
    
    
  }
  
  
  public void init()
  {
    // Load XML, fix to load only once
    XML xml = loadXML("config.xml");
    
    // Load list of effects
    xmlEffect = xml.getChildren("effects")[0].getChildren("effect");
        
    this.set(xml.getInt("defaultEffect"));
    
    // Init effects here  
    for(Effect e : this.effect)
    {
       e.init();
    }
  }
  
  public void draw()
  {
    effect[effectRealIndex].draw();
  }
  
  
  void next()
  {
    if(effectXMLIndex < xmlEffect.length - 1)
    {
      this.set(effectXMLIndex + 1);
    }
  }
  
  void prev()
  {
    if((effectXMLIndex) > 0)
    {
      this.set(effectXMLIndex - 1);
    }
  }
  
  void set(int effectIndex)
  {
    
    String efSearchName = xmlEffect[effectIndex].getString("name");
    
    println("Effect.set " + effectIndex + ", " + efSearchName);
    
    effectXMLIndex = effectIndex;
    
    int i = 0;
    for(Effect e : this.effect)
    {
       if(e.getName().equals(efSearchName))
       {
         println("Found: " + i);
         effectRealIndex = i;
         
         effect[effectRealIndex].setParams(xmlEffect[effectIndex]);
       }
       i++;
    }
    /*
    if(i >= 0 && i < effect.length) 
    {
      actualEffect = i;
    }*/
    
    //println("Selected effect: " + effectXMLIndex);
  }


  
  
  
  
}