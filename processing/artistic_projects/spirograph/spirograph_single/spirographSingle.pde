/**************************************************************
 Project:  Recreating the classic spirograph drawing tool with
           the ability to adjust gears within the sketch. 
 
 Author:  Yahir 
 Date:    January 2023
 
 
 Notes:
 - Processing 3.5.4
 
 Instructions:
 1. ENTER KEY to start drawing
 2. SPACE KEY to hide show gears/info...
 3. CLICK AND DRAG to adjust angles and gear radius... 
 
 
 **************************************************************/
PFont myFont;          // global font

color light;           // general color palette
color dark;
color bright;

boolean showUI;        // toggle showing/hiding UI
boolean drawing;       // toggle start/stop hiding
boolean leftPressed;   // track left mouse button pressed
float penSpeed;        // default pen drawing speed
float penPos;          // pen point offset 
float penHue;          // pen ink hue
float penSat;          // pen ink saturation
float penBri;          // pen ink brightness

PGraphics img;         // image for holding the drawing
boolean imgSetup;      // run faux setup function for img

Dial dial0;            // dial object for gear0/base gear
Dial dial1;            // dial object for gear1
Dial dialPen;          // dial object for pen offset

Gear gear0;            // gear 0 or base gear
Gear gear1;            // gear 1

/**************************************************************
 SET UP FUNCTION
 **************************************************************/
void setup() {
  size(900, 900);
  colorMode(HSB, 360, 100, 100, 100);
  
  surface.setTitle("spirograph by Yahir");

  myFont = createFont("Montserrat-Light.ttf", 60);
  textFont(myFont);
  textAlign(CENTER, CENTER);

  light = color(0, 0, 95);
  dark = color(0, 0, 13);
  bright = color(0, 94, 90);
  
  showUI = true;
  drawing = false;
  imgSetup = true;
  leftPressed = false;

  penSpeed = 0.5;
  penPos = 25;
  penHue = 267;
  penSat = 50;
  penBri = 70;
  
  dial0 = new Dial(110, 790, 340, 90, 100, 360, "gear 0");
  dial1 = new Dial(790, 790, 80, 90, 40, 200, "gear 1");
  dialPen = new Dial(600, 840, 25, 0, 160, "pen");
 
  gear0 = new Gear(width/2, height/2 - 20, dial0.radiusValue, dial0.angleValue, penSpeed, 0);
  gear1 = new Gear(dial1.radiusValue, dial1.angleValue, 1, gear0);

  img = createGraphics(width, height);
}

/**************************************************************
 DRAW FUNCTION
 **************************************************************/
void draw() {
  background(light);

  if (leftPressed) {
    dial0.update();
    dial1.update();
    dialPen.update();

    if (dial0.activeRadius()) gear0.radius = int(dial0.radiusValue);
    if (dial0.activeAngle()) gear0.angle = int(dial0.angleValue);
    if (dial1.activeRadius()) gear1.radius = int(dial1.radiusValue);
    if (dial1.activeAngle()) gear1.angle = int(dial1.angleValue);
    if (dialPen.activeRadius()) penPos = int(dialPen.radiusValue);
  }

  gear0.update();
  gear1.update(gear0);
  dialPen.max = int(dial1.radiusValue) * 2;


  // calculate pen tip location 
  float penX = gear1.center.x + cos(radians(gear1.angle)) * (gear1.radius - penPos);
  float penY = gear1.center.y + sin(radians(gear1.angle)) * (gear1.radius - penPos);

  img.beginDraw();
  if (imgSetup) {
    img.colorMode(HSB, 360, 100, 100, 100);
    img.background(light);
    imgSetup = false;
  }

  if (drawing) {
    gear0.move(); 
    gear1.move(gear0);
    
    // update hue value
    penHue+= 0.1;
    if(penHue > 360) penHue = 0;

    img.noStroke();
    img.fill(penHue, penSat, penBri);
    img.ellipse(penX, penY, 5, 5);
  }

  img.endDraw();
  image(img, 0, 0);

  if (showUI) {
    gear1.displayChild(gear0);
    gear0.display();

    // show pen tip
    stroke(gear1.gearColor);
    line(gear1.center.x, gear1.center.y, penX, penY);
    noFill();
    ellipse(penX, penY, 5, 5);
    
    stroke(dark, 40);
    ellipse(300, 840, 100, 100);
    
    // title/info text
    fill(dark);
    textSize(42);
    text("spirograph", width/2, 20);
  
    textSize(14);
    text("ratio\n" + String.format("%.3f", gear0.radius/gear1.radius), 300, 845);
 
    dial0.display(2);
    dial1.display(2);
    dialPen.display(1);
  } 
}

/**************************************************************
 KEY PRESSED FUNCTION
 
 KEY SPACE  | toggle show/hide UI
 KEY ENTER  | toggle start/stop hiding
 KEY D      | delete canvas
 KEY S      | save canvas output
 
 **************************************************************/
void keyPressed() {
  if (key == ' ') {
    showUI = !showUI;
  }
  if (key == ENTER) {
    drawing = !drawing;
  }
  if (key == 'd' || key == 'D') {
    imgSetup = true;
  }
  if (key == 's' || key == 'S') {
    img.save("spirograph-adj-######.png");
  }
}

/**************************************************************
 MOUSE PRESSED FUNCTION
 
 LEFT    | toggle left click
 **************************************************************/
void mousePressed() {
  if (mouseButton == LEFT) {
    leftPressed = true;
  }
}

/**************************************************************
 MOUSE RELEASED FUNCTION
 
 LEFT    | toggle left click
 **************************************************************/
void mouseReleased() {
  if (mouseButton == LEFT) {
    leftPressed = false;
  }
}

/**************************************************************
 * Class for creating nested gears that mimicks action of a
 * spirograph drawing tool
 **************************************************************/
class Gear {
  PVector center;       // center point
  PVector pos;          // moving point
  float radius;         // radius of gear
  float diam;           // diam of gear
  float angle;          // start angle of gear
  float speed;          // speed of spin/revolution
  int id;               // id of gear for setting spin direction
  float angleStart;     // save start angle (this won't update)

  int toothSize;        // size of gear tooth
  int step;             // calcualte space between gear teeth
  
  // possible colors for gears
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
    angleStart = _angle;

    // set moving position of this gear given desired angle of this year
    pos.x = center.x + cos(radians(angle)) * radius;
    pos.y = center.y + sin(radians(angle)) * radius;

    toothSize = 6;
    float mes = degrees(8 / radius);
    step = ceil(mes);


    int index = id;
    if (id > 3) index = id % 3;
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
    angleStart = _angle;

    float arcLength = _parent.radius * radians(360);  
    float arcMeasure = arcLength / radius;  
    float ratio = 360.0 / degrees(arcMeasure);

    speed = (_parent.speed / ratio) /2;


    // angle of parent pos to parent center
    float parentAngleToCenter = atan2(_parent.center.y - _parent.pos.y, _parent.center.x - _parent.pos.x);

    // find center of this gear relative to parent
    center.x = (_parent.pos.x + cos(parentAngleToCenter) * (diam)) + (cos(radians(_parent.angle)) * radius);
    center.y = (_parent.pos.y + sin(parentAngleToCenter) * (diam)) + (sin(radians(_parent.angle)) * radius);

    // set moving position of this gear given desired angle of this gear
    pos.x = center.x + cos(radians(angle)) * radius;
    pos.y = center.y + sin(radians(angle)) * radius;  

    toothSize = 6;
    float mes = degrees(8 / radius);
    step = Math.round(mes);

    int index = id;
    if (id > 3) index = id % 3;
    gearColor = colors[index];
  }

  void move() {
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

  void move(Gear _parent) {
    // alternate gear spin/rotation of gears
    if (id % 2 == 0) {
      angle += speed;
    } else {
      angle -= speed;
    }

    float parentAngleToCenter = atan2(_parent.center.y - _parent.pos.y, _parent.center.x - _parent.pos.x);
    // find center of this gear relative to parent
    center.x = (_parent.pos.x + cos(parentAngleToCenter) * (diam)) + (cos(radians(_parent.angle)) * radius);
    center.y = (_parent.pos.y + sin(parentAngleToCenter) * (diam)) + (sin(radians(_parent.angle)) * radius);
  }


  /*
   * Update the parent gear
   *
   */
  void update() {

    diam = radius * 2;

    // set moving position of this gear given desired angle of this year
    pos.x = center.x + cos(radians(angle)) * radius;
    pos.y = center.y + sin(radians(angle)) * radius;

    toothSize = 6;
    float mes = degrees(8 / radius);
    step = ceil(mes);
  }

  /*
   * update children or nested gear based on direct parent gear
   *
   * @param: _parent   parent gear
   */
  void update(Gear _parent) {
    diam = radius * 2;

    float arcLength = _parent.radius * radians(360);  
    float arcMeasure = arcLength / radius;  
    float ratio = 360.0 / degrees(arcMeasure);

    speed = (_parent.speed / ratio) /2;


    // angle of parent pos to parent center
    float parentAngleToCenter = atan2(_parent.center.y - _parent.pos.y, _parent.center.x - _parent.pos.x);

    // find center of this gear relative to parent
    center.x = (_parent.pos.x + cos(parentAngleToCenter) * (diam)) + (cos(radians(_parent.angle)) * radius);
    center.y = (_parent.pos.y + sin(parentAngleToCenter) * (diam)) + (sin(radians(_parent.angle)) * radius);

    // set moving position of this gear given desired angle of this gear
    pos.x = center.x + cos(radians(angle)) * radius;
    pos.y = center.y + sin(radians(angle)) * radius;  

    toothSize = 6;
    float mes = degrees(8 / radius);
    step = ceil(mes);

    //diam = radius * 2;
    // alternate gear spin/rotation of gears
    //if (id % 2 == 0) {
    //  angle += speed;
    //} else {
    //  angle -= speed;
    //}

    // angle of parent pos to parent center
    //float parentAngleToCenter = atan2(_parent.center.y - _parent.pos.y, _parent.center.x - _parent.pos.x);
    //// find center of this gear relative to parent
    //center.x = (_parent.pos.x + cos(parentAngleToCenter) * (diam)) + (cos(radians(_parent.angle)) * radius);
    //center.y = (_parent.pos.y + sin(parentAngleToCenter) * (diam)) + (sin(radians(_parent.angle)) * radius);

    // set moving position of this gear given desired angle of this gear
    //pos.x = center.x + cos(radians(angle)) * radius;
    //pos.y = center.y + sin(radians(angle)) * radius;
  }

  /*
   * display basic elements of the grid
   *
   */
  void display() { 

    // draw gear teeth
    fill(gearColor);
    noStroke();
    int tooth = int(angleStart);
    for (int i = tooth; i <= 360 + tooth; i+=step) {
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

  void displayChild(Gear _parent) {
    diam = radius * 2;
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

    stroke(_parent.gearColor);
    line(center.x, center.y, _parent.center.x, _parent.center.y);
  }
}

/**************************************************************
*
* Class for creating a basic dial to adjust gears
*
**************************************************************/
class Dial {
  int x, y;            // the center position of dial  
  float radius;        // the radius of the dial
  float diam;          // the diameter of the dial

  String name;         // name of dial
  String textInfo;     // further string text to display (radius/angle)
  
  float angle;         // angle for angle value
  float angleRaw;      // raw angle value in radians
  float angleValue;     // angle value converted to degrees

  float radiusRaw;     // raw radius value in radians
  float radiusAngle;   // radius value converted to degrees
  float radiusValue;   // radius value mapped to desired range
  int min;             // min value for mapping radius
  int max;             // max value for mapping radius
  
  /*
   * Constructor method for normal gear
   *
   * @param: _x             x position CENTER
   * @param: _y             y position CENTER
   * @param: _startRadius   start radius value
   * @param: _startAngle    start angle value
   * @param: _min           min mapping value
   * @param: _max           max mapping value
   * @param: _name          name of dial
   */
  Dial(int _x, int _y, float _startRadius, float _startAngle, int _min, int _max, String _name) {
    x = _x;
    y = _y;
    angle = _startAngle;
    min = _min;
    max = _max;
    diam = 180;
    radius = diam/2;
    textInfo = "";
    name = _name;

    // set to start values
    angleRaw = radians(_startAngle);
    // converte angle to degrees/final value
    angleValue = degrees(angleRaw);
    if(angle < 0) angle = 180 + (181 + (degrees(angleRaw)));
 
    radiusRaw = radians(map(_startRadius, min, max, 0, 360));
    // convert radius to angle and then map to desired range
    radiusAngle = degrees(radiusRaw);
    if(radiusAngle < 0) radiusAngle = 180 + (181 + (degrees(radiusRaw)));
    radiusValue = map(radiusAngle, 0, 360, min, max);
  }
  
  /*
   * Constructor method for modified radius dial
   *
   * @param: _x              x position CENTER
   * @param: _y              y position CENTER
   * @param: _startRadius    start radius value
   * @param: _min            min mapping value
   * @param: _max            max mapping value
   * @param: _name           name of dial
   */
  Dial(int _x, int _y, float _startRadius, int _min, int _max, String _name) {
    x = _x;
    y = _y;
    radius = _startRadius;
    min = _min;
    max = _max;
    diam = 100;
    radius = diam/2;
    textInfo = "";
    name = _name;
    angle = 0;
    angleRaw = 0;
    
    radiusRaw = radians(map(_startRadius, min, max, 0, 361));
    // convert radius to angle and then map to desired range
    radiusAngle = degrees(radiusRaw);
    if(radiusAngle < 0) radiusAngle = 180 + (181 + (degrees(radiusRaw)));
    radiusValue = map(radiusAngle, 0, 360, min, max);
    
  }
  
  void update() {
   // update radius position
    if(activeRadius() && mousePressed) {
     radiusRaw =  atan2(mouseY - y, mouseX - x);
     // convert radius to angle and then map to desired range
      radiusAngle = degrees(radiusRaw);
      if(radiusAngle < 0) radiusAngle = 180 + (181 + (degrees(radiusRaw)));
      radiusValue = map(radiusAngle, 0, 360, min, max);
    }
    
    // update angle position
    if(activeAngle() && mousePressed) {
      angleRaw = atan2(mouseY - y, mouseX - x);
      // converte angle to degrees/final value
      angleValue = degrees(angleRaw);
      if(angle < 0) angle = 180 + (181 + (degrees(angleRaw)));
    } 
    
  }
  
  /**
  * combination of update and displaying the
  * dial
  */
  void display(int _num) {
     
    // get points to show angle position in ui
    float posRadiusX = x + cos((radiusRaw)) * radius;
    float posRadiusY = y + sin((radiusRaw)) * radius;    
    float posRadiusX2 = x + cos(radiusRaw) * (radius - 5);
    float posRadiusY2 = y + sin(radiusRaw) * (radius - 5);
    
    // get points to show radius position in ui
    float posAngleX = x + cos((angleRaw)) * (radius + 6);
    float posAngleY = y + sin((angleRaw)) * (radius + 6);    
    float posAngleX2 = x + cos(angleRaw) * (radius  + 11);
    float posAngleY2 = y + sin(angleRaw) * (radius + 11);
    
    // draw line for displaying ui position of angle and radius
    stroke(dark); 
    line(posRadiusX, posRadiusY, posRadiusX2, posRadiusY2);
    if(_num == 2) line(posAngleX, posAngleY, posAngleX2, posAngleY2);
    
    // display dials
    stroke(dark, 40);
    noFill();
    ellipse(x, y, diam, diam);
    if(_num == 2) ellipse(x, y, diam + 22, diam + 22);
    
    // display text info
    fill(dark);
    textSize(14);
    textInfo = String.format(name + "\noffset: %s", int(radiusValue));
    if(_num == 2) textInfo = String.format(name + "\nradius: %s\nangle: %s", int(radiusValue), int(angleValue));
    
    text(textInfo, x, y);
  }
  
  /**
  * return true if mouse is within angle ring
  */
  boolean activeRadius() {
    float d = dist(mouseX, mouseY, x, y);
    if(d < radius && d > radius - 10) {
      return true;
    } else {
      return false;
    }
  }
  
  /**
  * return true if mouse is within radius ring
  */
  boolean activeAngle() {
    float d = dist(mouseX, mouseY, x, y);
    if(d > radius + 1 && d < radius  + 11) {
      return true;
    } else {
      return false;
    }
  }
}
