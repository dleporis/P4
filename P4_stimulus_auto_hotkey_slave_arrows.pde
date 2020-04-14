
import java.io.*;
//import java.awt.Robot;
import java.awt.event.MouseEvent;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

int rectSize = 300; //size of square sizes
int margin = 90; // distance between window border and square
int textDist = 40; // distance between square and command captions
// ON OFF
boolean blinkModeON = false;

//time variables
int fps = 60;

PFont arial;

String commandString =  String.format("cmd /c cd %s", dataPath("P4_octopus.exe"));
final String dir = System.getProperty("user.dir");
void setup(String[] args) throws IOException{
  arial = loadFont("ArialMT-32.vlw");
  textFont(arial,32);
  // setup display
  size(displayWidth, displayHeight);
  stroke(0);
  smooth();
  //make the window resizable
  if (frame != null) {
    surface.setResizable(true);
  }
  rectMode(CORNER);
  sketchFullScreen();
  frameRate(fps);  
  background(0);
  //start P4_octopus.exe
  //println(commandString);
  //Process p = Runtime.getRuntime().exec("cmd /c P4_octopus.exe");
  
        
}
//C:\Users\Damian\Documents\OneDrive - Aalborg Universitet\4_Semester\P4\Source\Processing\P4_stimulus_auto_hotkey_slave_arrows\
void draw(){
  println("current dir = " + dir);
  println(commandString);
  background(0);
  fill(255);
  ////textFont(arial,20);
  //text("fps: "+int(frameRate),10,20);
  if (blinkModeON == true){
    commandCaptions();
    /////////////////////////////////////////
    //Top right
    // Number of frames in 1 blink "loop": 3    this number is used in the code
    // duration of 1 Frame [ms]: 16,667
    // Duration of 1 loop (blink fame+pause) [ms]: 50
  
    // True frequency [Hz]: 20
    if(frameCount% 3 == 0) {
      fill(200);
    }
    else{
      fill(0);
    }
    rect(width-margin-rectSize, margin, rectSize, rectSize);
    
    /////////////////////////////////////////
    // top left
    // Number of frames in 1 blink "loop": 4 - this number is used in the code
    // duration of 1 Frame [ms]: 16,667
    // Duration of 1 loop (blink fame+pause) [ms]: 66,6666667
    // True frequency [Hz]: 15
    if(frameCount% 4 == 0) {
      fill(200);
    }
    else{
      fill(0);
    }
    rect(margin, margin, rectSize, rectSize);
    
    /////////////////////////////////////////
    //bottom left
    // Number of frames in 1 blink "loop": 5 - this number is used in the code
    // duration of 1 Frame [ms]: 16,667
    // Duration of 1 loop (blink fame+pause) [ms]: 83,33333333
    // True frequency [Hz]: 12
    if(frameCount% 5 == 0) {
      fill(200);
    }
    else{
      fill(0);
    }
    rect(margin, height-margin-20-rectSize, rectSize, rectSize);
    
    /////////////////////////////////////////
    // bottom right
    // Number of frames in 1 blink "loop": 7 - this number is used in the code
    // duration of 1 Frame [ms]: 16,667
    // Duration of 1 loop (blink fame+pause) [ms]: 116,6666667
    // True frequency [Hz]: 8,571428571
  
    if(frameCount% 7 == 0) {
      fill(200);
    }
    else{
      fill(0);
    }
    rect(width-margin-rectSize, height-margin-20-rectSize, rectSize,rectSize);
    ///////////////////////////////////////// 
  }
  else {
    textAlign(CENTER);
    //textFont(arial,20);
    text("Press 'CTRL+E' to start recording EEG and start stimulus.\nPress 'E' to start stimulus.",width/2,height/2);
    textAlign(LEFT);
  }
}

void commandCaptions(){
  fill(255);
  //textFont(arial,20);
  text("Command 1", margin, margin+textDist+rectSize);
  text("Command 2", width-margin-rectSize, margin+textDist+rectSize);
  text("Command 3", margin, height-margin-rectSize-textDist); //margin, margin+textDist+rectSize);
  text("Command 4", width-margin-rectSize, height-margin-rectSize-textDist);
  textAlign(CENTER);
  text("Press 'Q' to stop stimulus.",width/2,height/2);
  textAlign(LEFT);
}

void keyReleased() {
  if (key == 'E' || key == 'e'){
    blinkModeON = true;
  }
  if (key == 'Q' || key == 'q'){
    blinkModeON = false;
  }
}


void sysinfo() {
  println( "__SYS INFO :");
  println( "System     : " + System.getProperty("os.name") + "  " + System.getProperty("os.version") + "  " + System.getProperty("os.arch") );
  println( "JAVA       : " + System.getProperty("java.home")  + " rev: " +javaVersionName);
  //println( System.getProperty("java.class.path") );
  //println( "\n" + isGL() + "\n" );
  println( "OPENGL     : VENDOR " + PGraphicsOpenGL.OPENGL_VENDOR+" RENDERER " + PGraphicsOpenGL.OPENGL_RENDERER+" VERSION " + PGraphicsOpenGL.OPENGL_VERSION+" GLSL_VERSION: " + PGraphicsOpenGL.GLSL_VERSION);
  println( "user.home  : " + System.getProperty("user.home") );
  println( "user.dir   : " + System.getProperty("user.dir") );
  println( "user.name  : " + System.getProperty("user.name") );
  println( "sketchPath : " + sketchPath() );
  println( "dataPath   : " + dataPath("") );
  println( "dataFile   : " + dataFile("") );
  println( "frameRate  :  actual "+nf(frameRate, 0, 1));
  println( "canvas     : width "+width+" height "+height+" pix "+(width*height));
}
