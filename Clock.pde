class Clock {

  float hour, minutes, seconds;
  float x, y, d;
  PVector pos;
  boolean isMain;

  public Clock(float _x, float _y, float _width, int _hour, int _minutes, int _seconds, PVector _pos)
  {
    x = _x+width/8;
    y = _y+height/4;
    d = _width;
    hour = _hour;
    minutes = _minutes;
    seconds = _seconds;
    pos = _pos;
  }

  void update()
  {
    display();
  }

  void display()
  {
      // boitier du cadran
    pushMatrix();
    translate(x, y);
    noFill();
    stroke(50);
    strokeWeight(5);
    ellipse(0, 0, d, d);
    noFill();
    ellipse(0, 0, d+5, d+5);
    popMatrix();
    
   
    clockPins();
    //secPin(seconds);
    hourPin(hour);
    minPin(minutes);
    
    
  
  }

  

  void hourPin(float h)
  {
    pushMatrix();
    strokeCap(PROJECT);
    translate(x, y);
    rotate(radians(-90+(h*30)));
    strokeWeight(10);
    stroke(50);
    line(0, 0, d*0.3, 0);
    popMatrix();
  }

  void minPin(float m)
  {
    pushMatrix();
    strokeCap(PROJECT);
    translate(x, y);
    rotate(radians(-90+(m*6)));
    strokeWeight(10);
    line(0, 0, d*0.44, 0);
    popMatrix();
  }
  
  void secPin(float s)
  {
    pushMatrix();
    strokeCap(PROJECT);
    translate(x, y);
    rotate(radians(-90+(s*6)));
    stroke(255,0,0,100);
    strokeWeight(1);
    line(0, 0, d*0.44, 0);
    popMatrix();
  }

  void clockPins()
  {
    pushMatrix();

    translate(x, y);

    for (int i = 0; i < 12; i++)
    {
      strokeWeight(2);
      float x1 = (d/2)*cos(radians(i*30));
      float y1 = (d/2)*sin(radians(i*30));
      float x2 = (d*0.44)*cos(radians(i*30));
      float y2 = (d*0.44)*sin(radians(i*30));
      stroke(50);
      
      line(x2, y2, x1, y1);
    }
    popMatrix();
  }
}