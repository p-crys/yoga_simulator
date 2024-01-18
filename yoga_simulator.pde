import beads.*;
import org.jaudiolibs.beads.*;
import java.util.*;
import controlP5.*;

//to use text to speech functionality, copy text_to_speech.pde from this sketch to yours
//example usage below

//IMPORTANT (notice from text_to_speech.pde):
//to use this you must import 'ttslib' into Processing, as this code uses the included FreeTTS library
//e.g. from the Menu Bar select Sketch -> Import Library... -> ttslib

TextToSpeechMaker ttsMaker; 
ControlP5 p5;

//<import statements here>

//to use this, copy notification.pde, notification_listener.pde and notification_server.pde from this sketch to yours.
//Example usage below.

//name of a file to load from the data directory
String eventDataJSON1 = "yoga_test1.json";
String eventDataJSON2 = "yoga_test2.json";
Notification currentNotification;

NotificationServer server;
ArrayList<Notification> notifications;

Example example;

//Comparator<Notification> comparator;
//PriorityQueue<Notification> queue;
PriorityQueue<Notification> q2;

WavePlayer sine1;
WavePlayer sine2;
WavePlayer sine3;
WavePlayer sine4;
WavePlayer sine5;

WavePlayer saw1;
WavePlayer saw2;
WavePlayer saw3;
WavePlayer saw4;
WavePlayer saw5;

Gain gainSine1;
Gain gainSine2;
Gain gainSine3;
Gain gainSine4;
Gain gainSine5;

Glide sineGlide;
Gain sineGain;

Glide glideSine1;
Glide glideSine2;
Glide glideSine3;
Glide glideSine4;
Glide glideSine5;

RadioButton bodyParts;
RadioButton skillLevel;
RadioButton json;

TextToSpeechMaker tts;

Reverb reverb;

SamplePlayer clockSound;

boolean dangerToggle = false;

String skillSpeech;


void setup() {
  size(700,700);
  
  p5 = new ControlP5(this);
  
  NotificationComparator priorityComp = new NotificationComparator();
  
  q2 = new PriorityQueue<Notification>(10, priorityComp);
  
  //comparator = new NotificationComparator();
  //queue = new PriorityQueue<Notification>(10, comparator);
 
  
  ac = new AudioContext(); //ac is defined in helper_functions.pde
  
  clockSound = getSamplePlayer("serene-ding-ding.wav");
  clockSound.pause(true);
  
  sineGlide = new Glide(ac, 20, 50);  
  sineGain = new Gain(ac, 1, sineGlide);
  reverb = new Reverb(ac);
  reverb.setSize(0);
  reverb.addInput(sineGain);
  ac.out.addInput(reverb);
  
  p5.addRadioButton("radioButton")
     .setPosition(20,20)
     .setSize(40,20)
     .setColorForeground(color(120))
     .setColorActive(color(255))
     .setColorLabel(color(255))
     .setItemsPerRow(2)
     .setSpacingColumn(100)
     .setSpacingRow(30)
     .addItem("HANDS",0)
     .addItem("NECK",1)
     .addItem("SPINE",2)
     .addItem("BUTTOCKS",3)
     .addItem("FEET", 4);
     
     
   p5.addButton("dangerButton")
    .setPosition(400, 60)
    .setWidth(40)
    .setHeight(20)
    .setLabel("Danger");
    
  p5.addButton("clockButton")
    .setPosition(390, 110)
    .setSize(60, 20)
    .setLabel("Clock")
    .activateBy((ControlP5.RELEASE));
    
  p5.addRadioButton("skillButton")
   .setPosition(20,200)
   .setSize(40,20)
   .setColorForeground(color(120))
   .setColorActive(color(255))
   .setColorLabel(color(255))
   .setItemsPerRow(2)
   .setSpacingColumn(100)
   .setSpacingRow(30)
   .addItem("Beginner",0)
   .addItem("Advanced",1);
   
   
  p5.addRadioButton("jsonButton")
   .setPosition(20,275)
   .setSize(40,20)
   .setColorForeground(color(120))
   .setColorActive(color(255))
   .setColorLabel(color(255))
   .setItemsPerRow(2)
   .setSpacingColumn(100)
   .setSpacingRow(30)
   .addItem("test1",0)
   .addItem("test2",0);
   
    
 
     
  ac.start();
  
  
  
  
  //this will create WAV files in your data directory from input speech 
  //which you will then need to hook up to SamplePlayer Beads
  ttsMaker = new TextToSpeechMaker();
  
  //String exampleSpeech = "Text to speech is okay, I guess.";
  
  //ttsExamplePlayback(exampleSpeech); //see ttsExamplePlayback below for usage
  
  //START NotificationServer setup
  server = new NotificationServer();
  
  //instantiating a custom class (seen below) and registering it as a listener to the server
  example = new Example();
  server.addListener(example);
  
  //loading the event stream, which also starts the timer serving events
  
  //END NotificationServer setup
  
}


void radioButton(int a) {
  removeAll();
  if (a == 0) {
    if (dangerToggle){
      addSaw1();
    } else {
      addSine1();
    }
      
  } else if (a == 1) {
      if (dangerToggle){
      addSaw2();
    } else {
      addSine2();
    }
  } else if (a == 2) {
     if (dangerToggle){
      addSaw3();
    } else {
      addSine3();
    }
  } else if (a == 3) {
     if (dangerToggle){
      addSaw4();
    } else {
      addSine4();
    }
  } else if (a == 4) {
    if (dangerToggle){
      addSaw5();
    } else {
      addSine5();
    }
  }
}

void skillButton(int a) {
  removeAll();
  
  
  if (a == 0) {
     ttsMaker = new TextToSpeechMaker();
     skillSpeech = "skill level confirmed";
     ttsExamplePlayback(skillSpeech); 
     //println("beginnerbeginnerbeginnerbeginnerbeginnerbeginnerbeginnerbeginnerbeginnerbeginnerbeginner");
   
  } else if (a == 1) {
    ttsMaker = new TextToSpeechMaker();
    skillSpeech = "skill level confirmed";
    ttsExamplePlayback(skillSpeech); 
    //println("AdvancedAdvancedAdvancedAdvancedAdvancedAdvancedAdvancedAdvancedAdvancedAdvancedAdvancedAdvanced");
  }
}

void dangerButton() {
  dangerToggle = !dangerToggle;
}

void jsonButton(int k) {
  if (k == 0) {
     server.loadEventStream(eventDataJSON1);
    } else if (k == 1) {
      server.loadEventStream(eventDataJSON2);
    }
}

void removeAll() {
  sineGain.clearInputConnections();
}

void addSine1() {
  glideSine1 = new Glide(ac, 320, 200);
  sine1 = new WavePlayer(ac, glideSine1, Buffer.SINE);
  println("sin 1 pressed");
  gainSine1= new Gain(ac, 1, 1);
  
  gainSine1.addInput(sine1); // then connect the waveplayer to the gain
  sineGain.addInput(gainSine1);
  
}

void addSine2() {
  glideSine2 = new Glide(ac, 220, 200);
  sine2 = new WavePlayer(ac, glideSine2, Buffer.SINE);
  println("sin 2 pressed");
  gainSine2= new Gain(ac, 1, 1);
  
  gainSine2.addInput(sine2); // then connect the waveplayer to the gain
  sineGain.addInput(gainSine2);
}

void addSine3() {
  glideSine3 = new Glide(ac, 120, 200);
  sine3 = new WavePlayer(ac, glideSine3, Buffer.SINE);
  println("sin 3 pressed");
  gainSine3= new Gain(ac, 1, 1);
  
  gainSine3.addInput(sine3); // then connect the waveplayer to the gain
  sineGain.addInput(gainSine3);
}


void addSine4() {
  glideSine4 = new Glide(ac, 50, 200);
  sine4 = new WavePlayer(ac, glideSine4, Buffer.SINE);
  println("sin 4 pressed");
  gainSine4= new Gain(ac, 1, 1);
  
  gainSine4.addInput(sine4); // then connect the waveplayer to the gain
  sineGain.addInput(gainSine4);
}

void addSine5() {
  glideSine5 = new Glide(ac,-120, 200);
  sine5 = new WavePlayer(ac, glideSine5, Buffer.SINE);
  println("sin 5 pressed");
  gainSine5 = new Gain(ac, 1, 1);
  gainSine5.addInput(sine5); // then connect the waveplayer to the gain

  // finally, connect the gain to the master gain
  // masterGain will sum all of the sine waves, additively synthesizing a square wave tone
  sineGain.addInput(gainSine5);
}

void addSaw1() {
  saw1 = new WavePlayer(ac, glideSine1, Buffer.SAW);
  println("saw 1 pressed");
  
  gainSine1.addInput(saw1); // then connect the waveplayer to the gain
  sineGain.addInput(gainSine1);
}

void addSaw2() {
  saw2 = new WavePlayer(ac, glideSine2, Buffer.SAW);
  println("saw 2 pressed");
  
  gainSine2.addInput(saw2); // then connect the waveplayer to the gain
  sineGain.addInput(gainSine2);
}

void addSaw3() {
  saw3 = new WavePlayer(ac, glideSine3, Buffer.SAW);
  println("saw 3 pressed");
  
  gainSine3.addInput(saw3); // then connect the waveplayer to the gain
  sineGain.addInput(gainSine3);
}

void addSaw4() {
  saw4 = new WavePlayer(ac, glideSine4, Buffer.SAW);
  println("saw 4 pressed");
  
  gainSine4.addInput(saw4); // then connect the waveplayer to the gain
  sineGain.addInput(gainSine4);
}

void addSaw5() {
  saw5 = new WavePlayer(ac, glideSine5, Buffer.SAW);
  println("saw 5 pressed");
  
  gainSine5.addInput(saw5); // then connect the waveplayer to the gain
  sineGain.addInput(gainSine5);
}

void clockButton() {
  sineGain.addInput(clockSound);
  println("Clock button pressed");
  clockSound.setToLoopStart();
  clockSound.start();
}



void draw() {
  //this method must be present (even if empty) to process events such as keyPressed() 
}

void keyPressed() {
  //example of stopping the current event stream and loading the second one
  if (key == RETURN || key == ENTER) {
    server.stopEventStream(); //always call this before loading a new stream
    server.loadEventStream(eventDataJSON2);
    println("**** New event stream loaded: " + eventDataJSON2 + " ****");
  }
 
}

//in your own custom class, you will implement the NotificationListener interface 
//(with the notificationReceived() method) to receive Notification events as they come in
class Example implements NotificationListener {
  int priority;
  boolean clock;
  boolean danger;
  String flag;
  public Example() {
    //setup here
  }
  
  //this method must be implemented to receive notifications
  public void notificationReceived(Notification notification) { 
    println("<Example> " + notification.getType().toString() + " notification received at " 
    + Integer.toString(notification.getTimestamp()) + " ms");
    
    String debugOutput = ">>> ";
    switch (notification.getType()) {
      case feet:
        debugOutput += "feet detected: ";
        break;
      case buttocks:
        debugOutput += "buttocks detected: ";
        break;
      case spine:
        debugOutput += "spine detected: ";
        break;
      case neck:
        debugOutput += "neck detected: ";
        break;
      case hands:
        debugOutput += "hands detected: ";
        break;
    }
    debugOutput += notification.toString();
    //debugOutput += notification.getLocation() + ", " + notification.getTag();
    
    println(debugOutput);
    
   //You can experiment with the timing by altering the timestamp values (in ms) in the exampleData.json file
    //(located in the data directory)
  }
}

void ttsExamplePlayback(String inputSpeech) {
  //create TTS file and play it back immediately
  //the SamplePlayer will remove itself when it is finished in this case
  
  String ttsFilePath = ttsMaker.createTTSWavFile(inputSpeech);
  println("File created at " + ttsFilePath);
  
  //createTTSWavFile makes a new WAV file of name ttsX.wav, where X is a unique integer
  //it returns the path relative to the sketch's data directory to the wav file
  
  //see helper_functions.pde for actual loading of the WAV file into a SamplePlayer
  
  SamplePlayer sp = getSamplePlayer(ttsFilePath, true); 
  //true means it will delete itself when it is finished playing
  //you may or may not want this behavior!
  
  ac.out.addInput(sp);
  sp.setToLoopStart();
  sp.start();
  println("TTS: " + inputSpeech);
}
