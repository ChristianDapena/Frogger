# Frogger

The lab project is a copy of the game Frogger designed to be played on an FPGA. Like 
the classic 1981 title, this game will allow the user to control a frog (represented by 1 green 
LED) on a display (16 x 16 Bicolor LED Expansion Board). This frog will have four motion 
controls: LEFT (KEY[3]), UP (KEY[2]), DOWN (KEY[1]), and RIGHT (KEY[0]). The user 
will use these button motion controls (built in to the DE1-SoC FPGA Board) to maneuver their 
frog to the other side of the display. 
As the titular frog traverses the display, from one end to the other, it will need to navigate 
a busy, chaotic freeway filled with random oncoming traffic from both sides. If the frog 
navigates to the top of the display (row 16), it wins the game. 12 of the 16 rows of the 16 x 16 
display will be able to randomly spawn a vehicle (represented by a red LED) to traverse from 
one end of its row to the other at a set speed. Car speed can be set by adjusting SW[4:0] to adjust 
how frequently the “enable” that triggers the LFSR occurs (larger SW[4:0] value = slower 
speed). Spawns are pseudo-randomly decided on by a XNOR LFSR comparing against a set 
maximum car spawn value, once per divided clock cycle.  There are four “safe” rows where no 
cars will spawn: the bottom and top rows, and two rows in between, to make the game more 
playable and strategic.  
If a car occupies the same LED position as the frog, the frog is “run over”, and the game 
ends. At any point in the game, including after being run over or achieving victory, the user can 
reset the game to its starting conditions using a “RESET” switch (SW[9]) and begin the game 
again. This will, of course, result in all progress being lost. 

See "Final Project.pdf" for more details and block diagram
