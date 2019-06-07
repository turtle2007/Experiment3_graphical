class getLog{ 
  int currentMillis, uniformMillis;
  getLog(){
  }
  
  void timeLog(int objX, int objY){
    timeList [0] = hour();
    timeList [1] = minute();
    timeList [2] = second();
    timeList [3] = uniformMillis();
    timeList [4] = objX;
    timeList [5] = objY;
    timeList [6] = gPatternTimer;
    timeList [7] = forceData;
//    timeList [6] = 0;
//    timeList [7] = 0;
//    timeList [8] = 0;
//    timeList [9] = 0;
//    timeList [10] = 0;
  }
  int uniformMillis(){
    currentMillis = millis();
    if(gInitialDone == -1){
      gInitialMillis = currentMillis - gMillisLog;
      gInitialDone = 1;
    }
    uniformMillis = currentMillis - gMillisLog - gInitialMillis;
    return uniformMillis;
  }
  
  void startingNote(){
    startingNote [0] = year();
    startingNote [1] = month();
    startingNote [2] = day();
    startingNote [3] = hour();
    startingNote [4] = minute();
    startingNote [5] = second();
  } 
  
}
