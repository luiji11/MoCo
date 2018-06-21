#include <CapacitiveSensor.h>
//#include <Encoder.h>

CapacitiveSensor   cs = CapacitiveSensor(3,2);        // 10 megohm resistor between pins 4 & 2, pin 2 is sensor pin, add wire, foil
//Encoder myEnc(38,40);  //platform encoder...

int np_valve    = 3; //numberof pins used to drive valve 
int pv[3]       = {22, 24, 26}; // output pins
int pulseWidth  = 45; //15 ms pulse width
int stimTtlPin  = 13;
int rewardTtlPin= 12;

byte lick   = 0; //lick variable
long th     = 150; // detection threshold
int nreward = 0;

void setup()                    
{

int i;

for (i=0; i< np_valve; i++){
    pinMode(pv[i],OUTPUT);
    digitalWrite(pv[i],LOW);
//    myEnc.write(0);  //resets encoder 
  }
  pinMode(stimTtlPin,OUTPUT);
  digitalWrite(stimTtlPin,LOW);
  
  pinMode(rewardTtlPin,OUTPUT);
  digitalWrite(rewardTtlPin,LOW); 
   
  Serial.begin(9600);
}
   

void loop()                    
{
//    long pos;
//    int i;
//    long start = millis(); // read milliseconds
    long val = cs.capacitiveSensor(30); // sensitivity
    lick = (val>th); // accumulate licks

    if (Serial.available() > 0) {
      int cmd = Serial.read(); //read command

      switch (cmd) {
        case 0:
        lick = 0;
        break;

        case 'w':
        Serial.write(lick);
        //Serial.println("licking");
        break;

        case 'd':                         // deliver reward
          digitalWrite(rewardTtlPin,HIGH);

          int i;
          for(i =0; i<np_valve;i++) digitalWrite(pv[i],HIGH);
          delay(pulseWidth);
          for (i=0; i < np_valve; i++) digitalWrite(pv[i],LOW);

          digitalWrite(rewardTtlPin,LOW);

          break;
          
        case 'o': //stim on
          digitalWrite(stimTtlPin,HIGH);
          break;

        case 'x': //stimoff
          digitalWrite(stimTtlPin,LOW);
          break;          

        default: // condiered to be a new valve for the pulse width
          pulseWidth = cmd;
          break;
      }
    }
}

