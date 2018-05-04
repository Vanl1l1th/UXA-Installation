import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import mqtt.*;
MQTTClient client;

Kinect kinect;
PFont myFont;
int minDepth =  60;
int maxDepth = 940;
int cO=0;
int op=0;
boolean end=false;
boolean nam=false;
boolean mir=false;
ArrayList <PVector> userPos;
String input= "";
String trans= "";
String name= "";
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
float xu=0;
int counter2=0;
void setup() {
  //size(640, 480);
  fullScreen();
  kinect = new Kinect(this);
  kinect.initDepth();
  userPos=new ArrayList<PVector>();
  myFont = createFont("MingLiU",height/20);
  
  client = new MQTTClient(this);
  client.connect("mqtt://bff8033f:ad10caddad95db25@broker.shiftr.io");
  client.subscribe("/kinect");
  client.subscribe("/name");
}

void draw() {
userPos.clear();
//println(userPos.size());
userDet();
//background(0);
println(xu);
if(nodes.size()>0){//if(mir==true){pushMatrix();translate(xu,0);}
 for(Node n: nodes){
  n.display();
  n.repulse();
 }
 for(Connection c: con){
  c.display(); c.update();
 }//if(mir==true){popMatrix();}
 for(Web w:webs){w.display();} 
 if(end==true){textSize(height/20);
 textFont(myFont);
 textAlign(CENTER);
 rectMode(CENTER); 
 text(trans,width/2,height/2);
 text(name,width/2,(height/2)+(height/19));
 mir=true;}

 }
 else{fill(255); 
 textFont(myFont);
 rectMode(CENTER);
 textAlign(CENTER);
 textSize(height/10);
 text("Welcome!",width/2,height/2); mir=false;}
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
     pixels[ir] = color(c); xu=x;}else{pixels[ir]=color(0);}//if(frameCount%10==0){if(cO==0){op++;}if(cO==1){op--;}}if(op>255){cO=1;}if(op<10){cO=0;}}
     
     PVector p=new PVector(xr,y);if(mir==true){p=new PVector(x,y);} userPos.add(p);
     if(minx>x){minx=x; handMin=p;} if(maxx<x){maxx=x; handMax=p;}
     if(miny>y){miny=y; footMin=p;} if(maxy<y){maxy=y; footMax=p;}    } else{pixels[ir]=color(0);}//if(frameCount%10==0){if(cO==0){op++;}if(cO==1){op--;}}if(op>255){cO=1;}if(op<10){cO=0;}}
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
  //println("new message: " + topic + " - " + new String(payload));
  String st=new String(payload);
  char s=topic.charAt(1);
  if(s=='n'){name=st;}
  else if(s=='k'){
  if(st.length()==4){nodes.clear(); webs.clear(); con.clear(); end=false;}
  else if(st.length()==1){
  letter=st.charAt(0);
  readInput();}
  else{ trans=st; end=true; nam=false;}}
}
