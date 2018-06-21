class sLocalizer { 

                                        
  PGraphics pg1;
  PGraphics pg2;
  PrintWriter logfile;

  int reverseTime = 6; //200 ms per phase
  int currentT = 0;
  int currentPos = 0;
  
  int switchTime = 60; //1000 ms
  int presTime = 48; //800 ms, 200 pause

  int nx = 9;//%12;
  int ny = 5;//7;
  int nreps = 5;//4;//5;

  
  IntList xpos, ypos;
  
  int szw;
  int szh;
  
  public int needsCompute;
  public int visible;
  public int id;


  public sLocalizer() { 
    
    needsCompute = 1;
    visible = 1;
    id = 17;                // object id
    
    
    szw = displayWidth/nx;
    szh = displayHeight/ny;
  
    int nx_per = 5;
    int ny_per = 5;
    
    pg1 = createCheckerBoard(szw,szh,nx_per,ny_per,0);
    pg2 = createCheckerBoard(szw,szh,nx_per,ny_per,1);
    
    //Generate the big list of locations
    IntList pos = new IntList();
    for(int ii = 0; ii < nreps; ii++)
      for(int jj = 0; jj < ny; jj++)
        for(int kk = 0; kk < nx; kk++)
          pos.append(jj + kk*ny);
     
     pos.shuffle(); // randomize
     xpos = new IntList();
     ypos = new IntList();
     
     for(int ii = 0; ii < pos.size(); ii++)
     {
       xpos.append(pos.get(ii) / ny);
       ypos.append(pos.get(ii) % ny);
     }
     
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
    if (needsCompute == 1) {
      //empty for now
      needsCompute = 0;
      openlog();
    }
  }

  void display(int t) {

    if (visible==1) {
      background(128);

      currentPos = t / switchTime;

      if(currentPos >= xpos.size()) {
        //Nothing to show 
        return;
      }
      
      if(t % switchTime == 0)
      {
        tag_pulse();
        
        if(logfile != null)
        {
          logfile.println(t + " " + (ypos.get(currentPos) + 1) + " " + (xpos.get(currentPos) + 1));
          logfile.flush();
        } 
      }
      
      int dx = (int)((float)szw * ((float)xpos.get(currentPos)+.5));
      int dy = (int)((float)szh * ((float)ypos.get(currentPos)+.5));
      
      if(t % switchTime < presTime)
      {
        if(floor(t/reverseTime) % 2 == 0)
          image(pg1,dx,dy);
        else
          image(pg2,dx,dy);
      }
    }
  }
}

PGraphics createCheckerBoard(int szw, int szh, int nx, int ny, int phase)
{
    PGraphics pg1 = createGraphics(szw,szh, OPENGL);
    pg1.noSmooth();
    pg1.beginDraw();
    pg1.noStroke();
    
    pg1.fill(0,255.0); //fill background black 
    pg1.rect(0.0,0.0,float(szw),float(szh));
    
    float dx = float(szw) / float(nx);
    float dy = float(szh) / float(ny);
    
    //white stuff
    pg1.fill(255,255.0);
    
    for(int jj = 0; jj < ny; jj++)
    {
      for(int ii = 0; ii < nx; ii++)
      {
        if ( ((ii+jj) % 2) == phase)
        {
          // draw white checks
          pg1.rect(ii*dx,jj*dy,dx,dy);
        }
      }
    }
    pg1.endDraw();
    
    return pg1;
}
