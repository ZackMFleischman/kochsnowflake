// Tweakable Parameters
float updateRate = 0.01;
int maxIterations = 7;
color mainColor = color(0, 150, 150);

// Global State Variables
float progress = 0;
int currentIteration = 1;
boolean forward = true;

// Initial triangle point positions
PVector initialBottomLeft = new PVector(100, 450);
PVector initialBottomRight = new PVector(500, 450);

// Fonts
PFont mainFont;

void setup() {
  size(600, 620);
  background(0, 0, 50);
  mainFont = createFont("Arial", 16, true);
}

void draw() {
  clear();
  
  drawTitle();
  drawIterationsLabel();
  
  updateProgressAndIterations();
  
  drawSnowflake(initialBottomLeft, initialBottomRight, currentIteration, progress);
}

void drawTitle() {
  fill(mainColor);
  textFont(mainFont, 14);
  text("Iterations: " + currentIteration, width - 80, height - 10);
}

void drawIterationsLabel() {
  fill(mainColor);
  textFont(mainFont, 22);
  text("Koch Snowflake", 10, 30);
}

void updateProgressAndIterations() {
  if (forward) {
    if (progress >= 1.0)
      forward = false;
    else
      progress += updateRate;
  }
  else { // Going Backwards
    if (progress <= 0) {
      bumpCurrentIteration();
      forward = true;
    } else {
     progress -= updateRate; 
    }
  }
}

void bumpCurrentIteration() {
  currentIteration++;
  if (currentIteration > maxIterations) 
      currentIteration = 1;
}

void drawSnowflake(PVector left, PVector right, int iterations, float progress) {
  PVector top = getTrianglePoint(left, right, 1.0);
  
  drawSegment(left, top, iterations, progress);
  drawSegment(top, right, iterations, progress);
  drawSegment(right, left, iterations, progress);
}


void drawSegment(PVector start, PVector end, int iterations, float progress) {
  if (iterations == 0) {
    drawLine(start, end); // Base Case
  } else {
    float xLength = (end.x - start.x) / 3.0;
    float yLength = (end.y - start.y) / 3.0;
    
    PVector midLeft = new PVector(start.x + xLength, start.y + yLength);
    PVector midRight = new PVector(start.x + (xLength*2), start.y + (yLength*2));
    PVector top = getTrianglePoint(midLeft, midRight, progress);
    
    drawSegment(start, midLeft, iterations-1, progress);
    drawSegment(midLeft, top, iterations-1, progress);
    drawSegment(top, midRight, iterations-1, progress);
    drawSegment(midRight, end, iterations-1, progress);
  }
}


void drawLine(PVector start, PVector end) {
  stroke(mainColor);
  line(start.x, start.y, end.x, end.y);
}

PVector getTrianglePoint(PVector left, PVector right, float progress) {
  PVector rightLeft = new PVector(right.x - left.x, right.y - left.y);
  PVector center = new PVector(rightLeft.x/2.0, rightLeft.y/2.0);
  center.add(left);

  rightLeft.mult(progress);
  
  PVector rotated = new PVector(rightLeft.y, -rightLeft.x);
  rotated.add(center);
  return rotated;
}