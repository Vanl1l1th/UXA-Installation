class Connection{
 Node fromNode;
 Node toNode;
 
 int distance=width/25;
 float stiff=0.6;
 float damp2=0.5;
 boolean subcon=true;
 Connection(Node tNode, Node fNode){
  fromNode= fNode; toNode= tNode; int i=int(random(22,26)); distance=width/i; 
 }
 void display(){
   stroke(255);
   strokeWeight(width/642);
  line(fromNode.pos.x,fromNode.pos.y,toNode.pos.x,toNode.pos.y);
 
 }
 
 void update(){if(subcon==true){
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
   fromNode.vel.add(force);}}}
   
   
 
}
