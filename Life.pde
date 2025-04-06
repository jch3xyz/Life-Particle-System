import controlP5.*;

ControlP5 cp5;

// Self-interaction coefficients.
float redRed, greenGreen, blueBlue, yellowYellow;
// Cross-interaction coefficients (each pair now has two independent values).
float redGreen, redBlue, redYellow, greenBlue, greenYellow, blueYellow;
float greenRed, blueRed, yellowRed, blueGreen, yellowGreen, yellowBlue;

float r = 0.40;
int n = 700;

ArrayList<Particle> particles = new ArrayList<Particle>();

// Define our colors.
color RED = color(255, 0, 0);
color GREEN = color(0, 255, 0);
color BLUE = color(0, 0, 255);
color YELLOW = color(255, 255, 0);

// Particle arrays.
Particle[] redParticles;
Particle[] greenParticles;
Particle[] blueParticles;
Particle[] yellowParticles;

// For spatial partitioning.
float cellSize;

// Persistent Rule objects.
Rule ruleRedRed, ruleGreenGreen, ruleBlueBlue, ruleYellowYellow;
Rule ruleRedGreen, ruleGreenRed, ruleRedBlue, ruleBlueRed, ruleRedYellow, ruleYellowRed;
Rule ruleGreenBlue, ruleBlueGreen, ruleGreenYellow, ruleYellowGreen, ruleBlueYellow, ruleYellowBlue;

// Global toggle: if true, cross interactions are linked (equal & opposite).
boolean equalOpposite = false;

//images for flyers
PImage squareImg, verticalImg;

void setup() {
  size(1080, 1080, P2D);
  cellSize = width /4.0;
  
  //load images
  squareImg = loadImage("resources/Feedback Loops (square transparent).png");
  
  // Create particle groups.
  redParticles = createParticles(n, RED);
  greenParticles = createParticles(n, GREEN);
  blueParticles = createParticles(n, BLUE);
  yellowParticles = createParticles(n, YELLOW);
  
  // Create persistent Rule objects.
  ruleRedRed       = new Rule(redParticles, redParticles, redRed, cellSize);
  ruleGreenGreen   = new Rule(greenParticles, greenParticles, greenGreen, cellSize);
  ruleBlueBlue     = new Rule(blueParticles, blueParticles, blueBlue, cellSize);
  ruleYellowYellow = new Rule(yellowParticles, yellowParticles, yellowYellow, cellSize);
  
  ruleRedGreen   = new Rule(redParticles, greenParticles, redGreen, cellSize);
  ruleGreenRed   = new Rule(greenParticles, redParticles, greenRed, cellSize);
  
  ruleRedBlue    = new Rule(redParticles, blueParticles, redBlue, cellSize);
  ruleBlueRed    = new Rule(blueParticles, redParticles, blueRed, cellSize);
  
  ruleRedYellow  = new Rule(redParticles, yellowParticles, redYellow, cellSize);
  ruleYellowRed  = new Rule(yellowParticles, redParticles, yellowRed, cellSize);
  
  ruleGreenBlue  = new Rule(greenParticles, blueParticles, greenBlue, cellSize);
  ruleBlueGreen  = new Rule(blueParticles, greenParticles, blueGreen, cellSize);
  
  ruleGreenYellow = new Rule(greenParticles, yellowParticles, greenYellow, cellSize);
  ruleYellowGreen = new Rule(yellowParticles, greenParticles, yellowGreen, cellSize);
  
  ruleBlueYellow = new Rule(blueParticles, yellowParticles, blueYellow, cellSize);
  ruleYellowBlue = new Rule(yellowParticles, blueParticles, yellowBlue, cellSize);
  
  // Set up ControlP5.
  cp5 = new ControlP5(this);
  
  // Sliders for self interactions.
  cp5.addSlider("redRed")
      .setPosition(20, 20)
      .setSize(200, 20)
      .setRange(-r, r)
      .setValue(random(-r, r));
  cp5.addSlider("greenGreen")
      .setPosition(20, 40)
      .setSize(200, 20)
      .setRange(-r, r)
      .setValue(random(-r, r));
  cp5.addSlider("blueBlue")
      .setPosition(20, 60)
      .setSize(200, 20)
      .setRange(-r, r)
      .setValue(random(-r, r));
  cp5.addSlider("yellowYellow")
      .setPosition(20, 80)
      .setSize(200, 20)
      .setRange(-r, r)
      .setValue(random(-r, r));
  
  // Sliders for cross interactions (first direction).
  cp5.addSlider("redGreen")
      .setPosition(20, 100)
      .setSize(200, 20)
      .setRange(-r, r)
      .setValue(random(-r, r));
  cp5.addSlider("redBlue")
      .setPosition(20, 120)
      .setSize(200, 20)
      .setRange(-r, r)
      .setValue(random(-r, r));
  cp5.addSlider("redYellow")
      .setPosition(20, 140)
      .setSize(200, 20)
      .setRange(-r, r)
      .setValue(random(-r, r));
  cp5.addSlider("greenBlue")
      .setPosition(20, 160)
      .setSize(200, 20)
      .setRange(-r, r)
      .setValue(random(-r, r));
  cp5.addSlider("greenYellow")
      .setPosition(20, 180)
      .setSize(200, 20)
      .setRange(-r, r)
      .setValue(random(-r, r));
  cp5.addSlider("blueYellow")
      .setPosition(20, 200)
      .setSize(200, 20)
      .setRange(-r, r)
      .setValue(random(-r, r));
  
  // Sliders for cross interactions (opposite direction).
  cp5.addSlider("greenRed")
      .setPosition(20, 220)
      .setSize(200, 20)
      .setRange(-r, r)
      .setValue(random(-r, r));
  cp5.addSlider("blueRed")
      .setPosition(20, 240)
      .setSize(200, 20)
      .setRange(-r, r)
      .setValue(random(-r, r));
  cp5.addSlider("yellowRed")
      .setPosition(20, 260)
      .setSize(200, 20)
      .setRange(-r, r)
      .setValue(random(-r, r));
  cp5.addSlider("blueGreen")
      .setPosition(20, 280)
      .setSize(200, 20)
      .setRange(-r, r)
      .setValue(random(-r, r));
  cp5.addSlider("yellowGreen")
      .setPosition(20, 300)
      .setSize(200, 20)
      .setRange(-r, r)
      .setValue(random(-r, r));
  cp5.addSlider("yellowBlue")
      .setPosition(20, 320)
      .setSize(200, 20)
      .setRange(-r, r)
      .setValue(random(-r, r));
      
  // Add a toggle button for linking cross interactions.
  cp5.addToggle("equalOppositeToggle")
      .setPosition(20, 350)
      .setSize(50, 20)
      .setValue(0)
      .setMode(ControlP5.SWITCH);
  
  cp5.hide();
}

void draw() {
  background(0);
  
  // Update grid cell for each particle.
  for (Particle p : particles) {
    p.updateCell(cellSize);
  }
  
  // Update slider values.
  redRed = cp5.getController("redRed").getValue();
  greenGreen = cp5.getController("greenGreen").getValue();
  blueBlue = cp5.getController("blueBlue").getValue();
  yellowYellow = cp5.getController("yellowYellow").getValue();
  
  redGreen = cp5.getController("redGreen").getValue();
  redBlue = cp5.getController("redBlue").getValue();
  redYellow = cp5.getController("redYellow").getValue();
  greenBlue = cp5.getController("greenBlue").getValue();
  greenYellow = cp5.getController("greenYellow").getValue();
  blueYellow = cp5.getController("blueYellow").getValue();
  
  greenRed = cp5.getController("greenRed").getValue();
  blueRed = cp5.getController("blueRed").getValue();
  yellowRed = cp5.getController("yellowRed").getValue();
  blueGreen = cp5.getController("blueGreen").getValue();
  yellowGreen = cp5.getController("yellowGreen").getValue();
  yellowBlue = cp5.getController("yellowBlue").getValue();
  
  // Update the equalOpposite flag from the toggle.
  equalOpposite = cp5.getController("equalOppositeToggle").getValue() > 0.5;
  
  // If equalOpposite is enabled, average the linked pairs.
  if (!equalOpposite) {
    float avgRG = (redGreen + greenRed) / 2.0;
    redGreen = avgRG;
    greenRed = avgRG;
    cp5.getController("redGreen").setValue(avgRG);
    cp5.getController("greenRed").setValue(avgRG);
    
    float avgRB = (redBlue + blueRed) / 2.0;
    redBlue = avgRB;
    blueRed = avgRB;
    cp5.getController("redBlue").setValue(avgRB);
    cp5.getController("blueRed").setValue(avgRB);
    
    float avgRY = (redYellow + yellowRed) / 2.0;
    redYellow = avgRY;
    yellowRed = avgRY;
    cp5.getController("redYellow").setValue(avgRY);
    cp5.getController("yellowRed").setValue(avgRY);
    
    float avgGB = (greenBlue + blueGreen) / 2.0;
    greenBlue = avgGB;
    blueGreen = avgGB;
    cp5.getController("greenBlue").setValue(avgGB);
    cp5.getController("blueGreen").setValue(avgGB);
    
    float avgGY = (greenYellow + yellowGreen) / 2.0;
    greenYellow = avgGY;
    yellowGreen = avgGY;
    cp5.getController("greenYellow").setValue(avgGY);
    cp5.getController("yellowGreen").setValue(avgGY);
    
    float avgBY = (blueYellow + yellowBlue) / 2.0;
    blueYellow = avgBY;
    yellowBlue = avgBY;
    cp5.getController("blueYellow").setValue(avgBY);
    cp5.getController("yellowBlue").setValue(avgBY);
  }
  
  // Update rule coefficients.
  ruleRedRed.g = redRed;
  ruleGreenGreen.g = greenGreen;
  ruleBlueBlue.g = blueBlue;
  ruleYellowYellow.g = yellowYellow;
  
  ruleRedGreen.g = redGreen;
  ruleGreenRed.g = greenRed;
  ruleRedBlue.g = redBlue;
  ruleBlueRed.g = blueRed;
  ruleRedYellow.g = redYellow;
  ruleYellowRed.g = yellowRed;
  ruleGreenBlue.g = greenBlue;
  ruleBlueGreen.g = blueGreen;
  ruleGreenYellow.g = greenYellow;
  ruleYellowGreen.g = yellowGreen;
  ruleBlueYellow.g = blueYellow;
  ruleYellowBlue.g = yellowBlue;
  
  // Apply all persistent rules.
  ruleRedRed.apply();
  ruleGreenGreen.apply();
  ruleBlueBlue.apply();
  ruleYellowYellow.apply();
  ruleRedGreen.apply();
  ruleGreenRed.apply();
  ruleRedBlue.apply();
  ruleBlueRed.apply();
  ruleRedYellow.apply();
  ruleYellowRed.apply();
  ruleGreenBlue.apply();
  ruleBlueGreen.apply();
  ruleGreenYellow.apply();
  ruleYellowGreen.apply();
  ruleBlueYellow.apply();
  ruleYellowBlue.apply();
  
  float damping = 0.99;
  
  // Update physics and draw particles.
  for (Particle p : particles) {
    p.update(damping);
    p.display();
  }
  
  //draw image
  image(squareImg, 0, 0, 1080, 1080);
  
  //saveFrame("square video/square-######.png");
}

Particle[] createParticles(int n, color col) {
  Particle[] group = new Particle[n];
  for (int i = 0; i < n; i++) {
    Particle p = new Particle(random(width), random(height), col);
    group[i] = p;
    particles.add(p);
  }
  return group;
}

void keyPressed() {
  if (key == 'h' || key == 'H') {
    if (cp5.isVisible()) cp5.hide(); else cp5.show();
  }
  if (key == 'e' || key == 'E') {
    // Toggle the equalOpposite flag.
    equalOpposite = !equalOpposite;
    cp5.getController("equalOppositeToggle").setValue(equalOpposite ? 1 : 0);
    // Immediately average the linked sliders so both update.
    if (!equalOpposite) {
      float avgRG = (cp5.getController("redGreen").getValue() + cp5.getController("greenRed").getValue())/2.0;
      cp5.getController("redGreen").setValue(avgRG);
      cp5.getController("greenRed").setValue(avgRG);
      
      float avgRB = (cp5.getController("redBlue").getValue() + cp5.getController("blueRed").getValue())/2.0;
      cp5.getController("redBlue").setValue(avgRB);
      cp5.getController("blueRed").setValue(avgRB);
      
      float avgRY = (cp5.getController("redYellow").getValue() + cp5.getController("yellowRed").getValue())/2.0;
      cp5.getController("redYellow").setValue(avgRY);
      cp5.getController("yellowRed").setValue(avgRY);
      
      float avgGB = (cp5.getController("greenBlue").getValue() + cp5.getController("blueGreen").getValue())/2.0;
      cp5.getController("greenBlue").setValue(avgGB);
      cp5.getController("blueGreen").setValue(avgGB);
      
      float avgGY = (cp5.getController("greenYellow").getValue() + cp5.getController("yellowGreen").getValue())/2.0;
      cp5.getController("greenYellow").setValue(avgGY);
      cp5.getController("yellowGreen").setValue(avgGY);
      
      float avgBY = (cp5.getController("blueYellow").getValue() + cp5.getController("yellowBlue").getValue())/2.0;
      cp5.getController("blueYellow").setValue(avgBY);
      cp5.getController("yellowBlue").setValue(avgBY);
    } else {
        cp5.getController("greenRed").setValue(random(-r, r));
        cp5.getController("blueRed").setValue(random(-r, r));
        cp5.getController("yellowRed").setValue(random(-r, r));
        cp5.getController("blueGreen").setValue(random(-r, r));
        cp5.getController("yellowGreen").setValue(random(-r, r));
        cp5.getController("yellowBlue").setValue(random(-r, r));
    }
  }
  if (key == 'r' || key == 'R') {
    cp5.getController("redRed").setValue(random(-r, r));
    cp5.getController("greenGreen").setValue(random(-r, r));
    cp5.getController("blueBlue").setValue(random(-r, r));
    cp5.getController("yellowYellow").setValue(random(-r, r));
    cp5.getController("redGreen").setValue(random(-r, r));
    cp5.getController("redBlue").setValue(random(-r, r));
    cp5.getController("redYellow").setValue(random(-r, r));
    cp5.getController("greenBlue").setValue(random(-r, r));
    cp5.getController("greenYellow").setValue(random(-r, r));
    cp5.getController("blueYellow").setValue(random(-r, r));
    cp5.getController("greenRed").setValue(random(-r, r));
    cp5.getController("blueRed").setValue(random(-r, r));
    cp5.getController("yellowRed").setValue(random(-r, r));
    cp5.getController("blueGreen").setValue(random(-r, r));
    cp5.getController("yellowGreen").setValue(random(-r, r));
    cp5.getController("yellowBlue").setValue(random(-r, r));
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
    cp5.getController("redRed").setValue(random(-r, r));
    cp5.getController("greenGreen").setValue(random(-r, r));
    cp5.getController("blueBlue").setValue(random(-r, r));
    cp5.getController("yellowYellow").setValue(random(-r, r));
    cp5.getController("redGreen").setValue(random(-r, r));
    cp5.getController("redBlue").setValue(random(-r, r));
    cp5.getController("redYellow").setValue(random(-r, r));
    cp5.getController("greenBlue").setValue(random(-r, r));
    cp5.getController("greenYellow").setValue(random(-r, r));
    cp5.getController("blueYellow").setValue(random(-r, r));
    cp5.getController("greenRed").setValue(random(-r, r));
    cp5.getController("blueRed").setValue(random(-r, r));
    cp5.getController("yellowRed").setValue(random(-r, r));
    cp5.getController("blueGreen").setValue(random(-r, r));
    cp5.getController("yellowGreen").setValue(random(-r, r));
    cp5.getController("yellowBlue").setValue(random(-r, r));
    
    for (Particle p : particles) {
      p.x = random(width);
      p.y = random(height);
      p.vx = 0;
      p.vy = 0;
    }
  }
}
