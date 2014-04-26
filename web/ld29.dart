library ld29;

import 'dart:html';
import 'dart:math';

part 'input.dart';

CanvasRenderingContext2D canvas;
CanvasRenderingContext2D buffer;
int canvasWidth, canvasHeight;
ImageElement background;
num lastTime;
num worldX, worldY, worldWidth, worldHeight;
num worldScale;
bool keyLeft, keyUp, keyRight, keyDown;
Root mainRoot;
num growTime;
num growInterval;

void main() {
  CanvasElement c = querySelector('#canvas');
  canvas = c.context2D;
  CanvasElement b = new CanvasElement();
  buffer = b.context2D;
  onResize(null);
  background = new ImageElement();
  background.src = 'res/background.png';
  lastTime = -1;
  worldX = 0;
  worldY = 0;
  worldWidth = 2000;
  worldHeight = 1500;
  worldScale = 1.0;
  keyLeft = false;
  keyUp = false;
  keyRight = false;
  keyDown = false;
  c.onClick.listen(onClick);
  c.onMouseWheel.listen(onMouseWheel);
  document.onKeyDown.listen(onKeyDown);
  document.onKeyUp.listen(onKeyUp);
  window.onResize.listen(onResize);
  window.animationFrame.then(frame);
  mainRoot = new Root(1000, 200, 0);
  growTime = 0;
  growInterval = 500;
}

void frame(num time) {
  if (lastTime != -1) {
    update(time - lastTime);
  }
  lastTime = time;
  drawWorld();
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
    worldX -= time / 2;
  }
  if (keyUp) {
    worldY -= time / 2;
  }
  if (keyRight) {
    worldX += time / 2;
  }
  if (keyDown) {
    worldY += time / 2;
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
  buffer.drawImageToRect(background, new Rectangle<num>(0, 0, canvasWidth, canvasHeight), sourceRect: new Rectangle<num>(worldX, worldY, canvasWidth / worldScale, canvasHeight / worldScale));
  mainRoot.draw();
}

class Root {
  
  static const num POINT_DISTANCE = 30;
  
  List<Point<num>> points;
  num angle;
  List<Root> subroots;
  
  Root(num x, num y, this.angle) {
    points = new List<Point<num>>();
    points.add(new Point<num>(x, y));
    points.add(new Point<num>(x + sin(angle) * POINT_DISTANCE, y + cos(angle) * POINT_DISTANCE));
    subroots = new List<Root>();
  }
  
  Root getRootWhichHasPointAround(num x, num y) {
    for (int i = 0; i < points.length; i++) {
      if ((points[i].x - x).abs() < 10 && (points[i].y - y).abs() < 10) {
        return this;
      }
    }
    for (int i = 0; i < subroots.length; i++) {
      return subroots[i].getRootWhichHasPointAround(x, y);
    }
    return null;
  }
  
  void grow() {
    Point l = points[points.length - 1];
    points.add(new Point<num>(l.x + sin(angle) * POINT_DISTANCE, l.y + cos(angle) * POINT_DISTANCE));
  }
  
  void addSubroot(num x, num y) {
    subroots.add(new Root(x, y, 1));
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
      buffer.stroke();
    }
    for (int i = 0; i < subroots.length; i++) {
      subroots[i].draw();
    }
  }
  
}