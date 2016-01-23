/*
  Coded by Paul Damon
  All Arduino stufF goes here
*/

//Imports

class DeviceManager{

    //___________________________________Variable Declaration___________________________________//
    //Variables go here
    int buttonOld;
    int [] buttonStates;
    boolean [] deviceStates;
    
    int flkt;
    int del;
    boolean alarmBool;
    
    
    
    //_______________________________________Constructors_______________________________________//
    //Constructors go here
    DeviceManager(){
      
      buttonOld = 0;
      buttonStates = new int[8];
      deviceStates = new boolean[11];
      flkt = 10;
      del = 500;
      alarmBool = false;
      setPins();
      fillArrays();
      
    }

    //____________________________________Method Declaration____________________________________//
    //Methods go here
   
    
  void setPins(){
  
    //Set pinmodes; outputs
    arduino.pinMode(B0,Arduino.OUTPUT);
    arduino.pinMode(B3,Arduino.OUTPUT);
    arduino.pinMode(B4,Arduino.OUTPUT);
    arduino.pinMode(B5,Arduino.OUTPUT);
    arduino.pinMode(flkt, Arduino.OUTPUT);
    
    //set pinModes Inputs
    for(int i = 2; i<7;i++){
      
      arduino.pinMode(i, Arduino.INPUT);
      
    }
  
}

  void fillArrays(){
    
    for(int i = 0; i < buttonStates.length-1; i++){
      buttonStates[i] = arduino.digitalRead(i);
    }
    
    for(int j = 0; j < deviceStates.length-1; j++){
      deviceStates[j] = false;
    }
}

  void setLogic(int b0,int b3,int b4,int b5){
    
    println("setlogic");
  
    arduino.digitalWrite(B0, b0);
    arduino.digitalWrite(B3,b3);
    arduino.digitalWrite(B4,b4);
    arduino.digitalWrite(B5,b5);
  
  }
  
  void checkDI(){

    for (int i = 2; i <= 7; i++) {
      delay(del);
      //TODO - Compare state with last known state to see if anything has changed
      
      if (arduino.digitalRead(i) != buttonStates[i]){
        //print info to serial monitor  depending on what device is being updated.
        switch(i){
        case 0:
          //RX
          break;
        case 1:
          //TX
          break;
        case 2://Fire
          if (arduino.digitalRead(i) == 1){
            
            //Send to sever
            try{
            client.sendData(121,"ON");
            }catch(Exception e){
              print("error");
            }
            
            //update GUI
            gui.fireAlarm.setStatus(true);
            
            buttonOld = 1;
          }else{
            
            //Send status to server
            try{
            client.sendData(121,"OFF");
            }catch(Exception e){
              print("error");
            }
            
            //update GUI
            gui.fireAlarm.setStatus(false);
            
            buttonOld = 0;
          }
          
            buttonStates[2] = buttonOld;
          break;
        case 3://door
        //if(alarmBool){
          if (arduino.digitalRead(i) == 0){
            
            println("door is open");
            
            delay(del);
            setLogic(0,0,1,0);
            try{
              client.sendData(171,"ON");
            }catch(IOException e){
               print("problem");
            }
            buttonOld = 0;
            
          }else{
            
            println("door is closed");
            
            delay(del);
            setLogic(0,0,0,0);
            try{
              client.sendData(171,"OFF");
            }catch(IOException e){
               print("problem");
            }
            
            buttonOld = 1;
            
          }
        //}
          
          buttonStates[3] = buttonOld;
          break;
        case 4://Water Leak
          if (arduino.digitalRead(i) == 1){
            
            //Send status to server
            try{
            client.sendData(161,"ON");
            }catch(Exception e){
              print("error");
            }
            
            //update GUI
            gui.waterLeak.setStatus(true);
            buttonOld = 1;
          }else{
            
            //Send status to server
            try{
            client.sendData(161,"OFF");
            }catch(Exception e){
              print("error");
            }
            
            //update GUI
            gui.waterLeak.setStatus(false);
            
            buttonOld = 0;
          }
          buttonStates[4] = buttonOld;
          break;
        case 5://Oven
          if (arduino.digitalRead(i) == 1){
            
            //Send status to server
            try{
            client.sendData(151,"ON");
            }catch(Exception e){
              print("error");
            }
            
            //update GUI
            gui.oven.setStatus(true);
            
            buttonOld = 1;
          }else{
            
            //Send status to server
            try{
            client.sendData(151,"OFF");
            }catch(Exception e){
              print("error");
            }
            
            //update GUI
            gui.oven.setStatus(false);
            
            buttonOld = 0;
          }
          buttonStates[5] = buttonOld;
          break;
        case 6://Window
          if (arduino.digitalRead(i) == 1){
            
            //Send status to server
            try{
            client.sendData(141,"ON");
            }catch(Exception e){
              print("error");
            }
            
            //update GUI
            gui.window.setStatus(true);
            
            buttonOld = 1;
          }else{
            
            //Send status to server
            try{
            client.sendData(141,"OFF");
            }catch(Exception e){
              print("error");
            }
            
            //update GUI
            gui.window.setStatus(false);
            
            buttonOld = 0;
          }
          buttonStates[6] = buttonOld;
          break;
        case 7://Blackout
          if (arduino.digitalRead(i) == 1){
            
            //update GUI
            gui.blackOut.setStatus(true);
            
            buttonOld = 1;
          }else{

            //update GUI
            gui.blackOut.setStatus(false);
            
            buttonOld = 0;
          }
            buttonStates[7] = buttonOld;
          break;
        }//Switch-case end
        //Send data
        //TODO When the senddata method in Client is fixed, ant change in the inputs are sent from here.
     }
    }
  }
  
  void checkAI(){

    //Readinput from Energy Consumption
    nrg = arduino.analogRead(nrgConsumption);
    
    //Readinput from thermometer(prototype)
    temp = (5.0 * arduino.analogRead(therm) * 100.0) / 1024;
    //Update temperature reading in gui
    gui.thermometer.updateStatus(temp);
    //print the temperature, read by from the arduino, to the console
    println("temperature is " +temp);
    client.updateTemp(temp);
    
    //Readinput from thermometer outside
    tempOut = (5.0 * arduino.analogRead(thermOut) * 100.0) / 1024;
    gui.thermometerOut.updateStatus(tempOut);
    
    //Readinput from LDR
    LDR = arduino.analogRead(LDRPin);
  
  }
  
  void cycleDev(JSONArray _values){
    boolean timeStarted = false;
  
  //Cycle through devices
  for (int i = 0; i < _values.size(); i++) {
  
      //Create json object and fill it with information from current device
      JSONObject jobj = _values.getJSONObject(i); 

      //Extract and seperate information on current device 
      int id = jobj.getInt("id");
      String devices = jobj.getString("name");
      String stat = jobj.getString("status");
      
      //Here we now use the ID of the device instead of the name. 
    switch(id){
      //Device ID = 1 - Outdoor Lamp
      case 1:
      
      //Check status
      if (stat.equals("ON")) {
        
          if(!deviceStates[0]){
            println("turning lamp on");
            
            //Turn Lamp on
            delay(del);
            setLogic(1,1,0,1);
            
            //update status of GUI element that represents the lamp
            gui.lamp.setStatus(true);
            //Update boolean state of the device
            deviceStates[0] = true;
            
          }
        } else {
          if(deviceStates[0]){
            //Turn Lamp off
            delay(del);
            setLogic(1,1,1,1);
            println("turning lamp off");
            
            //update status of GUI element that represents the lamp
            gui.lamp.setStatus(false);
            
            //Update boolean state of the device
            deviceStates[0] = false;
          }
          
        }
        
      break;
      
      //Device ID = 11 - VM3 coffe machine
      case 11:
        
        //if statement to check status of device. i.e. if the Coffe Machine is ON
        if (stat.equals("ON")) {
    
          if(!deviceStates[1]){
            //update status of GUI element that represents the Coffee Machine
            gui.coffeeMachine.setStatus(true);
            
            //Update boolean state of the device
            deviceStates[1] = true;
            
          }
        } else {
  
          if(deviceStates[1]){
          //update status of GUI element that represents the Coffee Machine
          gui.coffeeMachine.setStatus(false);
          
          //Update boolean state of the device
          deviceStates[1] = false;
          }
        }
        break;
      
      case 21:
      //Device ID = 2 - Timer
      //Check status
      long elapsedTime =0;
      if (stat.equals("ON")) {
        
        if(!deviceStates[2]){
          
          //Turn Timer on
          delay(del);
          setLogic(0, 1, 0, 1);
          
          long startTime = System.nanoTime();
          timeStarted = true;      

          if(elapsedTime == 5000)  {
          setLogic(0, 1, 1, 1);
          timeStarted = false;
         }
          
          //update status of GUI element that represents the Timer
          gui.timerT1.setStatus(true);
          
          deviceStates[2] = true;
        }
          
        } else {
          
          if(deviceStates[2]){
            
          //Turn Timer off
          delay(del);
          setLogic(0, 1, 1, 1);
          
          //update status of GUI element that represents the Timer
          gui.timerT1.setStatus(false);
          
          //Update boolean state of the device
          deviceStates[2] = false;
          }
        }
        
      break;
      
      case 31:
      //Device ID = 3 - Heater
      //Check status
      if (stat.equals("ON")) {
          
        if(!deviceStates[3]){
          
          //Turn Heater on
          delay(del);
          setLogic(1, 0, 0, 1);
         
          //update status of GUI element that represents the Heater
          gui.heater1.setStatus(true);
          
          //Update boolean state of the device
          deviceStates[3] = true;
        }
          
      } else {
          
        if(deviceStates[3]){
          
          //Turn Heater off
          delay(del);
          setLogic(1, 0, 1, 1);
          
          //update status of GUI element that represents the Heater
          gui.heater1.setStatus(false);
          
          //Update boolean state of the device
          deviceStates[3] = false;
        }
          
      }
     
      break;
      
      case 41:
      //Device ID = 4 - Heater(Vind)
      //Check status
      if (stat.equals("ON")) {
        
        if(!deviceStates[4]){
          
          //Turn Heater(Vind) on
          delay(del);
          setLogic(0, 0, 0, 1);
         
          //update status of GUI element that represents the Heater(Vind)
          gui.heater2.setStatus(true);
          
          //Update boolean state of the device
          deviceStates[4] = true;
        }
          
      } else {
          
        if(deviceStates[4]){
          //Turn Heater(Vind) off
          delay(del);
          setLogic(0, 0, 1, 1);
          
          //update status of GUI element that represents the Heater(Vind)
          gui.heater2.setStatus(false);
          
          //Update boolean state of the device
          deviceStates[4] = false;
          }
          
      }
        
      break;
      
      case 51:
      //Device ID = 5 - Burglar alarm
      //Check status
      if (stat.equals("ON")) {
          
        if(!deviceStates[5]){
         //Turn Burglar alarm on
         
         alarmBool = true;
         delay(del);
         setLogic(1,1,0,0);
         
         //update status of GUI element that represents the Burglar alarm
          gui.burglar_alarm_lamp.setStatus(true);
          
          //Update boolean state of the device
          deviceStates[5] = true;
          }
          
       } else {
          
         if(deviceStates[5]){
           //Turn Burglar alarm off
           alarmBool = false;
           delay(del);
           setLogic(1,1,1,0);
          
           //update status of GUI element that represents the Burglar alarm
           gui.burglar_alarm_lamp.setStatus(false);
           
           //Update boolean state of the device
           deviceStates[5] = false;
          }
       }
      break;
      
      case 61:
      //Device ID = 6 - Indoor Lamp
      //Check status
      if (stat.equals("ON")) {
        
        if(!deviceStates[6]){
          
          //Turn Indoor Lamp on
          delay(del);
          setLogic(0, 1, 0, 0);
         
          //update status of GUI element that represents the Indoor Lamp
          gui.indoor_lamp.setStatus(true);
          
          //Update boolean state of the device
          deviceStates[6] = true;
        }
          
      } else {
        
        if(deviceStates[6]){
          
          //Turn Indoor Lamp off
          delay(del);
          setLogic(0, 1, 1, 0);
          
          //update status of GUI element that represents the Indoor Lamp
          gui.indoor_lamp.setStatus(false);
          
          //Update boolean state of the device
          deviceStates[6] = false;
        }
      }

      break;
      
      case 71:
      //Device ID = 7 - Timer 2
      //Check status
      if (stat.equals("ON")) {
          
        if(!deviceStates[7]){
          //Turn Timer on
          delay(del);
          setLogic(1, 0, 0, 0);
          
          //update status of GUI element that represents the Timer
          gui.timerT2.setStatus(true);
          
          //Update boolean state of the device
          deviceStates[7] = true;
        }
      } else {
          
         if(deviceStates[7]){
           
           //Turn Timer off
           delay(del);
           setLogic(1, 0, 1, 0);
          
           //update status of GUI element that represents the Timer
           gui.timerT2.setStatus(false);
          
           //Update boolean state of the device
           deviceStates[7] = false;
        }
      }
      break;
      
      case 81:
      //Device ID = 8 - Fan
      //Check status
      if (stat.equals("ON")) {
          
        if(!deviceStates[8]){
          
         //Turn Fan on
         delay(del);
         arduino.digitalWrite(flkt,Arduino.HIGH);

         
         //update status of GUI element that represents the Speaker
          gui.flkt.setStatus(true);
          
         //Update boolean state of the device
         deviceStates[8] = true;
        }
      } else {
          
         if(deviceStates[8]){
           
         //Turn Fan off
         delay(del);
         arduino.digitalWrite(flkt,Arduino.LOW);
          
         //update status of GUI element that represents the Speaker
          gui.flkt.setStatus(false);
          
          //Update boolean state of the device
          deviceStates[8] = false;
        }
      }
      break;
      
      case 91:
      //Device ID = 9 - VM 1
      //Check status
      if (stat.equals("ON")) {
 
        if(!deviceStates[9]){

          //update status of GUI element that represents the VM 1
          gui.VM1.setStatus(true);
          
          //Update boolean state of the device
          deviceStates[9] = true;
        }
      } else {
        if(deviceStates[9]){
            
          //update status of GUI element that represents the VM 1
          gui.VM1.setStatus(false);
          
          //Update boolean state of the device
          deviceStates[9] = false;
        }
      }
      break;
      
      case 101:
      //Device ID = 10 - VM 2
      //Check status
      if (stat.equals("ON")) {
         
         if(!deviceStates[10]){

            //update status of GUI element that represents the VM 2
            gui.VM2.setStatus(true);
            
            //Update boolean state of the device
            deviceStates[10] = true;
         }
       } else {
          
         if(deviceStates[10]){
    
           //update status of GUI element that represents the VM 2
           gui.VM2.setStatus(false);
           
           //Update boolean state of the device
           deviceStates[10] = false;
         }
       }
      break;
  
      }
      //Print the device information to the console
      println(id + ", " + devices + ", " + stat);
    } //End of switch-case
    
  }
  
}