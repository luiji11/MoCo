

class MovingLine { 

  public int x0, y0;  // starting endpoint 1
  public int x1, y1;  // starting endpoint 2

  public float x, y;  // actual position

  public float ax0, ay0; // velocity #1
  public float ax1, ay1; // velocity #2

  public int p0, p1;   // periods

  public int sw;      // stroke width
  public int mean;    // stroke color

  public int flicker;
  public int fper;

  public int visible;

  public int lflag;  // leap/mouse flag
  public float th0;

  public int id;

  public int needsCompute;

  public MovingLine() { 

    x0 = displayWidth/2;
    y0 = 0;
    x1 = displayWidth/2;
    y1 = displayHeight;

    ax0 = displayWidth/2;
    ay0 = 0;
    ax1 = displayWidth/2;
    ay1 = 0;

    p0 = 3600;
    p1 = 3600;

    mean = 0;
    sw = 32;
    th0 = 0;

    flicker = 1;
    fper = 20;

    lflag = 1;  // allow leap control by default...

    id = 3;
    visible = 1;

    needsCompute = 0;
  }

  void compute() {
  }

  void display(int t) {
    //Hand h;
    //ArrayList hl;
    //PVector dyn, pos;

    if (visible==1) {

      if (lflag == 1) {

//        if (leap.countHands()>0) {
//
//          hl = leap.getHands();
//          h = (Hand) hl.get(0);  
//          dyn = h.getDynamics();  
//
//
//          th = (-dyn.y/360.0*TWO_PI);
//          
//          th = 0; // for now...
//          
//          pos = h.getPosition();
//
//          if (pos.x<200)
//            th0 = 0;
//          if (pos.x>1450)
//            th0 = PI/2;
//
//          th += th0;
//
//          //sw = round(100+pos.z);
//          sw = 250;
//          x0 = round(0.8*x0 + 0.2 * ( displayWidth/2 +  (pos.x-800) *2.0) );
//          y0 = round(0.8*y0 + 0.2 * (displayHeight/2 +  (pos.y-450) *2.0 ) ) ;
//
//          if (t % 15 == 0) mean = 255-mean;
//        }


        background(128);
        //if(t % (fper/2) == 0) mean = 255-mean;
        
        stroke(mean);
        stroke(0);
        strokeWeight(sw);

        x0 = int(0.8*x0 + 0.2*mouseX);
        y0 = int(0.8*y0 + 0.2*mouseY);
        
        if(barori==0)
          line(0,y0,displayWidth,y0);
          else
          line(x0,0,x0,displayHeight);
        
  
        //line(x0-1000.0*sin(th), y0-1000.0*cos(th), x0+1000.0*sin(th), y0+1000.0*cos(th));
        
      } 
      else {

        float a = x0 + ax0 * sin(TWO_PI*t/p0);
        float b = y0 + ay0 * sin(TWO_PI*t/p0);
        float c = x1 + ax1 * sin(TWO_PI*t/p1);
        float d = y1 + ay1 * sin(TWO_PI*t/p1);

        strokeWeight(sw);
        smooth();
        if ((flicker==1) && (t % fper)==0) mean = 255-mean;
        stroke(255);
        line(a, b, c, d);
      }
    }
  }
}

