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
  if (endProgress >= 1) {
    endProgress = 1;
  }
  centerX = originalCenterX + (targetCenterX - originalCenterX) * endProgress;
  centerY = originalCenterY + (targetCenterY - originalCenterY) * endProgress;
  worldScale = originalWorldScale + (targetWorldScale - originalWorldScale) * endProgress;
  worldX = centerX - canvasWidth / worldScale / 2;
  worldY = centerY - canvasHeight / worldScale / 2;
  if (endProgress >= 1) {
    
  }
}