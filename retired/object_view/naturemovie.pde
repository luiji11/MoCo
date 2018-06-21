import processing.video.*;
  
class naturemovie { 

  
  public int movieParams = 0; //which set of movie params to use
  float[] startTimes;// = {20.8};
  int[] movieLengths;// = {420};
  
  PrintWriter logfile;

  
  int currentMovie;
  
  Movie mov;
  
  int switched = 0;
  
  int blankTime = 60;
  int lastSwitched = 0;
  
  //boolean sketchFullScreen() {
  //  return true;
  //}
  
  
  public int needsCompute;
  public int visible;
  public int id;
  
  PApplet parent;
  
  public naturemovie(PApplet parent) { 
    needsCompute = 1;
    visible = 1;
    id = 18;
    
    currentMovie = 0;
    
    size(displayWidth,displayHeight,P2D);
    imageMode(CENTER); // all images with respect to their centers...
    rectMode(CENTER);
    noStroke();
    noCursor();
    frameRate(60);
    
    this.parent = parent;

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
      if(movieParams == 0) {
          //Original movie
          mov = new Movie(parent,"C:\\/Users/vincentbonin/Documents/nature.mp4");
          startTimes = new float[61];
          movieLengths = new int[61];
          for(int ii = 0; ii < 11; ii++)
          {
            startTimes[ii] = 20.8;
            movieLengths[ii] = 30;
          }
          for(int ii = 11; ii < 61; ii++)
          {
            startTimes[ii] = 20.8;
            movieLengths[ii] = 6;
          }
          movieLengths[0] = 300;
      } else if(movieParams == 1) {
          //courtney
          mov = new Movie(parent,"/Users/vincentbonin/Documents/nature.mp4");
          startTimes = new float[1];
          startTimes[0] = 20.8;
          movieLengths = new int[1];
          movieLengths[0] = 420;
      } else if(movieParams == 2) {
          //fast movie
          mov = new Movie(parent,"C:\\Users\\dario\\Documents\\naturalmovies\\naturemovie_fast_clip1_fixed.m4v");
          startTimes = new float[61];
          movieLengths = new int[61];
          for(int ii = 0; ii < 11; ii++)
          {
            startTimes[ii] = 0;
            movieLengths[ii] = 30;
          }
          for(int ii = 11; ii < 61; ii++)
          {
            startTimes[ii] = 0;
            movieLengths[ii] = 6;
          }
          movieLengths[0] = 600;
          startTimes[0] = 0;
      } else if(movieParams == 3) {
          //slow movie
          mov = new Movie(parent,"C:\\Users\\dario\\Documents\\naturalmovies\\naturemovie_slow_clip1_fixed.m4v");
          startTimes = new float[26];
          movieLengths = new int[26];
          for(int ii = 0; ii < 26; ii++)
          {
            startTimes[ii] = 0.0;
            movieLengths[ii] = 12;
          }
          movieLengths[0] = 600;
      }          
      else if(movieParams == 4) {
          //slow movie
          mov = new Movie(parent,"C:\\Users\\dario\\Documents\\naturalmovies\\naturemovie_fast_clip2_fixed.m4v");
          startTimes = new float[1];
          movieLengths = new int[1];
          startTimes[0] = 0;
          movieLengths[0] = 600;
      }          
      else if(movieParams == 5) {
          //slow movie
          mov = new Movie(parent,"C:\\Users\\dario\\Documents\\naturalmovies\\naturemovie_slow_clip2_fixed.m4v");
          startTimes = new float[1];
          movieLengths = new int[1];
          startTimes[0] = 0;
          movieLengths[0] = 600;
      }
      else if(movieParams == 6) {
          //slow movie
          mov = new Movie(parent,"C:\\Users\\dario\\Documents\\naturalmovies\\naturemovie_fast_clip3_fixed.m4v");
          startTimes = new float[1];
          movieLengths = new int[1];
          startTimes[0] = 0;
          movieLengths[0] = 600;
      }
      else if(movieParams == 7) {
          //slow movie
          mov = new Movie(parent,"C:\\Users\\dario\\Documents\\naturalmovies\\naturemovie_slow_clip3_fixed.m4v");
          startTimes = new float[1];
          movieLengths = new int[1];
          startTimes[0] = 0;
          movieLengths[0] = 600;
      } 
      else if(movieParams == 8) {
          //For Courtney
          mov = new Movie(parent,"C:\\Users\\dario\\Documents\\naturalmovies\\naturemovie_slow_clip1_fixed.m4v");
          startTimes = new float[18];
          movieLengths = new int[18];
          for(int ii = 0; ii < 18; ii++)
          {
            startTimes[ii] = ii*9.0;
            movieLengths[ii] = 9;
          }
          blankTime = 14*60;
      }
      
      needsCompute = 0;
      openlog();
    }
  }
  
  void resetMovie() {
    println("In reset movie");
    if(currentMovie < startTimes.length)
    {
      println("Reset movie");
      mov.jump(startTimes[currentMovie]);
      mov.play();
      switched = 2;
    }
  }
  
  //void movieEvent(Movie m)
  //{

  //}
    
  void display(int t) {
    if(t == 0)
    {
      mov.play();
      mov.volume(0);
      switched = 0;
      resetMovie();
    }
    
    background(128);
    
    if(currentMovie >= startTimes.length) {
      return;
    }
    
    switch(switched)
    {
      case 0: // regular state
        if(mov.available()) {
          mov.read();
        }
        image(mov,width/2,height/2,width,height);
        
        if(mov.time() - startTimes[currentMovie] >= ((float) movieLengths[currentMovie]))
        {
          switched = 1;
          pulseAndLog(t);
          lastSwitched = t;
        }
        else if(t % 60 == 0)
        {
          pulseAndLog(t);
        }
        break;
      case 1: //wait state
        if(t - lastSwitched >=blankTime) {
          currentMovie++;
          resetMovie();
        }
        break;
      case 2: //loading state
        if(mov.available()) {
          mov.read(); // ready for display on next frame
          pulseAndLog(t);
        }
        break;
    }
  }
  
  void pulseAndLog(int t){
      //Log
      tag_pulse();

      String tag = t + " " + currentMovie + " " + movieLengths[currentMovie] + " " + mov.time() + " " + switched + " " + movieParams;
      
      println(tag);
      logfile.println(tag);
      logfile.flush();
      
      //pulse
      if(switched == 2)
      {
        switched = 0;
      }
        
  }
}
