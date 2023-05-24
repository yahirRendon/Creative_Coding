<h1 align="center">Terrain</h1>

<p align="center">
  An endlessly mesmerizing terrain generating experience. After watching some game design videos on procedural terrain generation I came up with the idea of creating a grid that would appear to flow naturally over hills and valleys. The result was a very calming output with some fun and unique features
</p>

<h3 align="center">Demo</h3>

<p align="center">
  <img alt="default terrain"  width="800" align="center" src="https://github.com/yahirRendon/creative_coding/blob/main/processing/audio_projects/terrain/data/terrain_anim.gif"/>

<p>- SPACE to show/hide settings
<br>- LEFT CLICK  | in main screen click to scult edge terrain nodes through repelling
<br>- LEFT CLICK  | in settings screen click or drag to adjust dials
<br>- RIGHT CLICK | in main screen click to sclupt edge terrain nodes through attraction
<br>- Settings explained:
<br>- SIZE: adjust the radius for sculpting the edge terrain
<br>- MAIN: adjust the hue of the main terrain
<br>- EDGE: adjust the hue of the edge terrain
<br>- CLEAR: reset the edge terrain nodes
<br>- RESET: reset all settings to default
<br>- MONITOR: when on the audio in controls the speed of terrain navigation
<br>- MONITOR: when off (DEFAULT) the terrain navigation speed is controlled by feel setting
<br>- FEEL: on default sets the speed of navigation. When monitor is on this sets the sensativity level of aduio in
<br>- PEAK: adjust the vertical variance introduced into the terrain
<br>- FLOW: adjust the horizontal variance introduced into the terrain
<br>- Left click on red button to reset grid
</p>

<h3 align="center">Challenges and Features</h3>
<p>
  Created my GUI Dials that each have three individual settings that can be controlled. This has been generalized into a class that can be found in the processing-snips section of GitHub. How to create an attract and repeal ability for pushing and pulling the edge terrain nodes. This has also been generalized within processing-snips. 
</p>
<p>
  Using the monitor in feature makes the project quite interactive as it speeds up and slows down based on the sounds around you. I was also able to make all of the elements adjustable based on the window size. This allows you to maximize the window and the elements will reset to the appropriate location. Additionally, going into the code and uncommenting the fullscreen() method will further make the viewing experience more immersive. 
</p>

<h3 align="center">Examples</h3>
  
<p align="center">
  <img alt="default terrain"  width="500" align="center" src="https://github.com/yahirRendon/creative_coding/blob/main/processing/audio_projects/terrain/data/terrain_anim_01.gif"/>
  <img alt="settings"  width="500" align="center" src="https://github.com/yahirRendon/creative_coding/blob/main/processing/audio_projects/terrain/data/terrain_anim_02.gif"/>
</p>
  
<p align="center">
  <img alt="settings modify"  width="500" align="center" src="https://github.com/yahirRendon/creative_coding/blob/main/processing/audio_projects/terrain/data/terrain_anim_03.gif"/>
  <img alt="terrain modified"  width="500" align="center" src="https://github.com/yahirRendon/creative_coding/blob/main/processing/audio_projects/terrain/data/terrain_anim_04.gif"/>
</p>

<h3>Usage Notes</h3>
* Processing 3.5.4
* Ensure the main .pde file is within a folder of the exact same name along with other .pde files

<h1 align="center">Enjoy!</h1>
  
  
 

  
  
  





