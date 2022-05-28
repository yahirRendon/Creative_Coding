/*
 * simple class for creating a buttons that works with the dial class.
 * the buttons are designed to be grouped (max 3) with others such that
 * one dial can hold several and adjust several values. The button state
 * tracks and updates whether the button has been selected or note,
 * (true or false). Additionally the button stores values for a
 * value that can be manipulated by the slider. 
 */
class ButtonDial {
  int x, y;              // x and y position of button
  int w;                 // width of button
  int h;                 // height of button
  boolean state;         // boolean state/value of button (true = selected)
  String name;           // name of button
  String description;    // short description of what button does
  
  float value;           // value of button (modified when active)
  float min;             // min value
  float max;             // max value
  
  int nameSize;          // text size of name
  color cNameTrue;       // name color when true
  color cNameFalse;      // name color when false
  color cNameActive;     // name color when active
    
  /*
   * constructor method for creating a button
   *
   * @param _name           initial boolean value of button
   * @param _description    initial boolean value of button
   * @param _initState      inital boolean state/value of button
   * @param _min            min value of button
   * @param _max            max value of button
   * @param _initialValue   initial value of button
   */
  ButtonDial(String _name, String _description, boolean _initState, float _min, float _max, float _initialValue) {
    x = 0;
    y = 0;
    name = _name;
    description = _description;
    state = _initState;
    w = 60;
    h = 20;
    
    value = _initialValue;
    min = _min;
    max = _max;
    
    nameSize = 18;
    cNameTrue = color(0, 0, 95);
    cNameFalse = color(0, 0, 70);
    cNameActive = color(0, 0, 100);  
  }
  
  /**
  * set the position of the button
  *
  * @param {int} _x    x position
  * @param {int} _y    y position
  */
  void setPosition(int _x, int _y) {
    x = _x;
    y = _y;
  }
  
  /**
  * set the description of the button
  *
  * @param {String} _description    short description of the button
  */
  void setDescription(String _description) {
    description = _description;
  }
  
  /**
  * set the value of the button
  *
  * @param {float} _value    the value of the button
  */
  void setValue(float _value) {
    value = _value;
  }
  
  /**
  * get the value of the button
  *
  * @return      the button value
  */
  float getValue() {
    return value;
  }
  
  /**
  * get the min value for the button
  *
  * @return      the min value
  */
  float getMin() {
    return min;
  }
  
  /**
  * get the max value for the button
  *
  * @return      the max value
  */
  float getMax() {
    return max;
  }
  
  /**
  * get the description of the button
  *
  * @return      the button description
  */
  String getDescription() {
    return description;
  }
  
  void reset() {
    
  }
  
  /**
  * display the button with just text
  */
  void display() {
    textAlign(CENTER, CENTER);
    
    if(active()) {
        fill(mainHue, 100, 100);
      } else {
      if(state) {
        fill(cNameTrue);
      } else {
        fill(cNameFalse);
      }
    } 
      
    textSize(nameSize);   
    text(name, x + (w/2), y + (h/2));
  
  }
  
  /**
  * update the button state
  */
  void updateState() {
    if(active()) {
      state = !state;
    }       
  }
  
  /**
  * check if mouse is within button
  *
  * @return      return true if mouse is within button
  */
  boolean active() {
    if (mouseX > x && mouseX < x + w &&
      mouseY > y && mouseY < y + h) {
      return true;
    } else {
      return false;
    }
  }
}
