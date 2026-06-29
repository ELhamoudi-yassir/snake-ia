

class SuperSnakeClone {

  int len = 1;
  PVector pos;
  ArrayList<PVector> tailPositions; 
  PVector vel;
  PVector temp; 
  Food food;
  NeuralNet brain; 
  float[] vision = new float[24]; 
  float[] decision; 
  ArrayList<PVector> blanks = new ArrayList<PVector>();
  int leftToLive = 200; 



  int moveCount = 0; 
  boolean alive = true;  
  boolean foodFound = false;
  boolean trapped = false;


  boolean seenFood = false;
  int foodSeenAtCount = 300;
  boolean ranOut = false; 


  int growCount = 0;



  //---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //constructor
  SuperSnakeClone(SuperSnake original, NeuralNet chosenBrain) {


    pos = new PVector(original.pos.x, original.pos.y);
    tailPositions = (ArrayList)original.tailPositions.clone();
    len = original.len;
    food = original.fruit.clone();
    brain = chosenBrain.clone();
    leftToLive = original.leftToLive;
    growCount = original.growCount;
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  

  void runClone() {
    for (int i = 0; i< 500; i++) {
  
      look();
      setVelocity();
      move();
      if (!alive || foodFound || trapped) {
        return;
      }

    }
    ranOut = true; 
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------

  //depuis un tableau recuper la direction
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

    int direction = getDirection(brain.output(vision));

   //renitialiser vel dapres la direction
    switch(direction) {
    case 0:
      vel = new PVector(-10, 0);
      break;
    case 1:
      vel = new PVector(0, -10);
      break;
    case 2:
      vel = new PVector(10, 0);
      break;
    case 3:
      vel = new PVector(0, 10);
      break;
    }
  }


  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  //le serpent bousge on la direction de vel
  void move() {


    moveCount+=1;
  
    leftToLive -=1;

    
    if (leftToLive < 0) {
      alive = false;
      return;
    }

    //mort si le serpant a tousans corps ou les bordurescher 
    if (gonnaDie(pos.x + vel.x, pos.y + vel.y)) {
      alive= false;
      return;
    }

    
    if (isTrapped()) {
      trapped = true;
      return;
    }

   
    if (pos.x + vel.x == food.pos.x && pos.y + vel.y == food.pos.y) {
      foodFound = true;
      return;
    }



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
    }    pos.add(vel);

    if (!seenFood && seeFood()) {
      seenFood = true;
      foodSeenAtCount = moveCount;
    }
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //augementer la taille du corps
  void grow() {
    temp = new PVector(pos.x, pos.y);
    tailPositions.add(temp);
    len +=1;
  }


  //---------------------------------------------------------------------------------------------------------------------------------------------------------  
  boolean seeFood() {
  PVector left = new PVector(pos.x-10, pos.y);
    PVector right = new PVector(pos.x+10, pos.y);
    PVector up = new PVector(pos.x, pos.y-10);
    PVector down = new PVector(pos.x, pos.y+10);


    //regarder vers right ou left down et up pour trouver fruit
    while (!gonnaDie(left.x, left.y)) {
    
      if (left.x == food.pos.x && left.y == food.pos.y) {
        return true;
      }
  
      left.x-=10;
    }
  
    while (!gonnaDie(right.x, right.y)) {
      if (right.x == food.pos.x && right.y == food.pos.y) {
        return true;
      }
      right.x+=10;
    }


    while (!gonnaDie(up.x, up.y)) {
      if (up.x == food.pos.x && up.y == food.pos.y) {
        return true;
      }
      up.y -=10;
    }
 
    while (!gonnaDie(down.x, down.y)) {
      if (down.x == food.pos.x && down.y == food.pos.y) {
        return true;
      }
      down.y+=10;
    }

   
    return false;
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  //true si il touche sans corps ou bordures
  boolean gonnaDie(float x, float y) {
    //si il touche sans bordures
    if (x < 200 || y < 0 || x >= 1000 || y >= 800) {
      return true;
    }

    //si il touche sans corps 
    return isOnTail(x, y);
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------    

  boolean isOnTail(float x, float y) {
    for (int i = 0; i < tailPositions.size(); i++) {
      if (x == tailPositions.get(i).x &&  y == tailPositions.get(i).y) {
        return true;
      }
    }

    return false;
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  

  boolean isTrapped() {

    blanks = new ArrayList<PVector>();
    countNextTo(pos.x, pos.y);
    
    
    return (blanks.size() <= min((1600 - tailPositions.size())/2, 300));
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  
 
  void countNextTo(float x, float y) {
   
    if (blanks.size() <= min((1600 - tailPositions.size())/2, 300)) {
      temp = new PVector(x+10, y);
      
    //verifier les direction
      if (!gonnaDie(temp.x, temp.y) && !blanks.contains(temp)) {
        blanks.add(temp);
        countNextTo(temp.x, temp.y);
      }
      //look to the left
      temp = new PVector(x-10, y);
      if (!gonnaDie(temp.x, temp.y) && !blanks.contains(temp)) {
        blanks.add(temp);
        countNextTo(temp.x, temp.y);
      }
      //look down
      temp = new PVector(x, y+10);
      if (!gonnaDie(temp.x, temp.y) && !blanks.contains(temp)) {
        blanks.add(temp);
        countNextTo(temp.x, temp.y);
      }
      //look up
      temp = new PVector(x, y-10);
      if (!gonnaDie(temp.x, temp.y) && !blanks.contains(temp)) {
        blanks.add(temp);
        countNextTo(temp.x, temp.y);
      }
    }
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  

  //verifier 8 direction pour trouver les bordures ,fruit,corps
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

    //verifier si ya des vordures
    while (!(position.x < 200 || position.y < 0 || position.x >= 1000 || position.y >= 800)) {


      if (!foodIsFound && position.x == food.pos.x && position.y == food.pos.y) {
        visionInDirection[0] = 1;
        foodIsFound = true; 
      }

//verifier si il trouve
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
