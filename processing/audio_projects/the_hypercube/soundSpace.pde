/*
  * Class for creating mapped soundspaces that will control
 * amplitude of SoundFiles
 */
class SoundSpace {
  float x, y;    // center position of grid space
  float range;    // range of audio grid
  float amp;      // track amplitude value within grid space
  boolean mute;  // toggle mute of amplitude 
  float ampD;
  boolean muteD;
  float valx;      // track the x value (for dimension 2)
  float valy;      // track the y value (for dimension 2);

  int locNum;    // value that is used when looping to assign amplitudes  

  /*
  * Default constructor
   * @PARAM float _x: x pos
   * @PARAM float _y: y pos
   * @PARAM float _range: span of the sound space
   * @PARAM int _lc: assign location number that will conect to SoundFile
   */
  SoundSpace(float _x, float _y, float _range, int _lc) {
    x = _x;
    y = _y;
    range = _range;
    amp = 0;
    locNum = _lc;
    ampD = 0;
    valx = 500;
    valy = 460;
  }

  /*
  * Method for displaying soundspace
   */
  void display() {
    fill(255, 100);
    if (hCube.dimension == 0) {

      ellipse(x, y, range, range);
      ellipse(x, y, 50, 50);

      fill(51, 78, 83);
      textAlign(CENTER, CENTER);
      textSize(18);

      text(locNum + 1, x, y);
    } else {
      rect(500, 500, 600, 600);
    }
  }
  
  /*
  * Method for updating amplitude
  * #FIX: is this needed
  */
  void updateAmp2(float _cx, float _cy) {
    if (!initialRun) {
      if (mute) {
        amp = 0;
      } else {
        if (hCube.engaged) {
          if (hCube.dimension == 0 && !hCube.transforming) {
            float d = abs(dist(x, y, _cx, _cy));
            float dm = map(d, 0, range/2, 1, 0);
            if (dm > .95) {
              dm = 1;
            }
            if (dm < 0) {
              dm = 0;
            }  
            amp = dm;
          }
        } else {
          if (hCube.dimension == 0 && !hCube.transforming) {
            float d = abs(dist(x, y, hCube.a1.x, hCube.a1.y));
            float dm = map(d, 0, range/2, 1, 0);
            if (dm > .95) {
              dm = 1;
            }
            if (dm < 0) {
              dm = 0;
            } 
            amp = dm;
          }
        }
        // check if vertex is moving or engaged
        if (hCube.engaged) {
          // check if dimension is 1 and vertex a not moving
          if (hCube.dimension == 1 && !hCube.transforming) {
            valx = map(mouseX, 0, width, 0, 10);
            valy = map(mouseY, 0, height, 0, 10);
          }
        }
      }
    }
  }
  
  /*
  * Method for updating amplitude 
  * @PARAM float _cx: current x value
  * @PARAM float _cy: current y value
  */
  void updateAmp(float _cx, float _cy) {
    if (!initialRun) {
      if (mute) {
        amp = 0;
      } else {
        if (hCube.engaged) {
          if (hCube.dimension == 0 && !hCube.transforming) {
            amp = getAmplitude(_cx, _cy);
          }
        } else {
          if (hCube.dimension == 0 && !hCube.transforming) {
            amp = getAmplitude(hCube.a1.x, hCube.a1.y);
          }
        }

        // for dimension 1 check if vertex is moving or engaged
        if (hCube.engaged) {
          // check if dimension is 1 and vertex a not moving
          if (hCube.dimension == 1 && !hCube.transforming) {
            //valx = map(mouseX, 300, 700, 0, 10);
            //valy = map(mouseY, 300, 700, 0, 10);
            valx = _cx;
            valy = _cy;
          }
        }
      }
    }
  }
  
  // Getter method returns mapped amplitude
  float getAmplitude(float _x, float _y) {
    float d = abs(dist(x, y, _x, _y));
    float dm = map(d, 0, range/2, 1, 0);
    if (dm > .95) {
      dm = 1;
    }
    if (dm < 0) {
      dm = 0;
    }  
    return dm;
  }

  float getAmpD() {
    return ampD;
  }


  float getAmp() {
    return amp;
  }

  float getValx() {
    return valx;
  }

  float getValy() {
    return valy;
  }
}
