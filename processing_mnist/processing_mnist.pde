import java.io.*;

public static String[] fetchBash(String[] command){
  Process process = exec(command);
  try{
    process.waitFor();
  } catch (InterruptedException e){
    e.printStackTrace();
    return null;
  }
  
  BufferedReader reader = createReader(process.getInputStream());
  
  try {
    ArrayList<String> lines = new ArrayList<>();
    String line;
    while ((line = reader.readLine()) != null) {
      lines.add(line);
    }
    String[] linesArray = lines.toArray(new String[0]);
    return linesArray;
  } catch (IOException e) {
    e.printStackTrace();
    return null;
  }
}

public boolean mouseInRect(float x, float y, float sx, float sy){
  return mouseX > x && mouseX < x+sx && mouseY > y && mouseY < y+sy;
}


float CANVAS_X = 40;
float CANVAS_Y = 40;
float CANVAS_SZ = 560;
int BITMAP_SZ = 28;
float PEN_RADIUS = 2;
float PIXEL_SZ = CANVAS_SZ/BITMAP_SZ;
double[][] bitmap = new double[BITMAP_SZ][BITMAP_SZ];

PImage img;

public void setup(){
  size(640, 640);
  background(0);
}

public void draw(){
  noFill();
  stroke(255);
  strokeWeight(20);
  rect(40, 40, 560, 560);
  for (int x=0; x<bitmap.length; x++){
    for (int y=0; y<bitmap[0].length; y++){
      fill((float)(bitmap[x][y]*255));
      //fill(155);
      noStroke();
      rect(CANVAS_X+x*PIXEL_SZ, CANVAS_Y+y*PIXEL_SZ, PIXEL_SZ, PIXEL_SZ);
    }
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
  int[] imgBitmap = new int[BITMAP_SZ*BITMAP_SZ];
  for (int i=0; i<BITMAP_SZ*BITMAP_SZ; i++){
    int a = color(min(255,(int)(bitmap[i%BITMAP_SZ][i/BITMAP_SZ]*255)));
    imgBitmap[i] = a;
  }
  PImage img = createImage(28, 28, ALPHA);
  img.pixels = imgBitmap;
  img.save("drop.png");
  String[] ans = fetchBash(new String[]{"python3",sketchPath()+"/main.py"});
  println(ans[0]);
}
