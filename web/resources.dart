part of ld29;

ImageElement imgGround;
ImageElement imgGrass;
ImageElement imgSky;
ImageElement imgSprout;
ImageElement imgWaterUnknown;
List<ImageElement> imgWater;
List<ImageElement> imgFertilizerSmall;
List<ImageElement> imgFertilizerLarge;
List<ImageElement> imgTreasure;
ImageElement imgMouse;
ImageElement imgClock;
ImageElement imgBucket;
ImageElement imgTrunk;
ImageElement imgTop;
AudioElement sndEat;
AudioElement sndDie;
AudioElement sndRoot;
AudioElement sndWater;
AudioElement sndFertilizer;
AudioElement sndTreasure;

void loadResources() {
  imgGround = new ImageElement();
  imgGround.src = 'res/ground.png';
  imgGrass = new ImageElement();
  imgGrass.src = 'res/grass.png';
  imgSky = new ImageElement();
  imgSky.src = 'res/sky.png';
  imgSprout = new ImageElement();
  imgSprout.src = 'res/sprout.png';
  imgWaterUnknown = new ImageElement();
  imgWaterUnknown.src = 'res/water_unknown.png';
  imgWater = new List<ImageElement>();
  for (int i = 0; i < 4; i++) {
    imgWater.add(new ImageElement());
    imgWater[i].src = 'res/water_' + i.toString() + '.png';
  }
  imgFertilizerSmall = new List<ImageElement>();
  for (int i = 0; i < 3; i++) {
    imgFertilizerSmall.add(new ImageElement());
    imgFertilizerSmall[i].src = 'res/fertilizer_small_' + i.toString() + '.png';
  }
  imgFertilizerLarge = new List<ImageElement>();
  for (int i = 0; i < 3; i++) {
    imgFertilizerLarge.add(new ImageElement());
    imgFertilizerLarge[i].src = 'res/fertilizer_large_' + i.toString() + '.png';
  }
  imgTreasure = new List<ImageElement>();
  for (int i = 0; i < 4; i++) {
    imgTreasure.add(new ImageElement());
    imgTreasure[i].src = 'res/treasure_' + i.toString() + '.png';
  }
  imgMouse = new ImageElement();
  imgMouse.src = 'res/mouse.png';
  imgClock = new ImageElement();
  imgClock.src = 'res/clock.png';
  imgBucket = new ImageElement();
  imgBucket.src = 'res/bucket.png';
  imgTrunk = new ImageElement();
  imgTrunk.src = 'res/trunk.png';
  imgTop = new ImageElement();
  imgTop.src = 'res/top.png';
  sndEat = new AudioElement();
  sndEat.src = 'res/eat.wav';
  sndDie = new AudioElement();
  sndDie.src = 'res/die.wav';
  sndRoot = new AudioElement();
  sndRoot.src = 'res/root.wav';
  sndWater = new AudioElement();
  sndWater.src = 'res/water.wav';
  sndFertilizer = new AudioElement();
  sndFertilizer.src = 'res/fertilizer.wav';
  sndTreasure = new AudioElement();
  sndTreasure.src = 'res/treasure.wav';
}