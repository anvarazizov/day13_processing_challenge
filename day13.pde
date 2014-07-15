import java.util.*;

// ------ agents ------
Agent[] agents = new Agent[3000];

int agentsCount = 3000;
float noiseScale, noiseStrength;
float overlayAlpha = random(10, 20), agentsAlpha = 90, strokeWidth = 0.5;
int drawMode = 1;

void setup() {
  size(640, 640, JAVA2D);
  smooth();

  for (int i=0; i<agents.length; i++) {
    agents[i] = new Agent();
  }
  
}

void draw() {
  pushMatrix();
  translate(width/2, height/2);
  fill(0, overlayAlpha);
  noStroke();
  ellipse(0, 0, width, height);
  popMatrix();
  
  stroke(255, agentsAlpha);
  for (int i=0; i<agentsCount; i++) agents[i].update1();
}
void keyReleased() {
  if (key=='s' || key=='S') saveFrame(timestamp()+".png");
  if (key == ' ') {
    int newNoiseSeed = (int) random(100000);
    println("newNoiseSeed: "+newNoiseSeed);
    noiseSeed(newNoiseSeed);
  }
  if (key == DELETE || key == BACKSPACE) background(255);
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}

class Agent {
  PVector p, pOld;
  float stepSize, angle;
  boolean isOutside = false;

  Agent() {
    p = new PVector(random(width), random(height), random(width));
    pOld = new PVector(p.x, p.y, p.z);
    stepSize = random(1, 3);
  }

  void update1() {
    angle = noise(p.x/noiseScale, p.y/noiseScale) * noiseStrength;

    p.x += sin(angle) * stepSize;
    p.y -= cos(random(angle)) * stepSize;

    if (p.x<random(-10)) isOutside = true;
    else if (p.x>width+10){
      isOutside = true;
    }
    else if (p.y<-10) isOutside = true;
    else if (p.y>height+10) isOutside = true;

    if (isOutside) {
      p.x = random(width);
      p.y = random(height);
      pOld.set(p);
    }

    strokeWeight(strokeWidth*stepSize);
    line(pOld.x, pOld.y, p.x, p.y);
    
    pOld.set(p);

    noiseStrength = 1 + mouseX/4;
    noiseScale = mouseY;
    
    isOutside = false;
  }
}

