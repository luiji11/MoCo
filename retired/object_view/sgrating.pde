class sGrating { 

  public int xsize, ysize;  // size
  public int xpos, ypos;    // position       
  public float mean, contrast;     // mean/contrast
  public int tper;                 // temporal period
  public float th, sper;           // direction/spatial period/ temporal period
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

  public sGrating() { 
    xpos = displayWidth/2;
    ypos = displayHeight/2;
    xsize = 200;
    ysize = 200;
    mean = 128;
    contrast = 0.85;
    sper = 20;
    tper = 60;
    th_speed = 0;
    separable = 0;
    th = 0;
    sc = 1;
    talpha = 255;
    radius = 100;
    wt = 0;
    needsCompute = 1;
    visible = 1;
    id = 6;                // object id
    myshader = loadShader("sine.frag");
    //pg = createGraphics(displayWidth, displayHeight, OPENGL);
    //pg.noSmooth();
  }


  void compute() { 
      
      myshader.set("contrast",(float)contrast/2.0);
      myshader.set("mean",(float)mean/256.0);
      myshader.set("tper",(float)tper/60.0);  // in seconds\
      myshader.set("sper",(float)sper);
      myshader.set("th",radians((float)th));
      myshader.set("th_speed",(float)th_speed);
      myshader.set("separable",(float)separable);

      //myshader.set("resolution", float(displayWidth), float(displayHeight));  
  }

  void display(int t) {
        
    if (visible==1) {
       myshader.set("time", (millis()-t0)/1000.0);
       shader(myshader);
       rect(displayWidth/2,displayHeight/2,displayWidth,displayHeight);
    }
    
//    if (th_speed!=0) {
//      if (abs(th)<TWO_PI/2000.0) tag_pulse();  // passing through zero...
//    }
    
//     if (visible==1) {
//       myshader.set("time", millis()/1000.0);
//       pg.beginDraw();
//       pg.shader(myshader);
//       pg.rect(0,0,pg.width,pg.height);
//       pg.endDraw();
//       image(pg,displayWidth/2,displayHeight/2,displayWidth,displayHeight);
//    }   
    

//    if (th_speed!=0) {
//      if (t % th_speed == 0) tag_pulse();
//    } else {
//      if (t % tper == 0) tag_pulse();
//    }
  }
  
  
}

