class Node{
int r=10;
int radius=width/30;
char type;
boolean starter;
ArrayList<Node> nodes2= new ArrayList<Node>();
PVector pos;
PVector vel;
float damp=0.1;
Node(char t, boolean s, ArrayList<Node> n){
 type=t; starter=s;  nodes2=n; int i=int(random(0,userPos.size())); pos= userPos.get(i);
 vel= new PVector(random(-5,5),random(-5,5)); r=int(random(2,10));
}

void display(){
 fill(255); noStroke();
 if(starter==true){r=width/50;}
 ellipse(pos.x,pos.y,r,r);
 pos.add(vel); vel.mult(1-damp);
 if(pos.x<0){vel.x=-vel.x; }
 if(pos.x>width){vel.x=-vel.x; }
 if(pos.y<0){vel.y=-vel.y;}
 if(pos.y>height){vel.y=-vel.y;}
 userAt();
}
void repulse(){
for (Node n: nodes2){
 Node oNode=n;
 if(oNode==null){break;}
 if(oNode==this){continue;}
 float d =PVector.dist(pos, n.pos);
 if(d>0&&d<radius){
 PVector df=PVector.sub(pos,n.pos);
 df.mult(0.4/d);
 vel.add(df);
 }
}
}

void userAt(){
   float dn=1000;
   //float xmax=0; float xmin=1000;
   //float ymax=0; float ymin=1000;
   PVector nearest=new PVector(0,0);
   //PVector handMin=new PVector(0,0);
   //PVector handMax=new PVector(0,0);
  for(PVector p:userPos){
    float d=sqrt(sq(pos.x-p.x)+sq(pos.y-p.y));
    if(d<dn){ dn=d; nearest=p; }
    //if(p.x>xmax){xmax=p.x; handMax=p;} if(p.x<xmin){xmin=p.x; handMin=p;}
    //if(p.y>ymax){ymax=p.y;} if(p.y<ymin){ymin=p.y;}
   }
   float dhMax =PVector.dist(pos, handMax);
   float dhMin =PVector.dist(pos, handMin);
   float dfMax =PVector.dist(pos, footMax);
   float dfMin =PVector.dist(pos, footMin);
   //float rel=(xmax-xmin)/(ymax-ymin);
 
  PVector dir=PVector.mult(PVector.sub(nearest,pos),1.5);
  vel.add(dir);
  if(rel>0.9){
   //if(dhMax<100){
     PVector dhmax=PVector.sub(handMax,pos);
     PVector dhmin=PVector.sub(handMin,pos);
     PVector dfmax=PVector.sub(footMax,pos);
     PVector dfmin=PVector.sub(footMin,pos);
     dhmax.mult(0.1/(dhMax*4));
     dhmin.mult(0.1/(dhMin*4));
     dfmax.mult(0.1/dfMax);
     dfmin.mult(0.1/dfMin);
     dhmax.mult(rel*15);
     dhmin.mult(rel*15);
     dfmax.mult(rel);
     dfmin.mult(rel*0.5);
     vel.add(dhmax);
     vel.add(dhmin);
     vel.add(dfmax);
     vel.add(dfmin);
     //println("wwwwww");
   }
  //}
}


}