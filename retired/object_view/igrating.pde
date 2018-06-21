class iGrating { 

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
  public int wt;                  // window type (0=none, 1=circular, 2= Gauss)
  public int needsCompute;
  public int visible;
  public int id;
  ArrayList img;

  public iGrating() { 
    xpos = displayWidth/2;
    ypos = displayHeight/2;
    xsize = displayWidth/8;
    ysize = displayHeight/8;
    mean = 128;
    contrast = 0.85;
    sper = 100;
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
    id = 5 ;                // object id
    img = new ArrayList();  // images
  }


  void compute() {
    int i, j, v;

    if (needsCompute==1) {
      
      float cth,sth;
      
      cth = cos(radians(th));
      sth = sin(radians(th));

      img.clear();  // free images...
      
      for (int n=0;n<tper;n++) {
        PImage frame = createImage(xsize, ysize, ARGB);

        frame.loadPixels();
        for (i=0;i<ysize;i++) {
          for (j=0;j<xsize;j++) {

            if (separable==0)
              v = (int)(mean+contrast*mean*cos(TWO_PI*((float)n/tper+((float)j*cth+(float)i*sth)/sper)));
            else
              v = (int)(mean+contrast*mean*cos(TWO_PI*(float)n/tper)*cos(TWO_PI*((float)n/tper+((float)j*cth+(float)i*sth)/sper)));

            switch(wt) {
            case 0:
               frame.pixels[i*xsize+j] = color(v, v, v,  talpha);
              break;
            case 1: // circular
              frame.pixels[i*xsize+j] = color(v, v, v, pow(i-xsize/2, 2)+pow(j-ysize/2, 2)<pow(radius, 2) ? 255 : talpha);
              break;
            case 2: // exponential
              float r2 = pow(i-xsize/2, 2)+pow(j-ysize/2, 2);
              float w = exp(-r2/(2*pow(radius, 2)));
              frame.pixels[i*xsize+j] = color(v, v, v, (int) (255*w));
              break;
            default: // uniform alpha
              frame.pixels[i*xsize+j] = color(v, v, v, talpha);
              break;
            }
          }
        }
        frame.updatePixels();
        println(xsize);
        frame.resize((int)(xsize*sc),(int)(ysize*sc));
        img.add(0, frame);
      }
    }
    needsCompute=0;
  }

  void display(int t) {
    if (visible==1) {
        set((int)(xpos-xsize*sc/2),(int)(ypos-ysize*sc/2),((PImage) img.get(t % tper)));
    }
  }
}

