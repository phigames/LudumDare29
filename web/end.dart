part of ld29;

num originalCenterX, originalCenterY;
num originalWorldScale;
num centerX, centerY;
num targetCenterX, targetCenterY;
num targetWorldScale;
num endProgress;

void startEnding() {
  originalCenterX = worldX + canvasWidth / worldScale / 2;
  originalCenterY = worldY + canvasHeight / worldScale / 2;
  originalWorldScale = worldScale;
  targetWorldScale = canvasHeight / worldHeight;
  targetCenterX = worldWidth / 2;
  targetCenterY = 0;
  endProgress = 0;
}

void updateEnding(num time) {
  endProgress += time / 2000;
  if (endProgress > 1) {
    endProgress = 1;
  }
  centerX = originalCenterX + (targetCenterX - originalCenterX) * endProgress;
  centerY = originalCenterY + (targetCenterY - originalCenterY) * endProgress;
  worldScale = originalWorldScale + (targetWorldScale - originalWorldScale) * endProgress;
  worldX = centerX - canvasWidth / worldScale / 2;
  worldY = centerY - canvasHeight / worldScale / 2;
}

void drawEnding() {
  mainRoot.draw(300 * endProgress);
  num t = score / 1000 * worldHeight / 2;
  buffer.drawImageToRect(imgTrunk, new Rectangle<num>(getXOnCanvas(worldWidth / 2 - 165), getYOnCanvas(-t + 200), 330 * worldScale, t * worldScale));
  buffer.drawImageToRect(imgTop, new Rectangle<num>(getXOnCanvas(worldWidth / 2 - 665), getYOnCanvas(-t - 700), 1330 * worldScale, 1000 * worldScale));
  if (endProgress == 1) {
    buffer.fillStyle = '#005999';
    buffer.font = (canvasWidth / 30).toString() + 'px sans-serif';
    buffer.textAlign = 'left';
    buffer.fillText('Congratulations!', 50, canvasHeight / 2, canvasWidth / 2 - 150);
    buffer.textAlign = 'right';
    buffer.fillText('Your tree has grown', canvasWidth - 50, canvasHeight / 2 - canvasHeight / 30 - 20, canvasWidth / 2 - 150);
    buffer.fillStyle = '#CC2E2E';
    buffer.fillText(score.floor().toString() + ' meters tall!', canvasWidth - 50, canvasHeight / 2, canvasWidth / 2 - 150);
  }
}