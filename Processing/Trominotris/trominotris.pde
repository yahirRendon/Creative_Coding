/**************************************************************
 Project:  A minimal version of Tetris using trominos
 Author:   Yahir
 Date:     November 2021
 
 Notes:
 1. Use arrow keys to move and rotate tromino
 
 To Do:
 - create tromino land animation
 - create tromino row and trominotris clear animation
 - drop speed increment
 - add point system
 - set color pallete 
 - create irregular trominoes
 - add sounds and music
 
 **************************************************************/
ArrayList<Cell> cells;       // the cells that make up the play area
ArrayList<Block> blocks;     // list of all blocks in the play area
int gridWidth;               // the number of columns in play grid
int gridHeight;              // the number of rows in play grid (0-2 are loading zone)

int timeMarker;              // track time for tromino drop
int dropSpeed;               // speed at which trominos will drop

Tromino t = new Tromino();   // the current tromino player is controlling

/**************************************************************
 SET UP METHOD
 **************************************************************/
void setup() {
  size(800, 800);

  gridWidth = 7;
  gridHeight = 13;
  dropSpeed = 800;

  // create play area grid
  cells = new ArrayList<Cell>();
  for (int y = 0; y < gridHeight; y++) {
    for (int x = 0; x < gridWidth; x++) {
      cells.add(new Cell(x, y, 0));
    }
  }

  // #TESTING set a space in the grid to occupied to test move and rotations
  //grid.get(3 + 8 * gridWidth).state = 1;

  blocks = new ArrayList<Block>();  


  timeMarker = millis();
}

/**************************************************************
 DRAW METHOD
 **************************************************************/
void draw() {
  background(255);

  // drop current tromino at desired speed
  if (millis() > timeMarker + dropSpeed) {
    // continue moving block down if possible
    if (t.canMoveDown()) {
      t.moveDown();
    } else {
      // block cannot move down 
      // push tromino to block list and create new
      t.pushBlocks(blocks);
      t.createNew();

      // check if rows can be cleared
      checkRows();
    }
    timeMarker = millis();
  }

  for (int i = 0; i < cells.size(); i++) {
    cells.get(i).display();
  }
  for (int i = 0; i < blocks.size(); i++) {
    blocks.get(i).display();
  }

  t.display();
}

/**
 * method for clearing rows when torminos settle
 */
void checkRows() {  
  // loop through each row in the play area
  for (int y = 3; y < gridHeight; y++) {

    // sum the states of each cell in the row
    int rowSum = 0;
    for (int x = 0; x < gridWidth; x++) {
      rowSum += cells.get(x + y * gridWidth).state;
    }

    // if row sum is equal to grid width the 
    // row is full and can be cleared
    if (rowSum == gridWidth) {
      for (int x = 0; x < gridWidth; x++) {
        // change state of gride cells and remove blocks in row
        cells.get(x + y * gridWidth).state = 0; 
        for (int b = 0; b < blocks.size(); b++) {
          if (blocks.get(b).y == y) {
            blocks.remove(b);
          }
        }
      }  

      // loop through blocks to shift blocks down if above cleared row
      for (int b = 0; b < blocks.size(); b++) {
        if (blocks.get(b).y < y) {
          cells.get(blocks.get(b).x + blocks.get(b).y * gridWidth).state = 0; 
          blocks.get(b).y ++;
          blocks.get(b).updatePosition();
          cells.get(blocks.get(b).x + blocks.get(b).y * gridWidth).state = 1;
        }
      }

      // loop through all blocks and set state of corresponding grid cell
      for (int b = 0; b < blocks.size(); b++) {
        cells.get(blocks.get(b).x + blocks.get(b).y * gridWidth).state = 1;
      }
    }
  }
}

/**************************************************************
 KEY PRESSED
 
 - LEFT  : Move current tromino left
 - RIGHT : Move current tromino right
 - DOWN  : Move current tromino down
 - UP    : Rotate current tromino clockwise
 **************************************************************/
void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      t.moveLeft();
    }

    if (keyCode == RIGHT) {
      t.moveRight();
    }

    if (keyCode == DOWN) {
      t.moveDown();
    }

    if (keyCode == UP) {
      t.rotateShape();
    }
  }
}
