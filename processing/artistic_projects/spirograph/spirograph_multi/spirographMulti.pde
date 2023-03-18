/**************************************************************
 Project:  Recreating the classic spirograph drawing tool with
 multiple gear example.
 
 Author:  Yahir 
 Date:    January 2023
 
 
 Notes:
 - Processing 3.5.4
 
 Instructions:
 1. ENTER KEY to start drawing

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
float penClrSpd;

PGraphics img;         // image for holding the drawing
boolean imgSetup;      // run faux setup function for img

Gear gear0;            // gear 0 or base gear
Gear gear1;            // gear 1
Gear gear2;            // gear 2



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

  light = color(0, 0, 100);
  dark = color(0, 0, 13);
  bright = color(0, 94, 90);
  
  showUI = false;
  drawing = false;
  imgSetup = true;
  leftPressed = false;

  penSpeed = 0.25;
  penPos = 12;
  penHue = 50;
  penSat = 50;
  penBri = 70;
  penClrSpd = 0.1;
  
  gear0 = new Gear(width/2, height/2 + 75 , 300, 510, penSpeed, 0);
  gear1 = new Gear(75, 330, 1, gear0);
  gear2 = new Gear(150, 210, 2, gear1);
  
 
  img = createGraphics(width, height);
  background(light);
  fill(214, 26, 45, 10);
  rect(-10, -10, width + 20, height + 20);
}

/**************************************************************
 DRAW FUNCTION
 **************************************************************/
void draw() {
  //background(light);
  background(light);
  fill(214, 26, 45, 10);
  rect(-10, -10, width + 20, height + 20);
  
  // update gears
  gear0.update();
  gear1.update(gear0);
  gear2.update(gear1);

  // calculate pen tip location 
  float penX = gear2.center.x + cos(radians(gear2.angle)) * (gear2.radius - penPos);
  float penY = gear2.center.y + sin(radians(gear2.angle)) * (gear2.radius - penPos);

  img.beginDraw();
  if (imgSetup) {
    img.colorMode(HSB, 360, 100, 100, 100);
    img.background(light);
    img.fill(214, 26, 45, 10);
    img.rect(-10, -10, width + 20, height + 20);
    
    imgSetup = false;
  }

  if (drawing) {
    gear0.move(); 
    gear1.move(gear0);
    gear2.move(gear1);
    
     //update hue value
    penHue+= penClrSpd;
   
    if(penHue > 100 || penHue <= 40) penClrSpd *= -1;

    img.noStroke();
    img.fill(30, 70, penHue);
    img.ellipse(penX, penY, 5, 5);
  }

  img.endDraw();
  image(img, 0, 0);

  if (showUI) {
    gear2.displayChild(gear1);
    gear1.displayChild(gear0);
    gear0.display();
    
    // show pen tip
    stroke(gear2.gearColor);
    line(gear2.center.x, gear2.center.y, penX, penY);
    noFill();
    ellipse(penX, penY, 5, 5);
    
    // title/info text
    fill(dark);
    textSize(42);
    text("spirograph", width/2, 30);

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
    save("spirograph-multi-######.png");
    println("saved.");
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
