import controlP5.*;
import processing.sound.*;

ControlP5 cp5;
float redRed;
float greenGreen;
float blueBlue;
float yellowYellow;
float redGreen;
float redBlue;
float redYellow;
float greenBlue;
float greenYellow;
float blueYellow;
float r = 0.45;
int n = 1200;

ArrayList<Particle> particles = new ArrayList<Particle>();

// Define our colors.
color red = color(255, 0, 0);
color green = color(0, 255, 0);
color blue = color(0, 0, 255);
color yellow = color(255, 255, 0);

// Create different groups of particles by color.
Particle[] redParticles;
Particle[] greenParticles;
Particle[] blueParticles;
Particle[] yellowParticles;

// BounceSound pool for temporary bounce sounds.
ArrayList<BounceSound> bouncePool = new ArrayList<BounceSound>();

BounceSound getBounceSound(PApplet parent) {
  for (BounceSound bs : bouncePool) {
    if (!bs.inUse) {
      bs.inUse = true;
      return bs;
    }
  }
  BounceSound newBS = new BounceSound(parent);
  newBS.inUse = true;
  bouncePool.add(newBS);
  return newBS;
}

void setup() {
  // Use P2D renderer for better 2D performance.
  size(1920, 1080, P2D);
  
  // Create particle groups. Note: Our create method takes (int, color).
  redParticles = create(n, red);
  greenParticles = create(n, green);
  blueParticles = create(n, blue);
  yellowParticles = create(n, yellow);
  
  cp5 = new ControlP5(this);
  cp5.addSlider("redRed")
      .setPosition(20,20)
      .setSize(200,20)
      .setRange(-1*r, r)
      .setValue(random(-1*r, r));
  cp5.addSlider("greenGreen")
      .setPosition(20,40)
      .setSize(200,20)
      .setRange(-1*r, r)
      .setValue(random(-1*r, r));
  cp5.addSlider("blueBlue")
      .setPosition(20,60)
      .setSize(200,20)
      .setRange(-1*r, r)
      .setValue(random(-1*r, r));
  cp5.addSlider("yellowYellow")
      .setPosition(20,80)
      .setSize(200,20)
      .setRange(-1*r, r)
      .setValue(random(-1*r, r));
  cp5.addSlider("redGreen")
      .setPosition(20,100)
      .setSize(200,20)
      .setRange(-1*r, r)
      .setValue(random(-1*r, r));
  cp5.addSlider("redBlue")
      .setPosition(20,120)
      .setSize(200,20)
      .setRange(-1*r, r)
      .setValue(random(-1*r, r));
  cp5.addSlider("redYellow")
      .setPosition(20,140)
      .setSize(200,20)
      .setRange(-1*r, r)
      .setValue(random(-1*r, r));
  cp5.addSlider("greenBlue")
      .setPosition(20,160)
      .setSize(200,20)
      .setRange(-1*r, r)
      .setValue(random(-1*r, r));
  cp5.addSlider("greenYellow")
      .setPosition(20,180)
      .setSize(200,20)
      .setRange(-1*r, r)
      .setValue(random(-1*r, r));
  cp5.addSlider("blueYellow")
      .setPosition(20,200)
      .setSize(200,20)
      .setRange(-1*r, r)
      .setValue(random(-1*r, r));
      
  cp5.hide();
}

void draw() {
  background(0);
  
  // Compute grid cell for each particle.
  float cellSize = height / 9.0;
  for (Particle p : particles) {
    p.cellX = int(p.x / cellSize);
    p.cellY = int(p.y / cellSize);
  }
  
  // Use spatial partitioning in interaction rules.
  rule(redParticles, redParticles, redRed, cellSize);
  rule(greenParticles, greenParticles, greenGreen, cellSize);
  rule(blueParticles, blueParticles, blueBlue, cellSize);
  rule(yellowParticles, yellowParticles, yellowYellow, cellSize);
  rule(redParticles, greenParticles, redGreen, cellSize);
  rule(redParticles, blueParticles, redBlue, cellSize);
  rule(redParticles, yellowParticles, redYellow, cellSize);
  rule(greenParticles, blueParticles, greenBlue, cellSize);
  rule(greenParticles, yellowParticles, greenYellow, cellSize);
  rule(blueParticles, yellowParticles, blueYellow, cellSize);
  
  float damping = 0.99;
  
  // Combined update and draw loop.
  for (Particle p : particles) {
    p.vx += p.fx;
    p.vy += p.fy;
    p.x += p.vx;
    p.y += p.vy;
    
    // Bounce off boundaries.
    if (p.x <= 0 || p.x >= width) {
      p.vx *= -1;
      if (!p.bouncedX) {
        //p.triggerBounce();
        p.bouncedX = true;
      }
    } else {
      p.bouncedX = false;
    }
    
    if (p.y <= 0 || p.y >= height) {
      p.vy *= -1;
      if (!p.bouncedY) {
        //p.triggerBounce();
        p.bouncedY = true;
      }
    } else {
      p.bouncedY = false;
    }
    
    p.vx *= damping;
    p.vy *= damping;
    p.fx = 0;
    p.fy = 0;
    
    // Throttle continuous sound updates.
    if (frameCount % 5 == 0) {
      //p.updateSound();
    }
    
    fill(p.c);
    noStroke();
    circle(p.x, p.y, 6);
  }
}

// Custom create method: takes an int (number) and a color.
Particle[] create(int n, color col) {
  Particle[] group = new Particle[n]; 
  for (int i = 0; i < n; i++) {
    // Create an oscillator for every 100th particle.
    boolean withOsc = (i % 10000 == 0);
    group[i] = new Particle(this, random(width), random(height), col, withOsc);
    particles.add(group[i]);
  }
  return group;
}

// Optimized rule function with spatial partitioning.
void rule(Particle[] group1, Particle[] group2, float g, float cellSize) {
  for (int i = 0; i < group1.length; i++) {
    for (int j = 0; j < group2.length; j++) {
      if (group1 == group2 && i == j) continue;
      
      Particle a = group1[i];
      Particle b = group2[j];
      
      if (abs(a.cellX - b.cellX) > 1 || abs(a.cellY - b.cellY) > 1) continue;
      
      float dx = b.x - a.x;
      float dy = b.y - a.y;
      float d = dist(a.x, a.y, b.x, b.y);
      
      if (d > 0 && d < cellSize) {
        float scale = 0.5;
        float F = (g / d) * scale;
        float fx = F * dx;
        float fy = F * dy;
        
        a.fx += fx;
        a.fy += fy;
        if (group1 != group2) {
          b.fx -= fx;
          b.fy -= fy;
        }
      }
    }
  }
}

boolean slidersHidden = true;

void keyPressed() {
  if (key == 'h' || key == 'H') {
    slidersHidden = !slidersHidden;
    if (slidersHidden) cp5.hide();
    else cp5.show();
  }
  
  if (key == 'r' || key == 'R') {
    cp5.getController("redRed").setValue(random(-1*r, r));
    cp5.getController("greenGreen").setValue(random(-1*r, r));
    cp5.getController("blueBlue").setValue(random(-1*r, r));
    cp5.getController("yellowYellow").setValue(random(-1*r, r));
    cp5.getController("redGreen").setValue(random(-1*r, r));
    cp5.getController("redBlue").setValue(random(-1*r, r));
    cp5.getController("redYellow").setValue(random(-1*r, r));
    cp5.getController("greenBlue").setValue(random(-1*r, r));
    cp5.getController("greenYellow").setValue(random(-1*r, r));
    cp5.getController("blueYellow").setValue(random(-1*r, r));
  }
  
  if (key == 'p' || key == 'P') {
    for (Particle p : particles) {
      p.x = random(width);
      p.y = random(height);
      p.vx = 0;
      p.vy = 0;
    }
  }
  
  if (key == ' ') {
    cp5.getController("redRed").setValue(random(-1*r, r));
    cp5.getController("greenGreen").setValue(random(-1*r, r));
    cp5.getController("blueBlue").setValue(random(-1*r, r));
    cp5.getController("yellowYellow").setValue(random(-1*r, r));
    cp5.getController("redGreen").setValue(random(-1*r, r));
    cp5.getController("redBlue").setValue(random(-1*r, r));
    cp5.getController("redYellow").setValue(random(-1*r, r));
    cp5.getController("greenBlue").setValue(random(-1*r, r));
    cp5.getController("greenYellow").setValue(random(-1*r, r));
    cp5.getController("blueYellow").setValue(random(-1*r, r));
    for (Particle p : particles) {
      p.x = random(width);
      p.y = random(height);
      p.vx = 0;
      p.vy = 0;
    }
  }
}

class Particle {
  float x, y, vx, vy, fx, fy;
  color c;
  SinOsc sine;  // Continuous oscillator (for a subset of particles).
  PApplet parent;
  float baseFreq;  // Fixed note frequency assigned by color.
  boolean bouncedX = false;
  boolean bouncedY = false;
  int cellX, cellY;  // For spatial partitioning.
  
  Particle(PApplet parent, float posx, float posy, color col, boolean withOsc) {
    this.parent = parent;
    x = posx;
    y = posy;
    vx = 0;
    vy = 0;
    fx = 0;
    fy = 0;
    c = col;
    
   /* // Assign fixed base frequency by color (forming a Cmaj7 chord).
    if (col == red) {
      baseFreq = 261.63;  // C
    } else if (col == green) {
      baseFreq = 329.63;  // E
    } else if (col == blue) {
      baseFreq = 392.00;  // G
    } else if (col == yellow) {
      baseFreq = 493.88;  // B
    } else {
      baseFreq = 440;
    }
    
    if (withOsc) {
      sine = new SinOsc(parent);
      sine.freq(baseFreq);
      sine.amp(0.000005);
      sine.pan(0);
      sine.play();
    } else {
      sine = null;
    }
  }
  
  void updateSound() {
    if (sine != null) {
      float vibrato = parent.map(y, 0, parent.height, -30, 30);
      float freq = baseFreq + vibrato;
      sine.freq(freq);
      float speed = parent.sqrt(vx*vx + vy*vy);
      float amp = parent.map(speed, 0, 50, 0.0001, 0.0025);
      sine.amp(amp);
      float pan = parent.map(x, 0, parent.width, -1, 1);
      sine.pan(constrain(pan, -1, 1));
    }
  }
  
  // When a bounce is detected, trigger a bounce sound using the object pool.
  void triggerBounce() {
    BounceSound bs = getBounceSound(parent);
    bs.trigger(baseFreq);
  }
  
  void stopSound() {
    if (sine != null) {
      sine.stop();
    } */
  } 
}

class BounceSound {
  SinOsc osc;
  Env env;
  PApplet parent;
  boolean inUse = false;
  
  BounceSound(PApplet parent) {
    this.parent = parent;
    osc = new SinOsc(parent);
    env = new Env(parent);
  }
  
  void trigger(float freq) {
    inUse = true;
    osc.freq(freq);
    osc.amp(0.005);
    osc.play();
    env.play(osc, 0.001, 0.1, 0, 0.2);
    new java.util.Timer().schedule(new java.util.TimerTask() {
      public void run() {
        osc.stop();
        inUse = false;
      }
    }, 210);
  }
}

void stop() {
  for (Particle p : particles) {
    //p.stopSound();
  }
  super.stop();
}
