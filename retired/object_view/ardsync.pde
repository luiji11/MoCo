
import processing.serial.*;

Serial myPort;  // Create object from Serial class

void ardsync_init() 
{
  myPort = new Serial(this,"COM3", 57600);
}

void stim_high() {
  myPort.write(1);
}

void stim_low() {
  myPort.write(0);
}

void tag_high() {
  myPort.write(3);
}

void tag_low() {
  myPort.write(2);
}

void tag_pulse() {
  myPort.write(3);
  myPort.write(2);
}
        



