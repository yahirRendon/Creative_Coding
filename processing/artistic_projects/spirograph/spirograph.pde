/**************************************************************
 Project:  Recreating the classic spirograph drawing tool with
 the ability to add more gears to create even more
 unique designs.  
 
 Author:  Yahir 
 Date:    January 2022
 
 
 Notes:
 - Processing 3.5.4
 
 Instructions:
 1. SPACE KEY to start drawing
 2. hide show gears/info...
 3. adjust angles and gear radius... 
 
 
 **************************************************************/
PFont myFont;
boolean drawing;             // toggle drawing on/off
boolean showDetails;         // toggle showing description/details
float drawSpeed;             // the drawing speed for the large gear 
float penRadius;             // the offest of the pen within the final gear
ArrayList<PVector> pen;      // show pen ink
ArrayList<PVector> penColor; // store pen ink color
int inkLength;               // the length of ink trail 

Gear gear0;                  // large outter ring housing all others
Gear gear1;                  // first inner gear
Gear gear2;                  // second inner gear

float penHue;                // pen ink hue
float penSat;                // pen ink saturation
float penBri;                // pen ink brightness

// general color palette
color light;
color dark;
color bright;


/**************************************************************
 SET UP FUNCTION
 **************************************************************/
void setup() {
  size(1000, 1000);
  colorMode(HSB, 360, 100, 100, 100);
  
  myFont = createFont("Roboto", 60);
  textFont(myFont);

  light = color(0, 0, 95);
  dark = color(0, 0, 13);
  bright = color(0, 94, 90);

  showDetails = true;
  drawing = false;
  
  pen = new ArrayList<PVector>();
  penColor = new ArrayList<PVector>();
  inkLength = 5000;
  
  drawSpeed = 0.7;
  penRadius = 5;
  penHue = 267;
  penSat = 80;
  penBri = 89;
  gear0 = new Gear(500, 500, 360, 90, drawSpeed, 0);
  gear1 = new Gear(240, 180, 1, gear0);
  gear2 = new Gear(180, 90, 2, gear1); 

}

/**************************************************************
 DRAW FUNCTION
 **************************************************************/
void draw() {
  background(light);
  
  // calculate pen tip location
  float penX = gear2.center.x + cos(radians(gear2.angle)) * (gear2.radius - penRadius);
  float penY = gear2.center.y + sin(radians(gear2.angle)) * (gear2.radius - penRadius);

  if(showDetails) {
    // text info
    details();

    // display gears
    gear2.displayChild();
    gear1.displayChild();
    gear0.display();
    
    // display chain of lines from gear to gear
    stroke(bright);
    strokeWeight(2);
    line(gear0.center.x, gear0.center.y, gear1.center.x, gear1.center.y);
    line(gear1.center.x, gear1.center.y, gear2.center.x, gear2.center.y);
    line(gear2.center.x, gear2.center.y, penX, penY);
  }
  
  // draw ink
  if (drawing) {
    // update gear calculations
    gear0.update();
    gear1.updateChild(gear0);
    gear2.updateChild(gear1);

    // populate pen array to be like ink
    pen.add(new PVector(penX, penY));
    penColor.add(new PVector(penHue, penSat, penBri));
    if (pen.size() > inkLength) {
      pen.remove(0);
      penColor.remove(0);
    }
    
    penHue+= 360.0/inkLength;
    if(penHue > 360) penHue = 0;
    
  }
  
  // display pen ink
    noStroke();
    for (int i = 0; i < pen.size(); i++) {
      fill(penColor.get(i).x, penColor.get(i).y, penColor.get(i).z);
      ellipse(pen.get(i).x, pen.get(i).y, 5, 5);
    }
}

/**************************************************************
 KEY PRESSED FUNCTION
 
 KEY SPACE  | toggle draw on/off
 KEY N      | cycle through display types
 **************************************************************/
void keyPressed() {
  if (key == ' ') {
    drawing = ! drawing;
  }

  if (key == 'n' || key == 'N') {
    showDetails = !showDetails;
  }
}
/*
* text details about gear and sketch
*/
void details() {
  textAlign(CENTER, CENTER);
  fill(dark);
  textSize(32);
  text("spirograph", width/2, 50);
  
  textAlign(LEFT);
  textSize(14);
  
  text("GEAR 0", 25, 700);
  text("angle: " + gear0.angle, 25, 725);
  text("radius: " + gear0.radius, 25, 750);
  
  text("GEAR 1", 25, 800);
  text("angle: " + gear1.angle, 25, 825);
  text("radius: " + gear1.radius, 25, 850);
  
  text("GEAR 2", 25, 900);
  text("angle: " + gear2.angle, 25, 925);
  text("radius: " + gear2.radius, 25, 950);
  
  text("RATIOS", 175, 800);
  text(gear0.radius/gear1.radius, 175, 825);
  text(gear1.radius/gear2.radius, 175, 850);
  
  text("PEN OFFSET", 175, 900);
  text(gear2.radius - penRadius, 175, 925); 
}

/*
 * Class for creating nested gears that mimicks action of a
 * spirograph drawing tool
 */
class Gear {
  PVector center;       // center point
  PVector pos;          // moving point
  float radius;         // radius of gear
  float diam;           // diam of gear
  float angle;          // start angle of gear
  float speed;          // speed of spin/revolution
  int id;               // id of gear for setting spin direction

  int toothSize;
  int step;
  
  color[] colors = new color[]{color(206, 100, 62), color(321, 71, 99), color(177, 94, 90), color(21, 67, 100)};
  color gearColor;

  /*
   * Constructor method for setting the parent or root gear
   *
   * @param: _x        x position CENTER
   * @param: _y        y position CENTER
   * @param: _radius   radius of gear
   * @param: _angle    start angle from center
   * @param: _speed    speed of gear revolutions
   * @param: _id       the id of gear (gears spin in alternating directions)
   */
  Gear(float _x, float _y, float _radius, float _angle, float _speed, int _id) {
    center = new PVector(_x, _y);
    pos = new PVector();
    radius = _radius;
    diam = radius * 2;
    angle = _angle;
    speed = _speed;
    id = _id;

    // set moving position of this gear given desired angle of this year
    pos.x = center.x + cos(radians(angle)) * radius;
    pos.y = center.y + sin(radians(angle)) * radius;

    toothSize = 6;
    float mes = degrees(6 / radius);
    step = ceil(mes);
    
    int index = id;
    if(id > 3) index = id % 3;
    gearColor = colors[index];
   
  }

  /*
   * Constructor method for setting nested gears
   *
   * @param: _radius   radius of gear
   * @param: _angle    start angle from center
   * @param: _id       the id of gear (gears spin in alternating directions)
   * @param: _parent   parent gear
   */
  Gear(float _radius, float _angle, int _id, Gear _parent) {
    center = new PVector();
    pos = new PVector();
    angle = _angle;
    radius = _radius;
    diam = radius * 2;
    id = _id;

    float arcLength = _parent.radius * radians(360);  
    float arcMeasure = arcLength / radius;  
    float ratio = 360.0 / degrees(arcMeasure);

    speed = _parent.speed / ratio;

    // angle of parent pos to parent center
    float parentAngleToCenter = atan2(_parent.center.y - _parent.pos.y, _parent.center.x - _parent.pos.x);

    // find center of this gear relative to parent
    center.x = (_parent.pos.x + cos(parentAngleToCenter) * (diam)) + (cos(radians(_parent.angle)) * radius);
    center.y = (_parent.pos.y + sin(parentAngleToCenter) * (diam)) + (sin(radians(_parent.angle)) * radius);

    // set moving position of this gear given desired angle of this gear
    pos.x = center.x + cos(radians(angle)) * radius;
    pos.y = center.y + sin(radians(angle)) * radius;  

    toothSize = 6;
    float mes = degrees(6 / radius);
    step = ceil(mes);
    
    int index = id;
    if(id > 3) index = id % 3;
    gearColor = colors[index];
  }

  /*
   * Update the parent gear
   *
   */
  void update() {
    // alternate gear spin/rotation of gears
    if (id % 2 == 0) {
      angle += speed;
    } else {
      angle -= speed;
    }

    // set moving position of this gear given desired angle of this gear
    pos.x = center.x + cos(radians(angle)) * radius;
    pos.y = center.y + sin(radians(angle)) * radius;
  }

  /*
   * update children or nested gear based on direct parent gear
   *
   * @param: _parent   parent gear
   */
  void updateChild(Gear _parent) {
    // alternate gear spin/rotation of gears
    if (id % 2 == 0) {
      angle += speed;
    } else {
      angle -= speed;
    }

    // angle of parent pos to parent center
    float parentAngleToCenter = atan2(_parent.center.y - _parent.pos.y, _parent.center.x - _parent.pos.x);
    // find center of this gear relative to parent
    center.x = (_parent.pos.x + cos(parentAngleToCenter) * (diam)) + (cos(radians(_parent.angle)) * radius);
    center.y = (_parent.pos.y + sin(parentAngleToCenter) * (diam)) + (sin(radians(_parent.angle)) * radius);

    // set moving position of this gear given desired angle of this gear
    pos.x = center.x + cos(radians(angle)) * radius;
    pos.y = center.y + sin(radians(angle)) * radius;
  }

  /*
   * display basic elements of the grid
   *
   */
  void display() { 
    // draw gear teeth
    fill(gearColor);
    noStroke();
    int tooth = int(angle);
    for (int i = tooth; i < 360 + tooth; i+=step) {
      float x = center.x + cos(radians(i)) * (radius);
      float y = center.y + sin(radians(i)) * (radius);
      ellipse(x, y, toothSize, toothSize);
    }

    // draw gear rim
    noFill();
    strokeWeight(toothSize);
    stroke(gearColor);
    ellipse(center.x, center.y, diam + toothSize, diam+ toothSize);
    
    // draw gear center
    strokeWeight(2);
    stroke(gearColor);
    ellipse(center.x, center.y, 15, 15); 
  } 

  void displayChild() {

    // draw gear teeth
    fill(gearColor);
    noStroke();
    int tooth = int(angle);
    for (int i = tooth; i < 360 + tooth; i+=step) {
      float x = center.x + cos(radians(i)) * (radius);
      float y = center.y + sin(radians(i)) * (radius);
      ellipse(x, y, toothSize, toothSize);
    }

    // draw gear rim
    noFill();
    strokeWeight(2);
    stroke(gearColor);
    ellipse(center.x, center.y, diam, diam);  
    
    // draw gear center
    strokeWeight(2);
    stroke(gearColor);
    ellipse(center.x, center.y, 15, 15);     
  }
}
