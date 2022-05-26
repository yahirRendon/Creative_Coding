/**************************************************************
 Project:  A minimal version of Tetris using trominos
 Author:   Yahir
 Date:     November 2021
 
 Notes:
 1. SPACE KEY to start and pause game
 2. Use arrow keys to move and rotate tromino
 3. N KEY to start new game
 
 
Credits
Music theme: Benjamin Tissot of Bensound
  https://www.bensound.com/royalty-free-music/track/slow-motion
Clear Row Sound: LittleRobotSoundFactory
  https://freesound.org/people/LittleRobotSoundFactory/sounds/270524/
Trominotris Sound: Leszek_Szary
  https://freesound.org/people/Leszek_Szary/sounds/171671/
Reset Sound: colorsCrimsonTears
  https://freesound.org/people/colorsCrimsonTears/sounds/562292/
Block Land Sound: Yahir mixed in Ableton Live

Processing 3.5.4
 **************************************************************/
 
import processing.sound.*;

SoundFile soundTheme;        // the game theme song
SoundFile soundLand;         // the tromino land sound
SoundFile soundClear;        // basic row clear sound
SoundFile soundTrominotris;  // trominotris clear sound
SoundFile soundReset;        // restart game sound

PFont font;                  // set font for project
ArrayList<Cell> cells;       // the cells that make up the play area
ArrayList<Block> blocks;     // list of all blocks in the play area
int gridWidth;               // the number of columns in play grid
int gridHeight;              // the number of rows in play grid (0-2 are loading zone)

int timeMarker;              // track time for tromino drop
int dropSpeed;               // speed at which trominos will drop
int nextPiece;               // track the next tromino to be created
int dropDecrement;           // amount deducted from dropSpeed at each level

int score;                   // track user score
int level;                   // track user level (increments every 5 lines)
int totalLinesCleared;       // track total lines cleared by user
int linesCleared;            // track lines cleared per level
int priorLinesCleared;       // track lines for level advance
boolean gameOver;            // toggle game over
boolean clearAnimationActive;// track if row clearing animation is active
boolean clearAnimationDone;  // trigger when row clearing animation is done

int gameScreen;               // track the screen active intro, play, paus

Tromino t;                   // the current tromino player is controlling

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
  dropSpeed = 600;
  dropDecrement = 50;
  score = 0;
  level = 0;
  totalLinesCleared = 0;
  priorLinesCleared = 0;
  linesCleared = 0;
  gameOver = false;
  nextPiece = int(random(0, 2));
  clearAnimationActive = false;
  clearAnimationDone = false;
  gameScreen = 0;

  // create play area grid
  cells = new ArrayList<Cell>();
  for (int y = 0; y < gridHeight; y++) {
    for (int x = 0; x < gridWidth; x++) {
      cells.add(new Cell(x, y, 0));
    }
  }

  // initialize block area
  blocks = new ArrayList<Block>(); 
  t = new Tromino();
  
  // Initialize Sound elements
  soundReset = new SoundFile(this, "562292__colorscrimsontears__heal-rpg.mp3");
  soundReset.amp(0.3);
  soundLand = new SoundFile(this, "deep_kick.mp3");
  soundClear = new SoundFile(this, "270524__littlerobotsoundfactory__jingle-achievement-00.mp3");
  soundClear.amp(0.5);
  soundTrominotris = new SoundFile(this, "171671__leszek-szary__success-1.mp3");
  soundTrominotris.amp(0.25);
  soundTheme = new SoundFile(this, "bensound-slowmotion_loop-modified.mp3");
  soundTheme.amp(0.5);
  soundTheme.loop(); 

  // set timer
  timeMarker = millis();
}

/**************************************************************
 DRAW METHOD
 **************************************************************/
void draw() {
  background(245, 244, 240);
  
  switch(gameScreen) {
   case 0: // intro
   displayGameCore();
   fill(115, 138, 152);
   text("SPACE to start", 400, 400);
   break;
   case 1: // play
   displayGameCore();
   displayScoreElements();
   gameMechanics();
   break;
   case 2: // pause
   displayGameCore();
   displayGameTrominoes();
   fill(115, 138, 152);
   text("Game Paused", 400, 400);
   break;
  }  
}

/**************************************************************
 KEY PRESSED
 
 - LEFT  : Move current tromino left
 - RIGHT : Move current tromino right
 - DOWN  : Move current tromino down
 - UP    : Rotate current tromino clockwise
 - SPACE : toggle game screens
 - N KEY : restart game
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
  if(key == ' ') {
    gameScreen ++;
    if(gameScreen > 2) {
      gameScreen = 1;
    }
  }
  if(key == 'n' || key == 'N') {
    resetGame();
  }
}


/**
* the core gaming mechanics for trigger drops, score counters, 
* and clearing elements
*/
void gameMechanics() {
  // drop current tromino at desired speed
  // while game is not over
  if (!gameOver && !clearAnimationActive) {
    if(level > 7) {
      dropDecrement = 25;
    } 
    
    if (millis() > timeMarker + dropSpeed) {
      // continue moving block down if possible
      if (t.canMoveDown()) {
        t.moveDown();
      } else {
        if(soundLand.isPlaying()) {
          soundLand.stop();
        }
        soundLand.stop();
        soundLand.play();
        // block cannot move down 
        // push tromino to block list and create new
        t.startLandAnimation();
        t.pushBlocks(blocks);
        // check if rows can be cleared and create a tromino
        checkRows();      
        t.createNewTromino(nextPiece);        
        if(level > 0) {
          int rand = int(random(0, 2));
          if(rand == 0) {
            nextPiece = int(random(0, 4));
          } else {
            nextPiece = int(random(0, 2));
          }
        }
      }
      

      // reset timer
      timeMarker = millis();
    }
  }

  // perform clear animation
  if (clearAnimationActive) {
    for (int b = 0; b < blocks.size(); b++) {
      if (blocks.get(b).doneClear) {
        clearAnimationDone = true;
      }
    }

    // reset on completion
    if (clearAnimationDone) {
      clearFullRows();
      clearAnimationActive = false;
      clearAnimationDone = false;
    }
  }
 
  // display next piece on the side
  displayNextPiece();
  displayGameTrominoes();  
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
    fill(157, 193, 209);
    rect(62, 350, 50, 50, 5);
    rect(62, 400, 50, 50, 5);
    rect(112, 400, 50, 50, 5);
    break;
  case 2:
    fill(61, 98, 124);
    rect(112, 350, 50, 50, 5);
    rect(62, 400, 50, 50, 5);
    rect(62, 450, 50, 50, 5);
    break;
  case 3:
    fill(232, 139, 106);
    rect(37, 425, 50, 50, 5);
    rect(87, 375, 50, 50, 5);
    rect(137, 425, 50, 50, 5);
    break;
  default:
    fill(246, 210, 174);
    rect(87, 350, 50, 50, 5);
    rect(87, 400, 50, 50, 5);
    rect(87, 450, 50, 50, 5);
    break;
  }
}

/**
 * method for checking which rows can be cleared
 * and update score and game info
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
        //cells.get(x + y * gridWidth).state = 0; 
        for (int b = 0; b < blocks.size(); b++) {
          if (blocks.get(b).y == y) {
            blocks.get(b).startClear = true;
            clearAnimationActive = true;
            //blocks.remove(b);
          }
        }
      }
    }
  }

  // check if block has settled in loading zone
  for (int x = 0; x < gridWidth; x++) {
    if (cells.get(x + 2 * gridWidth).state == 1) {
      gameOver = true;
    }
  }

  // increment level per desired lines cleared
  if (linesCleared >= priorLinesCleared + 5) {
    level++;    
    linesCleared = priorLinesCleared;
    dropSpeed -= dropDecrement;
    if(dropSpeed < 150) {
      dropSpeed = 150;
    }
  }

  // increment score with bonuse depending on level
  float levelBonus = map(level, 0, 10, 1, 5.0);
  if (templinesCleared == 3) {
    score += int(100 * levelBonus);
    if(soundTrominotris.isPlaying()) {
      soundTrominotris.stop();
    }
    soundTrominotris.stop();
    soundTrominotris.play();
    if(soundClear.isPlaying()) {
      soundClear.stop();
    }
    soundClear.stop();
    soundClear.play();
  } else if (templinesCleared == 2) {
    score += int(50 * levelBonus);
    if(soundClear.isPlaying()) {
      soundClear.stop();
    }
    soundClear.stop();
    soundClear.play();
  } else if (templinesCleared == 1) {
    score += int(25 * levelBonus);
    if(soundClear.isPlaying()) {
      soundClear.stop();
    }
    soundClear.stop();
    soundClear.play();
  }
}

/**
 * remove rows that can be cleared and update
 * game grid status
 */
void clearFullRows() {  
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

      //loop through blocks to shift blocks down if above cleared row
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

/**
* Display the trominoes and blocks played
*/
void displayGameTrominoes() {
   // display blocks active in grid area
  for (int i = 0; i < blocks.size(); i++) {
    blocks.get(i).display();
  }

  // display current tromino controlled by player
  t.display();
}

/**
 * Display core game elements: grid and title
 */
void displayGameCore() {
  // game area rect
  fill(208, 210, 205, 100);
  stroke(115, 138, 152);
  rect(225, 100, 350, 650, 5);

  textAlign(CENTER, CENTER);
  textSize(48);
  fill(115, 138, 152);
  text("trominotris", width/2, 50);
  
  textSize(14);
  text("by yahir", width/2, height - 25);
    
}

/**
* Display the score, lines cleared, and level
*/
void displayScoreElements() {
  textSize(26);
  fill(115, 138, 152);
  text(score, 688, 400);

  textSize(18);
  fill(169, 176, 182);
  text(level, 688, 350);
  text(totalLinesCleared, 688, 450);
}

/**
* reset the game board and pieces
*/
void resetGame() {
  // rest variables
  dropSpeed = 700;
  dropDecrement = 50;
  score = 0;
  level = 0;
  totalLinesCleared = 0;
  priorLinesCleared = 0;
  linesCleared = 0;
  gameOver = false;
  nextPiece = int(random(0, 2));
  clearAnimationActive = false;
  clearAnimationDone = false;
  gameScreen = 1;

  // create play area grid
  cells = new ArrayList<Cell>();
  for (int y = 0; y < gridHeight; y++) {
    for (int x = 0; x < gridWidth; x++) {
      cells.add(new Cell(x, y, 0));
    }
  }

  // initialize block area
  blocks = new ArrayList<Block>(); 
  t = new Tromino();
  
  if(soundReset.isPlaying()) {
    soundReset.stop();
  }
  soundReset.stop();
  soundReset.play();
  if(soundClear.isPlaying()) {
    soundClear.stop();
  }
  soundClear.stop();
  soundClear.play();
  
  timeMarker = millis();
}
