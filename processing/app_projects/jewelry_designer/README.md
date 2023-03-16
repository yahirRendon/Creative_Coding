
<h1 align="center">Jewelry Designer</h1>

<p align="center">
  A tool for designing loom beaded jewelry with embedded binary.
  <br>Take a string of text and convert it to binary and embed the result within the beads. 
</p>

## Dev Notes
<p align="center">
  I had the desire to create predefined layout designs using non-linear interpolation. I wanted them to be symmetrical accross the
  center row. It caused me a few headaches but was able to find a solution that generated the same inputs but in reverse order for the top and bottom
  half to ensure symmetry. Oddly, I found the random layout to be the most applying when actually working with beads. There are a lot of additional 
  features that can be implemented but for the purpose of my own jewelry making this serves as a great tool. 
</p>

## Preview
<p align="center">
  <img width="600" align="center" src="https://github.com/yahirRendon/creative_coding/blob/main/processing/app_projects/jewelry_designer/data/jewerly-designer-ui-ex.png" alt="ui example"/>
</p>

##  Instructions
<p>
  - Adjust the bead layout using the user settings on the right.<br>
  - Edit the text field to embed your own message.<br>
  - SPACE BAR or DOWN ARROW | Move the row guide down.<br>
  - UP ARROW | Move the row guide up,
</p>

##  Grid Features
<table>
 <tr>
    <td>
      <img width="300" src="https://github.com/yahirRendon/creative_coding/blob/main/processing/app_projects/jewelry_designer/data/jd-grid-ui.gif" alt="ui grid example"/>
   </td>
    <td>
      <table>
        <tr>
          <td>- increase or decrease the display bead size</td>
        </tr>
        <tr>
          <td>- scroll the beads up or down within the container window</td>
        </tr>
        <tr>
          <td>- mouse over bead to reveal bead number in the bottom left corner</td>
        </tr> 
        <tr>
          <td>- left click to make bead open to holding message bit</td>
        </tr>
        <tr>
          <td>- right click to remove bead from holding message bit</td>
        </tr> 
        <tr>
          <td>- red bead represents unassigned bit value within current spread style</td>
        </tr>
        <tr>
          <td>- dark bead represents bit value of 0 within message</td>
        </tr>
        <tr>
          <td>- light bead represents bit value of 1 within message</td>
        </tr>
        <tr>
          <td>- white bead is a filler bead and not part of message</td>
        </tr>
      </table>
    </td>
 </tr>
</table>

##  Guide Features
<table>
 <tr>
    <td>
      <img width="300" src="https://github.com/yahirRendon/creative_coding/blob/main/processing/app_projects/jewelry_designer/data/jd-guide-ui.gif" alt="ui guide example"/>
   </td>
    <td>
      <table>
        <tr>
          <td>- move up and down individual rows to make beading easer</td>
        </tr>
        <tr>
          <td>- see bead row in bottow left corner</td>
        </tr>
      </table>
    </td>
 </tr>
</table>

##  Message Features
<table>
  <tr>
    <td>
      <img width="600" src="https://github.com/yahirRendon/creative_coding/blob/main/processing/app_projects/jewelry_designer/data/jd-message-ui.gif" alt="ui message example"/>
    </td>
  </tr>
  <tr>
    <td>- edit text via the edit icon</td>
  </tr>
  <tr>
    <td>- text appears read when editing</td>
  </tr>
  <tr>
    <td>- bead bit values update in real time with text</td>
  </tr>
  <tr>
    <td>- working backspace, clear/delete, left arrow, and right arrow</td>
  </tr>
</table>

##  Settings Features
<table>
  <tr>
    <td>
      <img width="600" src="https://github.com/yahirRendon/creative_coding/blob/main/processing/app_projects/jewelry_designer/data/jd-settings-ui.gif" alt="ui settings example"/>
    </td>
  </tr>
  <tr>
    <td>rows - add/remove rows of beads from grid</td>
  </tr>
  <tr>
    <td>columns - add/remove columns of beads from grid</td>
  </tr>
  <tr>
    <td>vertical margin - increase/decrease vertical bead margin</td>
  </tr>
  <tr>
    <td>horizontal margin - increase/decrease horizontal bead margin</td>
  </tr>
  <tr>
    <td>solid span - increase/decrease number of solid rows from center</td>
  </tr>
  <tr>
    <td>gap: increase/decrease gap between spread</td>
  </tr>
  <tr>
    <td>spread style: built-in spread styles<br>
    &nbsp;&nbsp;&nbsp;&nbsp;- gap fill: alternating from center**<br>
    &nbsp;&nbsp;&nbsp;&nbsp;- sine out: uses sine interpolation from center*<br>
    &nbsp;&nbsp;&nbsp;&nbsp;- quad out: uses quadratic interpolation from center*<br>
    &nbsp;&nbsp;&nbsp;&nbsp;- expo out: uses exponential interpolation from center*<br>
    &nbsp;&nbsp;&nbsp;&nbsp;- random all: random distribution with gap value controlling density<br>
    &nbsp;&nbsp;&nbsp;&nbsp;- random solid: random but solid span adjustable<br>
    &nbsp;&nbsp;&nbsp;&nbsp;- sine in: uses sine interpolation from ends*<br>
    &nbsp;&nbsp;&nbsp;&nbsp;- quad in: uses quadratic interpolation from ends*<br>
    &nbsp;&nbsp;&nbsp;&nbsp;- expo in: uses exponential interpolation from ends*<br>
    &nbsp;&nbsp;&nbsp;&nbsp;- all open: all beads open excluding vertical and horizontal margins*<br>
    &nbsp;&nbsp;&nbsp;&nbsp;* solid span adjustable<br>
    &nbsp;&nbsp;&nbsp;&nbsp;* solid span and gap adjustable<br>
    </td>
  </tr>
  <tr>
    <td>bead size: adjust bead size for dimension calculation only</td>
  </tr>
</table>

## To Do
<p>- make bead color selectable
</p>

## Usage Notes
<p>- Processing 4.5.4^
<br>- Ensure the .pde file is contained within a folder of the exact same name
</p>
