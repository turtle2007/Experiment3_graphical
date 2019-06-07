#include <SoftwareSerial.h>

const int motorPin =  20;
const int checkPin =  13; // the number of the LED pin

int forceSenPin = A0;
int motorState = 0;  
int incomingByte = 0;
char val;
// for the test
int testled = 3;

int forceValue = 0;
int tuioStatePre = 0, tuioState = 0;

long interval = 1000; 
long previousMillis = 0, currentMillis = 0; 

void setup() {
  Serial.begin(9600);
  analogWriteResolution(10);  
  analogWriteFrequency(motorPin, 1000);
  pinMode(motorPin, OUTPUT);   
  pinMode(checkPin, OUTPUT); 
  pinMode(testled, OUTPUT);
}

void loop()
{
  forceValue = analogRead(forceSenPin);
  if(forceValue > 90 && tuioState < 90){
    Serial.println("on");
    tuioState = forceValue; // send 'on' only once per trial.
  }else if(forceValue < 10 && tuioState > 90){
    Serial.println("off");
    tuioState = forceValue; // send 'off' only once per trial.
  }
  if(forceValue > 90){
    Serial.println(forceValue);  
  }

//  if(forceValue > 50){
//    Serial.println(forceValue);
//    tuioState = forceValue;
//  }else if(forceValue < 10 && tuioState > 50){
//    Serial.println("off");
//    tuioState = 0; // send 'off' only once per trial.
//  }

   
  if(Serial.available()){   
    val = Serial.read();
    Serial.println(val); 
//    int numCollect = 0;
    if(val == 'T'){
      onAndOff(0);
      digitalWrite(testled, LOW);
//      digitalWrite(testled, HIGH);
    }
    if(val == 'a'){
      onAndOff(921); // 0.9
      }
    if(val == 'g'){
      onAndOff(717); // 0.7
//      onAndOff(614); // 0.6
    }
    if (val == 'e'){ 
      onAndOff(512);  // 0.5
    }
    if (val == 'd'){ 
      onAndOff(307); // 0.3
      digitalWrite(testled, HIGH);
    }
    if (val == 'c'){ 
      onAndOff(102); // 0.1
    }
    if(val == '1'){
      fading(921, 10); // The first val is the haptic feedback intensity,
    }                 // the second is decrease rate.
    if(val == '2'){
      fading(717, 8);
    }
    if(val == '3'){
      fading(512, 6);
    }
    if(val == '4'){
      fading(307, 4);
    }
    if(val == '5'){
      fading(102, 2);
    }
    if(val == '0'){
      fading(0, 0);
    }
  } 
}

void onAndOff (int intensity){
  analogWrite(motorPin, intensity);
  if (intensity != 0){
    digitalWrite(checkPin, HIGH);  
  }else{
    digitalWrite(checkPin, LOW); 
  } 
}

void fading(int fadeVal, int decrease){
  for (int fadeValue = 0 ; fadeValue <= fadeVal; fadeValue += decrease) {
    analogWrite(motorPin, fadeValue);
    delay(10);
  }
  for (int fadeValue = fadeVal ; fadeValue >= 0; fadeValue -= decrease) {
    analogWrite(motorPin, fadeValue);
    delay(10);
  }
}
