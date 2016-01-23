/*
  Coded by Paul Damon
  All GUI stufF goes here
*/


//Imports

class GUIManager{

    //___________________________________Variable Declaration___________________________________//
    //Variables go here
    
    //Device declaration
    Gui_Device lamp;
    Gui_Device indoor_lamp;
    Gui_Device timerT1;
    Gui_Device timerT2;
    Gui_Device heater1;
    Gui_Device heater2;
    Gui_Device burglar_alarm_lamp;
    Gui_Device flkt;
    
    //Input devices
    Gui_Device fireAlarm;
    Gui_Device waterLeak;
    Gui_Device oven;
    Gui_Device window;
    Gui_Device blackOut;
    
    //Virtual devices
    Gui_Device coffeeMachine;
    Gui_Device VM1;
    Gui_Device VM2;
    
    //Analog devices
    Gui_Device energyMeter;
    Gui_Device thermometer;
    Gui_Device thermometerOut;
    
    PFont f;
    //Add rest of the items and arrange them so they look nice


    //_______________________________________Constructors_______________________________________//
    //Constructors go here
    GUIManager(){
      
      f = createFont("Arial",10,true);
      
      textContainer();
      
      //Device Definitions
      
      //Digital Devices
      lamp = new Gui_Device("Lamp", 1, 15,75);
      indoor_lamp = new Gui_Device("Indoor Lamp",1,15,125);
      timerT1 = new Gui_Device("Timer T1",1,150,75);
      timerT2 = new Gui_Device("Timer T2",1,150,125);
      heater1 = new Gui_Device("Heater(1)",1,275,75);
      heater2 = new Gui_Device("Heater(2)",1,275,125);
      burglar_alarm_lamp = new Gui_Device("Burglar alarm",1,400,75);
      flkt = new Gui_Device("Fan", 1, 400, 125);
      
      //Input devices
      window = new Gui_Device("Window", 1, 15, 550);
      fireAlarm = new Gui_Device("Fire Alarm", 1, 150,550);
      oven = new Gui_Device("Oven", 1, 275, 550);
      waterLeak = new Gui_Device("Water Leak",1,400,550);
      blackOut = new Gui_Device("Power outage", 1, 15, 600);
      
      
      //Virtual devices
      coffeeMachine = new Gui_Device("Coffee", 1,15,400);
      VM1 = new Gui_Device("Hot Tub",1, 150, 400);
      VM2 = new Gui_Device("Microwave",1, 275, 400);
      
      
      //Analog Devices
      energyMeter = new Gui_Device("Energy\nConsumption", 2, 15, 250);
      thermometer = new Gui_Device("Temperature\nIndoor", 2, 150, 250);
      thermometerOut = new Gui_Device("Temperature\nOutdoor", 2, 275, 250);
      
    }

    //____________________________________Method Declaration____________________________________//
    //Methods go here
    
    void updateGUI(){
      //updates what is shown on screen
      
      textContainer();
      
      lamp.drawStatus();
      indoor_lamp.drawStatus();
      timerT1.drawStatus();
      timerT2.drawStatus();
      heater1.drawStatus();
      heater2.drawStatus();
      burglar_alarm_lamp.drawStatus();
      flkt.drawStatus();
      
      //Virtual devices
      coffeeMachine.drawStatus();
      VM1.drawStatus();
      VM2.drawStatus();
      
      //Analog
      energyMeter.drawStatus();
      thermometer.drawStatus();
      thermometerOut.drawStatus();
      
      //Digital inputs
      fireAlarm.drawStatus();
      waterLeak.drawStatus();
      oven.drawStatus();
      window.drawStatus();
      blackOut.drawStatus();
      
    }
    
    void textContainer(){
      
      //Digital devices
      textFont(f,25);
      fill(0);
      text("Digital Devices", 250, 25);
      
      text("Analog Devices", 250, 225);
      
      text("Virtual Devices", 250, 350);
      
      text("Input Devices", 250, 500);
    }
}