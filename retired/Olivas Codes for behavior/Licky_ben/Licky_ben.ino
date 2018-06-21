/* Licky  -- Dario L Ringach 4/12/16 */

#include <CapacitiveSensor.h>

CapacitiveSensor   cs = CapacitiveSensor(3, 2);   // use pins 2/3 for capacitive sensing

int np_valve = 3;         // number of pins used to drive the valve (3 recommended)
int pv[3] = {22, 24, 26}; // which pins are the actual pins?
int pulseWidth    = 15;   // 15ms duration delivers ~2uL for 60cc syringe filled to 30cc at 20cm height

byte  lick = 0;   // lick variable
long  th = 500;   // threshold for detecting lick

void setup()
{
  int i;

  for (i = 0; i < np_valve; i++) {
    pinMode(pv[i], OUTPUT);
    digitalWrite(pv[i], LOW);
  }
  Serial.begin(115200);
}

void loop()
{
  int i;
  long start = millis(); //read milliseconds (serial monitor)
  long val =  cs.capacitiveSensor(30); //sensitivity

  lick = lick || (val > th);               // accumulate licks...

  if (Serial.available() > 0) {

    int cmd = Serial.read();                    // read command

    switch (cmd) {
      case 0:                                   // start monitoring for licks...
        lick = 0;
        break;

      case 1:                                   // stop monitoring for licks and report back
        Serial.write(lick);
        break;

      case 2:                                   // deliver reward 
        for (i = 0; i < np_valve; i++) digitalWrite(pv[i], HIGH);
        delay(pulseWidth);
        for (i = 0; i < np_valve; i++) digitalWrite(pv[i], LOW);
        break;

      default:  // considered to be a new value for the pulse width
        pulseWidth = cmd;
        break;

    }
  }
}

