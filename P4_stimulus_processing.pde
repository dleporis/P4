import java.util.Timer;
import java.util.TimerTask;
import java.io.*;
import processing.opengl.*;

// creation of new Timer object
public Timer myTimer = new Timer();
  
// creation of new TimerTasks for each square
// LU = left up square
//RU = right up square
//LD = left down square
//RD = right down square

public TimerTask taskLU = new TimerTask() {
  
  //this run() is executed when timer elapses
  public void run() {
      rectOnLU = true; // this will cause left up square to flash in the following iteration of draw()
  } 
};
// this is the same for all 4 squares
public TimerTask taskRU = new TimerTask() {
  public void run() {
      rectOnRU = true;
  }
};

public TimerTask taskLD = new TimerTask() {
  public void run() {
      rectOnLD = true;
  }
};
  
public TimerTask taskRD = new TimerTask() {
  public void run() {
      rectOnRD = true;
  }
};

// when these are true, the corresponding square will flash in the following itteration of draw()
boolean rectOnLU = false;
boolean rectOnRU = false;
boolean rectOnLD = false;
boolean rectOnRD = false;

// layout variables (in pixels)
int rectSize = 200; //size of square sizes
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
  
  // scheduling timerTasks to run at fixed rates 
  myTimer.scheduleAtFixedRate(taskLU, 0, 100); // taskname , delay[ms], period[ms]
  myTimer.scheduleAtFixedRate(taskRU, 0, 90);
  myTimer.scheduleAtFixedRate(taskLD, 0, 90);
  myTimer.scheduleAtFixedRate(taskRD, 0, 70);
  sketchFullScreen();
      
}

//draw acts as a loop
void draw(){
  commandCaptions(); // displays captions with command names
  
  // the following code changes the color of the rectangles when there is time to show them (based on timer), and then shows the rectangles
  // LU = left up square
  if (rectOnLU == true)
    fill(0,255,255);
  else if (rectOnLU == false)
    fill(0);
  rect(margin, margin, rectSize, rectSize);
  rectOnLU = false;
  
  //RU = right up square
  if (rectOnRU == true)
    fill(255,200,100);
  else if (rectOnRU == false)
    fill(0);
  rect(width-margin-rectSize, margin, rectSize, rectSize);
  rectOnRU = false;
  
  //LD = left down square
  if (rectOnLD == true)
    fill(255,200,200);
  else if (rectOnLD == false){
    fill(0);
  }
  rect(margin, height-margin-20-rectSize, rectSize, rectSize);
  rectOnLD = false;
  

  //RD = right down square
  if (rectOnRD == true)
    fill(0,255,100);
  else if (rectOnRD == false){
    fill(0);
  }
  rect(width-margin-rectSize, height-margin-20-rectSize, rectSize,rectSize);
  rectOnRD = false;
  
} //end of draw loop

// this shows the captions at specific locations
void commandCaptions(){
  fill(255);
  textSize(30);
  text("Command 1", margin, margin+textDist+rectSize);
  text("Command 2", width-margin-rectSize, margin+textDist+rectSize);
  text("Command 3", margin, height-margin-rectSize-textDist); //margin, margin+textDist+rectSize);
  text("Command 4", width-margin-rectSize, height-margin-rectSize-textDist);
}
