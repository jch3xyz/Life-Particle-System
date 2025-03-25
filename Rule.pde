// Rule.pde
class Rule {
  Particle[] group1;
  Particle[] group2;
  float g;      // Interaction coefficient.
  float cutoff; // Distance cutoff.
  
  Rule(Particle[] group1, Particle[] group2, float g, float cutoff) {
    this.group1 = group1;
    this.group2 = group2;
    this.g = g;
    this.cutoff = cutoff;
  }
  
  // Apply the rule to all pairs in the two groups.
  // For self-interaction (group1 == group2), forces are equal & opposite.
  // For cross interactions, force is applied only to particles in group1.
  void apply() {
    for (int i = 0; i < group1.length; i++) {
      for (int j = 0; j < group2.length; j++) {
        if (group1 == group2 && i == j) continue;
        Particle a = group1[i];
        Particle b = group2[j];
        
        // Use spatial partitioning: only process if particles are in adjacent or same cells.
        if (abs(a.cellX - b.cellX) > 1 || abs(a.cellY - b.cellY) > 1) continue;
        
        float dx = b.x - a.x;
        float dy = b.y - a.y;
        float d = dist(a.x, a.y, b.x, b.y);
        if (d > 0 && d < cutoff) {
          float scale = 0.5;
          float F = (g / d) * scale;
          a.fx += F * dx;
          a.fy += F * dy;
          if (group1 == group2) {  // For self-interactions, apply equal & opposite force.
            b.fx -= F * dx;
            b.fy -= F * dy;
          }
        }
      }
    }
  }
}
