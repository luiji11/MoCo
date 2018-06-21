class calibrator { 

  public int xsize, ysize;  // size
  public int xpos, ypos;    // position       
  public int r,g,b;
  public int needsCompute;
  public int visible;
  public int id;

  PShader myshader;
  PGraphics pg;

  public calibrator() { 
    xpos = displayWidth/2;
    ypos = displayHeight/2;
    r = 128;
    g = 128;
    b = 128;
    needsCompute = 1;
    visible = 1;
    id = 255;                // object id
    myshader = loadShader("calibrate.frag");
  }


  void compute() { 
      
      myshader.set("r",(float)r/256.0);
      myshader.set("g",(float)g/256.0);
      myshader.set("b",(float)b/256.0);

      //myshader.set("resolution", float(displayWidth), float(displayHeight));  
  }

  void display(int t) {
        
    if (visible==1) {
       myshader.set("time", (millis()-t0)/1000.0);
       shader(myshader);
       rect(displayWidth/2,displayHeight/2,displayWidth,displayHeight);
    }
  }

  
}

