/**************************************************************
 Project:  A minimal version of Tetris using trominos
 Author:   Yahir
 Date:     November 2021
 
 Notes:
 1. Use arrow keys to move and rotate tromino
 
 To Do:
 - create tromino land animation
 - create tromino row and trominotris clear animation
 x drop speed increment
 x add point system
 - set color pallete 
 - create irregular trominoes
 - add sounds and music
 
 **************************************************************/
PFont font;
ArrayList<Cell> cells;       // the cells that make up the play area
ArrayList<Block> blocks;     // list of all blocks in the play area
int gridWidth;               // the number of columns in play grid
int gridHeight;              // the number of rows in play grid (0-2 are loading zone)

int timeMarker;              // track time for tromino drop
int dropSpeed;               // speed at which trominos will drop
int nextPiece;               // track the next tromino to be created

int score;                   // track user score
int level;                   // track user level (increments every 5 lines)
int totalLinesCleared;       // track total lines cleared by user
int linesCleared;            // track lines cleared per level
int priorLinesCleared;       // track lines for level advance
boolean gameOver;            // toggle game over

Tromino t = new Tromino();   // the current tromino player is controlling

/**************************************************************
 SET UP METHOD
 **************************************************************/
void setup() {
  size(800, 800, FX2D);

  // set font
  font = createFont("Roboto Light", 150);
  textFont(font);
  
  // initialize variables
  gridWidth = 7;
  gridHeight = 16;
  dropSpeed = 800;
  score = 0;
  totalLinesCleared = 0;
  priorLinesCleared = 0;
  linesCleared = 0;
  gameOver = false;
  nextPiece = int(random(0, 2));

  // create play area grid
  cells = new ArrayList<Cell>();
  for (int y = 0; y < gridHeight; y++) {
    for (int x = 0; x < gridWidth; x++) {
      cells.add(new Cell(x, y, 0));
    }
  }
  
  // initialize block area
  blocks = new ArrayList<Block>(); 
  
  // set timer
  timeMarker = millis();
}

/**************************************************************
 DRAW METHOD
 **************************************************************/
void draw() {
  background(245, 244, 240);

  // drop current tromino at desired speed
  // while game is not over
  if (!gameOver) {
    if (millis() > timeMarker + dropSpeed) {
      // continue moving block down if possible
      if (t.canMoveDown()) {
        t.moveDown();
      } else {
        // block cannot move down 
        // push tromino to block list and create new
        t.pushBlocks(blocks);
        t.createNew(nextPiece);
        nextPiece = int(random(0, 2));

        // check if rows can be cleared
        checkRows();
      }
      
      // reset timer
      timeMarker = millis();
    }
  }
  
  // game area identifier
  fill(208, 210, 205, 100);
  stroke(115, 138, 152);
  rect(225, 100, 350, 650, 10);
  
  // disp;ay blocks active in grid area
  for (int i = 0; i < blocks.size(); i++) {
    blocks.get(i).display();
  }
  
  // display current tromino controlled by player
  t.display();
  
  // display next piece on the side
  displayNextPiece();
  
  // display game info (score, level, lines)
  displayInfo();
}

/**
* Display game information such as title, score, lines, levels
*/
void displayInfo() {
  
  textAlign(CENTER, CENTER);
  textSize(48);
  fill(115, 138, 152);
  text("trominotris", width/2, 50);

  textSize(26);
  fill(115, 138, 152);
  text(score, 688, 400);

  textSize(18);
  fill(169, 176, 182);
  text(level, 688 - 25, 450);
  text(totalLinesCleared, 688 + 25, 450);

  textSize(14);
  text("by yahir", width/2, height - 25);
}

/**
* display a visual representation of the next
* game piece to user
*/
void displayNextPiece() {
  stroke(169, 176, 182);
  stroke(115, 138, 152);
  switch(nextPiece) {
  case 1:
    fill(246, 210, 174);
    rect(62, 350, 50, 50, 10);
    rect(62, 400, 50, 50, 10);
    rect(112, 400, 50, 50, 10);
    break;
  default:
    fill(248, 232, 217);
    rect(87, 350, 50, 50, 10);
    rect(87, 400, 50, 50, 10);
    rect(87, 450, 50, 50, 10);
    break;
  }
}

/**
 * method for clearing rows when torminos settle
 */
void checkRows() {  
  int templinesCleared = 0;
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
      templinesCleared++;
      totalLinesCleared++;
      linesCleared++;
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

  for (int x = 0; x < gridWidth; x++) {
    if (cells.get(x + 2 * gridWidth).state == 1) {
      gameOver = true;
    }
  }

  // increment level per desired lines cleared
  if (linesCleared > priorLinesCleared + 5) {
    level++;    
    linesCleared = priorLinesCleared;
    dropSpeed -= 50;
  }

  float levelBonus = map(level, 0, 10, 1, 5.0);
  if (templinesCleared == 3) {
    score += int(100 * levelBonus);
  } else if (templinesCleared == 2) {
    score += int(50 * levelBonus);
  } else if (templinesCleared == 1) {
    score += int(25 * levelBonus);
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
