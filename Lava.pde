class Lava {
  
  float lavaHeight = 0;
  float speed = 1;
  PImage art;
  
  Lava() {
    lavaHeight = 0;
    art = loadImage("lava.png");
  }
  
  void move() {
    lavaHeight += speed;
  }
    
  void display() {
    int pixelsOnTop = abs(offset);
    int levelTotalHeight = CELL_SIZE*level.length();
    image(art, 0, y, 500, 500);
  }
}
