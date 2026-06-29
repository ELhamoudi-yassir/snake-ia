

class Menu {

  PImage logo;
  PFont font = createFont("Arial", 40, true); // Etape 2 : Cree la police
  
  
  Menu() {
    
  }
  
  void drawit() {
    
    logo = loadImage("image/logo2.png");
       rectMode(CENTER);
       textFont(font,26);
       stroke(255);
                  
        stroke(255);
        fill(0);
        rect(500,320,400,90);
        fill(255);
        text("Joueur", 500, 320);  
         textAlign(CENTER, CENTER);
     
        
        
        
        fill(0);
           stroke(255);
        rect(500,440,400,90);
        fill(255);
        text("Joueur vs Joueur ", 500, 440);
         textAlign(CENTER, CENTER);
              
        stroke(255);
        fill(0);
        rect(500,560,400,90);
        fill(255);
        text("Joueur vs Ordinateur", 500, 560);
         textAlign(CENTER, CENTER);
     
      

   image(logo,300,80);
    
  }
void isInsideMenu(float posX, float posY){
    
    
    
  if(((posX>=500-200)&&( posX<=500+200))&&(( posY>=320-45)&&( posY<=320+45))){
           drawgame=true;
         
           drawj=true;
           menumode=false;
      
   } 
   
   if(((posX>=500-200)&&( posX<=500+200))&&(( posY>=440-45)&&( posY<=440+45))){
          drawgame=true;
          drawjvsj=true;
          menumode=false;
   } 
    if(((posX>=500-200)&&( posX<=500+200))&&(( posY>=560-45)&&( posY<=560+45))){
           drawgame=true;
          drawauto=true;
          menumode=false;
   } 
   
}}
