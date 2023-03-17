/******************************************************************************
 Project:  messing around with an image reveal idea. This maps the radius of
 a circle to the amplitude and pixels within the circle slowly change alpha.
 
 Author:   Yahir
 Date:     July 2019
 
 Notes:    processing 3.5.4 
 
 ******************************************************************************/
import processing.sound.*;

SoundFile song;             // song file object
Amplitude amp;              // amplitude

PImage image;               // image object
PImage canvas;              // image object for creative pixelation grid
float songAmp;              // store current song amplitude
float songAmpMap;           // mapped value of song amplitude to control analyzer size
float songAmpMapPrior;      // prior mapped song amp value to compare peaks
float analyzerFadeSpeed;    // the analyzer fade or shrink speed
int offsetX;                // shift the grid and image placement in x direction
int offsetY;                // shift the grid and image placement in y direction
int gridSize;               // size of pixelated grid
double delayTimer;          // track time for delay 
int delayAmt;               // the amount of delay time to slow alpha changes
boolean active;             // check if alpha values can be updated given delay
int maxAmp;                 // the max amplitude value when remapping
boolean showAmp;            // toggle showing visualization of mapped amp value
float opacity;              // Reveal opacity
float opacitySpeed;         // Reveal opacity speed


/******************************************************************************
 * 
 * setup method
 * 
 *****************************************************************************/
void setup() {
  size(1000, 1000);

  // load image and song
  String path = "../data/";
  image = loadImage(path + "ryan-moreno-CAQV_lXm_iw-unsplash.jpg");
  image.resize(700, 700);
  //path = "C:/Users/yahir/Downloads/data/audio/music/";
  song = new SoundFile(this, path + "grandbrothers_bloodflow.wav");
  amp = new Amplitude(this);

  // global stuff
  offsetX = (width - image.width) / 2;
  offsetY = (height - image.height) / 2;
  songAmp = 0.0; 
  gridSize = 20; 
  songAmpMap = 0.1; 
  songAmpMapPrior = 0.0;
  analyzerFadeSpeed = 1;

  opacity = 1;
  opacitySpeed = .00001;

  maxAmp = width/2;

  // Cycle through image1 in
  // blocks in size of gridSize
  canvas = createImage(image.width, image.height, ARGB);
  //pxls = new ArrayList<Pxl>();
  int numInGrid = gridSize * gridSize;
  for (int y = 0; y < image.height; y+= gridSize) {
    for (int x = 0; x < image.width; x+= gridSize) {

      // sum color value for each grid
      float rv = 0;
      float gv = 0;
      float bv = 0;
      for (int py = y; py < y + gridSize; py++) {
        for (int px = x; px < x + gridSize; px++) {
          int pIndex = px + py * image.width;
          // Store the red, green and blue 
          // values for all pixels
          rv += red(image.pixels[pIndex]);
          gv += green(image.pixels[pIndex]);
          bv += blue(image.pixels[pIndex]);
          canvas.pixels[pIndex] = color(rv, gv, bv, 255);
        }
      }

      // calc average given grid area
      rv = rv/numInGrid;
      gv = gv/numInGrid;
      bv = bv/numInGrid;

      // update canvas pixels
      for (int py = y; py < y + gridSize; py++) {
        for (int px = x; px < x + gridSize; px++) {
          int pIndex = px + py * image.width;

          canvas.pixels[pIndex] = color(rv, gv, bv, 255);
        }
      }
    }
  }

  // loop song and amp
  amp.input(song);
  song.play();

  delayTimer = millis();
  delayAmt = 2000;
}

/******************************************************************************
 * 
 * draw method
 * 
 *****************************************************************************/
void draw() {
  background(234, 236, 239);
  strokeWeight(1);

  // Assign amplitude of song to songAmp variable
  songAmp = amp.analyze(); 
  songAmpMap = map(songAmp, 0.0, 1.0, 0, maxAmp);


  // Compare songAmpMap value to the prior songAmpMap value
  // to create slower pulsing analyzer that increases with amp
  // otherwise it shrinks
  if (songAmpMap > songAmpMapPrior) {
    songAmpMapPrior = songAmpMap;
  } else {  
    // No new amplitude peak measured so
    // begin lowering songAmpMap value
    songAmpMapPrior -= analyzerFadeSpeed;
    songAmpMap = songAmpMapPrior;
  }

  image(image, offsetX, offsetY);
  image(canvas, offsetX, offsetX);


  if (millis() > delayTimer + delayAmt) {
    delayTimer = millis();
    active = true;
  } else {
    active = false;
  }

  //// Cycle through each pixel in the appropriate
  //// image dimensions (width and height)
  if (active) {
    canvas.loadPixels();
    for (int y = 0; y < canvas.height; y++) {
      for (int x = 0; x < canvas.width; x++) {
        int index = x + y * canvas.width;

        if (dist(x, y, 500 - (offsetX), 500 - (offsetY)) < songAmpMap) {  
          // Update the appropriate pixels with the true red, green, and blue
          // values along with opacity value
          float rv = red(canvas.pixels[index]);
          float gv = green(canvas.pixels[index]);
          float bv = blue(canvas.pixels[index]);
          float av = alpha(canvas.pixels[index]) - opacitySpeed;
          canvas.pixels[index] = color(rv, gv, bv, av);
        }
      }
    }

    canvas.updatePixels();
  }

  // show amplitude visually
  if (showAmp) {
    noFill();
    stroke(255);
    ellipse(500, 500, songAmpMap*2, songAmpMap*2);
  }
}

/******************************************************************************
 * 
 * key pressed
 * 
 * SPACE    | toggle showing amp ring
 *****************************************************************************/
void keyPressed() {
  if (key == ' ') {
    showAmp = !showAmp;
  }
}

