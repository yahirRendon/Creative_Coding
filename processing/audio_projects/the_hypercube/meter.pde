/*
meter class
 */
class Meter {
  float x, y;
  float amp;
  float widthHeight;
  int sampleNum;


  Meter(float _x, float _y, int _sampleNum) {
    x = _x;
    y = _y;
    widthHeight = 50;
    sampleNum = _sampleNum;
  }

  void update(Amplitude _amp) {
    amp = map(_amp.analyze(), 0, 1, 0, 30);
  }

  void display(int _dimension) {
    rectMode(CENTER);
    if (_dimension == 0 && showMeters) {
      if (amp < .05) {
        stroke(255, 170);
        fill(93, 114, 118, 170);
      } else {
        stroke(255);
        fill(93, 114, 118);
      }

      rect(x, y, 50 + amp, 50 + amp);

      if (amp < .05) {
        fill(255, 170);
      } else {
        fill(255);
      }    
      textAlign(CENTER, CENTER);
      textSize(18);
      text(sampleNum + 1, x, y);
    }
  }
}
