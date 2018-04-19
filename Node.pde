class Node{
int r=10;
int radius=150;
char type;
boolean starter;
ArrayList<Node> nodes2= new ArrayList<Node>();
PVector pos;
PVector vel;
float damp=0.1;
Node(char t, boolean s, ArrayList<Node> n){
 type=t; starter=s;  nodes2=n; pos= new PVector(random(10,width-10),random(10,height-10));
 vel= new PVector(random(-5,5),random(-5,5)); r=int(random(5,20));
}

void display(){
 fill(255); noStroke();
 if(starter==true){r=40;}
 ellipse(pos.x,pos.y,r,r);
 pos.add(vel); vel.mult(1-damp);
 if(pos.x<0){vel.x=-vel.x; }
 if(pos.x>width){vel.x=-vel.x; }
 if(pos.y<0){vel.y=-vel.y;}
 if(pos.y>height){vel.y=-vel.y;}
}
void repulse(){
for (Node n: nodes2){
 Node oNode=n;
 if(oNode==null){break;}
 if(oNode==this){continue;}
 float d =PVector.dist(pos, n.pos);
 if(d>0&&d<radius){
 PVector df=PVector.sub(pos,n.pos);
 df.mult(0.1/d);
 vel.add(df);
 }
}
}


}