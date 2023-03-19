/*
Hyper Cube class
 */
class HyperCube {
  PVector a, b, c, d, e, f, g, h;       // True outer position LEFT
  PVector aa, bb, cc, dd, ee, ff, gg, hh;
  PVector a1, b1, c1, d1, e1, f1, g1, h1;      // outer cube position transformable
  PVector a2, b2, c2, d2, e2, f2, g2, h2;

  float easing = 0.05; // easing value for updating positions

  PVector aLast, aaLast;
  PVector dim1aOut, dim1aIn, dim2aOut, dim2aIn; // track and save the previous dimension values

  int dimension = 0;
  boolean transforming = true;

  boolean engaged; // toggle when a vertex is being moved

  float alphaOut;
  float alphaIn;
  float alphaH = 140;
  float alphaL = 40;
  float alphaLineLight = 80;
  float alphaLineStrong = 255;
  float alphaVertex = 80;

  float xoff = 33333; 
  float yoff;
  float inc = .002;


  float aLineLight = 80;
  float aLineStrong = 255;
  float aVertex = 100;

  boolean showing;
  boolean lastAutoPlay;

  HyperCube(float tempX, float tempY) {
    aLast = new PVector(tempX, tempY);
    aaLast = new PVector(tempX, tempY);
    dim1aOut = new PVector(tempX, tempY);
    dim1aIn = new PVector(tempX, tempY);
    dim2aOut = new PVector(tempX, tempY);
    dim2aIn = new PVector(tempX, tempY);

    // true shape outer
    a = new PVector(tempX, tempY);
    b = new PVector(tempX - 200, tempY - 100);
    c = new PVector(tempX - 200, tempY + 100);
    d = new PVector(tempX + 0, tempY + 250);
    e = new PVector(tempX + 200, tempY + 100);
    f = new PVector(tempX + 200, tempY - 100);
    g = new PVector(tempX, tempY - 180);
    h = new PVector(tempX + 200, tempY - 100);

    // outer Shape
    a1 = new PVector(tempX, tempY);
    b1 = new PVector(tempX - 200, tempY - 100);
    c1 = new PVector(tempX - 200, tempY + 100);
    d1 = new PVector(tempX + 0, tempY + 250);
    e1 = new PVector(tempX + 200, tempY + 100);
    f1 = new PVector(tempX + 200, tempY - 100);
    g1 = new PVector(tempX, tempY - 180);
    h1 = new PVector(tempX + 200, tempY - 100);

    // true nner shape
    aa = new PVector(tempX, tempY);
    bb = new PVector(tempX - 150, tempY - 75);
    cc = new PVector(tempX - 150, tempY + 75);
    dd = new PVector(tempX + 0, tempY + 187.5);
    ee = new PVector(tempX + 150, tempY + 75);
    ff = new PVector(tempX + 150, tempY - 75);
    gg = new PVector(tempX, tempY - 135);
    hh = new PVector(tempX + 150, tempY - 75);

    // inner shape
    a2 = new PVector(tempX, tempY);
    b2 = new PVector(tempX - 150, tempY - 75);
    c2 = new PVector(tempX - 150, tempY + 75);
    d2 = new PVector(tempX + 0, tempY + 187.5);
    e2 = new PVector(tempX + 150, tempY + 75);
    f2 = new PVector(tempX + 150, tempY - 75);
    g2 = new PVector(tempX, tempY - 135);
    h2 = new PVector(tempX + 150, tempY - 75);
  }

  void update() {
    switch(dimension) {
    case 1: 
      b1.x += ease(b1.x, bb.x);
      b1.y += ease(b1.y, bb.y);
      c1.x += ease(c1.x, cc.x);
      c1.y += ease(c1.y, cc.y);
      d1.x += ease(d1.x, dd.x);
      d1.y += ease(d1.y, dd.y);
      e1.x += ease(e1.x, ee.x);
      e1.y += ease(e1.y, ee.y);
      f1.x += ease(f1.x, ff.x);
      f1.y += ease(f1.y, ff.y);
      g1.x += ease(g1.x, gg.x);
      g1.y += ease(g1.y, gg.y);
      h1.x += ease(h1.x, hh.x);
      h1.y += ease(h1.y, hh.y);


      b2.x += ease(b2.x, b.x);
      b2.y += ease(b2.y, b.y);
      c2.x += ease(c2.x, c.x);
      c2.y += ease(c2.y, c.y);
      d2.x += ease(d2.x, d.x);
      d2.y += ease(d2.y, d.y);
      e2.x += ease(e2.x, e.x);
      e2.y += ease(e2.y, e.y);
      f2.x += ease(f2.x, f.x);
      f2.y += ease(f2.y, f.y);
      g2.x += ease(g2.x, g.x);
      g2.y += ease(g2.y, g.y);
      h2.x += ease(h2.x, h.x);
      h2.y += ease(h2.y, h.y);

      if (transforming) {
        // simple switch back and forth
        //a1.x += ease(a1.x, aaLast.x); // this works
        //a1.y += ease(a1.y, aaLast.y); // this works
        //a2.x += ease(a2.x, aLast.x); // this works
        //a2.y += ease(a2.y, aLast.y); / this works

        //  if(abs(dist(a1.x, a1.y, aaLast.x, aaLast.y)) < 1) {
        // transforming = false;

        //}

        //
        a1.x += ease(a1.x, dim1aIn.x);
        a1.y += ease(a1.y, dim1aIn.y);
        a2.x += ease(a2.x, dim1aOut.x);
        a2.y += ease(a2.y, dim1aOut.y);

        if (abs(dist(a2.x, a2.y, dim1aOut.x, dim1aOut.y)) < 1) {
          transforming = false;
        }
      }

      break;
    default:

      b1.x += ease(b1.x, b.x);
      b1.y += ease(b1.y, b.y);
      c1.x += ease(c1.x, c.x);
      c1.y += ease(c1.y, c.y);
      d1.x += ease(d1.x, d.x);
      d1.y += ease(d1.y, d.y);
      e1.x += ease(e1.x, e.x);
      e1.y += ease(e1.y, e.y);
      f1.x += ease(f1.x, f.x);
      f1.y += ease(f1.y, f.y);
      g1.x += ease(g1.x, g.x);
      g1.y += ease(g1.y, g.y);
      h1.x += ease(h1.x, h.x);
      h1.y += ease(h1.y, h.y);


      b2.x += ease(b2.x, bb.x);
      b2.y += ease(b2.y, bb.y);
      c2.x += ease(c2.x, cc.x);
      c2.y += ease(c2.y, cc.y);
      d2.x += ease(d2.x, dd.x);
      d2.y += ease(d2.y, dd.y);
      e2.x += ease(e2.x, ee.x);
      e2.y += ease(e2.y, ee.y);
      f2.x += ease(f2.x, ff.x);
      f2.y += ease(f2.y, ff.y);
      g2.x += ease(g2.x, gg.x);
      g2.y += ease(g2.y, gg.y);
      h2.x += ease(h2.x, hh.x);
      h2.y += ease(h2.y, hh.y);

      if (transforming) {

        // this works simple exchange
        //a1.x += ease(a1.x, aaLast.x);
        //a1.y += ease(a1.y, aaLast.y);
        //a2.x += ease(a2.x, aLast.x);
        //a2.y += ease(a2.y, aLast.y);
        //if(abs(dist(a2.x, a2.y, aLast.x, aLast.y)) < 1) {
        // transforming = false;

        //} 

        // prior dimension position exchange
        a1.x += ease(a1.x, dim2aOut.x);
        a1.y += ease(a1.y, dim2aOut.y);
        a2.x += ease(a2.x, dim2aIn.x);
        a2.y += ease(a2.y, dim2aIn.y);
        if (abs(dist(a1.x, a1.y, dim2aOut.x, dim2aOut.y)) < 1) {
          transforming = false;
        }
      }
      if (!transforming && autoPlayEngaged) {  
        float valx = map(noise(xoff), 0, 1, 0, width);
        float valy = map(noise(yoff), 0, 1, 0, height); 
        xoff+= inc;
        yoff+= inc;
        a1.x += ease(a1.x, valx);
        a1.y += ease(a1.y, valy);
        dim2aOut.x = a1.x;
        dim2aOut.y = a1.y;

        a2.x += ease(a2.x, map(a1.x, 0, 1000, 250, 750));
        a2.y += ease(a2.y, map(a1.y, 0, 1000, 250, 750));
      }


      break;
    }
  }


  void display() { 
    if (showHyperCube) {   
      if (alphaLineStrong - aLineStrong < 1) {
        if (dimension == 0) {
          alphaOut += ease(alphaOut, alphaH);
          alphaIn += ease(alphaIn, alphaL);
        } else {
          alphaOut += ease(alphaOut, alphaL);
          alphaIn += ease(alphaIn, alphaH);
        }
        alphaVertex += ease(alphaVertex, aVertex);
        alphaLineLight += ease(alphaLineLight, aLineLight);
        alphaLineStrong += ease(alphaLineStrong, aLineStrong);
      } else {
        alphaOut = map(abs(dist(a1.x, a1.y, 500, 500)), 0, 500, 230, 60);
        alphaIn = map(abs(dist(a1.x, a1.y, 500, 500)), 0, 500, 100, 40);
      }
    } else {
      // alphaOut = map(abs(dist(a1.x, a1.y, 500, 500)), 0, 500, 230, 60);
      //alphaIn = map(abs(dist(a1.x, a1.y, 500, 500)), 0, 500, 100, 40); 
      alphaOut += ease(alphaOut, 0);
      alphaIn += ease(alphaIn, 0);
      alphaLineLight += ease(alphaLineLight, 0);
      alphaLineStrong += ease(alphaLineStrong, 0);
      alphaVertex += ease(alphaVertex, 0);
    }


    if (dimension == 0) {
      stroke(255, alphaLineStrong);
      // inner left
      fill(0, 204, 253, alphaIn); // cool blue
      beginShape();
      vertex(a2.x, a2.y );
      vertex(b2.x, b2.y );
      vertex(c2.x, c2.y );
      vertex(d2.x, d2.y );
      vertex(a2.x, a2.y );
      endShape(); 

      // inner right
      fill(32, 17, 162, alphaIn); // violet
      beginShape();
      vertex(a2.x, a2.y );
      vertex(f2.x, f2.y );
      vertex(e2.x, e2.y );
      vertex(d2.x, d2.y );
      vertex(a2.x, a2.y );
      endShape();
      
      // inner top
      fill(255, 52, 179, alphaIn); // pink
      beginShape();
      vertex(a2.x, a2.y );
      vertex(b2.x, b2.y );
      vertex(g2.x, g2.y );
      vertex(h2.x, h2.y );
      vertex(a2.x, a2.y );
      endShape(); 

      // outer left
      fill(74, 112, 122, alphaOut);
      beginShape();
      vertex(a1.x, a1.y );
      vertex(b1.x, b1.y );
      vertex(c1.x, c1.y );
      vertex(d1.x, d1.y );
      vertex(a1.x, a1.y );
      endShape();
      
      // outer right
      fill(194, 200, 197, alphaOut);
      beginShape();
      vertex(a1.x, a1.y );
      vertex(f1.x, f1.y );
      vertex(e1.x, e1.y );
      vertex(d1.x, d1.y );
      vertex(a1.x, a1.y );
      endShape();  
      
      // outer top
      fill(148, 176, 183, alphaOut); 
      beginShape();
      vertex(a1.x, a1.y );
      vertex(b1.x, b1.y );
      vertex(g1.x, g1.y );
      vertex(h1.x, h1.y );
      vertex(a1.x, a1.y );
      endShape(); 



      stroke(255, alphaLineLight);  
      line(a1.x, a1.y, a2.x, a2.y);
      line(b1.x, b1.y, b2.x, b2.y);
      line(c1.x, c1.y, c2.x, c2.y);
      line(d1.x, d1.y, d2.x, d2.y);
      line(e1.x, e1.y, e2.x, e2.y);
      line(f1.x, f1.y, f2.x, f2.y);
      line(g1.x, g1.y, g2.x, g2.y);
      line(h1.x, h1.y, h2.x, h2.y);


      line(g2.x, g2.y, 500, 470);
      line(c2.x, c2.y, 500, 470);
      line(e2.x, e2.y, 500, 470);

      // visual reminder of prior dimension points
      if (showHyperCube) {
        fill(0, alphaVertex);
        ellipse(dim1aOut.x, dim1aOut.y, 10, 10);
        fill(255, alphaVertex);
        ellipse(dim2aOut.x, dim2aOut.y, 10, 10);
      } else {
        if (autoPlayEngaged) {
          fill(255, alphaVertex);
          ellipse(dim2aOut.x, dim2aOut.y, 10, 10);
        }
      }
    } else {
      stroke(0, alphaLineStrong);

      fill(74, 112, 122, alphaOut);
      beginShape();
      vertex(a1.x, a1.y );
      vertex(b1.x, b1.y );
      vertex(c1.x, c1.y );
      vertex(d1.x, d1.y );
      vertex(a1.x, a1.y );
      endShape();   
      // outer right

      fill(194, 200, 197, alphaOut);
      beginShape();
      vertex(a1.x, a1.y );
      vertex(f1.x, f1.y );
      vertex(e1.x, e1.y );
      vertex(d1.x, d1.y );
      vertex(a1.x, a1.y );
      endShape();  
      // outer top

      fill(148, 176, 183, alphaOut);
      beginShape();
      vertex(a1.x, a1.y );
      vertex(b1.x, b1.y );
      vertex(g1.x, g1.y );
      vertex(h1.x, h1.y );
      vertex(a1.x, a1.y );
      endShape();  

      // inner left

      fill(0, 204, 253, alphaIn); // cool blue
      beginShape();
      vertex(a2.x, a2.y );
      vertex(b2.x, b2.y );
      vertex(c2.x, c2.y );
      vertex(d2.x, d2.y );
      vertex(a2.x, a2.y );
      endShape();   
      // inner right
      //fill(196, 125, 161, alphaIn);
      //fill(9, 251, 211, alphaIn); // teal green
      fill(32, 17, 162, alphaIn); // violet

      beginShape();
      vertex(a2.x, a2.y );
      vertex(f2.x, f2.y );
      vertex(e2.x, e2.y );
      vertex(d2.x, d2.y );
      vertex(a2.x, a2.y );
      endShape();
      // inner top
      //fill(226, 161, 164, alphaIn);
      fill(255, 52, 179, alphaIn); // pink

      beginShape();
      vertex(a2.x, a2.y );
      vertex(b2.x, b2.y );
      vertex(g2.x, g2.y );
      vertex(h2.x, h2.y );
      vertex(a2.x, a2.y );
      endShape(); 

      stroke(0, alphaLineLight);
      line(a1.x, a1.y, a2.x, a2.y);
      line(b1.x, b1.y, b2.x, b2.y);
      line(c1.x, c1.y, c2.x, c2.y);
      line(d1.x, d1.y, d2.x, d2.y);
      line(e1.x, e1.y, e2.x, e2.y);
      line(f1.x, f1.y, f2.x, f2.y);
      line(g1.x, g1.y, g2.x, g2.y);
      line(h1.x, h1.y, h2.x, h2.y);


      line(g2.x, g2.y, 500, 470);
      line(c2.x, c2.y, 500, 470);
      line(e2.x, e2.y, 500, 470);

      // visual reminder of prior dimension points
      if (showHyperCube) {
        fill(0, alphaVertex);
        ellipse(dim1aOut.x, dim1aOut.y, 10, 10);
        fill(255, alphaVertex);
        ellipse(dim2aOut.x, dim2aOut.y, 10, 10);
      } else {
        if (autoPlayEngaged) {
          fill(0, alphaVertex);
          ellipse(dim1aOut.x, dim1aOut.y, 10, 10);
        }
      }
    }
  }

  float ease(float start, float target) {
    float dx = target - start;
    return dx * easing;
  }

  boolean inRange() {
    if (dimension == 0) {
      if (abs(dist(mouseX, mouseY, a1.x, a1.y)) < 21) {
        return true;
      } else {
        return false;
      }
    } else {
      if (abs(dist(mouseX, mouseY, a2.x, a2.y)) < 21 && checkLimits()) {
        return true;
      } else {
        return false;
      }
    }
  }

  boolean checkLimits() {
    if (mouseX > 200 && mouseX < 800 && mouseY > 200 &&  mouseY < 800) {
      return true;
    } else {
      return false;
    }
  }
}
