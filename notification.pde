//enum NotificationType { Door, PersonMoveHome, PersonMoveWork, Meeting, PersonStatus, ObjectMove, ApplianceStateChange, PackageDelivery, Message }
enum NotificationType { feet, buttocks, spine, neck, hands }

class Notification {
   
  int timestamp;
  NotificationType type; // feet, buttocks, spine, neck, hands
  int pos_x;
  int pos_y;
  int priority;
  String note;
  boolean clock;
  boolean danger;
  String flag;
  
  
  
  public Notification(JSONObject json) {
    this.timestamp = json.getInt("timestamp");
    //time in milliseconds for playback from sketch start
    
    String typeString = json.getString("type");
    
    this.pos_x = json.getInt("pos_x");
    this.pos_y = json.getInt("pos_y");
    
    this.clock = json.getBoolean("clock");
    
    this.danger = json.getBoolean("danger");
    
    
    try {
      this.type = NotificationType.valueOf(typeString);
    }
    catch (IllegalArgumentException e) {
      throw new RuntimeException(typeString + " is not a valid value for enum NotificationType.");
    }
    
     
    if (json.isNull("flag")) {
      this.flag = "";
    }
    else {
      this.flag = json.getString("flag");      
    }
    
    if (json.isNull("note")) {
      this.note= "";
    }
    else {
      this.note = json.getString("note");     
    }
    
    this.priority = json.getInt("priority");
    //1-3 levels (1 is highest, 3 is lowest)    
  }
  
  public NotificationType getType() { return type; }
  public String getFlag() { return flag; }
  public int getTimestamp() { return timestamp; }
  public int getPosX() { return pos_x; }
  public int getPosY() { return pos_y; }
  public int getPriorityLevel() { return priority; }
  public String getNote() { return note; }
  public boolean getClock() { return clock; }
  public boolean getDanger() { return danger; }
  
  
  
  public String toString() {
      String output = getType().toString() + ": ";
      output += "(flag: " + getFlag() + ") ";
      output += "(pos_x: " + getPosX() + ") ";
      output += "(pos_y: " + getPosY() + ") ";
      output += "(priority: " + getPriorityLevel() + ") ";
      output += "(clock: " + getClock() + ") ";
      output += "(danger: " + getDanger() + ") ";
      output += "(note: " + getNote() + ") ";
      return output;
    }
}
