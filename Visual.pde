class Visual {

  int index;
  boolean hasWeather, hasFeed;
  String ttime;
  String tdate;
  int cx = width/2; //center X
  int cy = height/2; //center Y
  ArrayList<Clock> tab;
  ArrayList<PVector> timeTab;
  boolean analogMode = true;
  int pas = 0, nbPas = 100;
  float moteur;
  Table table;
  String timeString;
  int[] timeShow;
  int time,startSec,ms,currentSecond;
  float inH, inM, outM, outH;
  int lastTime;
  float refTime;
  float animSpeed = 0.0002; //Vitesse de l'animation des aiguilles
  boolean isNewTime = false;

  public Visual(ArrayList<Clock> _tab)
  {
    currentSecond = 0;
    startSec = second()*1000;
    tab = _tab;
    timeTab = new ArrayList<PVector>();
    table = loadTable("numtab.csv");
    println("csv file loaded.... "+table.getColumnCount()+" col "+table.getRowCount()+" rows");
    timeShow = getTime();
    lastTime = time;
  }

  void update()
  {
    display();
  }
  //Initialise les visuels
  void display()
  {

    background(250);
    drawSeconds();
    //Mettre à jour chaque cadran
    for (int i = 0; i < tab.size(); i++)
    {
      tab.get(i).update();
    }

    //Moteur d'animation
    if (millis()*animSpeed-refTime <= 1)
    {
      moteur = millis()*animSpeed-refTime;
    } else
    {
      moteur = 1;
    }


    timeShow = getTime();

    //Animation des cadrans
    if (time != lastTime)
    {
      moteur = 0;
      refTime = millis()*animSpeed;
      lastTime =  time;
      isNewTime = true;
    } else
    {
      for (int i = 0; i< 24; i++)
      {
        int index = i%6;
        if (!isNewTime)
        {
          inH = -24;
          inM = 25;
          outH = getTimeWithPositon(index, timeShow[i/6]).x;
          outM = getTimeWithPositon(index, timeShow[i/6]).y;
        } else
        {
          outH = getTimeWithPositon(index, timeShow[i/6]).x+12;
          outM = getTimeWithPositon(index, timeShow[i/6]).y+120;
          inH = getTimeWithPositon(index, timeShow[i/6]).x;
          inM = getTimeWithPositon(index, timeShow[i/6]).y;
        }

        tab.get(i).hour = lerp(inH, outH, moteur);
        tab.get(i).minutes = lerp(inM, outM, moteur);
        tab.get(i).seconds = second();
      }
    }
  }

  //Retourne le temps dans un tableau de quatre (4) espaces (ex: [0400] pour 04:00)
  int[] getTime()
  {

    String[] hourTab = String.valueOf(hour()).split("");
    String[] minTab = String.valueOf(minute()).split("");
    int[] timeTab = new int[4];

    if (hourTab.length < 2)
    {
      String temp = hourTab[0];
      hourTab = new String[] {"0", temp};
    } else
    {
    }

    if (minTab.length < 2)
    {
      String temp = minTab[0];
      minTab = new String[] {"0", temp};
    } else
    {
    }

    for (int i = 0; i < 4; i++)
    {
      if (i < 2)
      {
        timeTab[i] = Integer.parseInt(hourTab[i]);
      } else
      {
        timeTab[i] = Integer.parseInt(minTab[i-2]);
      }
    }
    time = Integer.parseInt(hourTab[0]+hourTab[1]+minTab[0]+minTab[1]);
    return timeTab;
  }


  // PAS UTILISÉ
  //Écrit le temps
  //void drawTime(float tx, float ty, int alpha)
  //{
  //  String min = String.valueOf(minute());
  //  String h = String.valueOf(hour());
  //  if (min.length() < 2)
  //  {
  //    min = "0"+min;
  //  }
  //  if (h.length() < 2)
  //  {
  //    h = "0"+min;
  //  }
  //  ttime = h+":"+min;
  //  tdate =  day()+"/"+month()+"/"+year();
  //  pushMatrix();

  //  textFont(font);
  //  textAlign(CENTER, CENTER);
  //  fill(255, alpha);
  //  text(ttime, cx+tx, cy+tx);
  //  popMatrix();
  //}


  //Retourne un index avec le temps correspondant à un cadran
  PVector getTimeWithPositon(int index, int num)
  {
    String timeString = table.getString(num, index);
    String[] timeTab = split(timeString, ".");
    PVector vTime = new PVector(Integer.parseInt(timeTab[0]), Integer.parseInt(timeTab[1]));


    return new PVector(vTime.x, vTime.y);
  }

  void drawSeconds()
  {
    pushMatrix();
    stroke(20);
    strokeWeight(10);
    ms = (millis()+startSec)-currentSecond;
    if(ms >= 60000)
    {
      currentSecond+=60000;
    }
 
    line(0, 0, map(ms,0,60000,0,width), 0);
    popMatrix();
  }
}