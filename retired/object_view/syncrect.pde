class SyncRect { 

  public int xsize, ysize;  // size
  public int xpos, ypos;    // position   
  public int visible;
  public int id;
  public int needsCompute;

  public SyncRect() { 
    xpos = 30;
    ypos = 30;
    xsize = 60;
    ysize = 60;
    id = 1;
    visible = 1;
    needsCompute = 0;
  }

  void compute() {
  }

  void display(int t) {
    if (visible==1) {
//      fill(frameCount % 2 == 0 ? 255 : 0);
//      rect(xpos, ypos, xsize, ysize);
    if(frameCount % 60 == 0 && frameCount>0){
      fill(255);
      rect(xpos,ypos,xsize,ysize);
      tag_pulse();
    } else {
      fill(0);
      rect(xpos,ypos,xsize,ysize);
    }


    }
  }
}

