// key flags
boolean keyA = false;
boolean keyS = false;
boolean keyD = false;
boolean keyW = false;

int CELL_SIZE = 25;
int PLAYER_SIZE = 50;
// an Array to hold all of our tiles
PImage[] tiles = new PImage[3];

StageGenerator sg = new StageGenerator(40);
int[][] level;

float offset;

float cameraPace = 0.2;

Player squid;
void setup() {
  size(500, 500);
  loadTiles();
  squid = new Player(0, 300);
  level = sg.generate();
  offset = (-CELL_SIZE*level.length) + CELL_SIZE*(width/CELL_SIZE);
}


void resetGame() {
  level = sg.generate();
  squid = new Player(0, 300);
  offset = (-CELL_SIZE*level.length) + CELL_SIZE*(width/CELL_SIZE);
}

void draw() {
  drawLevel();
  adjustCameraView();
  squid.move();
  squid.display();
  if (squid.isBelowMap()) {
    resetGame();
  }
  System.out.println("touching coin:" + squid.isTouchingCoin());
}

void adjustCameraView() {
//  System.out.println("offset: " + offset);
  if (offset < 0 && squid.y <= width/3) {
    offset+=2;
    squid.y+=2;
  }
  if (offset >= 0) offset = 0;
  
}

// load our tiles into memory
void loadTiles()
{
  for (int i = 0; i < tiles.length; i++)
  {
    tiles[i] = loadImage(i + ".png");
  }
}

// iterate over the level array and draw the correct tile to the screen
void drawLevel()
{
  for (int row = 0; row < level.length; row++)
  {
    for (int col = 0; col < level[row].length; col++)
    {
      int tileID = level[row][col];
      image( tiles[tileID], col*CELL_SIZE, offset+row*CELL_SIZE, CELL_SIZE, CELL_SIZE);
      if (tileID == 2) { //gold coin: draw air background behind it, then draw the coin.
        image(tiles[1], col*CELL_SIZE, offset+row*CELL_SIZE, CELL_SIZE, CELL_SIZE);
        image(tiles[tileID], col*CELL_SIZE, offset+row*CELL_SIZE, CELL_SIZE, CELL_SIZE);
      }
    }
  }
}

// getTileCode - checks to see what tile is under the supplied x & y position
int getTileCode(float x, float y, float offset)
{
  // convert x & y coordinate to an array coordinate
  int col = int(x)/CELL_SIZE;
  int row = int(y + abs(offset))/CELL_SIZE;
//  System.out.printf("y: %f level:[%d][%d]\n", y, row, col);
  // off board test
  if (x >= width || x <= 0 || y >= height || y <= 0)
  {
    // off the board - return air tile
    return 1;
  }

  // otherwise return the tile value
  return level[row][col];
}


// isSolid - returns true if the tile in question is solid, false if not
// you can update this function so you can support multiple solid tiles
boolean isSolid(int tileCode)
{
  return tileCode == 0;
}

boolean isCoin(int tileCode) {
  return tileCode == 2;
}


// handle multiple key presses
void keyPressed()
{
  if (key == 'a') { keyA = true; }  
  if (key == 's') { keyS = true; }  
  if (key == 'd') { keyD = true; }  
  if (key == 'w') { keyW = true; }    
}

void keyReleased()
{
  if (key == 'a') { keyA = false; }  
  if (key == 's') { keyS = false; }  
  if (key == 'd') { keyD = false; }  
  if (key == 'w') { keyW = false; }    
}
