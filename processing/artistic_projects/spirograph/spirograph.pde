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

boolean drawing;             // toggle drawing on/off
float drawSpeed;       // the drawing speed for the large gear                          
float penRadius;             // the offest of the pen within the final gear
ArrayList<PVector> pen;      // show pen ink

Gear gear0;                  // large outter ring housing all others
Gear gear1;                  // first inner gear
Gear gear2;                  // second inner gear

/**************************************************************
 SET UP FUNCTION
 **************************************************************/
void setup() {
  size(900, 900);
  
  drawing = false;
  drawSpeed = 0.025;
  penRadius = 25;
  pen = new ArrayList<PVector>();
  
  gear0 = new Gear(450, 450, 360, 75, drawSpeed, 0);
  gear1 = new Gear(240, 25, 1, gear0);
  gear2 = new Gear(48, 90, 2, gear1);  
}

/**************************************************************
 DRAW FUNCTION
 **************************************************************/
void draw() {
  background(255);
  
  if(drawing) {
    // update gear calculations
    gear0.update();
    gear1.updateChild(gear0);
    gear2.updateChild(gear1);
  }
  
  // display gears
  gear0.display();
  gear1.display();
  gear2.display();
  
  // calculate pen tip location
  float penX = gear2.center.x + cos(radians(gear2.angle)) * (gear2.radius - penRadius);
  float penY = gear2.center.y + sin(radians(gear2.angle)) * (gear2.radius - penRadius);

  // populate pen array to be like ink
  pen.add(new PVector(penX, penY));
  if(pen.size() > 1000) {
    pen.remove(0);
  }
  
  // display pen ink
  for(int i = 0; i < pen.size(); i++) {
    fill(0);
    ellipse(pen.get(i).x, pen.get(i).y, 5, 5);
  }   
}

/**************************************************************
 KEY PRESSED FUNCTION
 
 SPACE KEY  | toggle draw on/off
 **************************************************************/
void keyPressed() {
  if(key == ' ') {
    drawing = ! drawing;
  }
  
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
  }
  
  /*
   * Update the parent gear
   *
   */
  void update() {
    // alternate gear spin/rotation of gears
    if(id % 2 == 0) {
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
    if(id % 2 == 0) {
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
    noFill();
    ellipse(center.x, center.y, diam, diam);
    ellipse(pos.x, pos.y, 10, 10);
    line(center.x, center.y, pos.x, pos.y);
    
    // static point on this gear to better show revolutions
    float x = center.x + cos(radians(0)) * radius;
    float y = center.y + sin(radians(0)) * radius;
    fill(0);
    ellipse(x, y, 10, 10);    
  } 
}
