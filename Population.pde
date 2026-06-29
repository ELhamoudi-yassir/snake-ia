class Population {
  
  Snake[] snakes;

  int gen = 1;
  int globalBest = 4;
  long globalBestFitness = 0;
  int currentBest = 4;
  int currentBestSnake = 0; 

  Snake globalBestSnake; 
  int populationID = floor(random(10000)); //
//---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //constructor
  Population(int size) {
    snakes = new Snake[size];

    for (int i =0; i<snakes.length; i++) {
      snakes[i] = new Snake();
    }
    globalBestSnake = snakes[0].clone();

  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  
  

  Population(int size, Snake best) {
    
    
    snakes = new Snake[size];
    
  
    for (int i =0; i<snakes.length; i++) {
      snakes[i] = best.clone();
      snakes[i].mutate(globalMutationRate);
    }
    
    globalBestSnake = best.clone();

  }
  
  

  Population(Snake best) {
    
    
    snakes = new Snake[2000];
    
   
    for (int i =0; i<snakes.length; i++) {
      snakes[i] = best.clone();
      snakes[i].test = true;
    }
    


  }
   
  
//---------------------------------------------------------------------------------------------------------------------------------------------------------    
 
  void updateAlive() {
    for (int i = 0; i< snakes.length; i++) {
      if (snakes[i].alive) {
        snakes[i].look(); 
        snakes[i].setVelocity(); 
        snakes[i].move(); 
     
      }
    }
    setCurrentBest(); 
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------    
  boolean done() {
    for (int i = 0; i< snakes.length; i++) {
      if (snakes[i].alive) {
        return false;
      }
    }

    return true;
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  
  void calcFitness() {
    for (int i = 0; i< snakes.length; i++) {

      snakes[i].calcFitness();
    }
  }
  
 //---------------------------------------------------------------------------------------------------------------------------------------------------------   
  void naturalSelection() {

    Snake[] newSnakes = new Snake[snakes.length]; //next generation of snakes
    
    setBestSnake();
    newSnakes[0] = globalBestSnake.clone();
    for (int i = 1; i<newSnakes.length; i++) {
      
      Snake parent1 = selectSnake();
      Snake parent2 = selectSnake();
      
      Snake child = parent1.crossover(parent2);
      child.mutate(globalMutationRate);
  
      newSnakes[i] = child;
      
         }
    snakes = newSnakes.clone();
    
    
    gen+=1;
    currentBest = 4;
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  
 
  Snake selectSnake() {
  
    long fitnessSum = 0;
    for (int i =0; i<snakes.length; i++) {
      fitnessSum += snakes[i].fitness;
    }

    
 
    long rand = floor(random(fitnessSum));
    
  
    long runningSum = 0;

    for (int i = 0; i< snakes.length; i++) {
      runningSum += snakes[i].fitness; 
      if (runningSum > rand) {
        return snakes[i];
      }
    }
 
    return snakes[0];
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  

  void setBestSnake() {

    long max =0;
    int maxIndex = 0;
    for (int i =0; i<snakes.length; i++) {
      if (snakes[i].fitness > max) {
        max = snakes[i].fitness;
        maxIndex = i;
      }
    }
  
    if(max > globalBestFitness){
      globalBestFitness = max;
      globalBestSnake = snakes[maxIndex].clone();
    }
    
    
  }
    
 //---------------------------------------------------------------------------------------------------------------------------------------------------------   

  void mutate() {
    for (int i =1; i<snakes.length; i++) {
      snakes[i].mutate(globalMutationRate);
    }
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  

  void setCurrentBest() {
    if (!done()) {//si les serpant 
      float max =0;
      int maxIndex = 0;
      for (int i =0; i<snakes.length; i++) {
        if (snakes[i].alive && snakes[i].len > max) {
          max = snakes[i].len;
          maxIndex = i;
        }
      }

      if (max > currentBest) {
        currentBest = floor(max);
      }


      if (!snakes[currentBestSnake].alive || max > snakes[currentBestSnake].len +5   ) {

        currentBestSnake  = maxIndex;
      }

      
      if (currentBest > globalBest) {
        globalBest = currentBest;
      }
    }
  }
}
