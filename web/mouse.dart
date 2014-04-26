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
    x = root.points[point].x - 60;
    y = root.points[point].y - 15;
    width = 70;
    height = 30;
    nom = 0;
    done = false;
  }
  
  bool contains(Point<num> point) {
    if (point.x >= x && point.y >= y && point.x < x + width && point.y < y + height) {
      return true;
    }
    return false;
  }
  
  void gnaw() {
    nom++;
    // TODO maybe different nom limits depending on height / root size / level / time?
    if (nom >= 5) { // <-- number of seconds
      root.removeFromPoint(point);
      done = true;
    }
  }
  
  void draw() {
    buffer.drawImageToRect(mouse, new Rectangle<num>(getXOnCanvas(x), getYOnCanvas(y), getXOnCanvas(width + worldX), getYOnCanvas(height + worldY)));
  }
  
}