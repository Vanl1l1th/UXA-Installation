import ddf.minim.*;
import mqtt.*;
MQTTClient client;
Minim minim;
//Audio player loads the sound on the fly. This is suitable for background music or longer audio clips
int mode=0;
ArrayList<AudioPlayer> sounds=new ArrayList<AudioPlayer>();
int n=9;
boolean start=false;
void setup() {
  size(600, 300);
  // sound init
  minim = new Minim(this);
  for(int i=0;i<n;i++){
    AudioPlayer p;
    p= minim.loadFile("soundFile"+i+".mp3");
   sounds.add(p); 
  }

  
  client = new MQTTClient(this);
  client.connect("mqtt://7b97772b:e0f7dff7fa444671@broker.shiftr.io");
  client.subscribe("/audio");
}

void draw() {
 switch(mode){
  case 0: if(start==true){sounds.get(mode).play(); }break;
  case 1: sounds.get(mode-1).pause(); sounds.get(mode).play(); break;
  case 2: sounds.get(mode-1).pause(); sounds.get(mode).play(); break;
  case 3: sounds.get(mode-1).pause(); sounds.get(mode).play(); break;
  case 4: sounds.get(mode-1).pause(); sounds.get(mode).play(); break;
  case 5: sounds.get(mode-1).pause(); sounds.get(mode).play(); break;
  case 6: sounds.get(mode-1).pause(); sounds.get(mode).play(); break;
  case 7: sounds.get(mode-1).pause(); sounds.get(mode).play(); break;
  case 8: sounds.get(mode-1).pause(); sounds.get(mode).play(); break;
 }
}

void mousePressed() {
  start=true;
}

void messageReceived(String topic, byte[] payload) {
  println("new message: " + topic + " - " + new String(payload));
  String st=new String(payload);
  if(st.length()==4){mode=0; start=false;
  for(AudioPlayer a: sounds){
  a.rewind();}}
  else{
  mode=Integer.parseInt(st);}
 
}