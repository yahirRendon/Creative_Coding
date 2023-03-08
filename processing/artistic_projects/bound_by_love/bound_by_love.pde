/**************************************************************
 Project:  I saw this feature on a website in which the company
           logo would dispurse when the cursor went over it and 
           would then recombine. I decided to created something
           similar.  
 
 Author:  Yahir 
 Date:    January 2022
 
 
 Notes:
 - Processing 3.5.4
 
 Instructions:
 - click and drag left mouse button to repel pixels 
 - click and drag right mouse button to attract pixels 
 
 
 **************************************************************/
PImage img;              // source image for placing pxl objects
ArrayList<Pxl> pxls;     // list of pxl objects
int range;               // push distance from cursor
boolean leftPressed;     // track left mouse button pressed
boolean rightPressed;    // track right mouse button pressed

/**************************************************************
 SET UP FUNCTION
 **************************************************************/
void setup() {
  size(600, 600, P2D);
  colorMode(HSB, 360, 100, 100, 100);
  img = loadImage(""); // png will be needed in data folder
  pxls = new ArrayList<Pxl>();
  range = 120;
  leftPressed = false;
  rightPressed = false;
 
  // loop through image and get desired pixels
  // based on brightness 
  for(int y = 0; y < height; y++) {
    for(int x = 0; x < width; x++) {
      int index = x + y * width;
      float alpha = alpha(img.pixels[index]);
     
      if(alpha > 0) {
        color tColor = color(hue(img.pixels[index]),
                             saturation(img.pixels[index]),
                             brightness(img.pixels[index]),
                             alpha(img.pixels[index]));
        pxls.add(new Pxl(x, y, tColor));
      }
    }
  }
}

/**************************************************************
 DRAW FUNCTION
 **************************************************************/
void draw() {
  background(0, 0, 97);
  
  noStroke();
  for(int i = 0; i < pxls.size(); i++) {
    float d = dist(mouseX, mouseY, pxls.get(i).pos.x, pxls.get(i).pos.y);
    if(d < range + random(-30, 30)) {
      float angle = atan2(mouseY - pxls.get(i).pos.y, mouseX - pxls.get(i).pos.x);
     
      // repel nodes in range when left mouse button pressed
      if(leftPressed) {
        float spd = pxls.get(i).moveSpd;
        pxls.get(i).pos.x -= map(d, range, 0, 0, spd) * cos(angle);
        pxls.get(i).pos.y -= map(d, range, 0, 0, spd) * sin(angle);
        pxls.get(i).resetOnMove();
      }  
      // attract nodes
      if(rightPressed) {
        float spd = pxls.get(i).moveSpd;
        pxls.get(i).pos.x += map(d, range, 0, 0, spd) * cos(angle);
        pxls.get(i).pos.y += map(d, range, 0, 0, spd) * sin(angle);
        pxls.get(i).resetOnMove();
      }
    }
    pxls.get(i).display();
  } 
}

/**************************************************************
 MOUSEPRESSED FUNCTION
 
 LEFT  | left mouse button pressed
 RIGHT | right mouse button pressed
 **************************************************************/
void mousePressed() {
  if (mouseButton == LEFT) {
    leftPressed = true;
  }
  if (mouseButton == RIGHT) {
    rightPressed = true;
  }
}

/**************************************************************
 MOUSEPRESSED FUNCTION
 
 LEFT  | left mouse button released
 RIGHT | right mouse button released
 **************************************************************/
void mouseReleased() {
  if (mouseButton == LEFT) {
    leftPressed = false;
  }
  if (mouseButton == RIGHT) {
    rightPressed = false;
  }
}

/*
 * Class for holding a pixel that will be pushed and return
 * to origin
 */
class Pxl {
  PVector origin;        // the origin position of pixel
  PVector pos;           // position of pixel that moves
  color pxlColor;        // pixel color
  int minSize;           // minimum pixel size
  int stage;             // move through push and return stages
  int delayCounter;      // frame counter after being moved
  int delayAmt;          // number of frames before returning origin
  float moveSpd;         // pixel move speed

 /*
  * Constructor method for setting the parent or root gear
  *
  * @param: _x        x position
  * @param: _y        y position
  * @param: _c        pxl color
  */
  Pxl(int _x, int _y, color _c) {
    origin = new PVector(_x, _y);
    pos = new PVector(_x, _y);
    pxlColor = _c;
    minSize = 2;
    stage = 0;
    delayCounter = 0;
    delayAmt = int(random(200, 300));
    moveSpd = random(1, 5);
  }
  
  /*
  * reset elements when pixel is being moved
  */
  void resetOnMove() {
    delayCounter = 0;
    stage = 1;  
  }
  
  /*
  * update the position and display the pixel
  */
  void display() {
    
    // update pos based on stage
    float d = minSize;
    switch(stage) {
     case 1:
     // has been moved so start delay;
     delayCounter++;
     if(delayCounter > delayAmt) {
       delayCounter = 0;
       stage ++;
     } 
     d = dist(pos.x, pos.y, origin.x, origin.y);
     break;
     case 2:
     // can begin moving back to home position with easing
     float targetX = origin.x;
      float dx = targetX - pos.x;
      pos.x += dx * 0.05;
     
      float targetY = origin.y;
      float dy = targetY - pos.y;
      pos.y += dy * 0.05;
      d = dist(pos.x, pos.y, origin.x, origin.y);
      if(d < 1) {
        pos.x = origin.x;
        pos.y = origin.y;
        stage = 0; // set back to doing nothing
      }
     break;
     case 0:
     default:
     break;
    }
    
    // display
    if(d > 1) {
      float satAdj = (map(d, minSize, 200, 0, 50));
      float sat = saturation(pxlColor) + satAdj;
      if(sat > 90) sat = 90;
      
      fill(hue(pxlColor), sat, brightness(pxlColor), alpha(pxlColor));
    } else {
      fill(pxlColor);
    }
    float s = map(d, minSize, 200, minSize, 4);

    //ellipse(pos.x, pos.y, s, s);
    rect(pos.x, pos.y, s, s);
  } 
}
