// arduino sync box for object view

// pins for the LEDs:

void setup() {
  // initialize serial:
  Serial.begin(9600);
  // make the pins outputs:
  pinMode(12, OUTPUT); // 51
  pinMode(13, OUTPUT); // 53

  digitalWrite(12,LOW); // 51
  digitalWrite(13,LOW); // 53

}

void loop() {
  char buf[2];

  if(Serial.available()) {

    Serial.readBytes(buf,2);
    digitalWrite(buf[0],buf[1] ? HIGH : LOW);

  }
}
