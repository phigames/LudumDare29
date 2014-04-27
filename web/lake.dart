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
      fullness = random.nextInt(100) + 50;
    }
  }

  void hit(Root root) {
    if (!known) {
      known = true;
      score += 5;
    }
    if (!connected) {
      root.target = root.length;
      root.hittable = this;
      connected = true;
      sndWater.play();
      if (tutorial) {
        updateTutorial('water');
      }
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
      if (fullness > 100) {
        buffer.drawImageToRect(imgWater[0], new Rectangle<num>(getXOnCanvas(x), getYOnCanvas(y), width * worldScale, height * worldScale));
      } else if (fullness > 50) {
        buffer.drawImageToRect(imgWater[1], new Rectangle<num>(getXOnCanvas(x), getYOnCanvas(y), width * worldScale, height * worldScale));
      } else if (fullness > 0) {
        buffer.drawImageToRect(imgWater[2], new Rectangle<num>(getXOnCanvas(x), getYOnCanvas(y), width * worldScale, height * worldScale));
      } else {
        buffer.drawImageToRect(imgWater[3], new Rectangle<num>(getXOnCanvas(x), getYOnCanvas(y), width * worldScale, height * worldScale));
      }
    } else {
      buffer.drawImageToRect(imgUnknown, new Rectangle<num>(getXOnCanvas(x), getYOnCanvas(y), width * worldScale, height * worldScale));
    }
  }

}

class FertilizerSmall extends Hittable {

  num fullness;

  FertilizerSmall(num x, num y) {
    this.x = x - 15;
    this.y = y - 15;
    width = 30;
    height = 30;
    connected = false;
    fullness = 10;
  }

  void hit(Root root) {
    if (!connected && fullness > 0) {
      root.target = root.length;
      root.hittable = this;
      connected = true;
      sndFertilizer.play();
      if (tutorial) {
        updateTutorial('fertilizer');
      }
    }
  }

  void drain() {
    if (connected && fullness > 0) {
      fullness--;
      score += 0.1;
    }
  }

  void draw() {
    if (fullness > 6) {
      buffer.drawImageToRect(imgFertilizerSmall[0], new Rectangle<num>(getXOnCanvas(x), getYOnCanvas(y), width * worldScale, height * worldScale));
    } else if (fullness > 3) {
      buffer.drawImageToRect(imgFertilizerSmall[1], new Rectangle<num>(getXOnCanvas(x), getYOnCanvas(y), width * worldScale, height * worldScale));
    } else if (fullness > 0) {
      buffer.drawImageToRect(imgFertilizerSmall[2], new Rectangle<num>(getXOnCanvas(x), getYOnCanvas(y), width * worldScale, height * worldScale));
    }
  }

}

class FertilizerLarge extends Hittable {

  num fullness;

  FertilizerLarge(num x, num y) {
    this.x = x - 30;
    this.y = y - 30;
    width = 60;
    height = 60;
    connected = false;
    fullness = 30;
  }

  void hit(Root root) {
    if (!connected && fullness > 0) {
      root.target = root.length;
      root.hittable = this;
      connected = true;
      sndFertilizer.play();
      if (tutorial) {
        updateTutorial('fertilizer');
      }
    }
  }

  void drain() {
    if (connected && fullness > 0) {
      fullness--;
      score += 0.1;
    }
  }

  void draw() {
    if (fullness > 20) {
      buffer.drawImageToRect(imgFertilizerLarge[0], new Rectangle<num>(getXOnCanvas(x), getYOnCanvas(y), width * worldScale, height * worldScale));
    } else if (fullness > 10) {
      buffer.drawImageToRect(imgFertilizerLarge[1], new Rectangle<num>(getXOnCanvas(x), getYOnCanvas(y), width * worldScale, height * worldScale));
    } else if (fullness > 0) {
      buffer.drawImageToRect(imgFertilizerLarge[2], new Rectangle<num>(getXOnCanvas(x), getYOnCanvas(y), width * worldScale, height * worldScale));
    }
  }

}

class Treasure extends Hittable {

  num fullness;

  Treasure(num x, num y) {
    this.x = x - 96;
    this.y = y - 167;
    width = 192;
    height = 167;
    connected = false;
    fullness = 100;
  }

  void hit(Root root) {
    root.target = root.length;
    if (!connected) {
      root.hittable = this;
      connected = true;
      sndTreasure.play();
    }
  }

  void drain() {
    if (connected) {
      fullness--;
      score += 1;
    }
  }

  void draw() {
    if (fullness > 66) {
      buffer.drawImageToRect(imgTreasure[0], new Rectangle<num>(getXOnCanvas(x), getYOnCanvas(y), width * worldScale, height * worldScale));
    } else if (fullness > 33) {
      buffer.drawImageToRect(imgTreasure[1], new Rectangle<num>(getXOnCanvas(x), getYOnCanvas(y), width * worldScale, height * worldScale));
    } else if (fullness > 0) {
      buffer.drawImageToRect(imgTreasure[2], new Rectangle<num>(getXOnCanvas(x), getYOnCanvas(y), width * worldScale, height * worldScale));
    } else {
      buffer.drawImageToRect(imgTreasure[3], new Rectangle<num>(getXOnCanvas(x), getYOnCanvas(y), width * worldScale, height * worldScale));
    }
  }

}
