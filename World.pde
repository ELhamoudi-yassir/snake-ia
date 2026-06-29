class World {
  int gen = 0;


  Population[] species;

  NeuralNet[] topBrains;
  SuperSnake fusedSnake;

  int worldBestScore = 0;

  Snake[] SnakesOfLegend;
  Snake legend;
  int legendNo; 
//---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //constructor
  World(int speciesNo, int popSize) {

    species = new Population[speciesNo];
    for (int i = 0; i< speciesNo; i++) {
      species[i] = new Population(popSize);
    }

    SnakesOfLegend = new Snake[5];
    for (int i = 0; i<SnakesOfLegend.length; i++) {
      SnakesOfLegend[i] = new Snake();
    }

    //initiate topbrains
    topBrains = new NeuralNet[SnakesOfLegend.length];
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  
  void updateAlive() {
    for (int i = 0; i< species.length; i++) {
      species[i].updateAlive();
    }
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  
  void geneticAlgorithm() {
    for (int i = 0; i< species.length; i++) {
      species[i].calcFitness();
      species[i].naturalSelection();
    }
    gen+=1;
    setTopScore();
    for (int i = 0; i< species.length; i++) {
      saveTopSnake(i);
    }
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  
  void loadBestSnakes() {
    for (int i = 0; i< 5; i++) {
      SnakesOfLegend[i] = SnakesOfLegend[i].loadSnake(i);
      
    }
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  
  void snakeFusion() {
    loadBestSnakes();

    for (int i = 0; i< SnakesOfLegend.length; i++) {
      topBrains[i] = SnakesOfLegend[i].brain.clone();
    }

    fusedSnake = new SuperSnake(topBrains);
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  
  void updateSuperSnake() {

    fusedSnake.look();
    fusedSnake.setVelocity(); 
    fusedSnake.move();
    fusedSnake.show();
    saveFrame("output/superSnake/frame_#######.png");
  }  
//---------------------------------------------------------------------------------------------------------------------------------------------------------  
  void updateLegend() {

    legend.look();
    legend.setVelocity();
    legend.move();
    legend.show();

  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  
  boolean done() {
    for (int i = 0; i< species.length; i++) {
      if (!species[i].done()) {
        return false;
      }
    }
    return true;
  }

//---------------------------------------------------------------------------------------------------------------------------------------------------------  
  void setTopScore() {
    long max = 0;
    int maxIndex = 0;
    for (int i = 0; i< species.length; i++) {
      if (species[i].globalBestFitness > max ) {
        max = species[i].globalBestFitness;
        maxIndex = i;
      }
    }

    worldBestScore = species[maxIndex].globalBest;
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  


  void saveTopSnake(int speciesNo) {

    
    Table t = loadTable("data/snakesStored.csv");
    int snakeNo = -1;
    TableRow tr = t.getRow(0);
    for (int i = 0; i< t.getColumnCount(); i++) {
      if (tr.getInt(i) == 0) {
        snakeNo = i;
        break;
      }
    }

    if (snakeNo!= -1) {
      species[speciesNo].globalBestSnake.clone().saveSnake(snakeNo, species[speciesNo].globalBest, species[speciesNo].populationID);
      tr=t.getRow(0);
      tr.setInt(snakeNo, 1);
      saveTable(t, "data/snakesStored.csv");
    } else {
    
      Table t1;
      TableRow tr1;
      for (int i = 0; i< t.getColumnCount(); i++) {
        t1 = loadTable("data/SnakeStats" + i+ ".csv", "header");
        tr1 = t1.getRow(0);
        if (tr1.getInt(1) == species[speciesNo].populationID) {
          if (species[speciesNo].globalBest > tr1.getInt(0)) { 
            species[speciesNo].globalBestSnake.clone().saveSnake(i, species[speciesNo].globalBest, species[speciesNo].populationID);
          }
          return;
        }
      }


      int min = species[speciesNo].globalBest;
      int minIndex = -1;

      for (int i = 0; i< t.getColumnCount(); i++) {
        t1 = loadTable("data/SnakeStats" + i+ ".csv", "header");
        tr1 = t1.getRow(0);
        if (tr1.getInt(0) < min) {
          min = tr1.getInt(0);
          minIndex = i;//
        }
      }

      if (minIndex!= -1) {
        species[speciesNo].globalBestSnake.clone().saveSnake(minIndex, species[speciesNo].globalBest, species[speciesNo].populationID);//save snake
      }
    }
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  

  void playLegend(int snakeNo) {
    loadBestSnakes();
    legend = SnakesOfLegend[snakeNo].clone();
    legendNo = snakeNo;
    legend.test = true;
  }

//---------------------------------------------------------------------------------------------------------------------------------------------------------  


  World( int popSize, Snake[] legendsArray) {

    //initiate species
    species = new Population[legendsArray.length];


    for (int i = 0; i< legendsArray.length; i++) {
      species[i] = new Population(popSize, legendsArray[i]);
    }

   
    Table t ;
    for (int i = 0; i< legendsArray.length; i++) {
      t = loadTable("data/SnakeStats" + i+ ".csv", "header");
      TableRow tr = t.getRow(0);
      species[i].populationID = tr.getInt(1);
    }
  }
  
}
