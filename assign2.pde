PImage bgImg, cabbageImg, lifeImg, soilImg, soldierImg;
PImage titleImg, startNormalImg, startHoveredImg, gameoverImg, restartNormalImg, restartHoveredImg;
PImage groundhogIdleImg, groundhogDownImg, groundhogLeftImg, groundhogRightImg;

int lifeX=10, lifeY=10, lifeW=50, lifeH=51;

int soilBlock=80;
int groundhogX = soilBlock*4, groundhogY = 80;
int groundhogOldX, groundhogOldY;
int soldierRandomY = floor(random(4));
int soldierX=0, soldierY= 160+soldierRandomY*soilBlock;

float lifeD=20;
int lifeNumber = 2;

int cabbageX = soilBlock*floor(random(8)), cabbageY= 160+soilBlock*floor(random(4));
boolean cabbageExist = true;

boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

boolean moving = false;
int movingDirection = 0;
int frame = 0;

final int GAME_START = 0;
final int GAME_RUN = 1;
final int GAME_OVER = 2;

int gameState = GAME_START;

void setup() {
  size(640, 480, P2D);

  // objects
  bgImg = loadImage("img/bg.jpg");
  soilImg = loadImage("img/soil.png");
  lifeImg = loadImage("img/life.png");
  cabbageImg = loadImage("img/cabbage.png");
  soldierImg = loadImage("img/soldier.png");

  // game start
  titleImg = loadImage("img/title.jpg");
  startNormalImg = loadImage("img/startNormal.png");
  startHoveredImg = loadImage("img/startHovered.png");

  // game over
  gameoverImg = loadImage("img/gameover.jpg");
  restartNormalImg = loadImage("img/restartNormal.png");
  restartHoveredImg = loadImage("img/restartHovered.png");

  // groundhog
  groundhogIdleImg = loadImage("img/groundhogIdle.png");
  groundhogDownImg = loadImage("img/groundhogDown.png");
  groundhogLeftImg = loadImage("img/groundhogLeft.png");
  groundhogRightImg = loadImage("img/groundhogRight.png");
}

void draw() {
  // Switch Game State
  switch(gameState) {
  case GAME_START:  // Game Start
    image(titleImg, 0, 0);
    if (mouseX > 248 && mouseX < 248+144
      && mouseY > 360 && mouseY < 360+60) {
      image(startHoveredImg, 248, 360); 
      if (mousePressed) {
        gameState = GAME_RUN;
      }
    } else {
      image(startNormalImg, 248, 360);
    }


    break;
  case GAME_RUN:   // Game Run
    //backround
    image(bgImg, 0, 0);

    //soil
    image(soilImg, 0, 160);

    //life
    if (lifeNumber == 3) {
      image(lifeImg, lifeX, lifeY);
      image(lifeImg, lifeX+lifeW+lifeD, lifeY);
      image(lifeImg, lifeX+2*lifeW+2*lifeD, lifeY);
    }
    if (lifeNumber == 2) {
      image(lifeImg, lifeX, lifeY);
      image(lifeImg, lifeX+lifeW+lifeD, lifeY);
    }
    if (lifeNumber == 1) {
      image(lifeImg, lifeX, lifeY);
    }

    //sun
    colorMode(RGB);
    fill(253, 184, 19); //light yellow
    stroke(255, 255, 0); //yellow
    strokeWeight(5);
    ellipse(width-50, 50, 120, 120);

    //grass
    colorMode(RGB);
    noStroke();
    fill(124, 204, 25);//green
    rectMode(CORNERS);
    rect(0, 145, 640, 160);

    //cabbage
    if (cabbageExist) {
      image(cabbageImg, cabbageX, cabbageY);
    }

    //groundhog

    if (moving == true) {
      frame += 1;
      switch(movingDirection) {
      case 1: //down
        groundhogY += (1.0/15)*soilBlock;
        image(groundhogDownImg, groundhogX, groundhogY);
        if (frame >= 14) {
          frame = 0;
          moving = false;
          groundhogY = groundhogOldY + soilBlock;
        }
        break;
      case 2: //left
        groundhogX -= (1.0/15)*soilBlock;
        image(groundhogLeftImg, groundhogX, groundhogY);
        if (frame >= 14) {
          frame = 0;
          moving = false;
          groundhogX = groundhogOldX - soilBlock;
        }
        break;
      case 3: //right
        groundhogX += (1.0/15)*soilBlock;
        image(groundhogRightImg, groundhogX, groundhogY);
        if (frame >= 14) {
          frame = 0;
          moving = false;
          groundhogX = groundhogOldX + soilBlock;
        }
        break;
      }
    } else {
      image(groundhogIdleImg, groundhogX, groundhogY);
    }
    if (groundhogX < soldierX+soldierImg.width &&     //collision
      groundhogX+groundhogIdleImg.width > soldierX &&
      groundhogY < soldierY+soldierImg.height &&
      groundhogY+groundhogIdleImg.height > soldierY
      ) {
      groundhogX = soilBlock*4;
      groundhogY = 80;
      lifeNumber -= 1;
      if (lifeNumber == 0) {
        gameState = GAME_OVER;
      }
    }
    if (groundhogX < cabbageX+cabbageImg.width && //eat cabbage
      groundhogX+cabbageImg.width > cabbageX &&
      groundhogY < cabbageY+cabbageImg.height &&
      groundhogY+cabbageImg.height > cabbageY &&
      cabbageExist == true
      ) {
      cabbageExist = false;
      lifeNumber += 1;
    }


    //soldier
    image(soldierImg, soldierX, soldierY);
    soldierX = soldierX+1;
    if (soldierX >= width) {
      soldierX=-soldierImg.width;
      //cabbage
    }
    break;
  case GAME_OVER:// Game Lose
    image(gameoverImg, 0, 0);
    if (mouseX > 248 && mouseX < 248+144
      && mouseY > 360 && mouseY < 360+60) {
      image(restartHoveredImg, 248, 360); 
      if (mousePressed) {
        gameState = GAME_RUN;
        lifeNumber = 2;
        soldierX=0;
        soldierY= 160+floor(random(4))*soilBlock;
        cabbageX = soilBlock*floor(random(8));
        cabbageY= 160+soilBlock*floor(random(4));
        cabbageExist = true;
      }
    } else {
      image(restartNormalImg, 248, 360);
    }
    break;
  }
}

void keyPressed() {
  if (key == CODED && moving==false) { // detect special keys 
    switch (keyCode) {
    case DOWN:
      downPressed = true;
      if (groundhogY + soilBlock >= height) {
        groundhogY = height - soilBlock;
      } else {
        moving = true;
        movingDirection = 1; //
        groundhogOldY = groundhogY;
      }
      break;
    case LEFT:
      leftPressed = true;
      if (groundhogX <= 0) {
        groundhogX = 0;
      } else {
        moving = true;
        movingDirection = 2;
        groundhogOldX = groundhogX;
      }
      break;
    case RIGHT:
      rightPressed = true;
      if (groundhogX + soilBlock >= width) {
        groundhogX = width - soilBlock;
      } else {
        moving = true;
        movingDirection = 3;
        groundhogOldX = groundhogX;
      }
      break;
    }
  }
}
////////
void keyReleased() {
  if (key == CODED) {
    switch (keyCode) {
    case DOWN:
      downPressed = false;
      break;
    case LEFT:
      leftPressed = false;
      break;
    case RIGHT:
      rightPressed = false;
      break;
    }
  }
}
