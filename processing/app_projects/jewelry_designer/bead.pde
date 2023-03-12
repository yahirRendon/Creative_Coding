/******************************************************************************
 *
 * class for creating individuals bead
 *
 *****************************************************************************/
class Bead {
  int x, y;        // x and y location (index)
  int xpos, ypos;  // x and y position (pixels)
  boolean open;    // is this bead open (can be filled with message)
  int offsetx;     // shift start position on x axis (pixels)
  int offsety;     // shift start position on y axis (pixels)
  int fw, fh;      // width of bead
  int bitValue;    // height of bead
  
  // color of beads
  color colorPrimary;  
  color colorOpen;
  color color0;
  color color1;
  /******************************************************************************
   * constructor
   * 
   * @param  _x         the x position of the bead
   * @param  _y         the y position of the bead
   * @param  _numRows   the number of rows in bead grid for placement
   * @param  _numCols   the nubmer of columns in bead grid for placement
   * @param  _beadSize  the size of the bead for placement
   *****************************************************************************/
  Bead(int _x, int _y, int _numRows, int _numCols, int _beadSize) {
    x = _x;
    y = _y;
    open = false;
    bitValue = 2;
    updatePosition(_numRows, _numCols, _beadSize);
    
    colorPrimary = color(255);
    colorOpen = color(240, 0, 0, 60);
    color0 = color(34, 87, 122);
    color1 = color(197, 201, 208);
  }
  
   /******************************************************************************
   * 
   * reset button to default
   * 
   *****************************************************************************/
  void reset() {
    bitValue = 2;
    open = false;
  }

  /******************************************************************************
   * 
   * update the bead position
   * 
   * @param  _cols    number of cols in grid
   * @param  _rows    number of rows in grid
   * @param  _bs      the bead size
   *****************************************************************************/
  void updatePosition(int _cols, int _rows, int _bs) {
    // update bead dimensions
    fw = _bs;
    fh = int(_bs * .75);
    
    // calc and set new position
    offsetx = 200 - ((fw) * _cols) / 2 ;
    offsety = (450 - scrollPosition) - ((fh) * _rows) / 2;
    xpos = offsetx + (fw) * x;
    ypos = offsety + (fh) * y;
  }

  /******************************************************************************
   *
   * set bead to open state
   *
   * @param  _on    set bead to open
   *****************************************************************************/
  void setOpen(boolean _on) {
    open = _on;
  }

  /******************************************************************************
   * 
   * display the bead
   *
   *****************************************************************************/
  void display() {
    stroke(0, 75);
    fill(colorPrimary);
    if (open) {
      if (bitValue == 0) fill(color0);
      if (bitValue == 1) fill(color1);
      if (bitValue == 2) fill(colorOpen);
    }

    // when using beading guide tool
    if (beadGuide && y != guideRow) {
      fill(0, 200);
      rect(xpos, ypos, fw, fh);
    } else {

      rect(xpos, ypos, fw, fh, fh * .4);
    }
  }

  /**
   *  determine if the bead is active
   *
   * @RETURN    true when mouse hover over bead
   */
  boolean active() {
    if (mouseX > xpos && mouseX < xpos + fw &&
      mouseY > ypos && mouseY < ypos + fh) {
      // give user feedback with bead number
      fill(0);
      textSize(14);
      textAlign(CENTER, CENTER);
      if (!beadGuide) {
        text((x + y * bg.cols) + 1, 25, 875);
      } 
      return true;
    } else {
      return false;
    }
  }
}
