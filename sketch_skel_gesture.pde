import SimpleOpenNI.*; // simple-openni
import processing.net.*;
Client c;

SimpleOpenNI kinect;
double sin=0.0;

void setup() {
 c = new Client(this, "localhost", 5000);
 kinect = new SimpleOpenNI(this);
 kinect.setMirror(true);
 kinect.enableDepth();
 kinect.enableRGB();
 kinect.enableUser();
 kinect.alternativeViewPointDepthToImage();
 size(kinect.rgbWidth(), kinect.rgbHeight());
}

void draw() {
 kinect.update();
 image(kinect.rgbImage(), 0, 0);
 for (int userId = 1; userId <= kinect.getNumberOfUsers(); userId++) {
  if( kinect.isTrackingSkeleton(userId) ) {
   strokeWeight(8);
   stroke(0,0,255);
   drawSkeleton(userId);
   if(kinect.isTrackingSkeleton(userId)){
    detectGesture(userId);
   }
  }
 }
}

void onNewUser(SimpleOpenNI curContext, int userId){
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId){
  println("onLostUser - userId: " + userId);
}

void drawSkeleton(int userId) {
 kinect.drawLimb(userId,SimpleOpenNI.SKEL_LEFT_HAND,SimpleOpenNI.SKEL_RIGHT_HAND);
}

void detectGesture(int userId){
  PVector rhand3d=new PVector();
  kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,rhand3d);
  PVector rhand2d=new PVector();
  kinect.convertRealWorldToProjective(rhand3d,rhand2d);
  PVector lhand3d=new PVector();
  kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,lhand3d);
  PVector lhand2d=new PVector();
  kinect.convertRealWorldToProjective(lhand3d,lhand2d);
  sin=(rhand2d.y-lhand2d.y)/Math.sqrt(Math.pow((rhand2d.x-lhand2d.x),2)+Math.pow((rhand2d.y-lhand2d.y),2));
  c.write(Double.toString(sin*Math.sqrt(2)));  
}
