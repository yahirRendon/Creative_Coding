/**************************************************************
  Project:  Proof of concept inpsired by an Instagram Filter ad
  Author:   Yahir
  Date:     May 2021
  
  Notes:
    1. Import image into the data folder the same size of canvas. 
       Default image/canvas size is 1080 x 1080 pixels
    2. Run Sketch
    3. Click and Drag mouse ONCE over area to select pixels
       from the image
    4. Click and Drag mouse AGAIN to assign direction of
       particle flow
    5. Slected pixels will generate particles that flow in desired
       angle from orgin
    6. Continue selecting as many sample areas and angles as desired
**************************************************************/
  
ArrayList<Particle> selectionlist;        // holds selected Particle positions passed into mainlist
ArrayList<ArrayList<Particle>> mainlist;  // nested ArrayList of ArrayList of Particle objects
PImage img;                               // the background image
PVector start = new PVector();            // tracks start position of mouse  onClick
PVector end = new PVector();              // tracks end position of mouse onRelease
int clickCycle = 0;                       // track the clicks for selection and angle assignment

/**************************************************************
  * SETUP METHOD
  ************************************************************/
void setup() {
  size(1080, 1080);
  colorMode(HSB, 360, 100, 100, 100);
  
  // initialize variables
  selectionlist = new ArrayList<Particle>();
  mainlist = new ArrayList<ArrayList<Particle>>();
  img = loadImage("flowers_yahir_1080x1080_b.jpg");

}

/**************************************************************
  * DRAW METHOD
  ************************************************************/
void draw() {
  image(img, 0, 0);
  
  // nested for loop for the mainlist to update and display
  // all arraylist of Particle objects
  for (int i = 0; i < mainlist.size(); i++) {
    for (int j = 0; j < mainlist.get(i).size(); j++) {
      mainlist.get(i).get(j).update();
      mainlist.get(i).get(j).display();
    }
  }

}

/**************************************************************
  * DO ON MOUSE DRAGGED
  ************************************************************/
void mouseDragged() {
  switch(clickCycle) {
  case 0: // populate selection list with particles at mouse pos
    selectionlist.add(new Particle(mouseX, mouseY));
    break;
  case 1: // set start position when first clicked for angle flow
    start = new PVector(mouseX, mouseY);
    clickCycle = 2;
    break;
  }
}

/**************************************************************
  * DO ON MOUSE RELEASED
  ************************************************************/
void mouseReleased() {
  switch(clickCycle) {
  case 0: // add selected pixels to mainlist as Particle ojbect list
    ArrayList<Particle> temp = new ArrayList<Particle>(selectionlist);
    mainlist.add(temp);
    clickCycle = 1;
    break;
  case 1: // do nothing
    break;
  case 2: // calculate the desired angle flow
    selectionlist.clear();
    end = new PVector(mouseX, mouseY);
    float a = atan2(end.y-start.y, end.x-start.x);
    float d = dist(start.x, start.y, end.x, end.y);
    for (int i = 0; i < mainlist.get(mainlist.size()-1).size(); i++) {
      mainlist.get(mainlist.size() - 1).get(i).setAngle(a);
    }
    clickCycle = 0;
    break;
  }
}

/**************************************************************
  *
  * Class for creating the particles that will move in a sine
  * pattern from an origin
  *
  ************************************************************/
class Particle {
  PVector pos;                 // the position of particle through time
  PVector org;                 // the origin position of particle
  
  color pColor;                // particle color
  
  float amplitude;             // sine wave amplitude
  float angle;                 // the angle of flow from origin position
  float pSize;                 // size of the particle through time
  float speed;                 // speed along x prior to rotation
  float theta;                 // angle passed into sin function
  
  int delayAmt;                // inital display delay amount
  int delayCounter;            // counts frames to meet delay amount
  int duration;                // duration of display for particle at full size
  int durCounter;              // counts frames to meet duration variable
  int life;                    // tracks lifecyle of the particle through stages
  int sizeTarget;              // desired full size of particle 
 
  /**
    * Constructor method for Particle class
    *
    * @param {float} x    the x origin position of particle
    * @param {float} y    the y origin position of particle
    */ 
  Particle(float x, float y) {
    // initialize variables
    org = new PVector(x, y);
    pos = new PVector(0, 0);
    
    // calculate particle color for img pixel
    float h = hue(img.pixels[int(x) + int(y) * width]);
    float s = saturation(img.pixels[int(x) + int(y) * width]);
    float b = brightness(img.pixels[int(x) + int(y) * width]);
    pColor = color(h, s + random(20, 80), b + random(25, 50));
      
    amplitude = random(20, 50); 
    angle = 0;
    pSize = 0;
    speed = random(.25, 1);    
    theta = random(0, 720);
    
    delayAmt = int(random(50, 200));
    delayCounter = 0;
    duration = int(random(250, 350));
    durCounter = 0;
    life = 0;
    sizeTarget = int(random(3, 20));  
  }
  
  /**
    * Update the particle lifecycle
    * generate the sine wav and pass x and y to pos
    * this creates a standard sine from left to right
    * with the defined sine wave attributes
    * rotation to desired angle occures in display
    */
  void update() {
    switch(life) {     
    case 1: // initial display delay
      if (delayCounter > delayAmt) {
        life = 2;
      } else {
        delayCounter++;
      }
      break;
      
    case 2: // grow particle to desired size
      if (pSize >= sizeTarget) {
        life = 3;
      } else {
        pSize+=.25;
        durCounter++;
        theta ++;
        pos.y =  sin(radians(theta)) * amplitude;
        pos.x+=speed;
      }
      break;
      
    case 3: // move in direction for duration of life

      if (durCounter > duration) {
        life = 4;
      } else {
        durCounter++;
        theta ++;
        pos.y =  sin(radians(theta)) * amplitude;
        pos.x+=speed;
      }
      break;
      
    case 4: // shrink out
      if (pSize <= 0) {
        life = 5;  
      } else {
        pSize -=.25;
        if(pSize < 0) { pSize = 0;}
        durCounter++;
        theta ++;
        pos.y =  sin(radians(theta)) * amplitude;
        pos.x+=speed;
      }
      break;
      
    case 5: // reset particle or leave dead  
      durCounter = 0;
      delayCounter = 0;
      pSize = 0;
      pos.x = 0;
      pos.y = 0;
      life = 2;
      break;
      
    default:
      break;
    }
  }
  
  /**
    * Display the particle visually on canvas
    */
  void display() {
    
    // rotate the pos x and y by the user defined angle
    PVector t = rotation(pos, angle);
    fill(pColor);
    //stroke(0, 0, 100);
    noStroke();
    // display ellipse with rotated x and y + offset of
    // user defined origin
    ellipse(org.x + t.x, org.y + t.y, pSize, pSize);
 
  }
  
  /**
    * Setter method for the angle calculated from
    * the start and end mouse position on second click
    * 
    * @param {float} ang    the caluclated desired angle (radians)
    */
  void setAngle(float ang) {
    angle = ang; 
    life = 1;
  }
  
  /**
    * rotate a PVector by a desired angle in radians
    * and return the new PVector with rotated x and y
    */
  PVector rotation(PVector vec, float angle) {
    // assign desired rotation angle in radians
    float rotationAngle = angle;
    
    // calculate new x and y values based on rotation
    float tempX = (vec.x * cos(rotationAngle)) - (vec.y * sin(rotationAngle));
    float tempY = (pos.y * cos(rotationAngle)) + (pos.x * sin(rotationAngle));
    
    // assign and return new PVector
    PVector tempVector = new PVector(tempX, tempY);
    return tempVector; 
  }
}
