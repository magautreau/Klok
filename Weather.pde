import java.net.HttpURLConnection;
import java.net.URL;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Date;

//*********** MODIFIÉ PAR MARC-ANTOINE GAUTREAU *************

/*
* Depuis décembre 2016, les requêtes XML pour la météo sur Yahoo Weather RSS ont été discontinués
* La présente librairie est donc inutilisable sans modifications
* J'ai converti les requètes XML RSS en requètes YQL avec query.yahooapis.com
* Ajustements des selecteurs .getChild() pour corriger la selection d'enfants
*/

//************************************************************


//Basé sur le code déjà en place de
/*
 *
 * Project: Yahoo Weather for Processing
 * Author: delvedor
 * Twitter: @delvedor
 * License: GNU GPLv2
 * GitHub: https://github.com/delvedor/YahooWeatherProcessing
 *
 */

class Weather {

  private XML root;
  private XML channel;
  private boolean reachable;
  private int code;
  private String loc;
  private String tempUnit;

  //---- Modifié -----------------------
  String query;
  String fullUrlStr;
  private String baseUrl = "http://query.yahooapis.com/v1/public/yql?q=";
  private final static String  URL = "https://query.yahooapis.com";
  //-----------------------------------


  private final static int TIMEOUT = 5000;

  public Weather(String _loc, String tempUnit) {
    //---- Modifié -----------------------
    this.loc = _loc; //Un String avec la requête pour déterminer la météo
    this.tempUnit = tempUnit;
    reachable = checkConnection();
    query = "select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\""+this.loc+"\") and u=\""+tempUnit+"\"";

    try {
      fullUrlStr = baseUrl + URLEncoder.encode(query, "UTF-8") + "&format=xml";
    }
    catch (UnsupportedEncodingException e) {
      print("UnsupportedEncodingException");
    }
    if (reachable) {

      root = loadXML(fullUrlStr); //String de l'URL pour la requête corrigé
    } else {
      root = loadXML("error.xml"); //Fichier erreur original
    }
   

    channel = root.getChild("results").getChild("channel"); //Ajout de .getChild("results") avant le channel pour corriger l'erreur de selecteur
    
     //-----------------------------------
  }

  /*
   * General methods
   */
  public boolean checkConnection() {
    try {
      HttpURLConnection connection = (HttpURLConnection) new URL(URL).openConnection();
      connection.setConnectTimeout(TIMEOUT);
      connection.setReadTimeout(TIMEOUT);
      connection.setRequestMethod("HEAD");
      int responseCode = connection.getResponseCode();
      return (200 <= responseCode && responseCode <= 399);
    } 
    catch (IOException exception) {
      return false;
    }
  }

  public void update() {
    reachable = checkConnection();

    if (reachable) {
      root = loadXML(fullUrlStr);
    } else {
      root = loadXML("error.xml");
    }

    channel = root.getChild("results").getChild("channel");
  }

  public String lastUpdate() {
    Date date = new Date();
    return date.toString();
  }

  /*
   * Today
   */
  public String getCityName() {
    return channel.getChild("yweather:location").getString("city");
  }

  public String getCountryName() {
    return channel.getChild("yweather:location").getString("country");
  }

  public String getWeatherCondition() {
    return channel.getChild("item").getChild("yweather:condition").getString("text");
  }

  public String getSunrise() {
    return channel.getChild("yweather:astronomy").getString("sunrise");
  }

  public String getSunset() {
    return channel.getChild("yweather:astronomy").getString("sunset");
  }

  public float getPressure() {
    return channel.getChild("yweather:atmosphere").getFloat("pressure");
  }

  public int getHumidity() {
    return channel.getChild("yweather:atmosphere").getInt("humidity");
  }

  public int getTemperature() {
    return channel.getChild("item").getChild("yweather:condition").getInt("temp");
  }

  public int getWeatherConditionCode() {
    return channel.getChild("item").getChild("yweather:condition").getInt("code");
  }

  public int getTemperatureLow() {
    return channel.getChild("item").getChild(15).getInt("low");
  }

  public int getTemperatureHigh() {
    return channel.getChild("item").getChild(15).getInt("high");
  }

  public String getWeekday() {
    return channel.getChild("item").getChild(15).getString("day");
  }

  /*
   * Tomorrow
   */
  public int getTemperatureLowTomorrow() {
    return channel.getChild("item").getChild(17).getInt("low");
  }

  public int getTemperatureHighTomorrow() {
    return channel.getChild("item").getChild(17).getInt("high");
  }


  public String getWeatherConditionTomorrow() {
    return channel.getChild("item").getChild(17).getString("text");
  }

  public int getWeatherConditionCodeTomorrow() {
    return channel.getChild("item").getChild(17).getInt("code");
  }


  public String getWeekdayTomorrow() {
    return channel.getChild("item").getChild(17).getString("day");
  }

  /*
   * Day After Tomorrow
   */
  public int getTemperatureLowDayAfterTomorrow() {
    return channel.getChild("item").getChild(19).getInt("low");
  }

  public int getTemperatureHighDayAfterTomorrow() {
    return channel.getChild("item").getChild(19).getInt("high");
  }


  public String getWeatherConditionDayAfterTomorrow() {
    return channel.getChild("item").getChild(19).getString("text");
  }

  public int getWeatherConditionCodeDayAfterTomorrow() {
    return channel.getChild("item").getChild(19).getInt("code");
  }


  public String getWeekdayDayAfterTomorrow() {
    return channel.getChild("item").getChild(19).getString("day");
  }
}