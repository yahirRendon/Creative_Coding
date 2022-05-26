/**************************************************************
 Project:  My interpretation of the classic Conway's Game of Life
           with an added heatmap feature that will reveal an image
           the longer a cell is alive. 
 
 Author:   Yahir
 Date:     January 2021
 
 Notes:
 - Run Sketch
 - Move mouse within window to reveal selectable cells
 - LEFT CLICK: select a cell to create start pattern
 - RIGHT CLICK : deselect a cell
 - SPACE KEY : toggle between evolving or static board
 - PRESS C KEY : to clear the board
 
 Photo by Anna Shvets from Pexels:
 https://www.pexels.com/photo/women-hugging-each-other-4557876/
 
 **************************************************************/
 
PImage img;                // image to be revealed

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
color dark;                // selected cell color             
color light;               // gird layout reveal color

/**************************************************************
 SET UP METHOD
 **************************************************************/
void setup() {
  size(950, 950, FX2D);
  // Set intials variable values
  cols = 13 + 19 + 13;
  rows = 13 + 19 + 13;
  cols = 21;
  rows = 21;
  cellSize = 50; 
  evolveCounter = 0;
  evolveSpeed = 60;
  lClicked = false;
  evolveBoard = false;
  
  img = loadImage("pexels-anna-shvets-4557876.jpg");
  
  // Set color palette
  dark = color(68, 49, 141);
  light = color(164, 179, 182);
  
  light = color(212, 208, 175);
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
  image(img, 0, 0);
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
  for(int y = 1; y < rows - 1; y++) {
    for(int x = 1; x < cols - 1; x++) {
      // hold assigned x and y center of board spaces
      // hold the state of the board piece
      float xx = 0;
      float yy = 0;
      float state = 0;

      // create normal board grid
      xx = (board[x][y].x * 50) - (25 + 0);
      yy = (board[x][y].y * 50) - (25 + 0);
      
      // update value of board space if selected
      // mouse pos is within range of board space and clicked
      float d = dist(mouseX, mouseY, xx, yy);
      if(d < 25) {
        if(lClicked) {
          board[x][y].z = 1;
        } 
        else if(rClicked) {
           board[x][y].z = 0; 
        }
      }
      
      // heatmap image reveal
      float m2 = map(boardData[x][y].x, 0, 3000, 255, 0);
      fill(235, 237, 239, m2);
      rect(xx - cellSize/2, yy - cellSize/2, cellSize, cellSize);
      
      // store state of board space
      state = board[x][y].z;
      
      // visually display state of board space
      // dead or not selected
      if(state == 1) {
        
        // display selected or alive cells
        fill(dark);
        stroke(255);
        rect(xx - cellSize/2, yy - cellSize/2, cellSize, cellSize);
        noStroke();
        
        // increment heatmap for alive cells
        if(evolveBoard) {
          boardData[x][y].x++;
          // Set heatmap limit
          if(boardData[x][y].x > 3000) {
            boardData[x][y].x = 3000;
          }
        }
      }
      
      // create a simple guide for revealing grid
      rectMode(CENTER);
      if(d < 150 && !evolveBoard && state == 0) {
        float dm = map(d, 0, 150, cellSize, 0);        
        fill(light);
        rect(xx, yy, dm, dm);
      }
      rectMode(CORNER);
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
  
  if(key == '-') {
    for(int y = 0; y < rows; y++) {
      for(int x = 0; x < cols; x++) {
        board[x][y] = new PVector(x, y, 0);
      }
    }
  }
}

 /**
 * function for evolving the board to the next state 
 * based on present state
 */
void evolve() {
  // just some clean up... need to fix this
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      if(x == 0 || y == 0) {
       board[x][y].z = 0; 
      }
    }
  }
  // loop through every spot in 2D array and check neighbors states
  for (int x = 1; x < cols - 1; x++) {
    for (int y = 1; y < rows - 1; y++) {
      
      
      
      // loop to add up the surrounding cell states
      int neighbors = 0;
      for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
          neighbors += board[x+i][y+j].z;
        }
      }

      // remove current cell state (counted above loop)
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
      // homeostasis
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
