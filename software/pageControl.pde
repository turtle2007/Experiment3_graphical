import arb.soundcipher.*;
SoundCipher sc = new SoundCipher(this);
touchPoint testSketch = new touchPoint();

class pageControl{
  int head = 0, audioOn = 1, displayOrder = 0, // displayOrder: temp store either the order in the trial or the demo.
      takeLog = -1, hapRender = -1;
  int /*flashInterval = 200, */flashCover = 200, fillColor = 254, circleSize = 90; 
  int flashInterval [][] = {
        {0, 6, 1, 3, 3},{0, 3, 6, 1, 3},
        {0, 3, 3, 6, 1},{0, 1, 6, 3, 3},
        
        {0, 6, 1, 3, 3},{0, 3, 6, 1, 3},
        {0, 3, 3, 6, 1},{0, 1, 6, 3, 3},
        
        {0, 6, 1, 3, 3},{0, 3, 6, 1, 3},
        {0, 3, 3, 6, 1},{0, 1, 6, 3, 3},
        
        {0, 6, 1, 3, 3},{0, 3, 6, 1, 3},
        {0, 3, 3, 6, 1},{0, 1, 6, 3, 3},
        
        {0, 6, 1, 3, 3},{0, 3, 6, 1, 3},
        {0, 3, 3, 6, 1},{0, 1, 6, 3, 3},
  };
  //int [][] flashOrderTrial = {
  //    {0,2,1,4,3},{2,4,1,0,3},{3,0,2,1,4},
  //    {1,3,0,4,2},{4,3,0,2,1},{1,2,3,4,0},
  //    {4,2,3,0,1},{3,1,2,4,0},{0,4,1,3,2}
  //};
  int []flashOrderTrial = {0,1,2,3,4};
  String [] orderRecord = {"T1_VHA","T2_VHA","T3_VHA","T4_VHA",
                           "T5_VH","T6_VH","T7_VH","T8_VH",
                           "T9_VA","T10_VA","T11_VA","T12_VA",
                           "T13_n/a","T14_n/a","T15_n/a","T16_n/a",
                           "T17_learn","T18_learn","T19_learn","T20_learn"
                           };
  int [][] flashOrderDemo = {
    {1,0,2,3,4},{0,3,2,1,4},{3,1,4,2,0}  
  };
  //int [] note = {69, 67, 64, 62, 60};
  int [] note = {67, 67, 67, 67, 67};
  //int [] vibIntensity = {'a', 'g', 'e', 'd', 'c'};
  int [] vibIntensity = {'a', 'a', 'a', 'a', 'a'};
  int[][] circles = {  {365+200, 315}, //regular - coordinates of 5 circles.
             {529+200, 315}, 
             {365+200, 315}, 
             {529+200, 315}, 
             {365+200, 315}  }; 
  String myString;
  pageControl(){
    
  }

 void page(int page){ // Page = 1, welcome. Page = 2, video. Page = 3, practice. page = 4, real trials.
    // page 1
    if (page == 1 || expDone == 1){
      background(backgroundColor); // only for page 1.
      fill (120,20,0); // colour: red
      textSize(30);
      if(expDone == 0){
        myString = "Welcome to join the study.";
      }else{
        myString = "All done. Thank you very much.";
      }
      text(myString, 240+200, 300);
    }
    // page 2
    if(page == 2){
      background(0); // black background.
      hapRender();
      myMovie1.play();
      image(myMovie1, 0, 0, width, 550);
    }
    // page 3 -- practice, page 4 -- trials.
    if ((page == 4) && (trialStep != trialStepPre || sketchOnGoing == -1)){ // practice or real trial.
      drawCanvas();
    }

    if (page == 4 && trialStep != trialStepPre){ // play the same demo once only.
        realTrial();
    }else if (page == 4 && trialStep == trialStepPre){ //page = 3, in the demo. page = 4, in the trial.
      if (displayTrialNo > 18){ // the # of trials grow from 0 to the limit. The total # will be limit + 2.
        println(displayTrialNo);
        expDone = 1;
        backgroundColor = 240;
      }else{ // if the no. has not reach the limit.    
        demoDone = 0; // for one sequence, not the whole demo.
        sketchOnGoing = -1;
        head = 0;
        audioOn = 1; // true, ready for playing in the next turn.
        newTrial = 1;
        realTrialSta = 0;
        frameSaved = 0;
        trialStep ++;
        displayTrialNo ++; // for displaying next sequence in the experiment.
        takeLog = -1;
        gInitialDone = -1;
        tuioSketchOn = "-1";
        gPatternTimer = 0;
        }
      } 
  }
//____________________________________________________________________________________________
  void realTrial(){   
    int timeDiffCross = 0;
    if(realTrialSta == 0){
      timeDiff();
      realTrialSta++;
      next = false;
    }
    if(realTrialSta == 1){
      millisT2 = millis();
      timeDiffCross = millisT2 - millisT1; /* count the time passed after the fixation cross.*/
      if(timeDiffCross < 500){ // 300 ms fixation cross
        drawCross();       
      }else{  
        realTrialSta ++;
      demoDone = demoPre;
      }
    }    
    if (realTrialSta == 2){
      showDemo();
      if(head ==10){ // head =10, the demo sequence is done.
        realTrialSta ++;
      }     
    }
    if(realTrialSta == 3){
      sketchOnGoing = 1; // now ready for the draw, stop covering it with the canvas.
      if(takeLog == -1){
        timePoint.println(orderRecord[displayTrialNo] + "---New block" + (trial+1) + "---");
        gMillisLog = millis();
        takeLog = 1;
      }
      if(displayTrialNo < 16){ // after the 16, there are no viusal circles on the screen
        //comment this for loop after testing.
        for (int i = 0; i < 5; i++){
          multiFeedback0(circles[i][0],circles[i][1]); 
        }
      }
      //if(mousePressed){
      //  frameSaved = 0; // ready for storeing a new sketch.
      //  testSketch.testSketch(fillColor); // log participant-made sketch here
      //}
      testSketch.tuioStart();
      if(tuioSketchOn == "on"){
        frameSaved = 0; // back to 0, ready for storeing a new sketch.
        testSketch.testSketch(); // log participant-made sketch here
        if(forceDataAvailable == true){  // force data.
         forceData = myPort.read();
          println(forceData); 
        }
      }
      if(tuioSketchOn == "off"){
        frameSaved = 1; // new sketch saved.
        myPort.write('T'); // after drawing, send stop to teensy, which will stop.  
      }
      
      if(takeLog == -1){
        timePoint.println(orderRecord[displayTrialNo] + "---New block" + (trial+1) + "---");
        gMillisLog = millis();
        takeLog = 1;
      }
      
      if(frameSaved == 1){ // call back change val to 1: mouse released, frame saved.
        realTrialSta ++;
        trial++;
        println("This is trial..." + trial);
      }
    }
    
    if(realTrialSta == 4){
      buttons(); // display "go to next."
      if(next){// if next = true, move to the next.
        trialStepPre = trialStep;
      } 
    }
  }

  void timeDiff(){
    if (demoDone == demoPre){ // if the demo is over, generate new flash order.
    millisT1  = millis();
    demoDone ++;
    } 
  }
  
  void drawCross(){
    fill(220,220,220);
    textSize(40);
    myString = "+"; 
    text(myString, 420+200, 350);
  }
  
  void showDemo(){ 
    timeDiff();    
    millisT2 = millis();
    int timeDiff = millisT2 - millisT1; /* count the time passed 
                                         after the offset of previous circle.*/
// 1. draw five circles.
    for (int i = 0; i<5; i++){    
      noStroke();
      fill (fillColor);    // brightness levels.
      ellipse(circles[i][0], circles[i][1], circleSize, circleSize);
      fill(0);
      // comment following 2 lines after testing.
      //myString = str(i);
      //text(myString, circles[i][0], circles[i][1]);
    } 

// 2. cover the five cirles follow the flash order, while play sound and send vib intensity index.
    if ((timeDiff > flashInterval[trial][head]*100) && head < 5){  // (ms) interval between five circles. Head is the pointer for the sequence.      
      //displayOrder = flashOrderTrial[displayTrialNo][head];   
      
      displayOrder = flashOrderTrial[head]; 
      
      //myPort.write(vibIntensity[displayOrder]); // send note to teensy, start vib.
      if(displayTrialNo < 8 || 
        displayTrialNo == 16 || displayTrialNo == 17){
        myPort.write(vibIntensity[displayOrder]); // 3. hap. send note to teensy, start vib.
      }
      
      //playSound(note[displayOrder]); // start note.
      if(displayTrialNo <= 3 || (displayTrialNo > 7  && displayTrialNo < 12) || 
        displayTrialNo == 16 || displayTrialNo == 18){
        playSound(note[displayOrder]); // 2. auditory
      } 
      
      fill(0); // fill in colour black.
      ellipse(circles[displayOrder][0], circles[displayOrder][1], circleSize-15, circleSize-15);
      if (timeDiff > flashInterval[trial][head]*100 + flashCover){  // ms covering.
        if (head < 4){ // if the sequence is not over.
          head ++; // move the pointer to the next.
          audioOn = 1; // true, ready for playing in the next turn.
          myPort.write('T'); // send stop to teensy, which will stop.
        }else {
          head = 10; // if the sequence is over, stop it by signing 10 to the pointer head.
          myPort.write('T'); // send stop to teensy, which will stop.
//          demoDone = demoPre; // comment this, stop generating new sequence.
        }
        millisT1 = millisT2;  
      }    
    } 
  }
  
  void drawCanvas(){
    backgroundColor = 50; // update background color in a trial.
    background(backgroundColor);
    stroke(0);
    fill(0); // set the canvas color in black.
    rectMode(CORNERS);
    rect(gMargin, gMargin, width - gMargin, height - gMargin, 10);  
  }
  
  void playSound(int note){ 
    if (audioOn == 1){
      sc.playNote(note, 200, 0.5);
      audioOn = audioOn*(-1);
    }    
  }
  
  void buttons(){
    rectMode(CORNER);
    fill (120);
    noStroke();
    fill(220);
    String myString2 = "Go to next...";
    text(myString2, 480, 585);
  }
  // comment out this method after testing.
  void multiFeedback0 (int cooX, int cooY){  
    fill(30);
    ellipse(cooX, cooY, 100, 100); 
  }
  
  void hapRender(){
    if(hapRender == -1){
      millisT1  = millis();
      hapRender = 1;
    }
   millisT2  = millis();
   //println("time T2..." + millisT2);
   int timeDiff = millisT2 - millisT1;
   //println(timeDiff);
   if (timeDiff >= 200 && timeDiff <= 350){
     myPort.write('4');
     //println('4');
   }
   if (timeDiff >= 1600 && timeDiff <= 1630){
     //myPort.write('T');
     myPort.write('5');
     //println('5');
   }
   if (timeDiff >= 4000 && timeDiff <= 4030){
     myPort.write('T');
     myPort.write('5');
     //println('5');
   }
   if (timeDiff >= 9150 && timeDiff <= 9180){
     //myPort.write('T');
     myPort.write('3');
     //println('3');
   }
   if (timeDiff >= 12050 && timeDiff <= 12080){
     //myPort.write('T');
     myPort.write('2');
     //println('2');
   }
   if (timeDiff >= 13040 && timeDiff <= 13070){
     //myPort.write('T');
     myPort.write('3');
     //println('3');
   }
   if (timeDiff >= 14200 && timeDiff <= 14230){
     //myPort.write('T');
     myPort.write('2');
     //println('2');
   }
   if (timeDiff >= 17200 && timeDiff <= 17230){
     //myPort.write('T');
     myPort.write('1');
     //println('1');
   }
   if (timeDiff >= 19100 && timeDiff <= 19130){
     //myPort.write('T');
     myPort.write('2');
     //println('2');
   }
   if (timeDiff >= 19400 && timeDiff <= 19450){
     //myPort.write('T');
     myPort.write('3');
     //println('3');
   }
  }


}
