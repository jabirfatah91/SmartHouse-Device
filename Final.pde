/*
  Coded by Paul Damon,
           Jabir Al Fatah
           Liaquath Hassan
          
  All Main code goes here
*/

//Imports
import processing.net.*; 
import processing.serial.*;
import cc.arduino.*;
import java.net.HttpURLConnection;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.net.MalformedURLException;
import java.io.IOException;

//Variable declaration/definition
int B0 = 8;
int B3 = 11;
int B4 = 12;
int B5 = 13;
int nrgConsumption = 0;
int therm = 1;
int thermOut = 2;
int LDRPin = 3;
float temp = 0;
float nrg = 0;
float tempOut = 0;
float LDR = 0;
String temp_URL;
String [] json;
String upload_URL;
//TODO
//All variables that we need should be listed here ASAP

ClientSide client;
DeviceManager DM;
GUIManager gui;

//Arduino board declaration
Arduino arduino;


void setup() { 
  
  //Display size
  size(650, 650);

  //Arduino Definition
  arduino = new Arduino(this, Arduino.list()[1], 57600);

  client = new ClientSide();;
  DM = new DeviceManager();
  gui = new GUIManager();

  delay(1000);
}

void draw() {  
  
  //Set background color
  background(127);  
  
  //client.retrieveData();
  
  //delay
  delay(1000);
  
  //Check for changes on analgo and digital inputs
  //DM.checkDI();
  //DM.checkAI();
  
  //update GUI
  gui.updateGUI();
  
}

//_______________________METHOD DECLARATION/DEFINITION___________________________//