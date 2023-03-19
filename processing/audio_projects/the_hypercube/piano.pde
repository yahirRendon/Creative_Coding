/*
  * class for creating piano keys
  */

class Piano {
  boolean noteC3, noteCS3, noteD3, noteDS3, noteE3, noteF3, 
    noteFS3, noteG3, noteGS3, noteA3, noteAS3, noteB3;      // toggle when keys are played
    
  // Default constructor
  Piano() {
  }

  void display() {
    rectMode(CORNER);
    // create white keys and toggle color when played
    if (noteC3) {
      fill(255, 52, 179, 150); // darker pink
    } else {
      fill(255, 52, 179, 80); // lighter pink
    }
    createKey(270, 800, "LEFT");

    if (noteD3) {
      fill(255, 52, 179, 150);
    } else {
      fill(255, 52, 179, 80);
    }
    createKey(360, 800, "MIDDLE");

    if (noteE3) {
      fill(255, 52, 179, 150);
    } else {
      fill(255, 52, 179, 80);
    }
    createKey(425, 800, "RIGHT");
    
    if (noteF3) {
      fill(255, 52, 179, 150);
    } else {
      fill(255, 52, 179, 80);
    }
    createKey(465, 800, "LEFT");
    
    if (noteG3) {
      fill(255, 52, 179, 150);
    } else {
      fill(255, 52, 179, 80);
    }
    createKey(555, 800, "MIDDLE");
    
    if (noteA3) {
      fill(255, 52, 179, 150);
    } else {
      fill(255, 52, 179, 80);
    }
    createKey(620, 800, "MIDDLE");
    
    if (noteB3) {
      fill(255, 52, 179, 150);
    } else {
      fill(255, 52, 179, 80);
    }
    createKey(685, 800, "RIGHT");
    
    // Create black keys and toggle when played
    if (noteCS3) {
      fill(32, 17, 162, 150); // darker violet
    } else {
      fill(32, 17, 162, 80); // lighter violet
    }
    createKey(310, 800, "BLACK");
    
    if (noteDS3) {
      fill(32, 17, 162, 150);
    } else {
      fill(32, 17, 162, 80);
    }
    createKey(375, 800, "BLACK");
    
    if (noteFS3) {
      fill(32, 17, 162, 150);
    } else {
      fill(32, 17, 162, 80);
    }
    createKey(505, 800, "BLACK");
    
    if (noteGS3) {
      fill(32, 17, 162, 150);
    } else {
      fill(32, 17, 162, 80);
    }
    createKey(570, 800, "BLACK");
    
    if (noteAS3) {
      fill(32, 17, 162, 150);
    } else {
      fill(32, 17, 162, 80);
    }
    createKey(635, 800, "BLACK");

  }
  
  /*
  * Method for creating piano keys
  * @PARAM int lx: left x start pos
  * @PARAM int ly: left y start pos
  * @PARAM String type: type of key LEFT, MIDDLE, RIGHT, BLACK
  */
  void createKey(int lx, int ly, String type) {
    switch(type) {
      case "LEFT":
      beginShape();
      vertex(lx, ly);
      vertex(lx + 35, ly);
      vertex(lx + 35, ly + 105);
      vertex(lx + 60, ly + 105);
      vertex(lx + 60, ly + 150);
      vertex(lx, ly + 150);
      vertex(lx, ly);
      endShape();
      break;
      case "MIDDLE":
      beginShape();
      vertex(lx, ly);
      vertex(lx + 10, ly);
      vertex(lx + 10, ly + 105);
      vertex(lx + 35, ly + 105);
      vertex(lx + 35, ly + 150);
      vertex(lx - 25, ly + 150);
      vertex(lx - 25, ly + 105);
      vertex(lx, ly + 105);
      vertex(lx, ly); 
      endShape();
      break;
      case "RIGHT":
      beginShape();
      vertex(lx, ly);
      vertex(lx + 35, ly);
      vertex(lx + 35, ly + 150);
      vertex(lx - 25, ly + 150);
      vertex(lx - 25, ly + 105);
      vertex(lx, ly + 105);
      vertex(lx, ly);
      endShape();
      break;
      case "BLACK":
      beginShape();
      vertex(lx, ly);
      vertex(lx + 45, ly);
      vertex(lx + 45, ly + 100);
      vertex(lx, ly + 100);
      vertex(lx, ly);
      endShape();
      break;
      default:
      break;
    }
  }
  
  // #fix if I want to create mouse click key triggers
  boolean active() {
    if (mouseX > 270 && mouseX < 330
      && mouseY > 800 && mouseY < 950
      && hCube.dimension == 1) {
      return true;
    } else {
      return false;
    }
  }
}
