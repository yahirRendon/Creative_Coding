/**************************************************************
 Project:  My interpretation of a circular audio visualizer 
           inspired by an image I saw online.
           This specific sketch is a modification of a prior
           sketch which introduces a moving amplitude around the circle
 Author:   Yahir
 Date:     July 2021
 
 Notes:
 1. Run Sketch
 2. You can swap out audio files in the data folder and update code
 3. Play with ring parameters to get desired outcome
 
 **************************************************************/

import ddf.minim.analysis.*;
import ddf.minim.*;

Minim       minim;
AudioPlayer song;
FFT         fft;

PFont myFont;

String songName = "Dreams";                                      // name of the song
String songAuthor = "bensound.com";                              // author of the song
String songFile = "bensound-dreams";                             // control smoothness in ring audio peaks

ArrayList<PVector> colors = new ArrayList<PVector>();            // hold colors (hue, saturation, brightness)
ArrayList<PVector> frequencies = new ArrayList<PVector>();       // hold list of frequences bands (min band, max band, sensativity)
ArrayList<Ring> rings = new ArrayList<Ring>();                   // hold list of visualizer rings


/**************************************************************
 SET UP METHOD
 **************************************************************/
void setup() {
  size(1600, 1600);
  smooth(8);
  colorMode(HSB, 360, 100, 100, 100);
  
  delay(3000);
  
  // change font
  myFont = createFont("Roboto Light", 80);
  textFont(myFont);
  
  // populate the list of colors
  colors.add(new PVector(323, 17, 96));    // pink
  colors.add(new PVector(37, 26, 100));    // orange
  colors.add(new PVector(260, 24, 100));   // purple
  colors.add(new PVector(207, 32, 100));   // blue

  // populate the list of frequencies/sensativity
  frequencies.add(new PVector(20, 50, 80)); // sub bass
  frequencies.add(new PVector(200, 600, 50)); // bass
  frequencies.add(new PVector(250, 1000, 20)); // low mids
  frequencies.add(new PVector(1000, 2000, 10)); // mids
  frequencies.add(new PVector(3000, 6000, 5)); // high mids
  frequencies.add(new PVector(6000, 20000, 5)); // high
 
  PVector pos = new PVector(800, 800);
  
  // add ring to rings list with desired features
  rings.add(new Ring(pos.x, pos.y));
  rings.get(0).setColor(color(colors.get(0).x, colors.get(0).y, colors.get(0).z));
  rings.get(0).setFreqRange(int(frequencies.get(1).x), int(frequencies.get(1).y), int(frequencies.get(1).z));
  
  rings.add(new Ring(pos.x, pos.y));
  rings.get(1).setColor(color(colors.get(1).x, colors.get(1).y, colors.get(1).z));
  rings.get(1).setFreqRange(int(frequencies.get(0).x), int(frequencies.get(0).y), int(frequencies.get(0).z));
  
  rings.add(new Ring(pos.x, pos.y));
  rings.get(2).setColor(color(colors.get(2).x, colors.get(2).y, colors.get(2).z));
  rings.get(2).setFreqRange(int(frequencies.get(3).x), int(frequencies.get(3).y), int(frequencies.get(3).z));
  
  rings.add(new Ring(pos.x, pos.y));
  rings.get(3).setColor(color(colors.get(3).x, colors.get(3).y, colors.get(3).z));
  rings.get(3).setFreqRange(int(frequencies.get(4).x), int(frequencies.get(4).y), int(frequencies.get(4).z));
        
  // initialize minim
  minim = new Minim(this);

  // set audio buffer of AudioPlayer for FFT. 
  song = minim.loadFile(songFile + ".mp3", 1024);

  // play the song
  song.play();

  fft = new FFT( song.bufferSize(), song.sampleRate() );

  // for sketches that don't update the background
  background(0, 0, 100);
}

/**************************************************************
 DRAW METHOD
 **************************************************************/
void draw() {
  background(0, 0, 100);
  
  // pass song into fft
  fft.forward(song.mix );
  
  // display song and info text
  fill(0, 0, 75);
  textAlign(CENTER, CENTER);
  textSize(80);
  text(songName, 800, 770);
  textSize(30);
  text("from " + songAuthor, 800, 840);
   
  fill(0, 0, 60);
  textAlign(RIGHT);
  textSize(30);
  text("Visuals by Yahir", 1550, 1550);
  
  // Display the rings
  for (Ring r : rings) {
    r.display();
  }
  rings.get(3).displayFade();
  
}

/**************************************************************
 KEY PRESSED
 
 - S key saves current frame into output folder
 **************************************************************/
void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame("output/VisRingGrid_" + songFile + "_######.png");
  }
}

/**************************************************************
 Class for creating a ring visualizer
 A frequency range is selected and an average amplitude is 
 calculated. This value is mapped to the outter vertices of a
 ring and displayed through time as it moves through the angles
 of a circle. 
 **************************************************************/
class Ring {
  PVector pos = new PVector();                           // center of ring
  ArrayList<PVector> big = new ArrayList<PVector>();     // vertices for outer ring
  ArrayList<PVector> small = new ArrayList<PVector>();   // vertices for inner ring
  ArrayList<Float> frequencies = new ArrayList<Float>(); // hold frequencies for smoothing

  float freqAvg;            // the calculated frequencey average
  float ringSize;           // the size of the ring (inner ring)
  float radius;             // the chanign radius of outter ring
  float angle;              // move through the angles of a circle
  float angleReset;         // value the begins removing vertices from ring
  float angleSpeed;         // how quickly we move through the angle values
  float freqMin;            // the lower bound of frequencies in band
  float freqMax;            // the higher boudn of frequencies in band
  float freqSensativity;    // how reactive the frequency average will respond
  float mapMax;             // the max reaction value when mapping frequency average
  color ringColer;          // set the ring color
  float freqAvgLast;        // store last value of the frequency avg
  float freqAvgCurrent;     // track current value of frequency avg

  /**
   * Constructor method for Ring class
   *
   * @param {float} x    the x position of ring (center)
   * @param {float} y    the y position of ring (center)
   */
  Ring(float _x, float _y) {
    pos = new PVector(_x, _y);
    //ringSize = int(random(50, 200)); // for random ring size
    ringSize = 150; 
    ringSize = 400;
    radius = 0;
    angle = int(random(0, 720));
    angleReset = angle + int(random(125, 315)); // for random length of ring
    //angleReset = angle + 360;
    angleSpeed = random(.5, 1);
    freqMin = 0;
    freqMax = 600;
    freqSensativity = 100;
    freqAvgLast = -1;
    freqAvgCurrent = 0;
    mapMax = random(300, 400);
    ringColer = color(200, 20, 100);
  }

  /**
   * Set the color of the the ring
   *
   * @param {color} _c   the color of the ring
   */
  void setColor(color _c) {
    ringColer = _c;
  }

  /**
   * set the frequency range for the ring and sensativity value
   *
   * @param {int} _min    the lower bound of the frequency band
   * @param {int} _max    the upper bound of the frequncy band
   * @param {int} _sens   the sensativity value (lower more sensative)
   */
  void setFreqRange(int _min, int _max, int _sens) {
    freqMin = _min;
    freqMax = _max;
    freqSensativity = _sens;
  }

  /**
   * display the ring
   */
  void display() {

    // store frequence amp average for band 
    freqAvg = fft.calcAvg(freqMin, freqMax);

    // limit reading to sensativity value
    if (freqAvg > freqSensativity) {
      freqAvg = freqSensativity;
    }

    // tracking jumps in amplitude for flicker effect
    freqAvgCurrent = freqAvg;
    if (freqAvgCurrent > freqAvgLast) {
      freqAvgLast = freqAvgCurrent;
    } else {
      freqAvgLast -= .1; 
      if (freqAvgLast < 0) {
        freqAvgLast = 0;
      }
    }

    // loop through frequencies and sample frequencies in chunks for
    // smoothing out peaks. 
    float beatOffset = map(freqAvg, 0, freqSensativity, 0, mapMax);
    float rad = 0;
    frequencies.add(new Float(beatOffset));

    if (frequencies.size() > 10) {
      frequencies.remove(0);
      for (int i = 0; i < frequencies.size(); i++) {
        rad += frequencies.get(i);
      }
      radius = rad / frequencies.size(); // fix this
      float bigX = pos.x + cos(radians(angle)) * (ringSize + radius);
      float bigY = pos.y + sin(radians(angle)) * (ringSize + radius);
      float smallX = pos.x + cos(radians(angle)) * (ringSize);
      float smallY = pos.y + sin(radians(angle)) * (ringSize);

      // add the smooth vertices to big and small cirlces
      big.add(new PVector(bigX, bigY));
      small.add(new PVector(smallX, smallY));

      // move through angles of circle
      angle += angleSpeed;
      if (angle > angleReset) {
        big.remove(0);
        small.remove(0);
      }
    }

    // map the amount of boost to saturation with amplitude jumps
    float fmap = map(freqAvgLast, 0, freqSensativity, 0, 50);
    fill(hue(ringColer), saturation(ringColer) + fmap, brightness(ringColer), 80);

    // create rings by looping through big/outer circle and adding vertices
    // to beginShape. loop through small/inner circle backwards to create a
    // smooth shape
    noStroke();
    beginShape();
    for (int i = 0; i < big.size(); i++) {
      // more smoothing
      if (i > 5 && i < big.size() - 5) {
        float newX = 0;
        float newY = 0;
        int counter = 0;
        for (int j = i - 5; j < i + 5; j++) {
          newX += big.get(j).x;
          newY += big.get(j).y;
          counter++;
        }
        newX = newX/counter;
        newY = newY/counter;
        vertex(newX, newY);
      }
    }

    // reverse loop wih smoothing
    for (int i = small.size() - 1; i >= 0; i--) {
      if (i > 5 && i < big.size() - 5) {
        float newX = 0;
        float newY = 0;
        int counter = 0;
        for (int j = i - 5; j < i + 5; j++) {
          newX += small.get(j).x;
          newY += small.get(j).y;
          counter++;
        }
        newX = newX/counter;
        newY = newY/counter;
        vertex(newX, newY);
      }
    }
    endShape(CLOSE); 

  }
  
  /**
   * display the inner ring fade feature
   */
  void displayFade() {  
    int fmap = int(map(fft.calcAvg(0, 3000), 0, 20, 5, 30));
    for (int t = 0; t < fmap; t++) {
      float fade = map(t, 0, fmap, 100, 0);
      fill(hue(ringColer), saturation(ringColer), brightness(ringColer), fade);
      beginShape();
      for (int i = 0; i < 361; i++) {
        float x = pos.x - cos(radians(i)) * ((ringSize + 1) - (t));
        float y = pos.y - sin(radians(i)) * ((ringSize + 1) - (t));
        vertex(x, y);
      }
      for (int i = 360; i >=0; i--) {
        float x = pos.x - cos(radians(i)) * ((ringSize + 1) - (t * 2));
        float y = pos.y - sin(radians(i)) * ((ringSize + 1) - (t * 2));
        vertex(x, y);
      }
      endShape();
    } 
  }
}
