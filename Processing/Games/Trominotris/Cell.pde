/**************************************************************
 Class for creating cells that make the up the game grid.
 #FIX not sure if this is needed as it can be just an Integer
 array decalring if space in grid is open or has a block in it.
 
 However for design things different colors or effects can be
 used in the cells. 
 
 **************************************************************/
class Cell {
  int x;            // x location of cell (index)
  int y;            // y location of cell (index)
  int xPos;         // x position of cell (pixel)
  int yPos;         // y position of cell (pixel)
  int state;        // track if cell is empty (0 = empty | 1 = block)
  int cellSize;     // size of the cell

  /**
   * Constructor method for Block class
   *
   * @param {int} _x    the x position of the Cell (index)
   * @param {int} _y    the y position of the Cell (index)
   * @param {int} _s    the size of the cell
   */
  Cell(int _x, int _y, int _s) {
    x = _x;
    y = _y;
    cellSize = 50;
    xPos = 225 + _x * cellSize;
    yPos =  (_y * cellSize) - cellSize;
    state = _s;
  }

  /**
   * Display the block depending on state
   */
  void display() {
    if(y > 2) {
    fill(208,210, 205);
    noStroke();
    rect(xPos, yPos, cellSize, cellSize);
    }
  }
}
