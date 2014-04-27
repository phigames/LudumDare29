part of ld29;

DivElement tutorialElement;
DivElement tutorialTextElement;
bool tutorial;
bool tutRoot = true;
bool tutMap = false;
bool tutLake = false;
bool tutWater = false;
bool tutMouse = false;
bool tutFertilizer = false;

void updateTutorial(String event) {
  if (tutRoot && event == 'start') {
    paused = true;
    tutorialElement = querySelector('#tutorial');
    tutorialTextElement = querySelector('#tutorial_text');
    ButtonElement b = querySelector('#ok');
    b.onClick.listen(onTutorialOK);
    tutorialElement.style.left = getXOnCanvas(worldWidth / 2 + 10).toString() + 'px';
    tutorialElement.style.top = getYOnCanvas(210).toString() + 'px';
    tutorialTextElement.innerHtml = 'Hello and congratulations on your decision to play this game! This is the main root of your tree. Grow a subroot by simply drawing it where you want it using the left mouse button. Of course, it has to be connected to an existing root.';
    tutorialElement.style.display = 'block';
    tutRoot = false;
    tutMap = true;
  } else if (tutMap && event == 'root') {
    paused = true;
    tutorialElement.style.left = (canvasWidth / 2 - 150).toString() + 'px';
    tutorialElement.style.top = '10px';
    tutorialTextElement.innerHtml = 'Good job! To move the map around, put your cursor close to the edge of the window or use the arrow keys or WASD. To zoom in and out, use the mouse wheel.';
    tutorialElement.style.display = 'block';
    tutMap = false;
    tutLake = true;
  } else if (tutLake && event == 'map') {
    paused = true;
    tutorialElement.style.left = (canvasWidth / 2 - 150).toString() + 'px';
    tutorialElement.style.top = '10px';
    tutorialTextElement.innerHtml = 'Nice! Now try growing a root to one of these dark areas beneath you and see if you can find some water.';
    tutorialElement.style.display = 'block';
    tutLake = false;
    tutWater = true;
  } else if (tutWater && event == 'water') {
    paused = true;
    tutorialElement.style.left = (canvasWidth - 360).toString() + 'px';
    tutorialElement.style.top = (canvasHeight - 300).toString() + 'px';
    tutorialTextElement.innerHtml = 'Wow! You\'re good at this! On the right hand side of your screen, you can see how much water you\'ve got. You need water to grow roots faster. You can get water by connecting your roots to water.';
    tutorialElement.style.display = 'block';
    tutWater = false;
    tutMouse = true;
  } else if (tutMouse && event == 'mouse') {
    paused = true;
    tutorialElement.style.left = (canvasWidth / 2 - 150).toString() + 'px';
    tutorialElement.style.top = (canvasHeight / 2 - 100).toString() + 'px';
    tutorialTextElement.innerHtml = 'Did you hear that? I think there\'s a mouse somewhere trying to gnaw at your roots! Better go find and kill her!';
    tutorialElement.style.display = 'block';
    tutMouse = false;
    tutFertilizer = true;
  } else if (tutFertilizer && event == 'fertilizer') {
    paused = true;
    tutorialElement.style.left = (canvasWidth / 2 - 150).toString() + 'px';
    tutorialElement.style.top = (canvasHeight / 2 - 100).toString() + 'px';
    tutorialTextElement.innerHtml = 'Well done! You just found some fertilizer (aka. Mouse Poop<sup>TM</sup>)! This will help your tree grow taller in the end! Now go exploring on your own, who knows what you\'ll find <b>beneath the surface.</b> Have fun!';
    tutorialElement.style.display = 'block';
    tutFertilizer = false;
  }
}

void onTutorialOK(MouseEvent event) {
  tutorialElement.style.display = 'none';
  paused = false;
}
