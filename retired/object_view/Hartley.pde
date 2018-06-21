class Hartley { 

  public int xsize, ysize;  // size
  public int xpos, ypos;    // position       
  public float mean, contrast;     // mean/contrast
  public int tper;                 // temporal period
  public int max_k;
  public float sc;
  public int talpha;  
  public int needsCompute;
  public int visible;
  public int id;
  public int idxs;          // selected grating...
  public int nframes;
  ArrayList img, kidx, lidx, sidx;
  PrintWriter logfile;

  public Hartley() {
    xpos = displayWidth/2;
    ypos = displayHeight/2;
    xsize = 128;
    ysize = 128;
    mean = 128;
    contrast = 0.5;
    talpha = 255;
    max_k = 1;
    sc = 6.0;
    tper = 15;
    needsCompute = 1;
    visible = 1;
    id = 4;                // object id
    img = new ArrayList();  // images
    kidx = new ArrayList();
    lidx = new ArrayList();
    sidx = new ArrayList();
  }

  void openlog() {

    //close anything if open...
    if (logfile != null) {
      logfile.flush();
      logfile.close();
    }    
    logfile = createWriter(logname + "_" + nf(id,2));
  }

  void closelog() {
    if(logfile != null) {
    logfile.flush();
    logfile.close();
    logfile = null;
    }
  }


  void compute() {
    int i, j, v, k, l, s;

    if (needsCompute==1) {

      idxs = 0;

      img.clear();  // free images...
      kidx.clear();
      lidx.clear();

      for (k=-max_k;k<=max_k;k++) 
        for (l=-max_k ; l<= max_k; l++) {
          for (s=-1 ; s<=2 ; s=s+2) { 


            PImage frame = createImage(xsize, ysize, ARGB);

            frame.loadPixels();

            for (i=0;i<xsize;i++) {
              for (j=0;j<ysize;j++) {

                v = (int)(mean+s*contrast*mean*cas(TWO_PI*((float)(k*i+l*j)/xsize)));

                frame.pixels[i*xsize+j] = color(v, v, v, talpha);
              }
            }

            frame.updatePixels();

            img.add(0, frame); 
            kidx.add(0, k);
            lidx.add(0, l);
            sidx.add(0, s);
          }
        }

      nframes = img.size();

      openlog();

      needsCompute=0;
      
    }
  }

  void display(int t) {
    if (visible==1) {

      if ((t % tper)==0) {
        idxs = int(random(nframes));
        if (logfile != null) {
          if (t == 0) logfile.println("T " + trialno);
          logfile.println(t + " " + idxs + " " + sidx.get(idxs) + " " + kidx.get(idxs)+ " " + lidx.get(idxs));
          logfile.flush();
        }
      }

      pushMatrix();
      translate(xpos, ypos);
      scale(sc);
      image((PImage) img.get(idxs), 0, 0); 
      popMatrix();
      
      if ((t % tper)==0) tag_pulse();  // send a pulse...

    }
  }
}



float cas(float x) {
  return(cos(x)+sin(x));
}

