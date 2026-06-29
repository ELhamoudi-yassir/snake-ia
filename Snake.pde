class Snake {

  int len = 1;
  PVector pos;
  ArrayList<PVector> tailPositions; 
  PVector vel;
  PVector temp;
  Food food;
  NeuralNet brain; 
  float[] vision = new float[24]; 
  float[] decision; 

  int lifetime = 0;
  long fitness = 0;
  int leftToLive = 200;


  
  int growCount = 0;

  boolean alive = true;  
  boolean test = false;



  //---------------------------------------------------------------------------------------------------------------------------------------------------------  

  //constructor
  Snake() {
    
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


    food = new Food();




    brain = new NeuralNet(24, 18, 4);
    leftToLive = 200;
  }

 
  void mutate(float mr) {
    brain.mutate(mr);
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  


  void setVelocity() {
 
    decision = brain.output(vision);

  
    float max = 0;
    int maxIndex  =0;
    for (int i = 0; i < decision.length; i++) {
      if (max < decision[i]) {
        max = decision[i];
        maxIndex = i;
      }
    }

    if (maxIndex == 0) {
      //if (vel.x!=10 && vel.y !=0) { /: pour eviter le retour du serpant vers sans corps
      vel.x =-10;
      vel.y =0;
      //}
    } else if (maxIndex == 1) {
      //if (vel.x!=0 && vel.y !=10) {
      vel.x =0;
      vel.y =-10;
      //}
    } else if (maxIndex == 2) {
      //if (vel.x!=-10 && vel.y !=0) {
      vel.x =10;
      vel.y =0;
      //}
    } else {
      //if (vel.x!=0 && vel.y !=-10) {
      vel.x =0;
      vel.y =10;
      //}
    }
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  

  //le serpant bouger en la direction de vel
  void move() {

    lifetime+=1;
    leftToLive -=1;
 //if time left to live is up then kill the snake
    if (leftToLive < 0) {
      alive = false;
    }

    //si le serpant touche  sans corps ou les bordures
    if (gonnaDie(pos.x + vel.x, pos.y + vel.y)) {
      alive= false;
    }

    //si le serpant a la meme position du fruit
    if (pos.x + vel.x == food.pos.x && pos.y + vel.y == food.pos.y) {
      eat();
    }

    //sepant ajout un rectangle
    if (growCount > 0) {
      growCount --;
      grow();
    } else {
      for (int i = 0; i< tailPositions.size() -1; i++) {
        temp = new PVector(tailPositions.get(i+1).x, tailPositions.get(i+1).y);
        tailPositions.set(i, temp);
      }
      temp = new PVector(pos.x, pos.y);
      tailPositions.set(len-2, temp);
    }


    pos.add(vel);
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------  

  //serpant a manger fruit
  void eat() {

    //renitialiser les positions du fruit
    food = new Food(); 
    while (tailPositions.contains(food.pos)) { 
      food = new Food();
    }
   

    leftToLive += 100;

   
    if (test||len>=10) {
      growCount += 4;
    } else {
      growCount += 1;
    }
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  

//afficher le serpant
  void show() {
    fill(255);
    stroke(0);
    //afficher le corps
    for (int i = 0; i< tailPositions.size(); i++) {
      rect(tailPositions.get(i).x, tailPositions.get(i).y, 10, 10);
    }
    //afficher tete
    rect(pos.x, pos.y, 10, 10);

    //safficher fruit
    food.show();
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  

  //augmenter le corps du serpant
  void grow() {
    temp = new PVector(pos.x, pos.y);
    tailPositions.add(temp);
    len +=1;
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  //retoure true si le serpant vas toucher sans corps ou les bordures
  boolean gonnaDie(float x, float y) {
    //verfier si il touches les bordures
    if (x < 200 || y < 0 || x >= 1000 || y >= 800) {
      return true;
    }

    //si il touche sans corps
    return isOnTail(x, y);
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------    
  //verifier si il a toucher sans corps
  boolean isOnTail(float x, float y) {
    for (int i = 0; i < tailPositions.size(); i++) {
      if (x == tailPositions.get(i).x &&  y == tailPositions.get(i).y) {
        return true;
      }
    }

    return false;
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  

  void calcFitness() {
 
    if (len < 10) {
      fitness = floor(lifetime *lifetime * pow(2, (floor(len))));
    } else {
     
      fitness =  lifetime * lifetime;
      fitness *= pow(2, 10);
      fitness *=(len-9);
    }
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  

 
  Snake crossover(Snake partner) {
    Snake child = new Snake();

    child.brain = brain.crossover(partner.brain);
    return child;
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  


  Snake clone() {
    Snake clone = new Snake();
    clone.brain = brain.clone();
    clone.alive = true;
    return clone;
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  


  void saveSnake(int snakeNo, int score, int popID) {
    
    Table snakeStats = new Table();
    snakeStats.addColumn("Top Score");
    snakeStats.addColumn("PopulationID");
    TableRow tr = snakeStats.addRow();
    tr.setFloat(0, score);
    tr.setInt(1, popID);

    saveTable(snakeStats, "data/SnakeStats" + snakeNo+ ".csv");


    saveTable(brain.NetToTable(), "data/Snake" + snakeNo+ ".csv");
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  

 
  Snake loadSnake(int snakeNo) {

    Snake load = new Snake();
    Table t = loadTable("data/Snake" + snakeNo + ".csv");
    load.brain.TableToNet(t);
    return load;
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------  

  //veridier 8 direction pour eviter le corps et les bordures
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

    //regarder si ya des bordures
    while (!(position.x < 200 || position.y < 0 || position.x >= 1000 || position.y >= 800)) {

      //tester la osition du fruit
      if (!foodIsFound && position.x == food.pos.x && position.y == food.pos.y) {
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
