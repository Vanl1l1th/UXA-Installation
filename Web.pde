class Web{
 Node n;
  PVector anker;
  Web(Node ni){
  n=ni; float x=random(0,1); float y=0;
  if(x<0.25){x=width; y=random(0,height);}else if(x<0.5){x=0; y=random(0,height);}
  else if(x<0.75){y=height; x=random(0,width);}else{y=0; x=random(0,width);}
  anker=new PVector(x,y);
  }
  void display(){
   fill(255);
   strokeWeight(width/642);
   line(n.pos.x,n.pos.y,anker.x,anker.y);
  }
}