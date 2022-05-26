/*
 * Simple class for creating a node that will serve
 * to create triangles in a 2D array
 *
 */
class Node {
  float x, y, z;      // x, y positions (index) and z value

  /*
   * Constructor method for setting x and y position of node
   *
   * @param: _x    the x position of node
   * @param: _y    the y position of node
   */
  Node(float _x, float _y) {
    x = _x;
    y = _y;
    z = 50;
  }
  
  /*
   * display the node using an ellipse
   */
  void display() {
    fill(0);
    ellipse(x, y, 1, 1);
  }
}
