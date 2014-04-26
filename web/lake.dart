part of ld29;

abstract class Hittable {

  num x, y;
  num width, height;
  bool connected;
  
  bool contains(Point<num> point) {
    if (point.x >= x && point.y >= y && point.x < x + width && point.y < y + height) {
      return true;
    }
    return false;
  }
  
  void hit(Root root);
  
  void drain();
  
  void draw();
  
}

class Lake extends Hittable {
  
  bool known;
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
  
  void hit(Root root) {
    if (!known) {
      known = true;
    }
    if (!connected) {
      root.target = root.length;
      root.hittable = this;
      connected = true;
    }
  }
  
  void drain() {
    if (connected && fullness > 0) {
      fullness--;
      waterSupply++;
    }
  }
  
  void draw() {
    if (known) {
      if (fullness > 0) {
        buffer.drawImageToRect(imgWater, new Rectangle<num>(getXOnCanvas(x), getYOnCanvas(y), width * worldScale, height * worldScale));
      } else {
        buffer.drawImageToRect(imgEmpty, new Rectangle<num>(getXOnCanvas(x), getYOnCanvas(y), width * worldScale, height * worldScale));
      }
    } else {
      buffer.drawImageToRect(imgUnknown, new Rectangle<num>(getXOnCanvas(x), getYOnCanvas(y), width * worldScale, height * worldScale));
    }
  }
  
}

class Fertilizer extends Hittable {
  
  Fertilizer(num x, num y) {
    this.x = x - 15;
    this.y = y - 15;
    width = 30;
    height = 30;
    connected = false;
  }

  void hit(Root root) {
    root.target = root.length;
    if (!connected) {
      root.hittable = this;
      connected = true;
    }
  }
  
  void drain() {
    if (connected) {
      // TODO score
    }
  }
  
  void draw() {
    buffer.drawImageToRect(imgFertilizer, new Rectangle<num>(getXOnCanvas(x), getYOnCanvas(y), width * worldScale, height * worldScale));
  }
  
}