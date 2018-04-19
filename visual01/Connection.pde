class Connection{
 Node fromNode;
 Node toNode;
 
 int distance=100;
 float stiff=0.6;
 float damp2=0.5;
 Connection(Node tNode, Node fNode){
  fromNode= fNode; toNode= tNode; 
 }
 void display(){
   stroke(255);
   strokeWeight(2);
  line(fromNode.pos.x,fromNode.pos.y,toNode.pos.x,toNode.pos.y);
 
 }
 
 void update(){
   PVector diff= PVector.sub(toNode.pos,fromNode.pos);
if(diff.mag()>10){
   diff.normalize();
   diff.mult(distance);
   PVector target= PVector.add(fromNode.pos, diff);
   PVector force= PVector.sub(target, toNode.pos);
   force.mult(0.5);
   force.mult(stiff);
   force.mult(1-damp2);
   toNode.vel.add(force);
   
   force.mult(-1);
   fromNode.vel.add(force);}}
   
   void setdist(int d){distance=d;}
 
}
