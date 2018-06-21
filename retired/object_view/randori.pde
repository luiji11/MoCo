class randori { 
 
  public float mean, contrast;     // mean/contrast
  public int needsCompute;
  public int visible;
  public int xpos, ypos;    // position       
  public int radius;
  public int id;
  public float th;
  public float sphase;
  public float sper;
  public int tper;
  public int ton;          // number of frames a stimulus is on...
  public int fmode;         // flash mode or not?
  public int fcnt;        // flash mode counter    
  public int max_ori;
  public int max_phase;
  public int max_sper;      // max period
  PrintWriter logfile;
  PShader myshader;

  public randori() {

    mean = 128;
    contrast = 0.7;
    needsCompute = 1;
    visible = 1;
    xpos = displayWidth/2;
    ypos = displayHeight/2;
    radius = displayHeight/4;
    id = 31;                // object id
    th = 0;
    sphase = 0;
    sper = 300;
    tper = 15;
    fmode = 0;
    fcnt = 0;
    ton = 10;      
    max_ori   = 18;        // how many bins, not the range!
    max_phase = 8;    
    max_sper  = 12;
    myshader = loadShader("randori.frag");
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
      myshader.set("contrast", (float)contrast);
      myshader.set("mean", (float) mean/256.0);
    }
  }

  void display(int t) {
    int tnow;
    int flag = 0;

    tnow = millis();

    if (visible==1) {
      if ( (t % tper) == 0 ) {
        th = floor(random(0, max_ori));
        sphase = floor(random(0, max_phase));
        sper = floor(random(0,max_sper));

        myshader.set("contrast", (float)contrast);
        myshader.set("th", (float)th * PI / (float) max_ori);
        myshader.set("sphase", (float)sphase * TWO_PI / (float) max_phase);

        myshader.set("sper", (float)displayWidth / (float) pow(1.31,sper));
        myshader.set("xpos", (float)xpos);
        myshader.set("ypos", (float)ypos);
        myshader.set("radius", (float)radius);

        if (logfile != null) {
          if (t == 0) logfile.println("T " + trialno);
          logfile.println(t + " " + th + " " + sphase + " " + sper);
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

