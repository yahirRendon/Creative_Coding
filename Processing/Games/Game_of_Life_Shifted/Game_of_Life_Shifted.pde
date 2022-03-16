/**************************************************************
 Project:  My interpretation of the classic Conway's Game of Life
           Added a heatmap feature that will get brighter the longer
           a cell remains alive. 
 
 Author:   Yahir
 Date:     January 2021
 
 Notes:
 - Run Sketch
 - Move mouse within window to reveal selectable cells
 - LEFT CLICK: select a cell to create start pattern
 - RIGHT CLICK : deselect a cell
 - SPACE KEY : toggle between evolving or static board
 - PRESS C KEY : to clear the board
 
 
 **************************************************************/

PVector[][] board;         // 2D Array for holding board x & y position and space state
                           // [][].x = x pos, [][].y = y pos, [][].z = space state
PVector[][] nextBoard;     // 2D array generating future/next board state
PVector[][] boardData;     // 2D array holding heatmap value and potential other details
                           // [][].x = heatmap

int cols;                  // number of board/grid columns
int rows;                  // number of board/grid rows
int cellSize;              // size of individual cell size making up board
int evolveCounter;         // counter used for delay in evolving board
int evolveSpeed;           // the speed betwen evolutions 60 default
boolean lClicked;          // track left mouse clicked
boolean rClicked;          // track right mouse clicked
boolean evolveBoard;       // toggling if board is static or evolving 



// Color palette 
color dark;                 
color bright;
color light;

/**************************************************************
 SET UP METHOD
 **************************************************************/
void setup() {
  size(800, 800, FX2D);
  // Set intials variable values
  cols = 17;
  rows = 19;
  cellSize = 50; 
  evolveCounter = 0;
  evolveSpeed = 60;
  lClicked = false;
  evolveBoard = false;
  
  
  // set color palette
  light = color(212, 208, 175);
  bright = color(255, 0, 221);
  dark = color(144, 167, 196);
  
  // Initialize 2D array board, next board, and board data
  board = new PVector[cols][rows];
  nextBoard = new PVector[cols][rows];
  boardData = new PVector[cols][rows];

  // Populate 2D arrays
  for(int y = 0; y < rows; y++) {
    for(int x = 0; x < cols; x++) {
      board[x][y] = new PVector(x, y, 0);
      nextBoard[x][y] = new PVector(x, y, 0);
      boardData[x][y] = new PVector(0, 0, 0);
    }
  }  
}

/**************************************************************
 DRAW METHOD
 **************************************************************/
void draw() {
  background(235, 237, 239);
  noStroke();
  
  // check if board is evolving or is static
  // if evolving run evolve function set on evolveSpeed
  if(evolveBoard) { 
    evolveCounter++;
    if(evolveCounter > evolveSpeed) {
      evolve();  
      evolveCounter = 0;
    }
  }
  
  // loop through each space in board except edges
  for(int y = 1; y < rows -1; y++) {
    for(int x = 1; x < cols-1; x++) {
      // hold assigned x and y center of board spaces
      // hold that state of the board piece
      float xx = 0;
      float yy = 0;
      float state = 0;
      
      // create circle packed board with offsets
       if(y % 2 == 0) {
        xx = (board[x][y].x * 50) + 10;
        yy = (board[x][y].y * 45) + 0;

        } else {
          xx = (board[x][y].x * 50) - 15;
          yy = (board[x][y].y * 45) + 0;
        }
      
      // update value of board space if selected
      // mouse pos is within range of board space and clicked
      float d = dist(mouseX, mouseY, xx, yy);
      if(d < 25) {
        if(lClicked) {
          board[x][y].z = 1;
        } else if(rClicked) {
         board[x][y].z = 0; 
        }
      }
      
      // heatmap normal
      float mc = map(boardData[x][y].x, 0, 5000, 0, 255);
      fill(red(bright), green(bright), blue(bright), mc); // bright color
      ellipse(xx, yy, cellSize, cellSize);
      
      
      // store state of board space
      state = board[x][y].z;
      
      // visually display state of board space
      // dead or not selected
      if(state == 1) {
        
        // display selected or alive cells
        fill(dark);
        ellipse(xx, yy, cellSize, cellSize);
        
        
        // increment heatmap for alive cells
        if(evolveBoard) {
          boardData[x][y].x++;
          // Set heatmap limit
          if(boardData[x][y].x > 5000) {
            boardData[x][y].x = 5000;
          }
        }
      }
      
      // create a simple guide for revealing grid
      if(d < 150 && !evolveBoard && state == 0) {
        float dm = map(d, 0, 150, cellSize, 0);        
        fill(light);
        ellipse(xx, yy, dm, dm);
      }
    }
  }
  
  // reset mouseClick value
  lClicked = false;
  rClicked = false;
}

/**************************************************************
MOUSE CLICKED

- LEFT CLICK : select cells
- RIGHT CLICK: deselect cells
 **************************************************************/
void mouseClicked() {
  if(mouseButton == LEFT) {
    lClicked = true;
  }
  if(mouseButton == RIGHT) {
   rClicked = true; 
  }
}

/**************************************************************
 KEY PRESSED
 
 - SPACE : toggle between evolve board and static board
 - 'c' or 'C' : clear/reset the board
 **************************************************************/
void keyTyped() {
  // SPACE toggle between static and evolving board
  if(key == ' ') {
    evolveBoard = !evolveBoard;
    evolveCounter = 0;
  }
  
  // 'C' or 'c' clear the board 
  if(key == 'c' || key == 'C') {
    for(int y = 0; y < rows; y++) {
      for(int x = 0; x < cols; x++) {
        board[x][y] = new PVector(x, y, 0);
        boardData[x][y] = new PVector(0, 0, 0); 
      }
    }
  }

}

 /**
 * function for evolving the board to the next state 
 * based on present state
 */
void evolve() {

  // loop through every spot in our 2D array and check neighbors states
  for (int x = 1; x < cols - 1; x++) {
    for (int y = 1; y < rows - 1; y++) {
      // add up all the surrounding cell states
      int neighbors = 0;
      for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
          neighbors += board[x+i][y+j].z;
        }
      }

      // Remove current cell state (counted above loop)
      neighbors -= board[x][y].z;
      // rules of Life
      // loneliness
      if((board[x][y].z == 1) && (neighbors <  2)) {
        nextBoard[x][y].z = 0;     
      }
      // overpopulation
      else if((board[x][y].z == 1) && (neighbors >  3)) {
        nextBoard[x][y].z = 0;       
      }
      // reproduction
      else if((board[x][y].z == 0) && (neighbors == 3)) {
        nextBoard[x][y].z = 1;       
      }
      // stasis
      else {                                            
        nextBoard[x][y].z = board[x][y].z; 
      }
    }
  }

  // swap board to next/future board state
  PVector[][] temp = new PVector[cols][rows];
  temp = board;
  board = nextBoard;
  nextBoard = temp;
}
