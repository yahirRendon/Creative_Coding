/******************************************************************************
 Project:  Simple game in which you try to find a hidden target by clicking.
 The amount of clicks reduces with each round until you are unable
 to find Mia. 
 
 Author:   Yahir
 Date:     November 2019
 
 Notes:    processing 3.5.4^ 
 
 Instructions:
 - Follow instructions and left click
 
 ******************************************************************************/

PFont myFont;                 //Assign custom font
PImage sqrlImage;             //For squirrel target image
PImage backgroundImage;       //For background image

Dot guess;                    //Create Dot object called guess
ArrayList<Dot> guesses;       //Track array list of guesses
ArrayList<Integer> sumList;   //List of all guess dist per game
int sum;                      //total of sumList array list for finding average

int backgroundImageX;         //The X position of the backgroundImage start
int targetX, targetY;         //The x and y values of target
int menuX, menuY;             //The x and y values of menu rect
int menuYSpeed;               //The speed of show/hide of menu
int menuMinHeight;            //The height of the menu when collapsed

int numGuessesDisplay;        //The max number of guess dots to display
int roundCount;               //Track the rounds of the game
int guessCount;               //Track the number of guesses made
int endGuessMax;              //The initial max number of guess allowed per round
int endGuessMaxReset;         //Used to reset the initial guess max allowed on restart game
int endGuessMin;              //The min number of max allowed guesses

int scoreAvg;                 //Track the overall average distance guesses are from target
int roundScoreAvg;            //Track the individual round average distance 
int targetDiam;               //The diameter of the target area

boolean found;                //Determine if the target was found
boolean updateScoreAvg;       //Determine if scoreAverage should be updated
boolean gameOver;             //Determine if player has lost
boolean gameStart;            //Determine if game has begun
boolean introScreen;          //start up screen
boolean howToScreen;          //If necessary in the future
boolean roundScreen;          //Determine if Round Complete screen shows
boolean gameOverScreen;       //Determine if Game Over Screen shows
String foundText;             //Set text for found phrase
int randPhrase;               //Random number selector for selecting found phrase
boolean pickPhrase;           //Only pick 1 random number per round

/******************************************************************************
 * 
 * setup method
 * 
 *****************************************************************************/
void setup() {
  //Global Setup
  size(800, 800);
  //pixelDensity(2);
  backgroundImage = loadImage("grn_mtn_hd.png");
  sqrlImage = loadImage("sqrl.png");
  myFont = createFont("Ariel", 12);
  textFont(myFont);
  textAlign(CENTER, CENTER);

  //Game Setup
  guesses = new ArrayList<Dot>();
  sumList = new ArrayList<Integer>();
  menuX = width;
  menuY = height;
  menuMinHeight = 80;
  menuYSpeed = 20;
  roundCount = 1;
  endGuessMax = 20;
  endGuessMin = 7;
  targetX = int(random(width - (width - 20), width - 40));
  targetY = int(random(menuMinHeight + (targetDiam / 2), height - 130));
  endGuessMaxReset = endGuessMax;
  numGuessesDisplay = 4;
  targetDiam = 50;
  gameStart = false;
  introScreen = true;
}

/******************************************************************************
 * 
 * setup method
 * 
 *****************************************************************************/
void draw() {
  background(202, 235, 242);
  image(backgroundImage, -140, 0);
  noStroke();

  //#Game Testing
  //ellipse(targetX, targetY, 60, 60); //Show target for testing purpose
  //rect((width - (width - 20)), (menuMinHeight + (targetDiam / 2)), (width - 40), (width - 130)); //Test the active game area

  // when game start game logic
  if (gameStart)
  { 
    //Cycle through guesses and display
    for (int i = 0; i < guesses.size(); i++) { 
      guess = guesses.get(i);
      guess.show();

      //Check if target found
      if (guess.dist < targetDiam) { 
        found = true;
        roundScreen = true;
        gameStart = false;
      }
    }
    //Remove oldest guess
    if (guesses.size() > numGuessesDisplay) { 
      guesses.remove(0);
    }
    //Check if player lost 
    if (guessCount == endGuessMax && !roundScreen) { 
      gameOverScreen = true;
      gameStart = false;
    }
    // Update average screen on click
    if (updateScoreAvg) { 
      calcAverage(guess.dist);
      updateScoreAvg = false;
    }
  }

  //Display Necessary Screens
  if (introScreen) 
  { 
    showIntroScreen();
  } else if (roundScreen) 
  { 
    //Cycle through guesses and display
    for (int i = 0; i < guesses.size(); i++) {
      guess = guesses.get(i);
      guess.show();
    }
    showRoundScreen();
  } else if (gameOverScreen) 
  {
    showGameOverScreen();
  } else 
  {    
    showStatBar();
  }
}



/******************************************************************************
 * 
 * display the intro screen
 * 
 *****************************************************************************/
void showIntroScreen() {
  //Expand Menu
  if (menuY < height) {
    menuY = menuY + menuYSpeed;
  }
  // menu back splash
  fill(106, 171, 186, 200);
  rect(0, 0, menuX, menuY);

  // title text
  textSize(80);
  fill(50);
  text("Find Mia", width/2, menuY - 670 ); 
  // sub text
  textSize(18);
  text("by Yahir", width/2, menuY - 600); 
  // main text 1 and 2
  textSize(26);
  text("Find Mia, the squirrel, by clicking", width/2, menuY - 500);
  text("and checking your distance to her hideout", width/2, menuY - 440);
  // action text
  textSize(26);
  text("Click to Begin", width/2, menuY - 100);

  image(sqrlImage, width/2 - 100, height - 360, 200, 200);
}

/******************************************************************************
 * 
 * display round complete screen
 * 
 *****************************************************************************/
void showRoundScreen() {
  //Expand Menu
  if (menuY < height) {
    menuY = menuY + menuYSpeed;
  }

  //Randomly pick complete phrase
  if (pickPhrase) {
    randPhrase = int(random(0, 5));
    pickPhrase = false;
  } 
  switch (randPhrase) {
  case 0: 
    {
      foundText = "Nice Job!";
      break;
    }
  case 1: 
    {
      foundText = "Sweet!";
      break;
    }
  case 2: 
    {
      foundText = "Awesome!";
      break;
    }
  case 3: 
    {
      foundText = "Keep It Up!";
      break;
    }
  default: 
    {
      foundText = "Well Done!";
      break;
    }
  }

  // menu back splash and image
  fill(106, 171, 186, 200);
  rect(0, 0, menuX, menuY);
  image(sqrlImage, targetX - 50, targetY - 50, 100, 100); 
  // title text
  textSize(80);
  fill(50);
  text(foundText, width/2, menuY - 670 );
  // sub text
  textSize(18);
  text("You Found Mia!", width/2, menuY - 600);
  // main text 1 and 2
  textSize(26);
  text("Guesses: " + guessCount, width/2, menuY - 500); 
  text("Average Distance: " + scoreAvg, width/2, menuY - 440); 
  // action text
  textSize(26);
  text("Click for Round " + (roundCount + 1), width/2, menuY - 100);
}

/******************************************************************************
 * 
 * display game over screen
 * 
 *****************************************************************************/
void showGameOverScreen() {
  //Expand Menu
  if (menuY < height) {
    menuY = menuY + menuYSpeed;
  } 

  // menu back splash and image
  fill(106, 171, 186, 200); 
  rect(0, 0, menuX, menuY);
  image(sqrlImage, targetX - 50, targetY - 50, 100, 100); 
  // text title
  textSize(80);
  fill(50);
  text("Game Over", width/2, menuY - 670 );
  // sub text
  textSize(18);
  text("You Couldn't Find Mia!", width/2, menuY - 600);
  // main text 1 and 2
  textSize(26);
  text("Average Distance: " + scoreAvg, width/2, menuY - 500); 
  text("Rounds Completed: " + (roundCount - 1), width/2, menuY - 440); 
  // action text
  textSize(26);
  text("Click to Play Again", width/2, menuY - 100);
}

/****** GAME STAT BAR ******/
void showStatBar() { 
  // Collapse Menu
  if (menuY > menuMinHeight) {
    menuY = menuY - menuYSpeed;
  }

  // menu back splash
  fill(106, 171, 186, 200);
  rect(0, 0, menuX, menuY);
  // guess text
  fill(239);
  textSize(18);
  text("Remaining", 100, 14);
  //guess count text
  textSize(30);
  text(endGuessMax - guessCount, 100, 46); 
  // average title text
  textSize(18);
  text("Average", width/2, 14); 
  // score average
  textSize(30);
  text(scoreAvg, width/2, 46); 
  // round title text
  textSize(18);
  text("Round", width - 100, 14);
  // round text
  textSize(30); 
  text(roundCount, width - 100, 46);
}

/******************************************************************************
 * 
 * calculate average score
 * 
 * @param  mDist    the new distance to add to average calc
 *****************************************************************************/
void calcAverage(int mDist) {

  sumList.add(mDist);
  sum = 0;
  for (int i = 0; i < sumList.size(); i++) {
    sum += sumList.get(i);
  }
  scoreAvg = sum / sumList.size();
}

/******************************************************************************
 * 
 * track mouse clicked
 * 
 *****************************************************************************/
void mouseClicked() {
  if (gameStart && mouseY > menuMinHeight && menuY == menuMinHeight) {
    guesses.add(new Dot(mouseX, mouseY));
    guessCount++;
    pickPhrase = true;
    updateScoreAvg = true;
  } else if (introScreen) {
    introScreen = false;
    gameStart = true;
  } else if (roundScreen) {
    guesses.clear();
    found = false;
    roundScreen = false;
    roundCount++;
    guessCount = 0;
    targetX = int(random(width - (width - 20), width - 40));
    targetY = int(random(menuMinHeight + (targetDiam / 2), height - 130));
    gameStart = true;
    if (endGuessMax > endGuessMin) {
      endGuessMax--;
    }
  } else if (gameOverScreen) {
    guesses.clear();
    sumList.clear();
    sum = 0;
    scoreAvg = 0;
    found = false;
    roundCount = 1;
    guessCount = 0;
    gameStart = true;
    gameOverScreen = false;
    endGuessMax = endGuessMaxReset;
  }
}

/******************************************************************************
 *
 * class for creating use feedback on display
 *
 *****************************************************************************/
class Dot {
  float x;                // x position
  float y;                // y position
  int c, cSpeed, cSpeed2; // color and speed
  int dist;               // track distance
  color guessColor;       // color for dot
  int dotDiam;            // dot size/diam

  /******************************************************************************
   * constructor
   * 
   * @param  tempX         the x position of the dot
   * @param  tempY         the y position of the dot
   *****************************************************************************/
  Dot(float tempX, float tempY) {
    x = tempX;
    y = tempY;
    c = 100;
    dotDiam = 70;
    dist = int(dist(x, y, targetX, targetY));
    cSpeed = int(map(dist, 0, width, 20, 1));
  }

  /******************************************************************************
   * 
   * show/display the button
   * 
   *****************************************************************************/
  void show() {   
    c = c + cSpeed;
    if (c < 50 - cSpeed || c > 220 - cSpeed) {
      cSpeed *= -1;
    }

    noStroke();
    fill(255);
    ellipse(x, y, dotDiam, dotDiam);

    //fill(255, 59, 63, c); //red
    fill(130, 116, 194, c);
    ellipse(x, y, dotDiam, dotDiam);

    fill(106, 171, 186);
    ellipse(x, y, dotDiam - 16, dotDiam - 16); 

    fill(239);
    textSize(14);
    text(int(dist), x, y);
  }
}

