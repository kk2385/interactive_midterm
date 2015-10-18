class StageGenerator {
  
  int[][] stage;
  int size;
  
  StageGenerator(int _size) {
    size = _size;
    stage = new int[size+1][500/CELL_SIZE];
  }
  
  int[][] generate() {
    setAllToAir();
    fillInPlatforms();
    setBottomRowToAllSolid();
    setTopThreeRowsToAllAir();
    setRandomCoinOnTop();
    return stage;
  }
  
  void fillInPlatforms() {
    for (int i = 0; i < stage.length; i++) {
      if (i % 2 == 0) { //we add a platform on even numbered ledges.
        int randLength = (int)random(3,5);
        int randStart = (int)random(0, 500/CELL_SIZE-randLength);
        for (int j = randStart; j < randStart+randLength; j++) { //
          stage[i][j] = 0; //solid cell. 
        }
      }
    }
  }
  
  //sets every grid to an air grid (value : 1)
  void setAllToAir() { 
    for (int i = 0; i < stage.length; i++) {
      for (int j = 0; j < stage[i].length; j++) {
        stage[i][j] = 1; //air cell.
      }
    }
  }
  
  
  //place a random coin in the 2nd row of the game.
  void setRandomCoinOnTop() {
    //somewhere in the 2nd row there's a coin. this is exit.
    int rand = (int)random(1, 500/CELL_SIZE);
    stage[1][rand] = 2;
  }
  
  //sets the bottom row to be all solids (value: 0)
  void setBottomRowToAllSolid() {
     for (int i = 0; i < stage[stage.length-1].length; i++) {
      stage[stage.length-1][i] = 0;
    }
  }
  
  //sets the top three rows to be all air (value: 1)
  void setTopThreeRowsToAllAir() {
    for (int i = 0; i < stage[0].length; i++) {
      stage[0][i] = 1;
      stage[1][i] = 1;
      stage[2][i] = 1;
    }
  }
  
}
