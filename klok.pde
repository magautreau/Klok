// magautreau(arobas)gmail(point)com
// Marc-Antoine Gautreau
// Projet : Kloks
// Date : 2017-12-11


String ttime, tdate, tweather;
Visual v;
ArrayList<Clock> clocks = new ArrayList<Clock>();
int d, dens, cw, ch, spc, tx, ty;
Weather weather;
PFont font;
int fontSize = 70;

void setup()
{
  size(1280, 720);
  v = new Visual(clocks);
  font = createFont("OpenSans-Regular.ttf", fontSize);
  weather = new Weather("Venise", "c"); // Ville, Unité de température (c ou f)

  //Paramètres d'emplacement des cadrans
  d = 100; // diamètre
  spc = 10; // Espacement
  cw = width-tx; //Centre largeur
  ch = height-ty; //Centre hauteur

  for (int x  = 0; x < 8; x++)
  {
    for (int y  = 0; y < 3; y++)
    {
      //int _x = (x*(d+spc))+((d+spc)/2);
      //int _y = (y*(d+spc))+((d+spc)/2);
      int centerFactor = (width-8*(d+spc))/2;
      int _x = x*(d+spc)-(d+spc)+centerFactor;
      int _y = y*(d+spc);

      clocks.add(new Clock(_x, _y, d, hour(), minute(), second(), new PVector(x, y)));
    }
  }
  
}


void draw()
{ 
  v.update();
  showInfos();  
}


void showInfos()
{
  noStroke();
  fill(20);
  rect(0,height-height/4,width,height/4);
  fill(250);
  textAlign(CENTER);
  textSize(40);
  textFont(font, 32);
  String begining = "Il fait ";
  String temperature = weather.getTemperature()+"\u00b0"+"C";
  String location = weather.getCityName(); 
  text(begining + temperature + " à " + location, width/2, height-(height/8));  
}