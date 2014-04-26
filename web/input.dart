part of ld29;

bool mouseDown = false;
bool dragging = false;
Point addRootFork;
num mouseX, mouseY;
Root addRoot;

void onClick(MouseEvent event) {
  num x = getXInWorld(event.layer.x);
  num y = getYInWorld(event.layer.y);
  for (int i = 0; i < mouses.length; i++) {
    if (mouses[i].contains(new Point(x, y))) {
      mouses.removeAt(i);
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
  if (mouseDown) {
    num x = getXInWorld(event.layer.x);
    num y = getYInWorld(event.layer.y);
    if (!dragging) {
      Root r = mainRoot.getRootWhichHasPointAround(x, y);
      if (r != null) {
        dragging = true;
        addRootFork = r.getPointAround(x, y);
        mouseX = x;
        mouseY = y;
        addRoot = r;
      }
    } else {
      mouseX = x;
      mouseY = y;
    }
  } else if (dragging) {
    dragging = false;
    num dx = mouseX - addRootFork.x;
    num dy = mouseY - addRootFork.y;
    if (dy < 0) {
      addRoot.addSubroot(new Root(addRoot, addRootFork, atan(dx / dy) + PI, sqrt(dx * dx + dy * dy)));
    } else {
      addRoot.addSubroot(new Root(addRoot, addRootFork, atan(dx / dy), sqrt(dx * dx + dy * dy)));
    }
  }
}

void onMouseWheel(WheelEvent event) {
  num x = worldX + event.layer.x / worldScale;
  num y = worldY + event.layer.y / worldScale;
  worldScale -= event.deltaY.sign / 10;
  worldX = x - event.layer.x / worldScale;
  worldY = y - event.layer.y / worldScale;
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