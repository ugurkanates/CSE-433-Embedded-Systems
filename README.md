# CSE-433-Embedded-Systems
CSE 433 Embedded Systems for GTU Computer Engineering Course by Dr Alp Arslan BAYRAKCI of GTU

## Project 1 - Bisection Method and Greatest Common Divider with FSM and LOGISIM
This is bisection method. Its mostly used for finding root of one unknown equations.
“Bisection Method = a numerical method in Mathematics to find a root of a given ... The
Bisection Method is given an initial interval [a..b] that contains a root
“


I implemented on Logisim, created C code, created State table, state diagram and put on expressions
according to inputs(boolean simplify)

It took 1.5 week to develop this project (along with 0.5 week for GCD HW0)
![alt text](https://i.ibb.co/pbgFzss/proj1.png)

It took me 20(ish) try on to get fully right. Reasons for this at %10 of my datapath (states) being not fully
viable for every step of C Code, %30 of hardness of putting state diagram / circuit / boolean’s to Logisim
control module I created , %60 of LOGISIM program not working correctly.( getting RED wire on places
that shouldnt be RED, auto wiring each input of D-Flip flops so creating major errors that kills your all
hope.)

I also struggled with IEEE754 jar library at first . I was developing inputs as pin so after discovering it had
constant inputs my whole design had to change(because of pin 32 bit multiply situtation) I was using
different bits for inputs and it was limited. Also I didn’t know it had probe so I was struggling for 2 days
straight.
![alt text](https://i.ibb.co/gjLXm0t/proj2.png)

### I have very detailed project report inside to read more on project 1 folder

## Project 2 - FPGA  Verilog LED Game using Buttons,7 Segment and more
For this project I have implemented 6 level Verilog game using Quartus II 13.0
Web Edition and used Visual Studio Code for prototyping Verilog files.

I have used 4 BCD 7 segment display.
Used 9 switch - used 9 LEDS.
Used Clock 50 Mhz
Reset Pin
Button Input as module inputs/outputs

### How game works :

I have 2 FSM inside the system.
First FSM starts with State_Start which initialize the data , outputs STR to BCD
then in next assignment we are going on

STATE LEVEL 1 = In loop if anyone not breaks the loop, Loop breaks with out signal

STATE_LEVEL_1_SORU = Its only triggered when out is 1 and question shows up
When user answers the question with Switch inputs(its arithmetic question) then
he needs to press START button for checking.

state_LEVEL1_Out_TruWait = Answer for level is correct, We need user to turn off
all switches, and BCD says TRU letters.

state_LEVEL1_Out_FalWait = Answer is false , we need user to turn off all
switches and BCD says FALS letters.

We have 6 LEVEL for this system.

Other FSM state is for loop of LED’s. 9:0 LEDS are in loop. They go their level
routes accordingly.

I have Counter module implemented

always @ (posedge Clock, posedge reset) begin

 if (reset) count <= 26'b0;
 
else if (pulse) count <= 26'b0;

else count <= count + 26'b1;

 end
 
 
List of end-Level Questions

LEVEL1 = 1 2 3 4 = 12+34 = 46

LEVEL2 = 4 2 1 5 = 42 -15 = 27

LEVEL3 = 1 2 1 1 = 12*11 = 132

LEVEL4 = 9 8 ‘ 7 = 98/7 = 14

LEVEL5 = Series of leds turn of in range and user must count number of them

LEVEL6 = Series of leds turn of in range and user must count number of

them(faster)

LEVEL 1 and LEVEL 2 works on slowClock 50mhz
LEVEL3 and LEVEL 4 works on midClock 50 mhz / 2
LEVEL5 and LEVEL6 50 mhz / 4 
![alt text](https://i.ibb.co/jGMVZfn/proj2.png)


## Project 3 - TIVA C  series ek-tm4c123gxl with Python
## Apartment Security System Prototype 
### Tiva C = Server
### Python = Client

In this project i have developed a system which TIVA C acts as server and uses Timer to send data via UART to USB connected PC

Python(3.5) client always listens UART port and connect if there is any connection

I am checking data verification with parity bits.

When data is arrived(1 second delay) python takes photo with OpenCV library and saves it to pc.

Basically if you use external camera it would be WiFi server of security system.

If you press SW1 button on TIVA C it would break connection and python client ends itself.
![alt text](https://i.ibb.co/nmjkkp4/filename15.jpg)

This is pic taken from my laptop's webcam during demo of project.
