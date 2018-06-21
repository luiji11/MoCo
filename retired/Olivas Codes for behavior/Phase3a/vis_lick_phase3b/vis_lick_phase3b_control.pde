/*
 * Getting Started with Capture.
 * 
 * Reading and displaying an image from an attached Capture device. 
 */

 //import processing.video.*;
 import processing.serial.*;

PrintWriter output;
Serial myPort;  // Create object from Serial class

PImage frame;

int sOn,sOff;
int rewardGiven   = 0;
int nTrials       = 50;
int trial         = 0;
int trialMode     = 0;
int hitFrame      = 0;
float thetaVals[] = {0.0, PI/2.0};
float Ori         = 0;
int lastThree[]   = {1,0,1}; 

int isLicking     = 0;
int sigLicks      = 0;
int noiseLicks    = 0;

void setup() {
  int i, j, v;

  size(displayWidth, displayHeight, P2D);
//    size(500, 500, P2D);

  output = createWriter("phase3Data_wd15_000_004.txt"); 
  
  ardsync_init();

  int xsize = displayWidth/4+100;
  int ysize =  displayHeight+500;// sets the size of the visual display

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
  
  int k;
  int pos;
  int a = 0; //keeps track of even/odd trial
  
background(128);

  if (trialMode==0 && trial<nTrials) 
  {  
    sOn = frameCount + 10*int(random(30, 60)); 
    sOff = sOn+4*60;  // 4 sec vis stim

    trialMode     =1;
    rewardGiven   =0;
    hitFrame      =0;
    sigLicks      =0;
    noiseLicks    =0;
    trial++;    
    
    lastThree = getOri(lastThree);
    Ori       = thetaVals[lastThree[2]];
 

  } 
 
 else{
  
   if (frameCount == sOn){
       myPort.write('o'); // tell scanbox stim is on
   }
   if (frameCount == sOff){
      myPort.write('x'); // stim off 
   }
   
   
   if (frameCount<sOff) {   
   
   if (frameCount>sOn){ 
        pushMatrix();
        scale(4);
           rotate(Ori);                
     
        translate(0,+ ((frameCount-sOn) % 100)-1000); // x=0, y=framecount-sOn (shifts horizontal bars down) ; speed adjusted here
        image(frame, 0, 0);
        popMatrix();
        
        myPort.write('w');      
        isLicking = int(myPort.read() > 0);
        print(isLicking);         

        if (frameCount <=  sOff-120){
           noiseLicks = noiseLicks + isLicking;
        }
        
        if (frameCount >  sOff-120){
           sigLicks = sigLicks + isLicking;

          if (rewardGiven == 0 && isLicking == 1 && a%2 == 0) { //gives reward on even trial
            print("*");
            myPort.write('d');
            rewardGiven = 1; 
            hitFrame = frameCount - sOn;
          }
            a++; //advances even/odd counter
        }
        
    }
    }
    else {
       trialMode=0;
       println();       
//       println(lastThree[2] + " " + noiseLicks + " " + sigLicks + " " + hitFrame);       
       println();       
  
  //
  //   myport.write('e');
  //   myport.readBytes(4);
  //   format for int32 
  
      
  
       output.println(lastThree[2] + " " + noiseLicks + " " + sigLicks + " " + hitFrame );       
       output.flush();    
    }  


 }
 
   if (trial == nTrials){
            output.println(lastThree[2] + " " + noiseLicks + " " + sigLicks + " " + hitFrame);       
       output.flush(); 
     output.close(); // Finishes the fil
  } 
  
}
  
void ardsync_init() 
{
  myPort = new Serial(this, "/dev/cu.usbmodem5d11", 9600); // bits/second
}    


int[] getOri(int[] lastThree) {
  if ((lastThree[0] == lastThree[1]) && (lastThree[1] == lastThree[2])) {
     int x[] = {lastThree[1], lastThree[2], (lastThree[2]+1) % 2};   
     return x;   
  }
  else {
     int x[] = {lastThree[1], lastThree[2], int(random(0,2))}; 
     return x;   
  }

  
}





boolean sketchFullScreen() {
 return true;
}