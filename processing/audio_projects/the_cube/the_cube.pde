/******************************************************************************
 Project:  Push and pull a singular vertex of a cube through
           various sounds scapes to create a unique audio
           experience.
              
 Author:  Yahir 
 Date:    January 2019

 Notes:
          - Processing 3.5.4
          
 Instructions:

 Background Photo by Dani Aláez on Unsplash
 https://unsplash.com/photos/Pimi_9akwIs

 Sound sample from:
 https://www.producerloops.com/Glitch-Samples-and-Glitch-Loops/
 Winter Glitch
                     
 ******************************************************************************/

import processing.sound.*;

Timer timer;

//Decalare audio object
SoundFile audio1, audio2, audio3, audio4, 
  audio5, audio6, audio7, audio8, 
  audio9, audio10, audio11, audio12, welcomeAudio; 
  
// Delcare amplitude object
Amplitude amp1, amp2, amp3, amp4, amp5, amp6, 
  amp7, amp8, amp9, amp10, amp11, amp12; 

// Track amplitude
float amplitude1, amplitude2, amplitude3, amplitude4, 
  amplitude5, amplitude6, amplitude7, amplitude8, 
  amplitude9, amplitude10, amplitude11, amplitude12; 
  
// Toggle individual mutes
boolean mute1, mute2, mute3, mute4, 
  mute5, mute6, mute7, mute8, 
  mute9, mute10, mute11, mute12; 

// Toggle inividual solos
boolean solo1, solo2, solo3, solo4, 
  solo5, solo6, solo7, solo8, 
  solo9, solo10, solo11, solo12; 

// Toggle mute groups
boolean muteGroup1, muteGroup2, muteGroup3;  

// Toggle show sound spaces
boolean showSoundSpace1, showSoundSpace2, showSoundSpace3, showSoundSpace4, 
  showSoundSpace5, showSoundSpace6, showSoundSpace7, showSoundSpace8, 
  showSoundSpace9, showSoundSpace10, showSoundSpace11, showSoundSpace12; 

PImage bckgrndImg;       // Create PImage object for background image

float mX;                // Store and track mouseX position
float mY;                // Store and track mouseY position
boolean inRange;         // Check if mouseX/mouseY is inRange of Cube center vertex
boolean showWire;        // Toggle wire frame view
boolean showPulse;       // Toggle pulse analyzer view

boolean activateCube;    // Track first time through program

float opacityL;          // Track Cube left side opacity
float opacityT;          // Track Cube right side opacity
float opacityR;          // Track Cube top opacity
float opacityWF;         // Track wire frame opacity
float opacityPulse;      // Track the pulse analyzer opacity

boolean shiftPressed;    // Track if shift key has been pressed
boolean ctrlPressed;     // Track if control key has been pressed
boolean leftPressed;     // Track if left key has been pressed
boolean upPressed;       // Track if up key has been pressed
boolean rightPressed;    // Track if right key has been pressed
boolean downPressed;

boolean displayAudioSettings; // Toggle audio playing/mute display
boolean timerEnd; // check if intro timer is done
boolean introFadeDone;  // check if cube fade in is done
boolean welcomeSoundDone; // Check if welcome sound is done
int audioTextStart;           // Start location of audio text display
int pulseColor;           // Track pulse analyzer color
int wireFrameColor;       // Track wire frame color

int numAudioTracks; // The number of audio tracks. Matches number of sound spaces
String[] audioList; // List of audio track names
int[] randomNumList; // List for randomizing audio track order

String tutorialText; // Inform user how to access tutorial mode
float opacityTutText; // Opacity for tutorial text
boolean goToTutorialMode; //Begin animation to go to tutorial mode
boolean goToUserMode; // Begin animation to go to user mode
boolean startTutorialMode; // Tutorial mode start (no user control beyond esc)
boolean startUserMode; // UserMode start (user in control)
int tutorialCounter;  // Track and move through tutorial steps

float opacityTutorialBkgrnd; // Opacity for the tutorial rect overlay
int xCubeToCenter;  // Checks were current mX is and determines how to return to center
int yCubeToCenter;  // Check were current mY is and determines how to return to center
boolean cubeCentered; // Checks if the Cube mX and mY is centered
boolean canMoveNext; // Checks if user can move to next step in tutorial

String userModeTitleText; // Title of the application

// tutorial text
String tutorialModeTitleText = "TUTORIAL MODE"; // When in tutorial mode display text
String tutorialText0 = "Welcome to The Cube tutorial.";
String tutorialText0A = "Press the RIGHT arrow key\nto move through each step.\n\nPress the 'r' key to reset and\nexit the tutorial mode.";
String tutorialText1 = "The Cube is an interactive\nauditory experience\nconsisting of overlapping\nsound spaces.";
String tutorialText2 = "Explore the sound spaces\nby clicking and dragging\nthe center vertex\nof The Cube.";
String tutorialText3 = "Pressing CTRL + 1\nreveals the epicenter\nand span of sound space 1.";
String tutorialText4 = "The Cube is made\nup of 12 distinct\n sound spaces.\n\nPressing CTRL + NUM KEY\nwill reveal the corresponding\nsound space.";
String tutorialText4A = "Use key '-' for sound\nspace 11 and\nkey '=' for sound\nspace 12.";
String tutorialText5 = "Pressing SPACE reveals the\naudio status of the individual\nsound spaces.";
String tutorialText6 = "Pressing a NUM KEY will mute\nthe individual sound space.\nIn this case KEY '4' mutes\nsound space 4.";
String tutorialText7 = "Pressing SHIFT + NUM KEY will\nsolo the individual sound space.\nIn this case SHIFT + '4' solos\nsound space 4.";
String tutorialText8 = "Pressing the LEFT, UP, or RIGHT arrow keys\nwill mute sections 1-4, 5-8, and 9-12 respectively.\nIn this case the LEFT arrow key mutes\nsound spaces 1-4.";
String tutorialText9 = "Pressing KEY 'w' toggles\nThe Cube's wire frame view.\n\nPressing SHIFT + 'w' will cycle\nthrough available wire\nframe colors.";
String tutorialText10 = "Pressing KEY 'p' toggles\nthe pulse audio analyzer.\n\nPressing SHIFT + 'p' cycles\nthrough the available\ncolors.";
String tutorialText11 = "Pressing RIGHT arrow key will restart tutorial.\nPressing KEY 'r' will reset and end the tutorial.";
String tutorialText11A = "Enjoy your stay at The Cube.";


/*************************************************************************************
 SETUP
 *************************************************************************************/
void setup() {
  size(800, 800, FX2D);
  cursor(HAND);
  bckgrndImg = loadImage("bckgrnd800.jpg");
  
  timerEnd = false; 
  introFadeDone = false;  
  welcomeSoundDone = false; 
  numAudioTracks = 12; 
  audioList = new String[numAudioTracks];
  tutorialText = "PRESS 'T' KEY FOR TUTORIAL"; 
  opacityTutText = 180; 
  goToTutorialMode = false; 
  goToUserMode = false; 
  startTutorialMode = false;
  startUserMode = true;
  tutorialCounter = 0; 
  opacityTutorialBkgrnd = 0;
  xCubeToCenter = 0;
  yCubeToCenter = 0;
  cubeCentered = false;
  canMoveNext = false;
  userModeTitleText = "THE CUBE"; 

  
  //#Timer
  timer = new Timer();
  
  // Assign audio track label to list audioList
  audioList[0] = "";
  audioList[1] = "";
  audioList[2] = "";
  audioList[3] = "";
  
  audioList[4] = "";
  audioList[5] = "";
  audioList[6] = "";
  audioList[7] = "";
  
  audioList[8] = "";
  audioList[9] = "";
  audioList[10] = "";
  audioList[11] = "";
  
  // Assign audio to SoundFile audio(1-12)
  audio1 = new SoundFile(this, audioList[0]); 
  audio2 = new SoundFile(this, audioList[1]); 
  audio3 = new SoundFile(this, audioList[2]);
  audio4 = new SoundFile(this, audioList[3]);
  
  audio5 = new SoundFile(this, audioList[4]); 
  audio6 = new SoundFile(this, audioList[5]); 
  audio7 = new SoundFile(this, audioList[6]);
  audio8 = new SoundFile(this, audioList[7]);
  
  audio9 = new SoundFile(this, audioList[8]);
  audio10 = new SoundFile(this, audioList[9]);
  audio11 = new SoundFile(this, audioList[10]); 
  audio12 = new SoundFile(this, audioList[11]);
  
  // Assign welcome audio to appropriate SoundFile object
  welcomeAudio = new SoundFile(this, "welcome_to_the_cube.wav");
  
  // Assign amplitude objects to amp(1-12)
  amp1 = new Amplitude(this);  
  amp2 = new Amplitude(this);  
  amp3 = new Amplitude(this);
  amp4 = new Amplitude(this);
  
  amp5 = new Amplitude(this);
  amp6 = new Amplitude(this);
  amp7 = new Amplitude(this);
  amp8 = new Amplitude(this);
  
  amp9 = new Amplitude(this);
  amp10 = new Amplitude(this);
  amp11 = new Amplitude(this);
  amp12 = new Amplitude(this);
  
  // Assing the input of amp(1-12) to corresponding audio(1-12)
  amp1.input(audio1);    
  amp2.input(audio2);
  amp3.input(audio3);
  amp4.input(audio4);
  
  amp5.input(audio5);
  amp6.input(audio6);
  amp7.input(audio7);
  amp8.input(audio8);
  
  amp9.input(audio9);
  amp10.input(audio10);
  amp11.input(audio11);
  amp12.input(audio12);
  
  // Set amplitude to 0 on start to avoid audio click on launch
  amplitude1 = 0.0;    
  amplitude2 = 0.0;
  amplitude3 = 0.0;
  amplitude4 = 0.0;
  
  amplitude5 = 0.0;
  amplitude6 = 0.0;
  amplitude7 = 0.0;
  amplitude8 = 0.0;
  
  amplitude9 = 0.0;
  amplitude10 = 0.0;
  amplitude11 = 0.0;
  amplitude12 = 0.0;
  
  // Set mute to false on start
  mute1 = false;  
  mute2 = false;
  mute3 = false;
  mute4 = false;
  
  mute5 = false;
  mute6 = false;
  mute7 = false;
  mute8 = false;
  
  mute9 = false;
  mute10 = false;
  mute11 = false;
  mute12 = false;
  
  // Set mute groups to false on start
  muteGroup1 = false;
  muteGroup2 = false;
  muteGroup3 = false;
  
  // #FIX do I use these?
  //soloGroup1 = false;
  //soloGroup2 = false;
  //soloGroup3 = false;
  
  // Do not show sound spaces on start
  showSoundSpace1 = false;
  showSoundSpace2 = false;
  showSoundSpace3 = false;
  showSoundSpace4 = false;
  showSoundSpace5 = false;
  showSoundSpace6 = false;
  showSoundSpace7 = false;
  showSoundSpace8 = false;
  showSoundSpace9 = false;
  showSoundSpace10 = false;
  showSoundSpace11 = false;
  showSoundSpace12 = false;
  
  mX = 400;             // Start mouseX position at cube center vertex
  mY = 360;             // Start mouseY position at cube center vertex
  inRange = false;      // Start inRange value 
  showWire = false;     // Start showWire value to not show wire frame
  showPulse = false;    // No pulse analyzer at start
  activateCube = false; // No sound will play at start
  shiftPressed = false; // Start key pressed at false
  ctrlPressed = false;  // Ctrl not presse don start    
  leftPressed = false;  // left arrow key not pressed on start
  upPressed = false;    // up arrow key not pressed on start
  rightPressed = false; // right arrow key not pressed on start
  downPressed = false;  // #FIX do i use this? 
  displayAudioSettings = false; // No audio settings displayed to start
  //audioTextStart = 140;         // Audio text width start location is 140
  pulseColor = 0;               // Start pulse color at 0
  wireFrameColor = 0;           // Start wire frame color 0

  opacityL = 0;     // Start Cube left opacity
  opacityT = 0;     // Start Cube top opacity
  opacityR = 0;     // Start Cube right opacity
  opacityWF = 0;      // Start wire frame opacity
  opacityPulse = 100; // Start pulse analyzer opacity
  
  //delay(1000);
}

/*************************************************************************************
 DRAW
 *************************************************************************************/
void draw() {
  image(bckgrndImg, 0, 0);
  
  // Play welcome to The Cube sound on first run
  //if(!welcomeSoundDone) {
  //  welcomeAudio.play();
  //  welcomeSoundDone = true;
  //}
  
  // Instructions to re-center the cube vertex
  // on reset or tutorial launch
  if(!cubeCentered) {
    switch(xCubeToCenter) {
      case 0:
      mX+=3;
      if(mX > 400) {
       mX = 400; 
      }
      break;
      case 1:
      mX-=3;
      if(mX < 400) {
        mX = 400;
      }
      break;
      default:
      break;
    }
    switch(yCubeToCenter) {
      case 0:
      mY+=3;
      if(mY > 360) {
        mY = 360;
      }
      break;
      case 1:
      mY-=3;
      if(mY < 360) {
        mY = 360;
      }
      break;
      default:
      break;
    }
    if(mX == 400 && mY == 360) {
      cubeCentered = true;
    }
  }
  
  // Begin transition to user mode
  if(goToUserMode) {
    opacityTutorialBkgrnd--;
    if(opacityTutorialBkgrnd < 0) {
      opacityTutorialBkgrnd = 0;
     startUserMode = true; 
    }
  }
  // Update the amplitude of audio(1-12) based on amplitude(1-12) variable
  audio1.amp(amplitude1); 
  audio2.amp(amplitude2);
  audio3.amp(amplitude3);
  audio4.amp(amplitude4);
  audio5.amp(amplitude5); 
  audio6.amp(amplitude6);
  audio7.amp(amplitude7);
  audio8.amp(amplitude8);
  audio9.amp(amplitude9); 
  audio10.amp(amplitude10);
  audio11.amp(amplitude11);
  audio12.amp(amplitude12);
  
  // Display the sound space map as toggled
  displaySoundSpace();
  
  //#FIX
  // Run timer and display tutorial option text
  // If timer is 3 seconds fade out tutorial
  // option text and fade in the cube
  if(!timerEnd)  {
    timer.run();
    timer.startStop();
    
    // Display initial tutorial option text
    // with fade out feature
    fill(108, 0, 232, opacityTutText);
    opacityTutText--;
    if(opacityTutText < 0) {
      opacityTutText = 0;
    }
    displayTutorialOptionText(400, 400, 22); // Press 'T' key for tutorial
    
    // If timer reaches 3 seconds turn timer off
    if(timer.seconds > 3.0) {
      timerEnd = true;  
    }
  } else {
    if(!introFadeDone) {
      //Fade in The Cube on introFadeDone
      opacityL+= 1;
      if(opacityL > 100) {
        opacityL = 100;
      }
      opacityT+=1;
      if(opacityT >100) {
        opacityT = 100;
      }
      opacityR+=1;
      if(opacityR >100) {
        opacityR = 100;
        // Turn introFadeDone to true to insure this is done only 
        // once on start or otherwise toggled
        introFadeDone = true;
      }
    }
  }
  // Display cube but opacity is faded
  // in per above logic and then remains 
  // consistent to distance from center vertex
  cubeDisplay();
  
  // Toggle wireframe view show/hide
  if (showWire) {
    displayWireFrame();
  }

  // Toggle pulse analyzer view show/hide
  if (showPulse) {
    displayPulseAnalyzer();
  }
  
  // Display THE CUBE title text and format
  
  if(startUserMode) {
    displayTitleText(userModeTitleText, 26); 
  } else if(startTutorialMode) {
    displayTitleText(tutorialModeTitleText, 26); 
  }
  
  // Toggle dispay audio status view
  if (displayAudioSettings) { 
    displayAudioStatusText(12);
    displayTutorialOptionText(400, 730, 12); // Press 'T' key for tutorial
  }
  
  // Overlay rect for tutorial mode
  fill(0, opacityTutorialBkgrnd);
  noStroke();
  rect(0,0,width, height); 
  //#TEST END
  
  // Begin transition to tutorial mode
  if(goToTutorialMode) { // INTRO TO TUTORIAL MODE
   opacityTutorialBkgrnd+= 1;
   
   if(opacityTutorialBkgrnd > 70) {
    opacityTutorialBkgrnd = 70; 
    startTutorialMode = true;
    
    if(startTutorialMode && introFadeDone) { // BEGIN THE TUTORIAL MODE

    //Loop audio within tutorial mode
    // then turn off initiate cube
    if (!activateCube) {
      audio1.loop(); //Loop songOne
      audio2.loop();
      audio3.loop();
      audio4.loop();
      audio5.loop(); 
      audio6.loop();
      audio7.loop();
      audio8.loop();
      audio9.loop();
      audio10.loop();
      audio11.loop();
      audio12.loop();
      activateCube = true;
    }
    // Update amplitues of individual audio(1-12)
    // Also update mutes, solos, and opacity changes
    updateAmplitudes(); 
    //Navigate through tutorial mode
      switch(tutorialCounter) {
        case 0: // Welcome
        displayTutorialText(tutorialText0, 400, 270, 2);
        displayTutorialText(tutorialText0A, 410, 380, 0);
        canMoveNext = true;
        break;
        
        case 1: // Interactive Sound
        displayTutorialText(tutorialText1, 390, 390, 1);
        canMoveNext = true;
        break;
        
        case 2: // Explore sounds
        displayTutorialText(tutorialText2, 400, 240, 2);
        stroke(255, 0 , 0);
        noFill();
        strokeWeight(1);
        ellipse(mX, mY, 30, 30);
        canMoveNext = true;
        break;
        
        case 3: // Press CTRL + 1
        // Move center vertex to sound space 1
        mX-=2;
        if(mX < 96) {
          mX = 96;
        }
        mY-=1.75;
        if(mY < 96) {
          mY = 96;
        }
        if(mX == 96 && mY == 96) {
          displayTutorialText(tutorialText3, 10, 190, 0);
          showSoundSpace1 = true;
          canMoveNext = true;
        } else {
          displayTutorialText(tutorialText2, 400, 240, 2);
        }
        // Red circle on vertex
        stroke(255, 0 , 0);
        noFill();
        strokeWeight(1);
        ellipse(mX, mY, 30, 30);
        break;
        
        case 4:
        // Move center vertex to new sound space
        // and display sounds space vertex moves
        mX+=2;
        if(mX > 550) {
          mX = 550;
        }
        mY++;
        if(mY > 250) {
          mY = 250;
        }
        if(mX > 110) {
         displayTutorialText(tutorialText4, 210, 280, 0); 
        }
        showSoundSpace1 = true;
        if(mX > 150) {
          
         showSoundSpace2 = true; 
         showSoundSpace3 = true; 
         showSoundSpace4 = true; 
        }
        if(mX > 270) {
         showSoundSpace5 = true; 
         showSoundSpace6 = true; 
         showSoundSpace7 = true; 
         showSoundSpace8 = true; 
        }
        if(mX > 400) {
         showSoundSpace9 = true; 
         showSoundSpace10 = true; 
         showSoundSpace11 = true; 
         showSoundSpace12 = true; 
         //displayTutorialText(tutorialText4, 390, 470, 1); 
        }
        if(mX == 550 && mY == 250) {
         displayTutorialText(tutorialText4A, 390, 470, 1); 
         canMoveNext = true;
        } 
        // Red circle around vertex
        stroke(255, 0 , 0);
        noFill();
        strokeWeight(1);
        ellipse(mX, mY, 30, 30);
        break;
        
        case 5:
        // Move center vertex to new sound space
        // and hide sound spaces
        mX-=1.35;
        if(mX < 320) {
          mX = 320;
        }
        mY+=2;
        if(mY > 580) {
          mY = 580;
        }
        if(mY > 300) {
         showSoundSpace1 = false; 
         showSoundSpace2 = false; 
         showSoundSpace3 = false; 
         showSoundSpace4 = false; 
        }
        if(mY > 400) {
         showSoundSpace5 = false; 
         showSoundSpace6 = false; 
         showSoundSpace7 = false; 
         showSoundSpace8 = false; 
         
        }
        if(mY > 500) {
         showSoundSpace9 = false; 
         showSoundSpace10 = false; 
         showSoundSpace11 = false; 
         showSoundSpace12 = false;
         displayTutorialText(tutorialText5, 400, 260, 2);
         
        }
        if(mX == 320 && mY == 580) {
         displayAudioStatusText(12);
         canMoveNext = true;
        }
        // Red circle around vertex
        stroke(255, 0 , 0);
        noFill();
        strokeWeight(1);
        ellipse(mX, mY, 30, 30);
        break;
        
        case 6:  
        displayAudioStatusText(12);
        // Move center vertex to new sound space
        // and hide sound spaces
        mX+=2;
        if(mX > 704) {
          mX = 704;
        }
        mY+=1;
        if(mY > 704) {
          mY = 704;
        }
        if(mX > 620) {
          displayTutorialText(tutorialText6, 580, 320, 1);
        }
        if(mX == 704 & mY == 704) {
          mute4 = true;
          amplitude4 = 0.0;
          // Red solo circle
          stroke(255, 0 , 0);
          noFill();
          strokeWeight(1);
          ellipse(295, 775, 30, 30);
          canMoveNext = true;
        }
        
        // Red circle around vertex
        stroke(255, 0 , 0);
        noFill();
        strokeWeight(1);
        ellipse(mX, mY, 30, 30);
        break;
        case 7:
        displayTutorialText(tutorialText7, 580, 320, 1);
        displayAudioStatusText(12);
        
        amplitude1 = 0.0;
        amplitude2 = 0.0;
        amplitude3 = 0.0;
        mute4 = false;
        amplitude4 = mapAudioAmp(amplitude4, 600, 400, 400);
        amplitude5 = 0.0;
        amplitude6 = 0.0;
        amplitude7 = 0.0;
        amplitude8 = 0.0;
        amplitude9 = 0.0;
        amplitude10 = 0.0;
        amplitude11 = 0.0;
        amplitude12 = 0.0;
        mute1 = true;
        mute2 = true;
        mute3 = true;
        solo4 = true;
        mute5 = true;
        mute6 = true;
        mute7 = true;
        mute8 = true;
        mute9 = true;
        mute10 = true;
        mute11 = true;
        mute12 = true;
        // Red circle around vertex
        stroke(255, 0 , 0);
        noFill();
        strokeWeight(1);
        ellipse(mX, mY, 30, 30);
        // Red solo circle
        ellipse(295, 775, 30, 30);
        canMoveNext = true;
        break;

        case 8:
        displayTutorialText(tutorialText8, 400, 260, 2);
        displayAudioStatusText(12);
        // Move center vertex to new sound space
        // and hide sound spaces
        mX-=3;
        if(mX < 220) {
          mX = 220;
        }
        mY-=.75;
        if(mY < 600) {
          mY = 600;
        }
        if(mX == 220 && mY == 600) {
        amplitude1 = 0.0;
        amplitude2 = 0.0;
        amplitude3 = 0.0;
        amplitude4 = 0.0;
        mute1 = true;
        mute2 = true;
        mute3 = true;
        mute4 = true;
        mute5 = false;
        mute6 = false;
        mute7 = false;
        mute8 = false;
        mute9 = false;
        mute10 = false;
        mute11 = false;
        mute12 = false;
        solo4 = false;
        
        // Red rect around muted group
        stroke(255, 0 , 0);
        noFill();
        strokeWeight(1);
        ellipse(mX, mY, 30, 30);
        // Red solo circle
        rect(130, 740, 180, 50);
        }
        // Red circle around vertex
        stroke(255, 0 , 0);
        noFill();
        strokeWeight(1);
        ellipse(mX, mY, 30, 30);
        canMoveNext = true;
        break;

        case 9:
        // Move center vertex to new sound space
        // and hide sound spaces
        mX-=1;
        if(mX < 80) {
          mX = 80;
        }
        mY-=2;
        if(mY < 200) {
          mY = 200;
        }
        if(mY <570) {
          displayTutorialText(tutorialText9, 410, 390, 0);
        }
        if(mY < 450) {
          showWire = true;
        }
        if(mY < 400) {
          wireFrameColor = 1;
        }
        if(mY < 350) {
          wireFrameColor = 2;
        }
        if(mY < 300) {
          wireFrameColor = 3;
        }
        if(mX == 80 && mY == 200) {
          wireFrameColor = 0;
          canMoveNext = true;
        }
        
        mute1 = false;
        mute2 = false;
        mute3 = false;
        mute4 = false;
        updateAmplitudes();
        // Red circle around vertex
        stroke(255, 0 , 0);
        noFill();
        strokeWeight(1);
        ellipse(mX, mY, 30, 30);
        break;

        case 10:
        // Move center vertex to new sound space
        // and hide sound spaces
        mX+=2;
        if(mX > 370) {
          mX = 370;
        }
        mY-=.35;
        if(mY < 150) {
          mY = 150;
        }
        
        if(mX > 130) {
          displayTutorialText(tutorialText10, 380, 380, 1);
        }
        if(mX > 150) {
          showWire = false;
          showPulse = true;
        }
        if(mX > 200) {
          pulseColor = 1;
        }
        if(mX > 260) {
          pulseColor = 2;
        }
        if(mX > 310) {
          pulseColor = 3;
        }
        if(mX == 370 && mY == 150) {
          pulseColor = 0;
          canMoveNext = true;
        }
        // Red circle around vertex
        stroke(255, 0 , 0);
        noFill();
        strokeWeight(1);
        ellipse(mX, mY, 30, 30);
        break;

        case 11:
        // Move center vertex to center start
        mX+=.15;
        if(mX > 400) {
          mX = 400;
        }
        mY+=1;
        if(mY > 360) {
          mY = 360;
        }
        if(mX > 390) {
        }
        if(mX == 400 && mY == 360) {
          showPulse = false;
          displayTutorialText(tutorialText11, 400, 250, 2);
          displayTutorialText(tutorialText11A, 410, 460, 0);
          canMoveNext = true;
        } else {
         stroke(255, 0 , 0);
        noFill();
        strokeWeight(1);
        ellipse(mX, mY, 30, 30); 
        }
        break;
        
        default:
        break;
      } 
    }
   }
  }
}

/*************************************************************************************
 MY METHODS
 *************************************************************************************/

/**
 * Map the amplitude of sound space
 *
 * @PARAM mMap: Float being mapped
 * @PARAM mSize: Ingetger size of the sound space
 * @PARAM tX: Float x position of sound space
 * @PARAM tY: Float y position of sound space
 **/
float mapAudioAmp(float mMap, int mSize, float tX, float tY) {  
  //soundSpace12.initiate(amplitude12, mX, mY, 150, 360, 500);
  mMap = map(abs(dist(mX - (mSize / 4), mY - (mSize / 4), tX + (mSize/4), tY +(mSize/4))), 0, (mSize / 2), 1, 0);
  if (mMap > 0.9) {
    mMap = 1.0;
  }  
  if (mMap < 0.0) {
    mMap = 0.0;
  }
  return mMap;
}

/**
 * Display the mapped sound space area
 *
 * @PARAM mSize: Ingetger size of the sound space
 * @PARAM tX: Float x position of sound space
 * @PARAM tY: Float y position of sound space
 **/
void soundSpaceDisplay(int mSize, float tX, float tY, int num) {
  noStroke();
  fill(48, 94, 47, 50);
  ellipse(tX + (mSize / 2), tY + (mSize / 2), mSize, mSize);
  fill(48, 94, 47, 200);
  ellipse(tX + (mSize / 2), tY + (mSize / 2), 20, 20);
  textAlign(CENTER, CENTER);
  textSize(10);
  fill(255);
  text(num, tX + (mSize / 2), tY + (mSize / 2));
}

/**
 * Display the cube
 **/
void cubeDisplay() {
  noStroke();
  /** Vertex locations of cube
   ---------------------------------------
   ----------------G----------------------
   ---------------------------------------
   ---------B-------------F---------------
   ----------------A----------------------
   ---------C-------------E---------------
   ---------------------------------------
   ----------------D----------------------   
   **/
  // Cube dark-green left side
  fill(74, 112, 122, opacityL);
  beginShape();
  vertex(mX, mY);    // A
  vertex(200, 260);  // B
  vertex(200, 460);  // C
  vertex(400, 610);  // D
  vertex(mX, mY);    // A
  endShape();
  // Cube medium-green top
  fill(148, 176, 183, opacityT);
  beginShape();
  vertex(mX, mY);    // A
  vertex(200, 260);  // B
  vertex(400, 180);  // G
  vertex(600, 260);  // F
  vertex(mX, mY);    // A
  endShape();
  // Cube gray right side
  fill(194, 200, 197, opacityR);
  beginShape();
  vertex(mX, mY);    // A
  vertex(600, 260);  // F
  vertex(600, 460);  // E
  vertex(400, 610);  // D
  vertex(mX, mY);    // A
  endShape();
}

/**
 * Display the wire frame of cube
 **/
void displayWireFrame() {
  switch(wireFrameColor) {
  case 1:
    stroke(108, 0, 232, opacityWF);
    break;
  case 2:
    stroke(48, 94, 47, opacityWF);
    break;
  case 3:
    stroke(120, opacityWF);
    break;
  default:
    stroke(8, 24, 110, opacityWF);
    break;
  }

  strokeWeight(1);
  noFill();

  beginShape(); // Cube left side
  vertex(400, 360);  // A
  vertex(200, 260);  // B
  vertex(200, 460);  // C
  vertex(400, 610);  // D
  endShape();
  beginShape();// Cube right side
  vertex(400, 360);  // A
  vertex(600, 260);  // F
  vertex(600, 460);  // E
  vertex(400, 610);  // D
  vertex(400, 360);  // A
  endShape();
  beginShape(); // Cube top
  vertex(200, 260);  // B
  vertex(400, 180);  // G
  vertex(600, 260);  // F
  endShape();
}

/**
 * Method for displaying audio visual analyzer 
 * for all audio actively playing
 *
 * @Param a, b, c, d,
 *        e, f, g, h,
 *        i, j, k, l: Amplitude object
 * @Param mPulseAmt: Pulse Analyzer amount
 * @Param mStrkWhgt: Stroke Weight value
 * @Param mR: Red color value
 * @Param mG: Green color value
 * @Param mB: Blue color value
 * @Param mO: Opacity value
 **/
void pulseAnalyzerAll(Amplitude a, Amplitude b, Amplitude c, Amplitude d, 
  Amplitude e, Amplitude f, Amplitude g, Amplitude h, 
  Amplitude i, Amplitude j, Amplitude k, Amplitude l, 
  float mPulseAmt, int mStrkWhgt, int mR, int mG, int mB, float mO) {

  float mAmp = (a.analyze() + b.analyze() + c.analyze() + d.analyze() +
    e.analyze() + f.analyze() + g.analyze() + h.analyze() +
    i.analyze() + j.analyze() + k.analyze() + l.analyze()) / 3;
  noFill();
  strokeWeight(mStrkWhgt);
  stroke(mR, mG, mB, mO);

  beginShape(); // Cube Left
  vertex(400, 360 - (mAmp * mPulseAmt/2)); //A
  vertex(200 - (mAmp * mPulseAmt), 260 - (mAmp * mPulseAmt)); // B
  vertex(200 - (mAmp * mPulseAmt), 460); // C
  vertex(400, 610 + (mAmp * mPulseAmt));
  endShape();
  beginShape(); // Cube Right
  vertex(400, 360 - (mAmp * (mPulseAmt / 2))); // A
  vertex(600 + (mAmp * mPulseAmt), 260 - (mAmp * mPulseAmt)); // F
  vertex(600 + (mAmp * mPulseAmt), 460); // E
  vertex(400, 610 + (mAmp * mPulseAmt)); // D
  vertex(400, 360 - (mAmp * (mPulseAmt / 2))); // A
  endShape();
  beginShape(); // Cube Top
  vertex(200 - (mAmp * mPulseAmt), 260 - (mAmp * mPulseAmt)); // B
  vertex(400, 180 - (mAmp * mPulseAmt)); // G
  vertex(600 + (mAmp * mPulseAmt), 260 - (mAmp * mPulseAmt)); //F
  endShape();
}

/**
 * Method for indivual audio visual analyzer 
 *
 * @Param mAmp: Amplitude object
 * @Param mPulseAmt: Pulse Analyzer amount
 * @Param mStrkWhgt: Stroke Weight value
 * @Param mR: Red color value
 * @Param mG: Green color value
 * @Param mB: Blue color value
 * @Param mO: Opacity value
 **/
void pulseAnalyzerSolo(Amplitude  mAmp, float mPulseAmt, int mStrkWhgt, int mR, int mG, int mB, float mO) {
  noFill();
  strokeWeight(mStrkWhgt);
  stroke(mR, mG, mB, mO);

  beginShape(); // Cube Left
  vertex(400, 360 - (mAmp.analyze() * mPulseAmt/2)); //A
  vertex(200 - (mAmp.analyze() * mPulseAmt), 260 - (mAmp.analyze() * mPulseAmt)); // B
  vertex(200 - (mAmp.analyze() * mPulseAmt), 460); // C
  vertex(400, 610 + (mAmp.analyze() * mPulseAmt));
  endShape(); 
  beginShape(); // Cube Right
  vertex(400, 360 - (mAmp.analyze() * (mPulseAmt / 2))); // A
  vertex(600 + (mAmp.analyze() * mPulseAmt), 260 - (mAmp.analyze() * mPulseAmt)); // F
  vertex(600 + (mAmp.analyze() * mPulseAmt), 460); // E
  vertex(400, 610 + (mAmp.analyze() * mPulseAmt)); // D
  vertex(400, 360 - (mAmp.analyze() * (mPulseAmt / 2))); // A
  endShape();
  beginShape(); // Cube Top
  vertex(200 - (mAmp.analyze() * mPulseAmt), 260 - (mAmp.analyze() * mPulseAmt)); // B
  vertex(400, 180 - (mAmp.analyze() * mPulseAmt)); // G
  vertex(600 + (mAmp.analyze() * mPulseAmt), 260 - (mAmp.analyze() * mPulseAmt)); //F
  endShape();
}

/**
 * Display individual tutorial step text
 *
 * @PARAM stepText, String the text to be displayed
 * @PARAM sX, int x start position of text
 * @PARAM sY, int y start position of text
 * @PARAM tAlign, int text align type (0 = left, 1 = right, 2 = center)
 **/
void displayTutorialText(String stepText, int sX, int sY, int tAlign) {
  textSize(14);
  fill(108, 0, 232, 200);
  switch(tAlign) {
   case 1:
   textAlign(RIGHT);
   break;
   case 2:
   textAlign(CENTER);
   break;
   default:
   textAlign(LEFT);
   break;
  }
  text(stepText, sX, sY);
  textAlign(LEFT); 
}

/**
 * Display the text for the tutorial mode option
 * "PREST 'T' FOR TUTORIAL"
 *
 * @PARAM sX: int x start position of the text
 * @PARAM sY: int y start position of the text
 * @PARAM fontSize: int font size of the text
 **/
void displayTutorialOptionText(int sX, int sY, int fontSize) {
  //#TUTORIAL
  textSize(fontSize);
  text(tutorialText, sX - (textWidth(tutorialText)/2), sY);
}

/**
 * Display the program title text
 * "THE CUBE"
 *
 * @PARAM fontSize: int font size of the text
 **/
void displayTitleText(String tText, int fontSize) {
  
  if(startUserMode) {
  fill(200, 200 - (opacityWF * 1.5));
  } else if(startTutorialMode) {
    fill(108, 0, 232, 200);
  }
  textAlign(LEFT);
  textSize(fontSize);
  text(tText, (400 - (textWidth(tText)/2)), 100);
}

/**
 * Display the text and format settings when
 * audio status view is toggled on
 *
 * @PARAM fontSize: int font size of the text
 **/
void displayAudioStatusText(int fontSize) {
  //AUDIO TEXT START AND FORMAT
  textSize(fontSize);
  textAlign(LEFT);
    audioTextStart = 140;
    fill(200);
    if (mute1) {
      text("AUDIO 01: M", audioTextStart, 760);
    } else {
      audioPlayingText("AUDIO 01: ", audioTextStart, 760);
    }
    if (mute2) {
      text("AUDIO 02: M", audioTextStart, 780);
    } else {
      audioPlayingText("AUDIO 02: ", audioTextStart, 780);
    }
    audioTextStart += 90;
    if (mute3) {
      text("AUDIO 03: M", audioTextStart, 760);
    } else {
      audioPlayingText("AUDIO 03: ", audioTextStart, 760);
    }
    if (mute4) {
      text("AUDIO 04: M", audioTextStart, 780);
    } else { 
      audioPlayingText("AUDIO 04: ", audioTextStart, 780);
    }
    audioTextStart += 100;
    if (mute5) {
      text("AUDIO 05: M", audioTextStart, 760);
    } else { 
      audioPlayingText("AUDIO 05: ", audioTextStart, 760);
    }
    if (mute6) {
      text("AUDIO 06: M", audioTextStart, 780);
    } else { 
      audioPlayingText("AUDIO 06: ", audioTextStart, 780);
    }
    audioTextStart += 90;
    if (mute7) {
      text("AUDIO 07: M", audioTextStart, 760);
    } else {
      audioPlayingText("AUDIO 07: ", audioTextStart, 760);
    }
    if (mute8) {
      text("AUDIO 08: M", audioTextStart, 780);
    } else {
      audioPlayingText("AUDIO 08: ", audioTextStart, 780);
    }
    audioTextStart += 100;
    if (mute9) {
      text("AUDIO 09: M", audioTextStart, 760);
    } else {
      audioPlayingText("AUDIO 09: ", audioTextStart, 760);
    }
    if (mute10) {
      text("AUDIO 10: M", audioTextStart, 780);
    } else { 
      audioPlayingText("AUDIO 10: ", audioTextStart, 780);
    }
    audioTextStart += 90;
    if (mute11) {
      text("AUDIO 11: M", audioTextStart, 760);
    } else { 
      audioPlayingText("AUDIO 11: ", audioTextStart, 760);
    }
    if (mute12) {
      text("AUDIO 12: M", audioTextStart, 780);
    } else { 
      audioPlayingText("AUDIO 12: ", audioTextStart, 780);
    }
    
}

/**
 * Display the amplitude pulse analyzer when toggled
 *
 * @SWITCH sX: int cycle through preprogrammed color options
 **/
void displayPulseAnalyzer() {
 switch(pulseColor) {
    case 1:
      pulseAnalyzerAll(amp1, amp2, amp3, amp4, 
        amp5, amp6, amp7, amp8, 
        amp9, amp10, amp11, amp12, 
        200, 2, 108, 0, 232, opacityPulse); // Rya Purple
      break;
    case 2:
      pulseAnalyzerAll(amp1, amp2, amp3, amp4, 
        amp5, amp6, amp7, amp8, 
        amp9, amp10, amp11, amp12, 
        200, 2, 48, 94, 47, opacityPulse); // Rya Green
      break;
    case 3:
      pulseAnalyzerAll(amp1, amp2, amp3, amp4, 
        amp5, amp6, amp7, amp8, 
        amp9, amp10, amp11, amp12, 
        200, 2, 120, 120, 120, opacityPulse); // Gray
      break;
    default:
      pulseAnalyzerAll(amp1, amp2, amp3, amp4, 
        amp5, amp6, amp7, amp8, 
        amp9, amp10, amp11, amp12, 
        200, 2, 8, 24, 110, opacityPulse); // Rya Blue
      break;
    } 
}

/**
 * Display the sound space when toggled
 *
 **/
void displaySoundSpace() {
  if (showSoundSpace1) {
    soundSpaceDisplay(600, -200, -200, 1); // 1
  }
  if (showSoundSpace2) {
    soundSpaceDisplay(600, 400, -200, 2); // 2
  }
  if (showSoundSpace3) {
    soundSpaceDisplay(600, -200, 400, 3); // 3
  }
  if (showSoundSpace4) {
    soundSpaceDisplay(600, 400, 400, 4); // 4
  }
  if (showSoundSpace5) {
    soundSpaceDisplay(600, -300, 100, 5); // 5
  }
  if (showSoundSpace6) {
    soundSpaceDisplay(600, 100, -300, 6); // 6
  }
  if (showSoundSpace7) {
    soundSpaceDisplay(600, 500, 100, 7); // 7
  }
  if (showSoundSpace8) {
    soundSpaceDisplay(600, 100, 500, 8); // 8
  }
  if (showSoundSpace9) {
    soundSpaceDisplay(400, 0, 160, 9); // 9
  }
  if (showSoundSpace10) {
    soundSpaceDisplay(400, 200, -40, 10); // 10
  }
  if (showSoundSpace11) {
    soundSpaceDisplay(400, 400, 160, 11); // 11
  }
  if (showSoundSpace12) {
    soundSpaceDisplay(500, 150, 360, 12); // 12
  }
}

/**
 * Display triangle play button when audio is playing
 
 * @PARAM tAudio: String, to be displayed next to playing triangle
 *                i.e. "AUDIO 1"
 * @PARAM tX: int, x start position of the text
 * @PARAM tY: int, y start position of the text
 **/
void audioPlayingText(String tAudio, int tX, float tY) {
  noStroke();
  fill(200);
  beginShape(); // Play
  vertex(tX + 65, tY - 8);
  vertex(tX + 65, tY + 2);
  vertex(tX + 70, tY - 3);
  vertex(tX + 65, tY - 8);
  endShape();
  text(tAudio, tX, tY);
}

/**
 * Randomize the audioList in order to shuffle the
 * audio tracks around the sound space
 *
 * @PARAM listLen the length of the array list
 **/
void randomizeList(int listLen) {
  ArrayList<Integer> nums = new ArrayList<Integer>();
  randomNumList = new int[listLen];

  for(int i = 0; i < listLen; i++) {
    nums.add(i);
  }
  
  for(int i = 0; i < listLen; i++) {
    int rand = int(random(0, nums.size()));
    randomNumList[i] = nums.get(rand);
    nums.remove(rand);
    println(nums.size());
  }
}

/**
 * Updates the amplitudes when cube vertex dragged around
 * sound spaces. 
 *
 **/
void updateAmplitudes() {
  // Update opacity values
    opacityL = map(mX, 100, width, 200, 10);
    opacityT = map(mY, 100, height, 200, 10);
    opacityR = map(mX, 100, width, 10, 200);
    opacityWF = map(abs(dist(mX, mY, 400, 360)), 0, width, 0, 200);
    opacityPulse = map(abs(dist(mX, mY, 400, 360)), 0, width, 100, 5);

    if (muteGroup1) {
      //amplitude1 = mapAudioAmp(amplitude1, 600, -200, -200);
      //amplitude2 = mapAudioAmp(amplitude2, 600, 400, -200);
      //amplitude3 = mapAudioAmp(amplitude3, 600, -200, 400);
      //amplitude4 = mapAudioAmp(amplitude4, 600, 400, 400);  
      mute1 = true;
      mute2 = true;
      mute3 = true;
      mute4 = true;
    } else {
      if (!mute1) {
        mute1 = false;
      }
      if (!mute2) {
        mute2 = false;
      }
      if (!mute3) {
        mute3 = false;
      }
      if (!mute4) {
        mute4 = false;
      }
      amplitude1 = mapAudioAmp(amplitude1, 600, -200, -200);
      amplitude2 = mapAudioAmp(amplitude2, 600, 400, -200);
      amplitude3 = mapAudioAmp(amplitude3, 600, -200, 400);
      amplitude4 = mapAudioAmp(amplitude4, 600, 400, 400);
    }
    if (muteGroup2) {
      //  amplitude5 = mapAudioAmp(amplitude5, 600, -300, 100);
      //  amplitude6 = mapAudioAmp(amplitude6, 600, 100, -300);
      //  amplitude7 = mapAudioAmp(amplitude7, 600, 500, 100);
      //  amplitude8 = mapAudioAmp(amplitude8, 600, 100, 500);
      mute5 = true;
      mute6 = true;
      mute7 = true;
      mute8 = true;
    } else {
      if (!mute5) {
        mute5 = false;
      }
      if (!mute6) {
        mute6 = false;
      }
      if (!mute7) {
        mute7 = false;
      }
      if (!mute8) {
        mute8 = false;
      }
      amplitude5 = mapAudioAmp(amplitude5, 600, -300, 100);
      amplitude6 = mapAudioAmp(amplitude6, 600, 100, -300);
      amplitude7 = mapAudioAmp(amplitude7, 600, 500, 100);
      amplitude8 = mapAudioAmp(amplitude8, 600, 100, 500);
    }

    if (muteGroup3) {
      //  amplitude9 = mapAudioAmp(amplitude9, 400, 0, 160);
      //  amplitude10 = mapAudioAmp(amplitude10, 400, 200, -40);
      //  amplitude11 = mapAudioAmp(amplitude11, 400, 400, 160);     
      //  amplitude12 = mapAudioAmp(amplitude12, 500, 150, 360);
      mute9 = true;
      mute10 = true;
      mute11 = true;
      mute12 = true;
    } else {
      if (!mute9) {
        mute9 = false;
      }
      if (!mute10) {
        mute10 = false;
      }
      if (!mute11) {
        mute11 = false;
      }
      if (!mute12) {
        mute12 = false;
      }
      amplitude9 = mapAudioAmp(amplitude9, 400, 0, 160);
      amplitude10 = mapAudioAmp(amplitude10, 400, 200, -40);
      amplitude11 = mapAudioAmp(amplitude11, 400, 400, 160);     
      amplitude12 = mapAudioAmp(amplitude12, 500, 150, 360);
    }



    if (!mute1) {
      amplitude1 = mapAudioAmp(amplitude1, 600, -200, -200);
    } else {
      amplitude1 = 0;
    }
    if (!mute2) {
      amplitude2 = mapAudioAmp(amplitude2, 600, 400, -200);
    } else {
      amplitude2 = 0;
    }
    if (!mute3) {
      amplitude3 = mapAudioAmp(amplitude3, 600, -200, 400);
    } else {
      amplitude3 = 0;
    }
    if (!mute4) {
      amplitude4 = mapAudioAmp(amplitude4, 600, 400, 400);
    } else {
      amplitude4 = 0;
    }
    if (!mute5) {
      amplitude5 = mapAudioAmp(amplitude5, 600, -300, 100);
    } else {
      amplitude5 = 0;
    }
    if (!mute6) {
      amplitude6 = mapAudioAmp(amplitude6, 600, 100, -300);
    } else {
      amplitude6 = 0;
    }
    if (!mute7) {
      amplitude7 = mapAudioAmp(amplitude7, 600, 500, 100);
    } else {
      amplitude7 = 0;
    }
    if (!mute8) {
      amplitude8 = mapAudioAmp(amplitude8, 600, 100, 500);
    } else {
      amplitude8 = 0;
    }
    if (!mute9) {
      amplitude9 = mapAudioAmp(amplitude9, 400, 0, 160);
    } else {
      amplitude9 = 0;
    }
    if (!mute10) {
      amplitude10 = mapAudioAmp(amplitude10, 400, 200, -40);
    } else {
      amplitude10 = 0;
    }
    if (!mute11) {
      amplitude11 = mapAudioAmp(amplitude11, 400, 400, 160);
    } else {
      amplitude11 = 0;
    }
    if (!mute12) {
      amplitude12 = mapAudioAmp(amplitude12, 500, 150, 360);
    } else {
      amplitude12 = 0;
    }

    if (solo1) {
      amplitude1 = mapAudioAmp(amplitude1, 600, -200, -200);
      amplitude2 = 0.0;
      amplitude3 = 0.0;
      amplitude4 = 0.0;
      amplitude5 = 0.0;
      amplitude6 = 0.0;
      amplitude7 = 0.0;
      amplitude8 = 0.0;
      amplitude9 = 0.0;
      amplitude10 = 0.0;
      amplitude11 = 0.0;
      amplitude12 = 0.0;
      // #FIXME do i need to add this tall solos?
      mute2 = true;
      mute3 = true;
      mute4 = true;
      mute5 = true;
      mute6 = true;
      mute7 = true;
      mute8 = true;
      mute9 = true;
      mute10 = true;
      mute11 = true;
      mute12 = true;
    }

    if (solo2) {
      amplitude1 = 0.0;
      amplitude2 = mapAudioAmp(amplitude2, 600, 400, -200);
      amplitude3 = 0.0;
      amplitude4 = 0.0;
      amplitude5 = 0.0;
      amplitude6 = 0.0;
      amplitude7 = 0.0;
      amplitude8 = 0.0;
      amplitude9 = 0.0;
      amplitude10 = 0.0;
      amplitude11 = 0.0;
      amplitude12 = 0.0;
    }
    if (solo3) {
      amplitude1 = 0.0;
      amplitude2 = 0.0;
      amplitude3 = mapAudioAmp(amplitude3, 600, -200, 400);
      amplitude4 = 0.0;
      amplitude5 = 0.0;
      amplitude6 = 0.0;
      amplitude7 = 0.0;
      amplitude8 = 0.0;
      amplitude9 = 0.0;
      amplitude10 = 0.0;
      amplitude11 = 0.0;
      amplitude12 = 0.0;
    }
    if (solo4) {
      amplitude1 = 0.0;
      amplitude2 = 0.0;
      amplitude3 = 0.0;
      amplitude4 = mapAudioAmp(amplitude4, 600, 400, 400);
      amplitude5 = 0.0;
      amplitude6 = 0.0;
      amplitude7 = 0.0;
      amplitude8 = 0.0;
      amplitude9 = 0.0;
      amplitude10 = 0.0;
      amplitude11 = 0.0;
      amplitude12 = 0.0;
    }
    if (solo5) {
      amplitude1 = 0.0;
      amplitude2 = 0.0;
      amplitude3 = 0.0;
      amplitude4 = 0.0;
      amplitude5 = mapAudioAmp(amplitude5, 600, -300, 100);
      amplitude6 = 0.0;
      amplitude7 = 0.0;
      amplitude8 = 0.0;
      amplitude9 = 0.0;
      amplitude10 = 0.0;
      amplitude11 = 0.0;
      amplitude12 = 0.0;
    }
    if (solo6) {
      amplitude1 = 0.0;
      amplitude2 = 0.0;
      amplitude3 = 0.0;
      amplitude4 = 0.0;
      amplitude5 = 0.0;
      amplitude6 = mapAudioAmp(amplitude6, 600, 100, -300);
      amplitude7 = 0.0;
      amplitude8 = 0.0;
      amplitude9 = 0.0;
      amplitude10 = 0.0;
      amplitude11 = 0.0;
      amplitude12 = 0.0;
    }
    if (solo7) {
      amplitude1 = 0.0;
      amplitude2 = 0.0;
      amplitude3 = 0.0;
      amplitude4 = 0.0;
      amplitude5 = 0.0;
      amplitude6 = 0.0;
      amplitude7 = mapAudioAmp(amplitude7, 600, 500, 100);
      amplitude8 = 0.0;
      amplitude9 = 0.0;
      amplitude10 = 0.0;
      amplitude11 = 0.0;
      amplitude12 = 0.0;
    }
    if (solo8) {
      amplitude1 = 0.0;
      amplitude2 = 0.0;
      amplitude3 = 0.0;
      amplitude4 = 0.0;
      amplitude5 = 0.0;
      amplitude6 = 0.0;
      amplitude7 = 0.0;
      amplitude8 = mapAudioAmp(amplitude8, 600, 100, 500);
      amplitude9 = 0.0;
      amplitude10 = 0.0;
      amplitude11 = 0.0;
      amplitude12 = 0.0;
    }
    if (solo9) {
      amplitude1 = 0.0;
      amplitude2 = 0.0;
      amplitude3 = 0.0;
      amplitude4 = 0.0;
      amplitude5 = 0.0;
      amplitude6 = 0.0;
      amplitude7 = 0.0;
      amplitude8 = 0.0;
      amplitude9 = mapAudioAmp(amplitude9, 400, 0, 160);
      amplitude10 = 0.0;
      amplitude11 = 0.0;
      amplitude12 = 0.0;
    }
    if (solo10) {
      amplitude1 = 0.0;
      amplitude2 = 0.0;
      amplitude3 = 0.0;
      amplitude4 = 0.0;
      amplitude5 = 0.0;
      amplitude6 = 0.0;
      amplitude7 = 0.0;
      amplitude8 = 0.0;
      amplitude9 = 0.0;
      amplitude10 = mapAudioAmp(amplitude10, 400, 200, -40);
      amplitude11 = 0.0;
      amplitude12 = 0.0;
    }
    if (solo11) {
      amplitude1 = 0.0;
      amplitude2 = 0.0;
      amplitude3 = 0.0;
      amplitude4 = 0.0;
      amplitude5 = 0.0;
      amplitude6 = 0.0;
      amplitude7 = 0.0;
      amplitude8 = 0.0;
      amplitude9 = 0.0;
      amplitude10 = 0.0;
      amplitude11 = mapAudioAmp(amplitude11, 400, 400, 160);
      amplitude12 = 0.0;
    }
    if (solo12) {
      amplitude1 = 0.0;
      amplitude2 =0.0;
      amplitude3 = 0.0;
      amplitude4 = 0.0;
      amplitude5 = 0.0;
      amplitude6 = 0.0;
      amplitude7 = 0.0;
      amplitude8 = 0.0;
      amplitude9 = 0.0;
      amplitude10 = 0.0;
      amplitude11 = 0.0;
      amplitude12 = mapAudioAmp(amplitude12, 500, 150, 360);
    }
}

/*************************************************************************************
 BUILT IN METHODS
 *************************************************************************************/

/**
 * When mouse is dragged
 **/
void mouseDragged() {
  // Check if mouseX/mouseY are in range of Cube center vertex
  if (inRange) {  
    if(startUserMode) {
    // Assign mX to mouseX but check edges
    if (mouseX > width) {
      mX = width;
    } else if (mouseX < 0) {
      mX = 0;
    } else {
      mX = mouseX;
    }
    // Assign mY to mouseY but check edges
    if (mouseY > height) {
      mY = height;
    } else if (mouseY < 0) {
      mY = 0;
    } else {
      mY = mouseY;
    }
    updateAmplitudes();
    } 
  }// CLOSE IN RANGE
} // CLOSE MOUSEDRAGGED



/**
 * When mouse is pressed check if it is within range of 
 * cube center vertex
 **/
void mousePressed() {
  // If within range toggle inRange
  if (abs(dist(mouseX, mouseY, mX, mY)) <= 20) {
    inRange = true;

    // Start looping audio on first valid cube vertex move
    // then turn off initiate cube
    if (!activateCube) {
      audio1.loop(); //Loop songOne
      audio2.loop();
      audio3.loop();
      audio4.loop();
      audio5.loop(); 
      audio6.loop();
      audio7.loop();
      audio8.loop();
      audio9.loop();
      audio10.loop();
      audio11.loop();
      audio12.loop();
      activateCube = true;
    }
  } else {
    inRange = false;
  }
}

/**
 * Check which key is released
 **/
void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      shiftPressed = false;
    }
  }
  if (key == CODED) {
    if (keyCode == CONTROL) {
      ctrlPressed = false;
    }
  }
}

void resetSettings() {
  if(startTutorialMode) {
     goToUserMode = true; 
     startTutorialMode = false;
     goToTutorialMode = false;
    }
    // Instructions to return Cube vertex to center
    cubeCentered = false;
    if(mX < 400) {
      xCubeToCenter = 0;
    } else {
      xCubeToCenter = 1;
    }
    if(mY < 360) {
      yCubeToCenter = 0;
    } else {
      yCubeToCenter = 1;
    }
    
    tutorialCounter = 0;
    showWire = false;
    showPulse = false;
    displayAudioSettings = false;
    pulseColor = 0;
    wireFrameColor = 0;

    audio1.stop(); // Stop all audio samples
    audio2.stop();
    audio3.stop();
    audio4.stop();
    audio5.stop(); 
    audio6.stop();
    audio7.stop();
    audio8.stop();
    audio9.stop();
    audio10.stop();
    audio11.stop();
    audio12.stop();

    amplitude1 = 0.0; // Reset all amplitudes to 0;
    amplitude2 = 0.0;
    amplitude3 = 0.0;
    amplitude4 = 0.0;
    amplitude5 = 0.0;
    amplitude6 = 0.0;
    amplitude7 = 0.0;
    amplitude8 = 0.0;
    amplitude9 = 0.0;
    amplitude10 = 0.0;
    amplitude11 = 0.0;
    amplitude12 = 0.0;
   

    activateCube = false; // Wait for Cube vertex movement to activate cube

    mute1 = false; // Set all mutes to false
    mute2 = false;
    mute3 = false;
    mute4 = false;
    mute5 = false;
    mute6 = false;
    mute7 = false;
    mute8 = false;
    mute9 = false;
    mute10 = false;
    mute11 = false;
    mute12 = false;
    solo1 = false; // Set all solos to false
    solo2 = false;
    solo3 = false;
    solo4 = false;
    solo5 = false;
    solo6 = false;
    solo7 = false;
    solo8 = false;
    solo9 = false;
    solo11 = false;
    solo12 = false;
    solo12 = false;

    showSoundSpace1 = false; // Stop showing all sound spaces
    showSoundSpace2 = false;
    showSoundSpace3 = false;
    showSoundSpace4 = false;
    showSoundSpace5 = false;
    showSoundSpace6 = false;
    showSoundSpace7 = false;
    showSoundSpace8 = false;
    showSoundSpace9 = false;
    showSoundSpace10 = false;
    showSoundSpace11 = false;
    showSoundSpace12 = false;

    muteGroup1 = false; // Set all mute groups to false
    muteGroup2 = false;
    muteGroup3 = false;

    //soloGroup1 = false; // Set all solo groups to false
    //soloGroup2 = false;
    //soloGroup3 = false;
} //END resetSettings

/**
 * Check which key is pressed and do action
 * KEY 'T' | tutorial mode
 
 *
 **/
void keyPressed() {
  //#TUT
  if(key == 't' || key == 'T') {
    if(goToTutorialMode == false) {
       goToTutorialMode = true;
       goToUserMode = false;
       startUserMode = false;
       resetSettings();
    }
    
   
  }
  //#FIX
  //if(key == 'x' || key == 'X') {
  // timer.startStop(); 
  //}
  if (key == CODED) {
    if (keyCode == SHIFT) {
      shiftPressed = true;
    }
  }

  if (key == CODED) {
    if (keyCode == CONTROL) {
      ctrlPressed = true;
    }
  }

  if (key == CODED) {
    if (keyCode == LEFT) {
      if(startUserMode) {
        if (shiftPressed) {
          //soloGroup1 = !soloGroup1;
          //if (soloGroup1) {
          //} else {
          //}
        } else {
          muteGroup1 = !muteGroup1;
          if (muteGroup1) {
            amplitude1 = 0.0;
            amplitude2 = 0.0;
            amplitude3 = 0.0;
            amplitude4 = 0.0;
            mute1 = true;
            mute2 = true;
            mute3 = true;
            mute4 = true;
          } else {
            mute1 = false;
            mute2 = false;
            mute3 = false;
            mute4 = false;
            amplitude1 = mapAudioAmp(amplitude1, 600, -200, -200);
            amplitude2 = mapAudioAmp(amplitude2, 600, 400, -200);
            amplitude3 = mapAudioAmp(amplitude3, 600, -200, 400);
            amplitude4 = mapAudioAmp(amplitude4, 600, 400, 400);
          }
        }
      }
    }
  }
  if (key == CODED) {
    if (keyCode == UP) {
      if(startUserMode) {
        if (shiftPressed) {
          //soloGroup2 = !soloGroup2;
        } else {
          muteGroup2 = !muteGroup2;
          if (muteGroup2) {
            amplitude5 = 0.0;
            amplitude6 = 0.0;
            amplitude7 = 0.0;
            amplitude8 = 0.0;
            mute5 = true;
            mute6 = true;
            mute7 = true;
            mute8 = true;
          } else {
            mute5 = false;
            mute6 = false;
            mute7 = false;
            mute8 = false;
            amplitude5 = mapAudioAmp(amplitude5, 600, -300, 100);
            amplitude6 = mapAudioAmp(amplitude6, 600, 100, -300);
            amplitude7 = mapAudioAmp(amplitude7, 600, 500, 100);
            amplitude8 = mapAudioAmp(amplitude8, 600, 100, 500);
          }
        }
      }
    }
  }
  if (key == CODED) {
    if (keyCode == RIGHT) {
      if(startTutorialMode) {
        if(canMoveNext) {
          tutorialCounter++;
          if(tutorialCounter > 11) {
            tutorialCounter = 0;
          }
          canMoveNext = false;
        }
      } else {
        if (shiftPressed) {
          //soloGroup3 = !soloGroup3;
        } else {
          muteGroup3 = !muteGroup3;
          if (muteGroup3) {
            amplitude9 = 0.0;
            amplitude10 = 0.0;
            amplitude11 = 0.0;
            amplitude12 = 0.0;
            mute9 = true;
            mute10 = true;
            mute11 = true;
            mute12 = true;
          } else {
            mute9 = false;
            mute10 = false;
            mute11 = false;
            mute12 = false;
            amplitude9 = mapAudioAmp(amplitude9, 400, 0, 160);
            amplitude10 = mapAudioAmp(amplitude10, 400, 200, -40);
            amplitude11 = mapAudioAmp(amplitude11, 400, 400, 160);
            amplitude12 = mapAudioAmp(amplitude12, 500, 150, 360);
            solo1 = false;
            solo2 = false;
            solo3 = false;
            solo4 = false;
            solo5 = false;
            solo6 = false;
            solo7 = false;
            solo8 = false;
            solo9 = false;
            solo10 = false;
            solo11 = false;
            solo12 = false;
          }
        }
      }
    }
  }

  // Toggle audio info settings
  if (key == ' ') {
    if(startUserMode) {
      displayAudioSettings = !displayAudioSettings;
    }
  }

  // RESET Cube center vertex to start position
  if (key == 'r' || key == 'R') {
    resetSettings();
  }
  
  // Shuffle audio
  if(key == 's' || key == 'S') {
   if(startUserMode) {
    audio1.stop(); // Stop all audio samples
    audio2.stop();
    audio3.stop();
    audio4.stop();
    audio5.stop(); 
    audio6.stop();
    audio7.stop();
    audio8.stop();
    audio9.stop();
    audio10.stop();
    audio11.stop();
    audio12.stop();
    
    randomizeList(numAudioTracks);
    //int rand = int(random(0, audioList.length));
    //println(rand);
    audio1 = new SoundFile(this, audioList[randomNumList[0]]); // shuffle audio
    audio2 = new SoundFile(this, audioList[randomNumList[1]]); 
    audio3 = new SoundFile(this, audioList[randomNumList[2]]);
    audio4 = new SoundFile(this, audioList[randomNumList[3]]);
    audio5 = new SoundFile(this, audioList[randomNumList[4]]); 
    audio6 = new SoundFile(this, audioList[randomNumList[5]]); 
    audio7 = new SoundFile(this, audioList[randomNumList[6]]);
    audio8 = new SoundFile(this, audioList[randomNumList[7]]);
    audio9 = new SoundFile(this, audioList[randomNumList[8]]);
    audio10 = new SoundFile(this, audioList[randomNumList[9]]);
    audio11 = new SoundFile(this, audioList[randomNumList[10]]); 
    audio12 = new SoundFile(this, audioList[randomNumList[11]]);
    
    audio1.loop(); // loop audio
    audio2.loop();
    audio3.loop();
    audio4.loop();
    audio5.loop(); 
    audio6.loop();
    audio7.loop();
    audio8.loop();
    audio9.loop();
    audio10.loop();
    audio11.loop();
    audio12.loop();
   }
  }

  // TOGGLE wire frame view
  if (key == 'w' || key == 'W') {
    if(startUserMode) {
      if (shiftPressed) {
        if (showWire) {
          wireFrameColor++;
          if (wireFrameColor > 3) {
            wireFrameColor = 0;
          }
        }
      } else {
        showWire = !showWire;
      }
    }
  }

  // TOGGLE pulse analyzer view
  if (key == 'p' || key == 'P') {
    if(startUserMode) {
      if (shiftPressed) {
        if (showPulse) {
          pulseColor++;
          if (pulseColor > 3) {
            pulseColor = 0;
          }
        }
      } else {
        showPulse = !showPulse;
      }
    }
  }
  // num: mute audio num
  // SHIFT + num: solo audio num
  // CTRL + num: show sound space num
  if (key == '1') {
    if(startUserMode) {
    if (shiftPressed) {
      solo1 = !solo1;
      if (solo1) {
        mute1 = false;
        amplitude1 = mapAudioAmp(amplitude1, 600, -200, -200);
        amplitude2 = 0.0;
        amplitude3 = 0.0;
        amplitude4 = 0.0;
        amplitude5 = 0.0;
        amplitude6 = 0.0;
        amplitude7 = 0.0;
        amplitude8 = 0.0;
        amplitude9 = 0.0;
        amplitude10 = 0.0;
        amplitude11 = 0.0;
        amplitude12 = 0.0;
        solo1 = true;
        mute2 = true;
        mute3 = true;
        mute4 = true;
        mute5 = true;
        mute6 = true;
        mute7 = true;
        mute8 = true;
        mute9 = true;
        mute10 = true;
        mute11 = true;
        mute12 = true;
      } else {
        amplitude1 = mapAudioAmp(amplitude1, 600, -200, -200);
        amplitude2 = mapAudioAmp(amplitude2, 600, 400, -200);
        amplitude3 = mapAudioAmp(amplitude3, 600, -200, 400);
        amplitude4 = mapAudioAmp(amplitude4, 600, 400, 400);
        amplitude5 = mapAudioAmp(amplitude5, 600, -300, 100);
        amplitude6 = mapAudioAmp(amplitude6, 600, 100, -300);
        amplitude7 = mapAudioAmp(amplitude7, 600, 500, 100);
        amplitude8 = mapAudioAmp(amplitude8, 600, 100, 500);
        amplitude9 = mapAudioAmp(amplitude9, 400, 0, 160);
        amplitude10 = mapAudioAmp(amplitude10, 400, 200, -40);
        amplitude11 = mapAudioAmp(amplitude11, 400, 400, 160);
        amplitude12 = mapAudioAmp(amplitude12, 500, 150, 360);
        solo1 = false;
        mute1 = false;
        mute2 = false;
        mute3 = false;
        mute4 = false;
        mute5 = false;
        mute6 = false;
        mute7 = false;
        mute8 = false;
        mute9 = false;
        mute10 = false;
        mute11 = false;
        mute12 = false;
      }
    } else if (ctrlPressed) {
      showSoundSpace1 = !showSoundSpace1;
    } else {  
      mute1 = !mute1;
      if (mute1) {
        amplitude1 = 0.0;
        solo1 = false;
      } else {
        amplitude1 = mapAudioAmp(amplitude1, 600, -200, -200);
      }
    }
    }
  }

  if (key == '2') {
    if(startUserMode) {
    if (shiftPressed) {
      solo2 = !solo2;
      if (solo2) {
        amplitude1 = 0.0;
        mute2 = false;
        amplitude2 = mapAudioAmp(amplitude2, 600, 400, -200);
        amplitude3 = 0.0;
        amplitude4 = 0.0;
        amplitude5 = 0.0;
        amplitude6 = 0.0;
        amplitude7 = 0.0;
        amplitude8 = 0.0;
        amplitude9 = 0.0;
        amplitude10 = 0.0;
        amplitude11 = 0.0;
        amplitude12 = 0.0;
        mute1 = true;
        solo2 = true;
        mute3 = true;
        mute4 = true;
        mute5 = true;
        mute6 = true;
        mute7 = true;
        mute8 = true;
        mute9 = true;
        mute10 = true;
        mute11 = true;
        mute12 = true;
      } else {
        amplitude1 = mapAudioAmp(amplitude1, 600, -200, -200);
        amplitude2 = mapAudioAmp(amplitude2, 600, 400, -200);
        amplitude3 = mapAudioAmp(amplitude3, 600, -200, 400);
        amplitude4 = mapAudioAmp(amplitude4, 600, 400, 400);
        amplitude5 = mapAudioAmp(amplitude5, 600, -300, 100);
        amplitude6 = mapAudioAmp(amplitude6, 600, 100, -300);
        amplitude7 = mapAudioAmp(amplitude7, 600, 500, 100);
        amplitude8 = mapAudioAmp(amplitude8, 600, 100, 500);
        amplitude9 = mapAudioAmp(amplitude9, 400, 0, 160);
        amplitude10 = mapAudioAmp(amplitude10, 400, 200, -40);
        amplitude11 = mapAudioAmp(amplitude11, 400, 400, 160);
        amplitude12 = mapAudioAmp(amplitude12, 500, 150, 360);
        mute1 = false;
        mute2 = false;
        solo2 = false;
        mute3 = false;
        mute4 = false;
        mute5 = false;
        mute6 = false;
        mute7 = false;
        mute8 = false;
        mute9 = false;
        mute10 = false;
        mute11 = false;
        mute12 = false;
      }
    } else if (ctrlPressed) {
      showSoundSpace2 = !showSoundSpace2;
    } else {  
      mute2 = !mute2;
      if (mute2) {
        amplitude2 = 0.0;
        solo2 = false;
      } else {
        amplitude2 = mapAudioAmp(amplitude2, 600, 400, -200);
      }
    }
    }
  }
  if (key == '3') {
    if(startUserMode) {
    if (shiftPressed) {
      solo3 = !solo3;
      if (solo3) {
        amplitude1 = 0.0;
        amplitude2 = 0.0;
        mute3 = false;
        amplitude3 = mapAudioAmp(amplitude3, 600, -200, 400);
        amplitude4 = 0.0;
        amplitude5 = 0.0;
        amplitude6 = 0.0;
        amplitude7 = 0.0;
        amplitude8 = 0.0;
        amplitude9 = 0.0;
        amplitude10 = 0.0;
        amplitude11 = 0.0;
        amplitude12 = 0.0;
        mute1 = true;
        mute2 = true;
        solo3 = true;
        mute4 = true;
        mute5 = true;
        mute6 = true;
        mute7 = true;
        mute8 = true;
        mute9 = true;
        mute10 = true;
        mute11 = true;
        mute12 = true;
      } else {
        amplitude1 = mapAudioAmp(amplitude1, 600, -200, -200);
        amplitude2 = mapAudioAmp(amplitude2, 600, 400, -200);
        amplitude3 = mapAudioAmp(amplitude3, 600, -200, 400);
        amplitude4 = mapAudioAmp(amplitude4, 600, 400, 400);
        amplitude5 = mapAudioAmp(amplitude5, 600, -300, 100);
        amplitude6 = mapAudioAmp(amplitude6, 600, 100, -300);
        amplitude7 = mapAudioAmp(amplitude7, 600, 500, 100);
        amplitude8 = mapAudioAmp(amplitude8, 600, 100, 500);
        amplitude9 = mapAudioAmp(amplitude9, 400, 0, 160);
        amplitude10 = mapAudioAmp(amplitude10, 400, 200, -40);
        amplitude11 = mapAudioAmp(amplitude11, 400, 400, 160);
        amplitude12 = mapAudioAmp(amplitude12, 500, 150, 360);
        mute1 = false;
        mute2 = false;
        mute3 = false;
        solo3 = false;
        mute4 = false;
        mute5 = false;
        mute6 = false;
        mute7 = false;
        mute8 = false;
        mute9 = false;
        mute10 = false;
        mute11 = false;
        mute12 = false;
      }
    } else if (ctrlPressed) {
      showSoundSpace3 = !showSoundSpace3;
    } else {  
      mute3 = !mute3;
      if (mute3) {
        amplitude3 = 0.0;
        solo3 = false;
      } else {
        amplitude3 = mapAudioAmp(amplitude3, 600, -200, 400);
        //amplitude4 = mapAudioAmp(amplitude4, 600, 400, 400);
      }
    }
    }
  }
  if (key == '4') {
    if(startUserMode) {
    if (shiftPressed) {
      solo4 = !solo4;
      if (solo4) {
        amplitude1 = 0.0;
        amplitude2 = 0.0;
        amplitude3 = 0.0;
        mute4 = false;
        amplitude4 = mapAudioAmp(amplitude4, 600, 400, 400);
        amplitude5 = 0.0;
        amplitude6 = 0.0;
        amplitude7 = 0.0;
        amplitude8 = 0.0;
        amplitude9 = 0.0;
        amplitude10 = 0.0;
        amplitude11 = 0.0;
        amplitude12 = 0.0;
        mute1 = true;
        mute2 = true;
        mute3 = true;
        solo4 = true;
        mute5 = true;
        mute6 = true;
        mute7 = true;
        mute8 = true;
        mute9 = true;
        mute10 = true;
        mute11 = true;
        mute12 = true;
      } else {
        amplitude1 = mapAudioAmp(amplitude1, 600, -200, -200);
        amplitude2 = mapAudioAmp(amplitude2, 600, 400, -200);
        amplitude3 = mapAudioAmp(amplitude3, 600, -200, 400);
        amplitude4 = mapAudioAmp(amplitude4, 600, 400, 400);
        amplitude5 = mapAudioAmp(amplitude5, 600, -300, 100);
        amplitude6 = mapAudioAmp(amplitude6, 600, 100, -300);
        amplitude7 = mapAudioAmp(amplitude7, 600, 500, 100);
        amplitude8 = mapAudioAmp(amplitude8, 600, 100, 500);
        amplitude9 = mapAudioAmp(amplitude9, 400, 0, 160);
        amplitude10 = mapAudioAmp(amplitude10, 400, 200, -40);
        amplitude11 = mapAudioAmp(amplitude11, 400, 400, 160);
        amplitude12 = mapAudioAmp(amplitude12, 500, 150, 360);
        mute1 = false;
        mute2 = false;
        mute3 = false;
        mute4 = false;
        solo4 = false;
        mute5 = false;
        mute6 = false;
        mute7 = false;
        mute8 = false;
        mute9 = false;
        mute10 = false;
        mute11 = false;
        mute12 = false;
      }
    } else if (ctrlPressed) {
      showSoundSpace4 = !showSoundSpace4;
    } else {  
      mute4 = !mute4;
      if (mute4) {
        amplitude4 = 0.0;
        solo4 = false;
      } else {
        amplitude4 = mapAudioAmp(amplitude4, 600, 400, 400);
      }
    }
    }
  }
  if (key == '5') {
    if(startUserMode) {
    if (shiftPressed) {
      solo5 = !solo5;
      if (solo5) {
        amplitude1 = 0.0;
        amplitude2 = 0.0;
        amplitude3 = 0.0;
        amplitude4 = 0.0;
        mute5 = false;
        amplitude5 = mapAudioAmp(amplitude5, 600, -300, 100);
        amplitude6 = 0.0;
        amplitude7 = 0.0;
        amplitude8 = 0.0;
        amplitude9 = 0.0;
        amplitude10 = 0.0;
        amplitude11 = 0.0;
        amplitude12 = 0.0;
        mute1 = true;
        mute2 = true;
        mute3 = true;
        mute4 = true;
        solo5 = true;
        mute6 = true;
        mute7 = true;
        mute8 = true;
        mute9 = true;
        mute10 = true;
        mute11 = true;
        mute12 = true;
      } else {
        amplitude1 = mapAudioAmp(amplitude1, 600, -200, -200);
        amplitude2 = mapAudioAmp(amplitude2, 600, 400, -200);
        amplitude3 = mapAudioAmp(amplitude3, 600, -200, 400);
        amplitude4 = mapAudioAmp(amplitude4, 600, 400, 400);
        amplitude5 = mapAudioAmp(amplitude5, 600, -300, 100);
        amplitude6 = mapAudioAmp(amplitude6, 600, 100, -300);
        amplitude7 = mapAudioAmp(amplitude7, 600, 500, 100);
        amplitude8 = mapAudioAmp(amplitude8, 600, 100, 500);
        amplitude9 = mapAudioAmp(amplitude9, 400, 0, 160);
        amplitude10 = mapAudioAmp(amplitude10, 400, 200, -40);
        amplitude11 = mapAudioAmp(amplitude11, 400, 400, 160);
        amplitude12 = mapAudioAmp(amplitude12, 500, 150, 360);
        mute1 = false;
        mute2 = false;
        mute3 = false;
        mute4 = false;
        mute5 = false;
        solo5 = false;
        mute6 = false;
        mute7 = false;
        mute8 = false;
        mute9 = false;
        mute10 = false;
        mute11 = false;
        mute12 = false;
      }
    } else if (ctrlPressed) {
      showSoundSpace5 = !showSoundSpace5;
    } else {  
      mute5 = !mute5;
      if (mute5) {
        amplitude5 = 0.0;
        solo5 = false;
      } else {
        amplitude5 = mapAudioAmp(amplitude5, 600, -300, 100);
      }
    }
    }
  }
  if (key == '6') {
    if(startUserMode) {
    if (shiftPressed) {
      solo6 = !solo6;
      if (solo6) {
        amplitude1 = 0.0;
        amplitude2 = 0.0;
        amplitude3 = 0.0;
        amplitude4 = 0.0;
        amplitude5 = 0.0;
        mute6 = false;
        amplitude6 = mapAudioAmp(amplitude6, 600, 100, -300);
        amplitude7 = 0.0;
        amplitude8 = 0.0;
        amplitude9 = 0.0;
        amplitude10 = 0.0;
        amplitude11 = 0.0;
        amplitude12 = 0.0;
        mute1 = true;
        mute2 = true;
        mute3 = true;
        mute4 = true;
        mute5 = true;
        solo6 = true;
        mute7 = true;
        mute8 = true;
        mute9 = true;
        mute10 = true;
        mute11 = true;
        mute12 = true;
      } else {
        amplitude1 = mapAudioAmp(amplitude1, 600, -200, -200);
        amplitude2 = mapAudioAmp(amplitude2, 600, 400, -200);
        amplitude3 = mapAudioAmp(amplitude3, 600, -200, 400);
        amplitude4 = mapAudioAmp(amplitude4, 600, 400, 400);
        amplitude5 = mapAudioAmp(amplitude5, 600, -300, 100);
        amplitude6 = mapAudioAmp(amplitude6, 600, 100, -300);
        amplitude7 = mapAudioAmp(amplitude7, 600, 500, 100);
        amplitude8 = mapAudioAmp(amplitude8, 600, 100, 500);
        amplitude9 = mapAudioAmp(amplitude9, 400, 0, 160);
        amplitude10 = mapAudioAmp(amplitude10, 400, 200, -40);
        amplitude11 = mapAudioAmp(amplitude11, 400, 400, 160);
        amplitude12 = mapAudioAmp(amplitude12, 500, 150, 360);
        mute1 = false;
        mute2 = false;
        mute3 = false;
        mute4 = false;
        mute5 = false;
        mute6 = false;
        solo6 = false;
        mute7 = false;
        mute8 = false;
        mute9 = false;
        mute10 = false;
        mute11 = false;
        mute12 = false;
      }
    } else if (ctrlPressed) {
      showSoundSpace6 = !showSoundSpace6;
    } else {  
      mute6 = !mute6;
      if (mute6) {
        amplitude6 = 0.0;
        solo6 = false;
      } else {
        amplitude6 = mapAudioAmp(amplitude6, 600, 100, -300);
      }
    }
    }
  }
  if (key == '7') {
    if(startUserMode) {
    if (shiftPressed) {
      solo7 = !solo7;
      if (solo7) {
        amplitude1 = 0.0;
        amplitude2 = 0.0;
        amplitude3 = 0.0;
        amplitude4 = 0.0;
        amplitude5 = 0.0;
        amplitude6 = 0.0;
        mute7 = false;
        amplitude7 = mapAudioAmp(amplitude7, 600, 500, 100);
        amplitude8 = 0.0;
        amplitude9 = 0.0;
        amplitude10 = 0.0;
        amplitude11 = 0.0;
        amplitude12 = 0.0;
        mute1 = true;
        mute2 = true;
        mute3 = true;
        mute4 = true;
        mute5 = true;
        mute6 = true;
        solo7 = true;
        mute8 = true;
        mute9 = true;
        mute10 = true;
        mute11 = true;
        mute12 = true;
      } else {
        amplitude1 = mapAudioAmp(amplitude1, 600, -200, -200);
        amplitude2 = mapAudioAmp(amplitude2, 600, 400, -200);
        amplitude3 = mapAudioAmp(amplitude3, 600, -200, 400);
        amplitude4 = mapAudioAmp(amplitude4, 600, 400, 400);
        amplitude5 = mapAudioAmp(amplitude5, 600, -300, 100);
        amplitude6 = mapAudioAmp(amplitude6, 600, 100, -300);
        amplitude7 = mapAudioAmp(amplitude7, 600, 500, 100);
        amplitude8 = mapAudioAmp(amplitude8, 600, 100, 500);
        amplitude9 = mapAudioAmp(amplitude9, 400, 0, 160);
        amplitude10 = mapAudioAmp(amplitude10, 400, 200, -40);
        amplitude11 = mapAudioAmp(amplitude11, 400, 400, 160);
        amplitude12 = mapAudioAmp(amplitude12, 500, 150, 360);
        mute1 = false;
        mute2 = false;
        mute3 = false;
        mute4 = false;
        mute5 = false;
        mute6 = false;
        mute7 = false;
        solo7 = false;
        mute8 = false;
        mute9 = false;
        mute10 = false;
        mute11 = false;
        mute12 = false;
      }
    } else if (ctrlPressed) {
      showSoundSpace7 = !showSoundSpace7;
    } else {  
      mute7 = !mute7;
      if (mute7) {
        amplitude7 = 0.0;
        solo7 = false;
      } else {
        amplitude7 = mapAudioAmp(amplitude7, 600, 500, 100);
      }
    }
    }
  }
  if (key == '8') {
    if(startUserMode) {
    if (shiftPressed) {
      solo8 = !solo8;
      if (solo8) {
        amplitude1 = 0.0;
        amplitude2 = 0.0;
        amplitude3 = 0.0;
        amplitude4 = 0.0;
        amplitude5 = 0.0;
        amplitude6 = 0.0;
        amplitude7 = 0.0;
        mute8 = false;
        amplitude8 = mapAudioAmp(amplitude8, 600, 100, 500);
        amplitude9 = 0.0;
        amplitude10 = 0.0;
        amplitude11 = 0.0;
        amplitude12 = 0.0;
        mute1 = true;
        mute2 = true;
        mute3 = true;
        mute4 = true;
        mute5 = true;
        mute6 = true;
        mute7 = true;
        solo8 = true;
        mute9 = true;
        mute10 = true;
        mute11 = true;
        mute12 = true;
      } else {
        amplitude1 = mapAudioAmp(amplitude1, 600, -200, -200);
        amplitude2 = mapAudioAmp(amplitude2, 600, 400, -200);
        amplitude3 = mapAudioAmp(amplitude3, 600, -200, 400);
        amplitude4 = mapAudioAmp(amplitude4, 600, 400, 400);
        amplitude5 = mapAudioAmp(amplitude5, 600, -300, 100);
        amplitude6 = mapAudioAmp(amplitude6, 600, 100, -300);
        amplitude7 = mapAudioAmp(amplitude7, 600, 500, 100);
        amplitude8 = mapAudioAmp(amplitude8, 600, 100, 500);
        amplitude9 = mapAudioAmp(amplitude9, 400, 0, 160);
        amplitude10 = mapAudioAmp(amplitude10, 400, 200, -40);
        amplitude11 = mapAudioAmp(amplitude11, 400, 400, 160);
        amplitude12 = mapAudioAmp(amplitude12, 500, 150, 360);
        mute1 = false;
        mute2 = false;
        mute3 = false;
        mute4 = false;
        mute5 = false;
        mute6 = false;
        mute7 = false;
        mute8 = false;
        solo8 = false;
        mute9 = false;
        mute10 = false;
        mute11 = false;
        mute12 = false;
      }
    } else if (ctrlPressed) {
      showSoundSpace8 = !showSoundSpace8;
    } else {  
      mute8 = !mute8;
      if (mute8) {
        amplitude8 = 0.0;
        solo8 = false;
      } else {
        amplitude8 = mapAudioAmp(amplitude8, 600, 100, 500);
      }
    }
    }
  }
  if (key == '9') {
    if(startUserMode) {
    if (shiftPressed) {
      solo9 = !solo9;
      if (solo9) {
        amplitude1 = 0.0;
        amplitude2 = 0.0;
        amplitude3 = 0.0;
        amplitude4 = 0.0;
        amplitude5 = 0.0;
        amplitude6 = 0.0;
        amplitude7 = 0.0;
        amplitude8 = 0.0;
        mute9 = false;
        amplitude9 = mapAudioAmp(amplitude9, 400, 0, 160);
        amplitude10 = 0.0;
        amplitude11 = 0.0;
        amplitude12 = 0.0;
        mute1 = true;
        mute2 = true;
        mute3 = true;
        mute4 = true;
        mute5 = true;
        mute6 = true;
        mute7 = true;
        mute8 = true;
        solo9 = true;
        mute10 = true;
        mute11 = true;
        mute12 = true;
      } else {
        amplitude1 = mapAudioAmp(amplitude1, 600, -200, -200);
        amplitude2 = mapAudioAmp(amplitude2, 600, 400, -200);
        amplitude3 = mapAudioAmp(amplitude3, 600, -200, 400);
        amplitude4 = mapAudioAmp(amplitude4, 600, 400, 400);
        amplitude5 = mapAudioAmp(amplitude5, 600, -300, 100);
        amplitude6 = mapAudioAmp(amplitude6, 600, 100, -300);
        amplitude7 = mapAudioAmp(amplitude7, 600, 500, 100);
        amplitude8 = mapAudioAmp(amplitude8, 600, 100, 500);
        amplitude9 = mapAudioAmp(amplitude9, 400, 0, 160);
        amplitude10 = mapAudioAmp(amplitude10, 400, 200, -40);
        amplitude11 = mapAudioAmp(amplitude11, 400, 400, 160);
        amplitude12 = mapAudioAmp(amplitude12, 500, 150, 360);
        mute1 = false;
        mute2 = false;
        mute3 = false;
        mute4 = false;
        mute5 = false;
        mute6 = false;
        mute7 = false;
        mute8 = false;
        mute9 = false;
        solo9 = false;
        mute10 = false;
        mute11 = false;
        mute12 = false;
      }
    } else if (ctrlPressed) {
      showSoundSpace9 = !showSoundSpace9;
    } else {  
      mute9 = !mute9;
      if (mute9) {
        amplitude9 = 0.0;
        solo9 = false;
      } else {
        amplitude9 = mapAudioAmp(amplitude9, 400, 0, 160);
      }
    }
    }
  }
  if (key == '0') {
    if(startUserMode) {
    if (shiftPressed) {
      solo10 = !solo10;
      if (solo10) {
        amplitude1 = 0.0;
        amplitude2 = 0.0;
        amplitude3 = 0.0;
        amplitude4 = 0.0;
        amplitude5 = 0.0;
        amplitude6 = 0.0;
        amplitude7 = 0.0;
        amplitude8 = 0.0;
        amplitude9 = 0.0;
        mute10 = false;
        amplitude10 = mapAudioAmp(amplitude10, 400, 200, -40);
        amplitude11 = 0.0;
        amplitude12 = 0.0;
        mute1 = true;
        mute2 = true;
        mute3 = true;
        mute4 = true;
        mute5 = true;
        mute6 = true;
        mute7 = true;
        mute8 = true;
        mute9 = true;
        solo10 = true;
        mute11 = true;
        mute12 = true;
      } else {
        amplitude1 = mapAudioAmp(amplitude1, 600, -200, -200);
        amplitude2 = mapAudioAmp(amplitude2, 600, 400, -200);
        amplitude3 = mapAudioAmp(amplitude3, 600, -200, 400);
        amplitude4 = mapAudioAmp(amplitude4, 600, 400, 400);
        amplitude5 = mapAudioAmp(amplitude5, 600, -300, 100);
        amplitude6 = mapAudioAmp(amplitude6, 600, 100, -300);
        amplitude7 = mapAudioAmp(amplitude7, 600, 500, 100);
        amplitude8 = mapAudioAmp(amplitude8, 600, 100, 500);
        amplitude9 = mapAudioAmp(amplitude9, 400, 0, 160);
        amplitude10 = mapAudioAmp(amplitude10, 400, 200, -40);
        amplitude11 = mapAudioAmp(amplitude11, 400, 400, 160);
        amplitude12 = mapAudioAmp(amplitude12, 500, 150, 360);
        mute1 = false;
        mute2 = false;
        mute3 = false;
        mute4 = false;
        mute5 = false;
        mute6 = false;
        mute7 = false;
        mute8 = false;
        mute9 = false;
        mute10 = false;
        solo10 = false;
        mute11 = false;
        mute12 = false;
      }
    } else if (ctrlPressed) {
      showSoundSpace10 = !showSoundSpace10;
    } else {  
      mute10 = !mute10;
      if (mute10) {
        amplitude10 = 0.0;
        solo10 = false;
      } else {
        amplitude10 = mapAudioAmp(amplitude10, 400, 200, -40);
      }
    }
    }
  }
  if (key == '-') {
    if(startUserMode) {
    if (shiftPressed) {
      solo11 = !solo11;
      if (solo11) {
        amplitude1 = 0.0;
        amplitude2 = 0.0;
        amplitude3 = 0.0;
        amplitude4 = 0.0;
        amplitude5 = 0.0;
        amplitude6 = 0.0;
        amplitude7 = 0.0;
        amplitude8 = 0.0;
        amplitude9 = 0.0;
        amplitude10 = 0.0;
        mute11 = false;
        amplitude11 = mapAudioAmp(amplitude11, 400, 400, 160);
        amplitude12 = 0.0;
        mute1 = true;
        mute2 = true;
        mute3 = true;
        mute4 = true;
        mute5 = true;
        mute6 = true;
        mute7 = true;
        mute8 = true;
        mute9 = true;
        mute10 = true;
        solo11 = true;
        mute12 = true;
      } else {
        amplitude1 = mapAudioAmp(amplitude1, 600, -200, -200);
        amplitude2 = mapAudioAmp(amplitude2, 600, 400, -200);
        amplitude3 = mapAudioAmp(amplitude3, 600, -200, 400);
        amplitude4 = mapAudioAmp(amplitude4, 600, 400, 400);
        amplitude5 = mapAudioAmp(amplitude5, 600, -300, 100);
        amplitude6 = mapAudioAmp(amplitude6, 600, 100, -300);
        amplitude7 = mapAudioAmp(amplitude7, 600, 500, 100);
        amplitude8 = mapAudioAmp(amplitude8, 600, 100, 500);
        amplitude9 = mapAudioAmp(amplitude9, 400, 0, 160);
        amplitude10 = mapAudioAmp(amplitude10, 400, 200, -40);
        amplitude11 = mapAudioAmp(amplitude11, 400, 400, 160);
        amplitude12 = mapAudioAmp(amplitude12, 500, 150, 360);
        mute1 = false;
        mute2 = false;
        mute3 = false;
        mute4 = false;
        mute5 = false;
        mute6 = false;
        mute7 = false;
        mute8 = false;
        mute9 = false;
        mute10 = false;
        mute11 = false;
        solo11 = false;
        mute12 = false;
      }
    } else if (ctrlPressed) {
      showSoundSpace11 = !showSoundSpace11;
    } else {  
      mute11 = !mute11;
      if (mute11) {
        amplitude11 = 0.0;
        solo11 = false;
      } else {
        amplitude11 = mapAudioAmp(amplitude11, 400, 400, 160);
      }
    }
    }
  }
  if (key == '=') {
    if(startUserMode) {
    if (shiftPressed) {
      solo12 = !solo12;
      if (solo12) {
        amplitude1 = 0.0;
        amplitude2 = 0.0;
        amplitude3 = 0.0;
        amplitude4 = 0.0;
        amplitude5 = 0.0;
        amplitude6 = 0.0;
        amplitude7 = 0.0;
        amplitude8 = 0.0;
        amplitude9 = 0.0;
        amplitude10 = 0.0;
        amplitude11 = 0.0;
        mute12 = false;
        amplitude12 = mapAudioAmp(amplitude12, 500, 150, 360);
        mute1 = true;
        mute2 = true;
        mute3 = true;
        mute4 = true;
        mute5 = true;
        mute6 = true;
        mute7 = true;
        mute8 = true;
        mute9 = true;
        mute10 = true;
        mute11 = true;
        solo12 = true;
      } else {
        amplitude1 = mapAudioAmp(amplitude1, 600, -200, -200);
        amplitude2 = mapAudioAmp(amplitude2, 600, 400, -200);
        amplitude3 = mapAudioAmp(amplitude3, 600, -200, 400);
        amplitude4 = mapAudioAmp(amplitude4, 600, 400, 400);
        amplitude5 = mapAudioAmp(amplitude5, 600, -300, 100);
        amplitude6 = mapAudioAmp(amplitude6, 600, 100, -300);
        amplitude7 = mapAudioAmp(amplitude7, 600, 500, 100);
        amplitude8 = mapAudioAmp(amplitude8, 600, 100, 500);
        amplitude9 = mapAudioAmp(amplitude9, 400, 0, 160);
        amplitude10 = mapAudioAmp(amplitude10, 400, 200, -40);
        amplitude11 = mapAudioAmp(amplitude11, 400, 400, 160);
        amplitude12 = mapAudioAmp(amplitude12, 500, 150, 360);
        mute1 = false;
        mute2 = false;
        mute3 = false;
        mute4 = false;
        mute5 = false;
        mute6 = false;
        mute7 = false;
        mute8 = false;
        mute9 = false;
        mute10 = false;
        mute11 = false;
        mute12 = false;
        solo12 = false;
      }
    } else if (ctrlPressed) {
      showSoundSpace12 = !showSoundSpace12;
    } else {  
      mute12 = !mute12;
      if (mute12) {
        amplitude12 = 0.0;
        solo12 = false;
      } else {
        amplitude12 = mapAudioAmp(amplitude12, 500, 150, 360);
      }
    }
    }
  }
}

/*************************************************************************************
 MY CLASS
 *************************************************************************************/

/**
  * Timer class that counts time
 **/
class Timer {
  int millisecs;
  int seconds;
  int minutes;
  boolean start;
  boolean starter;
  
  Timer() {
    start = false;
  }
  
  void display() {
    //textAlign(CENTER);
    fill(255);
    textSize(15);
    text(nf(minutes, 2) + ":" + nf(seconds, 2) + "." + nf(millisecs, 1) , width/2, height/2);
  }
  
  void run() {
    if(start) {
    if (int(millis()/100)  % 10 != millisecs){
    millisecs++;
    
    }
    if (millisecs >= 10){
      millisecs -= 10;
      seconds++;
    }
    if (seconds >= 60){
      seconds -= 60;
      minutes++;
    }
    }
  }
  
  void startStop() {
    if(start == false){
      starter = true;
    }
    if(start == true){
      starter = false;
    }
  start = starter;
    
  }
  
  void reset() {
   millisecs = 0;
    seconds = 0;
    minutes = 0; 
  }
  
  void pause() {
    if(key == ' '){
    millisecs = 0;
    seconds = 0;
    minutes = 0;
  }
  }
}
