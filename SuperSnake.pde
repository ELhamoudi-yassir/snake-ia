

class SuperSnake {




  int len = 1;
  PVector pos;
  ArrayList<PVector> tailPositions; 
  PVector vel;
  PVector temp;
 Food fruit;
  float[] vision = new float[24];
  float[] decision;
int score=0;

  int leftToLive = 500; 




  int growCount = 0; 
  boolean alive = true;  



  NeuralNet[] brain; 

  SuperSnakeClone[] clones;

  int brainToFollow = 0;  
  boolean foodFound = false;
  boolean sawFood = false; 
  int movesToFollow = 0;


  //---------------------------------------------------------------------------------------------------------------------------------------------------------  

  //constructor
  SuperSnake(NeuralNet[] demBrains) {
  
    int x = 600;
    int y = 200;
    pos = new PVector(x, y);
    vel = new PVector(10, 0);
    tailPositions = new ArrayList<PVector>();
    temp = new PVector(x-30, y);
    tailPositions.add(temp);
    temp = new PVector(x-20, y);
    tailPositions.add(temp);
    temp = new PVector(x-10, y);
    tailPositions.add(temp);
    len+=3;

    fruit = new Food();
    

    brain = demBrains;

    clones = new SuperSnakeClone[demBrains.length];
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------  


  void bestDecision() {
    



    for (int i = 0; i < brain.length; i++) {
      clones[i] = new SuperSnakeClone(this, brain[i]);
      clones[i].runClone();
      
    }
    
    //si un des serpant a trouver la meilleur route vers fruit
    int min = 1000;
    int cloneAteFood = -1;
    for (int i = 0; i < brain.length; i++) {

      if (clones[i].foodFound) {
        if (clones[i].moveCount < min) {
          min =  clones[i].foodSeenAtCount;
          cloneAteFood = i;

        }
      }
    }
     //si le serpant a manger fruit
    if (cloneAteFood != -1) {

      foodFound = true; 
      movesToFollow = clones[cloneAteFood].moveCount;
      brainToFollow = cloneAteFood;
      return;
    }
    

   
    //si le serpant a vue fruit
     min = 1000;
    int cloneSeenFood = -1;
    for (int i = 0; i < brain.length; i++) {

      if (clones[i].seenFood) {
        if (clones[i].foodSeenAtCount < min) {
          min =  clones[i].foodSeenAtCount;
          cloneSeenFood = i;
        }
      }
    }

   
    if (cloneSeenFood != -1) {
      sawFood = true; 
      movesToFollow = clones[cloneSeenFood].foodSeenAtCount;
      brainToFollow = cloneSeenFood;
      return;
    }


    //si le serpant na pas trouver fruit

    int max = 0;
    int cloneLastedLongest = 0;
    for (int i = 0; i < brain.length; i++) {

      if (!clones[i].ranOut) {
        if (clones[i].moveCount > max) {
          max =  clones[i].moveCount;
          cloneLastedLongest = i;
        }
      }
    }

    brainToFollow = cloneLastedLongest;
    movesToFollow = 1;
    return;
  }



  //---------------------------------------------------------------------------------------------------------------------------------------------------------  

  //depuis de tableau la meilleur direction vers fruit
  int getDirection(float[] netOutputs) {
    float max = 0;
    int maxIndex = 0;

    for (int i = 0; i < netOutputs.length; i++) {
      if (max < netOutputs[i]) {
        max = netOutputs[i];
        maxIndex = i;
      }
    }
    return maxIndex;
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------  

 
  void setVelocity() {
    look();
    //si ya pas de movement cerer un clone pour choisir un movement
    if (movesToFollow <= 0) {
      sawFood = false;
      foodFound = false;
      bestDecision();
    }

    //avoir la direction depuis brain
    int direction  = getDirection(brain[brainToFollow].output(vision));


    switch(direction) {
    case 0://left
      vel = new PVector(-10, 0);
      break;
    case 1://up
      vel = new PVector(0, -10);
      break;
    case 2://right
      vel = new PVector(10, 0);
      break;
    case 3://down
      vel = new PVector(0, 10);
      break;
    }
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //le serpant bouge vers la direction vel
  void move() {
    
    movesToFollow -=1;
    
  
    
    //si le serpant touche les bordes
    if (gonnaDie(pos.x + vel.x, pos.y + vel.y)) {
      alive= false;
    }

    //si le serpant a manger la fruit
    if (pos.x + vel.x == fruit.pos.x && pos.y + vel.y == fruit.pos.y) {
      eat();
    }
    
     //si il mange fruit ajouter la longeur
    if (growCount > 0) {
      growCount --;
      grow();
    } else {
      for (int i = 0; i< tailPositions.size() -1; i++) {
        temp = new PVector(tailPositions.get(i+1).x, tailPositions.get(i+1).y);
        tailPositions.set(i, temp);
      }

      if (len>1) {
        temp = new PVector(pos.x, pos.y);
        tailPositions.set(len-2, temp);
      }
    }


    pos.add(vel);
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  

  void eat() {
    
    //initialiser la position du fruit apres manger
    fruit = new Food(); 
    while (tailPositions.contains(fruit.pos)) {
      fruit = new Food();
    }


    
    growCount +=1;//ajoute 1
    score=+1;
    movesToFollow =0;
    foodFound = false;
    
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------  

  //afficher le serpant
  void show() {
    fill(0,255,0);
    stroke(0);
 
    
    
    for (int i = 0; i< tailPositions.size(); i++) {
      rect(tailPositions.get(i).x, tailPositions.get(i).y, 10, 10);
    }
    rect(pos.x, pos.y, 10, 10);
    fruit.show();
    stroke(255);
   fill(255);
    textSize(30);
   text("Serpant auto", 100, 400); 
   text(score, 100, 450); 
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //ajouter un rec tange
  void grow() {

    temp = new PVector(pos.x, pos.y);
    tailPositions.add(temp);
    len +=1;
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  //si le serpant toucher sans corsps ou les bordures
  boolean gonnaDie(float x, float y) {
    //si il touche bordures
    if (x < 200 || y < 0 || x >= 1000 || y >= 800) {
      return true;
    }
   for (int i = 0; i <j1.lon_corps; i++) {
   
    if(j1.corps[i].x == x && j1.corps[i].y == y)  j1.fin = true;
   }
    //si il touche sans corps
    return isOnTail(x, y);
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------    
  //position de le corps
  boolean isOnTail(float x, float y) {
    for (int i = 0; i < tailPositions.size(); i++) {
      if (x == tailPositions.get(i).x &&  y == tailPositions.get(i).y) {
        return true;
      }
    }

    return false;
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  

  //voir dans 8 direction pour voir les bordures ou le corps
  void look() {
    vision = new float[24];
    //look left
    float[] tempValues = lookInDirection(new PVector(-10, 0));
    vision[0] = tempValues[0];
    vision[1] = tempValues[1];
    vision[2] = tempValues[2];
    //look left/up  
    tempValues = lookInDirection(new PVector(-10, -10));
    vision[3] = tempValues[0];
    vision[4] = tempValues[1];
    vision[5] = tempValues[2];
    //look up
    tempValues = lookInDirection(new PVector(0, -10));
    vision[6] = tempValues[0];
    vision[7] = tempValues[1];
    vision[8] = tempValues[2];
    //look up/right
    tempValues = lookInDirection(new PVector(10, -10));
    vision[9] = tempValues[0];
    vision[10] = tempValues[1];
    vision[11] = tempValues[2];
    //look right
    tempValues = lookInDirection(new PVector(10, 0));
    vision[12] = tempValues[0];
    vision[13] = tempValues[1];
    vision[14] = tempValues[2];
    //look right/down
    tempValues = lookInDirection(new PVector(10, 10));
    vision[15] = tempValues[0];
    vision[16] = tempValues[1];
    vision[17] = tempValues[2];
    //look down
    tempValues = lookInDirection(new PVector(0, 10));
    vision[18] = tempValues[0];
    vision[19] = tempValues[1];
    vision[20] = tempValues[2];
    //look down/left
    tempValues = lookInDirection(new PVector(-10, 10));
    vision[21] = tempValues[0];
    vision[22] = tempValues[1];
    vision[23] = tempValues[2];


  }


  float[] lookInDirection(PVector direction) {
    
    float[] visionInDirection = new float[3];
    
    PVector position = new PVector(pos.x, pos.y);
    boolean foodIsFound = false;
    boolean tailIsFound = false;
    float distance = 0;
  
    position.add(direction);
    distance +=1;

    //verifier la direction pour eviter les bordures
    while (!(position.x < 200|| position.y < 0 || position.x >= 1000 || position.y >= 800)) {

   
      if (!foodIsFound && position.x == fruit.pos.x && position.y == fruit.pos.y) {
        visionInDirection[0] = 1;
        foodIsFound = true; 
      }

      
      if (!tailIsFound && isOnTail(position.x, position.y)) {
        visionInDirection[1] = 1/distance;
        tailIsFound = true; 
      }

      
      position.add(direction);
      distance +=1;
    }


    visionInDirection[2] = 1/distance;

    return visionInDirection;
  }

}
//merci pour@Code-Bullet Code-Bullet pour inspiration et les explications
//https://creativecommons.org/licenses/by/4.0/
