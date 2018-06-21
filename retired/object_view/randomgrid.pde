
import java.util.Arrays;
import java.util.Comparator;

class randomgrid { 
  
  int nx = 16*3;
  int ny = 9*3;
  float radius = 60;//22.5;
  int nframes = 4500;
  float sparseness = .01;



//maze world
/*
  int nx = 16*3;
  int ny = 9*3;
  float radius = 15;//22.5;
  int nframes = 4500;
  float sparseness = 1;
*/
  PrintWriter logfile;
  int nframesper = 12;
  int blanktime = 2; // 167 ms pres, 2 ms blank
    
  public int needsCompute;
  public int visible;
  public int id;
  
  int[] xposs, yposs, timess, colss;
  int curridx = 0;
  
  public randomgrid() { 
    needsCompute = 1;
    visible = 1;
    id = 19;
    
    
    size(displayWidth,displayHeight,P2D);
    imageMode(CENTER); // all images with respect to their centers...
    rectMode(CENTER);
    noStroke();
    noCursor();
    frameRate(60);
    
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
      if(sparseness < 1)
      {
        int ndotsper = (int) (sparseness * (float) nframes);
        int ns = 0;
        int[] xpos, ypos, times, col;
        xpos = new int[nx*ny*ndotsper];
        ypos = new int[nx*ny*ndotsper];
        times = new int[nx*ny*ndotsper];
        col = new int[nx*ny*ndotsper];
        for(int jj = 0; jj < nx; jj++)
        {
          for(int ii = 0; ii < ny; ii++)
          {
            for(int kk = 0; kk < ndotsper; kk++)
            {
              int theframe = (int) random(0,nframes);
              xpos[ns] = jj;
              ypos[ns] = ii;
              times[ns] = theframe;
              col[ns] = (int) random(0,2);
              ns++;
            }
          }
        }
        
        Integer[] idx = argSort(times);
        
        xposs = new int[nx*ny*ndotsper];
        yposs = new int[nx*ny*ndotsper];
        timess = new int[nx*ny*ndotsper];
        colss = new int[nx*ny*ndotsper];
        
        for(int ii = 0; ii < nx*ny*ndotsper; ii++)
        {
          xposs[ii] = xpos[idx[ii]];
          yposs[ii] = ypos[idx[ii]];
          timess[ii] = times[idx[ii]];
          colss[ii] = col[idx[ii]];
        }
      }
      else
      {
        xposs = new int[nx*ny*nframes];
        yposs = new int[nx*ny*nframes];
        timess = new int[nx*ny*nframes];
        colss = new int[nx*ny*nframes];
        
        int ns = 0;
        for(int kk = 0; kk < nframes; kk++)
        {
          for(int jj = 0; jj < nx; jj++)
          {
            for(int ii = 0; ii < ny; ii++)
            {
                xposs[ns] = jj;
                yposs[ns] = ii;
                timess[ns] = kk;
                colss[ns] = (int) random(0,2);
                ns++;
            }
          }
        }
        
      }
      needsCompute = 0;
      //openlog();
      
      background(128);
      openlog();
    }
  }
  
      
  void display(int t) {
    
    

    
    if(t % nframesper == 0)
    {
      //draw circles
      float w = ((float) displayWidth / (float) nx);
      float h = ((float) displayHeight / (float) ny);
      

      
      while(curridx < xposs.length && timess[curridx] == (t/nframesper))
      {
        //read info
        fill(colss[curridx]*255);
        float dx = (xposs[curridx]+.5)*w;
        float dy = (yposs[curridx]+.5)*h;
        if(sparseness < 1) {
          ellipse(dx, dy, radius*2,radius*2);
        }
        else
        {
          rect(dx, dy, w,h);
        }
        
        String tag = t + " " + yposs[curridx] + " " + xposs[curridx] + " " + colss[curridx];
        logfile.println(tag);
        
        curridx++;
      }
      
      logfile.flush();
      
    }
    else if(t % nframesper == (nframesper - blanktime))
    {
      //blank
      background(128);
    }
    
    if(curridx < xposs.length && t % 60 == 0)
    {
      tag_pulse();
    }
  }
  
}

Integer[] argSort(int[] array) {
  IndexComparator ic = new IndexComparator(array);
  Integer[] indices = ic.createIndexArray();
  Arrays.sort(indices, ic);
  return indices;
}


/*
 A Comparator class to implement argsort
 */
class IndexComparator implements Comparator<Integer> {
  private final int[] array;

  public IndexComparator(int[] array) {
    this.array = array;
  }

  public Integer[] createIndexArray() {
    Integer [] indices = new Integer[this.array.length];
    for (int i = 0; i < array.length; i++) {
      indices[i] = i;
    }
    return indices;
  }

  public int compare(Integer index1, Integer index2) {
    return Integer.compare(this.array[index1],this.array[index2]);
  }

}

