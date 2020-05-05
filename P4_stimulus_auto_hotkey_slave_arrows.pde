import java.lang.*;
import java.io.*;
//import java.awt.event.MouseEvent;

int rectSize = 225; //size of square sizes
int margin = 80; // distance between window border and square
int textDist = 40; // distance between square and command captions
// ON OFF
boolean blinkModeON = false;
Process process;
//time variables
int fps = 60;
int operatingMode = 1;
PFont arial;
int lookHere = int(random(1, 5));
int shiftMid = 35;
float circX, circY;

void setup(){//String[] args) throws IOException{
  try {
    process = Runtime.getRuntime().exec(dataPath("P4_octopus.exe"));
   }
  catch (IOException io) {
     throw new RuntimeException(io);
   }
  
  ellipseMode(RADIUS);
  
  arial = loadFont("ArialMT-32.vlw");
  textFont(arial,20);
  // setup display
  size(displayWidth, displayHeight);
  
  //make the window resizable
  if (surface != null) {
    surface.setResizable(true);
  }
  rectMode(CORNER);
  ellipseMode(RADIUS);
  //sketchFullScreen();
  
  stroke(0);
  smooth();
  background(0);
  
  frameRate(fps);
  prepareExitHandler();
  sysinfo();
}

void draw(){
  background(0);
  fill(255);
  //text("fps: "+int(frameRate),10,20);
  
  switch(lookHere){
    case 1:
      circX = width/8;
      circY = height/2;
      break;
    case 2:
    circX = width-width/8;
    circY = height/2;
      break;
    case 3:
    circX = width/2;
    circY = height/11-shiftMid;
      break;
    case 4:
    circX = width/2;
    circY = height-height/11+shiftMid;
      break;
  }
  ellipse(circX, circY, 20, 20);
  if (blinkModeON == true){
    /////////////////////////////////////////
    //Left
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
    //rect(width-margin-rectSize, margin, rectSize, rectSize);
    triangle(width/8, height/2, width/4, height/3, width/4, height-height/3);
    
    /////////////////////////////////////////
    // right
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
    //rect(margin, margin, rectSize, rectSize);
    triangle(width-width/8, height/2, width-width/4, height/3, width-width/4, height-height/3);
    
    /////////////////////////////////////////
    //Up
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
    //rect(margin, height-margin-20-rectSize, rectSize, rectSize);
    triangle(width/2, height/11-shiftMid, width/2-width/8, height/3.5-shiftMid, width/2+width/8, height/3.5-shiftMid);
    
    /////////////////////////////////////////
    // Down
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
    //rect(width-margin-rectSize, height-margin-20-rectSize, rectSize,rectSize);
    triangle(width/2, height-height/11+shiftMid, width/2-width/8, height-height/3.5+shiftMid, width/2+width/8, height-height/3.5+shiftMid);
    ///////////////////////////////////////// 
    if(frameCount% 11 == 0) {
      fill(200);
      rect(margin, margin, rectSize, rectSize);
      fill(0);
      text("SHIFT\noperating\nmodes",  margin+rectSize/2, margin+rectSize/2);
    }
    else{
      fill(200);
      text("SHIFT\noperating\nmodes",  margin+rectSize/2, margin+rectSize/2);
    }
    commandCaptions();
  }
  else { //if (blinkModeON == false)
    textAlign(CENTER);
    //textFont(arial,20);
    text("Press 'CTRL+E' to start recording EEG and start stimulus.\nPress 'E' to start stimulus.",width/2,height/2);
    //textAlign(LEFT);
  }
}

void commandCaptions(){
  fill(255);
  textAlign(CENTER);
  switch(operatingMode){
    case 1:
      text("LEFT 20Hz", width/3.5, height/2);
      text("RIGHT 15Hz", width-width/3.5, height/2);
      text("UP 12Hz", width/2, height/3);
      text("DOWN 8,57Hz",  width/2, height-height/3);
      break;
    case 2:
      text("LEFT 20Hz", width/3.5, height/2);
      text("RIGHT 15Hz", width-width/3.5, height/2);
      text("AWAY 12Hz", width/2, height/3);
      text("TOWARDS 8,57Hz",  width/2, height-height/3);
      break;
    case 3:
      text("AWAY 20Hz", width/3.5, height/2);
      text("TOWARDS 15Hz", width-width/3.5, height/2);
      text("UP 12Hz", width/2, height/3);
      text("DOWN 8,57Hz",  width/2, height-height/3);
      break;
  }
  
  
  
  text("Press 'Q' to stop stimulus.\nPress 'S' to switch operating mode.",width/2,height/2);
  textSize(32);
  text("operating mode: "+operatingMode,  margin+rectSize/2, margin+rectSize+40);
  textSize(20);
  text("shift 5,45Hz",  margin+rectSize+50, margin);
}

void keyReleased() {
  if (key == 'E' || key == 'e'){
    blinkModeON = true;
  }
  if (key == 'Q' || key == 'q'){
    blinkModeON = false;
    lookHere = int(random(1, 5));
  }
  if (key == 'S' || key == 's'){
    if (blinkModeON ==true){
      operatingMode++;
      if (operatingMode > 3){
        operatingMode = 1;
      }
      println("operating mode: "+operatingMode);
    }
  }
}

void sysinfo() {
  println( "__SYS INFO :");
  println( "System     : " + System.getProperty("os.name") + "  " + System.getProperty("os.version") + "  " + System.getProperty("os.arch") );
  println( "JAVA       : " + System.getProperty("java.home")  + " rev: " +javaVersionName);
  println( System.getProperty("java.class.path") );
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

private void prepareExitHandler () {
  Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
    public void run () {
      System.out.println("SHUTDOWN HOOK");
      // application exit code here
      process.destroy();
      println("window closed");
  }
}));
}
