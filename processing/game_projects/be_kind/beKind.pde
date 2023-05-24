/*************************************************************************************
 THE KIND CHALLENGE
 Version 1 
 Processing Version 3.4
 Created by Yahir
 February 1, 2019
 
 Music: 
 https://www.bensound.com
 **************************************************************************************/

import processing.sound.*;

PFont font;             // adjust font
SoundFile song;         // Create sound file object
boolean showInfo;       // Introduction text
float dSpin;            // Difference in spin and targetValue
float easing;           // easing rate
float finalValue;       // Tracks selected section by the dial
float followDial;       // Value that follows the dial value
float incrementAngle;   // Determine the increment angle for created ellipse markers
float spin;             // Tracks spin of the dial
float targetValue;      // Large spin value
int bckgrndColor;       // Determines backgroudn color based on dial selection
boolean beginInfoTrans; // Toggle in and out of info screen
float opacityTrans;     // Track opacity of transition screen
float opacityTransText; // Track opacity of info screen text4

// color palette
color color1;
color color2;
color color3;
color color4;
color color5;
color color6;
color color7;
color color8;

/**
 * Setup Function
 **/
void setup() {
  size(800, 800, FX2D);
  font = createFont("Montserrat-Light.otf", 150);
  textFont(font);
  preSetup(); // load initial values
}

/**
 * Draw Function
 **/
void draw() {  
  // update mouse cursor
  float distDial = dist(mouseX, mouseY, 400, 400);
  if(distDial < 50) {
    cursor(HAND);
  } else {
    cursor(ARROW);
  }
  
  // Spinner pie colors
  noStroke();
  // fill(255, 179, 186); //red // 1 a
  fill(color1);
  triangle(400, 400, 400, 0, 800, 0);
  // fill(255, 255, 186); // yellow // 2 a
  fill(color2);
  triangle(400, 400, 800, 0, 800, 400);
  // fill(179, 255, 245); // blue; //3  a
  fill(color3);
  triangle(400, 400, 800, 400, 800, 800);
  // fill(255, 211, 179); // orange // a
  fill(color4);
  triangle(400, 400, 400, 800, 800, 800);
  // fill(192, 255, 179); // green; // 5 a
  fill(color5);
  triangle(400, 400, 400, 800, 0, 800);
  // fill(164, 197, 193); // pink // 6 a
  fill(color6);
  triangle(400, 400, 0, 800, 0, 400);
  // fill(217, 217, 127); // yellow; // 7
  fill(color7);
  triangle(400, 400, 0, 400, 0, 0);
  // fill(217, 238, 174); // blue // 8 a
  fill(color8);
  triangle(400, 400, 0, 0, 400, 0);

  // Narrows spinner size
 noFill();
  strokeWeight(500);
  switch(bckgrndColor) {
  case 1: 
    stroke(255, 179, 186);
    stroke(color1);
    break;
  case 2: 
    stroke(255, 255, 186);
    stroke(color2);
    break;
  case 3: 
    stroke(179, 255, 245);
    stroke(color3);
    break;
  case 4: 
    stroke(255, 211, 179);
    stroke(color4);
    break;
  case 5: 
    stroke(192, 255, 179);
    stroke(color5);
    break;
  case 6: 
    stroke(164, 197, 193);
    stroke(color6);
    break;
  case 7: 
    stroke(217, 217, 127);
    stroke(color7);
    break;
  case 8: 
    stroke(217, 238, 174);
    stroke(color8);
    break;
  default:
    stroke(194, 176, 204);
    stroke(color1);
    break;
  }
  ellipse(400, 400, 1000, 1000);

  // Spinner outter ring
  strokeWeight(5);
  stroke(155, 127, 170); // Dark Purple
  ellipse(400, 400, 500, 500);

  // Spinner drop shadow feature
  fill(0, 25);
  noStroke();
  ellipse(500, 680, 400, 10);

  // Main dial design
  pushMatrix();
  translate(width/2, height/2);
  rotate(radians(spin));
  noStroke();
  fill(194, 176, 204); // Purple outter circle
  ellipse(0, 0, 120, 120);
  fill(155, 127, 170); // Dark purple ring
  ellipse(0, 0, 105, 105);
  fill(229, 221, 233); // Light purple Inner circle
  ellipse(0, 0, 100, 100);
  fill(155, 127, 170); // Dark purple pointer
  triangle(0, -60, 10, -50, -10, -50);
  popMatrix();

  // Dial drop shadow features
  fill(0, 25); 
  curve(199, 283, 375, 467, 467, 420, 380, 258);
  beginShape();
  vertex(349, 410);
  vertex(375, 467);
  vertex(467, 420);
  vertex(446, 376);
  vertex(349, 410);
  endShape();

  // Dial highlight features
  fill(229, 221, 233); // Inner ring
  ellipse(400, 400, 100, 100);
  fill(255); // Highlight dot
  ellipse(380, 375, 10, 10);

  // Ellipse marker ring
  pushMatrix();
  translate(width/2, height/2);
  rotate(radians(23));
  // Solid ellipse markers
  incrementAngle = 0;
  for (int i = 0; i < 8; i++) {
    strokeWeight(2);
    stroke(155, 127, 170); // Dark purple
    // fill(229, 221, 233); // Light purple
    fill(194, 176, 204);
    ellipse(250 * cos(incrementAngle), 
      250 * sin(incrementAngle), 
      20, 20);        
    incrementAngle += TWO_PI / 8;
  }

  // Highlight Ellipse Markers
  stroke(125, 88, 145);
  fill(229, 221, 233); // dark purple
  followDial = (spin - ((int(spin / 360) * 360)));
  if (followDial <=45) {
    ellipse(250 * cos(4.712389), 250 * sin(4.712389), 20, 20);
  } else if ( followDial <=90) {
    ellipse(250 * cos(5.497787), 250 * sin(5.497787), 20, 20);
  } else if ( followDial<=135) {
    ellipse(250 * cos(6.283185), 250 * sin(6.283185), 20, 20);
  } else if ( followDial<=180) {
    ellipse(250 * cos(0.7853982), 250 * sin(0.7853982), 20, 20);
  } else if ( followDial<=225) {
    ellipse(250 * cos(1.5707964), 250 * sin(1.5707964), 20, 20);
  } else if ( followDial<=270) {
    ellipse(250 * cos(2.3561945), 250 * sin(2.3561945), 20, 20);
  } else if ( followDial<=315) {
    ellipse(250 * cos(3.1415927), 250 * sin(3.1415927), 20, 20);
  } else {
    ellipse(250 * cos(3.926991), 250 * sin(3.926991), 20, 20);
  }
  popMatrix();

  // Display text on spinner
  fill(125, 88, 145);
  DisplaySpinnerOptions("Give a hug", -65, 80, 0);
  DisplaySpinnerOptions("Pick up litter", -20, 80, 0);
  DisplaySpinnerOptions("Volunter your time", 25, 80, 0);
  DisplaySpinnerOptions("Give a gift", 70, 80, 0);
  DisplaySpinnerOptions("Appreciate someone", 290, -80, 1);
  DisplaySpinnerOptions("Give a compliment", 335, -80, 1);
  DisplaySpinnerOptions("Help a stranger", 380, -80, 1);
  DisplaySpinnerOptions("Send a kind email", 425, -80, 1);

  // Title and Intro Text
  if (opacityTransText <= 0) {
    textSize(40);
    textAlign(CENTER);
    fill(20);
    text("The Kind Challenge", 400, 100);
    textSize(20);
    if (showInfo) {
      text("Click on the center dial to help create a kinder world.", 400, 730);
      textSize(16);
      text("Press SPACE key for more info.", 400, 770);
    }
  }

  // Display selected text by checking dial location
  if (opacityTransText <= 0) {
    if (!showInfo) {
      dSpin = targetValue - spin;
      spin += dSpin * easing;
      if ((targetValue - spin) < 1) {
        showInfo = false;
        fill(20);
        textAlign(CENTER);
        if (finalValue <= 45) {
          text("Hugging can reduce stress keeping your immune system\nhealthy and reduce your chances of getting sick.", 400, 730);
          bckgrndColor = 1;
        } else if (finalValue <= 90) {
          text("Studies have shown that litter can negatively\nimpact the sense of community and safety.", 400, 730);
          bckgrndColor = 2;
        } else if ( finalValue <= 135) {
          text("Volunteering helps combat depression, increases\nself-confidence, and provides a sense of purpose.", 400, 730);
          bckgrndColor = 3;
        } else if ( finalValue <= 180) {
          text("Similar to eating chocolate, giving makes us feel good as it\nstimulates the same pleasure circuits in the brain.", 400, 730);
          bckgrndColor = 4;
        } else if ( finalValue <= 225) {
          text("Letting someone know they are valued and appreciated builds\ntrust in relationships.", 400, 730);
          bckgrndColor = 5;
        } else if ( finalValue <= 270) {
          text("Giving someone a compliment has the potential to shift their\nthinking in a positive manner for the rest of their day.", 400, 730);
          bckgrndColor = 6;
        } else if ( finalValue <= 315) {
          text("Research shows, those that help others tend to live longer\nas they have reduced levels of stress, anxiety, and depression.", 400, 730);
          bckgrndColor = 7;
        } else {
          text("Recognizing and being kind to others inspires\nbelonging and deeper relationships.", 400, 730);
          bckgrndColor = 8;
        }
      }
    }
  }

  // Transition to info screen
  if (beginInfoTrans) {
    opacityTrans+=4;
    if (opacityTrans > 230) {
      opacityTrans = 230;
      showInfo = true;
      bckgrndColor = 0;
    }
  } else {
    opacityTransText -=10;
    if (opacityTransText < 0) {
      opacityTransText = 0;
    }
    if (opacityTransText == 0) {
      opacityTrans -= 10;
      if (opacityTrans < 0) {
        opacityTrans = 0;
      }
    }
  }
  if (opacityTrans == 230) {
    opacityTransText += 4; 
    if (opacityTransText > 255) {
      opacityTransText = 255;
    }
  } 

  fill(155, 127, 170, opacityTrans); 
  noStroke();
  rect(0, 0, 800, 800); 
  fill(0, opacityTransText);
  textAlign(CENTER);
  textSize(40);
  text("Be Kind.", 400, 250);
  textSize(20);
  text("This challenge was made as a reminder that\n within every moment exists an opportunity  to do\nsomething kind.\n\nTake a spin and be the change the world needs today.", 400, 320);
  textSize(16);
  text("Created by Yahir\nMusic from bensound.com (Once Again).", 400, 520);
}

/**
 * A function that loads all initial values on setup
 **/
void preSetup() {
  showInfo = true;
  dSpin = 0;
  easing = 0.015;
  finalValue = 0;
  followDial = 0;
  incrementAngle = 0;
  spin = 22.5;
  targetValue = 22.5;
  bckgrndColor = 0;
  beginInfoTrans = false;
  opacityTrans = 0;
  opacityTransText = 0;

  color1 = color(182, 205, 236);
  color2 = color(222, 179, 224);
  color3 = color(255, 221, 228);
  color4 = color(220, 243, 252);
  // color4 = color(163, 159, 225);
  color5 = color(208, 212, 247);
  color6 = color(254, 198, 223);
  color7 = color(254, 236, 214);
  color8 = color(228, 246, 223);
  song = new SoundFile(this, "bensound-onceagain.mp3");
  song.loop();
}

/**
 * A function to display the text to be displayed within the spinner section
 *
 * @PARAM spinnerText: String value of the text to be displayed
 * @PARAM rotateAmt: Int value of the degrees of text rotation
 * @PARAM xStart: Int value of the start of the text
 * @PARAM align: Int value to align text (0 for LEFT and 1 for RIGHT)
 **/
void DisplaySpinnerOptions(String spinnerText, int rotateAmt, int xStart, int align) {
  pushMatrix();
  translate(width/2, height/2);
  textSize(12);
  if (align == 0) {
    textAlign(LEFT);
  } else {
    textAlign(RIGHT);
  }
  rotate(radians(rotateAmt));
  text(spinnerText, xStart, 0);
  popMatrix();
}

/**
 * When the mouse is clicked check that it is within dial location
 * select random target value to begin spinning dial
 * calculate the final value to determine dial selection
 **/
void mouseClicked() {
  if (!beginInfoTrans) {
    // Check mouse is within dial size and then selected targetValue and finalValue
    if (abs(dist(mouseX, mouseY, 400, 400)) < 50) {
      showInfo = false;
      spin = targetValue;
      targetValue = targetValue + random(720, 1440);
      finalValue = (targetValue - (int(targetValue / 360) * 360));
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    beginInfoTrans = !beginInfoTrans;
  }
}
