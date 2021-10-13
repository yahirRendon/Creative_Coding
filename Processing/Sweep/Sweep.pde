/**************************************************************
 Project:  Proof of concept for a minesweeper clone that has
           the core mechanics in a laid back minal style
 Author:   Yahir
 Date:     October 2021
 
 Notes:
 1. Run Sketch
 2. Left click on cell to reveal
 3. Right click on cell to place flag
 4. Left click on dark button to reset flags
 5. Left click on red button to reset grid
 
 by default there are 6 mines within the 6 x 6 grid
 
 **************************************************************/
 
Button flags;              // button to reset flags
Button reset;              // button to reset grid
PFont font;                // adjust font

ArrayList<Cell> cells;     // cell grid
ArrayList<PVector> mines;  // mine location x, y, index

boolean gameWon;           // track if grid was cleared
boolean gameLost;          // track if mine was tripped
int totalMines;            // total number of mines
int flagsPlaced;           // number of flags placed
int winStreak;             // number of games won in a row

// set color palette
color base;
color mine;
color closed;
color opened;
color flagged;
color dark;

/**************************************************************
 SET UP METHOD
 **************************************************************/
void setup() {
  size(1600, 1600);
  smooth(8);
  
  // set font
  font = createFont("Roboto Light", 150);
  textFont(font);
  
  // set initial values
  base = color(244, 233, 227);
  mine = color(244, 210, 208);
  closed = color(201, 211, 223);
  opened = color(228, 233, 236);
  flagged = color(158, 174, 197);
  dark = color(121, 125, 161);
  
  cells = new ArrayList<Cell>();
  mines = new ArrayList<PVector>();
  
  totalMines = 6;
  flagsPlaced = 0;
  winStreak = 0;
  gameWon = false;
  gameLost = false;
  
  flags = new Button(320, 200, 0);
  reset = new Button(1600 - 400, 200, 1);
   
  resetGrid();
}

/**************************************************************
 DRAW METHOD
 **************************************************************/
void draw() {
  background(base);
  
  // display the game grid
  for(int i = 0; i < cells.size(); i++) {
    cells.get(i).display(); 
  }
  
  // game title and info
  textAlign(CENTER, CENTER);
  fill(dark);
  textSize(150);
  text("sweep", width/2, 200);
  textSize(32);
  text("by Yahir", width/2, 1440);
  
  
  // display the buttons
  flags.display();
  reset.display();
  textSize(32);
  fill(255);
  text(totalMines - flagsPlaced, 360, 240);  
  text(winStreak, 1600 - 360, 240);
}

/**************************************************************
 MOUSEPRESSED PRESSED
 
 - LEFT & RIGHT CLICK
 **************************************************************/
void mouseClicked() {
  if(mouseButton == LEFT) {
    cellSelected();
    if(!gameWon) {
      checkGameWon();
    }
    if(reset.active()) {
     resetGrid(); 
    }
    
    if(flags.active()) {
      resetFlags();   
    }
  }
  if(mouseButton == RIGHT) {
   checkFlag(); 
  }
}

/**
 * Reset the flags placed
 */
void resetFlags() {
  flagsPlaced = 0;
  for(int i = 0; i < cells.size(); i++) {
    if(cells.get(i).getFlag()) {
      cells.get(i).setFlag();
    }
  }
}

/**
 * Reset/Create the grid, place mines, and calcuate neighboring mines
 */
void resetGrid() {
  if(cells.size() > 0) {
    cells.clear();
    mines.clear();
  }
  gameWon = false;
  gameLost = false;
  flagsPlaced = 0;
  // generate mines within grid
  while(mines.size() < 6) {
    int tempRand = int(random(0, 36));
    if(mines.size() == 0) {
      mines.add(new PVector(0, 0, tempRand));
    } else {
      boolean newCellPosition = true;
      for(int i = 0; i < mines.size(); i++) {
        if(tempRand == int(mines.get(i).z)) {
          newCellPosition = false;
        }
      }
      if(newCellPosition) {
        mines.add(new PVector(0, 0, tempRand));
      }
    }
  }
  
  // create cell board
  for(int y = 0; y < 6; y++) {
    for(int x = 0; x < 6; x++) {
      int index = x + y * 6;
      cells.add(new Cell(x, y));
      for(int i = 0; i < mines.size(); i++) {
        if(index == int(mines.get(i).z)) {
          cells.get(index).setType(-1);
        }
      }
    }
  }
  
  // check cell neighbors
  for(int y = 0; y < 6; y++) {
    for(int x = 0; x < 6; x++) {
      int index = x + y * 6;
      int numMines = 0;
      for(int yy = -1; yy < 2; yy++) {
        for(int xx = -1; xx < 2; xx++) {       
          if(xx + x > -1 && xx + x < 6 && yy + y > -1 && yy + y < 6){
            int inIndex = (x + xx) + (y + yy) * 6;
            if(inIndex != index && cells.get(inIndex).getType() == -1) {
              numMines ++;
            }
          }         
        }
      }
    cells.get(index).setNumMines(numMines);
    }
  }  
  
  // for #TESTING
  //println();
  //for(int i = 0; i < cells.size(); i++) {
  //  if(i % 6 == 0) {
  //    println();
  //  }
  //  if(cells.get(i).getType() == 0) {
  //    print(" O");
  //  } else {
  //    print(" X");
  //  }   
  //}
}

/**
 * Check whether to set flag
 */
void checkFlag() {
  for(int i = 0; i < cells.size(); i++) {
    if(cells.get(i).active() && cells.get(i).getState() != 0 && flagsPlaced < 6) {
      cells.get(i).setFlag();
      if(cells.get(i).getFlag()) {
        flagsPlaced++;     
      } else {
        flagsPlaced--;
      }     
    }
  }
}

/**
 * Check which cell has been selected and whether to open it
 * if the game has be won or lost
 */
void cellSelected() { 
  for(int i = 0; i < cells.size(); i++) {
    if(cells.get(i).active()) {
      if(!cells.get(i).getFlag()) {
        cells.get(i).setState(0); 
      }
      if(cells.get(i).getType() == -1 && !cells.get(i).getFlag()) {
        gameLost = true;
        winStreak = 0;
      }
      else if(cells.get(i).getNumMines() == 0 && !cells.get(i).getFlag()) {
        checkNeighbor(i);     
      }
  
    }
  } 
}

/**
 * Check which neighbors to reveal when clicking on a cell using recursion
 *
 * @param {int} _i   the index position of the cell (x + y * gridWidth)
 */
void checkNeighbor(int i) {
  int cellX = int(cells.get(i).cellX);
  int cellY = int(cells.get(i).cellY);
  for(int yy = -1; yy < 2; yy++) {
    for(int xx = -1; xx < 2; xx++) {    
      if(xx + cellX > -1 && xx + cellX < 6 && 
         yy + cellY > -1 && yy + cellY < 6){
        int inIndex = (cellX + xx) + (cellY + yy) * 6;     
        if(cells.get(inIndex).getState() == 1 && cells.get(inIndex).getType() == 0) {
          if(cells.get(inIndex).getNumMines() == 0) {
            if(!cells.get(inIndex).getFlag()) {
              cells.get(inIndex).setState(0);
              checkNeighbor(inIndex);
            }
          } else {
            cells.get(inIndex).setState(0);
          }
        }
      }    
    }
  }
}

/**
 * Check if the game has been won by counter the number of cells left
 */
void checkGameWon() {
  int num = 0;
  for(int i = 0; i < cells.size(); i++) {
    if(cells.get(i).getState() == 1) {
      num++;
    }
  }
  if(num == 6) {
    gameWon = true;
    winStreak++;
  }
}

/**************************************************************
 Class for creating a cell that will make up the game grid. 
 The cell will be:
 - open or closed
 - contain a mine or not
 - flagged or not flagged
 - inform of number of neighboring mines
 **************************************************************/
class Cell {
 int x, y;            // x and y index position (row/col)
 int cellX, cellY;    // x and y position in window
 int cellSize;        // the size of the cell
 int cellType;        // empty or mine (0 | -1)
 int cellState;       // open or closed (1 | 0)
 int numMines;        // the number of neighboring mines
 boolean flag;        // cell flagged
 
 int delayCounter;
 int delayAmount;
 float dCol;
 
 /**
  * Constructor method for Cell class
  *
  * @param {int} _x    the x position of the Cell (index)
  * @param {int} _y    the y position of the Cell (index)
  */
 Cell(int _x, int _y) {
    cellX = _x;
    cellY = _y;
    cellSize = 160;
    x = 320 + (_x * cellSize);
    y = 400 + (_y * cellSize);
    cellType = 0;
    cellState = 1;
    numMines = 0;
    flag = false;
    
    delayCounter = 0;
    delayAmount = int(random(75, 100));
  }
  
  /**
   * Setter methods
   */
  void setType(int _t) {
    cellType = _t;
  }
  void setState(int _s) {
    cellState = _s;
  }
  void setNumMines(int _n) {
    numMines = _n;
  }
  void setFlag() {
    flag = !flag;
  }
    
  /**
   * Getter methods
   */
  int getType() {
    return cellType;
  }
  int getState() {
    return cellState;
  }
  int getNumMines() {
    return numMines;
  }
  boolean getFlag() {
    return flag;
  }
  
  /**
   * Display the Cell
   */
  void display() {  
    if(delayCounter < delayAmount) {
      // fade in animation
      float targetVal = delayAmount;
      float dx = targetVal - delayCounter;
      dCol += dx * 0.05;
      stroke(255, dCol);
      fill(red(closed), green(closed), blue(closed), dCol);
      delayCounter++;
    } else {
      fill(closed);
      stroke(255);
      if(cellState == 0) {
        fill(opened);
      } 
      if(flag) {
        fill(flagged);
      }
    }
    rect(x, y, cellSize, cellSize, 10);
    
    // display number of neighboring mines
    fill(dark);
    textSize(28);
    if(cellState == 0 && numMines > 0 ) {
    text(numMines, x + (cellSize/2), y + (cellSize/2) +  0);
    }
    
    // display mine
    if(cellType == -1) {
      if(gameLost) {
        fill(mine);
        ellipse(x + (cellSize/2), y + (cellSize/2), 60, 60);
      } else 
      if(gameWon) {
        fill(red(mine), green(mine), blue(mine), 100);
        ellipse(x + (cellSize/2), y + (cellSize/2), 60, 60);
      }
    }  
  }
   
  /**
   * check if mouse is over cell
   */
  boolean active() {
   if(mouseX > x && mouseX < x + cellSize &&
      mouseY > y && mouseY < y + cellSize) {
       return true;
     } else {
       return false;
     }
  }
}

/**************************************************************
 Class for creating a basic button
 **************************************************************/
class Button {
 int x, y;            // the x and y position of the Button
 color buttonColor;   // the color of the button
 
 /**
  * Constructor method for Button class
  *
  * @param {int} _x    the x position of Button (center)
  * @param {int} _y    the y position of Button (center)
  * @param {int} _t    the type of button (different color preset)
  */
  Button(int _x, int _y, int _t) {
    x = _x;
    y = _y;
    buttonColor = color(mine);
    if(_t == 0) {
      buttonColor = color(flagged);
    }
  }
  
  /**
   * Display the button
   */
  void display() {
    if(active()) {
      fill(240);
    } else {
      fill(buttonColor);
    }
    
    //ellipse(x, y, 80, 80);
    rect(x, y, 80, 80, 10);
  }
  
  /**
   * check if mouse is over button
   */
  boolean active() {
    if(dist(mouseX, mouseY, x, y) < 80) {
     return true; 
    } else {
      return false;
    }
  }
}
