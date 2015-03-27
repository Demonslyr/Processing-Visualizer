import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput Audin;
AudioInput Beatin;
BeatDetect beat;
FFT fft;

int tick =1;
int g;
int draw=0;
float hn, ho, k;
float update = 1;//was originally 0.1
float updatec = 1;//was originally 0.1

bar[]  bar= new bar[50];
dot[]  dot= new dot[150];
smoke[]  smoke= new smoke[150];
float[] freq= {1,3,5,10,16,22,26,31,39,42,45,55,60,65,70,80,90,100,120,140,160,200,240,280,320,400,480,560,590,640,720,800,960,1024,1120,1280,1600,1920,2240,2560,3200,3340,3590,3720,3840,4480,5120,6400,7680,8960,10240,12800,15360,15360,15360,17800}; 

void setup() {
  frameRate(240);
  minim = new Minim(this);
  Audin = minim.getLineIn(Minim.MONO, 4096);
  fft = new FFT(Audin.bufferSize(), Audin.sampleRate());
  size(800, 300);

 for(int i=0; i<50; i++){
   bar[i] = new bar((i*11)+(i*2)+100,200,800);
   dot[i] = new dot();
   dot[i+50] = new dot();
   //dot[i+100] = new dot();

 }
  // a beat detection object song SOUND_ENERGY mode with a sensitivity of 10 milliseconds
  beat = new BeatDetect();
}
void draw() {
  
  fft.forward(Audin.mix);
  tick=1;
  /*
  //update and updatec are the rates of change of theta in the sine functions controlling the fill color
  update += 0.02;
  update = update%6.28;
  updatec -= 0.01;
  updatec = updatec%6.28;
  float ofst=0;*/
  int boom;
      beat.setSensitivity(20);
    beat.detect(Audin.mix);
    if ( beat.isOnset() ) {boom=10;}
    else{boom=0;}
  if(tick==1){
      clear();
      float band =0;
      float bandv=0;
    for(int i=0;i<100;i++){
      //below draws the dots two at a time to keep the 100 dots in the same loop as the bars
       //smoke[i].draws();
      dot[i].drawd();
     }
    for(g=0,k=0;g<50;g++,k++){
            //below draws the dots two at a time to keep the 100 dots in the same loop as the bars
      //below handls the color cycle the decimal is the speed at which theta changes
       fill(abs(int(127*sin((updatec+(g*0.02)%6.28))+128)),abs(int(127*sin((updatec+((g*0.02)+2)%6.28))+128)),abs(int(127*sin((updatec+((g*0.02)+4)%6.28))+128)));
     //below is for drawing the abrs
       strokeWeight(0);
       //  noStroke();
       
       //bar[g].drawr((18.2378*((0.017453)*atan(10*(((fft.getFreq(freq[g+1])+(2*fft.getFreq(freq[g+2]))+fft.getFreq(freq[g+3]))/4)-0.570896))+0.027416))*10, boom);
       bar[g].drawr(sqrt(((fft.getFreq(freq[g+1])+(2*fft.getFreq(freq[g+2]))+fft.getFreq(freq[g+3])))/4)*15*((k/25)+0.8), boom);
      /*
      //the code below is for drawing a line below the bars with a gradient color in phase with the bar color
       for(int j=0; j<2; j++){
        //stroke(abs(int(127*sin((updatec+(i*0.02)%6.28))+128)),abs(int(127*sin((updatec+((i*0.02)+2)%6.28))+128)),abs(int(127*sin((updatec+((i*0.02)+4)%6.28))+128)));
         stroke(245);
         strokeWeight(3);
         line(65+(7*((i*2)-j)), 253, 65+(7*((i*2)-j+1)), 253);
       }*/
    }
          stroke(0);
         strokeWeight(10);
         line(65, 247, 765, 247);
          stroke(245);
         strokeWeight(3);
         line(65, 246, 765, 246);
  }
}
class dot{
  
int divisor;
float xloc, yloc, diam, delx, dely, trans;
  
  dot(){
  divisor =75;
  trans= random(100, 255);
  xloc=random(0, 800);
  yloc=random(300);
  diam=(random(1,12));
  if (diam<7){diam=1;}
  else if(diam<11){diam=2;}
  else {diam=3;}
  delx =(random(1,3)/divisor)*3;
  dely =((random(0,6)-3)/divisor);
  }
  
 void drawd(){fill(245,245,245,int(trans));
    noStroke();
    ellipse(int(xloc), int(yloc), int(diam), int(diam));
    if (xloc > 800){xloc =0;}
    else {xloc = xloc + delx;}
    if (yloc > 300){yloc =0;}
    else if(yloc < 0){yloc = 300;}
    else {yloc = yloc + dely;}
  }
}


class smoke{

float ttl;
int divisor;
float xloc, yloc, diam, delx, dely, trans;
  
  smoke(){
    ttl = random(300-1000);
  divisor =75;
  trans= random(1,65);
  xloc=random(0, 800);
  yloc=random(300);
  diam=(random(10,200));
  delx =(random(1,3)/divisor)*3;
  dely =((random(0,2)-1)/divisor);
  }
  
 void draws(){fill(245,245,245,int(trans));
    noStroke();
    ellipse(int(xloc), int(yloc), int(diam), int(diam));
    if (xloc > 800){xloc =0;}
    else {xloc = xloc + delx;}
    if (yloc > 300){yloc =0;}
    else if(yloc < 0){yloc = 300;}
    else {yloc = yloc + dely;}
}
}


class bar{
  int xloc, yloc, maxh, minh, c;
  float hn, ho, y;
  bar(float x, int h, int w){
  xloc=floor(x);
  yloc=250;
  maxh=h;
  minh=yloc;
  c=0;
  ho=0;
  }
void drawr(float hn, int beat){
  if(hn>(ho*2.5)&&ho<maxh){
    y=ho+beat;
   ho=(ho+(0.01*hn)+beat);//was 0.01
    stroke(0);  
    rect(xloc, yloc, 11, int(-y));
    noStroke();
    ellipse(xloc+6, int(-y)+yloc, 10, 5);
    stroke(0);
    }
  else{ 
    if(ho<6){
      ho=6;
    } 
    else{      y=(ho); 
      ho=(ho-(0.015*ho));//was 0.015
    }
    stroke(0);
    rect(xloc, yloc, 11, int(-y));
    noStroke();
    ellipse(xloc+6, int(-y)+yloc, 10, 5);
    stroke(0);}
  }

}
