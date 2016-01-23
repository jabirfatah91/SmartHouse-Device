/*
  Coded by Jabir Al Fatah
  Gui devices to be manipulated
*/
//Imports

class Gui_Device{
  
  //___________________________________Variable Declaration___________________________________//
  PFont f;
  int xPos, yPos, type;
  int val;
  String name;
  boolean stat;
  
  //The Constructor
  Gui_Device(String _name,int _type, int _xPos, int _yPos){
 
    //Define the values of our variables
    name = _name;
    type = _type;
    xPos = _xPos;
    yPos = _yPos;
    stat = false;
    
    //Creat font for the text. this is used to define how the text will look
    f = createFont("Arial",10,true);
    
    //Check the type of our Device_ object
    //I THINK THIS WILL BE CHANGED, I HAVNT GOT AROUND TO IT, LOL/Paul
    switch(type){
      case 1:
        drawStatus();
        break;
      case 2:
        updateStatus(0);
        break;
      default:
        println("invalid type");
    }
    
  }
  
  void drawStatus(){
    //text
    textFont(f,20);
    fill(0);
    text(name, xPos, yPos);
    
    //If statement to see if the device being updated is a button or not(Lamp, coffee, etc)
    if(type == 1){
  
  //Decides if buttons should be filled in or not.
      if(stat){
        //If true then fill Button white
        noStroke();
        fill(255);
        ellipse(xPos + 10,yPos + 20, 10, 10);
      }else{
        //if not, fill button black
        noStroke();
        fill(0);
        ellipse(xPos + 10,yPos + 20, 10, 10);
      }
    
    }else{
      
      //Update Text devices(temperature etc)
      textFont(f,18);
      fill(0);
      text(val, xPos, yPos + 50);
  }
  
  }
  
  
  void updateStatus(float _val){
    
    //new value to display
    val = int(_val);
    
  }
  
  //Set the status of the button of THIS object
  void setStatus(boolean newState){
  
    //Change state boolean
    stat = newState;
    
    //update GUI
    drawStatus();
    
  }

}