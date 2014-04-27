part of ld29;

class Mouse {
  
  Root root;
  int point;
  num x, y;
  num width, height;
  num nom;
  bool done;
  
  Mouse(this.root) {
    point = random.nextInt(root.points.length);
    x = root.points[point].x - 95;
    y = root.points[point].y - 18;
    width = 98;
    height = 37;
    nom = 0;
    done = false;
    if (tutorial) {
      updateTutorial('mouse');
    }
    sndEat.play();
  }
  
  bool contains(Point<num> point) {
    if (point.x >= x && point.y >= y && point.x < x + width && point.y < y + height) {
      return true;
    }
    return false;
  }
  
  void gnaw() {
    nom++;
    if (nom >= 6) { // <-- number of seconds
      root.removeFromPoint(point);
      done = true;
    }
  }
  
  void draw() {
    buffer.drawImageToRect(imgMouse, new Rectangle<num>(getXOnCanvas(x), getYOnCanvas(y), getXOnCanvas(width + worldX), getYOnCanvas(height + worldY)));
  }
  
}