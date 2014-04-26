library ld29;

import 'dart:html';
import 'dart:math';

part 'input.dart';
part 'root.dart';
part 'lake.dart';
part 'mouse.dart';

CanvasRenderingContext2D canvas;
CanvasRenderingContext2D buffer;
int canvasWidth, canvasHeight;
ImageElement background;
ImageElement unknown;
ImageElement water;
ImageElement empty;
ImageElement mouse;
num lastTime;
Random random;
num worldX, worldY, worldWidth, worldHeight;
num worldScale;
bool keyLeft, keyUp, keyRight, keyDown;
List<Mouse> mouses;
List<Lake> lakes;
Root mainRoot;
num growTime;
num growInterval;
num waterTime;
num waterInterval;
num waterSupply;
num mouseTime;
num mouseInterval;
num gnawTime;
num gnawInterval;

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
  empty = new ImageElement();
  empty.src = 'res/lava.png';
  mouse = new ImageElement();
  mouse.src = 'res/mouse.png';
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
  mouses = new List<Mouse>();
  mainRoot = new Root(null, new Point(1000, 200), 0, 120);
  growTime = 0;
  growInterval = 500;
  waterTime = 0;
  waterInterval = 1000;
  waterSupply = 105;
  mouseTime = 0;
  mouseInterval = 20000;
  gnawTime = 0;
  gnawInterval = 1000;
  generateWorld();
}

/**
 * adds lakes
 */
void generateWorld() {
  for (int i = 0; i < 10; i++) {
    lakes.add(new Lake(random.nextInt(1500) + 150, random.nextInt(1000) + 500));
  }
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
    for (int i = 0; i < lakes.length; i++) {
      lakes[i].drain();
    }
    waterTime -= waterInterval;
  }
  mouseTime += time;
  if (mouseTime >= mouseInterval) {
    Root m = mainRoot.getSubroot(random.nextInt(3) + 2);
    if (m != null) {
      mouses.add(new Mouse(m));
    }
    mouseTime -= mouseInterval;
    mouseInterval = random.nextInt(10000) + 10000;
  }
  gnawTime += time;
  if (gnawTime >= gnawInterval) {
    for (int i = 0; i < mouses.length; i++) {
      mouses[i].gnaw();
      if (mouses[i].done) {
        mouses.removeAt(i);
        i--;
      }
    }
    gnawTime -= gnawInterval;
  }
}

/**
 * converts world x coordinates to screen x coordinates
 */
num getXOnCanvas(num x) {
  return (x - worldX) * worldScale;
}

/**
 * converts world y coordinates to screen y coordinates
 */
num getYOnCanvas(num y) {
  return (y - worldY) * worldScale;
}

/**
 * converts screen x coordinates to world x coordinates
 */
num getXInWorld(num x) {
  return x / worldScale + worldX;
}

/**
 * converts screen y coordinates to world y coordinates
 */
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
  for (int i = 0; i < mouses.length; i++) {
    mouses[i].draw();
  }
  if (dragging) {
    buffer.beginPath();
    buffer.moveTo(getXOnCanvas(addRootFork.x), getYOnCanvas(addRootFork.y));
    buffer.lineTo(getXOnCanvas(mouseX), getYOnCanvas(mouseY));
    buffer.lineWidth = 2;
    buffer.lineCap = 'round';
    buffer.strokeStyle = '#008800';
    buffer.stroke();
  }
  buffer.fillText(waterSupply.toString(), 0, 10);
}