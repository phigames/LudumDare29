part of ld29;

void onClick(MouseEvent event) {
  num x = getXInWorld(event.layer.x);
  num y = getYInWorld(event.layer.y);
  Root r = mainRoot.getRootWhichHasPointAround(x, y);
  if (r != null) {
    r.addSubroot(x, y);
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