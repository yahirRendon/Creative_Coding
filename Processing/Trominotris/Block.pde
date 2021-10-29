/**************************************************************
 Class for creating individual blocks that will make up the 
 trominoes.
 **************************************************************/
class Block {
  int x;          // x location of the block (index)
  int y;          // y location of the block (index)
  int xPos;       // x position of the block (pixel)
  int yPos;       // y position of the block (pixel)
  int blockSize;  // size of the block
  color c;        // color fo the block


  /**
   * Constructor method for Block class
   *
   * @param {int} _x    the x position of the Cell (index)
   * @param {int} _y    the y position of the Cell (index)
   * @param {int} _c    the color of the block
   */
  Block(int _x, int _y, color _c) {
    x = _x;
    y = _y;
    blockSize = 80;
    xPos = blockSize + _x * blockSize;
    yPos = (_y * blockSize) - (blockSize * 3);
    c = _c;
  }

  /**
   * Update the pixel position of the block based on x and y position
   */
  void updatePosition() {
    xPos = blockSize + x * blockSize;
    yPos = (y * blockSize) - (blockSize * 3);
  }

  /**
   * Display the block
   */
  void display() {
    // only display if beyond the loading zone
    if (y > 2) {
      fill(c);
      rect(xPos, yPos, blockSize, blockSize);
    }
  }  

  /**
   * Method for checking if block can move to the
   * desired location in the grid based 
   * 
   * @param {int} _x      the x location in grid
   * @param {int} _y      the y location in grid
   *
   * @return {boolean}    if grid space is open returns true. else false
   */
  boolean checkMove(int _x, int _y) {
    // check if within bounds of grid
    if (_x < 0 || _x > gridWidth - 1 ||
      _y < 0 || _y > gridHeight - 1) {
      return false;
    }
    // check the grid cell is open (no other block)
    int index = _x + _y * gridWidth;
    if (cells.get(index).state == 1) {
      return false;
    }
    return true;
  }
}
