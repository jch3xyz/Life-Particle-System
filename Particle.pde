// Particle.pde
class Particle {
  float x, y;
  float vx, vy;
  float fx, fy;
  color c;
  int cellX, cellY;
  
  Particle(float x, float y, color c) {
    this.x = x;
    this.y = y;
    this.c = c;
    vx = 0;
    vy = 0;
    fx = 0;
    fy = 0;
  }
  
  // Update physics: add forces, move, bounce off boundaries, apply damping.
  void update(float damping) {
    vx += fx;
    vy += fy;
    x += vx;
    y += vy;
    
    // Bounce off boundaries.
    if (x < 0 || x > width) {
      vx *= -1;
      x = constrain(x, 0, width);
    }
    if (y < 0 || y > height) {
      vy *= -1;
      y = constrain(y, 0, height);
    }
    
    vx *= damping;
    vy *= damping;
    
    // Reset forces.
    fx = 0;
    fy = 0;
  }
  
  // Compute which grid cell the particle is in.
  void updateCell(float cellSize) {
    cellX = int(x / cellSize);
    cellY = int(y / cellSize);
  }
  
  // Draw the particle.
  void display() {
    fill(c);
    noStroke();
    //stroke(c);
    //noFill();
    circle(x, y, 7);
  }
}
