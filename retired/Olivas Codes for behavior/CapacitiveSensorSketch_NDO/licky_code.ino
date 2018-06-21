#include <CapacitiveSensor.h>

CapacitiveSensor   cs = CapacitiveSensor(3,2);        // 10 megohm resistor between pins 4 & 2, pin 2 is sensor pin, add wire, foil

int np_valve = 3; //numberof pins used to drive valve 
int pv[3] = {22, 24, 26}; // output pins
int pulseWidth = 15; //15 ms pulse width

byte lick = 0; //lick variable
long th = 500; // detection threshold

void setup()                    
{

int i;

for (i=0; i< np_valve; i++){
    pinMode(pv[i],OUTPUT);
    digitalWrite(pv[i],LOW);
  }
    Serial.begin(115200);
}
   

void loop()                    
{
    
    int i;
    long start = millis(); // read milliseconds
    long val = cs.capacitiveSensor(30); // sensitivity

    lick = lick || (val>th); // accumulate licks

    if (Serial.available() > 0) {
      int cmd = Serial.read(); //read command

      switch (cmd) {
        case 0:
        lick = 0;
        break;

        case 1:
        Serial.write(lick);
        break;

        case 2:                         // deliver reward
          for(i =0; i<np_valve;i++) digitalWrite(pv[i],HIGH);
          delay(pulseWidth);
          for (i=0; i < np_valve; i++) digitalWrite(pv[i],LOW);
          break;

        default: // condiered to be a new valve for the pulse width
          pulseWidth = cmd;
          break;
      }
    }
}
