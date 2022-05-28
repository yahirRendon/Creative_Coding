/*
 * Class for creating a basic round dial that can control
 * multiple values by using the buttonDial class
 */
class Dial {
  int x, y;                  // Center position of dial
  String name;               // name of button
  String description;        // optional description for button
  int valueIndex;            // track which button is active
  int numButtons;            // set to number of buttons (max 3)
  int len;                   // Radius of dial
  int diam;                  // Diameter of dial
  float angle;               // Angle for rotation
  float rval;                // Raw value of angular rotation
  float dialValue;           // Value to be used between min and max
  float dialMin, dialMax;    // Min and max range of dial
  int nameSize;              // text size for name
  int valueSize;             // text size for value
  int numRound;              // number to round value display to.
  
  color cBackground;         // background color
  color cForeground;         // foregournd color
  color cName;               // name color
  color cValue;              // value color
  color cActive;             // color when dial active

  ButtonDial[] buttons;      // array of buttons to hold additional values
  
  /*
   * Constructor method for setting x and y position of node
   *
   * @param: _x        x position CENTER
   * @param: _y        y position CENTER
   * @param: _name     name of dial
   * @param: _buttons  array of buttonDials to control multiple values
   *
   */
  Dial(int _x, int _y, String _name, ButtonDial[] _buttons) {
    x = _x;
    y = _y;
    len = 160;
    diam = len * 2;
    name = _name;   
    numButtons = _buttons.length;   
          
    buttons = _buttons;
    int btnLen = buttons[0].w;
    int xoff = x - btnLen/2;
    int yoff = y + len - 10;
    if(numButtons == 1) {
      buttons[0].setPosition(xoff, yoff);
    }
    else if(numButtons == 2) {
      buttons[0].setPosition(xoff - btnLen, yoff);
      buttons[1].setPosition(xoff + btnLen, yoff);
    } else {    
      buttons[0].setPosition(xoff - btnLen, yoff);
      buttons[1].setPosition(xoff, yoff);
      buttons[2].setPosition(xoff + btnLen, yoff);     
    }
     
    valueIndex = 0;
    dialValue = buttons[valueIndex].getValue();
    dialMin = buttons[valueIndex].getMin();
    dialMax = buttons[valueIndex].getMax();
   
    // map position bases on min, max, and start value of current button
    rval = map(dialValue, dialMin, dialMax, 135, 405);
    angle = rval;
   
    // style elements
    numRound = 1;
    nameSize = 18;
    valueSize = 24;
    cBackground = color(0, 0, 75);
    cForeground = color(0, 0, 85);
    cName = color(0, 0, 85);
    cValue = color(0, 0, 85);
    cActive = color(0, 0, 100);      
  }
  
  /**
  * set the value index
  *
  * @ param _index        integer between 0 and 3
  */
  void setIndex(int _index) {
    valueIndex = _index;
  }
 
  /**
  * get the value at index
  *
  * @param _index      integer between 0 and 3
  * @return            the value at _index
  */
  float getValue(int _index) {
    return buttons[_index].getValue();
  } 
 
  /**
  * Update dial values and elements
  */
  void update() {
    // if selected calculate angle to determine value setting
    
    if (selected()) {
      angle = ((degrees(atan2(mouseY - y, mouseX - x)) + 720) % 360);
    }
   
    // adjust for angle 0 location
    if (angle >= 0 && angle <= 90) {
      rval = 360 + angle;
    } else {
      rval = angle;
    }

    if (rval < 135) {
      rval = 135;
      angle = 135;
    }
    if (rval > 405) {
      rval = 405;
      angle = 45;
    }
   
    // map dial value as desired
    dialValue = map(rval, 135, 405, dialMin, dialMax);
    buttons[valueIndex].setValue(dialValue);
  }
 
  /**
  * display dial elements
  */
  void display() {  
    update();
    
    // visually display total dial value range
    noStroke();  
    noFill();
    stroke(cBackground);
    strokeWeight(5);
    arc(x, y, diam, diam, radians(135), radians(405));

    // visually display current dial value  
    strokeWeight(5);
    stroke(cForeground);
    if(active()) {
      stroke(cActive);
    }
    arc(x, y, diam, diam, radians(135), radians(rval));
    
    strokeWeight(5);
    stroke(mainHue, 100, 100, 50);
    arc(x, y, diam, diam, radians(135), radians(rval));
   
    // text settings to display dial name and value
    textAlign(CENTER, CENTER);
    textSize(nameSize);
   
    // position name and display
    float nameY = y + sin(radians(135)) * len;
    fill(cName);
    if(active()) {
      fill(cActive);
    }
    text(name, x , nameY);
     
    // round and display value
    textSize(valueSize);
    //float displayValue = (float)(Math.round(dialValue * Math.pow(10, 3)) / Math.pow(10, 3)); 
    String displayValue = nf(dialValue, 1, numRound);
    fill(cValue);
    if(active()) {
      fill(cActive);
    }
    text(displayValue, x, y);
    
    // display buttons and description when active
    for(int i = 0; i < buttons.length; i++) {
      buttons[i].display();
      if(buttons[i].active()) {
        fill(0, 0, 100);
        textSize(16);
        text(buttons[i].getDescription(), x, y + len + 40);
      }
    }
       
    // Reset values to avoid impact other sketch elements
    strokeWeight(1);
  }
 
  /**
  * check and update buttons as necessary.
  * place this in mouseClicked
  *
  */
  void updateButtonState() {
    for(int i = 0; i < buttons.length; i++) {
      if(buttons[i].active()) {
        valueIndex = i;
        buttons[i].state = true;  
      }
    }
    
    for(int i = 0; i < buttons.length; i++) {
      if(valueIndex != i) {
        buttons[i].state = false;  
      }
    }
    dialMin = buttons[valueIndex].getMin();
    dialMax = buttons[valueIndex].getMax();
    dialValue = buttons[valueIndex].getValue();
    rval = map(dialValue, dialMin, dialMax, 135, 405);
    angle = rval;
  }
 
  /**
  * Check if the mouse is within area of dial
  *
  * @return true if within area else false
  */
  boolean active() {
    if (abs(dist(mouseX, mouseY, x, y)) < len + 10 && mouseY < y + len - 10) {
      return true;
    } else {
      return false;
    }
  }
 
  /**
  * Check if the dial is selected
  *
  * @return true if within and mousePressed else false
  */
  boolean selected() {
    if (mousePressed && active()) {
      return true;
    } else {
      return false;
    }
  }
}
