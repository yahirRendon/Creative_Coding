/**************************************************************
 Project:  Faux endless 3D terrain generator controlled by 
           Perlin noise. Terrain speed can be controlled manually
           or by adjusting sensativity to audio from monitor in. 
           Additionally control for Perlin noise is also available. 
           
           2D terrain exists on the left and right sides of the
           window that can be pushed and pulled with the mouse. 
           
 Author:  Yahir 
 Date:    March 2020
 Update:  May 2021
 
 Notes:
          - Processing 3.5.4
 
 Instructions:
           1. run with standard window size or change to fullscreen
           2. run sketch
           3. SPACE to toggle settings
           4. mold edge terrain
               - LEFT MOUSE  | repel edge terrain nodes
               - RIGHT MOUSE | attract edge terrain nodes
           5. play with other settings
           6. enjoy!
           
 **************************************************************/

import processing.sound.*;

final float[] SCULPT_SIZE = new float[]{60, 5, 100};          // scult brush start value, min, max
final float[] MAIN_HUE = new float[]{300, 0, 360};            // main terrain start value, min max
final float[] EDGE_HUE = new float[]{300, 0, 360};            // edge terrain start value, min max
final float[] PEAK_AMT = new float[]{0.065, 0.0, 0.25};       // peak start value, min, max
final float[] FLOW_AMT = new float[]{0.03, 0.0, 0.25};        // flow start value, min, max
final float[] FEEL_STD = new float[]{0.002, 0.000, 0.009};    // feel standard start value, min, max
final float[] FEEL_MON = new float[]{0.01, 0.0, .5};          // feel monitor start value, min, max

PFont myFont;
int window_w;               // track window changes in width
int window_h;               // track window changes in height

Amplitude amp;              // amp analyzer for monitor in
AudioIn in;                 // access monitor in audio

int rows;                   // rows in main terrain
int cols;                   // cols in main terrain
Node[][] terrain2D;         // 2D array of main terrain nodes
float triangleMain_w;       // main terrain triangle width
float triangleMain_h;       // main terrain triangle height
int mainOffset_x;           // main terrain offset in x
int mainOffset_y;           // main terrain offset in y

int rowsEdge;               // rows in edge terrain
int colsEdge;               // cols in edge terrain
int edgeSize;               // edge terrain triangle size
int edgeOffset_x;           // edge terrain offset in x
Node[][] terrainLeft;       // 2D array of left terrain nodes
Node[][] terrainRight;      // 2d array of right terrain nodes

float moving;               // initial terrain moving offset (time)
float moveSpd;              // traverse terrain speed

float currentAmp;           // current amp from monitor in values
boolean rightPressed;       // toggle left mouse button pressed
boolean leftPressed;        // toggle right mouse button pressed
boolean showSettings;       // toggle showing settings
float showSettingsTrans;    // easing amount for setting transition

ButtonDial buttonReset;     // rest all settings
ButtonDial buttonMonitor;   // toggle standard vs monitor in modes
ButtonDial buttonClear;     // reset edge terrain nodes
Dial dialStyle;             // dial GUI for terrain style elements
Dial dialInput;             // dial GUI for main terrain settings
float sculptSize;           // edge terrain sculting brush size
float mainHue;              // main terrain hue value
float edgeHue;              // edge terrain hue value
float peakAmt;              // vertical variance in perlin noise
float flowAmt;              // lateral variance in perlin noise
float feelAmtStd;           // speed of terrain traverse in STD
float feelAmtMon;           // sensativity of mice in monitor mode

/**************************************************************
 SET UP FUNCTION
 **************************************************************/
void setup() {
  size(1200, 800, P2D);
  //fullScreen(P2D, 2);
  
  window_w = width;
  window_h = height;
  colorMode(HSB, 360, 100, 100, 100); 

  myFont = createFont("Montserrat-Light.otf", 100);
  textFont(myFont);
  
  currentAmp = 0.0;
  moving = 0;             
  moveSpd = 0.001;       
  rightPressed = false;
  leftPressed = false;

  sculptSize = SCULPT_SIZE[0];
  mainHue = MAIN_HUE[0];
  edgeHue = EDGE_HUE[0];
  peakAmt = PEAK_AMT[0];
  flowAmt = FLOW_AMT[0];
  feelAmtStd = FEEL_STD[0];
  feelAmtMon = FEEL_MON[0];

  // Create an Input stream which is routed into the Amplitude analyzer
  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);
  
  // set main terrain nodes
  rows = 25;
  cols = 38; 
  resizeMain();
  
  // set edge terrain nodes
  rowsEdge = 81; 
  colsEdge = 35;
  resizeEdges();
  
  // set buttons and setting elements
  resizeSettings();
  
  // for resizing window
  surface.setResizable(true);
  registerMethod("pre", this);
}

/**************************************************************
 PRE FUNCTION
 
 fun this before draw to check for window changes. If changes
 resize main, edge, and setting elements. 
 **************************************************************/
void pre() {
  if (window_w != width || window_h != height) {
    // Sketch window has resized
    window_w = width;
    window_h = height;
    resizeEdges();
    resizeMain();
    resizeSettings();
    
  }
}

/**************************************************************
 DRAW FUNCTION
 **************************************************************/
void draw() {
  background(0, 0, 95);

  // edge terrain
  updateEdgeTerrain();
  displayEdgeTerrain();

  // main 3D terrain
  updateTerrain3D();
  displayTerrain3D();

  // settings
  displaySettings();  
}

/**************************************************************
 MOUSECLICKED FUNCTION
 
 LEFT  | when settings open allow adjustments
 **************************************************************/
void mouseClicked() {
    
  // allow setting updates when settings displayed
  if (showSettings) {
    // since dialInput feel has two settings check which to update
    buttonMonitor.updateState();
    if(buttonMonitor.state) {
      dialInput.buttons[0].min = FEEL_MON[1];
      dialInput.buttons[0].max = FEEL_MON[2];
      dialInput.buttons[0].value = feelAmtMon;
   } else {
      dialInput.buttons[0].min = FEEL_STD[1];
      dialInput.buttons[0].max = FEEL_STD[2];
      dialInput.buttons[0].value = feelAmtStd;
   }
   
   // reset the edge terrain and then reset button to false
   buttonClear.updateState();
   if(buttonClear.state) {
     //resetEdgeTerrain();
     resizeEdges();
     buttonClear.updateState();
   }
   
   buttonReset.updateState();
   if(buttonReset.state) {
     buttonMonitor.state = false;
     dialStyle.valueIndex = 0;
     dialStyle.buttons[0].min = SCULPT_SIZE[1];
     dialStyle.buttons[0].max = SCULPT_SIZE[2];
     dialStyle.buttons[0].value = SCULPT_SIZE[0];
     dialStyle.buttons[1].min = MAIN_HUE[1];
     dialStyle.buttons[1].max = MAIN_HUE[2];
     dialStyle.buttons[1].value = MAIN_HUE[0];
     dialStyle.buttons[2].min = EDGE_HUE[1];
     dialStyle.buttons[2].max = EDGE_HUE[2];
     dialStyle.buttons[2].value = EDGE_HUE[0];
     
     //#fix feel
     dialInput.buttons[0].state = true;
     dialInput.valueIndex = 0;
     dialInput.buttons[0].min = FEEL_STD[1];
     dialInput.buttons[0].max = FEEL_STD[2];
     dialInput.buttons[0].value = FEEL_STD[0];
     feelAmtMon = FEEL_MON[0];
     
     
     dialInput.buttons[1].min = PEAK_AMT[1];
     dialInput.buttons[1].max = PEAK_AMT[2];
     dialInput.buttons[1].value = PEAK_AMT[0];
     dialInput.buttons[2].min = FLOW_AMT[1];
     dialInput.buttons[2].max = FLOW_AMT[2];
     dialInput.buttons[2].value = FLOW_AMT[0];
     
     //resetEdgeTerrain();
     resizeEdges();
     buttonReset.updateState();
   }
   
   // update the dial values and buttons
   dialStyle.updateButtonState();
   dialInput.updateButtonState();
  }
}

/**************************************************************
 MOUSEPRESSED FUNCTION
 
 LEFT  | controls push edge terrain ability
 RIGHT | controls attract edge terrain ability
 **************************************************************/
void mousePressed() {
  if (!showSettings) {
    if (mouseButton == LEFT) {
      leftPressed = true;
    } 
    if (mouseButton == RIGHT) {
      rightPressed = true;
    }
  }
}

/**************************************************************
 MOUSEPRESSED FUNCTION
 
 LEFT  | controls push edge terrain ability
 RIGHT | controls attract edge terrain ability
 **************************************************************/
void mouseReleased() {
  if (!showSettings) {
    if (mouseButton == LEFT) {
      leftPressed = false;
    } 
    if (mouseButton == RIGHT) {
      rightPressed = false;
    }
  }
}

/**************************************************************
 KEYPRESSED FUNCTION
 
 KEY ' '  | toggle settings
 **************************************************************/
void keyPressed() {
  if (key == ' ') {
    showSettings = !showSettings; 
  }
}

/*
 * Method for creating easing
 *
 * @param: float | start value for easing from
 * @param: float | target value for easing to
 * @param: float | speed of easing
 *
 */
float ease(float start, float target, float spd) {
  float dx = target - start;
  return dx * spd;
}

/**
* Interpolation function using the exponential out easing function
* by easing.net
*
* @param {int}   a      first value
* @param {int}   b      second value
* @param {float} t      amt between 0.0 and 1.0
* @return               value between first and second value given t
*/
float exerpOut(int a, int b, float t) {
  if(t <= 0) return a;
  if(t >= 1) return b;
  float out_t = 1 - pow(2, -10 * t);
  return a + (b - a) * out_t;
}

/**
* create and resize edge nodes for left and right
*/
void resizeEdges() {  
  edgeSize = int(width * 0.3) / colsEdge;
  edgeOffset_x = width - (edgeSize * (colsEdge -1));

  // initialize edge terrain nodes that will be
  // used for creating terrain on the edge of window
  // and can be controlled via mouse
  terrainLeft = new Node[colsEdge][rowsEdge];
  terrainRight = new Node[colsEdge][rowsEdge];
  
  // set initial x and y values for terrain
  for (int y = 0; y < rowsEdge; y++) {
    for (int x = 0; x < colsEdge; x++) {
      // create left nodes
      float xpos_left = 0 + (x * edgeSize);
      float ypos_left = 0 + (y * edgeSize);
      terrainLeft[x][y] = new Node(xpos_left, ypos_left);
      
      // create right nodes
      float xpos_right = edgeOffset_x + (x * edgeSize);
      float ypos_right = 0 + (y * edgeSize);
      terrainRight[x][y] = new Node(xpos_right, ypos_right);
    }
  }
}

/**
* create and resize main terrain nodes
*/
void resizeMain() {
  triangleMain_w = int(width * .5) / cols;
  triangleMain_h = int(height * .3) / rows;
    
  // calculate offset x and y for main terrain
  float left_x = ((triangleMain_h)) + (triangleMain_w);
  float left_y = ((rows-1) * triangleMain_h);  
  float right_x = (((cols-1) * triangleMain_h) + (cols-1) * triangleMain_w);
  float right_y = ((rows-1) * triangleMain_h);
  float terrainLength = dist(left_x, left_y, right_x, right_y);
  mainOffset_x = int(terrainLength/2);     
  mainOffset_y = int(height * 0.3);
  
  // intialize main terrain nodes that will be used
  // for creating 3d effect using perlin noise
  terrain2D = new Node[cols][rows];
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      // offset x position to determine start and adjust for triangle dimensions
      float xpos = (mainOffset_x - (y * triangleMain_h)) + (x * triangleMain_w);
      float ypos = mainOffset_y + (y * triangleMain_h);
      terrain2D[x][y] = new Node(xpos, ypos);
    }
  }
}

/**
* create and size setting buttons and GUI elements
*/
void resizeSettings() {
  buttonClear = new ButtonDial("clear", "reset edge terrain", false, 0, 0, 0);
  int xadj = int(buttonClear.w/2);
  buttonClear.setPosition(int((width * 0.4) - xadj), int(height * 0.8));
  
  buttonReset = new ButtonDial("reset", "reset all settings", false, 0, 0, 0);
  buttonReset.setPosition(int((width * 0.5) - xadj), int(height * 0.8));
  
  buttonMonitor = new ButtonDial("monitor", "control feel via audio in", false, 0.00, 1.0, 0.03);
  buttonMonitor.setPosition(int((width * 0.6) - xadj), int(height * 0.8));
  
  // create buttons for style and input elements of dial
  ButtonDial[] styleButtons = new ButtonDial[]{
    // name, description, initial state, min, max, initial value
    new ButtonDial("size", "edge terrain sculpt size", true, SCULPT_SIZE[1], SCULPT_SIZE[2], SCULPT_SIZE[0]),
    new ButtonDial("main", "hue of edge terrain", false, MAIN_HUE[1], MAIN_HUE[2], MAIN_HUE[0]),
    new ButtonDial("edge", "hue of main terrain", false, EDGE_HUE[1], EDGE_HUE[2], EDGE_HUE[0])};
    // x, y, name, buttons
  dialStyle = new Dial(int(width *.2), int(height * 0.5), "", styleButtons);
  dialStyle.numRound = 0;
  
  ButtonDial[] inputbuttons = new ButtonDial[]{
    new ButtonDial("feel", "sensativity level", true, FEEL_STD[1], FEEL_STD[2], FEEL_STD[0]),
    new ButtonDial("peak", "vertical variance", false, PEAK_AMT[1], PEAK_AMT[2], PEAK_AMT[0]),
    new ButtonDial("flow", "lateral variance", false, FLOW_AMT[1], FLOW_AMT[2], FLOW_AMT[0])};
  dialInput = new Dial(int(width *.8), int(height * 0.5), "", inputbuttons);
  dialInput.numRound = 3;
}

/*
 * function for displaying GUI setting elements
 */
void displaySettings() {
  textAlign(CENTER, CENTER);

  // dispaly title text 
  textSize(80);
  fill(0, 0, 80);
  text("terrain", width/2, 60);

  // check if show settings is toggled
  if (showSettings) { 
    // Manage easing in 
    showSettingsTrans += ease(showSettingsTrans, 75, .075);
    if (showSettingsTrans > 60) {
      showSettingsTrans = 60;
    }
    // display tinted background rect
    fill(0, 0, 0, showSettingsTrans);
    rect(-1, -1, width + 1, height + 1);
    textAlign(CENTER, CENTER);

    //display title text and author
    textSize(80);
    fill(0, 0, 100);
    text("terrain", width/2, 60);
    fill(0, 0, 85);
    textSize(18);
    text("by yahir", width/2, 160);
    
    // buttons and dials
    sculptSize = dialStyle.getValue(0);
    mainHue = dialStyle.getValue(1);
    edgeHue = dialStyle.getValue(2);

    if(buttonMonitor.state) {
      feelAmtMon = dialInput.getValue(0);
    } else {
      feelAmtStd = dialInput.getValue(0);
    }
    peakAmt = dialInput.getValue(1);
    flowAmt = dialInput.getValue(2);
    
    dialStyle.display();
    dialInput.display();
    
    buttonClear.display();
    buttonReset.display();
    buttonMonitor.display();
    
    // disaply description on active
    textSize(18);
    fill(0, 0, 100);
    if(buttonClear.active()) {
      text(buttonClear.getDescription(), width/2, 680);
    }
    if(buttonReset.active()) {
      text(buttonReset.getDescription(), width/2, 680);
    }
    if(buttonMonitor.active()) {
      text(buttonMonitor.getDescription(), width/2, 680);
    }
    
    if(buttonClear.active() || buttonReset.active() || buttonMonitor.active() ||
       dialInput.active() || dialInput.buttons[0].active() || dialInput.buttons[1].active() || dialInput.buttons[2].active() ||
       dialStyle.active() || dialStyle.buttons[0].active() || dialStyle.buttons[1].active() || dialStyle.buttons[2].active()) {
  
      cursor(HAND);
    } else {
      cursor(ARROW);
    }
  } else { // Manage easing out 
    showSettingsTrans += ease(showSettingsTrans, 0, .05);
    if (showSettingsTrans < 2) {
      showSettingsTrans = 0;
    }
  }
}

/*
 * function updating the position of nodes within faux 3D
 * generated with perlin noise and monitor in
 */
void updateTerrain3D() {
  // update based on audio input
  if(buttonMonitor.state) {
      currentAmp = map(amp.analyze(), 0, 1, 0.00, feelAmtMon);
      moveSpd += ease(moveSpd, currentAmp, .0075);
  } else {
    // update based on standard
    moveSpd = dialInput.getValue(0);
  }

  moving += moveSpd;
  float xoff = moving;
  for (int y = 0; y < rows; y++) {
    float yoff = 0;
    for (int x = 0; x < cols; x++) {
      // set the y value based on perline noise xoff and yoff values
      terrain2D[x][y].y = (mainOffset_y + (y * triangleMain_h)) + map(noise(xoff, yoff), 0, 1, -200, 200);

      yoff += dialInput.getValue(1);
    }
    xoff += dialInput.getValue(2);
  }
}

/*
 * function for display faux 3D terrain 
 */
void displayTerrain3D() {

  // Create and fill faux 3D triangles based on node x and y
  for (int y = 0; y < rows - 1; y++) {
    for (int x = 0; x < cols -1; x++) {
      // Set color and stroke values
      float alphaval = exerpOut(5, 100, map(y, 0, rows, 0, 1));
      float brightval = map(y, 0, rows, 70, 15);
      fill(dialStyle.getValue(1), 90, brightval, alphaval); 
      stroke(0, 0, 100, 20); 

      // Generate appropriate triangles
      triangle(terrain2D[x][y].x, terrain2D[x][y].y, terrain2D[x][y + 1].x, terrain2D[x][y + 1].y, terrain2D[x+ 1][y].x, terrain2D[x + 1][y].y);
      triangle(terrain2D[x+1][y].x, terrain2D[x+1][y].y, terrain2D[x][y + 1].x, terrain2D[x][y + 1].y, terrain2D[x+ 1][y+1].x, terrain2D[x + 1][y+1].y);
    }
  }

  // Create faux shadow effect for faux 3D terrain
  float lux = terrain2D[0][0].x +25;
  float luy = terrain2D[0][0].y;
  float rux = terrain2D[cols-1][0].x - 100;
  float ruy = terrain2D[cols-1][0].y;
  float rdx = terrain2D[cols-1][rows-1].x - 50;
  float rdy = terrain2D[cols-1][rows-1].y;
  float ldx = terrain2D[0][rows-1].x + 75;
  float ldy = terrain2D[0][rows-1].y;
 
  float offset_y = height *0.9;
 
  noStroke();
  fill(0, 1);
  for(int i = 0; i < 10; i++) {
    float r = (i * 10);
    float off_lux = map(luy, mainOffset_y - 200, mainOffset_y + 200, r, r);
    float off_rux = map(ruy, mainOffset_y - 200, mainOffset_y + 200, -r, r);
    float off_rdx = map(rdy, mainOffset_y - 200, mainOffset_y + 200, -r, r);
    float off_ldx = map(ldy, mainOffset_y - 200, mainOffset_y + 200, r, r);
      
    float final_lux = lux + off_lux;
    float final_luy = offset_y - 25;
    float final_rux = rux + off_rux;
    float final_ruy = offset_y - 25;
    float final_rdx = rdx - off_rdx;
    float final_rdy = offset_y;
    float final_ldx = ldx + off_ldx;
    float final_ldy = offset_y;
      
    beginShape();
      vertex(final_lux - i , final_luy - i );
      vertex(final_rux + i , final_ruy  - i);
      vertex(final_rdx - i , final_rdy + i );
      vertex(final_ldx - i, final_ldy  + i);
    endShape(); 
  
    }
}


/*
 * function updating the position of nodes withing 
 * edge terrains when being manipulated by mouse clicks
 */
void updateEdgeTerrain() {
  // check if left mouse button is pressed (repel)
  if (leftPressed) {
    //loop through each node
    for (int y = 0; y < rowsEdge; y++) {
      for (int x = 0; x < colsEdge; x++) {       
        // get distance from current node to mouseX and mouseY for both terrains
        float dL = abs(dist(mouseX, mouseY, terrainLeft[x][y].x, terrainLeft[x][y].y));   
        float dR = abs(dist(mouseX, mouseY, terrainRight[x][y].x, terrainRight[x][y].y));

        // check if the left terrain/mouse distance is within limits for repelling nodes
        if (dL < dialStyle.getValue(0) && dL > 5) {
          float radians = atan2(mouseY-terrainLeft[x][y].y, mouseX-terrainLeft[x][y].x)+PI;          
          float d2 = abs(dist(mouseX, mouseY, terrainLeft[x][y].x, terrainLeft[x][y].y));
          //update x, y, and z values of terrain
          terrainLeft[x][y].x = terrainLeft[x][y].x + map(d2, dialStyle.getValue(0), 0, 0, 1) * cos(radians);
          terrainLeft[x][y].y = terrainLeft[x][y].y + map(d2, dialStyle.getValue(0), 0, 0, 1) * sin(radians);
          terrainLeft[x][y].z = terrainLeft[x][y].z + 1;
          if (terrainLeft[x][y].z > 100) {
            terrainLeft[x][y].z = 100;
          }
        }

        // check if the right terrain/mouse distance is within limits for repelling nodes
        if (dR < dialStyle.getValue(0) && dR > 5) {
          float radians = atan2(mouseY-terrainRight[x][y].y, mouseX-terrainRight[x][y].x)+PI;          
          float d2 = abs(dist(mouseX, mouseY, terrainRight[x][y].x, terrainRight[x][y].y));
          terrainRight[x][y].x = terrainRight[x][y].x + map(d2, dialStyle.getValue(0), 0, 0, 1) * cos(radians);
          terrainRight[x][y].y = terrainRight[x][y].y + map(d2, dialStyle.getValue(0), 0, 0, 1) * sin(radians);
          terrainRight[x][y].z = terrainRight[x][y].z + 1;
          if (terrainRight[x][y].z > 100) {
            terrainRight[x][y].z = 100;
          }
        }
      }
    }
  }

  // Check if right mouse button pressed (shrink)
  if (rightPressed) {
    for (int y = 1; y < rowsEdge-1; y++) {
      for (int x = 1; x < colsEdge-1; x++) {        
        // get distance from current node to mouseX and mouseY for both terrains
        float dL = abs(dist(mouseX, mouseY, terrainLeft[x][y].x, terrainLeft[x][y].y)); 
        float dR = abs(dist(mouseX, mouseY, terrainRight[x][y].x, terrainRight[x][y].y)); 

        // check if the left terrain/mouse distance is within limits for shrinking nodes
        if (dL < dialStyle.getValue(0) && dL > 5) {
          float radians = atan2(mouseY-terrainLeft[x][y].y, mouseX-terrainLeft[x][y].x)+PI;         
          float d2 = abs(dist(mouseX, mouseY, terrainLeft[x][y].x, terrainLeft[x][y].y));
          terrainLeft[x][y].x = terrainLeft[x][y].x - map(d2, 0, dialStyle.getValue(0), 0, .5) * cos(radians);
          terrainLeft[x][y].y = terrainLeft[x][y].y - map(d2, 0, dialStyle.getValue(0), 0, .5) * sin(radians);
          terrainLeft[x][y].z = terrainLeft[x][y].z - 1;
          if (terrainLeft[x][y].z < 0) {
            terrainLeft[x][y].z = 0;
          }
        }

        // check if the left terrain/mouse distance is within limits for shrinking nodes
        if (dR < dialStyle.getValue(0) && dR > 5) {
          float radians = atan2(mouseY-terrainRight[x][y].y, mouseX-terrainRight[x][y].x)+PI;         
          float d2 = abs(dist(mouseX, mouseY, terrainRight[x][y].x, terrainRight[x][y].y));
          terrainRight[x][y].x = terrainRight[x][y].x - map(d2, 0, dialStyle.getValue(0), 0, .5) * cos(radians);
          terrainRight[x][y].y = terrainRight[x][y].y - map(d2, 0, dialStyle.getValue(0), 0, .5) * sin(radians);
          terrainRight[x][y].z = terrainRight[x][y].z - 1;
          if (terrainRight[x][y].z < 0) {
            terrainRight[x][y].z = 0;
          }
        }
      }
    }
  }
}

/*
 * function for displaying edge terrains
 */
void displayEdgeTerrain() {
  // create and fill triangles based on node x and y
  // exclude edge nodes to prevent edges from shrinking 
  noStroke();
  int edgeLength = (edgeSize * (colsEdge -1));
  for (int x = 0; x < colsEdge - 1; x++) {
    for (int y = 0; y < rowsEdge -1; y++) {
      // left terrain
      float avgL = (terrainLeft[x][y].z + terrainLeft[x][y + 1].z + terrainLeft[x+ 1][y].z)/3;
      float distEdgeL = (terrainLeft[x][y].x + terrainLeft[x][y + 1].x + terrainLeft[x+ 1][y].x)/3;      
      float mapDistEdgeL = map(distEdgeL, 0, edgeLength, 30, -5);
      
      // each square is divided into two triangles. the underlying solid triangle prevents alpha stacking
      fill(0, 0, 95);
      triangle(terrainLeft[x][y].x, terrainLeft[x][y].y, terrainLeft[x][y + 1].x, terrainLeft[x][y + 1].y, terrainLeft[x+ 1][y].x, terrainLeft[x + 1][y].y);  
      fill(dialStyle.getValue(2), 30 + avgL, 60, mapDistEdgeL);     
      triangle(terrainLeft[x][y].x, terrainLeft[x][y].y, terrainLeft[x][y + 1].x, terrainLeft[x][y + 1].y, terrainLeft[x+ 1][y].x, terrainLeft[x + 1][y].y);
      
      fill(0, 0, 95);
      triangle(terrainLeft[x+1][y].x, terrainLeft[x+1][y].y, terrainLeft[x][y + 1].x, terrainLeft[x][y + 1].y, terrainLeft[x+ 1][y+1].x, terrainLeft[x + 1][y+1].y); 
      fill(dialStyle.getValue(2), 30 + avgL, 60, mapDistEdgeL); 
      triangle(terrainLeft[x+1][y].x, terrainLeft[x+1][y].y, terrainLeft[x][y + 1].x, terrainLeft[x][y + 1].y, terrainLeft[x+ 1][y+1].x, terrainLeft[x + 1][y+1].y);
      
      float avgR = (terrainRight[x][y].z + terrainRight[x][y + 1].z + terrainRight[x+ 1][y].z)/3;
      float distEdgeR = (terrainRight[x][y].x + terrainRight[x][y + 1].x + terrainRight[x+ 1][y].x)/3;
      float mapDistEdgeR = map(distEdgeR, edgeOffset_x, width, -5, 30);
      
      // each square is divided into two triangles. the underyling solid triangle prevent alpha stacking
      fill(0, 0, 95);
      triangle(terrainRight[x][y].x, terrainRight[x][y].y, terrainRight[x][y + 1].x, terrainRight[x][y + 1].y, terrainRight[x+ 1][y].x, terrainRight[x + 1][y].y);   
      fill(dialStyle.getValue(2), 30 + avgR, 60, mapDistEdgeR);
      triangle(terrainRight[x][y].x, terrainRight[x][y].y, terrainRight[x][y + 1].x, terrainRight[x][y + 1].y, terrainRight[x+ 1][y].x, terrainRight[x + 1][y].y);
      
      fill(0, 0, 95);
      triangle(terrainRight[x+1][y].x, terrainRight[x+1][y].y, terrainRight[x][y + 1].x, terrainRight[x][y + 1].y, terrainRight[x+ 1][y+1].x, terrainRight[x + 1][y+1].y);
      fill(dialStyle.getValue(2), 30 + avgR, 60, mapDistEdgeR);
      triangle(terrainRight[x+1][y].x, terrainRight[x+1][y].y, terrainRight[x][y + 1].x, terrainRight[x][y + 1].y, terrainRight[x+ 1][y+1].x, terrainRight[x + 1][y+1].y);
    }
  }
}
