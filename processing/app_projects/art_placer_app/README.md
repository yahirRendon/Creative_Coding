
<h1 align="center">Art Placer App</h1>

<p align="center">
  A tool for overlaying an image of a piece of artwork on top above a background. 
  Various settings can be adjusted to recreate a faux shadow for enhanced realism. 
</p>

##  Dev Notes
<p align="center">
  There were a couple of challenges while developing this project. The first was figuring out how to 
  select and order the vertices of a generated shadow in such a way to only include points along the perimeter.
  I attempted to implement my own approach and got pretty close but had a few edge cases that made it imperfect. 
  In doing further research I disocovered that a solution to this was to use a hull algorithm. With some further
  research I was able to implement a quick hull algorithm. 
</p>

<p align="center">
  I initially attempted to create the shadow in 2D but found limitations when trying to mimick
  3D shadows so I moved to the P3D rendering in Processing. However, I had to then find a way to find
  the point at which a light ray intersected the plane on which the background image laid. After researching
  some math forums found a way using line/plane intersection. This worked incredible well and coupled withe the 
  prevously mentioned quick hull algorithm I was able to work out the core mechanism of this project. 
</p>

## Preview
<p align="center">
  <img width="350" align="center" src="https://github.com/yahirRendon/creative_coding/blob/main/processing/app_projects/art_placer_app/data/mk-s-yh38-HUCces-unsplash_adj-art-placer.jpg" alt="ui example"/>
  <img width="350" align="center" src="https://github.com/yahirRendon/creative_coding/blob/main/processing/app_projects/art_placer_app/data/pexels-blank-space-2647714_adj-art-placer.jpg" alt="ui example"/>
</p>
<p align="center">
  <img width="700" align="center" src="https://github.com/yahirRendon/creative_coding/blob/main/processing/app_projects/art_placer_app/data/pexels-rachel-claire-4857775_adj-art-placer.jpg" alt="ui example"/>
</p>
<p align="center">
  Photo by <a href="https://unsplash.com/@mk__s?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">mk. s</a> on <a href="https://unsplash.com/photos/yh38-HUCces?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a><br>
  Photo by <a href="https://www.pexels.com/photo/green-leafed-potted-plant-on-bistro-table-2647714/](https://www.pexels.com/@blankspace/">Blank Space. </a> on <a href="https://www.pexels.com/photo/green-leafed-potted-plant-on-bistro-table-2647714/">Pexels</a><br>
  Photo by <a href="https://www.pexels.com/@rachel-claire/">Rachel Claire.</a> on <a href="https://www.pexels.com/photo/cozy-sofa-and-bed-in-contemporary-studio-apartment-4857775/">Pexels</a><br> 
  
  
</p>

##  Instructions &nbsp;&nbsp;&nbsp;&nbsp;
<p>
  - LEFT MOUSE: click and drag within artwork canvas to move<br>
  - RIGHT MOUSE: click and drage horizonontally within artwork canvas to resize<br>
  - SPACE KEY: toggle user interface<br>
  - 'd' KEY: toggle dark mode<br>
  - 'a' KEY: load new artwork image<br>
  - 'b' KEY: load new background image<br>
  - 's' KEY: save image of current frame<br>
  - 'l' KEY: add additional light source<br>
  - LEFT ARROW: with ui active cycle through light/shadow settings down<br>
  - RIGHT ARROW: with ui active cycle through light/shadow settings up<br>
  - UP ARROW: with ui active cycle throuhg light sources up<br>
  - DOWN ARROW: with ui active cycle through light sources down<br>
</p>

## UI Review
- coming soon

## To Do
<p>- fix text placement (z-axis)<br>
  - allow shadow alpha to take on different tones other than black
  - add border
  - textured canvas effect
</p>

## Usage Notes
<p>- Processing 4.5.4^
<br>- Ensure the .pde file is contained within a folder of the exact same name
</p>
