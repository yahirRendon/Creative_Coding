/**************************************************************
 Project: Proof of concept based on an instagram ad I saw for a 
 relaxing drawing app that used mirroring/reflecting 
 the users lines and shapes. I added an auto draw feature.
 
 Author:  Yahir 
 
 Date:    August 2022
 
 Instructions:
 - MOUSE for drawing
 - SPACE toggle auto drawing using Perlin noise
 
 Notes:
 - Change number of reflection points within rf object initialization 
 - Processing 3.5.4
 
 **************************************************************/

Reflect rf;              // reflection drawing object
boolean drawingActive;   // toggle displaying drawing strokes
boolean handDrawing;     // engage user drawing vai mouse
int midX;                // center x of screen
int midY;                // center y of screen

Reflect rf2, rf3;


/**************************************************************
 SET UP FUNCTION
 **************************************************************/
void setup() {
  size(900, 900);
  colorMode(HSB, 360, 100, 100, 100);
  
  midX = width/2;
  midY = height/2;

  // initialize reflection object with number of points
  int num = int(random(2, 26));
  rf = new Reflect(num);

  background(0, 0, 100);
  
  delay(3000);
}


/**************************************************************
 DRAW FUNCTION
 **************************************************************/
void draw() {

  // update based on drawing style
  rf.update();
  if (handDrawing) {
    rf.update(mouseX, mouseY);
  }

  // display when active or hand drawing
  if (drawingActive || handDrawing) {
    rf.display();
  }

}

/**************************************************************
 KEYPRESSED FUNCTION
 
 SPACE  | toggle displaying draw strokes
 **************************************************************/
void keyPressed() {
  if(key == ' ') {
    drawingActive = !drawingActive;
  }
  
  if(key == 's' || key == 'S') {
    saveFrame("data/reflect_####.png"); 
  }
}

/**************************************************************
 MOUSEPRESSED FUNCTION
 
 LEFT  | hand drawing active
 **************************************************************/
void mousePressed() {
  if (mouseButton == LEFT) {
    handDrawing = true;
  }
}

/**************************************************************
 MOUSERELEASED FUNCTION
 
 LEFT  | hand drawing end
 **************************************************************/
void mouseReleased() {
  if (mouseButton == LEFT) {
    handDrawing = false;
  }
}

/**************************************************************
 *
 * Class for creating basic drawing bristle strokes
 *
 ************************************************************/
class Bristle {
  float x, y;    // x and y position of bristle
  float sze;     // size/width of bristle
  float h, s, b, a;

  /**
   * Constructor method for Bristle
   */
  Bristle() {
    x = 0;
    y = 0;
    sze = 0;
  }

  /**
   * Update the bristle elements
   *
   * @param {float} _x    bristle x position
   * @param {float} _y    bristle y position
   * @param {float} _sze  bristle size
   */
  void update(float _x, float _y, float _sze) {
    x = _x;
    y = _y;
    sze = _sze;
  }

  /**
   * display bristle
   */
  void display(float _h, float _s, float _b, float _a) { 
    h = _h;
    s = _s;
    b = _b;
    a = _a;
    fill(h, s+10, b+10, 5);
    stroke(h, s+10, b+10, 5);
    ellipse(x, y, sze * 1.5, sze * 1.5);
  
    fill(h, s, b, a);
    stroke(h, s, b, a);
    ellipse(x, y, sze, sze);
    
    fill(h, s + 20, b, 80);
    stroke(h, s + 20, b, 80);
    ellipse(x, y, sze/2, sze/2);
  }
}

/**************************************************************
 *
 * Class for reflective/mirror drawing
 *
 ************************************************************/
class Reflect {
  PVector pos;      // the actual draw node position
  int numPoints;    // number of reflective points around 360 degrees

  float xOff;       // the modulating of x position
  float yOff;       // the r modulating of y position
  float xOffSpd;    // the x modulation speed
  float yOffSpd;    // the y modulation speed

  float thickOff;   // the modulating of thickness
  float thickSpd;   // the thickness modulation speed

  float b;          // brightness value
  float bOff;       // the modulating of brightness
  float bSpd;       // the brightness modulation speed

  float h;          // hue value

  ArrayList<Bristle> bristles;  // array of bristle objects 

  /**
   * Constructor for Reflect object
   *
   * @param {int} _np    the number of reflection points
   */
  Reflect(int _np) {
    h = random(0, 360);
    bristles = new ArrayList<Bristle>();
    init(_np);
  }

  /**
   * initialize aid/reset reflect object
   */
  void init(int np) {
    numPoints = np;

    bristles.clear();
    for (int i = 0; i < numPoints; i++) {
      bristles.add(new Bristle());
    }

    xOff = random(2010);
    yOff = random(1000);
    xOffSpd = random(0.005, 0.01);
    yOffSpd = random(0.005, 0.01);
    //xOffSpd = random(0.002, 0.05);
    //yOffSpd = random(0.002, 0.05);
    pos = new PVector(random(350, 550), random(350, 550));

    thickOff = random(401);
    thickSpd = random(0.01, 0.035);

    bOff = random(340);
    bSpd = random(0.02, 0.06);
  }

  /**
   * update method when hand drawing
   *
   * @param {float} _x    desired x position
   * @param {float} _y    desired y position
   */
  void update(float _x, float _y) {
    pos.x = _x;
    pos.y = _y;

    // modulate thickness
    float thick = map(noise(thickOff), 0, 1, -4, 12);
    if (thick < 0) thick = 0;
    thickOff += thickSpd;

    // set angle increment amount
    float angleInc = 360.0 / bristles.size();

    // modulate color
    b = map(noise(bOff), 0, 1, 0, 80);
    bOff += bSpd;
    fill(h, 20, b, 50);
    stroke(h, 20, b, 50);

    // loop through each bristle point and display
    for (int i = 0; i < bristles.size(); i++) {
      float angle = atan2(pos.y - midY, pos.x - midX);
      if (i > 0) {
        angle += radians(angleInc * i);
      }

      float radius = dist(pos.x, pos.y, midX, midY);
      float x = 450 + cos(angle) * radius;
      float y = 450 + sin(angle) * radius;
      bristles.get(i).update(x, y, thick);
    }
  }

  /**
   * update method for auto drawing
   */
  void update() {
    // modulate movement
    pos.x += map(noise(xOff), 0, 1, -2, 2);
    pos.y += map(noise(yOff), 0, 1, -2, 2);
    
    // reset based on radius
    float dFromCenter = dist(pos.x, pos.y, 450, 450);
    if(dFromCenter > 425) init(numPoints);
    
    // reset based on window
    //if (pos.x > width || pos.x < 0 || pos.y > height || pos.y < 0) {
    //  init(numPoints);
    //}

    xOff += xOffSpd;
    yOff += yOffSpd;

    // modulate thickness
    float thick = map(noise(thickOff), 0, 1, -4, 12);
    if (thick < 0) thick = 0;
    thickOff += thickSpd;

    // set angle increment amount
    float angleInc = 360.0 / bristles.size();

    // modulate color
    b = map(noise(bOff), 0, 1, 0, 80);
    bOff += bSpd;
    fill(h, 20, b, 50);
    stroke(h, 20, b, 50);

    // loop through each bristle point and display
    for (int i = 0; i < bristles.size(); i++) {
      float angle = atan2(pos.y - midY, pos.x - midX);
      if (i > 0) {
        angle += radians(angleInc * i);
      }

      float radius = dist(pos.x, pos.y, midX, midY);
      float x = 450 + cos(angle) * radius;
      float y = 450 + sin(angle) * radius;
      bristles.get(i).update(x, y, thick);
      //bristles.get(i).display();
    }
  }

  /**
   * drawing bristles/strokes
   */
  void display() {
    // loop through each bristle point and display
    for (int i = 0; i < bristles.size(); i++) {
      bristles.get(i).display(h, 20, b, 50);
    }
  }
}
