/******************************************************************************
 Project:  messing around with an image reveal idea. this uses a boost
           from the amplitude of a song/audio source.
 
 Author:   Yahir
 Date:     July 2019
 
 Notes:    processing 3.5.4 
 
 ******************************************************************************/
import processing.sound.*;

SoundFile song;             // song file object
Amplitude amp;              // amplitude

PImage image;               // image object
float songAmp;              // store current song amplitude
float songAmpMap;           // mapped value of song amplitude to control analyzer size
float songAmpMapPrior;      // prior mapped song amp value to compare peaks
float analyzerFadeSpeed;    // the analyzer fade or shrink speed
int offsetX;                // shift the grid and image placement in x direction
int offsetY;                // shift the grid and image placement in y direction
int gridSize;               // size of pixelated grid
float sensativity;          // sensativity for song/audio in
ArrayList<PVector> gridList;      // hold x, y position for invidivudal grid
ArrayList<PVector> gridRevealSpd; // hold elements to control reveal speed

/******************************************************************************
 * 
 * setup method
 * 
 *****************************************************************************/
void setup() {
  size(1000, 1000);
  
  // load image and song
  image = loadImage(IMAGE_PATH);
  image.resize(800, 800);
  song = new SoundFile(this, SONG_PATH);
  //in = new AudioIn(this, 0);
  amp = new Amplitude(this);
  
  // global stuff
  offsetX = (width - image.width) / 2;
  offsetY = (height - image.height) / 2;
  songAmp = 0.0; 
  gridSize = 100; 
  songAmpMap = 0.1; 
  songAmpMapPrior = 0.0;
  analyzerFadeSpeed = .5;
  sensativity = 1.0;

  // generate grid
  gridList = new ArrayList<PVector>();
  gridRevealSpd = new ArrayList<PVector>();
  for (int x = 0; x < image.width; x += gridSize) {
    for (int y = 0; y < image.height; y += gridSize) {
      gridList.add(new PVector(x, y, 255));
      gridRevealSpd.add(new PVector(random(0.1, 1), 2));
    }
  }
  
  // loop song and amp    
  song.play();
  amp.input(song);
}

/******************************************************************************
 * 
 * draw method
 * 
 *****************************************************************************/
void draw() {
  background(243, 248, 251);
  image(image, offsetX, offsetY);

  // Assign amplitude of song to songAmp variable
  songAmp = amp.analyze();
  
  // Remap songeAmp to analyzer diameter
  songAmpMap = map(songAmp, 0.0, sensativity, 0, 100);

  //// Compare songAmpMap value to the prior songAmpMap value
  //// to create slower pulsing analyzer that increases with amp
  //// otherwise it shrinks
  if (songAmpMap > songAmpMapPrior) {
    songAmpMapPrior = songAmpMap;
  } else {  
    // No new amplitude peak measured so
    // begin lowering songAmpMap value
    songAmpMapPrior -= analyzerFadeSpeed;
    if(songAmpMapPrior < 0) songAmpMapPrior = 0;
    songAmpMap = songAmpMapPrior;
  }
  
  // Cycle through image1 in
  // blocks in size of gridSize
  int numInGrid = gridSize * gridSize;
  for (int x = 0; x < image.width; x+= gridSize) {
    for (int y = 0; y < image.height; y+= gridSize) {
      // Store the red, green and blue 
      // values for all pixels
      float rv = 0;
      float gv = 0;
      float bv = 0;
      
      
      // sum values within grid to find average
      for (int px = x; px < x + gridSize; px++) {
        for (int py = y; py < y + gridSize; py++) {
          int pIndex = px + py * image.width;
          // Sum the all of the red, green and blue
          // values for each pixel in block of size gridSize
          rv += red(image.pixels[pIndex]);
          gv += green(image.pixels[pIndex]);
          bv += blue(image.pixels[pIndex]);
        }
      }

      // Display rectangle of size gridSize
      // and set fill color to the average of all
      // red, green, and blue values within block of size gridSize
      for (int i = 0; i < gridList.size(); i++) {
        if (x == int(gridList.get(i).x) && y == int(gridList.get(i).y)) {
          fill(rv/numInGrid, gv/numInGrid, bv/numInGrid, gridList.get(i).z - songAmpMap);
        }
      }       
      noStroke();
      rect(x + offsetX, y + offsetY, gridSize, gridSize);
    }
  }
  
  // update reveal spead for each grid
  for (int i = 0; i < gridRevealSpd.size(); i++) {    
    gridList.get(i).z += gridRevealSpd.get(i).x;
    if (gridList.get(i).z < 100 || gridList.get(i).z > 255) {
      gridRevealSpd.get(i).x *= -1;
    }
  }
  
  // visualize amp for testing
  //stroke(255);
  //noFill();
  //ellipse(500, 500, songAmpMap, songAmpMap);
}

/******************************************************************************
 * 
 * key pressed
 * 
 * UP    | increase sensativity
 * DOWN  | decrease sensativity
 *****************************************************************************/
void keyPressed() {
 if(key == CODED) {
   if(keyCode == UP) {
     sensativity += .05;
     if(sensativity > 5.0) sensativity = 5.0;
   }
   if(keyCode == DOWN) {
     sensativity -= .05;
     if(sensativity < 0) sensativity = 0;
   }
 }
}
