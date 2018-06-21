/**
 * Getting Started with Capture.
 * 
 * Reading and displaying an image from an attached Capture device. 
 */

 import processing.video.*;
 import processing.serial.*;

PrintWriter output;
Serial myPort;  // Create object from Serial class
byte[] buf = new byte[2]; 
int flag = 0;

//Capture cam;
PImage frame;

int maxstim = 10;
int nstim=0;
int start, stop;
int instim=0;

int p1  = 12;
int p2  = 13;


void setup() {
  int i, j, v;

  size(displayWidth, displayHeight, P2D);

  output = createWriter("/Users/Nick/images/stimulus.txt"); 
  
  ardsync_init();

  //cam = new Capture(this, 320, 180, "Live! Cam Sync HD VF0770", 15);//video display
  //cam.start();

  // drifting grating

  int xsize = displayWidth/4+100;
  int ysize = displayHeight+500;// sets the size of the visual display

  frame = createImage(xsize, ysize, RGB);

  frame.loadPixels();
  for (i=0;i<ysize;i++) {
    for (j=0;j<xsize;j++) {
      v = (int)(128+128*cos(TWO_PI*((float)i/50.0))); //spatial Hz , i= horiztonal
      frame.pixels[i*xsize+j] = color(v, v, v);
    }
  }
  
  frame.updatePixels();
  frameRate(60);
}

void draw() {


  background(128);

  if (instim==0 && nstim<maxstim) {
    
    start = frameCount + 10*int(random(30, 60)); 
    stop = start+4*60;  // 4 sec vis stim
    output.println(start + " " + stop);
    output.flush();
    instim=1;
  } else {
    if (frameCount<stop) {
      if (frameCount>start) {
        pushMatrix();
        scale(4);
        translate(0,+ ((frameCount-start) % 100)-250); // x=0, y=framecount-start (shifts horizontal bars down) ; speed adjusted here
        image(frame, 0, 0);
        popMatrix();
        if (frameCount>stop-120) { 
          //stim_high(); 
          myPort.write(2);  // enable water delivery....
        } else {
                      //disable water delivery
        }
      }
    } else {
      stim_low();
      instim=0;
      nstim++;
    }
  }
  
   //if(flag==1) image(cam, 0, 0);

  //save("/Users/Nick/images/screen_" + frameCount + ".png");  
}

void ardsync_init() 
{
  myPort = new Serial(this, "/dev/tty.usbmodem1431", 9600); // bits/second
}

void stim_high() {
  buf[0] = byte(12); //changed from 51 to 12
  //buf[0] = byte(13); // added

  buf[1] = byte(255);
  myPort.write(buf);
}

void stim_low() {
  buf[0] = byte(12); //changed from 51 to 12
  //buf[0] = byte(13); // added
  buf[1] = byte(0);
  myPort.write(buf);
}

void captureEvent(Capture c){
  c.read();
}

void keyPressed(){
  flag = 1-flag;
}

boolean sketchFullScreen() {
  return true;
}
