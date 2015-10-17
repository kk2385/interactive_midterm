// key flags
boolean keyA = false;
boolean keyS = false;
boolean keyD = false;
boolean keyW = false;

int CELL_SIZE = 50;
// an Array to hold all of our tiles
PImage[] tiles = new PImage[2];

StageGenerator sg = new StageGenerator(16);
int[][] level;

float offset;

float cameraPace = 0.2;

Player squid;
void setup() {
  size(500, 500);
  loadTiles();
  squid = new Player(0, 300);
  level = sg.generate();
  offset = (-CELL_SIZE*level.length) + CELL_SIZE*10;
}

void draw() {
  drawLevel();
  if (offset <= 0) offset+=cameraPace;
  
//  println(offset + " " + level.length);
  squid.move();
  squid.display();
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
      image( tiles[ level[row][col] ], col*CELL_SIZE, offset+row*CELL_SIZE, CELL_SIZE, CELL_SIZE);
    }
  }
}

// getTileCode - checks to see what tile is under the supplied x & y position
int getTileCode(float x, float y, float offset)
{
  // convert x & y coordinate to an array coordinate
  int col = int(x)/CELL_SIZE;
  int row = int(y + abs(offset))/CELL_SIZE;
  //System.out.printf("y: %f level:[%d][%d]\n", y, row, col);
  // off board test
  if (x >= width || x <= 0 || y >= height || y <= 0)
  {
    // off the board - return a solid tile
    return 0;
  }

  // otherwise return the tile value
  return level[row][col];
}


// isSolid - returns true if the tile in question is solid, false if not
// you can update this function so you can support multiple solid tiles
boolean isSolid(int tileCode)
{
  if (tileCode == 1)
  {
    return false;
  } 
  
  else
  {
    return true;
  }
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
