class retinotopy { 

  public int id;

  public int checker;
  public int tper;
  public int th;
  public float contrast;
  public float kappa;
  public int cycle;      // period of one screen cycle in frames!

  public int needsCompute;
  public int visible;

  PShader myshader;

  public retinotopy() {

    needsCompute = 0;
    visible = 1;
    id = 55;                // object id

    contrast = 1;
    cycle = 600;            // 10 sec cycle
    th = 0;
    tper = 20;
    checker = 60;
    kappa = 40;

    myshader = loadShader("retinotopy.frag");
  }

  void openlog() {
  }

  void closelog() {
  }


  void compute() {
  }

  void display(int t) {

    myshader.set("th",      (float) th);
    myshader.set("checker", (float) checker);
    myshader.set("kappa",   (float) kappa);
    myshader.set("frame",   (float) t);
    myshader.set("width",   (float) displayWidth);
    myshader.set("height",  (float) displayHeight);


    switch(th) {
    case 0:
    case 1:
      myshader.set("speed",(float)displayWidth/(float)cycle);  // in pixels per frame
      break;
    case 2:
    case 3:
      myshader.set("speed",(float)displayHeight/(float)cycle);  // in pixels per frame
      break;
    }

    if (visible==1) {

      if ( (t % cycle == 0) ) tag_pulse();

      if ( (t % tper) == 0 ) {

        contrast = -contrast;
        myshader.set("contrast", (float) contrast);
      }
    } else {
      myshader.set("contrast", 0.0);
    }

    shader(myshader);
    rect(displayWidth/2, displayHeight/2, displayWidth, displayHeight);  // full screen...
  }
}

