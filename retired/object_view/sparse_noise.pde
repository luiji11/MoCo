
class SparseNoise { 

  public int nelem;                // number of elements
  public int xsize;
  public int ysize;
  public int xpos;
  public int ypos;
  public int radius;
  public int rsize;
  public int maxage;
  public int needsCompute;
  public int id;
  ArrayList dots;
  PrintWriter logfile;

  public SparseNoise() { 
    nelem = 2;
    xsize = displayWidth;
    ysize = displayHeight; 
    xpos = displayWidth/2;
    ypos = displayHeight/2;
    radius = 50;
    rsize = 0;              // window of radius distribution
    maxage = 15;
    needsCompute = 1;
    id = 2;
    dots = new ArrayList();  // the dots.
  }

  void openlog() {

    //close anything if open...
    if (logfile != null) closelog();
    logfile = createWriter(logname + "_" + nf(id, 2));
  }

  void closelog() {

    logfile.flush();
    logfile.close();
    logfile = null;
  }

  PrintWriter getlog() {
    return logfile;
  }


  void compute() {
    Dot d;

    for (int n=0;n<nelem;n++) {
      d = new Dot(xsize, ysize, radius , rsize , maxage, 255, this);    // bright dots
      dots.add(d);
      d = new Dot(xsize, ysize, radius , rsize, maxage, 0, this);     // dark dots...
      dots.add(d);
    }

    openlog();
    needsCompute = 0;
  }


  void display(int t) {


    pushMatrix();
    translate(xpos, ypos);
    for (int i=0;i<2*nelem;i++) {
      Dot d = (Dot) dots.get(i);
      d.display(t);
    }
    popMatrix();
    
    if ((t % 60) == 0) tag_pulse(); //send a tag every 60 frames...
  }
}

class Dot { 

  public int xsize, ysize;
  public int xpos, ypos;           // position       
  public int mean;                 // mean/contrast
  public int radius;               // radius of window or sigma of Gaussian
  public int rsize;
  public int r;                    // actual radius!
  public int born;
  public int maxage;
  public int needsCompute;
  public SparseNoise parent;

  public Dot(int xs, int ys, int r, int rz, int ma, int val, SparseNoise o) { 

    xsize = xs;
    ysize = ys;

    xpos = int(random(xsize)-xsize/2);
    ypos = int(random(ysize)-ysize/2);
    radius = r;
    rsize = rz;
    r = radius + int(random(-rsize,rsize));

    maxage = ma;
    born = int(random(maxage*10));

    mean = val;
    needsCompute = 0;

    parent = o;
  }

  void display(int t) {

    if (t>=born+maxage) {
      born = t+int(random(maxage));
      xpos = int(random(xsize)-xsize/2);
      ypos = int(random(ysize)-ysize/2);
      r = radius + int(random(-rsize,rsize));
            
      PrintWriter log = parent.getlog();
      if (log != null) {
        log.println(t + " " + xpos + " " + ypos + " " + mean + " " + maxage + " " + born + " " + r);    // notice this logs information when the dots die!!
        log.flush();
      }
    }

    if (t>=born) {
      fill(mean);
      noStroke();
      ellipse(xpos, ypos, 2*r, 2*r);
    }
  }
}

