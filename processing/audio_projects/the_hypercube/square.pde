/*
Square class used to create background effect with shimmer
*/
class Square {
  PVector pos;      // x y position of the center of square
  float widthHeight; // width and height of square
  float shimmer;    // track shimmer alpha value
  float fallSpeed;    // fall speed of the squares
  int soundAmp; // connect to a sound amplitude
  
  float lastX;    // state change 
  float currentX; // state change

  int follow; // random value assigned to shifting left and right with hcube movement
  int colorMatch;
  int colorSel;

  
  /*
  * Default Constructor
  * @PARAM: integer that passes the courresponding sound sample amplitude for iteration use
  */
  Square(int _soundAmp) {
    pos = new PVector(int(random(-5, 1005)), int(random(-1005, -20)));
    widthHeight = int(random(10, 50));
    shimmer = random(6, 15); //10;
    soundAmp = _soundAmp;
    fallSpeed = random(.75, 1.5);
    follow = int(random(0, 3)); // a third follow
    if(follow == 0) {
     colorMatch = int(random(0, 4));
     colorSel = int(random(0, 6));
    } else {
     colorMatch = -1; 
    }
  }
  
  /*
  * Method for updating squares
  */
  void update() {
    if(follow == 0) {
    currentX = hCube.a1.x;
    if(currentX > lastX + 10) {
     pos.x += ease(pos.x, currentX);
       lastX = hCube.a1.x;

    }   
    if(currentX < lastX - 10) {
     pos.x += ease(pos.x, currentX);
     lastX = hCube.a1.x;
    }
  
    }
    pos.y += fallSpeed;
  }
  
  /*
  * Method for displaying squares
  */
  void display() {
    rectMode(CENTER);
    float d = map(pos.y, 0, height, 100, -150);
    switch(colorMatch) {
     case 0: 
     switch(colorSel) {
      case 0:
      fill(0,204,253, d + shimmer); // cool blue
      break;
      case 1:
      fill(32,17,162, d + shimmer); // violet
      break;
      case 2:
      fill(255,52,179, d + shimmer); // pink
      break;
      case 3:
      fill(131, 144, 145, d + shimmer);
      break;
      case 4:
      fill(51, 78, 83, d + shimmer);
      break;
      case 5:
      fill(93, 114, 118, d + shimmer);
      break;
      default:
      break;
     }
          
     break;
     default:
     fill(255, d + shimmer);
     break;
    }
    
    noStroke();
    rect(pos.x, pos.y, widthHeight, widthHeight);
  }

  void reset(int _soundAmp) {
    pos = new PVector(int(random(-5, 1005)), int(random(-1005, -20)));
    widthHeight = int(random(10, 50));
    shimmer = random(6, 15); //10;
    soundAmp = _soundAmp;
    fallSpeed = random(.75, 1.5);
    colorMatch = int(random(0, 4));
     colorSel = int(random(0, 6));
  }
  
  // calculate and return easing value
  // start pos and targert pos
  float ease(float start, float target) {
    float dx = target - start;
    return dx * .0035;
  }
  
  // detect if square has passed below window
  boolean edge() {
    if (pos.y > height + widthHeight) {
      return true;
    } else {
      return false;
    }
  }
}
