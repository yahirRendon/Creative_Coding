/**************************************************************
 Project: The basic works of a Perlin Flowfield. I convereted the p5.js 
 tutorial by Dan Shiffman into java with some modifcations
 
 Author:  Yahir 
 
 Date:    November 2018
 
 
 Notes:
 - Processing 3.5.4
 
 **************************************************************/

float inc;                // how quickly we increment through flowfield
int scl;                  // size of grids that generate angles
int cols, rows;           // numbr or rows in columns in the flowfield
float zoff;               // perlin zoff
float noiseAmt;           // modulation to angles in flowfield
float flowStrength;       // how strong particles interact with angles
int numParticles;         // number of particles in flowfield

ArrayList<Particle> particles; // array of particles
PVector flowfield[];           // Array of PVector that holds the angle 
                               // of the vectors in the flowfield

boolean showVectors = false;  // show angles/vectors for testing

float strengthOff;

/**************************************************************
 SET UP FUNCTION
 **************************************************************/
void setup() {
  size(1000, 1000, P2D);
  background(255);

  inc = 0.1;  
  scl = 40;  
  zoff = 0;
  noiseAmt = 3;         
  flowStrength = .15;   
  numParticles = 2000;     
  
  strengthOff = random(2302);

  //Create grid for vectors based on the width, height and scale
  cols = floor((width + scl) / scl);
  rows = floor((height + scl) / scl);

  //Create flowfield array the size of cols * rows
  flowfield = new PVector[cols * rows]; 

  //Create the number of particles indicated by numParticles
  particles = new ArrayList<Particle>(); 
  for (int i = 0; i < numParticles; i++) {
    particles.add(new Particle());
  }
}

/**************************************************************
 DRAW FUNCTION
 **************************************************************/

void draw() {
  //background(255);

  float yoff = 0;
  for (int y = 0; y < rows; y++) {
    float xoff = 0;
    for (int x = 0; x < cols; x++) {
      int index = x + y * cols;
      float angle = noise(xoff, yoff, zoff) * TWO_PI * noiseAmt;
      ;
      PVector v = PVector.fromAngle(angle);
      
      flowStrength = map(noise(strengthOff), 0, 1, 0.15, 0.25);
      strengthOff += 0.05;
      
      v.setMag(flowStrength);
      flowfield[index] = v;

      if (showVectors) {
        stroke(0);
        strokeWeight(1);
        pushMatrix();
        translate(x * scl, y * scl);
        rotate(v.heading());
        line(0, 0, scl, 0);
        popMatrix();
      }
      
      

      xoff+= inc;
    }
    yoff+= inc;

    zoff += .0001;
  }

  for (Particle part : particles) {
    part.follow(flowfield);
    part.update();
    part.edges();
    part.show();
  }
}

/**
 * class for creating basic particles
 */
class Particle {
  PVector pos;        // position of particle
  PVector prevPos;    // track previous particle position
  PVector vel;        // velocity
  PVector acc;        // acceleration
  float maxSpeed;     // limit maxspeed;
 
  // modulate size
  float sze;
  float szeSpd;
  float szeOff;
  
  /**
  * Particle constructor
  */
  Particle() {
    pos = new PVector(random(width), random(height));
    prevPos = new PVector(pos.x, pos.y);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    maxSpeed = 4;

    sze = 1;
    szeSpd = random(0.03, 0.075);
    szeOff = random(208);
    
  }

  /**
   * Update particle vel, pos, acc
   */
  void update() {
    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(vel);
    acc.mult(0);
  }

  /**
   * Have particle follow vectors
   * @PARAM vector array
   */
  void follow(PVector vectors[]) {
    int x = floor(pos.x / scl);
    int y = floor(pos.y /scl);
    int index = x + y * cols;
    PVector force = vectors[index];
    applyForce(force);
  }

  /**
   * Apply force to acceleration
   *
   * @PARAM force is the force applied to acc
   */
  void applyForce(PVector force) {
    acc.add(force);
  }

  void show() {
    sze = map(noise(szeOff), 0, 1, -5, 5);
    if(sze < 0) sze = 0;
    szeOff += szeSpd;
    stroke(0, 1);
    strokeWeight(sze);
    line(pos.x, pos.y, prevPos.x, prevPos.y);
    
    //noStroke();
    //fill(0, 5);
    //ellipse(pos.x, pos.y, sze, sze);
    updatePrev();
  }

  /**
   * update the previous position to avoid excess lines being drawn
   */
  void updatePrev() {
    prevPos.x = pos.x;
    prevPos.y = pos.y;
  }

  /**
   * Check particle pos and reset if out of bounds
   */
  void edges() {
    if (pos.x < 0) {  
      pos.x = width;
      updatePrev();
    }
    if (pos.x > width) {
      pos.x = 0;
      updatePrev();
    }
    if (pos.y < 0) {
      pos.y = height; 
      updatePrev();
    }
    if (pos.y > height) {
      pos.y = 0; 
      updatePrev();
    }
  }
}
