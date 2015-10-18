class StageGenerator {
  
  int[][] stage;
  
  StageGenerator(int size) {
      stage = new int[size+1][500/CELL_SIZE];
  }
  
  int[][] generate() {
    for (int i = 0; i < stage.length; i++) {
      for (int j = 0; j < stage[i].length; j++) {
        stage[i][j] = 1; //air cell.
      }
      if (i % 2 == 0) { //we add a platform on even numbered ledges.
        int randLength = (int)random(3,5);
        int randStart = (int)random(0, 500/CELL_SIZE-randLength);
        for (int j = randStart; j < randStart+randLength; j++) { //
          stage[i][j] = 0; //solid cell. 
        }
      }
    }
    //bottom row is all solids, top row is all air.
    for (int i = 0; i < stage[stage.length-1].length; i++) {
      stage[stage.length-1][i] = 0;
      stage[0][i] = 1;

    }
    
    //somewhere in the top row there's a coin. this is exit.
    int rand = (int)random(1, 500/CELL_SIZE);
    stage[1][rand] = 2;
    
    return stage;
  }
}
