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
  
  //charge jump
  float charge = 0;
  
  
  //frame count for flutter (dont wanna flutter forever)
  int remainingFlutterFrames = 0;
  
  //flutter jump
  float flutter = 0;
  
  boolean fluttering = false;
  boolean alreadyFluttered = false;

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
      if (x >= width) x = 0;
      fill(255);
    }

    // left
    if (keyA) 
    { 
      // debugging ellipse
      ellipse(x-3, y+CELL_SIZE/2, 10, 10);
      x -= speed;
      if (x <= 0) x = width;
      fill(255);
    }
    
    //flutter
    boolean inAir = jumpPower != 0;
    if (inAir && keyW && !alreadyFluttered) {
      fluttering = true;
      alreadyFluttered = true;
      remainingFlutterFrames = 40;
    }
    
    if (fluttering) {
       jumpPower += 0.22;
       remainingFlutterFrames--;
       if (remainingFlutterFrames <= 0) {
         fluttering = false;
       }
    }
        
    // jump charge
    if (keyS && jumpPower == 0) { 
      charge += 0.2;
      if (charge >= 7) charge = 7;
    }

    if (!keyS && jumpPower == 0) {
      jumpPower = charge;
      charge = 0.;
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

    boolean canLand = jumpPower <= 0;
    if (isSolid(downTileCode) && !isSolid(currTileCode) && canLand) //land on a tile.
    {
      fluttering = false;
      alreadyFluttered = false;
      jumpPower = 0;
      fill(255);
      text("Tile below mario is SOLID. jumpPower=" + jumpPower, 20, 20);
    } else
    {
      jumpPower -= 0.2;
      if (jumpPower <= -5) jumpPower = -5;
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

