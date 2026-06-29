

class Menuexit {

 
  PFont font = createFont("Arial", 40, true); // Etape 2 : Cree la police
  
  
  Menuexit() {
    
  }
  
  void drawit() {

         rectMode(CENTER);         
        stroke(255);
        fill(0);
        rect(500,320,400,90);
        fill(255);
        text("Recommencer", 500, 320);  
         textAlign(CENTER, CENTER);
     
        
        
        
        fill(0);
         stroke(255);
        rect(500,440,400,90);
        fill(255);
        textSize(30);
        text("Retourner au Menu Mode", 500, 440);
         textAlign(CENTER, CENTER);
              
        stroke(255);
        fill(0);
        rect(500,560,400,90);
        fill(255);
        text("Quitter", 500, 560);
         textAlign(CENTER, CENTER);
     
      


    
  }
void isInsideMenuexit(float posX, float posY){
    
    
    
  if(((posX>=500-200)&&( posX<=500+200))&&(( posY>=320-45)&&( posY<=320+45))){
        if(drawj==true){
                         j1=new joueur();
                         drawmenuexit=false;
                         drawgame=true;
                         move=false;
                         
        }
      if(drawjvsj==true){
    
                         j2=new joueurvsjoueur();
                         drawmenuexit=false;
                         drawgame=true;
                         move=false;
                 }
    if(drawauto==true){

                         j1=new joueur();
                         drawmenuexit=false;
                         move=false; 
                         drawgame=true;
                        
    
     }
   } 
   
   if(((posX>=500-200)&&( posX<=500+200))&&(( posY>=440-45)&&( posY<=440+45))){
         menumode=true;
         drawj=false;
         drawjvsj=false;
         drawauto=false;
         drawmenuexit=false;
         move=false;
   } 
    if(((posX>=500-200)&&( posX<=500+200))&&(( posY>=560-45)&&( posY<=560+45))){
          exit();
   } 
   
}}
