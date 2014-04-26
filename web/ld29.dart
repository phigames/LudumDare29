import 'dart:html';

CanvasRenderingContext2D canvas;
CanvasRenderingContext2D buffer;
int canvasWidth, canvasHeight;
ImageElement background;
num lastTime;
int worldX, worldY, worldWidth, worldHeight;
double worldScale;
bool keyLeft, keyUp, keyRight, keyDown;

void main() {
  CanvasElement c = querySelector('#canvas');
  canvas = c.context2D;
  CanvasElement b = new CanvasElement();
  b.width = c.width;
  b.height = c.height;
  buffer = b.context2D;
  canvasWidth = c.width;
  canvasHeight = c.height;
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
  document.onKeyDown.listen(onKeyDown);
  document.onKeyUp.listen(onKeyUp);
  window.animationFrame.then(frame);
}

void onKeyDown(KeyboardEvent event) {
  if (event.keyCode == KeyCode.LEFT || event.keyCode == KeyCode.A) {
    keyLeft = true;
  } else if (event.keyCode == KeyCode.UP || event.keyCode == KeyCode.W) {
    keyUp = true;
  } else if (event.keyCode == KeyCode.RIGHT || event.keyCode == KeyCode.D) {
    keyRight = true;
  } else if (event.keyCode == KeyCode.DOWN || event.keyCode == KeyCode.S) {
    keyDown = true;
  }
}

void onKeyUp(KeyboardEvent event) {
  if (event.keyCode == KeyCode.LEFT || event.keyCode == KeyCode.A) {
      keyLeft = false;
    } else if (event.keyCode == KeyCode.UP || event.keyCode == KeyCode.W) {
      keyUp = false;
    } else if (event.keyCode == KeyCode.RIGHT || event.keyCode == KeyCode.D) {
      keyRight = false;
    } else if (event.keyCode == KeyCode.DOWN || event.keyCode == KeyCode.S) {
      keyDown = false;
    }
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
  if (keyLeft) {
    worldX -= time;
  } else if (keyUp) {
    worldY -= time;
  } else if (keyRight) {
    worldX += time;
  } else if (keyDown) {
    worldY += time;
  }
}

void drawWorld() {
  buffer.drawImageToRect(background, new Rectangle<num>(0, 0, canvasWidth, canvasHeight), sourceRect: new Rectangle<num>(worldX, worldY, canvasWidth * worldScale, canvasHeight * worldScale));
}