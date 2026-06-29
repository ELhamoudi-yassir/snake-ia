/****************** déclaration ****************************/
class joueur{
int lon_corps=3; 
Corps [] corps= new Corps[100000];
String direction="DOWN" ;
tete ts = new tete(); 

boolean fin=false;
int score=0;
boolean retour = false;
int level =10;

/************** les classes ***********************************/

class tete{
int posx_t ,posy_t;
public tete(){
  posx_t=400;
  posy_t=300;
}
}
class Corps {
  int x = 0;
  int y = 0;
  public Corps(int _x, int _y) {
    x = _x;
    y = _y;
  }
  
}



/************************************ setUp****************************/

joueur(){



corps[0] = new Corps(ts.posx_t-10,ts.posy_t);
corps[1] = new Corps(ts.posx_t-20, ts.posy_t);
corps[2] = new Corps(ts.posx_t-30, ts.posy_t);
  textFont(createFont("Arial", 60));

  

}
/*************************************************/
void drawit(){
   frameRate(10);
 
  // les lignes 
/*for(int i=0;i<600;i+=10){
  stroke(255);
  line(i,0,i,600);
  line(0,i,600,i);
}*/

// tete de serpent

fill(255);
 stroke(0);
rect(ts.posx_t,ts.posy_t,10,10);

// corps
fill(255);
  for (int i = 0; i < lon_corps; i++) {
     stroke(0);
    rect(corps[i].x, corps[i].y,10,10);
    if(corps[i].x == ts.posx_t && corps[i].y == ts.posy_t) fin = true;

    
  }
 

}
void direction(){
 if(direction.equals("UP")) ts.posy_t=ts.posy_t-10;
 if(direction.equals("DOWN")) ts.posy_t=ts.posy_t+10;
 if(direction.equals("LEFT")) ts.posx_t=ts.posx_t-10;
 if(direction.equals("RIGHT")) ts.posx_t=ts.posx_t+10;
 
}
void move(){
  // si le serpent mange le fruit 
  if(drawj){
if((ts.posx_t>=fruit.pos.x-5) && (ts.posx_t<=fruit.pos.x+5)&& (ts.posy_t>=fruit.pos.y-5)&&(ts.posy_t<=fruit.pos.y+5)) {
    fruit = new Food(); 
    score++;
    corps [lon_corps]=new Corps(corps[lon_corps-1].x,corps[lon_corps-1].y);
    lon_corps++;
 }}else{
 if((ts.posx_t>=world.fusedSnake.fruit.pos.x-5) && (ts.posx_t<=world.fusedSnake.fruit.pos.x+5)&& (ts.posy_t>=world.fusedSnake.fruit.pos.y-5)&&(ts.posy_t<=world.fusedSnake.fruit.pos.y+5)) {
    world.fusedSnake.fruit = new Food(); 
    score++;
    corps [lon_corps]=new Corps(corps[lon_corps-1].x,corps[lon_corps-1].y);
    lon_corps++;
 }
 
 }
 
  //movement du serpent
if(!fin){  
 for(int i=lon_corps-1;i>0;i--){
 corps[i].x=corps[i-1].x;
 corps[i].y=corps[i-1].y;
 }
 corps[0].x=ts.posx_t;
 corps[0].y=ts.posy_t;
direction();
  

 //Fin de jeu
 
 if(ts.posx_t<=200+5 || ts.posx_t>=width-5 || ts.posy_t<=5 || ts.posy_t>=height-5) fin=true;
 if(drawauto==true) if(world.fusedSnake.isOnTail(ts.posx_t, ts.posy_t)==true) fin=true;

 
  fill(255);
  textSize(30);
    text("Score joueur ",100, 150);
  text(+score,100, 200);

}
else{
    fill(0);
    rectMode(CORNER);
    rect(0, 0, 1000, 800);
    fill(255);
    textSize(60);
    text("FIN DE JEU ", width/2, 300);
    text("Ton score :  "+score, width/2,400);
  }
retour=false; 
if (score==3) level =11;
if (score==5) level =12;
if (score==13) level =15;
}}
