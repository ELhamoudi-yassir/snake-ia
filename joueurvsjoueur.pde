/********** Les classes **************/
class joueurvsjoueur{
class Tete {
int x,y ;
public Tete (int _x,int _y) {
  this.x=_x ;
  this.y=_y ;
}
}
class Corps {
int x,y ;
public Corps (int _x,int _y){
  this.x=_x ;
  this.y=_y ;
}
}
class Fruit {
  int x,y ;
  public Fruit (int _x,int _y){
  this.x=_x ;
  this.y=_y ;
}
}
/*************** Déclarations **************/
int longeur1=3 ;
int longeur2=3 ;
Corps [] corps1=new Corps[100000] ;
Corps [] corps2=new Corps[100000] ;
Tete tete1=new Tete(300,500);
Tete tete2=new Tete (600,100) ;
String direction1="UP";
char  direction2='s';
boolean fin1=false;
boolean fin2=false;
int score1=0;
int score2=0;

/*************** setup ****************************/
joueurvsjoueur(){

frameRate(10);
corps1[0]=new Corps(tete1.x,tete1.y+10); 
corps1[1]=new Corps(tete1.x,tete1.y+20); 
corps1[2]=new Corps(tete1.x,tete1.y+30); 

corps2[0]=new Corps(tete2.x,tete2.y-10); 
corps2[1]=new Corps(tete2.x,tete2.y-20); 
corps2[2]=new Corps(tete2.x,tete2.y-30); 

 textFont(createFont("Arial", 40));

}
/************** draw ******************************/
void drawit(){

// tete 1 
fill(0,255,0);
 stroke(0);
rect(tete1.x,tete1.y,10,10);

// tete 2 
fill(0,0,255);
 stroke(0);
rect(tete2.x,tete2.y,10,10);

// corps 1
fill(0,255,0);
 stroke(0);
for(int u=0; u<longeur1;u++){
  rect(corps1[u].x,corps1[u].y,10,10);
  if(corps1[u].x == tete1.x && corps1[u].y == tete1.y) fin1 = true;
  if(corps1[u].x == tete2.x && corps1[u].y == tete2.y) fin2 = true;//collision 
}
//corps2
fill(0,0,255);
 stroke(0);
for(int i=0;i<longeur2;i++){
rect(corps2[i].x,corps2[i].y,10,10);
if(corps2[i].x == tete2.x && corps2[i].y == tete2.y) fin2 = true;
if(corps2[i].x == tete1.x && corps2[i].y == tete1.y) fin1 = true;//collision
}

}
void move(){
// Un des serpents mange le fruit 
if ((tete1.x>=fruit.pos.x-6) && (tete1.x<=fruit.pos.x+6)&& (tete1.y>=fruit.pos.y-6)&&(tete1.y<=fruit.pos.y+6)) {
  fruit = new Food(); 
   score1++;
   corps1 [longeur1]=new Corps(corps1[longeur1-1].x,corps1[longeur1-1].y);
   longeur1++;
}
if ((tete2.x>=fruit.pos.x-5) && (tete2.x<=fruit.pos.x+5)&& (tete2.y>=fruit.pos.y-5)&&(tete2.y<=fruit.pos.y+5)) {
   fruit = new Food(); 
   score2++;
   corps2[longeur2]=new Corps(corps2[longeur2-1].x,corps2[longeur2-1].y);
   longeur2++;
}

//affichage de score à l'écran 
fill(0,255,0);
 textSize(30);
text("Joueur1", 100, 150);
text(score1, 100, 200);
fill(0,0,255);
 textSize(30);
text("Joueur2 " ,100, 400);
text(score2 , 100, 450);
// movement 
  // serpent2
 if(!fin1 || !fin2){
if(!fin2){
for(int j=longeur2-1;j>0;j--){
corps2[j].x=corps2[j-1].x;
 corps2[j].y=corps2[j-1].y;
}
corps2[0].x=tete2.x;
corps2[0].y=tete2.y;

if(direction2=='z') tete2.y=tete2.y-10 ;
if(direction2=='s') tete2.y=tete2.y+10 ;
if(direction2=='q') tete2.x=tete2.x-10 ;
if(direction2=='d') tete2.x=tete2.x+10 ;}
  //serpent1
  if(!fin1){
 for(int i=longeur1-1;i>0;i--){
 corps1[i].x=corps1[i-1].x;
 corps1[i].y=corps1[i-1].y;
 }
 corps1[0].x=tete1.x;
 corps1[0].y=tete1.y;
  
 if(direction1.equals("UP")) tete1.y=tete1.y-10;
 if(direction1.equals("DOWN")) tete1.y=tete1.y+10;
 if(direction1.equals("LEFT")) tete1.x=tete1.x-10;
 if(direction1.equals("RIGHT")) tete1.x=tete1.x+10;}
 // colision avec les bordures
 if(tete1.x==200 || tete1.x==width-10 || tete1.y==0 || tete1.y==height-10) fin1=true;
 if(tete2.x==200|| tete2.x==width-10 || tete2.y==0 || tete2.y==height-10) fin2=true;
 
 }else{
    fill(0); 
    rectMode(CORNER);
    rect(0, 0, 1000, 800);
    fill(255);
    textSize(60);
    text("FIN DE JEU ", width/2,250);
    text("score de joueur 1 :  "+score1, width/2, 350);
    text("score de joueur 2 :  "+score2, width/2, 430);
  }


}


}
