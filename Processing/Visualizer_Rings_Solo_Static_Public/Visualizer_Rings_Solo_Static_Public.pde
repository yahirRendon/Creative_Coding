/**************************************************************
 Project:  My interpretation of a circular/ring audio visualizer 
           inspired by an image I saw online
           This specific sketch has fixed angle to frequency bands
 Author:   Yahir
 Date:     July 2021
 
 Notes:
 1. Run Sketch
 2. You can swap out audio files in the data folder and update code
 3. Play with smoothAmount or ring parameters to get desired outcome
 
 **************************************************************/

import ddf.minim.analysis.*;
import ddf.minim.*;

Minim       minim;
AudioPlayer song;
FFT         fft;

String songName = "Slow Motion";          // name of the song
String songAuthor = "bensound.com";       // author of the song
String songFile = "bensound-slowmotion";  // name of the file for the song
int SmoothAmount = 20;                    // control smoothness in ring audio peaks

PFont myFont;
ArrayList<Ring> rings;                    // list of ring objects

/**************************************************************
 SET UP METHOD
 **************************************************************/
void setup() {
  size(1600, 1600);
  smooth(8);
  colorMode(HSB, 360, 100, 100, 100);
  
  delay(3000);

  // change font
  myFont = createFont("Roboto Light", 60);
  textFont(myFont);

  // initialize minim
  minim = new Minim(this);

  // set audio buffer of AudioPlayer for FFT. 
  song = minim.loadFile(songFile +".mp3", 1024);

  // play the song
  song.play();

  // initialize fft with song
  fft = new FFT( song.bufferSize(), song.sampleRate() );

  rings = new ArrayList<Ring>();
  
  // add rings to list x, y, angle offset, frequency start, show fade
  rings.add(new Ring(800, 800, 270, 800, false));
  rings.add(new Ring(800, 800, 180, 1000, false));
  rings.add(new Ring(800, 800, 90, 600, true));

  // update ring colors
  rings.get(1).ringColor = color(51, 87, 96);  // yellow
  rings.get(2).ringColor = color(359, 66, 98); // red
  rings.get(0).ringColor = color(183, 99, 74); // blue
}

/**************************************************************
 DRAW METHOD
 **************************************************************/
void draw() {
  background(0, 0, 0);
  
  // pass song into fft
  fft.forward(song.mix);
  
  // display song and info text
  fill(0, 0, 75);
  textAlign(CENTER, CENTER);
  textSize(80);
  text(songName, 800, 770);
  textSize(30);
  text("from " + songAuthor, 800, 840);

  fill(0, 0, 80);
  textAlign(RIGHT);
  textSize(30);
  text("Visuals by Yahir", 1550, 1550);
  
  // display rings
  for (Ring r : rings) {
    r.display();
  }
}

/**************************************************************
 KEY PRESSED
 
 - S key saves current frame into output folder
 **************************************************************/
void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame("output/VisRingFixed_" + songName + "_######.png");
  }
}

/**************************************************************
 Class for creating nodes that holds angle and radius information
 along with position. Additionally, frequency bands and sensativity
 are set here. 
 
 #FIX: I am not sure this class is fully needed. Could be nestled
 within the Ring class
 **************************************************************/
class Node {
  PVector pos;            // the moving position of the node
  PVector posOrigin;      // the origin position of the node
  float angle;            // the angle fo the node
  float radius;           // the moving radius of the node
  float radiusPeak;       // the peak radius of the node
  int min, max;           // the lower and upper bounds of the frequency range
  int sensativity;        // the sensativity to the amplitude calc
  int maxMap;             // the max value of the ring remapping
  float shrinkSpeed;      // how quickly the peak radius shrinks
  
  /**
   * Constructor method for Node class
   *
   * @param {float} x         the x position of node (center)
   * @param {float} y         the y position of node (center)
   * @param {float} _anlge    the angle of this node from origin
   * @param {int} _min        the lower bound of the frequency range being sampled
   * @param {int} _max        the upper bound of the frequency range being sampled
   */
  Node(float _x, float _y, float _angle, int _min, int _max) {
    pos = new PVector(_x, _y);
    posOrigin = new PVector(_x, _y);
    angle = _angle;
    min = _min;
    max = _max;
    radius = 100;
    radiusPeak = 100;
    sensativity = int(random(35, 60));
    maxMap = int(random(750, 900));
    shrinkSpeed = random(.5, 2);
  }
  
  // update the position of the node relative to origin and the 
  // reading of the frequency band amplitude
  void update() {
    radius = fft.calcAvg(min, max);
    float radiusMap = map(radius, 0, sensativity, 500, maxMap);
    if (radiusMap > radiusPeak) {
      radiusPeak = radiusMap;
    } else {
      radiusPeak -= shrinkSpeed;
    }

    pos.x = posOrigin.x + cos(radians(angle)) * radiusPeak;
    pos.y = posOrigin.y + sin(radians(angle)) * radiusPeak;
  }
}

/**************************************************************
 Class for creating Ring visualizer. Each node around the ring
 has a fixed angle and frequency band it is sampling. 
 **************************************************************/
class Ring {
  PVector pos;                  // origin position of the ring
  ArrayList<Node> nodesList;    // list of outer ring nodes
  int ringSize;                 // size of the ring
  boolean showFade;             // toggle displaying the inner circle fade element
  color ringColor;              // set ring color
  int angleOff;                 // angle offset that will begin making frequncy bands
  int frequencyOff;             // the start of the frequency band
  int lastAmp;                  // track last amplitude of song for inner fade element
  
  /**
   * Constructor method for Ring class
   *
   * @param {float} x         the x position of ring (center)
   * @param {float} y         the y position of ring (center)
   * @param {int} _angOff     the start angle offset of frequency mapping
   * @param {int} _freqOff    the start frequency for slicing regions
   * @param {boolean} _fade   toggle displaying the innder fade element
   */
  Ring(float _x, float _y, int _angOff, int _freqOff, boolean _fade) {
    pos = new PVector(_x, _y);
    angleOff = _angOff;
    ringSize = 500;
    showFade = _fade;
    ringColor = color(66, 19, 194);
    frequencyOff = _freqOff;
    lastAmp = 0;

    // loop for creating nodes at desired positions
    nodesList = new ArrayList<Node>();
    int tempAngle = 0;
    int position = 0;
    for (int i = 0; i < 361; i++) {
      // #FIX not sure if i need this
      //if (i > 359) {
      //  tempAngle =  i - 360;
      //} else {
      //  tempAngle = i;
      //}
      
      tempAngle = i;
      
      // adjust for angle offset and position start
      position = i + angleOff;
      if (position > 359) {
        position = i - 360 + angleOff;
      }
      
      // set min and max of frequency bands
      int minFreq = int(position * 10) + frequencyOff;
      int maxFreq = int((position + 1) * 10) + frequencyOff;
      
      // create Node object and add to list
      nodesList.add(new Node(pos.x, pos.y, tempAngle, minFreq, maxFreq));
    }
  }
  
  /**
   * display the ring
   */
  void display() {
    // update each node with current average band amplitude
    for (int i = 0; i < nodesList.size(); i++) {
      nodesList.get(i).update();
    }

    // display the visualizer ring
    fill(hue(ringColor), saturation(ringColor), brightness(ringColor));
    noStroke();
    beginShape();
    // loop through nodes and calculate average amplitude
    // in order to smooth out readings
    for (int i = 0; i < nodesList.size(); i++) {
      // used for finding new vector position with smoothing
      int index = 0;
      int avg = 0;
      int counter = 0;
      for (int j = -SmoothAmount; j < SmoothAmount + 1; j++) {
        index = i - j;
        if (index < 0) {
          index = index + 360;
        } else if ( index > 359) {
          index = index - 360;
        }
        avg += nodesList.get(index).radiusPeak;
        counter++;
      }

      // calculate new x and y position for outer shape of ring
      float rad = avg/counter;
      float x = pos.x + cos(radians(nodesList.get(i).angle)) * (0 + rad);
      float y = pos.y + sin(radians(nodesList.get(i).angle)) * (0 + rad);
      vertex(x, y);
    }
    
    // loop through list in reverse to create inner circle for closed ring effect
    for (int i = nodesList.size() - 1; i >= 0; i--) {
      //for(int i = 0; i < nodesList.size(); i++) {
      float x = pos.x + cos(radians(nodesList.get(i).angle)) * (ringSize - 5);
      float y = pos.y + sin(radians(nodesList.get(i).angle)) * (ringSize - 5);
      vertex(x, y);
    }
    endShape(CLOSE);
    
    // display fade element if necessary
    if (showFade) {
      displayFade();
    }
  }
  
  /**
   * display the inner ring fade feature
   */
  void displayFade() {
    // get song amplitude
    int fmap = int(map(fft.calcAvg(0, 3000), 0, 40, 5, 30));
    
    // highlight peaks in amplitude and shrink otherwise
    if (fmap > lastAmp) {
      lastAmp = fmap;
    } else {
      lastAmp -= .25;
    }
    
    // set amount of fade to amp peaks
    for (int t = 0; t < lastAmp; t ++) {
      float fade = map(t, 0, fmap, 100, 0);
      fill(hue(ringColor), saturation(ringColor), brightness(ringColor), fade);
      beginShape();
      // outer circle vertices
      for (int i = 0; i < 361; i++) {
        float x = pos.x - cos(radians(i)) * ((ringSize  ) - (t));
        float y = pos.y - sin(radians(i)) * ((ringSize ) - (t));
        vertex(x, y);
      }
      
      // inner circle vertices
      for (int i = 360; i >=0; i--) {
        float x = pos.x - cos(radians(i)) * ((ringSize) - (t * 2));
        float y = pos.y - sin(radians(i)) * ((ringSize) - (t * 2));
        vertex(x, y);
      }
      endShape();
    }
  }
}
