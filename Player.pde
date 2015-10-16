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

      // is this a solid tile?  if so, don't allow us to move!
      if ( !isSolid(tileCode) )
      {
        x += speed;
        fill(255);
        text("Tile to the right of mario is NOT SOLID.", 20, 60);
      } else
      {
        fill(255);
        text("Tile to the right of mario is SOLID.", 20, 60);
      }
    }

    // left
    if (keyA) 
    { 
      // we need to check to see what tile is to our left (by 3 pixels or so)
      int tileCode = getTileCode(x - 3, y + CELL_SIZE/2, offset);

      // debugging ellipse
      ellipse(x-3, y+CELL_SIZE/2, 10, 10);

      // is this a solid tile?  if so, don't allow us to move!
      if ( !isSolid(tileCode) )
      {
        x -= speed;
        fill(255);
        text("Tile to the left of mario is NOT SOLID.", 20, 40);
      } else
      {
        fill(255);
        text("Tile to the left of mario is SOLID.", 20, 40);
      }
    }


    // jump
    if (keyW) { 

      // only jump if we are on solid ground (not falling, not jumping)
      if (jumpPower == 0)
      {
        jumpPower = 10;
      }
      
      canLand = false;
    }


    // apply jump power (if we are actively jumping this will push us up into the sky)
    y -= jumpPower;
    if (offset <= 0) y += cameraPace; //move mario with camera.

    // always pull down the character (gravity) if we aren't on solid land
    print("down:");
    int downTileCode = getTileCode(x + CELL_SIZE/2, y + CELL_SIZE+3, offset);
    // debugging ellipse
    ellipse(x+CELL_SIZE/2, y+CELL_SIZE+3, 10, 10);

    println("jumppower: " + jumpPower);

    
    //once you are falling and you have past through SOME air (non-solids), you can land.
    if (jumpPower < 0 && !isSolid(downTileCode)) {
      canLand = true;
    }
    
    if (isSolid( downTileCode) && canLand)
    {
      jumpPower = 0;
      fill(255);
      text("Tile below mario is SOLID. jumpPower=" + jumpPower, 20, 20);
    } else
    {
      jumpPower -= 0.2;
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

