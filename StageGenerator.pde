class StageGenerator {
  
  int[][] stage;
  
  StageGenerator(int size) {
      stage = new int[size][500/CELL_SIZE];
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
    return stage;
  }
  

}
