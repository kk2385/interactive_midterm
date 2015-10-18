//enable print messages
boolean DEBUG = false;

// key flags
boolean keyA = false;
boolean keyS = false;
boolean keyD = false;
boolean keyW = false;

int CELL_SIZE = 25;
int PLAYER_SIZE = 50;
// an Array to hold all of our tiles
PImage[] tiles = new PImage[3];

StageGenerator sg;
int[][] level;

float offset; //camera offset.

int highScore;
Player squid; // in our version it's a yoshi, though

boolean deathScreen; //death screen toggle

void setup() {
  size(500, 500);
  loadTiles();
  squid = new Player(0, 300);
  sg = new StageGenerator(40);
  resetStage();
  highScore = 0;
  deathScreen = false;
}

void draw() {
  if (deathScreen) {
    deathScreen();
  } else {
    gamePlaying();
  }
}

//interactions during game play
void gamePlaying() {
  drawLevel();
  adjustCameraView();
  squid.move();
  squid.display();
  if (squid.isBelowMap()) {
    goToDeathScreen();
    squid.die();
    resetStage();
  }
  if (squid.isTouchingCoin()) {
    toNextStage();
  }
  squid.updateScore();
  setHighScore();
  displayScore();
}

//intereactions with death screen
void deathScreen() {
  background(0);
  if (squid.livesRemaining > 0) { //there are still lives
    text("You are dead!", 20, 20);
    text("Lives remaining: " + squid.livesRemaining, 20, 40);
    text("Press space to continue.", 20, 60);
    if (keyPressed && key==' ') {
      exitDeathScreen();
    }
  } else { //no more lives.
    text("Game Over!", 20, 20);
    text("Press space to start a new game.", 20, 40);
    if (keyPressed && key==' ') {
      exitDeathScreen();
      newGame();
    }
  }  
}

//death screen toggles
void goToDeathScreen() {deathScreen = true;}
void exitDeathScreen() {deathScreen = false;}

//resets camera angle and then produces new stage.
void resetStage() {
  level = sg.generate();
  resetCameraAngle();
}


//text representation of score
void displayScore() {
  text("High Score: " + highScore, 20, 30);
  text("Score: " + squid.totalScore, 20, 50);
  text("Lives Remaining: " + squid.livesRemaining, 20, 70);
  text("Level: " + squid.currLevel, 20, 90);
}

//create a brand new game. used for after game over.
void newGame() {
  resetStage();
  squid = new Player(0, 300);
  resetCameraAngle();
  displayScore();
}


//resets the camera to the bottom of the level
void resetCameraAngle() {
  offset = (-CELL_SIZE*level.length) + CELL_SIZE*(width/CELL_SIZE);  
}


//Goes to the next level for the player by creating a new stage and incrementing level.
void toNextStage() {
  resetStage();
  squid.respawn();
  squid.currLevel++;
}


//Sets high score if current player's score is better than high score.
void setHighScore() {
  highScore = max(highScore, squid.totalScore);
}



// Updates the camera view of the game depending on Yoshi's location.
void adjustCameraView() {
//  System.out.println("offset: " + offset);
  if (offset < 0 && squid.y <= width/3) { //move camera up if yoshi is in the top 1/3 of screen.
    offset+=2;
    squid.y+=2; //move our character up too, since the world is technically "shifting".
  }
  if (offset >= 0) offset = 0;
}

// load our tiles into memory
void loadTiles() {
  for (int i = 0; i < tiles.length; i++) {
    tiles[i] = loadImage(i + ".png");
  }
}

// iterate over the level array and draw the correct tile to the screen
void drawLevel() {
  for (int row = 0; row < level.length; row++) {
    for (int col = 0; col < level[row].length; col++) {
      int tileID = level[row][col];
      image(tiles[tileID], col*CELL_SIZE, offset+row*CELL_SIZE, CELL_SIZE, CELL_SIZE);
    }
  }
}

// getTileCode - modified from lecture code to take into account camera offset.
int getTileCode(float x, float y, float offset) {
  // convert x & y coordinate to an array coordinate
  int col = int(x)/CELL_SIZE;
  int row = int(y + abs(offset))/CELL_SIZE;
  if (x >= width || x <= 0 || y >= height || y <= 0){
    return 1; // off the board - return air tile
  }
  // otherwise return the tile value
  return level[row][col];
}

// isSolid - returns true if the tile in question is solid, false if not.
boolean isSolid(int tileCode)
{
  return tileCode == 0;
}

boolean isCoin(int tileCode) {
  return tileCode == 2;
}

// handle multiple key presses
void keyPressed() {
  if (key == 'a') { keyA = true; }  
  if (key == 's') { keyS = true; }  
  if (key == 'd') { keyD = true; }  
  if (key == 'w') { keyW = true; }    
}

void keyReleased() {
  if (key == 'a') { keyA = false; }  
  if (key == 's') { keyS = false; }  
  if (key == 'd') { keyD = false; }  
  if (key == 'w') { keyW = false; }    
}
