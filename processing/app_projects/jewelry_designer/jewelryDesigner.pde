/******************************************************************************
 Project:  tool for creating binary beaded jewelery. converts string of text
           into binary and populates a looming grid using predefined patterns
           or by selecting/deselecting individual beads. 
 
 Author:   Yahir
 Date:     January 2023
 
 Notes:    processing 3.5.4^ 
 
 Instructions:
 - use edit icon to change message. see the binary embed within grid
 - most adjustments can be made via the UI
 - space bar  | move the bead guide row down
 - down arrow | move the bead guide row down
 - up arrow   | move the bead guide row up
 
 binary to string: https://codebeautify.org/binary-string-converter
 ******************************************************************************/

// default colors
color light;              
color medium;
color highlight;

PImage editIconRed;            // edit pencil icon color red
PImage editIconBlack;          // edit pencil icon color black

PFont font;
String projectName;            // who/what is this piece for
int dropShadowSize;            // amount of shadow for ui effect

ArrayList<Integer> msgBits;    // holds binary values of the message to embed

int guideRow;                  // track which row is highlighted when using bead guide
boolean beadGuide;             // toggle beading guide

float[][] beadSizeChart;      // look up table for bead size, bead width, bead height for dimensions
int beadSizeChartIndex;       // move through beadSizeChart by index

boolean leftClicked;          // track left clicked
boolean rightClicked;         // track right clicked

int scrollPosition;           // track vertial scroll of bead grid
Slider sliderScroll;          // slider for scrolling beads up and down
Slider sliderBeadSize;        // slider for adjusting bead size/zoom

BeadGrid bg;                  // bead grid object. displays all beads in jewelry piece


InfoBar infoBar;              // info bar object. display select feedback to user

TextFieldBasic msgTF;         // text field for editing/displaying text to embed in jewelry
TextFieldBasic saveNameTF;    // text field for editing/displaying project name

// arrays for positioning buttons
// [0][1] xy for text [2][3] left button [4][5] right button
int[] buttonRow;
int[] buttonCol;
int[] buttonVert;
int[] buttonHor;
int[] buttonSolid;
int[] buttonGap;
int[] buttonStyle;
int[] buttonSize;
Button buttonDelRow, buttonAddRow;         // buttons for deleting/adding row
Button buttonDelCol, buttonAddCol;         // buttons for deleting/adding columns
Button buttonDelVert, buttonAddVert;       // buttons for decrement/increment vertical margin
Button buttonDelHor, buttonAddHor;         // buttons for decrement/increment horizontal margin
Button buttonDelSolid, buttonAddSolid;     // buttons for decrement/increment solid span
Button buttonDelGap, buttonAddGap;         // buttons for decrement/increment spread gap
Button buttonDelStyle, buttonAddStyle;     // buttons for switching spread styles
Button buttonDelSize, buttonAddSize;       // buttons for decrement/increment bead size (dimension calc only)
Button buttonGuide;                        // button for toggling beadGuide
Button buttonLoad;                         // button for loading design
Button buttonSave;                         // buton for saving a design
Button buttonBit0, buttonBit1, buttonBit2; // used for visual display of the number of beads with bit values

/******************************************************************************
 * 
 * setup method
 * 
 *****************************************************************************/
void setup() {
  size(900, 900);
  surface.setTitle("Binary Jewelry Designer by Yahir");

  editIconRed = loadImage("edit-icon-red.png");
  editIconBlack = loadImage("edit-icon-black.png");
  font = createFont("SpaceGrotesk-Light.ttf", 32);
  textFont(font);

  light = color(246, 246, 246);
  medium = color(250, 250, 250);
  highlight = color(240, 0, 0);

  // global stuff
  projectName = "";
  dropShadowSize = 2;
  scrollPosition = 0;
  beadSizeChartIndex = 0;
  guideRow = 0;      
  beadGuide = false;  

  // create and initialize bead grid
  int numCols = 11; 
  int numRows = 51; 
  int beadSize = 14;   
  bg = new BeadGrid(numCols, numRows, beadSize);
  msgTF = new TextFieldBasic(625, 110, 855, 70, "what say you?...");

  // convert message to binary
  msgBits = new ArrayList<Integer>();
  msgBits = StringToBinary_8bit(msgTF.textStr);

  // intiilaize bead grid scroll and bead size slider
  sliderScroll = new Slider(25, 50, 800, 0, 450);
  sliderBeadSize = new Slider(50, 875, 300, 1, 100);

  // ui button posistions on left
  buttonRow = buttonPairPositions(500, 490);
  buttonCol = buttonPairPositions(500, 540);
  buttonSolid = buttonPairPositions(500, 590);
  buttonStyle = buttonPairPositions(500, 640);
  // ui button positions on right
  buttonVert = buttonPairPositions(750, 490);  
  buttonHor = buttonPairPositions(750, 540);
  buttonGap = buttonPairPositions(750, 590);
  buttonSize = buttonPairPositions(750, 640);
  // ui buttons
  buttonDelRow = new Button(buttonRow[2], buttonRow[3], 20);
  buttonAddRow = new Button(buttonRow[4], buttonRow[5], 20);
  buttonDelCol = new Button(buttonCol[2], buttonCol[3], 20);
  buttonAddCol = new Button(buttonCol[4], buttonCol[5], 20);
  buttonDelVert = new Button(buttonVert[2], buttonVert[3], 20);
  buttonAddVert = new Button(buttonVert[4], buttonVert[5], 20);
  buttonDelHor = new Button(buttonHor[2], buttonHor[3], 20);
  buttonAddHor = new Button(buttonHor[4], buttonHor[5], 20);
  buttonDelSolid = new Button(buttonSolid[2], buttonSolid[3], 20);
  buttonAddSolid = new Button(buttonSolid[4], buttonSolid[5], 20);
  buttonDelGap = new Button(buttonGap[2], buttonGap[3], 20);
  buttonAddGap = new Button(buttonGap[4], buttonGap[5], 20);
  buttonDelStyle = new Button(buttonStyle[2], buttonStyle[3], 20);
  buttonAddStyle = new Button(buttonStyle[4], buttonStyle[5], 20);
  buttonDelSize = new Button(buttonSize[2], buttonSize[3], 20);
  buttonAddSize = new Button(buttonSize[4], buttonSize[5], 20);
  buttonGuide = new Button(475, 800, 60, "guide");
  buttonLoad = new Button(625, 800, 60, "load");
  buttonSave = new Button(775, 800, 60, "save");
  buttonBit0 = new Button(475, 310, 80, ""); 
  buttonBit1 = new Button(625, 310, 80, ""); 
  buttonBit2 = new Button(775, 310, 80, ""); 

  infoBar = new InfoBar(width - 25, height - 25);
  saveNameTF = new TextFieldBasic(625, 735, 855, 730, "untitled-project");

  beadSizeChart = new float[][]{
    {8, 2.5, 2.5}, 
    {10, 2.3, 1.2}, 
    {11, 1.6, 1.5}, 
    {15, 1.3, 1}, 
  };
}


/******************************************************************************
 * 
 * draw method
 * 
 *****************************************************************************/
void draw() {
  background(medium);

  // display ui elements
  displayTextUI();
  displayButtons();
  infoBar.display();
  msgTF.display2();
  saveNameTF.display2();

  // edit/update/display bead grid elements
  msgBits = StringToBinary_8bit(msgTF.textStr);
  bg.assignMsgToBeads(msgBits);
  bg.calculateBeadNumbers();
  bg.setBeadSize(int(map(sliderBeadSize.sliderVal, sliderBeadSize.minX, sliderBeadSize.maxX, 8, 41)));
  bg.updateBeadPosition();
  bg.display();

  // update and display sliders
  scrollPosition = sliderScroll.sliderVal;
  sliderScroll.update();
  sliderScroll.display();
  sliderBeadSize.update();
  sliderBeadSize.display();
}

/******************************************************************************
 * key pressed method
 *
 * LEFT  |
 * RIGHT |
 * DOWN  | guide row down
 * UP    | guide row up
 * SPACE | guide row down
 *****************************************************************************/
void keyPressed() {
  // text field input
  msgTF.update();
  saveNameTF.update();

  if (key == CODED) {
    if (keyCode == DOWN) {
      guideRow++;
      if (guideRow > bg.rows - 1) guideRow = 0;
    }
    if (keyCode == UP) {
      guideRow--;
      if (guideRow < 0) guideRow = bg.rows - 1;
    }
  }

  if (key == ' ') {
    guideRow++;
    if (guideRow > bg.rows - 1) guideRow = 0;
  }
  
  if(!msgTF.inFocus && !saveNameTF.inFocus) {
    if(key == 's' || key == 'S') {
      saveFrame("data/ui-######.png");
    }
  }
}

/******************************************************************************
 * 
 * track left and right mouse pressed
 *
 *****************************************************************************/
void mousePressed() {
  if (mouseButton == LEFT) {
    leftClicked = true;
    // update buttons 
    buttonDelRow.update();
    buttonAddRow.update();
    buttonDelCol.update();
    buttonAddCol.update();
    buttonDelVert.update();
    buttonAddVert.update();
    buttonDelHor.update();
    buttonAddHor.update();
    buttonDelSolid.update();
    buttonAddSolid.update();
    buttonDelGap.update();
    buttonAddGap.update();
    buttonDelStyle.update();
    buttonAddStyle.update();
    buttonDelSize.update();
    buttonAddSize.update();
    buttonGuide.update();
    buttonLoad.update();
    buttonSave.update();
  }
  if (mouseButton == RIGHT) {
    rightClicked = true;
  }
}

/******************************************************************************
 *
 * track left and right mouse released
 *
 *****************************************************************************/
void mouseReleased() {
  if (mouseButton == LEFT) {
    leftClicked = false;
  }
  if (mouseButton == RIGHT) {
    rightClicked = false;
  }
}

/******************************************************************************
 *
 * opening and handling file selection for loading projects
 *
 *****************************************************************************/
void fileSelected(File selection) {
  if (selection == null) {
    infoBar.update("Window was closed or without selection.");
  } else {
    //println("User selected abs" + selection.getAbsolutePath());
    //println("User selected " + selection.getName());
    String fileName = selection.getName();
    infoBar.update("opened file: " + fileName.substring(0, fileName.length() - 4));
    loadOpenArray(selection.getName());
  }
}

/******************************************************************************
 * 
 * create and save a csv file that holds a list of the desired open/closed 
 * beads along with important information for recreating it uponload.
 * 
 *****************************************************************************/
void saveOpenArray() {
  // get date details for name
  int day = day();
  int mon = month();
  int year = year();
  int hour = hour();
  int min = minute();
  int sec = second();

  // format save name file
  String fileName = saveNameTF.textStr + "-" +
    year + String.format("%02d", mon) +
    String.format("%02d", day) + "_" +
    String.format("%02d", hour)+ 
    String.format("%02d", min) + 
    String.format("%02d", sec);

  // create table object that will be saved
  Table csvTable = new Table();

  // add table headers
  csvTable.addColumn("open");
  csvTable.addColumn("cols");
  csvTable.addColumn("rows");
  csvTable.addColumn("vertical");
  csvTable.addColumn("horiztonal");
  csvTable.addColumn("solid");
  csvTable.addColumn("gap");
  csvTable.addColumn("message");

  // loop through beads and update table
  for (int i = 0; i < bg.beads.size(); i++) {
    // create new row
    TableRow newRow = csvTable.addRow();

    // for initial row add dimensions and message
    if (i == 0) {
      newRow.setInt("cols", bg.cols);
      newRow.setInt("rows", bg.rows);
      newRow.setInt("vertical", bg.verticalCap);
      newRow.setInt("horiztonal", bg.horizontalCap);
      newRow.setInt("solid", bg.solidSpan);
      newRow.setInt("gap", bg.spreadGap);
      newRow.setString("message", msgTF.textStr);
    }

    // add open adn close rows
    if (bg.beads.get(i).open) {
      newRow.setInt("open", 1);
    } else {
      newRow.setInt("open", 0);
    }
  }

  // save the created table
  saveTable(csvTable, "projects/"+ fileName + ".csv");
  String infoText = "saved: " + fileName;
  infoBar.update(infoText);
}

/******************************************************************************
 *
 * load a project by getting the selected .csv file and updating the 
 * appropriate settings for display.
 * 
 *****************************************************************************/
void loadOpenArray(String name) {
  // update project name based on file
  saveNameTF.textStr = name.substring(0, name.length() - 20);
  
  // open file
  Table csvTable = loadTable("projects/" + name, "header");
  
  // update settings based on row 0
  TableRow roww = csvTable.getRow(0);
  bg.cols = roww.getInt("cols");
  bg.rows = roww.getInt("rows");
  bg.verticalCap = roww.getInt("vertical");
  bg.horizontalCap = roww.getInt("horiztonal");
  bg.solidSpan = roww.getInt("solid");
  bg.spreadGap = roww.getInt("gap");
  msgTF.textStr = roww.getString("message");


  // populate beads with bracelet dimensions
  bg.beads.clear();
  for (int y = 0; y < bg.rows; y++) {
    for (int x = 0; x < bg.cols; x++) {
      bg.beads.add(new Bead(x, y, bg.cols, bg.rows, bg.beadSize));
    }
  }

  // convert message to binary
  msgBits = StringToBinary_8bit(msgTF.textStr);

  int index = 0;
  for (TableRow row : csvTable.rows()) {
    int openValue = row.getInt("open");
    if (openValue == 0) {
      bg.beads.get(index).open = false;
    } else {
      bg.beads.get(index).open = true;
    }
    index++;
  }
}


/******************************************************************************
 * 
 * display ui elements and text
 * 
 *****************************************************************************/
void displayTextUI() {
  // dropShadowEffect
  noStroke();
  fill(255);
  rect(50 - dropShadowSize/2, 50 - dropShadowSize/2, 300, 800, 8);  // beads
  rect(375 - dropShadowSize/2, 50 - dropShadowSize/2, 500, 140, 8); // message 
  rect(375 - dropShadowSize/2, 200 - dropShadowSize/2, 500, 240, 8); // bead 
  rect(375 - dropShadowSize/2, 450 - dropShadowSize/2, 500, 250, 8); // edit 
  rect(375 - dropShadowSize/2, 710 - dropShadowSize/2, 500, 140, 8); // file 
  fill(0, 30);
  rect(50 + dropShadowSize, 50 + dropShadowSize, 300, 800, 8);  // beads
  rect(375 + dropShadowSize, 50 + dropShadowSize, 500, 140, 8); // message
  rect(375 + dropShadowSize, 200 + dropShadowSize, 500, 240, 8); // bead
  rect(375 + dropShadowSize, 450 + dropShadowSize, 500, 250, 8); // edit
  rect(375 + dropShadowSize, 710 + dropShadowSize, 500, 140, 8); // file

  // background rects
  fill(light);
  // left rect
  rect(50, 50, 300, 800, 8);  // for displaying beads

  // right side rects
  rect(375, 50, 500, 140, 8); // message info
  rect(375, 200, 500, 240, 8); // bead info
  rect(375, 450, 500, 250, 8); // edit buttons
  rect(375, 710, 500, 140, 8); // file buttons

  // title
  textAlign(CENTER, CENTER);
  fill(0);
  textSize(24);
  text("Binary Jewelry Designer", 625, 20);

  // message info
  textSize(16);
  text("Messasge:", 625, 80);
  textSize(14);

  // msg bits versus open
  text("bits in text:", 475, 220);
  text(msgBits.size(), 475, 240);
  text("beads open:", 775, 220);
  if (bg.numBeadsOpen == msgBits.size()) {
    fill(0, 0, 0);
  } else {
    fill(highlight);
  }
  text(bg.numBeadsOpen, 775, 240);

  //dimensions and total
  fill(0);
  float widthmm = beadSizeChart[beadSizeChartIndex][1] * bg.cols;
  float heightmm = beadSizeChart[beadSizeChartIndex][2] * bg.rows;
  text(bg.cols + " by " + bg.rows + " for a total of " + bg.beads.size() + " beads", 625, 390);
  text("aprox. " + widthmm + "mm by " + heightmm + "mm.", 625, 410);
}

/******************************************************************************
 *
 * display ui button eleemnts
 * 
 *****************************************************************************/
void displayButtons() {

  /***** delete a row *****/
  if (buttonDelRow.on) {
    buttonDelRow.reset();
    bg.delBeadRow();
    infoBar.update("removed a row of beads");
  }
  buttonDelRow.displayMinus();

  /***** add a row *****/
  if (buttonAddRow.on) {
    buttonAddRow.reset();
    bg.addBeadRow();
    infoBar.update("added a row of beads");
  }
  buttonAddRow.displayPlus();

  /***** delete column *****/
  if (buttonDelCol.on) {
    buttonDelCol.reset();
    bg.delBeadColumn();
    infoBar.update("removed a column of beads");
  }
  buttonDelCol.displayMinus();

  /***** add column *****/
  if (buttonAddCol.on) {
    buttonAddCol.reset();
    bg.addBeadColumn();
    infoBar.update("added a column of beads");
  }
  buttonAddCol.displayPlus();

  /***** decrement vertical cap *****/
  if (buttonDelVert.on) {
    buttonDelVert.reset();
    bg.verticalCap--;
    if (bg.verticalCap < 0) bg.verticalCap = 0;
    bg.selectSpreadDisplay();
    infoBar.update("decreased vertical margin to: " + bg.verticalCap);
  }
  buttonDelVert.displayMinus();

  /***** increment vertical cap *****/
  if (buttonAddVert.on) {
    buttonAddVert.reset();
    bg.verticalCap++;
    bg.selectSpreadDisplay();
    infoBar.update("increased vertical margin to: " + bg.verticalCap);
  }
  buttonAddVert.displayPlus();

  /***** decrement horizontal cap *****/
  if (buttonDelHor.on) {
    buttonDelHor.reset();
    bg.horizontalCap--;
    if (bg.horizontalCap < 0) bg.horizontalCap = 0;
    bg.selectSpreadDisplay();
    infoBar.update("decreased horizontal margin to: " + bg.horizontalCap);
  }
  buttonDelHor.displayMinus();

  /***** increment horizontal cap *****/
  if (buttonAddHor.on) {
    buttonAddHor.reset();
    bg.horizontalCap++;
    bg.selectSpreadDisplay();
    infoBar.update("increased horizontal margin to: " + bg.horizontalCap);
  }
  buttonAddHor.displayPlus();

  /***** decrement number of solid rows *****/
  if (buttonDelSolid.on) {
    buttonDelSolid.reset();
    bg.solidSpan--;
    if (bg.solidSpan < 0) bg.solidSpan = 0;
    bg.selectSpreadDisplay();
    infoBar.update("decreased solid span to: " + bg.solidSpan);
  }
  buttonDelSolid.displayMinus();

  /***** increment number of solid rows *****/
  if (buttonAddSolid.on) {
    buttonAddSolid.reset();
    bg.solidSpan++;
    bg.selectSpreadDisplay();
    infoBar.update("increased solid span to: " + bg.solidSpan);
  }
  buttonAddSolid.displayPlus();

  /***** decrement spread gap *****/
  if (buttonDelGap.on) {
    buttonDelGap.reset();
    bg.spreadGap--;
    if (bg.spreadGap < 0) bg.spreadGap = 0;
    bg.selectSpreadDisplay();
    infoBar.update("Decreased spread gap to: " + bg.spreadGap);
  }
  buttonDelGap.displayMinus();

  /***** increment spread gap *****/
  if (buttonAddGap.on) {
    buttonAddGap.reset();
    bg.spreadGap++;
    bg.selectSpreadDisplay();
    infoBar.update("increased spread gap to: " + bg.spreadGap);
  }
  buttonAddGap.displayPlus();

  /***** decrement spread style *****/
  if (buttonDelStyle.on) {
    buttonDelStyle.reset();
    bg.spreadType--;
    if (bg.spreadType < 0) bg.spreadType = bg.spreadStyleMax;
    bg.selectSpreadDisplay();
    infoBar.update("spread style set to: " + bg.spreadStyleText);
  }
  buttonDelStyle.displayMinus();

  /***** increment spread style *****/
  if (buttonAddStyle.on) {
    buttonAddStyle.reset();
    bg.spreadType++;
    if (bg.spreadType > bg.spreadStyleMax) bg.spreadType = 0;
    bg.selectSpreadDisplay();
    infoBar.update("spread style set to: " + bg.spreadStyleText);
  }
  buttonAddStyle.displayPlus();

  /***** increment bead size *****/

  if (buttonDelSize.on) {
    buttonDelSize.reset();
    beadSizeChartIndex--;
    if (beadSizeChartIndex < 0) beadSizeChartIndex = beadSizeChart.length - 1;
    infoBar.update("bead size set to delica: " + int(beadSizeChart[beadSizeChartIndex][0]) + "/0");
  }
  buttonDelSize.displayMinus();

  /***** increment bead size *****/
  if (buttonAddSize.on) {
    buttonAddSize.reset();
    beadSizeChartIndex++;
    if (beadSizeChartIndex > beadSizeChart.length - 1) beadSizeChartIndex = 0;
    infoBar.update("bead size set to delica: " + int(beadSizeChart[beadSizeChartIndex][0]) + "/0");
  }
  buttonAddSize.displayPlus();
  
  /***** button showing number of beads with value of 0 *****/
  buttonBit0.btnName = String.valueOf(bg.numBeads0);
  if (buttonBit0.active()) buttonBit0.btnName = "0";
  buttonBit0.displayDisc(bg.beads.get(0).color0);
  
  /***** buttons show number of beads with value of 1 *****/
  buttonBit1.btnName = String.valueOf(bg.numBeads1);
  if (buttonBit1.active()) buttonBit1.btnName = "1";
  buttonBit1.displayDisc(bg.beads.get(0).color1);
  
  /***** buttons show number of beads with value of 2 or not part of message *****/
  buttonBit2.btnName = String.valueOf(bg.numBeads2);
  buttonBit2.displayDisc(bg.beads.get(0).colorPrimary);

  // on hover of buttons update simple setting feedback
  fill(0);
  if (buttonDelRow.active() || buttonAddRow.active()) text("there are " + bg.rows + " rows currently", 625, 675);
  if (buttonDelCol.active() || buttonAddCol.active()) text("there are " + bg.cols + " columns currently", 625, 675);
  if (buttonDelSolid.active() || buttonAddSolid.active()) text("there are " + bg.solidSpan + " solid rows from center", 625, 675);
  if (buttonDelStyle.active() || buttonAddStyle.active()) text("the current spread style is " + bg.spreadStyleText, 625, 675);

  if (buttonDelVert.active() || buttonAddVert.active()) text("there are " + bg.verticalCap + " rows of vertical margin", 625, 675);
  if (buttonDelHor.active() || buttonAddHor.active()) text("there are " + bg.horizontalCap + " columns of horizontal margin", 625, 675);
  if (buttonDelGap.active() || buttonAddGap.active()) text("the gap jump is currently set to " + bg.spreadGap, 625, 675);
  if (buttonDelSize.active() || buttonAddSize.active()) text("there current bead size is " + int(beadSizeChart[beadSizeChartIndex][0]) + "/0", 625, 675);

  /***** guide button *****/
  if (buttonGuide.on) {
    buttonGuide.reset();
    beadGuide = !beadGuide;
    if (beadGuide) {
      infoBar.update("bead guide on");
    } else {
      infoBar.update("bead guide off");
    }
  }
  buttonGuide.display();

  /***** load button *****/
  if (buttonLoad.on) {
    buttonLoad.reset();
    infoBar.update("loading...");
    delay(100);
    selectInput("select a file to process:", "fileSelected");
  }
  buttonLoad.display();

  /***** save button *****/
  if (buttonSave.on) {
    buttonSave.reset();
    saveOpenArray(); // update timer in method call
  }
  buttonSave.display();

  /***** button text info *****/
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(14);
  text("rows", buttonRow[0], buttonRow[1]);
  text("columns", buttonCol[0], buttonCol[1]);
  text("vertical margin", buttonVert[0], buttonVert[1]);
  text("horizontal margin", buttonHor[0], buttonHor[1]);
  text("solid span", buttonSolid[0], buttonSolid[1]);
  text("gap", buttonGap[0], buttonGap[1]);
  text("spread style", buttonStyle[0], buttonStyle[1]);
  text("bead size", buttonSize[0], buttonSize[1]);
}

/******************************************************************************
 * crate an array that helps match the position of two buttons to 
 * the left and right of corresponding text title.
 *
 * @param  _x  x position of center of text
 * @param  _y  y position of center of text
 * @return     array of with
 *             [0][1] position of text
 *             [2][3] position of left button
 *             [3][4] position of right button
 ******************************************************************************/
int[] buttonPairPositions(int _x, int _y) {
  return new int[] {_x, _y, _x - 75, _y, _x + 75, _y};
}

/******************************************************************************
 * A function that takes a string of text and creates an array list 
 * resulting from converting each character in the string into 
 * its 8-bit binary representation
 *
 * @param  _str      String to be converted
 * @return           ArrayList of integers
 ******************************************************************************/
ArrayList<Integer> StringToBinary_8bit(String _str) {
  ArrayList<Integer> strBinary = new ArrayList<Integer>();
  String str = _str;
  for (int i = 0; i < str.length(); i++) {
    String num = binary(str.charAt(i), 8);
    for (int j = 0; j < num.length(); j++) {
      strBinary.add(parseInt(num.substring(j, j + 1)));
    }
  }
  return strBinary;
}

/******************************************************************************
 * Interpolation function using the sine in easing function
 * by easing.net
 *
 * @param  a      first value
 * @param  b      second value
 * @param  t      amt between 0.0 and 1.0
 * @return        value between first and second value given t
 ******************************************************************************/
float serpIn(int a, int b, float t) {
  if (t <= 0) return a;
  if (t >= 1) return b;
  float in_t = 1 - cos((t * PI) / 2);
  return a + (b - a) * in_t;
}

/******************************************************************************
 * Interpolation function using the sine out easing function
 * by easing.net
 *
 * @param  a      first value
 * @param  b      second value
 * @param  t      amt between 0.0 and 1.0
 * @return        value between first and second value given t
 ******************************************************************************/
float serpOut(int a, int b, float t) {
  if (t <= 0) return a;
  if (t >= 1) return b;
  float out_t = sin((t * PI) / 2);
  return a + (b - a) * out_t;
}

/******************************************************************************
 * Interpolation function using the quad in easing function
 * by easing.net
 *
 * @param  a      first value
 * @param  b      second value
 * @param  t      amt between 0.0 and 1.0
 * @return        value between first and second value given t
 ******************************************************************************/
float qerpIn(int a, int b, float t) {
  if (t <= 0) return a;
  if (t >= 1) return b;
  float in_t = t * t;
  return a + (b - a) * in_t;
}

/******************************************************************************
 * Interpolation function using the quad out easing function
 * by easing.net
 *
 * @param  a      first value
 * @param  b      second value
 * @param  t      amt between 0.0 and 1.0
 * @return        value between first and second value given t
 ******************************************************************************/
float qerpOut(int a, int b, float t) {
  if (t <= 0) return a;
  if (t >= 1) return b;
  float in_t = 1 - (1 - t) * (1 - t);
  return a + (b - a) * in_t;
}

/******************************************************************************
 * Interpolation function using the exponential in easing function
 * by easing.net
 *
 * @param  a      first value
 * @param  b      second value
 * @param  t      amt between 0.0 and 1.0
 * @return        value between first and second value given t
 ******************************************************************************/
float exerpIn(int a, int b, float t) {
  if (t <= 0) return a;
  if (t >= 1) return b;
  float in_t = pow(2, 10 * t - 10);
  return a + (b - a) * in_t;
}

/******************************************************************************
 * Interpolation function using the exponential out easing function
 * by easing.net
 *
 * @param  a      first value
 * @param  b      second value
 * @param  t      amt between 0.0 and 1.0
 * @return        value between first and second value given t
 ******************************************************************************/
float exerpOut(int a, int b, float t) {
  if (t <= 0) return a;
  if (t >= 1) return b;
  float out_t = 1 - pow(2, -10 * t);
  return a + (b - a) * out_t;
}
