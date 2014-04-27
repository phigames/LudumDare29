library ld29;

import 'dart:html';
import 'dart:math';

part 'input.dart';
part 'root.dart';
part 'lake.dart';
part 'mouse.dart';
part 'resources.dart';
part 'end.dart';
part 'tutorial.dart';

CanvasRenderingContext2D canvas;
CanvasRenderingContext2D buffer;
int canvasWidth, canvasHeight;
num lastTime;
Random random;
num worldX, worldY, worldWidth, worldHeight;
num worldScale;
bool keyLeft, keyUp, keyRight, keyDown;
List<Mouse> mice;
List<Hittable> hittables;
Root mainRoot;
num growTime;
num growInterval;
num drainTime;
num drainInterval;
num waterSupply;
num mouseTime;
num mouseInterval;
num gnawTime;
num gnawInterval;
num endTime;
num end;
num score;
bool gameOver;
bool paused;

void main() {
  CanvasElement c = querySelector('#canvas');
  canvas = c.context2D;
  CanvasElement b = new CanvasElement();
  buffer = b.context2D;
  onResize(null);
  mouseX = canvasWidth / 2;
  mouseY = canvasHeight / 2;
  lastTime = -1;
  random = new Random();
  worldWidth = 4000;
  worldHeight = 10000;
  worldX = worldWidth / 2 - canvasWidth / 2;
  worldY = 0;
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
  hittables = new List<Hittable>();
  mice = new List<Mouse>();
  mainRoot = new Root(null, new Point(worldWidth / 2, 200), 0, 200);
  growTime = 0;
  growInterval = 500;
  drainTime = 0;
  drainInterval = 1000;
  waterSupply = 200;
  mouseTime = 0;
  mouseInterval = 20000;
  gnawTime = 0;
  gnawInterval = 1000;
  endTime = 0;
  end = 300000;
  score = 0;
  gameOver = false;
  paused = false;
  tutorial = true;
  loadResources();
  generateWorld();
  if (tutorial) {
    updateTutorial('start');
  }
}

/**
 * adds lakes
 */
void generateWorld() {
  for (int i = 0; i < 50; i++) {
    hittables.add(new Lake(random.nextInt(3500) + 500, random.nextInt(8000) + 500));
  }
  for (int i = 0; i < 20; i++) {
    hittables.add(new FertilizerSmall(random.nextInt(3500) + 250, random.nextInt(5000) + 3000));
  }
  for (int i = 0; i < 10; i++) {
    hittables.add(new FertilizerLarge(random.nextInt(3500) + 250, random.nextInt(3000) + 6000));
  }
  hittables.add(new Treasure(worldWidth / 2, worldHeight - 100));
}

void frame(num time) {
  if (lastTime != -1) {
    if (gameOver) {
      updateEnding(time - lastTime);
    } else {
      update(time - lastTime);
    }
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
  if (!paused) {
    growTime += time;
    if (growTime >= growInterval) {
      mainRoot.grow();
      growTime -= growInterval;
      growInterval = 8000 / waterSupply;
    }
    drainTime += time;
    if (drainTime >= drainInterval) {
      for (int i = 0; i < hittables.length; i++) {
        hittables[i].drain();
      }
      drainTime -= drainInterval;
    }
    mouseTime += time;
    if (mouseTime >= mouseInterval) {
      Root m = mainRoot.getSubroot(random.nextInt(7) + 2);
      if (m != null) {
        mice.add(new Mouse(m));
      }
      mouseTime -= mouseInterval;
      mouseInterval = random.nextInt(30000) + 20000;
    }
    gnawTime += time;
    if (gnawTime >= gnawInterval) {
      for (int i = 0; i < mice.length; i++) {
        mice[i].gnaw();
        if (mice[i].done) {
          mice.removeAt(i);
          i--;
        }
      }
      gnawTime -= gnawInterval;
    }
    endTime += time;
    if (endTime >= end) {
      gameOver = true;
      startEnding();
    }
  }
}

/**
 * converts world x coordinates to screen x coordinates
 */
num getXOnCanvas(num x) {
  return ((x - worldX) * worldScale).floor();
}

/**
 * converts world y coordinates to screen y coordinates
 */
num getYOnCanvas(num y) {
  return ((y - worldY) * worldScale).floor();
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
  if (!paused) {
    if (keyLeft || mouseX < 50) {
      worldX -= time * 1.5;
      if (tutorial) {
        updateTutorial('map');
      }
    }
    if (keyUp || mouseY < 50) {
      worldY -= time * 1.5;
      if (tutorial) {
        updateTutorial('map');
      }
    }
    if (keyRight || mouseX >= canvasWidth - 50) {
      worldX += time * 1.5;
      if (tutorial) {
        updateTutorial('map');
      }
    }
    if (keyDown || mouseY >= canvasHeight - 50) {
      worldY += time * 1.5;
      if (tutorial) {
        updateTutorial('map');
      }
    }
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
  int x = (worldX / 500).floor() * 500;
  int y = (worldY / 500).floor() * 500;
  num w = (canvasWidth / worldScale / 500).ceil();
  num h = (canvasHeight / worldScale / 500).ceil();
  for (int i = 0; i <= w; i++) {
    for (int j = 0; j <= h; j++) {
      num yy = y + j * 500;
      num xx = x + i * 500;
      if (yy == 0) {
        buffer.drawImageToRect(imgGrass, new Rectangle<num>(getXOnCanvas(xx), getYOnCanvas(yy), 500 * worldScale + 1, 500 * worldScale + 1));
      } else if (yy < 0) {
        buffer.drawImageToRect(imgSky, new Rectangle<num>(getXOnCanvas(xx), getYOnCanvas(yy), 500 * worldScale + 1, 500 * worldScale + 1));
      } else {
        buffer.drawImageToRect(imgGround, new Rectangle<num>(getXOnCanvas(xx), getYOnCanvas(yy), 500 * worldScale + 1, 500 * worldScale + 1));
      }
    }
  }
  if (!gameOver) {
    for (int i = 0; i < hittables.length; i++) {
      hittables[i].draw();
    }
    mainRoot.draw(0);
    for (int i = 0; i < mice.length; i++) {
      mice[i].draw();
    }
    if (dragging) {
      buffer.beginPath();
      buffer.moveTo(getXOnCanvas(addRootFork.x), getYOnCanvas(addRootFork.y));
      buffer.lineTo(getXOnCanvas(dragX), getYOnCanvas(dragY));
      buffer.lineWidth = 2;
      buffer.lineCap = 'round';
      buffer.strokeStyle = '#008800';
      buffer.stroke();
    }
    buffer.drawImageToRect(imgClock, new Rectangle<num>(5, canvasHeight - 65, 60, 60));
    buffer.fillStyle = '#B70000';
    buffer.fillRect(25, canvasHeight - 70, 20, (endTime - end) / end * (canvasHeight - 95));
    buffer.drawImageToRect(imgBucket, new Rectangle<num>(canvasWidth - 65, canvasHeight - 65, 60, 60));
    buffer.fillStyle = '#3760D2';
    buffer.fillRect(canvasWidth - 45, canvasHeight - 70, 20, -waterSupply / 500 * (canvasHeight - 95));
  } else {
    drawEnding();
  }
}