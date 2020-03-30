import java.util.Timer;
import java.util.TimerTask;
import java.io.*;
import processing.opengl.*;
import ddf.minim.*;

boolean isOn = false;

// Use Minim lib
Minim minim = new Minim(this); 
// Create instance of mp3 player
AudioPlayer  player1; 

// creation of new Timer object
public Timer myTimer = new Timer();
  
public TimerTask beep = new TimerTask(){
  public void run() {
    playsound("beep.mp3");
  }
};  

public TimerTask onOff = new TimerTask() {
  
  //this run() is executed when timer elapses
  public void run() {
    if (isOn == true){
      isOn = false;
      
    }
    else 
      isOn = true;
  }
};

// layout variables (in pixels)
int rectSize = 300; //size of square sizes
int margin = 90; // distance between window border and square
int textDist = 40; // distance between square and command captions


//setup runs once
void setup(){
  // setup display
  size(displayWidth, displayHeight,OPENGL);
  stroke(0);
  smooth();
  background(0);
  // make the window resizable
  if (frame != null) {
    frame.setResizable(true);
  }
  rectMode(CORNER);
  sketchFullScreen();
  myTimer.scheduleAtFixedRate(onOff, 5000, 5000); //waits 5000ms to "fire" for 1st time, then "fires" every 5000ms
  myTimer.scheduleAtFixedRate(beep, 4000, 10000); //waits 4000ms to "fire" for 1st time, then "fires" every 10000ms
}

boolean on=true;
void draw() {
  if (isOn == true){
    commandCaptions();
    /////////////////////////////////////////
    // Number of frames in 1 blink "loop": 3    this number is used in the code
    // duration of 1 Frame [ms]: 16,667
    // Duration of 1 loop (blink fame+pause) [ms]: 50

    // True frequency [Hz]: 20
    if(frameCount% 3 == 0) {
      fill(200,200,200);
    }
    else{
      fill(0);
    }
    rect(width-margin-rectSize, margin, rectSize, rectSize);
    
    /////////////////////////////////////////
    // Number of frames in 1 blink "loop": 4 - this number is used in the code
    // duration of 1 Frame [ms]: 16,667
    // Duration of 1 loop (blink fame+pause) [ms]: 66,6666667
    // True frequency [Hz]: 15
    if(frameCount% 4 == 0) {
      fill(200,200,200);
    }
    else{
      fill(0);
    }
    rect(margin, margin, rectSize, rectSize);
    
    /////////////////////////////////////////
    // Number of frames in 1 blink "loop": 5 - this number is used in the code
    // duration of 1 Frame [ms]: 16,667
    // Duration of 1 loop (blink fame+pause) [ms]: 83,33333333
    // True frequency [Hz]: 12
    if(frameCount% 5 == 0) {
      fill(200,200,200);
    }
    else{
      fill(0);
    }
    rect(margin, height-margin-20-rectSize, rectSize, rectSize);
    
    /////////////////////////////////////////
    
    // Number of frames in 1 blink "loop": 7 - this number is used in the code
    // duration of 1 Frame [ms]: 16,667
    // Duration of 1 loop (blink fame+pause) [ms]: 116,6666667
    // True frequency [Hz]: 8,571428571

    if(frameCount% 7 == 0) {
      fill(200,200,200);
    }
    else{
      fill(0);
    }
    rect(width-margin-rectSize, height-margin-20-rectSize, rectSize,rectSize);
    /////////////////////////////////////////
  }
  else{
    background(0);
  }
  fill(0);
  rect(10, 10, 50,50);
  fill(255);
  text("fps: "+int(frameRate),20,60);
  //String filename = String.format("frame%s.jpg", frameCount);
  //save(filename);
  
}
void commandCaptions(){
  fill(255);
  textSize(20);
  text("Command 1", margin, margin+textDist+rectSize);
  text("Command 2", width-margin-rectSize, margin+textDist+rectSize);
  text("Command 3", margin, height-margin-rectSize-textDist); //margin, margin+textDist+rectSize);
  text("Command 4", width-margin-rectSize, height-margin-rectSize-textDist);
}

void playsound( String fileName){
   player1 = minim.loadFile(fileName);  
   player1.setGain(-8.0);  // Adjust volume if needed 
   player1.play();
}
