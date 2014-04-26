library ld29;

import 'dart:html';
import 'dart:math';

part 'input.dart';

CanvasRenderingContext2D canvas;
CanvasRenderingContext2D buffer;
int canvasWidth, canvasHeight;
ImageElement background;
ImageElement unknown;
ImageElement water;
ImageElement lava;
num lastTime;
Random random;
num worldX, worldY, worldWidth, worldHeight;
num worldScale;
bool keyLeft, keyUp, keyRight, keyDown;
List<Lake> lakes;
Root mainRoot;
num growTime;
num growInterval;
num waterTime;
num waterInterval;
num waterSupply;
int waterLakes;

void main() {
  CanvasElement c = querySelector('#canvas');
  canvas = c.context2D;
  CanvasElement b = new CanvasElement();
  buffer = b.context2D;
  onResize(null);
  background = new ImageElement();
  //background.src = 'res/background.png';
  unknown = new ImageElement();
  unknown.src = 'res/unknown.png';
  water = new ImageElement();
  water.src = 'res/water.png';
  lava = new ImageElement();
  lava.src = 'res/lava.png';
  lastTime = -1;
  random = new Random();
  worldX = 1000 - canvasWidth / 2;
  worldY = 0;
  worldWidth = 2000;
  worldHeight = 10000;
  worldScale = 1.0;
  keyLeft = false;
  keyUp = false;
  keyRight = false;
  keyDown = false;
  c.onClick.listen(onClick);
  c.onMouseDown.listen(onMouseDown);
  c.onMouseUp.listen(onMouseUp);
  c.onMouseMove.listen(onMouseMove);
  c.onMouseWheel.listen(onMouseWheel);
  document.onKeyDown.listen(onKeyDown);
  document.onKeyUp.listen(onKeyUp);
  window.onResize.listen(onResize);
  window.animationFrame.then(frame);
  lakes = new List<Lake>();
  lakes.add(new Lake(1000, 500));
  mainRoot = new Root(1000, 200, 0, 120);
  growTime = 0;
  growInterval = 500;
  waterTime = 0;
  waterInterval = 500;
  waterSupply = 105;
  waterLakes = 0;
}

void frame(num time) {
  if (lastTime != -1) {
    update(time - lastTime);
  }
  lastTime = time;
  buffer.clearRect(0, 0, canvasWidth, canvasHeight);
  drawWorld();
  canvas.clearRect(0, 0, canvasWidth, canvasHeight);
  canvas.drawImage(buffer.canvas, 0, 0);
  window.animationFrame.then(frame);
}

void update(num time) {
  moveWorld(time);
  growTime += time;
  if (growTime >= growInterval) {
    mainRoot.grow();
    growTime -= growInterval;
  }
  waterTime += time;
  if (waterTime >= waterInterval) {
    waterSupply += waterLakes;
    waterTime -= waterInterval;
  }
}

num getXOnCanvas(num x) {
  return (x - worldX) * worldScale;
}

num getYOnCanvas(num y) {
  return (y - worldY) * worldScale;
}

num getXInWorld(num x) {
  return x / worldScale + worldX;
}

num getYInWorld(num y) {
  return y / worldScale + worldY;
}

void moveWorld(num time) {
  if (keyLeft) {
    worldX -= time / 2 / worldScale;
  }
  if (keyUp) {
    worldY -= time / 2 / worldScale;
  }
  if (keyRight) {
    worldX += time / 2 / worldScale;
  }
  if (keyDown) {
    worldY += time / 2 / worldScale;
  }
  if (canvasWidth > worldWidth * worldScale) {
    worldScale = canvasWidth / worldWidth;
  }
  if (canvasHeight > worldHeight * worldScale) {
    worldScale = canvasHeight / worldHeight;
  }
  if (worldX < 0) {
    worldX = 0;
  } else if (worldX + canvasWidth / worldScale > worldWidth) {
    worldX = worldWidth - canvasWidth / worldScale;
  }
  if (worldY < 0) {
    worldY = 0;
  } else if (worldY + canvasHeight / worldScale > worldHeight) {
    worldY = worldHeight - canvasHeight / worldScale;
  }
}

void drawWorld() {
  //buffer.drawImageToRect(background, new Rectangle<num>(0, 0, canvasWidth, canvasHeight), sourceRect: new Rectangle<num>(worldX, worldY, canvasWidth / worldScale, canvasHeight / worldScale));
  for (int i = 0; i < lakes.length; i++) {
    lakes[i].draw();
  }
  mainRoot.draw();
  if (dragging) {
    buffer.beginPath();
    buffer.moveTo(getXOnCanvas(addRootX1), getYOnCanvas(addRootY1));
    buffer.lineTo(getXOnCanvas(addRootX2), getYOnCanvas(addRootY2));
    buffer.lineWidth = 2;
    buffer.lineCap = 'round';
    buffer.strokeStyle = '#008800';
    buffer.stroke();
  }
  buffer.fillText(waterSupply.toString(), 0, 10);
}

class Root {
  
  static const num POINT_DISTANCE = 20;
  
  List<Point<num>> points;
  num angle;
  num length;
  num target;
  List<Root> subroots;
  
  Root(num x, num y, this.angle, this.target) {
    points = new List<Point<num>>();
    points.add(new Point<num>(x, y));
    points.add(new Point<num>(x + sin(angle) * POINT_DISTANCE, y + cos(angle) * POINT_DISTANCE));
    length = POINT_DISTANCE;
    subroots = new List<Root>();
  }
  
  Root getRootWhichHasPointAround(num x, num y) {
    for (int i = 0; i < points.length; i++) {
      if ((points[i].x - x).abs() < 10 && (points[i].y - y).abs() < 10) {
        return this;
      }
    }
    for (int i = 0; i < subroots.length; i++) {
      Root s = subroots[i].getRootWhichHasPointAround(x, y);
      if (s != null) {
        return s;
      }
    }
    return null;
  }
  
  void grow() {
    if (length < target && waterSupply > 0) {
      Point l = points[points.length - 1];
      points.add(new Point<num>(l.x + sin(angle) * POINT_DISTANCE, l.y + cos(angle) * POINT_DISTANCE));
      length += POINT_DISTANCE;
      waterSupply--;
      for (int i = 0; i < lakes.length; i++) {
        if (lakes[i].contains(points[points.length - 1])) {
          lakes[i].hit(this);
        }
      }
    }
    for (int i = 0; i < subroots.length; i++) {
      subroots[i].grow();
    }
  }
  
  void addSubroot(Root sub) {
    if (waterSupply > 0) {
      subroots.add(sub);
    }
  }
  
  void draw() {
    if (points.length > 1) {
      buffer.beginPath();
      buffer.moveTo(getXOnCanvas(points[0].x), getYOnCanvas(points[0].y));
      for (int i = 1; i < points.length; i++) {
        buffer.lineTo(getXOnCanvas(points[i].x), getYOnCanvas(points[i].y));
      }
      buffer.lineWidth = 20 * worldScale;
      buffer.lineCap = 'round';
      buffer.lineJoin = 'round';
      buffer.strokeStyle = '#883300';
      buffer.stroke();
    }
    for (int i = 0; i < subroots.length; i++) {
      subroots[i].draw();
    }
  }
  
}

class Lake {
  
  static const int WATER = 0;
  static const int LAVA = 1;
  
  num x, y;
  num width, height;
  int type;
  bool known;
  
  Lake(num x, num y) {
    this.x = x - 75;
    this.y = y - 50;
    width = 150;
    height = 100;
    if (random.nextBool()) {
      type = WATER;
    } else {
      type = LAVA;
    }
    known = false;
  }
  
  bool contains(Point<num> point) {
    if (point.x >= x && point.y >= y && point.x < x + width && point.y < y + height) {
      return true;
    }
    return false;
  }
  
  void hit(Root root) {
    root.target = root.length;
    if (!known) {
      known = true;
      if (type == WATER) {
        waterLakes++;
      }
    }
  }
  
  void draw() {
    if (known) {
      if (type == WATER) {
        buffer.drawImageToRect(water, new Rectangle<num>(getXOnCanvas(x), getYOnCanvas(y), getXOnCanvas(width + worldX), getYOnCanvas(height + worldY)));
      } else if (type == LAVA) {
        buffer.drawImageToRect(lava, new Rectangle<num>(getXOnCanvas(x), getYOnCanvas(y), getXOnCanvas(width + worldX), getYOnCanvas(height + worldY)));
      }
    } else {
      buffer.drawImageToRect(unknown, new Rectangle<num>(getXOnCanvas(x), getYOnCanvas(y), getXOnCanvas(width + worldX), getYOnCanvas(height + worldY)));
    }
  }
  
}