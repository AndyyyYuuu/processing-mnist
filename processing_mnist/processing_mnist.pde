import java.io.*;
import java.util.Objects;

float CANVAS_X = 20;
float CANVAS_Y = 20;
float CANVAS_SZ = 280;
int BITMAP_SZ = 28;
float PEN_RADIUS = 2;
float PIXEL_SZ = CANVAS_SZ/BITMAP_SZ;
double[][] bitmap = new double[BITMAP_SZ][BITMAP_SZ];

String prediction = "n";
boolean isComputing = false;

PImage img;


public void drop(){
  int[] imgBitmap = new int[BITMAP_SZ*BITMAP_SZ];
  for (int i=0; i<BITMAP_SZ*BITMAP_SZ; i++){
    int a = color(min(255,(int)(bitmap[i%BITMAP_SZ][i/BITMAP_SZ]*255)));
    imgBitmap[i] = a;
  }
  PImage img = createImage(28, 28, ALPHA);
  img.pixels = imgBitmap;
  img.save("drop.png");
}


public boolean mouseInRect(float x, float y, float sx, float sy){
  return mouseX > x && mouseX < x+sx && mouseY > y && mouseY < y+sy;
}


public void setup(){
  size(480, 320);
  background(0);
  drop();
}


public void draw(){
  noFill();
  stroke(255);
  strokeWeight(PIXEL_SZ*2);
  rect(CANVAS_X, CANVAS_Y, CANVAS_SZ, CANVAS_SZ);
  for (int x=0; x<bitmap.length; x++){
    for (int y=0; y<bitmap[0].length; y++){
      fill((float)(bitmap[x][y]*255));
      //fill(155);
      noStroke();
      rect(CANVAS_X+x*PIXEL_SZ, CANVAS_Y+y*PIXEL_SZ, PIXEL_SZ, PIXEL_SZ);
    }
  }
  strokeWeight(PIXEL_SZ);
  stroke(255);
  rect(330, 208, 96, 96);
  fill(255);
  textSize(96);
  if (!prediction.equals("n")){
    text(prediction, 350, 290);
  }
  
  if (mousePressed){
    if (mouseInRect(40, 40, 560, 560)){
      for (int x=0; x<bitmap.length; x++){
        for (int y=0; y<bitmap[0].length; y++){
          float drawStrength = PIXEL_SZ*PEN_RADIUS-dist(CANVAS_X+((float)x+0.5)*PIXEL_SZ, CANVAS_Y+((float)y+0.5)*PIXEL_SZ, mouseX, mouseY);
          if (drawStrength > 0){
            bitmap[x][y] = max((float)bitmap[x][y], drawStrength/(PEN_RADIUS*0.7)/PIXEL_SZ);
          }
        }
      }
    }
  }
}


public void mouseReleased(){
  if (!isComputing){
    isComputing = true; 
    drop();
    String[] command = new String[]{sketchPath()+"/mnist_venv/bin/python", sketchPath()+"/main.py"};
    String[] ans = fetchBash(command);
    prediction = ans[0];
    isComputing = false;
  }
}
