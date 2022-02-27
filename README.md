# screensaver-with-vga

A VGA driver to implement a square 41x41 screensaver that sequentially cycles through all RGB colors as it moves.

This project was assigned for the Digital System Design (EE 240) course on Spring 2021 semester.



## Design

Overall, this project contains 4 VHDL modules:


### 1. Clock Division

These modules are clock dividers for getting 60 Hz and 25 MHz clock frequencies. We
implemented the clock dividers by keeping a counter that increments with the board_clock
positive edge which is 100 MHz. We have divided the clock by 416666 and 4 for 60 Hz and
25 MHz clock outputs respectively.


### 2. VGA Driver

This module is for designing a standard 640x480 screen with a 60 Hz refresh rate. We have
kept the front porch, back porch, display time, and pulse width (retrace) line widths in constant
integers. Our alignment of intervals is as shown in Figure 1. Starting from display time we
increment hpos with every 25 MHz positive clock edge until we reach the end of the back porch,
after that, we reset the hpos. We increment vpos with every 25 MHz clock positive edge when
hpos reaches the end of its back porch and we reset the vpos when it also reaches its back
porch’s end. We create a video_on signal during the interval where both vpos and hpos are
in their display time to handle blanking intervals. Module outputs video_enable signal to
color generator module and hsync, vsync signals for main module’s output.


### 3. Square Position Updating Module

This module takes the 60 Hz clock signal as the Enable input signal and outputs the x and y
positions of the 41x41 icon. The direction of the icon is stored as a 2-bit logic vector and the
position of the ball is incremented along the given direction of the ball by 1. The position of
the ball is updated when the internal 3-bit count signal has reached “111”. So the position
updating takes place once every 8 frames. Meaning that the ball moves 60 / 8 = 7.5 pixels
in both horizontal and vertical axes so the moving angle is 45 degrees.


### 4. Color Generator

There are two counters included in this module. The first counter tracks the index of the last
pixel which is displayed on the video. The second counter tracks the index of the last pixel whether
it is displayed on the video or not. When the second counter hits the max limit, both counters reset
to 0. There are 480x640 displayed pixels and 721x800 total pixels in one frame. About a quarter
of the total pixels are invisible to the viewer, so we have to keep a separate counter for the latter.

In an indexing scale where the pixels are enumerated from 1 to 480x640, the index of the
position of the left corner of the square can be expressed as “x + y * 640”. We can determine
whether the incoming pixel is in the square range or not by checking if the current pixel index
is in the following range:
```
𝑠𝑞𝑢𝑎𝑟𝑒_𝑝𝑜𝑠 + 𝑖 * 𝑠𝑐𝑟𝑒𝑒𝑛_𝑤𝑖𝑑𝑡ℎ < 𝑐𝑢𝑟𝑟_𝑝𝑖𝑥𝑒𝑙_𝑖𝑛𝑑𝑒𝑥 < 𝑠𝑞𝑢𝑎𝑟𝑒_𝑝𝑜𝑠 + 𝑠𝑞𝑢𝑎𝑟𝑒_𝑤𝑖𝑑𝑡ℎ + 𝑖 * 𝑠𝑐𝑟𝑒𝑒𝑛_𝑤𝑖𝑑𝑡ℎ
for any 𝑖 = {0, 1, 2, ..., 𝑠𝑞𝑢𝑎𝑟𝑒_ℎ𝑒𝑖𝑔ℎ𝑡}
```
If the current pixel index is not in any of these ranges, we can determine that the pixel
doesn’t belong to the icon so it must be black.



## Authors

👤 **Aras Güngöre**

* LinkedIn: [@arasgungore](https://www.linkedin.com/in/arasgungore)
* GitHub: [@arasgungore](https://github.com/arasgungore)

👤 **Aybars Manav**

* LinkedIn: [@aybarsmanav](https://www.linkedin.com/in/aybarsmanav)
* GitHub: [@AybarsManav](https://github.com/AybarsManav)
