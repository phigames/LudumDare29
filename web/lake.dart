part of ld29;

class Lake {
  
  num x, y;
  num width, height;
  bool known;
  bool connected;
  num fullness;
  
  Lake(num x, num y) {
    this.x = x - 75;
    this.y = y - 50;
    width = 150;
    height = 100;
    known = false;
    connected = false;
    if (random.nextInt(10) == 0) {
      fullness = 0;
    } else {
      fullness = random.nextInt(100) + 100;
    }
  }
  
  /**
   * returns true if and only if the given point is inside the lake's hitbox
   */
  bool contains(Point<num> point) {
    if (point.x >= x && point.y >= y && point.x < x + width && point.y < y + height) {
      return true;
    }
    return false;
  }
  
  /**
   * is called whenever a root hits a lake, whether it already has a connected root or not
   * sets the lake known and connected
   */
  void hit(Root root) {
    root.target = root.length;
    if (!known) {
      known = true;
    }
    if (!connected) {
      root.lake = this;
      connected = true;
    }
  }
  
  /**
   * moves one unit of water from the lake to the supply if the lake is connected and not empty
   */
  void drain() {
    if (connected && fullness > 0) {
      fullness--;
      waterSupply++;
    }
  }
  
  /**
   * draws the lake to the buffer
   */
  void draw() {
    if (known) {
      if (fullness > 0) {
        buffer.drawImageToRect(water, new Rectangle<num>(getXOnCanvas(x), getYOnCanvas(y), getXOnCanvas(width + worldX), getYOnCanvas(height + worldY)));
      } else {
        buffer.drawImageToRect(empty, new Rectangle<num>(getXOnCanvas(x), getYOnCanvas(y), getXOnCanvas(width + worldX), getYOnCanvas(height + worldY)));
      }
    } else {
      buffer.drawImageToRect(unknown, new Rectangle<num>(getXOnCanvas(x), getYOnCanvas(y), getXOnCanvas(width + worldX), getYOnCanvas(height + worldY)));
    }
  }
  
}