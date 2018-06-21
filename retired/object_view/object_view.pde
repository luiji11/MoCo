
import processing.net.*;
import java.lang.reflect.*;
import processing.opengl.*;
import javax.media.opengl.*;

//import de.voidplus.leapmotion.*;  // leap...
// Are we using leap?
// LeapMotion leap;

// just in case sound is needed...
Minim minim;
AudioOutput out;

// The ov server
Server ovServer;

ArrayList theList = new ArrayList();

int idx = -1;  // Pointer to selected object
int loopMode = 0;
int nframes = 0;
int trialno = -1;
int t0;
int barori = 0;

String logname = "u000_000";

int debug = 0;

void setup() {

  if (debug==1)
    size(displayWidth/2, displayHeight/2, P2D);
  else
    size(displayWidth, displayHeight, P2D);

  // open tcpip communication 
  ovServer = new Server(this, 6000); 

  // arduino serial communication 
  ardsync_init();

  // init sound...
  minim = new Minim( this );
  out   = minim.getLineOut();

  imageMode(CENTER); // all images with respect to their centers...
  rectMode(CENTER);
  noStroke();
  noCursor();
  frameRate(60);
  textSize(20);
}

void draw() {

  int id=0;
  Grating g;
  iGrating ig;
  sGrating sg;
  SyncRect r;
  SparseNoise n;
  MovingLine m;
  Hartley h;
  sHartley sh;
  Tone t;
  sGabor sGab;
  sLocalizer sl;
  naturemovie nm;
  randomgrid rg;
  calibrator cb;
  randori ro;
  orisf os;
  retinotopy or;
  Cohere ch;

  Object o;
  Class c;
  Field fld;



  background(128);

  Client aClient = ovServer.available();
  if (aClient != null) {
    if (aClient.available() > 0) {
      parse(aClient.readStringUntil(10));    // execute command...
    }
  }

  switch(loopMode) {
  case 0:
    background(128);
    t0 = millis();
    break;

  case -1:

  default:


    if (loopMode == -1 || (frameCount <= nframes)) {

      for (int i=0; i<theList.size (); i++) {      // check who needs to compute...
        o = theList.get(i);
        c = o.getClass();

        try { 
          fld = c.getField("id");
          id = fld.getInt(o);
        } 
        catch (Exception e) {
          println(e);
        }

        switch(id) {

        case 0:
          g = (Grating) o;
          if (g.needsCompute==1) g.compute();
          break;

        case 2:
          n = (SparseNoise) o;
          if (n.needsCompute==1) { 
            n.compute();
          }
          break;

        case 3:
          m = (MovingLine) o;
          if (m.needsCompute==1) m.compute();
          break;

        case 4:
          h = (Hartley) o;
          if (h.needsCompute==1) {
            h.compute();
          }
          break;

        case 5:
          ig = (iGrating) o;
          if (ig.needsCompute==1) {
            ig.compute();
          }
          break;

        case 6:
          sg = (sGrating) o;
          if (sg.needsCompute==1) {
            sg.compute();
          }
          break;

        case 7:
          sh = (sHartley) o;
          if (sh.needsCompute==1) {
            sh.compute();
          }
          break;

        case 16:

          sGab = (sGabor) o;
          if (sGab.needsCompute==1) {
            sGab.compute();
          }
          break;

        case 17:

          sl = (sLocalizer) o;
          if (sl.needsCompute==1) {
            sl.compute();
          }
          break;

        case 18:

          nm = (naturemovie) o;
          if (nm.needsCompute==1) {
            nm.compute();
          }
          break;

        case 19:

          rg = (randomgrid) o;
          if (rg.needsCompute==1) {
            rg.compute();
          }
          break;

        case 31:

          ro = (randori) o;
          if (ro.needsCompute==1) {
            ro.compute();
          }
          break;


        case 32:

          os = (orisf) o;
          if (os.needsCompute==1) {
            os.compute();
          }
          break;

        case 55:

          or = (retinotopy) o;
          if (or.needsCompute==1) {
            or.compute();
          }
          break;

        case 56:
          ch = (Cohere) o;
          if (ch.needsCompute==1) { 
            ch.compute();
          }
          break;

        case 100:
          t = (Tone) o;
          if (t.needsCompute==1) {
            t.compute();
          }
          break;

        case 255:
          cb = (calibrator) o;
          if (cb.needsCompute==1) {
            cb.compute();
          }
          break;

        default:
          break;
        }
      }

      for (int i=0; i<theList.size (); i++) {

        o = theList.get(i);
        c = o.getClass();    // get the object class...

        try { 
          fld = c.getField("id");
          id = fld.getInt(o);
        } 
        catch (Exception e) {
          println(e);
        }

        switch(id) {                            // and display it...
        case 0:
          g = (Grating) o;
          g.display(frameCount-1);
          break;

        case 1:
          r = (SyncRect) o;
          r.display(frameCount-1);
          break;

        case 2:
          n = (SparseNoise) o;
          n.display(frameCount-1);
          break;

        case 3:
          m = (MovingLine) o;
          m.display(frameCount-1);
          break;

        case 4:
          h = (Hartley) o;
          h.display(frameCount-1);
          break;

        case 5:
          ig = (iGrating) o;
          ig.display(frameCount-1);
          break;

        case 6:
          sg = (sGrating) o;
          sg.display(frameCount-1);
          break;

        case 7:
          sh = (sHartley) o;
          sh.display(frameCount-1);
          break;

        case 16:
          sGab = (sGabor) o;
          sGab.display(frameCount-1);
          break;

        case 17:
          sl = (sLocalizer) o;
          sl.display(frameCount-1);
          break;

        case 18:
          nm = (naturemovie) o;
          nm.display(frameCount-1);
          break;

        case 19:
          rg = (randomgrid) o;
          rg.display(frameCount-1);
          break;

        case 31:
          ro = (randori) o;
          ro.display(frameCount-1);
          break;

        case 32:
          os = (orisf) o;
          os.display(frameCount-1);
          break;

        case 55:
          or = (retinotopy) o;
          or.display(frameCount-1);
          break;

        case 56:
          ch = (Cohere) o;
          ch.display(frameCount-1);
          break;

        case 100:
          t = (Tone) o;
          t.display(frameCount-1);
          break;

        case 255:
          cb = (calibrator) o;
          cb.display(frameCount-1);
          break;
        }
      }
    } else {
      stim_low();
      //println(millis()-t0);
      loopMode=0;
      frameCount=1;

      // close all log files...

      for (int i=0; i<theList.size (); i++) {

        o = theList.get(i);
        c = o.getClass();    // get the object class...

        try { 
          fld = c.getField("id");
          id = fld.getInt(o);
        } 
        catch (Exception e) {
          println(e);
        }

        switch(id) {                            

        case 2:
          n = (SparseNoise) o;
          n.closelog();
          break;

        case 4:
          h = (Hartley) o;
          h.closelog();
          break;

        case 7:
          sh = (sHartley) o;
          sh.closelog();
          break;

        case 16:
          sGab = (sGabor) o;
          sGab.closelog();
          break;

        case 17:
          sl= (sLocalizer) o;
          sl.closelog();
          break;

        case 18:
          nm= (naturemovie) o;
          nm.closelog();
          break;

        case 19:
          rg= (randomgrid) o;
          rg.closelog();
          break;

        case 31:
          ro = (randori) o;
          ro.closelog();
          break;

        case 32:
          os = (orisf) o;
          os.closelog();
          break;

        default:
          break;
        }
      }
    }

    break;
  }
}




void parse(String message) {

  if (message != null) {

    println(message);

    String[] list = split(message.trim(), ' ');  // split...

    switch(list[0].charAt(0)) {

    case 'D':  //delete object

      idx = int(list[1]);
      if (idx<0) {
        theList.clear();
        resetShader();
      } else
        theList.remove(idx);

      idx = 0;               // make the pointer go to zero after deletion of an object..  
      break;

    case 'A':  //add object

      idx = int(list[1]);
      if (idx<0) idx = theList.size();    // add at the end...

      int objid = int(list[2]); 

      switch(objid) {          //only gratings available for now...

      case 0:
        Grating g = new Grating();    // add a new grating
        theList.add(idx, g);
        break;

      case 1:
        SyncRect r = new SyncRect();  // add sync square
        theList.add(idx, r);
        break;

      case 2:
        SparseNoise n = new SparseNoise();  // add sync square
        theList.add(idx, n);
        break;

      case 3:
        MovingLine m = new MovingLine();
        theList.add(idx, m);
        break;

      case 4:
        Hartley h = new Hartley();  // add sync square
        theList.add(idx, h);
        break;

      case 5:
        iGrating ig = new iGrating();
        theList.add(idx, ig);
        break;

      case 6:
        sGrating sg = new sGrating();
        theList.add(idx, sg);
        break;

      case 7:
        sHartley sh = new sHartley();
        theList.add(idx, sh);
        break;

      case 16:
        sGabor sGab = new sGabor();
        theList.add(idx, sGab);
        break;

      case 17:
        sLocalizer sl = new sLocalizer();
        theList.add(idx, sl);
        break;

      case 18:
        naturemovie nm = new naturemovie(this);
        theList.add(idx, nm);
        break;

      case 19:
        randomgrid rg = new randomgrid();
        theList.add(idx, rg);
        break;

      case 31:
        randori ro = new randori();
        theList.add(idx, ro);
        break;

      case 32:
        orisf os = new orisf();
        theList.add(idx, os);
        break;

      case 55:
        retinotopy or = new retinotopy();
        theList.add(idx, or);
        break;
        
      case 56:
        Cohere ch = new Cohere();
        theList.add(idx, ch);
        break;
        
      case 100:
        Tone t = new Tone();
        theList.add(idx, t);

      case 255:
        calibrator cb = new calibrator();
        theList.add(idx, cb);  

      default:                       // unknown class... do nothing
        break;
      }

      break;

    case 'S':  //select object
      idx = int(list[1]);
      break;

    case 'F':  //set field of selected object

      Class c = theList.get(idx).getClass();

      try { 
        Field fld = c.getField(list[1]);
        Field nc = c.getField("needsCompute");

        if (int(list[2]) == 0)
          fld.setInt(theList.get(idx), int(list[3]));
        else 
          fld.setFloat(theList.get(idx), float(list[3]));

        nc.setInt(theList.get(idx), int(list[4]));
      } 
      catch (Exception e) {
        println(e);
      }
      break;      

    case 'L':  //loop

      loopMode = int(list[1]);

      switch (loopMode) {

      case 0:   //stop
        stim_low();
        frameCount=1;
        break;

      case -1:  //loop forever
        frameCount=1;
        stim_high();
        break;

      default:
        frameCount = 1;
        nframes = int(list[1]);
        t0 = millis();
        stim_high();
        break;
      }

      break;

    case 'T':
      trialno = int(list[1]);  // set the trial number
      break;

    case 'G':                // set the root log file name
      logname = list[1];
      break;
    }
  }
}

void keyPressed() {   //same as L 0 command...
  if (keyCode == ESC)
  {
    //EDIT PATRICK: necessary on Windows
    exit();
  } else
  {
    stim_low();
    loopMode=0;
    frameCount=1;
  }
}

void mouseReleased() {
  barori = 1-barori;
}

boolean sketchFullScreen() {
  return debug == 0;
}

