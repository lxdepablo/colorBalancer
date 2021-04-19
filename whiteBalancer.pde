import java.util.ArrayList;

PImage img, workingImg;  // Declare variable "a" of type PImage 
PImage[] workingImages;
String[] filenames;
float colorDif;
int w, h;

void setup() {
  size(400, 400);
  
  String path = sketchPath() + "/unbalancedImages";
  filenames = listFileNames(path);
  
  workingImages = new PImage[10];
  
  if (filenames.length >= 10){  // Loads only 10 images at a time to save memory. Program eats up too much memory if all images are loaded at once
    int c = 0;
    println("Found " + filenames.length + " files to balance.");
    while (c<filenames.length-9){
      for (int n = 0; n<10; n++){
        workingImages[n] = loadImage(sketchPath() + "/unbalancedImages/" + filenames[c]);  // Loads set of 10 images
        workingImg = workingImages[n];
        w = workingImg.width;
        h = workingImg.height;
        float turquoise = getAverageBlue(workingImg) + getAverageGreen(workingImg);
        turquoise /= 2;
        colorDif = turquoise - getAverageRed(workingImg);
        balanceAllPixels(workingImg);
        workingImg.save(sketchPath() + "/balancedImages/" + filenames[c]);
        c++;
      }
    }
    int n=0;
    while (c<filenames.length) {  //  After running a multiple of 10 times, cleans up remaining images with while loop
      workingImages[n] = loadImage(sketchPath() + "/unbalancedImages/" + filenames[c]);  // Loads set of 10 images
      workingImg = workingImages[n];
      n++;
      w = workingImg.width;
      h = workingImg.height;
      //println(filenames[c]);
      float turquoise = getAverageBlue(workingImg) + getAverageGreen(workingImg);
      turquoise /= 2;
      colorDif = turquoise - getAverageRed(workingImg);
      balanceAllPixels(workingImg);
      workingImg.save(sketchPath() + "/balancedImages/" + filenames[c]);
      c++;
    }
  } else {
    for (int n = 0; n<filenames.length; n++){
      workingImages[n] = loadImage(sketchPath() + "/unbalancedImages/" + filenames[n]);  // Loads set of 10 images
      workingImg = workingImages[n];
      w = workingImg.width;
      h = workingImg.height;
      /*println(filenames[n]);
      println("Average blue value: " + getAverageBlue(workingImg));
      println("Average green value: " + getAverageGreen(workingImg));
      println("Average red value: " + getAverageRed(workingImg));
      println("Maximum brightness: " + maxBrightness(workingImg));
      println("Average brightness: " + getAverageBrightness(workingImg) + "\n");*/
      float turquoise = getAverageBlue(workingImg) + getAverageGreen(workingImg);
      turquoise /= 2;
      colorDif = turquoise - getAverageRed(workingImg);
      balanceAllPixels(workingImg);
      workingImg.save(sketchPath() + "/balancedImages/" + filenames[n]);
    }
  }
}

void draw() {
  exit();
}

float getAverageBlue(PImage img){
  float average = 0;
  for(int m=0; m<=h; m++){
    for(int n=0; n<=w; n++){
      average += getBlue(n, m, img);
    }
  }
  float numPixels = h*w;
  average /= numPixels;
  return average;
}

float getAverageGreen(PImage img){
  float average = 0;
  for(int m=0; m<=h; m++){
    for(int n=0; n<=w; n++){
      average += getGreen(n, m, img);
    }
  }
  float numPixels = h*w;
  average /= numPixels;
  return average;
}

float getAverageRed(PImage img){
  float average = 0;
  for(int m=0; m<=h; m++){
    for(int n=0; n<=w; n++){
      average += getRed(n, m, img);
    }
  }
  float numPixels = h*w;
  average /= numPixels;
  return average;
}

float getBlue(int x, int y, PImage img){
  return blue(img.get(x, y));
}

float getGreen(int x, int y, PImage img){
  return green(img.get(x, y));
}

float getRed(int x, int y, PImage img){
  return red(img.get(x, y));
}

float getBrightness(int x, int y, PImage img){
  return brightness(img.get(x, y));
}

float getAverageBrightness(PImage img){
  float average = 0;
  for(int m=0; m<=h; m++){
    for(int n=0; n<=w; n++){
      average += getBrightness(n, m, img);
      if(getBrightness(n, m, img) == 255){
        /*println("Bright pixel blue value: " + getBlue( n, m, img));
        println("Bright pixel green value: " + getGreen( n, m, img));
        println("Bright pixel red value: " + red(img.get(n, m)) + "\n");
        */
      }
    }
  }
  float numPixels = h*w;
  average /= numPixels;
  return average;
}

float maxBrightness(PImage img){
  float currMax = 0;
  for(int m=0; m<=h; m++){
    for(int n=0; n<=w; n++){
      if(getBrightness(n, m, img)>currMax){
        currMax = getBrightness(n, m, img);
      }
    }
  }
  return currMax;
}

void balancePixel(int x, int y, PImage image){
  colorMode(RGB);
  color origColor = image.get(x, y);
  float newBlue = blue(origColor);
  float newGreen = green(origColor);
  float newRed = red(origColor)+colorDif;
  color newColor = color(newRed, newGreen, newBlue);
  float brightDif = colorDif/5;
  float newBrightness = brightness(newColor)-brightDif;
  float newSaturation = saturation(newColor);
  colorMode(HSB);
  newColor = color(hue(newColor), newSaturation, newBrightness);
  image.set(x, y, newColor);
}

void balanceAllPixels(PImage thisImage){
  for(int i=0; i<=h; i++){
    for(int u=0; u<=w; u++){
      balancePixel(u, i, thisImage);
    }
  }
}

String[] listFileNames(String dir) {  // Lists out all the files in a directory
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}
