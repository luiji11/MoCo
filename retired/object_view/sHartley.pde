class sHartley { 

  public int xsize, ysize;  // size
  public int xpos, ypos;    // position       
  public float mean, contrast;     // mean/contrast
  public int tper;                 // temporal period
  public int max_k;
  public int needsCompute;
  public int visible;
  public int id;
  public int idxs;          // selected grating...
  public int nframes;
  public int k, l, s;
  public int ton;          // number of frames a stimulus is on...
  public int fmode;         // flash mode or not?
  public int fcnt;        // flash mode counter    
  ArrayList img, kidx, lidx, sidx;
  PrintWriter logfile;
  PShader myshader;

  public sHartley() {

    xpos = displayWidth/2;
    ypos = displayHeight/2;
    xsize = 128;
    ysize = 128;
    mean = 128;
    contrast = 0.7;
    max_k = 12;
    tper = 20;
    needsCompute = 1;
    visible = 1;
    id = 7;                // object id
    k = 0;
    l = 0;
    s = 0;
    fmode = 0;
    fcnt = 0;
    ton = 10;            
    myshader = loadShader("Hartley.frag");
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
        k = floor(random(-max_k, max_k+1));
        l = floor(random(-max_k, max_k+1));
        s = (random(0, 1)>0.5) ? 1 : -1 ;

        myshader.set("k", (float) k);
        myshader.set("l", (float) l);
        myshader.set("s", (float) s);
        myshader.set("contrast", (float)contrast/2.0);

        if (logfile != null) {
          if (t == 0) logfile.println("T " + trialno);
          logfile.println(t + " " + s + " " + k + " " + l);
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

