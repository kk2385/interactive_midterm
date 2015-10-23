class Enemy{
  float x;
  float y;
  PImage pic;
  boolean floatUp = true;
  float wiggleOffset = .5;
  float boo_size = 40;
  Enemy(){
    this.x = 0;
    this.y = random(50, 250);
    this.pic = loadImage("boo.png");
  }
  
  void display(){
    floatAround();
    x+=1;
    y-=wiggleOffset;
    image(pic, x, y, boo_size, boo_size);
  }
  
  void respawn(){
    x = 0;
    y = random(50, 250);
  }
  
  boolean isTouchingLava(Lava lava){
    return getActualHeight()-boo_size < lava.lavaHeight;
  }
  
  float getActualHeight() {
    return CELL_SIZE*level.length-int(y + abs(offset)); //total height of stage - distance yet to travel.
  }
  
  //every 100 frames, boo switches between going up and down
  void floatAround(){
    if(frameCount % 100 == 0){
      wiggleOffset*=-1;
    }
  }
}
