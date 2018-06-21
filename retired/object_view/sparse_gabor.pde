class sGabor { 

  public int ngabors;
  public int maxngabors = 64;
  public int xsize, ysize;  // size
  public int[] xpos, ypos;    // position       
  public float mean, contrast;     // mean/contrast
  public int tper;                 // temporal period
  public float[] th;
  public float[] ph;
  public float sper;           // direction/spatial period/ temporal period
  public float th_speed;           // speed of grating rotation... (in deg/frame)
  public float sc;                 // scale
  public int separable;            // spatio-temporal separable
  public int talpha;               // alpha
  public int radius;               // radius of window or sigma of Gaussian
  public int wt;                   // window type (0=none, 1=circular, 2= Gauss)
  public int needsCompute;
  public int visible;
  public int id;
  PShader myshader;
  PGraphics pg;
  PrintWriter logfile;


  public sGabor() { 
    ngabors = 4;
    radius = 50;

    xpos = new int[maxngabors];
    ypos = new int[maxngabors];
    th = new float[maxngabors];
    ph = new float[maxngabors];

    for (int ii = 0; ii < maxngabors; ii++)
    {
      xpos[ii] = 300;
      ypos[ii] = 300;
      th[ii] = 45.0;
      ph[ii] = 90.0;
    }

    xsize = 300;
    ysize = 300;
    mean = 128;
    contrast = 0.85;
    sper = 20;
    tper = 12;
    th_speed = 0;
    separable = 0;

    sc = 1;
    talpha = 255;

    wt = 0;
    needsCompute = 1;
    visible = 1;
    id = 16;                // object id
    myshader = loadShader("gabor.frag");
    //pg = createGraphics(displayWidth, displayHeight, OPENGL);
    //pg.noSmooth();
  }

  void openlog() {

    //close anything if open...
    if (logfile != null) {
      logfile.flush();
      logfile.close();
    }    
    logfile = createWriter(logname + "_" + nf(id, 2));
    logfile.println(ngabors);
  }

  void closelog() {
    if (logfile != null) {
      logfile.flush();
      logfile.close();
      logfile = null;
    }
  }

  void compute() { 
    //myshader.set("time",0.0);
    //myshader.set("side",(float)xsize);
    if (needsCompute == 1) {
      needsCompute=0;
      openlog();

      float[] xposout = new float[maxngabors];
      float[] yposout = new float[maxngabors];
      float[] thout = new float[maxngabors];
      float[] phout = new float[maxngabors];  

      for (int ii = 0; ii < maxngabors; ii++) {
        xposout[ii] = (float) xpos[ii];
        yposout[ii] = (float) ypos[ii];
        thout[ii] = radians((float)th[ii]);
        phout[ii] = radians((float)ph[ii]);
      }
      myshader.set("ngabors", ngabors);
      myshader.set("xpos", xposout);
      myshader.set("ypos", yposout);
      myshader.set("th", thout);
      myshader.set("ph", phout);
      myshader.set("radius", (float) radius);
    }
    //myshader.set("resolution", float(displayWidth), float(displayHeight));
  }

  void display(int t) {
  boolean flag;
  
    if (visible==1) {

      int n = t % tper;
      if (n==0) { 
        for (int ii = 0; ii < maxngabors; ii++)
        {
          xpos[ii] = (int)random(radius, displayWidth-radius);
          ypos[ii] = (int)random(radius, displayHeight-radius);
          th[ii] = (float) radians((float)random(0, 360));
          ph[ii] = (float) radians((float) 90.0);
        }

        if (logfile != null) {
          logfile.print(t + " ");
          for (int ii = 0; ii < ngabors; ii++)
          {
            logfile.print(xpos[ii] + " " + ypos[ii] + " " + th[ii] + " " + ph[ii] + " ");
          }
          logfile.println(radius);
          //logfile.flush();   it is flushed at the end...
        }
        tag_pulse();
        myshader.set("ngabors", (int) ngabors);



        float[] xposout = new float[maxngabors];
        float[] yposout = new float[maxngabors];
        float[] thout = new float[maxngabors];
        float[] phout = new float[maxngabors];


        for (int ii = 0; ii < maxngabors; ii++) {
          xposout[ii] = (float) xpos[ii];
          yposout[ii] = (float) ypos[ii];
          thout[ii] = ((float)th[ii]);
          phout[ii] = ((float)ph[ii]);
        }

        myshader.set("xpos", xposout);
        myshader.set("ypos", yposout);   
        myshader.set("th", thout);   
        myshader.set("ph", phout);   

        shader(myshader);
        rect(displayWidth/2, displayHeight/2, displayWidth, displayHeight);
      } else {
        shader(myshader);
        rect(displayWidth/2, displayHeight/2, displayWidth, displayHeight);
      }
    }
  }
}

