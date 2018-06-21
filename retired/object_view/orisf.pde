class orisf { 

  public int xsize, ysize;         // size
  public int xpos, ypos;           // position       
  public float mean, contrast;     // mean/contrast
  public float sper, th, sphase;
  public float max_sf;             
  public float min_sf;
  public int tper;
  public int needsCompute;
  public int visible;
  public int id;
  public int k, l, s;
  public int ton;                 // number of frames a stimulus is on...
  public int fmode;               // flash mode or not?
  public int fcnt;                // flash mode counter    
 
  PrintWriter logfile;
  PShader myshader;

  public orisf() {

    xpos = displayWidth/2;
    ypos = displayHeight/2;
    xsize = 128;
    ysize = 128;
    mean = 128;
    contrast = 0.5;
    min_sf = 1;                  // cycles per screen width
    max_sf = 100;
    tper = 20;
    needsCompute = 1;
    visible = 1;
    id = 32;                // object id
    fmode = 0;
    fcnt = 0;
    ton = 10;            
    myshader = loadShader("orisf.frag");
  }

  void openlog() {

    //close anything if open...
    if (logfile != null) {
      logfile.flush();
      logfile.close();
    }    
    logfile = createWriter(logname + "_" + nf(id, 2));
  }

  void closelog() {
    if (logfile != null) {
      logfile.flush();
      logfile.close();
      logfile = null;
    }
  }


  void compute() {

    if (needsCompute==1) {
      openlog();
      needsCompute=0;
      myshader.set("resolution", float(displayWidth), float(displayHeight));
      myshader.set("contrast", (float)contrast/2.0);
      myshader.set("mean", (float)mean/256.0);
    }
  }

  void display(int t) {
    int tnow;
    int flag = 0;

    tnow = millis();

    if (visible==1) {
      if ( (t % tper) == 0 ) {

        th = random(0, PI);
        sphase = random(0, 2*PI);
       float sf = exp(random(log(min_sf),log(max_sf))); // log spaced spatial frequency
//        float sf = random(min_sf,max_sf);

        sper = displayWidth/sf;
        
        myshader.set("contrast", (float)contrast);
        myshader.set("th", th);
        myshader.set("sphase", sphase);
        myshader.set("sper", sper);
        
        if (logfile != null) {
          if (t == 0) logfile.println("T " + trialno);
          logfile.println(t + " " + th + " " + sper + " " + sphase);
          //logfile.flush();   it is flushed at the end...
        }
        tag_pulse();
        fcnt = 0 ;
      } 
      else {
        if (fmode>0) {
          if (fcnt>=ton)
            myshader.set("contrast", (float)0.0);
          else
            fcnt++;
        }
      }
      
      shader(myshader);
      rect(displayWidth/2, displayHeight/2, displayWidth, displayHeight);  // full screen...
    }
  }
}

