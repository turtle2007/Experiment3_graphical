// This is TUIO version, for the wall display experiment.
// This sketch is developed based on the version ex_3_1_v7. 
// Mouse coordinates has been replaced by TUIO obj coordinates.
// Lastest update: 2018_6_3.

import processing.serial.*;
import processing.video.*;
import TUIO.*;

touchPoint touch_point;
pageControl which_page;
getLog gLog;
TuioProcessing tuioClient;
Movie myMovie1;

Serial gPort, myPort;
int gPortNumber = 1; 
int gSensorHeight = 700;
int gSensorWidth = 800;
int gMargin = 50;

// Used for recording movement, output to the log file
int[] timeList = new int[8]; 
int[] startingNote = new int[8]; // year, month, date

// Initial states
int page = 1, demoDone = 0, demoPre = 0, 
    trialStep = 1, trialStepPre = 0, trial = 0, 
    backgroundColor = 240, millisT1, millisT2, 
    gMillisLog, gInitialMillis, gInitialDone = -1,
    newTrial = -1, sketchOnGoing = -1, frameSaved = 0;  
int expDone = 0, allDemoDone = 0, displayTrialNo = 0,
    realTrialSta = 0, gPatternTimer = 0, forceData = -2; 
String tuioSketchOn = "-1";
boolean next = false, forceDataAvailable = false;
PrintWriter timePoint;
String demoOrTrial = "demo";
String logTitle = "1807010_order1_130Wall_P2_zhaoEZ###";

float object_size = 15;
float table_size = 760;
float scale_factor = 1;
PFont font;
boolean verbose = false; // print console debug messages
boolean callback = true; // updates only after callbacks

void setup() {
  which_page = new pageControl();
  // used for creat log in the timelist array
  gLog = new getLog(); 
  
  String logName = logTitle + "." + "txt";
  timePoint = createWriter(logName); 
  gLog.startingNote();
  timePoint.print("---New Experiment---");
  timePoint.print("Experiment date: ");
  for(int i = 0; i < 8; i++){
      timePoint.print(startingNote[i]+"  ");
      timeList[i] = 0;
      }
  timePoint.println("Participant: " + "A5");
  timePoint.println("\n");
  
  size(1300, 800);
  //size(1300, 800);
  frameRate(120);
  //size(displayWidth,displayHeight);

  println("Available ports: ");
  println(Serial.list());  
  String portName = Serial.list()[gPortNumber]; 
  println("Opening port " + portName);
  myPort = new Serial(this, portName, 9600); //port 1
  myPort.bufferUntil('\n');
  myMovie1 = new Movie(this, "bri.mp4");
  
  font = createFont("Arial", 18);
  scale_factor = height/table_size;
  tuioClient  = new TuioProcessing(this);
}

void draw() { 
  which_page.page(page);  
}

void movieEvent(Movie m) {
  m.read();
}

// log data with mouse press
//void mouseReleased(){
//  if (frameSaved == 0){
//        //TODO: add participant's info on the figure?        
//        saveFrame("/Users/fengfeng/Documents/My_research/Study_3/start_code/ex_3_1_v7/logSave/"+logTitle+"."+"png"); 
//      }
//   frameSaved = 1; // new sketch saved.
//   myPort.write('T'); // after drawing, send stop to teensy, which will stop.
//}

//log data with touch sensor
void serialEvent( Serial myPort) {
  String val = myPort.readStringUntil('\n');
  if (val != null) {
    val = trim(val);
    //println(val);
    if(val.equals("on")){ // Teensy send string, here must be string.
      forceDataAvailable = true;
      tuioSketchOn = "on";
      //println(tuioSketchOn);
      myPort.clear();
    }
    if(val.equals("off")){
      forceDataAvailable = false;
      saveFrame("/Users/fengfeng/Documents/My_research/Study_3/start_code/ex_3_3_v1_order1/logSave/"+logTitle+"."+"png"); 
      tuioSketchOn = "off";
      myPort.clear();
    }
  }    
}


void keyPressed(){
  switch(key){
    case 'v':
      page = 2; // video page.     
      println("watch video");
    break;
    case 'p':
      demoOrTrial = "demo";
      page = 3;      
      println("go to practice");
    break;
    case 't':
      demoOrTrial = "trial";
      page = 4;      
      println("Experiment started..." + demoOrTrial);
    break;
    case ' ':
      next = true; 
      //realTrialSta ++;
      //trial++;
      //println("This is trial..." + trial);
    break;
    case '-':
      trialStep --;
      trial -- ;
      displayTrialNo -- ;
    break;
  }
}
