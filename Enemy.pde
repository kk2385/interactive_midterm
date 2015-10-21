class Enemy{
  float x;
  float y;
  Enemy(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  void display(){
    ellipse(this.x, this.y, 30, 30);
  }
}
