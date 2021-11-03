/**************************************************************
 Class for trominoes and methods for moving within game grid
 - I or Long piece
 - L piece
 - Long irregular
 - Pyramid
 
 **************************************************************/
class Tromino {
  int orientation;             // track orientation of the tromino for rotations       
  ArrayList<Block> tromino;    // list of three blocks that make up tromino
  int type;                    // the type of tromino created (0 = I and 1 = L)

  /**
   * Constructor method for Tromino class
   *
   */
  Tromino() {
    // create tromino
    tromino = new ArrayList<Block>();
    createNewTromino(int(random(0, 2)));
  }


  /**
   * Display tromino
   */
  void display() {
    for (Block b : tromino) {
      b.display();
    }
  }

  /**
   * check if blocks in tromino can move left
   *
   * @return {boolean} true if all blocks can move left
   */
  boolean canMoveLeft() {
    // loop through blocks in tromino and check position
    // in grid to the left is open. 
    for (int i = 0; i < tromino.size(); i++) {
      int x = tromino.get(i).x - 1;
      int y = tromino.get(i).y;
      int index = x + y * gridWidth;

      // if grid space is not available by being out of bounds
      // or not in open state toggle canMoveLeft to false
      if (!tromino.get(i).checkMove(x, y) || cells.get(index).state == 1) {
        return false;
      }
    }
    return true;
  }

  /**
   * Move tromino to the left
   */
  void moveLeft() {

    // if all pieces can move left update all block positions
    // to new left location
    if (canMoveLeft()) {
      for (int i = 0; i < tromino.size(); i++) {
        tromino.get(i).x --;
        tromino.get(i).updatePosition();
      }
    }
  }

  /**
   * check if blocks in tromino can move right
   *
   * @return {boolean} true if all blocks can move right
   */
  boolean canMoveRight() {
    // loop through blocks in tromino and check position
    // in grid to the right is open. 
    for (int i = 0; i < tromino.size(); i++) {
      int x = tromino.get(i).x + 1;
      int y = tromino.get(i).y;
      int index = x + y * gridWidth;

      // if grid space is not available by being out of bounds 
      // or not in open state toggle canMoveLeft to false
      if (!tromino.get(i).checkMove(x, y) || cells.get(index).state == 1) {
        return false;
      }
    }
    return true;
  }

  /**
   * Move tromino to the right
   */
  void moveRight() {    
    // if all pieces can move right update all block positions
    // to new right location
    if (canMoveRight()) {
      for (int i = 0; i < tromino.size(); i++) {
        tromino.get(i).x ++;
        tromino.get(i).updatePosition();
      }
    }
  }

  /**
   * check if blocks in tromino can move down
   *
   * @return {boolean} true if all blocks can move down
   */
  boolean canMoveDown() {
    for (int i = 0; i < tromino.size(); i++) {
      int x = tromino.get(i).x;
      int y = tromino.get(i).y + 1;
      int index = x + y * gridWidth;

      // if grid space is not available by being out of bounds 
      // or not in open state toggle canMoveLeft to false
      if (!tromino.get(i).checkMove(x, y) || cells.get(index).state == 1) {
        return false;
      }
    }
    return true;
  }

  /**
   * Move tromino to down
   */
  void moveDown() {
    if (canMoveDown()) {
      for (int i = 0; i < tromino.size(); i++) {
        tromino.get(i).y ++;
        tromino.get(i).updatePosition();
      }
    }
  }

  /**
   * Rotate Long piece
   */
  void rotateLongPiece() {  
    // store current x and y positions for each block in tromino 
    int x0 = tromino.get(0).x;
    int y0 = tromino.get(0).y;
    int x1 = tromino.get(1).x;
    int y1 = tromino.get(1).y;
    int x2 = tromino.get(2).x;
    int y2 = tromino.get(2).y;
    boolean canMove = true;

    // update x and y positions to desired locations for rotation
    switch(orientation) {      
    case 0:   
      x0 += 1; 
      y0 += 1;
      x2 -= 1; 
      y2 -= 1;     
      break;
    case 1:
      x0 -= 1; 
      y0 += 1; 
      x2 += 1; 
      y2 -= 1;      
      break;
    case 2:
      x0 -= 1; 
      y0 -= 1; 
      x2 += 1; 
      y2 += 1;
      break;
    case 3:
      x0 += 1; 
      y0 -= 1; 
      x2 -= 1; 
      y2 += 1;
      break;
    default: 
      break;
    }

    // if any of the desired locations are either out of bounds
    // or not in open state trigger canMove to false
    if (!tromino.get(0).checkMove(x0, y0) ||
      !tromino.get(1).checkMove(x1, y1) ||
      !tromino.get(2).checkMove(x2, y2) ) {
      canMove = false;
    }

    // if all blocks can move update the current location to the
    // desired location and update position
    if (canMove) {
      tromino.get(0).x = x0;
      tromino.get(0).y = y0;
      tromino.get(0).updatePosition();
      tromino.get(1).x = x1;
      tromino.get(1).y = y1;
      tromino.get(1).updatePosition();
      tromino.get(2).x = x2;
      tromino.get(2).y = y2;
      tromino.get(2).updatePosition();

      // increment orientaiton on a succesful rotation
      orientation++;
      if (orientation > 3) orientation = 0;
    }
  }


  /**
   * rotate the L Piece
   */
  void rotateLPiece() {
    // store current x and y positions for each block in tromino 
    int x0 = tromino.get(0).x;
    int y0 = tromino.get(0).y;
    int x1 = tromino.get(1).x;
    int y1 = tromino.get(1).y;
    int x2 = tromino.get(2).x;
    int y2 = tromino.get(2).y;
    boolean canMove = true;

    // update x and y positions to desired locations for rotation
    switch(orientation) {      
    case 0:   
      x0 += 1; 
      y1 -= 1; 
      x2 -= 1;
      break;
    case 1:
      y0 += 1; 
      x1 += 1; 
      y2 -= 1;
      break;
    case 2:
      x0 -= 1; 
      y1 += 1; 
      x2 += 1;
      break;
    case 3:
      y0 -= 1; 
      x1 -= 1; 
      y2 += 1; 
      break;
    default:
      break;
    }


    // if any of the desired locations are either out of bounds
    // or not in open state trigger canMove to false
    if (!tromino.get(0).checkMove(x0, y0) ||
      !tromino.get(1).checkMove(x1, y1) ||
      !tromino.get(2).checkMove(x2, y2) ) {
      canMove = false;
    }

    // if all blocks can move update the current location to the
    // desired location and update position
    if (canMove) {
      tromino.get(0).x = x0;
      tromino.get(0).y = y0;
      tromino.get(0).updatePosition();
      tromino.get(1).x = x1;
      tromino.get(1).y = y1;
      tromino.get(1).updatePosition();
      tromino.get(2).x = x2;
      tromino.get(2).y = y2;
      tromino.get(2).updatePosition();

      // increment orientaiton on a succesful rotation
      orientation++;
      if (orientation > 3) orientation = 0;
    }
  }
  
  /**
   * rotate the irregular long Piece
   */
  void rotateIrregularLongPiece() {
    // store current x and y positions for each block in tromino 
    int x0 = tromino.get(0).x;
    int y0 = tromino.get(0).y;
    int x1 = tromino.get(1).x;
    int y1 = tromino.get(1).y;
    int x2 = tromino.get(2).x;
    int y2 = tromino.get(2).y;
    boolean canMove = true;

    // update x and y positions to desired locations for rotation
    switch(orientation) {      
    case 0:   
      y0 += 2;
      x2 -= 1; 
      y2 -= 1;     
      break;
    case 1:
      x0 -= 2; 
      x2 += 1; 
      y2 -= 1;      
      break;
    case 2:
      y0 -= 2; 
      x2 += 1; 
      y2 += 1;
      break;
    case 3:
      x0 += 2; 
      x2 -= 1; 
      y2 += 1;
      break;
    default: 
      break;
    }
    
    // if any of the desired locations are either out of bounds
    // or not in open state trigger canMove to false
    if (!tromino.get(0).checkMove(x0, y0) ||
      !tromino.get(1).checkMove(x1, y1) ||
      !tromino.get(2).checkMove(x2, y2) ) {
      canMove = false;
    }

    // if all blocks can move update the current location to the
    // desired location and update position
    if (canMove) {
      tromino.get(0).x = x0;
      tromino.get(0).y = y0;
      tromino.get(0).updatePosition();
      tromino.get(1).x = x1;
      tromino.get(1).y = y1;
      tromino.get(1).updatePosition();
      tromino.get(2).x = x2;
      tromino.get(2).y = y2;
      tromino.get(2).updatePosition();

      // increment orientaiton on a succesful rotation
      orientation++;
      if (orientation > 3) orientation = 0;
    }
  }
  
  /**
   * rotate the irregular pyramid piece
   */
  void rotateIrregularPyramidPiece() {
    // store current x and y positions for each block in tromino 
    int x0 = tromino.get(0).x;
    int y0 = tromino.get(0).y;
    int x1 = tromino.get(1).x;
    int y1 = tromino.get(1).y;
    int x2 = tromino.get(2).x;
    int y2 = tromino.get(2).y;
    boolean canMove = true;

    // update x and y positions to desired locations for rotation
    switch(orientation) {      
    case 0:   
      x0 += 1; 
      y0 -= 1;
      x1 += 1;
      y1 += 1;
      x2 -= 1; 
      y2 += 1;     
      break;
    case 1:
      x0 += 1; 
      y0 += 1; 
      x1 -= 1;
      y1 += 1;
      x2 -= 1; 
      y2 -= 1;      
      break;
    case 2:
      x0 -= 1; 
      y0 += 1; 
      x1 -= 1;
      y1 -= 1;
      x2 += 1; 
      y2 -= 1;
      break;
    case 3:
      x0 -= 1; 
      y0 -= 1; 
      x1 += 1;
      y1 -= 1;
      x2 += 1; 
      y2 += 1;
      break;
    default: 
      break;
    }
    
    // if any of the desired locations are either out of bounds
    // or not in open state trigger canMove to false
    if (!tromino.get(0).checkMove(x0, y0) ||
      !tromino.get(1).checkMove(x1, y1) ||
      !tromino.get(2).checkMove(x2, y2) ) {
      canMove = false;
    }

    // if all blocks can move update the current location to the
    // desired location and update position
    if (canMove) {
      tromino.get(0).x = x0;
      tromino.get(0).y = y0;
      tromino.get(0).updatePosition();
      tromino.get(1).x = x1;
      tromino.get(1).y = y1;
      tromino.get(1).updatePosition();
      tromino.get(2).x = x2;
      tromino.get(2).y = y2;
      tromino.get(2).updatePosition();

      // increment orientaiton on a succesful rotation
      orientation++;
      if (orientation > 3) orientation = 0;
    }
  }

  /**
   * Rotate the tromino clockwise
   * call this method generally and the approrpate
   * rotations will occur based on the tromino type/piece
   */
  void rotateShape() {
    switch(type) {
    case 0: 
      rotateLongPiece();
      break;
    case 1: 
      rotateLPiece();
      break;
    case 2: 
      rotateIrregularLongPiece();
      break;
    case 3:
      rotateIrregularPyramidPiece();
    break;
    default:
      break;
    }
  }

  /**
   * Method for pushing tromino to larger
   * list of blocks when tromino is set
   */
  void pushBlocks(ArrayList<Block> _b) {
    for (int i = 0; i < tromino.size(); i++) { 
      _b.add(tromino.get(i));

      int index = tromino.get(i).x + tromino.get(i).y * gridWidth;
      cells.get(index).state = 1;
    }
  }
  
  /**
  * start the land animation when tromino has settled
  */ 
  void startLandAnimation() {
    for (int i = 0; i < tromino.size(); i++) { 
      tromino.get(i).hasLanded = true;
    }
  }

  /**
   * Create new tromino of either long piece, L piece,
   * irregular long piece, or irregular pyramid piece
   *
   * @param {int} _t   the type of tromino to create
   */
  void createNewTromino(int _t) {
    orientation = 0; 
    type = _t;

    tromino = new ArrayList<Block>();
    switch(type) {
    case 0: // Long piece
      tromino.add(new Block(3, 0, color(246, 210, 174)));
      tromino.add(new Block(3, 1, color(246, 210, 174)));
      tromino.add(new Block(3, 2, color(246, 210, 174)));
      break;
    case 1: // L piece
      tromino.add(new Block(3, 1, color(157, 193, 209)));
      tromino.add(new Block(3, 2, color(157, 193, 209)));
      tromino.add(new Block(4, 2, color(157, 193, 209)));
      break;
    case 2: // irregular long
      tromino.add(new Block(4, 0, color(61, 98, 124)));
      tromino.add(new Block(3, 1, color(61, 98, 124)));
      tromino.add(new Block(3, 2, color(61, 98, 124)));
    break;
    case 3: // pyramid
      tromino.add(new Block(2, 2, color(232, 139, 106)));
      tromino.add(new Block(3, 1, color(232, 139, 106)));
      tromino.add(new Block(4, 2, color(232, 139, 106)));
    break;
    default:
      break;
    }
  }
}
