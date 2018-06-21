
class Cohere { 

  public int nelem;                // total number of elements
  public int nsame;                // number moving coherently
  public int xsize;
  public int ysize;
  public int xpos;
  public int ypos;
  public int radius;
  public int maxage;
  public int dir;
  public int step;
  public int needsCompute;
  public int id;
  ArrayList dots;
  PrintWriter logfile;

  public Cohere() { 
    nelem = 80;
    nsame = 60;
    xsize = displayWidth;
    ysize = displayHeight; 
    xpos = displayWidth/2;
    ypos = displayHeight/2;
    radius = 30;
    maxage = 30;
    step = 5;
    dir = 45;
    needsCompute = 1;
    id = 56;
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
    DotMove d;

    for (int n=0;n<nsame;n++) {
      d = new DotMove(xsize, ysize, radius , maxage, 0, step, dir, 0, this);    // add dots in the same direction
      dots.add(d);
    }
    
    for (int n=nsame;n<nelem;n++) {
      d = new DotMove(xsize, ysize, radius , maxage, 0, step, dir, 1, this);    // add dots in random directions
      dots.add(d);
    }

    openlog();
    needsCompute = 0;
  }


  void display(int t) {


    pushMatrix();
    translate(xpos, ypos);
    for (int i=0;i<nelem;i++) {
      DotMove d = (DotMove) dots.get(i);
      d.display(t);
    }
    popMatrix();
    
    if ((t % 60) == 0) tag_pulse(); //send a tag every 60 frames...
  }
}

class DotMove { 

  public int xsize, ysize;
  public int xpos, ypos;           // position       
  public int mean;                 // mean/contrast
  public int radius;               // radius of window or sigma of Gaussian
  public int r;                    // actual radius!
  public int born;
  public int maxage;
  public int dir;                  // direction angle
  public int flag;                 // move in dir or randomly?
  public int step;                 // step size in each frame
  public int needsCompute;
  public Cohere parent;

  public DotMove(int xs, int ys, int rd , int ma, int val, int st, int d, int f, Cohere o) { 

    xsize = xs;
    ysize = ys;

    xpos = int(random(xsize)-xsize/2);
    ypos = int(random(ysize)-ysize/2);
    radius = rd;
    r = rd;
    
    maxage = ma;
    born = int(random(maxage*5));

    if (f>0) 
       dir = int(random(360));
    else
       dir = d;

    mean = val;
    
    step = st;
    
    needsCompute = 0;

    parent = o;
  }

  void display(int t) {

    if (t>=born+maxage) {

      born = t;
      xpos = int(random(xsize)-xsize/2);
      ypos = int(random(ysize)-ysize/2);
            
      PrintWriter log = parent.getlog();
      if (log != null) {
        log.println(t + " " + xpos + " " + ypos + " " + mean + " " + maxage + " " + born + " " + r + " " + step + " " + dir + " " + flag);    // notice this logs information when the dots die!!
        log.flush();
      }
    }

    if (t>=born) {
      fill(mean);
      noStroke();
      ellipse(xpos+cos(float(dir)/360.0*TWO_PI)*step*(t-born), ypos+sin(float(dir)/360.0*TWO_PI)*step*(t-born), 2*r, 2*r);
    }
  }
}

