/*
    Code by Liaquath Hassan
    All net related code goes here
*/

//Imports

class ClientSide {
  Client c;
  //___________________________________Variable Declaration___________________________________//
  //Variables go here


  //_______________________________________Constructors_______________________________________//
  //Constructors go here
  ClientSide() {
  }

  //____________________________________Method Declaration____________________________________//
  //Methods go here

  void retrieveData() {
    
println("Attempting data reception");
    //load json string
    //Load information from website/server into an array of strings
    json=loadStrings("http://thesmarthouse.azurewebsites.net/restAPI/Room/1/1/bded74425176f692690a66bc3fcaf1ac");
    println("Data recieved!");
    
    //Check to see if there was information sent from server
    if (json != null) {
    //if so, save array of string information to file
    saveStrings("data.json", json);
      
    //Load json object
    JSONObject js= loadJSONObject("data.json");
    JSONObject room = js.getJSONObject("Room");
    JSONArray values = room.getJSONArray("devices");
      
    DM.cycleDev(values);
    
  
    }
  }
    
  void sendData(int _ID, String _Stat ) throws IOException {
    
    try {
      
      URL url = new URL("http://thesmarthouse.azurewebsites.net/restAPI/Device/"+_ID+"/"+_Stat+"/1/bded74425176f692690a66bc3fcaf1ac");
      
      HttpURLConnection httpCon = (HttpURLConnection) url.openConnection();
      httpCon.setDoOutput(true);
      httpCon.setRequestMethod("PUT");
      
      OutputStreamWriter out = new OutputStreamWriter(httpCon.getOutputStream());
      out.write("Resource content");
      out.close();
      
      httpCon.getInputStream();
      
    } catch (MalformedURLException e) {
    
      e.printStackTrace();
 
    } catch (IOException e) {
    
      e.printStackTrace();
      
    }

    }
    
    void updateTemp(float temp){
    //String temp_URL = "https://thesmarthouse.azurewebsites.net/restAPI/Device/updateTemp/"+temp+"/1/1/bded74425176f692690a66bc3fcaf1ac";//This link is broken for now and the
                                                                                                                                      //server team is fixing the problem /Hassan
    String temp_URL = "https://thesmarthouse.azurewebsites.net/restAPI/Device/updateTemp/"+int (temp)+"/1/1/bded74425176f692690a66bc3fcaf1ac";
    loadStrings(temp_URL);
    }
    
  }