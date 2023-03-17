/******************************************************************************
 Project:  messing around with image reveal. alpha value moves up and down and
 is used to transition between images with a grid layout.
 
 Author:   Yahir
 Date:     July 2019
 
 Notes:    processing 3.5.4
 ******************************************************************************/

int blockSize;                // the box size
int gridW;                    // width of grid
int gridH;                    // height of grid
int offsetX;                  // set grid offset x for variable image size
int offsetY;                  // set grid offset y for vraible image size

ArrayList<RevealBox> boxes;   // array holding all boxes in grid
ArrayList<PImage> images;     // array holding images to cycle through

/******************************************************************************
 * 
 * setup method
 * 
 *****************************************************************************/
void setup() {
  size(1000, 1000);

  // load images into an array
  String path = "C:/Users/yahir/Downloads/data/proj/";
  images = new ArrayList<PImage>();
  images.add(loadImage(path + "u_01.jpg"));
  images.add(loadImage(path + "u_02.jpg"));
  images.add(loadImage(path + "u_03.jpg"));
  images.add(loadImage(path + "u_04.jpg"));
  images.add(loadImage(path + "u_05.jpg"));
  images.add(loadImage(path + "u_06.jpg"));
  images.add(loadImage(path + "u_07.jpg"));
  images.add(loadImage(path + "u_08.jpg"));
  //images.add(loadImage(path + "u_09.jpg"));
  
  for(PImage img : images) {
    img.resize(800, 800);
  }
  
  // defing grid
  blockSize = 100;
  gridW = (images.get(0).width)/blockSize;
  gridH = (images.get(0).width)/blockSize;
  
  offsetX = (width - images.get(0).width) / 2;
  offsetY = (height - images.get(0).height) / 2;
  
  // generate grid
  boxes = new ArrayList<RevealBox>();
  for (int y = 0; y < gridH; y++) {
    for (int x = 0; x < gridW; x++) {
      boxes.add(new RevealBox(x, y, blockSize));
    }
  }
  
  delay(10000);
}

/******************************************************************************
 * 
 * draw method
 * 
 *****************************************************************************/
void draw() {
  background(252, 248, 248);
  noStroke();
  
  // update canvas pixels in current image
  loadPixels();
  for (int i = 0; i < boxes.size(); i++) {
    boxes.get(i).update();
  }
  updatePixels();
  
  // update and display the overlayed box 
  for (int i = 0; i < boxes.size(); i++) {
    boxes.get(i).display();
    boxes.get(i).updateBox();
  }
}

/******************************************************************************
 *
 * class for creating boxes that will make up image and overlay box
 *
 *****************************************************************************/
class RevealBox {
  int xpos, ypos;          // the x and y position of box
  int boxSize;             // the size of the box
  float r, g, b, a;        // the r, g, b, a color values

  int switches;            // track number of switchs at alpha value limits
  int counter;             // assist in changing box color and images
  int colorIndex;          // track index value for color box
  int imageIndex;          // track index value for image look up
  float aSpeed;            // the speed of alpha value change
  ArrayList<PVector> pxls; // hold pixels of box corresponding to image section
  
  /******************************************************************************
   * constructor
   * 
   * @param  _x         the x position of the box
   * @param  _y         the y position of the box
   * @param  _s         the size of the box
   *****************************************************************************/
  RevealBox(int _x, int _y, int _s) {
    boxSize = _s;
    xpos = _x * boxSize;
    ypos = _y * boxSize;
    a = int(random(0, 150));
    aSpeed = 1;
    imageIndex = 0;
    colorIndex = 0;
    updateColor();
    switches = 0;
    counter = 0;
  }
  
   /******************************************************************************
   * 
   * update the alpha value and the image pixels
   * 
   *****************************************************************************/
  void update() {

    // update alpha and number of reveals
    a += aSpeed;
    if (a < 0 || a > 255) {
      aSpeed *= -1;
      if (a < 0 || a > 255) switches ++;
    }

    // update background image pixels
    for (int y = ypos; y < ypos + boxSize; y++) {
      for (int x = xpos; x < xpos + boxSize; x++) {
        int index = (x + offsetX) + (y + offsetY) * width;
        int index2 = (x) + (y) * images.get(imageIndex).width;
        pixels[index] = color(images.get(imageIndex).pixels[index2]);
      }
    }
  }
  
   /******************************************************************************
   * 
   * display the color box
   * 
   *****************************************************************************/
  void display() {
    fill(r, g, b, a);
    rect(offsetX + xpos, offsetY + ypos, boxSize, boxSize);
  }
  
   /******************************************************************************
   * 
   * update the state of the box. color box transition. image transiton.
   * 
   *****************************************************************************/
  void updateBox() {
    if (switches == 1) {
      switches = 0;
      counter++;
      switch(counter) {
      case 1:
        imageIndex++;
        if (imageIndex > images.size() - 1) imageIndex = 0;
        updateImage();
        break;
      case 2:
        colorIndex++;
        if (colorIndex > images.size() - 1) colorIndex = 0;
        updateColor();
        counter = 0;
        break;
      }
    }
  }
  
   /******************************************************************************
   * 
   * update pxls array to new image
   * 
   *****************************************************************************/
  void updateImage() {
    pxls = new ArrayList<PVector>();
    for (int y = ypos; y < ypos + boxSize; y++) {
      for (int x = xpos; x < xpos + boxSize; x++) {
        int index = x + y * images.get(imageIndex).width;
        pxls.add(new PVector(red(images.get(imageIndex).pixels[index]), 
          green(images.get(imageIndex).pixels[index]), 
          blue(images.get(imageIndex).pixels[index])));
      }
    }
  }
  
   /******************************************************************************
   * 
   * update the color of the box based on average color value in box from image
   * 
   *****************************************************************************/
  void updateColor() {
    float rtemp = 0;
    float gtemp = 0;
    float btemp = 0;
    int num = 0;
    for (int y = ypos; y < ypos + boxSize; y++) {
      for (int x = xpos; x < xpos + boxSize; x++) {
        int index = x + y * images.get(colorIndex).width;

        rtemp += red(images.get(colorIndex).pixels[index]);
        gtemp += green(images.get(colorIndex).pixels[index]);
        btemp += blue(images.get(colorIndex).pixels[index]);
        num++;
      }
    }
    
    // average values
    r = rtemp/num;
    g = gtemp/num;
    b = btemp/num;
  }
}
