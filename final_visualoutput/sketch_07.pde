import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import mqtt.*;
MQTTClient client;

Kinect kinect;

int minDepth =  60;
int maxDepth = 885;
boolean end=false;
ArrayList <PVector> userPos;
String input= "";
String trans= "";
char letter;
ArrayList<Node> nodes= new ArrayList<Node>();
ArrayList<Connection> con= new ArrayList<Connection>();
ArrayList<Web> webs= new ArrayList<Web>();
Node pnode=null;
PVector handMin=new PVector(0,0);
PVector handMax=new PVector(0,0);
PVector footMin=new PVector(0,0);
PVector footMax=new PVector(0,0);
float rel;
int counter2=0;
void setup() {
  size(640, 480);
  //fullScreen();
  kinect = new Kinect(this);
  kinect.initDepth();
  userPos=new ArrayList<PVector>();
  
  client = new MQTTClient(this);
  client.connect("your connectioncode goes in there");
  client.subscribe("/kinect");
}

void draw() {
userPos.clear();
//println(userPos.size());
userDet();
//background(0);
//println(userPos.size());
if(nodes.size()>0){
 for(Node n: nodes){
  n.display();
  n.repulse();
 }
 for(Connection c: con){
  c.display(); c.update();
 }
 for(Web w:webs){w.display();}
 if(end==true){textSize(height/20);
 rectMode(CENTER); 
 text(trans,width/4,height/2);}
 }
 else{fill(255); textSize(height/10);
 rectMode(CENTER); 
 text("Welcome!",width/4,height/2);}
}

void userDet(){
  loadPixels();
  int counter=0;
float minx=1000; float maxx=0; float miny=1000; float maxy=0; 
  int[] rawDepth = kinect.getRawDepth();
  for (int i=0; i < rawDepth.length; i++) {
    float x=i%640; float y=(i-x)/640; float xr=640-x-1;
     int ir=int(xr+(640*y));
    if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) {
     if(counter%10==0){int c=150;
     pixels[ir] = color(c);}else{pixels[ir]=color(0);}
     
     PVector p=new PVector(xr,y); userPos.add(p);
     if(minx>x){minx=x; handMin=p;} if(maxx<x){maxx=x; handMax=p;}
     if(miny>y){miny=y; footMin=p;} if(maxy<y){maxy=y; footMax=p;}    } else{pixels[ir]=color(0);}
  counter++;}
 rel=(maxx-minx)/(maxy-miny);
 //println(rel);
 updatePixels();
}
  
  void readInput(){
 
 boolean starter2=false;
 Node sNode=null;
 char c=letter;
 for(Node n: nodes){
   if(n.starter==true&&n.type==c){
 starter2=true; sNode=n;}
 }
 if(starter2==true){
 nodes.add(new Node(c,false,nodes)); con.add(new Connection(sNode,nodes.get(nodes.size()-1)));
 nodes.add(new Node(c,false,nodes)); con.add(new Connection(sNode,nodes.get(nodes.size()-1)));
 nodes.add(new Node(c,false,nodes)); con.add(new Connection(sNode,nodes.get(nodes.size()-1)));}
 else{nodes.add(new Node(c,true,nodes));}
 if(pnode!=null){con.add(new Connection(pnode,nodes.get(nodes.size()-1))); con.get(con.size()-1).subcon=false;}
 pnode=nodes.get(nodes.size()-1);
 if(counter2%6==0){
 webs.add(new Web(pnode));} counter2++;
 //println(con.size());
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

void messageReceived(String topic, byte[] payload) {
  println("new message: " + topic + " - " + new String(payload));
  String st=new String(payload);
  if(st.length()==4){nodes.clear(); webs.clear(); con.clear(); end=false;}
  else if(st.length()==1){
  letter=st.charAt(0);
  readInput();}
  else{ trans=st; end=true;}
}
