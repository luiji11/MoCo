/*
 Keyboard test

 For the Arduino Leonardo, Micro or Due

 Reads a byte from the serial port, sends a keystroke back.
 The sent keystroke is one higher than what's received, e.g.
 if you send a, you get b, send A you get B, and so forth.

 The circuit:
 * none

 created 21 Oct 2011
 modified 27 Mar 2012
 by Tom Igoe

 This example code is in the public domain.

 http://www.arduino.cc/en/Tutorial/KeyboardSerial
 */

void setup() {
  // open the serial port
  SerialUSB.begin(115200);
  Serial.begin(115200);
 
  pinMode(13, OUTPUT);
  digitalWrite(13, LOW); 

  SerialUSB.write(101);
  
  // initialize control over the keyboard:
  
}

void loop() {
  // check for incoming serial data:
  if (Serial.available() > 0) {
     digitalWrite(13, HIGH); 
    char inChar = Serial.read();
    Serial.write(inChar);
  }

  if (SerialUSB.available() > 0) {
     digitalWrite(13, HIGH); 
    char inChar = Serial.read();
    SerialUSB.write(inChar);
  }
  
}

