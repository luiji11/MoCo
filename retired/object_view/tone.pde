
import ddf.minim.*;
import ddf.minim.ugens.*;

class Tone { 

  public float frequency;
  public float amplitude;
  public int start;
  public int stop;

  public int visible;
  public int id;
  public int needsCompute;
  int flag;

  Oscil wave;

  public Tone() { 
    start = 0;
    stop = 60;
    amplitude = 1;
    frequency = 2000;
    id = 100;
    visible = 1; 
    needsCompute = 1;
    flag = 0;
  }

  void compute() {
    wave = new Oscil(frequency, 0, Waves.SINE );
    wave.patch( out );
    needsCompute = 0;
  }

  void display(int t) {
  
    if (visible==1) {

      if (frameCount>start && frameCount<stop){
        if(flag==0){
          flag=1;
          tag_pulse();
        }
        wave.amplitude.setLastValue(amplitude); } 
      else {
        if(flag==1) {
          flag = 0;
          tag_pulse();
        }
        wave.amplitude.setLastValue(0.0);
      }
    }
  }

}
