part of ld29;

bool mouseDown = false;
bool dragging = false;
num addRootX1, addRootY1, addRootX2, addRootY2;
Root addRoot;

void onClick(MouseEvent event) {
  
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
        addRootX1 = x;
        addRootY1 = y;
        addRootX2 = x;
        addRootY2 = y;
        addRoot = r;
      }
    } else {
      addRootX2 = x;
      addRootY2 = y;
    }
  } else if (dragging) {
    dragging = false;
    num dx = addRootX2 - addRootX1;
    num dy = addRootY2 - addRootY1;
    if (dy < 0) {
      addRoot.addSubroot(new Root(addRootX1, addRootY1, atan(dx / dy) + PI, sqrt(dx * dx + dy * dy)));
    } else {
      addRoot.addSubroot(new Root(addRootX1, addRootY1, atan(dx / dy), sqrt(dx * dx + dy * dy)));
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