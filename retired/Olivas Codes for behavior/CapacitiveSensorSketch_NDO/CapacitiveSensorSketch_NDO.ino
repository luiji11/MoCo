#include <CapacitiveSensor.h>

/*
 * CapitiveSense Library Demo Sketch
 * Paul Badger 2008
 * Uses a high value resistor e.g. 10M between send pin and receive pin
 * Resistor effects sensitivity, experiment with values, 50K - 50M. Larger resistor values yield larger sensor values.
 * Receive pin is the sensor pin - try different amounts of foil/metal on this pin
 */


CapacitiveSensor   cs_2_4 = CapacitiveSensor(2,4);        // 10M resistor between pins 4 & 2, pin 2 is sensor pin, add a wire and or foil if desired
int p1              = 12;
int p2              = 13;
int dispDuration    = 50;
int senseThreshold  = 500;
void setup()                    
{
   pinMode(p1, OUTPUT);
   pinMode(p2, OUTPUT);
   digitalWrite(p1, LOW);   
   digitalWrite(p2, LOW);   
   Serial.begin(9600);

}

void loop()                    
{
  
    long start = millis(); //read milliseconds (serial monitor)
    long total1 =  cs_2_4.capacitiveSensor(30); //sensitivity

    Serial.print(millis() - start);        // check on performance in milliseconds
    Serial.print("\t");                    // tab character for debug windown spacing

    Serial.print(total1);                  // print sensor output 1
    Serial.println("\t"); // code for tab

    delay(10);                             // arbitrary delay to limit data to serial port 
    
   
    if (total1 > senseThreshold)
    {
      
      digitalWrite(p1, HIGH); 
      digitalWrite(p2, HIGH); 
      
      Serial.println("Water ON");
      delay(dispDuration);  
      Serial.println("Water OFF");   
      digitalWrite(p1, LOW); 
      digitalWrite(p2, LOW);     
      delay(500);
     }
    
     
}
