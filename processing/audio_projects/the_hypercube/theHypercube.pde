/**************************************************************
 Project:  Variation of The Cube project that uses a hypercube.
           Dimiension 0 uses the standard sound space mapping
           feature that can be navigated by dragging the center
           vertex of the cube. The higer dimension, 1, has audio
           effects that can be engaged by moving the center
           vertex. Additionally, a piano can be played via click
           or keystrokes. 
              
 Author:  Yahir 
 Date:    April 2020

 Notes:
          - Processing 3.5.4
          
 Instructions: Click and drag vertex to explore sounds and effects
 
 UP   | Cycle through dimensions 0 and 1
 DOWN | hide the hyper cube
 LEFT | toggle auto play
 TAB   | Show sound spaces
 SPACE | Show sound space info
 1 - 0, -, = | Mute sound space
 SHIFT + 1   | Mute sound space group 1
 SHIFT + 2   | Mute sound space group 2
 SHIFT + 3   | Mute sound space group 3
 
 Dimension 1:
 Control Piano via keys: A W S E D F T G Y H U J
 Vertex controls delay settings
                      
 **************************************************************/

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import java.util.*;
import processing.sound.*;

Minim minim;                              
AudioOutput out;
Summer mix;
ddf.minim.ugens.Delay delay;

HyperCube hCube;                    // Hyper cube object
SoundSpace spaceDimension1;         // Soundspace alt dimension
Piano piano;                        // Piano object for sampled key board

ArrayList<Sampler> notes;           // List of piano note samples
ArrayList<Square> squares;          // List of falling squares in background
ArrayList<Amplitude> amplitudes;    // List of Amplitude objects. For each audio sample
ArrayList<SoundSpace> spaces;       // List of SoundSpace objects. Dectataes sample amplitude and span vlaues
ArrayList<SoundFile> samples;       // List of SoundFile objects. holds sound smaples
ArrayList<Meter> meters;            // List of meter objects. display stem amplitudes

PImage backgroundC, backgroundD;    // color background image (D1) and dark background image (D2)
float alphaBack;                    // control background image alpha
int numStems;                       // number of sample stems in spaces

boolean initialRun;                 // toggle things on initial moves
boolean showSoundSpaces;            // toggle display sound space ranges
boolean showMeters;                 // toggle showing meters and keyboard
boolean showHyperCube;              // toggle displaying hpyer cube
boolean autoPlayEngaged;            // toggle engaging autoplay
boolean group1Mute;                 // toggle muting group 1 samples
boolean group2Mute;                 // toggle muting group 1 samples
boolean group3Mute;                 // toggle muting group 1 samples

boolean shiftPressed;               // toggle when shift key is pressed
boolean controlPressed;             // toggle when control key is pressed

/***********************************************************
 ************* SETUP METHOD ********************************
 ***********************************************************/
void setup() {
  size(1000, 1000, FX2D);

  // run initialize setup method
  initSetup();
}

/***********************************************************
 ************* DRAW METHOD *********************************
 ***********************************************************/
void draw() {
  backgroundVisualsDisplay();

  // display and update hybercube
  hCube.display();
  hCube.update();

  // loop through soundspaces and update corresponding
  // amplitude values in samples
  for (SoundSpace s : spaces) {
    s.updateAmp(mouseX, mouseY);    
    samples.get(s.locNum).amp(s.getAmp());
    if (hCube.dimension == 0 && showSoundSpaces) {
      s.display();
    }
  }

  if (hCube.dimension == 1 && showMeters) {
    piano.display();
  }

  // update and display meter values for each audio sample
  for (Meter m : meters) {
    m.update(amplitudes.get(m.sampleNum));
    m.display(hCube.dimension);
  }

  // simple representation of the dimension 1 grid values
  spaceDimension1.updateAmp(mouseX, mouseY);
  delay.setDelTime(map(spaceDimension1.getValx(), 200, 800, 0.01, 0.4));
  delay.setDelAmp(map(spaceDimension1.getValy(), 200, 800, 0.0, 0.75));
  //rect(500, 900, spaceDimension1.getValx(), spaceDimension1.getValy());
  if (hCube.dimension == 1 && showSoundSpaces) {
    spaceDimension1.display();
  }
}


/**************************************************************
 MOUSE DRAGGED FUNCTION
 **************************************************************/
void mouseDragged() { 
  if (hCube.inRange() && !hCube.transforming && showHyperCube) {   
    hCube.engaged = true;
    switch(hCube.dimension) {
    case 1:
      // move and map the values of a1 and a2 vertex when dragged
      hCube.a1.x = map(mouseX, 0, 1000, 250, 750);
      hCube.a1.y = map(mouseY, 0, 1000, 250, 750);
      hCube.a2.x = mouseX;
      hCube.a2.y = mouseY;

      // update and save the dim 1 a vertex of in and outer cube
      hCube.dim1aOut = new PVector(hCube.a2.x, hCube.a2.y);
      hCube.dim1aIn = new PVector(hCube.a1.x, hCube.a1.y);
      break;
    default:  
      loadSoundFiles();
      // move and map the values of a1 and a2 vertex when dragged
      hCube.a1.x = mouseX;
      hCube.a1.y = mouseY;
      hCube.a2.x = map(mouseX, 0, 1000, 250, 750);
      hCube.a2.y = map(mouseY, 0, 1000, 250, 750);
      // update and save the dim 0 a vertex of in and outer cube
      hCube.dim2aOut = new PVector(hCube.a1.x, hCube.a1.y);
      hCube.dim2aIn = new PVector(hCube.a2.x, hCube.a2.y);
      break;
    }
  }
}

/**************************************************************
 MOUSE RELEASED FUNCTION
 **************************************************************/
void mouseReleased() {
  // when mouse released disengage
  hCube.engaged = false;
  if (piano.active() && showMeters) {
    // if I do mouse keyboard
  }
}

/**************************************************************
 KEY PRESSED FUNCTION
 

 UP   | Cycle through dimensions 0 and 1
 DOWN | hide the hyper cube
 LEFT | toggle auto play
 
 TAB   | Show sound spaces
 SPACE | Show sound space info
 1 - 0, -, = | Mute sound space
 SHIFT + 1   | Mute sound space group 1
 SHIFT + 2   | Mute sound space group 2
 SHIFT + 3   | Mute sound space group 3
 
 Dimension 1:
 Control Piano via keys: A W S E D F T G Y H U J
 
 **************************************************************/
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      hCube.transforming = true;  
      hCube.dimension++;
      if (hCube.dimension > 1) {
        hCube.dimension = 0;
      }
      if (hCube.dimension == 0) {
        // update and save the dim 1 a vertex of in and outer cube
        hCube.dim1aOut = new PVector(hCube.a2.x, hCube.a2.y);
        hCube.dim1aIn = new PVector(hCube.a1.x, hCube.a1.y);
      } else {
        // update and save the dim 0 a vertex of in and outer cube
        hCube.dim2aOut = new PVector(hCube.a1.x, hCube.a1.y);
        hCube.dim2aIn = new PVector(hCube.a2.x, hCube.a2.y);
      }
    }
    if (keyCode == DOWN) {
      showHyperCube = !showHyperCube;
    }
    if (keyCode == LEFT) {
      if (hCube.dimension == 0) {
        loadSoundFiles();
        autoPlayEngaged = !autoPlayEngaged;
      }
    }
    if (keyCode == SHIFT) {
      shiftPressed = true;
    }
    if (keyCode == CONTROL) {
      controlPressed = true;
    }
  }

  // Toggle showing spaces
  if (key == TAB) {
    showSoundSpaces = !showSoundSpaces;
  }

  // Toggle showing meters
  if (key == ' ') {
    showMeters = !showMeters;
  }

  // Control mutes of audios
  if (key == '1') {
    if (!shiftPressed) {
      spaces.get(0).mute = !spaces.get(0).mute;       
      spaces.get(0).amp = spaces.get(0).getAmplitude(hCube.dim2aOut.x, hCube.dim2aOut.y);
    } else {
      group1Mute = !group1Mute;
      groupUpdate(1);
    }
  }
  if (key == '2') {
    if (!shiftPressed) {
      spaces.get(1).mute = !spaces.get(1).mute;
      spaces.get(1).amp = spaces.get(1).getAmplitude(hCube.dim2aOut.x, hCube.dim2aOut.y);
    } else {
      group2Mute = !group2Mute;
      groupUpdate(2);
    }
  }
  if (key == '3') {
    if (!shiftPressed) {
      spaces.get(2).mute = !spaces.get(2).mute;
      spaces.get(2).amp = spaces.get(2).getAmplitude(hCube.dim2aOut.x, hCube.dim2aOut.y);
    } else {
      group3Mute = !group3Mute;
      groupUpdate(3);
    }
  }
  if (key == '4') {
    if (!shiftPressed) {
      spaces.get(3).mute = !spaces.get(3).mute;
      spaces.get(3).amp = spaces.get(3).getAmplitude(hCube.dim2aOut.x, hCube.dim2aOut.y);
    }
  } 
  if (key == '5') {
    if (!shiftPressed) {
      spaces.get(4).mute = !spaces.get(4).mute;
      spaces.get(4).amp = spaces.get(4).getAmplitude(hCube.dim2aOut.x, hCube.dim2aOut.y);
    }
  } 
  if (key == '6') {
    if (!shiftPressed) {
      spaces.get(5).mute = !spaces.get(5).mute;
      spaces.get(5).amp = spaces.get(5).getAmplitude(hCube.dim2aOut.x, hCube.dim2aOut.y);
    }
  }
  if (key == '7') {
    if (!shiftPressed) {
      spaces.get(6).mute = !spaces.get(6).mute;
      spaces.get(6).amp = spaces.get(6).getAmplitude(hCube.dim2aOut.x, hCube.dim2aOut.y);
    }
  } 
  if (key == '8') {
    if (!shiftPressed) {
      spaces.get(7).mute = !spaces.get(7).mute;
      spaces.get(7).amp = spaces.get(7).getAmplitude(hCube.dim2aOut.x, hCube.dim2aOut.y);
    }
  }
  if (key == '9') {
    if (!shiftPressed) {
      spaces.get(8).mute = !spaces.get(8).mute;
      spaces.get(8).amp = spaces.get(8).getAmplitude(hCube.dim2aOut.x, hCube.dim2aOut.y);
    }
  } 
  if (key == '0') {
    if (!shiftPressed) {
      spaces.get(9).mute = !spaces.get(9).mute;
      spaces.get(9).amp = spaces.get(9).getAmplitude(hCube.dim2aOut.x, hCube.dim2aOut.y);
    }
  }  
  if (key == '-') {
    if (!shiftPressed) {
      spaces.get(10).mute = !spaces.get(10).mute;
      spaces.get(10).amp = spaces.get(10).getAmplitude(hCube.dim2aOut.x, hCube.dim2aOut.y);
    }
  }
  if (key == '=') {
    if (!shiftPressed) {
      spaces.get(11).mute = !spaces.get(11).mute;
      spaces.get(11).amp = spaces.get(11).getAmplitude(hCube.dim2aOut.x, hCube.dim2aOut.y);
    }
  }

  // Sampled piano control
  if (key == 'a' || key == 'A') {
    if (hCube.dimension == 1) {
      piano.noteC3 = true;
      notes.get(0).trigger();
    }
  }
  if (key == 'w' || key == 'W') {
    if (hCube.dimension == 1) {
      piano.noteCS3 = true;
      notes.get(1).trigger();
    }
  }

  if (key == 's' || key == 'S') {
    if (hCube.dimension == 1) {
      piano.noteD3 = true;
      notes.get(2).trigger();
    }
  }
  if (key == 'e' || key == 'E') {
    if (hCube.dimension == 1) {
      piano.noteDS3 = true;
      notes.get(3).trigger();
    }
  }
  if (key == 'd' || key == 'D') {
    if (hCube.dimension == 1) {
      piano.noteE3 = true;
      notes.get(4).trigger();
    }
  }
  if (key == 'f' || key == 'F') {
    if (hCube.dimension == 1) {
      piano.noteF3 = true;
      notes.get(5).trigger();
    }
  }
  if (key == 't' || key == 'T') {
    if (hCube.dimension == 1) {
      piano.noteFS3 = true;
      notes.get(6).trigger();
    }
  } 
  if (key == 'g' || key == 'G') {
    if (hCube.dimension == 1) {
      piano.noteG3 = true;
      notes.get(7).trigger();
    }
  } 
  if (key == 'y' || key == 'Y') {
    if (hCube.dimension == 1) {
      piano.noteGS3 = true;
      notes.get(8).trigger();
    }
  }
  if (key == 'h' || key == 'H') {
    if (hCube.dimension == 1) {
      piano.noteA3 = true;
      notes.get(9).trigger();
    }
  }
  if (key == 'u' || key == 'U') {
    if (hCube.dimension == 1) {
      piano.noteAS3 = true;
      notes.get(10).trigger();
    }
  } 
  if (key == 'j' || key == 'J') {
    if (hCube.dimension == 1) {
      piano.noteB3 = true;
      notes.get(11).trigger();
    }
  }
}

/**************************************************************
 KEY RELEASED FUNCTION
 **************************************************************/
void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      shiftPressed = false;
    }   
    if (keyCode == CONTROL) {
      controlPressed = false;
    }
  }

  // Sampled piano control
  if (key == 'a' || key == 'A') {
    piano.noteC3 = false;
  }
  if (key == 'w' || key == 'W') {
    piano.noteCS3 = false;
  }
  if (key == 's' || key == 'S') {
    piano.noteD3 = false;
  }
  if (key == 'e' || key == 'E') {
    piano.noteDS3 = false;
  }
  if (key == 'd' || key == 'D') {
    piano.noteE3 = false;
  }
  if (key == 'f' || key == 'F') {
    piano.noteF3 = false;
  }
  if (key == 't' || key == 'T') {
    piano.noteFS3 = false;
  }
  if (key == 'g' || key == 'G') {
    piano.noteG3 = false;
  }
  if (key == 'y' || key == 'Y') {
    piano.noteGS3 = false;
  }
  if (key == 'h' || key == 'H') {
    piano.noteA3 = false;
  }
  if (key == 'u' || key == 'U') {
    piano.noteAS3 = false;
  }
  if (key == 'j' || key == 'J') {
    piano.noteB3 = false;
  }
}

/*
* Display Background visuals
 * Background Image
 * Squares
 */
void backgroundVisualsDisplay() {
  // Display dark background
  image(backgroundD, 0, 0);

  // Load color background pixels
  backgroundC.loadPixels();

  // calculate in/out color background value
  if (hCube.dimension == 0) {
    alphaBack += easeAmt(alphaBack, 255);
    if (alphaBack > 254) {
      alphaBack = 255;
    }
  } else {
    alphaBack += easeAmt(alphaBack, 0);
    if (alphaBack < 2) {
      alphaBack = 1;
    }
  }

  // update pixel values
  for (int i = 0; i < backgroundC.pixels.length; i++) {
    backgroundC.pixels[i] = color(red(backgroundC.pixels[i]), green(backgroundC.pixels[i]), blue(backgroundC.pixels[i]), alphaBack);
  }

  // update color background pixels
  backgroundC.updatePixels();

  // display color background pixels
  image(backgroundC, 0, 0);

  // loop through squares and control shimmer effect
  for (Square s : squares) {
    s.shimmer = map(amplitudes.get(s.soundAmp).analyze(), 0, 1, 10, 100) * 2;
    s.update();
    s.display();
    if (s.edge()) {
      s.reset((int(random(0, numStems))));
    }
  }
}

/*
* Initialize objects and variables in setup
 */

void initSetup() {
  notes = new ArrayList<Sampler>();
  squares = new ArrayList<Square>();
  amplitudes = new ArrayList<Amplitude>();
  spaces = new ArrayList<SoundSpace>(); 
  samples = new ArrayList<SoundFile>();
  meters = new ArrayList<Meter>();    
  alphaBack = 255;              // control background image alpha
  numStems = 12;                // number of sample stems in spaces

  initialRun = true;            // toggle things on initial moves
  showHyperCube = true;         // toggle displaying hpyer cube

  // Load backgroudn images
  backgroundC = loadImage("IMAGE");
  backgroundD = loadImage("IMAGE");

  // Initialize hypercube
  hCube = new HyperCube(500.0, 460.0); 

  // Initialize piano 
  piano = new Piano();  

  // initialize amp analyzer objects and input sound files  
  for (int i = 0; i < 80; i++) {
    //squares.add(new Square(int(random(-5, 1005)), int(random(-1005, -20)), int(random(10, 50)), int(random(0, 4)))); 
    squares.add(new Square(int(random(0, numStems))));
  }

  // Add spaces to populate various regions within window
  spaces.add(new SoundSpace(100, 250, 600, 0));
  spaces.add(new SoundSpace(900, 250, 600, 1));
  spaces.add(new SoundSpace(100, 850, 600, 2));
  spaces.add(new SoundSpace(900, 850, 600, 3));
  spaces.add(new SoundSpace(300, 300, 400, 4));
  spaces.add(new SoundSpace(700, 300, 400, 5));
  spaces.add(new SoundSpace(300, 700, 600, 6));
  spaces.add(new SoundSpace(700, 700, 600, 7));
  spaces.add(new SoundSpace(500, 200, 500, 8));
  spaces.add(new SoundSpace(500, 800, 500, 9));
  spaces.add(new SoundSpace(400, 500, 600, 10));
  spaces.add(new SoundSpace(600, 500, 600, 11));

  // Create dimension 1 sound space
  spaceDimension1 = new SoundSpace(500, 460, 1000, 0);

  // Add meters display to meters list
  meters.add(new Meter(300, 800, 0));
  meters.add(new Meter(380, 800, 1));
  meters.add(new Meter(460, 800, 2));
  meters.add(new Meter(540, 800, 3));
  meters.add(new Meter(620, 800, 4));
  meters.add(new Meter(700, 800, 5));
  meters.add(new Meter(300, 900, 6));
  meters.add(new Meter(380, 900, 7));
  meters.add(new Meter(460, 900, 8));
  meters.add(new Meter(540, 900, 9));
  meters.add(new Meter(620, 900, 10));
  meters.add(new Meter(700, 900, 11));

  // Add sound files to samples list and begin loop
  samples.add(new SoundFile(this, "SOUND"));
  samples.add(new SoundFile(this, "SOUND"));
  samples.add(new SoundFile(this, "SOUND"));
  samples.add(new SoundFile(this, "SOUND"));
  samples.add(new SoundFile(this, "SOUND"));
  samples.add(new SoundFile(this, "SOUND"));
  samples.add(new SoundFile(this, "SOUND"));
  samples.add(new SoundFile(this, "SOUND"));
  samples.add(new SoundFile(this, "SOUND")); 
  samples.add(new SoundFile(this, "SOUND"));
  samples.add(new SoundFile(this, "SOUND"));
  samples.add(new SoundFile(this, "SOUND"));

  // Add Amplitude objects to amplitudes list and assign input
  for (int i = 0; i < numStems; i++ ) {
    amplitudes.add(new Amplitude(this));
    amplitudes.get(i).input(samples.get(i));
  } 

  // Initialze minim objects for piano
  minim = new Minim(this);
  mix = new Summer();  
  delay = new ddf.minim.ugens.Delay(0.4, 0.5, true); //time, amplitude factor, feedback
  out = minim.getLineOut();

  // Add piano notes to notes list for sampled piano
  notes.add(new Sampler("SAMPLE", 1, minim));
  notes.add(new Sampler("SAMPLE", 1, minim));
  notes.add(new Sampler("SAMPLE", 1, minim));
  notes.add(new Sampler("SAMPLE", 1, minim));
  notes.add(new Sampler("SAMPLE", 1, minim));
  notes.add(new Sampler("SAMPLE", 1, minim));
  notes.add(new Sampler("SAMPLE", 1, minim));
  notes.add(new Sampler("SAMPLE", 1, minim));
  notes.add(new Sampler("SAMPLE", 1, minim));
  notes.add(new Sampler("SAMPLE", 1, minim));
  notes.add(new Sampler("SAMPLE", 1, minim));
  notes.add(new Sampler("SAMPLE", 1, minim));

  // patch sampled piano notes into mix
  notes.get(0).patch(mix);
  notes.get(1).patch(mix);
  notes.get(2).patch(mix);
  notes.get(3).patch(mix);
  notes.get(4).patch(mix);
  notes.get(5).patch(mix);
  notes.get(6).patch(mix);
  notes.get(7).patch(mix);
  notes.get(8).patch(mix);
  notes.get(9).patch(mix);
  notes.get(10).patch(mix);
  notes.get(11).patch(mix);

  // patch delay and out
  mix.patch(delay).patch(out);
}

/*
* Load the sound stems files
 */
void loadSoundFiles() {
  if (initialRun) {
    for (SoundFile s : samples) {
      s.loop();
    }
    initialRun = false;
  }
}


/*
*  Method for control group mutes
 * @PARAM Int is the group to mute
 */
void groupUpdate(int group) {
  for (SoundSpace s : spaces) {
    switch(group) {
    case 1:
      if (group1Mute) {
        if (s.locNum < 4) {
          s.mute = true;
        }
      } else {
        if (s.locNum < 4) {
          s.mute = false;
        }
      }
      break;
    case 2:
      if (group2Mute) {
        if (s.locNum > 3 && s.locNum < 8) {
          s.mute = true;
        }
      } else {
        if (s.locNum > 3 && s.locNum < 8) {
          s.mute = false;
        }
      }
      break;
    case 3:
      if (group3Mute) {
        if (s.locNum > 7) {
          s.mute = true;
        }
      } else {
        if (s.locNum > 7) {
          s.mute = false;
        }
      }
      break;
    default:
      break;
    }
    s.amp = s.getAmplitude(hCube.dim2aOut.x, hCube.dim2aOut.y);
  }
}

// calculate and return analyzer value
float analyzer() {
  float avg = (amplitudes.get(0).analyze() + amplitudes.get(1).analyze()) / 2;
  return map(avg, 0, 1, 100, 500);
  //return map(amplyzer1.analyze(), 0, 1, 100, 500);
}

// calculate easing values
float easeAmt(float start, float target) {
  float dx = target - start;
  return dx * 0.05;
}
