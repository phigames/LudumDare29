part of ld29;

num mouseX, mouseY;
bool mouseDown = false;
bool dragging = false;
Point addRootFork;
num dragX, dragY;
Root addRoot;

void onClick(MouseEvent event) {
  num x = getXInWorld(event.layer.x);
  num y = getYInWorld(event.layer.y);
  for (int i = 0; i < mice.length; i++) {
    if (mice[i].contains(new Point(x, y))) {
      mice.removeAt(i);
    }
  }
}

void onMouseDown(MouseEvent event) {
  if (event.button == 0) {
    mouseDown = true;
  }
}

void onMouseUp(MouseEvent event) {
  if (event.button == 0) {
    mouseDown = false;
  }
}

void onMouseMove(MouseEvent event) {
  mouseX = event.layer.x;
  mouseY = event.layer.y;
  if (mouseDown) {
    num x = getXInWorld(event.layer.x);
    num y = getYInWorld(event.layer.y);
    if (!dragging) {
      Root r = mainRoot.getRootWhichHasPointAround(x, y);
      if (r != null) {
        dragging = true;
        addRootFork = r.getPointAround(x, y);
        dragX = x;
        dragY = y;
        addRoot = r;
      }
    } else {
      dragX = x;
      dragY = y;
    }
  } else if (dragging) {
    dragging = false;
    if (addRoot.points.contains(addRootFork) && addRoot.parent != null) {
      num dx = dragX - addRootFork.x;
      num dy = dragY - addRootFork.y;
      if (dy < 0) {
        addRoot.addSubroot(new Root(addRoot, addRootFork, atan(dx / dy) + PI, sqrt(dx * dx + dy * dy)));
      } else {
        addRoot.addSubroot(new Root(addRoot, addRootFork, atan(dx / dy), sqrt(dx * dx + dy * dy)));
      }
    }
  }
}

void onMouseWheel(WheelEvent event) {
  if (!gameOver) {
    num x = worldX + event.layer.x / worldScale;
    num y = worldY + event.layer.y / worldScale;
    worldScale -= event.deltaY.sign / 10;
    if (canvasWidth > worldWidth * worldScale) {
      worldScale = canvasWidth / worldWidth;
    } else {
      worldX = x - event.layer.x / worldScale;
    }
    if (canvasHeight > worldHeight * worldScale) {
      worldScale = canvasHeight / worldHeight;
    } else {
      worldY = y - event.layer.y / worldScale;
    }
  }
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

void onResize(Event event) {
  canvasWidth = window.innerWidth;
  canvasHeight = window.innerHeight;
  canvas.canvas.width = canvasWidth;
  canvas.canvas.height = canvasHeight;
  buffer.canvas.width = canvasWidth;
  buffer.canvas.height = canvasHeight;
}