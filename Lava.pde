class Lava {
  
  float lavaHeight;
  float speed = 1;
  PImage art;
  
  Lava() {
    lavaHeight = -100; //start below map
    art = loadImage("lava.png");
  }
  
  void move() {
    lavaHeight += speed;
  }
    
  
  void reset() {
    lavaHeight = -100;
  }  
    
  void display() {
    float pixelsOnTop = abs(offset) + height;
    float levelTotalHeight = CELL_SIZE*level.length;
    float gameBottomHeight = levelTotalHeight-pixelsOnTop;
    if (lavaHeight >= gameBottomHeight) {
      System.out.println("lavaHeight: " + lavaHeight);
      System.out.println("gameBottomHeight: " + gameBottomHeight);
      System.out.println("lavaHeight-gameBottomHeight"+(lavaHeight-gameBottomHeight));
      image(art, 0, -(lavaHeight-gameBottomHeight)+height, 500, 500);
    }    
  }
}
