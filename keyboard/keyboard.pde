import g4p_controls.*;
import processing.serial.*;
import java.util.*;

int lastStepTime = 0;

Serial myPort;
String val;    
Vector<Integer> firstval = new Vector<Integer>();
int dir = 0;

int up = 1;
int down = 2;
int right = 3;
int left = 4;

int name_ok = 0;
String name;
int bio_inserted = 0;

boolean found = false;

int points = 0;
int time = 60;
float time_init = 0;
float time_old = 0;
float time_now = 0;
int initTimer = 0;
int get60Sec = 0;
int points_old = 0;
int record = 0;
int flag_record = 0;

int number_old = 0;
int number = 0;
char letter;
char[][] alphabet = {{'q','w','e','r','t','y','u','i','o','p'}, {'a','s','d','f','g','h','j','k','l'}, {'z','x','c','v','b','n','m',' '}, {' '}};
int row = 0;
int column = 0;
int init = 0;
String sentence = "";
String sentence_old = "";
int xpos = 195;
int ypos = 242;
int width_square = 30;

int finished = 0;

PImage bg;

public void setup(){
  size(800, 450, JAVA2D);
  
  createGUI();
  customGUI();
  bg = loadImage("background.png");
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 115200);
}

public void draw(){
  background(230);
  
  if(bio_inserted == 1){
    
    background(bg);
    fill(255);
    stroke(255);
    rect(630, 100, 50, 100);
    
    PImage keyboard = loadImage("keyboard.png");
    PImage square = loadImage("square.png");
    PImage send = loadImage("send.png");
    PImage sun = loadImage("sun.png");
    PImage dog = loadImage("dog.png");
    PImage grape = loadImage("grape.png");
    PImage car = loadImage("car.png");
    PImage sea = loadImage("sea.png");
    PImage pencil =loadImage("pencil.png");
    PImage ball = loadImage("ball.png");
    PImage apple = loadImage("apple.png");
    PImage bed = loadImage("bed.png");
    PImage score = loadImage("score.png");
    PImage clock = loadImage("clock.png");
    PImage yesno = loadImage("yesno.png");
    PImage win = loadImage("win.png");
    PImage good = loadImage("good job.png");
 
    fill(0); //text black
    textFont(createFont("calibri", 30));
    text("Word: " + sentence, 105, 160);
    
    textSize(25);
    text("Time: " + time + " s", 650, 30);
    
    if(initTimer == 0 && get60Sec == 0){
      time_init = millis();
      initTimer = 1;
    }
    
    if(initTimer == 1 && get60Sec == 0){
      time_now = millis();
      if(time_now-time_init > 1000){
        time -=1;
        initTimer = 0;
        if(time == 0){
          if(points > record){
            record = points;
            flag_record = 1;
          }
          get60Sec = 1;
        }
      }
    }
    
    if(get60Sec == 1){
      if(flag_record == 1){
        textSize(20);
        text("Well done!", 75, 23);
        text("You scored a new record!", 15, 40);
        image(good, 230, 1, 40, 40);
       }else{
         textSize(20);
         text("Record: " + record, 90, 40);
         image(win, 47, 15, 40, 40);
       }
      textSize(20);
      text("Do you want to play again?", 15, 67);
      image(yesno, 85, 70, 70, 70);
    }
    
    text("Score: " + points, 650, 70);
    
    image(clock, 604, 3, 40, 40);
    image(score, 605, 44, 40, 40);
    image(keyboard, 150, 200, 500, 200);
    image(square, xpos, ypos, width_square, 34);
    image(send, 625, 120, 55, 55);
    
    if(!found){
      number_old = number;
      number =  int(random(1, 10));
      while(number_old == number){
        number =  int(random(1, 10));
      }
      found = true;
    }
    
    if(number == 1){
      image(sun, 330, 5, 100, 100);
    }else if(number == 2){
      image(dog, 330, 5, 100, 100);
    }else if(number == 3){
      image(grape, 330, 5, 100, 100);
    }else if(number == 4){
      image(car, 330, 5, 100, 100);
    }else if(number == 5){
      image(sea, 330, 5, 100, 100);
    }else if(number == 6){
      image(pencil, 330, 5, 100, 100);
    }else if(number == 7){
      image(ball, 330, 5, 100, 100);
    }else if(number == 8){
      image(apple, 330, 5, 100, 100);
    } else if(number == 9){
      image(bed, 330, 5, 100, 100);
    }
    
    if (myPort.available() > 0) {
      val = myPort.readStringUntil('\n');
      if (millis() - lastStepTime > 200){
        if (val != null) {
          String[] arrOfStr = val.split(",");
          dir = Integer.parseInt(arrOfStr[0]);
          //println("dir: " + dir);
          lastStepTime = millis();
          if(dir == up){ 
            row -= 1;
            if(row != 2){
              xpos -= 10;
              ypos -= 41;
            }else{
              width_square = 30;
              xpos = 215;
              ypos -= 41;
            }
          }
          if(dir == down){ 
            row +=1;
            if(row !=3){
              xpos += 10;
              ypos += 41;
            }else{
              column = 0;
              width_square = 230;
              xpos = 280;
              ypos += 41;
            }
          }
          if(dir == right){ 
            xpos += 35;
            column += 1;
          } 
          if(dir == left){ 
            xpos -= 35;
            column -= 1;
          }
        }
      }
      if(dir == 7){
        if(row == 2 && column == 7){
          sentence = sentence_old;
        }else{
          letter = alphabet[row][column];
          sentence_old = sentence;
          sentence = sentence + letter;
          if(init == 0){
            sentence = sentence.toUpperCase();
            init = 1;
          }
        }
      }
      //println("Sentence old: " + sentence_old);
     //println("Sentence: " + sentence);
    }
    if(finished == 1){
      if(number == 1){
        if(sentence.equals("Sun")){
          points += 1;
          sentence = "";
          finished=0;
          found = false;
        }else{
          sentence = "";
          finished=0;
          found = false;
        }
      }
      if(number == 2){
        if(sentence.equals("Dog")){
          points += 1;
          sentence = "";
          finished=0;
          found = false;
        }else{
          sentence = "";
          finished=0;
          found = false;
        }
      }
      if(number == 3){
        if(sentence.equals("Grape")){
          points += 1;
          sentence = "";
          finished=0;
          found = false;
        }else{
          sentence = "";
          finished=0;
          found = false;
        }
      }
      if(number == 4){
        println("Sentence: " + sentence);
        if(sentence.equals("Car")){
          println("correct!");
          points += 1;
          sentence = "";
          finished=0;
          found = false;
        }else{
          println("error");
          sentence = "";
          finished=0;
          found = false;
        }
      }
      if(number == 5){
        println("Sentence: " + sentence);
        if(sentence.equals("Sea")){
          println("correct!");
          points += 1;
          sentence = "";
          finished=0;
          found = false;
        }else{
          println("error");
          sentence = "";
          finished=0;
          found = false;
        }
      }
      if(number == 6){
        println("Sentence: " + sentence);
        if(sentence.equals("Pencil")){
          println("correct!");
          points += 1;
          sentence = "";
          finished=0;
          found = false;
        }else{
          println("error");
          sentence = "";
          finished=0;
          found = false;
        }
      }
      if(number == 7){
        println("Sentence: " + sentence);
        if(sentence.equals("Ball")){
          println("correct!");
          points += 1;
          sentence = "";
          finished=0;
          found = false;
        }else{
          println("error");
          sentence = "";
          finished=0;
          found = false;
        }
      }
      if(number == 8){
        println("Sentence: " + sentence);
        if(sentence.equals("Apple")){
          println("correct!");
          points += 1;
          sentence = "";
          finished=0;
          found = false;
        }else{
          println("error");
          sentence = "";
          finished=0;
          found = false;
        }
      }
      if(number == 9){
        println("Sentence: " + sentence);
        if(sentence.equals("Bed")){
          println("correct!");
          points += 1;
          sentence = "";
          finished=0;
          found = false;
        }else{
          println("error");
          sentence = "";
          finished=0;
          found = false;
        }
      }
    }
  }
}


void keyPressed()
{
  if(key == ENTER && name_ok == 0){
    name = ask_nickname.getText();
    println(name);
    label4.setVisible(false);
    ask_nickname.setVisible(false);
    imgButton1.setVisible(false);
    name_ok = 1;
    bio_inserted = 1;
  }
  if (key == 'x' || key == 'X')
  {
    exit();
  }
}

void mousePressed() {
  if( sqrt( sq(654 - mouseX) + sq(149 - mouseY)) < 55/2){
    finished = 1;
    println("Message sent!");
    row = 0;
    column = 0;
    xpos = 195;
    ypos = 242;
    width_square = 30;
    init = 0;
  }
  if( sqrt( sq(120 - mouseX) + sq(105- mouseY)) < 70/2){
    found = false;
    flag_record = 0;
    sentence = "";
    points = 0;
    time = 60;
    initTimer = 0;
    get60Sec = 0;
  }
}


public void customGUI(){

}
