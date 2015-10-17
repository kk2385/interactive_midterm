class Player
{
  // artwork
  PImage artwork;

  // location
  float x, y;

  // speed (constant)
  float speed = 3;

  // jump power
  float jumpPower = 0;

  boolean canLand = true; //if (!canLand) the character will keep falling even if it hits solids.
  Player(float _x, float _y)
  {
    // store position
    x = _x;
    y = _y;

    // load artwork
    artwork = loadImage("marioright.png");
  }  

  void move()
  {
    // move right
    if (keyD) 
    {
      // we need to check to see what tile is to our right (by 3 pixels or so)
      int tileCode = getTileCode(x + CELL_SIZE + 3, y + CELL_SIZE/2, offset);

      // debugging ellipse (to show the point that we are checking)
      ellipse(x + CELL_SIZE + 3, y+CELL_SIZE/2, 10, 10);

      x += speed;
      fill(255);
    }

    // left
    if (keyA) 
    { 
      // debugging ellipse
      ellipse(x-3, y+CELL_SIZE/2, 10, 10);
      x -= speed;
      fill(255);
    }


    // jump
    if (keyW) { 

      // only jump if we are on solid ground (not falling, not jumping)
      if (jumpPower == 0)
      {
        jumpPower = 7;
      }
      
      canLand = false;
    }


    // apply jump power (if we are actively jumping this will push us up into the sky)
    y -= jumpPower;
    if (offset <= 0) y += cameraPace; //move mario with camera.

    // always pull down the character (gravity) if we aren't on solid land
//    print("down:");
    int downTileCode = getTileCode(x + CELL_SIZE/2, y + CELL_SIZE+3, offset);
    int currTileCode = getTileCode(x + CELL_SIZE/2, y + CELL_SIZE-5, offset);
    // debugging ellipse
    ellipse(x+CELL_SIZE/2, y+CELL_SIZE+3, 10, 10);
    fill(255,200,5);
    ellipse(x+CELL_SIZE/2, y+CELL_SIZE-5, 10, 10);
//    println("jumppower: " + jumpPower);

    if (isSolid(downTileCode) && !isSolid(currTileCode) && canLand)
    {
      jumpPower = 0;
      fill(255);
      text("Tile below mario is SOLID. jumpPower=" + jumpPower, 20, 20);
    } else
    {
      jumpPower -= 0.2;
      if (jumpPower <= 0) canLand = true;
      fill(255);
      text("Tile below mario is NOT SOLID. jumpPower=" + jumpPower, 20, 20);
    }
  }


  // draw the player
  void display()
  {
    image(artwork, x, y, CELL_SIZE, CELL_SIZE);
  }
}

