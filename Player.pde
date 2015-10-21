import ddf.minim.*;
class Player
{
  // artwork
  PImage artwork;
  PImage right;
  PImage left;
  PImage chargeRight;
  PImage chargeLeft;
  PImage airRight;
  PImage airLeft;
  PImage flutterRight;
  PImage flutterLeft;
  PImage fallingRight;
  PImage fallingLeft;
  PImage[] flutterAnimationLeft;
  PImage[] flutterAnimationRight;
  int currFlutterFrame;
  Minim minim = new Minim(this);
  
  //orientation
  boolean facingRight = true;
  
  // (rendered) location 
  float x, y;

  // speed (constant)
  float speed = 3;

  // jump related
  float jumpPower = 0;
  float charge = 0; 
  float countdown = 1; // for shortHopSound
  //frame count for flutter (dont wanna flutter forever)
  int remainingFlutterFrames = 0;  
  boolean fluttering = false;
  boolean alreadyFluttered = false;
  float animationRadius; //for animating power radius around yoshi.
 
  //game stats
  int livesRemaining;
  int currLevel = 1;
  int totalScore = 0;
  int highestGroundThisStage = 0;


  Player(float _x, float _y) {
    // store position
    x = _x;
    y = _y;

    //sounds
//    AudioPlayer flyingNoise = minim.loadFile("sounds/Flying.mp3");
//    AudioPlayer shortHopNoise = minim.loadFile("sounds/Short Hop.mp3");
//    AudioPlayer maxPowerNoise = minim.loadFile("sounds/Max Power.mp3");
    
    //start with 3 lives.
    livesRemaining = 3;

    // load artwork
    artwork = loadImage("yoshi_right.png");
    right = loadImage("yoshi_right.png");
    left = loadImage("yoshi_left.png");
    chargeRight = loadImage("charge_right.png");
    chargeLeft = loadImage("charge_left.png");
    airLeft = loadImage("jump_left.png");
    airRight = loadImage("jump_right.png");
    fallingRight = loadImage("falling_right.png");
    fallingLeft = loadImage("falling_left.png");
    flutterAnimationLeft = new PImage[2];
    flutterAnimationRight = new PImage[2]; 
    for (int i = 0; i < 2; i++) {
      flutterAnimationLeft[i] = loadImage("flutter_left_" + i + ".png");
      flutterAnimationRight[i] = loadImage("flutter_right_" + i + ".png");
    }
  }  

  void resetSound() {
    AudioPlayer[] arr = new AudioPlayer[] {dyingNoise, shortHopNoise, flyingNoise, yoshiNoise, maxPowerNoise};
    for (AudioPlayer ap : arr) {
      ap.pause();
      ap.rewind();
    }  
  }
  
  void move() {
    // move right
    boolean inAir = jumpPower != 0;
    if (keyD) {
      // we need to check to see what tile is to our right (by 3 pixels or so)
      int tileCode = getTileCode(x + PLAYER_SIZE + 3, y + PLAYER_SIZE/2, offset);
      // debugging ellipse (to show the point that we are checking)
      if (DEBUG) ellipse(x + PLAYER_SIZE + 3, y+PLAYER_SIZE/2, 10, 10);
      x += speed;
      if (x >= width) x = 0;
      fill(255);
      facingRight = !inAir? true : facingRight; //change to right if not in air.
    }

    // left
    if (keyA) { 
      // debugging ellipse
      if (DEBUG) ellipse(x-3, y+PLAYER_SIZE/2, 10, 10);
      x -= speed;
      if (x <= 0) x = width;
      fill(255);
      facingRight = !inAir? false : facingRight; //change to left if not in air.
    }
    
    //flutter
    if (inAir && keyW && !alreadyFluttered) {
      fluttering = true;
//      flyingNoise.pause();
//      flyingNoise.rewind();
      resetSound  ();
      flyingNoise.play();
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
      if (charge >= 7) {
        charge = 7;
//        maxPowerNoise.pause();
//        maxPowerNoise.rewind();
//        maxPowerNoise.play();
      }
    }

    if (!keyS && jumpPower == 0) {
      jumpPower = charge;
      charge = 0.;

    }

    
    // apply jump power (if we are actively jumping this will push us up into the sky)
    y -= jumpPower;

    // always pull down the character (gravity) if we aren't on solid land
//    print("down:");
    int downTileCode = getTileCode(x + PLAYER_SIZE/2, y + PLAYER_SIZE+3, offset);
    int currTileCode = getTileCode(x + PLAYER_SIZE/2, y + PLAYER_SIZE-5, offset);
    // debugging ellipse
    if (DEBUG) ellipse(x+PLAYER_SIZE/2, y+PLAYER_SIZE+3, 10, 10);
    fill(255,200,5);
    if (DEBUG) ellipse(x+PLAYER_SIZE/2, y+PLAYER_SIZE-5, 10, 10);
//    println("jumppower: " + jumpPower);

    boolean canLand = jumpPower <= 0;
    if (isSolid(downTileCode) && !isSolid(currTileCode) && canLand) { //land on a tile.
      fluttering = false;
      alreadyFluttered = false;
      jumpPower = 0;
      fill(255);
      countdown = 1; // Yoshi can make shortHopSound
      if (DEBUG) text("Tile below is SOLID. jumpPower=" + jumpPower, 20, 20);
    } else {
      jumpPower -= 0.2;
      if (jumpPower <= -5) jumpPower = -5;
      fill(255);
      if (DEBUG) text("Tile below is NOT SOLID. jumpPower=" + jumpPower, 20, 20);
    }
    
        
    if (!keyS && jumpPower>0 && countdown == 1) {
      countdown = 0;
      System.out.println("Short Hop here" + x);
      //shortHopNoise.pause();
      //shortHopNoise.rewind();
      resetSound();
      shortHopNoise.play();  
    }
    //if (isSolid(downTileCode)) countdown = 1;    
  }

  
  void setArtwork() {
    boolean inAir = jumpPower != 0;
    if (facingRight) { // facing right.
      if (inAir) { //all in air operations
        if (fluttering) { 
          currFlutterFrame = (frameCount % 10) >= 5? 0 : 1;
          artwork = flutterAnimationRight[currFlutterFrame];
        } else if (alreadyFluttered) {
          artwork = fallingRight;      
        } else {
          artwork = airRight;
        }
      } else if (keyS) { // charging on ground. 
        artwork = chargeRight;
      } else { //on ground.
        artwork = right;
      }
    } else { //facing left.
      if (inAir) {
        if (fluttering) {
          currFlutterFrame = (frameCount % 10) >= 5? 0 : 1;
          artwork = flutterAnimationLeft[currFlutterFrame];
        } else if (alreadyFluttered) {
          artwork = fallingLeft;      
        } else {
          artwork = airLeft;
        }
      } else if (keyS) {
        artwork = chargeLeft;
      } else {
        artwork = left;
      }
    }
  }
  
  //sets to default spawning position. Use when going to new stage.
  void respawn() {
    x = 0;
    y = 300;
    highestGroundThisStage = 0;
  }
  
  //lose a live, score reset, then respawn.
  void die() {
    livesRemaining--;
    respawn();
  }

  boolean isTouchingCoin() {
    int currTileCode = getTileCode(x + PLAYER_SIZE/2, y + PLAYER_SIZE/2, offset);
    return isCoin(currTileCode);
  }

  boolean isBelowMap() {
    return y+PLAYER_SIZE >= height;
  }
  
  boolean isTouchingLava(Lava lava) {
    return getActualHeight()-PLAYER_SIZE < lava.lavaHeight;
  }
  
  //height respect to the bottom of the level.
  float getActualHeight() {
    return CELL_SIZE*level.length-int(squid.y + abs(offset)); //total height of stage - distance yet to travel.
  }
  
  void updateScore() {
    int currHeight = CELL_SIZE*level.length-int(squid.y + abs(offset)); //total height of stage - distance yet to travel.
    if (currHeight > highestGroundThisStage) {
      totalScore += currHeight - highestGroundThisStage;
      highestGroundThisStage = currHeight;
    }
  }
  
  void displayCharge() {
    if (keyS) {
      animationRadius = charge*charge*charge / 2; //just an arbitrary value i found suitable as a radius.
    } else {
      animationRadius *= 0.9; //slowly decrease it
      if (animationRadius <= 0) animationRadius = 0;
    }
    noFill();
    stroke(15, 255, 15, 200);
    strokeWeight(8);
    if (animationRadius <= 1) animationRadius = 1; //avoid gross overflow / clunky animation
    ellipse(x+PLAYER_SIZE/2, y+PLAYER_SIZE/2+10, animationRadius, animationRadius);
  }
  // draw the player
  void display() {
    setArtwork();
    displayCharge();
    image(artwork, x, y, PLAYER_SIZE, PLAYER_SIZE);
  }
}

