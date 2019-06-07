class touchPoint extends pageControl{  
  int feedbackOn = -1, stopVib = -1, order0 = 0, orderNext = -1;
  int distance=0, distFeedback=0, X_=0, Y_=0, order=0;
  int hapOnTime = 0, hapCurrent = 0, hapInterval = 0;
  ArrayList<PVector> path = new ArrayList<PVector>();
  float tightness = 2;
  float size = 10; 

  float obj_size = object_size*scale_factor;
  
  int objX, objY;
  touchPoint() {
  } 
  
  
  void tuioStart(){
    ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
    for (int m=0;m<tuioObjectList.size();m++) {
       TuioObject tobj = tuioObjectList.get(m);
       fill(fillColor);
       //pushMatrix();
       int X = tobj.getScreenX(width);
       int toMid = width/2 - X;
       if(toMid>0){
         X = X + 2*toMid;
       }else if(toMid<0){
         X = X - 2*abs(toMid);
       }     
       int Y = tobj.getScreenY(height);
       //ellipse(X,Y,obj_size,obj_size);
       //objX = X;
       //objY = Y;
       objX = int(map(X, 250, 650, 0, 900));
       objY = int(map(Y, 200, 600, 0, 800));
       ellipse(objX,objY,obj_size,obj_size);
    }
  }
  
  void testSketch() {
    if (newTrial == 1){// if new trial start, remove those obj from the last trial.
      //println("frameSaved ..." + frameSaved);
      for (int i = path.size(); i >0; i--) {
        PVector v = path.get(i-1);
        path.remove(v);
      }
      newTrial = -1;
      order0 = 0;
    }
    
    //feedback control during sketch.
    multiFeedback();
    //Interpolation. For more continous visual feedback.
    interpLine();
    gLog.timeLog(objX, objY); //push data into log array
    for (int j = 0; j < 8; j++) { //export data log to .txt
      timePoint.print(timeList[j]+"  ");// Writes the remaining data to the file
    }
    timePoint.println("\n");
    timePoint.flush();
  } //testSketch.
  
  // Interpolate the sketch line.
  void interpLine(){
    path.add(new PVector(objX, objY));  // if it's mouse, use mouseX and mouseY.  
    for (int i = 1; i < path.size (); i++) {
      PVector current  = path.get(i);
      PVector previous = path.get(i-1); 
      float distance = previous.dist(current); 
      int extraPoints = (int)(round(distance/size * tightness));  
      //draw the previous point
      //traces - change size and color here
      noStroke();
      fill(200);
      //if there are any exta points to be added, compute and draw them:
        for (int j = 0; j < extraPoints; j++) { 
        float interpolation = map(j, 0, extraPoints, 0.0, 1.0);
        PVector inbetween = PVector.lerp(previous, current, interpolation); 
        ellipse(inbetween.x, inbetween.y, size-5, size-5);
      } 
    } // Interpolation.    
  }
  
  //compare the mouseX, Y, if in the range, give audio, haptic feedback.
  //1. visual, 2. haptic, 3. audio.
  //void multiFeedback(){   
  //  for (int i = 0; i < 5; i++){
  //    distance = int(dist(circles[i][0], circles[i][1], objX, objY)); // if it's mouse, use mouseX and mouseY.
  //    if(distance < 100){ // find the nearest one
  //      X_ = circles[i][0];
  //      Y_ = circles[i][1];
  //      orderNext = i;
  //      //fill(90); // 1. visual
  //      //ellipse(X_, Y_, 10, 10); // 1. visual feedback
  //    }      
  //  }
  //  if(orderNext != order0){ //if move to a new position.
  //    feedbackOn = 1;
  //    audioOn =1;
  //    order0 = orderNext;
  //    hapOnTime = millis();
  //  }
    
  //  // for the continuous feedback, after certaint time, vib should stop.
  //  hapCurrent = millis();
  //  hapInterval = hapCurrent - hapOnTime;
  //  if(hapInterval > flashInterval && stopVib == -1){
  //    myPort.write('T'); // send stop to teensy, which will stop.
  //    stopVib = 1;
  //  }    
  //  if (feedbackOn == 1){ // consition satisfied, give feedback.
  //    myPort.write(vibIntensity[orderNext]); // 2. haptic feedback. send note to teensy, start vib.
  //    playSound(note[orderNext]); // 3. audio feedback
  //    feedbackOn = -1;

  //  }
  //}
  //compare the mouseX, Y, if in the range, give audio, haptic feedback.
  void multiFeedback(){   
    for (int i = 0; i < 5; i++){
      distance = int(dist(circles[i][0], circles[i][1], objX, objY));
      if(distance < 45){ // find the nearest one
        X_ = circles[i][0];
        Y_ = circles[i][1];
        orderNext = i;
        //fill(90); // 1. visual
        //ellipse(X_, Y_, 10, 10);
      }      
    }
    if(orderNext != order0){ //if move to a new position.
      gPatternTimer ++;
      feedbackOn = 1;
      audioOn =1;
      order0 = orderNext;
      hapOnTime = millis();
    }
    
    // for the continuous feedback, after certaint time, vib should stop.
    hapCurrent = millis();
    hapInterval = hapCurrent - hapOnTime;
    if(hapInterval > 200){ //200 ms
      myPort.write('T'); // 3. hap. send stop to teensy, which will stop.
    }
    
    if (feedbackOn == 1){ // condition satisfied, give feedback.
      if(displayTrialNo < 8 || 
        displayTrialNo == 16 || displayTrialNo == 17){
        myPort.write(vibIntensity[orderNext]); // 3. hap. send note to teensy, start vib.
      }
      if(displayTrialNo <= 3 || (displayTrialNo > 7  && displayTrialNo < 12) || 
        displayTrialNo == 16 || displayTrialNo == 18){
        playSound(note[orderNext]); // 2. auditory
      }  
      feedbackOn = -1;
    }
  }
  
}

// --------------------------------------------------------------
void addTuioObject(TuioObject tobj) {
  if (verbose) println("add obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle());
}

// called when an object is moved
void updateTuioObject (TuioObject tobj) {
  if (verbose) println("set obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle()
          +" "+tobj.getMotionSpeed()+" "+tobj.getRotationSpeed()+" "+tobj.getMotionAccel()+" "+tobj.getRotationAccel());
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
  if (verbose) println("del obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+")");
}

void refresh(TuioTime frameTime) {
  if (verbose) println("frame #"+frameTime.getFrameID()+" ("+frameTime.getTotalMilliseconds()+")");
  if (callback) redraw();
}

// --------------------------------------------------------------
// called when a cursor is added to the scene
void addTuioCursor(TuioCursor tcur) {
  if (verbose) println("add cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY());
  //redraw();
}

// called when a cursor is moved
void updateTuioCursor (TuioCursor tcur) {
  if (verbose) println("set cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY()
          +" "+tcur.getMotionSpeed()+" "+tcur.getMotionAccel());
  //redraw();
}

// called when a cursor is removed from the scene
void removeTuioCursor(TuioCursor tcur) {
  if (verbose) println("del cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+")");
  //redraw()
}

// --------------------------------------------------------------
// called when a blob is added to the scene
void addTuioBlob(TuioBlob tblb) {
  if (verbose) println("add blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea());
  //redraw();
}

// called when a blob is moved
void updateTuioBlob (TuioBlob tblb) {
  if (verbose) println("set blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea()
          +" "+tblb.getMotionSpeed()+" "+tblb.getRotationSpeed()+" "+tblb.getMotionAccel()+" "+tblb.getRotationAccel());
  //redraw()
}

// called when a blob is removed from the scene
void removeTuioBlob(TuioBlob tblb) {
  if (verbose) println("del blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+")");
  //redraw()
}
