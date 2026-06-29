//variables  globale
import java.io.File;
//declaration des objets
World world;
Menu menu;
Menuexit menuexit;
joueur j1;
joueurvsjoueur j2;
World worldOfLegends;
int Timegover;
//boolean pour gerer le jeux
boolean drawgame=false;//afficher le jeu
boolean drawj=false;//afficher un seul joueur
boolean drawjvsj=false;//afficher joueur vs joueur
boolean drawauto=false;//afficher joueur vs auto
boolean menumode=true;//afficher le menu mode
boolean drawmenuexit=false;//afficher le menu exit
int speed = 10;//vitesse de serpant automatique
boolean move=false;//si on peux bouger
boolean trainLegendSnakes = false;
boolean fusionGo =false;
Food fruit;
String level="Facile";//le niveau de jeux
float globalMutationRate = 0.01;

//---------------------------------------------------------------------------------------------------------------------------------------------------------  

void setup() {
  frameRate(speed);

  size(1000, 800);
  // Construction de lobjet world et lInitialiser
  world = new World(5, 2000);
  // Construction de lobjet MEnu et lInitialiser
  menu =new Menu();
  menuexit=new Menuexit();
  // Construction de lobjet joueur et lInitialiser
  j1=new joueur();
  j2=new joueurvsjoueur();
  // Construction de lobjet fruit et lInitialiser
  fruit=new Food();
  // crere un font
   textFont(createFont("Arial", 50));
  
}
//---------------------------------------------------------------------------------------------------------------------------------------------------------  
void draw() {
  background(0);


  if(drawauto==true){

    // tester si on doit afficher le serpant auto  
 if (fusionGo) {
    if (world.fusedSnake.alive) {
      world.updateSuperSnake();
    } else { //once done set the fusionGo to false
      fusionGo = false;
    }


    //training/evolving population normally
  } else {
    if (!world.done()) {//if there is still a snake alive then update them
      world.updateAlive();
    } else {//if all are dead :(
      world.geneticAlgorithm();
    } 
  }
  
  


  } 
  // tester si on doit afficher le menu mode
    if(menumode==true){
  menu.drawit();
  
  }
 
// tester si on doit afficher le menu exit
if(drawmenuexit==true)menuexit.drawit();
// tester si on doit afficher le jeux 
if(drawgame==true){
  
    if((j2.fin1==false && j2.fin2==false) || j1.fin==false){
     fill(255);
     stroke(255);
     line(200,0,200,800);
     
  }
  // tester si on doit afficher le jeu joueur seul
  if(drawj==true){
    drawgame=true;

  j1.drawit();
    fruit.show();
  if(move==true){
   
    j1.move();
 }
 

  }
  // tester si on doit afficher le joueur vs joueur
  if(drawjvsj==true){

    drawgame=true;
    j2.drawit();
    fruit.show();
    if(move==true){
     j2.move();
 }
 
   


  }
  // tester si on doit afficher lejoueur vs auto
 if(drawauto==true){

 drawgame=true;
 // si le score du joueur plus de 100 change le niveau et la vitesse
 if(j1.score==100){
  level="Moyen";
  speed=20;
 }
 // si le score du joueur plus de 300 change le niveau et la vitesse
 if(j1.score==300){
 level="Difficile";
  speed=30;
 }
  // tester si on doit bouger
 if(move==true){
    j1.drawit();
    j1.move();
    if(j1.fin==false){
    textSize(30);
    text("Level ",100, 550);
    text(level,100, 600);
 }}
 } 
 
 if(move==false){  
   fill(255,0,0);
   textSize(30);
   text("veuillez appuyer sur « espace» pour espace pour commencer ",500, height/2);
}



}
if((j2.fin1 && j2.fin2) || j1.fin){
  
  
  Timegover=10000;
     //apres 20s 
     if(millis()>=Timegover){
       //On quite le programme
                        exit();
                          }
}



}
//---------------------------------------------------------------------------------------------------------------------------------------------------------  


   





void mousePressed() {
  // tester si on a appuyer avec la souri sur le menu  
  if ( mousePressed==true ) {
        if(menumode==true){
         menu.isInsideMenu(mouseX,mouseY);
                         }
       if (drawmenuexit==true){
        menuexit.isInsideMenuexit(mouseX,mouseY);
                         }
}
  

}
    
    
 void keyPressed(){
   
if(drawj==true || drawauto==true){
// tester si le jeux pas fini
if(!j1.fin && !j1.retour){ 
  
  if (key == CODED){
    // tester si la boutton toucher et changer la direction
      if ((keyCode == UP) && (j1.direction.equals("LEFT") || j1.direction.equals("RIGHT"))) j1.direction="UP";
      else if ((keyCode == DOWN) && (j1.direction.equals("LEFT") ||  j1.direction.equals("RIGHT"))) j1.direction="DOWN";
      else if ((keyCode == LEFT) && (j1.direction.equals("UP") ||  j1.direction.equals("DOWN"))) j1.direction="LEFT";
      else if ((keyCode == RIGHT) && (j1.direction.equals("UP") ||  j1.direction.equals("DOWN"))) j1.direction="RIGHT";
  }
}
}
   
  
if(drawjvsj==true){
if(!j2.fin1 || !j2.fin2){  
  // tester si le joueur2 est vivre 
if(!j2.fin1){
if (key == CODED) {
    // tester si la boutton toucher et changer la direction du joueur1
  if ((keyCode == UP) && (j2.direction1.equals("LEFT") ||  j2.direction1.equals("RIGHT"))) j2.direction1="UP";
      else if ((keyCode == DOWN) && (j2.direction1.equals("LEFT") ||  j2.direction1.equals("RIGHT"))) j2.direction1="DOWN";
      else if ((keyCode == LEFT) && (j2.direction1.equals("UP") ||  j2.direction1.equals("DOWN"))) j2.direction1="LEFT";
      else if ((keyCode == RIGHT) && (j2.direction1.equals("UP") ||  j2.direction1.equals("DOWN")))j2.direction1="RIGHT";
} }
  // tester si le joueur1 est vivre
  if(!j2.fin2){
      // tester si la boutton toucher et changer la direction du joueur2
       if ((key == 122 ) && (j2.direction2=='q' || j2.direction2=='d')) j2.direction2='z' ;
      else if ((key ==113) && (j2.direction2=='z' || j2.direction2=='s')) j2.direction2='q' ;
      else if ((key ==115) && (j2.direction2=='q' || j2.direction2=='d')) j2.direction2='s' ;
      else if ((key ==100) && (j2.direction2=='z' || j2.direction2=='s')) j2.direction2='d' ;

}}
}
//verification si la button toucher est ECHAP
  if (keyCode == 27){
           key = 0;
if(drawgame==true){
    //changer le variable vers true pour designer le menu exit
    drawmenuexit=true;
      //changer le variable vers false pour effacer le jeux
    drawgame=false;
    fusionGo  = false;
       }
  }
  //verification si la button toucher est Espace
     if (keyCode == 32){
         
          //changer le variable vers true pour que les serpent peuve bouger
          move = true;
          
          if(drawauto==true){
         world.snakeFusion();
         fusionGo  = true;
          }
  
               
    
       }
   
   

}
