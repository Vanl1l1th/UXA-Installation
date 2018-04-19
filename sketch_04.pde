String input= "";
char letter;
ArrayList<Node> nodes= new ArrayList<Node>();
ArrayList<Connection> con= new ArrayList<Connection>();
Node pnode=null;
void setup(){
  fullScreen(); 
}
void draw(){
  background(0);
  fill(255);
 textSize(20);
 text(input,100,100);
 for(Node n: nodes){
  n.display();
  n.repulse();
 }
 for(Connection c: con){
  c.display(); c.update();
 }
 
}


void readInput(){
 
 boolean starter2=false;
 Node sNode=null;
 char c=letter;
 for(Node n: nodes){
   if(n.starter==true&&n.type==c){
 starter2=true; sNode=n;}
 }
 if(starter2==true){nodes.add(new Node(c,false,nodes)); con.add(new Connection(sNode,nodes.get(nodes.size()-1)));
 nodes.add(new Node(c,false,nodes)); con.add(new Connection(sNode,nodes.get(nodes.size()-1)));
 nodes.add(new Node(c,false,nodes)); con.add(new Connection(sNode,nodes.get(nodes.size()-1)));}
 else{nodes.add(new Node(c,true,nodes));}
 if(pnode!=null){con.add(new Connection(pnode,nodes.get(nodes.size()-1))); con.get(con.size()-1).setdist(250);}
 pnode=nodes.get(nodes.size()-1);
 
 println(con.size());
}
void keyPressed(){
  if(key==BACKSPACE){
  if(input.length()>1){
  int j=input.length()-1;
  input=input.substring(0,j);
  int l=nodes.size()-1; int m=con.size()-1;
  if(nodes.get(l).starter==true){
  nodes.remove(l); con.remove(m); pnode=nodes.get(nodes.size()-1);}
  else{nodes.remove(l); nodes.remove(l-1); nodes.remove(l-2);
       con.remove(m); con.remove(m-1); con.remove(m-2); con.remove(m-3);
       pnode=nodes.get(nodes.size()-1);}
}
else{con.clear(); nodes.clear(); pnode=null; input="";}
}
  else{
 char k=key; 
 input+=k;
 letter=k;
 readInput();}
 
}
void mousePressed(){
 nodes.get(nodes.size()-1).vel= new PVector(random(-25,25),random(-25,25)); 
}