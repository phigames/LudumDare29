part of ld29;

ImageElement imgGround;
ImageElement imgGrass;
ImageElement imgSky;
ImageElement imgUnknown;
ImageElement imgWater;
ImageElement imgEmpty;
ImageElement imgFertilizer;
ImageElement imgMouse;
ImageElement imgClock;
ImageElement imgBucket;

void loadResources() {
  imgGround = new ImageElement();
  imgGround.src = 'res/ground.png';
  imgGrass = new ImageElement();
  imgGrass.src = 'res/grass.png';
  imgSky = new ImageElement();
  imgSky.src = 'res/sky.png';
  imgUnknown = new ImageElement();
  imgUnknown.src = 'res/unknown.png';
  imgWater = new ImageElement();
  imgWater.src = 'res/water.png';
  imgEmpty = new ImageElement();
  imgEmpty.src = 'res/lava.png';
  imgFertilizer = new ImageElement();
  imgFertilizer.src = 'res/fertilizer.png';
  imgMouse = new ImageElement();
  imgMouse.src = 'res/mouse.png';
  imgClock = new ImageElement();
  imgClock.src = 'res/clock.png';
  imgBucket = new ImageElement();
  imgBucket.src = 'res/bucket.png';
}