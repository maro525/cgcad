// 5 * 5 のベジエ曲面

import processing.opengl.*;

class BezierSurface {

  PVector P04, P14, P24, P34, P44;
  PVector P03, P13, P23, P33, P43;
  PVector P02, P12, P22, P32, P42;
  PVector P01, P11, P21, P31, P41;
  PVector P00, P10, P20, P30, P40;
  PVector[][] S;
  int un, vn;

  float w04, w14, w24, w34, w44;
  float w03, w13, w23, w33, w43;
  float w02, w12, w22, w32, w42;
  float w01, w11, w21, w31, w41;
  float w00, w10, w20, w30, w40;

  BezierSurface() {
    P04 = new PVector(-150,   0, -150);
    P14 = new PVector( -50,  40, -150);
    P24 = new PVector(   0,  80, -150);
    P34 = new PVector(  50,  40, -150);
    P44 = new PVector( 150,   0, -150);
    P03 = new PVector(-150,   0,  -50);
    P13 = new PVector( -50,  40,  -50);
    P23 = new PVector(   0,  120,  -50);
    P33 = new PVector(  50,  40,  -50);
    P43 = new PVector( 150,   0,  -50);
    P02 = new PVector(-150,   0,    0);
    P12 = new PVector( -50,  40,    0);
    P22 = new PVector(   0,  160,    0);
    P32 = new PVector(  50,  40,    0);
    P42 = new PVector( 150,   0,    0);
    P01 = new PVector(-150,   0,   50);
    P11 = new PVector( -50,  40,   50);
    P21 = new PVector(   0,  120,   50);
    P31 = new PVector(  50,  40,   50);
    P41 = new PVector( 150,   0,   50);
    P00 = new PVector(-150,   0,  150);
    P10 = new PVector( -50,  40,  150);
    P20 = new PVector(   0,  80,  150);
    P30 = new PVector(  50,  40,  150);
    P40 = new PVector( 150,   0,  150);

    w04 = 1; w14 = 1; w24 = 1; w34 = 1; w44 = 1;
    w03 = 1; w13 = 1; w23 = 1; w33 = 1; w43 = 1;
    w02 = 1; w12 = 1; w22 = 1; w32 = 1; w42 = 1;
    w01 = 1; w11 = 1; w21 = 1; w31 = 1; w41 = 1;
    w00 = 1; w10 = 1; w20 = 1; w30 = 1; w40 = 1;

    un = 10;
    vn = 10;

    S = new PVector[un+1][vn+1];
    for (int i=0; i<un+1; i++)
      for (int j=0; j<vn+1; j++)
        S[i][j] = new PVector();

  }

  void CtrlPt(PVector P) { pushMatrix(); translate(P.x, P.y, P.z); box(2); popMatrix(); }
  void Edge(PVector P0, PVector P1) { line(P0.x, P0.y, P0.z, P1.x, P1.y, P1.z); }

  float B40(float t) { return (1-t)*(1-t)*(1-t)*(1-t); }
  float B41(float t) { return 4*(1-t)*(1-t)*(1-t)*t; }
  float B42(float t) { return 6*(1-t)*(1-t)*t*t; }
  float B43(float t) { return 4*(1-t)*t*t*t; }
  float B44(float t) { return t*t*t*t; }

  void draw(color c) {

    stroke(0, 255, 255);

    CtrlPt(P04); CtrlPt(P14); CtrlPt(P24); CtrlPt(P34); CtrlPt(P44);
    CtrlPt(P03); CtrlPt(P13); CtrlPt(P23); CtrlPt(P33); CtrlPt(P43);
    CtrlPt(P02); CtrlPt(P12); CtrlPt(P22); CtrlPt(P32); CtrlPt(P42);
    CtrlPt(P01); CtrlPt(P11); CtrlPt(P21); CtrlPt(P31); CtrlPt(P41);
    CtrlPt(P00); CtrlPt(P10); CtrlPt(P20); CtrlPt(P30); CtrlPt(P40);

    Edge(P04, P14); Edge(P14, P24); Edge(P24, P34); Edge(P34, P44);
    Edge(P03, P13); Edge(P13, P23); Edge(P23, P33); Edge(P33, P43);
    Edge(P02, P12); Edge(P12, P22); Edge(P22, P32); Edge(P32, P42);
    Edge(P01, P11); Edge(P11, P21); Edge(P21, P31); Edge(P31, P41);
    Edge(P00, P10); Edge(P10, P20); Edge(P20, P30); Edge(P30, P40);

    Edge(P00, P01); Edge(P01, P02); Edge(P02, P03); Edge(P03, P04);
    Edge(P10, P11); Edge(P11, P12); Edge(P12, P13); Edge(P13, P14);
    Edge(P20, P21); Edge(P21, P22); Edge(P22, P23); Edge(P23, P24);
    Edge(P30, P31); Edge(P31, P32); Edge(P32, P33); Edge(P33, P34);
    Edge(P40, P41); Edge(P41, P42); Edge(P42, P43); Edge(P43, P44);

    int   i, uu, vv;
    float u, v;
    float us = (float)1/un;
    float vs = (float)1/vn;

    stroke(c);

    u=0;
    for(uu=0; uu<=un; uu+=1) {
        v=0;
        for(vv=0; vv<=vn; vv+=1) {

          float sum = B40(u) * ( B40(v)*w00 + B41(v)*w01 + B42(v)*w02 + B43(v)*w03 + B44(v)*w04)
                        + B41(u) * ( B40(v)*w10 + B41(v)*w11 + B42(v)*w12 + B43(v)*w13 + B44(v)*w14)
                        + B42(u) * ( B40(v)*w20 + B41(v)*w21 + B42(v)*w22 + B43(v)*w23 + B44(v)*w24)
                        + B43(u) * ( B40(v)*w30 + B41(v)*w31 + B42(v)*w32 + B43(v)*w33 + B44(v)*w34)
                        + B44(u) * ( B40(v)*w40 + B41(v)*w41 + B42(v)*w42 + B43(v)*w43 + B44(v)*w44);
          S[uu][vv].x = (B40(u)*(B40(v)*P00.x*w00 + B41(v)*P01.x*w01 + B42(v)*P02.x*w02 + B43(v)*P03.x*w03 + B44(v)*P04.x*w04)
                        +B41(u)*(B40(v)*P10.x*w10 + B41(v)*P11.x*w11 + B42(v)*P12.x*w12 + B43(v)*P13.x*w13 + B44(v)*P14.x*w14)
                        +B42(u)*(B40(v)*P20.x*w20 + B41(v)*P21.x*w21 + B42(v)*P22.x*w22 + B43(v)*P23.x*w23 + B44(v)*P24.x*w24)
                        +B43(u)*(B40(v)*P30.x*w30 + B41(v)*P31.x*w31 + B42(v)*P32.x*w32 + B43(v)*P33.x*w33 + B44(v)*P34.x*w34)
                        +B44(u)*(B40(v)*P40.x*w40 + B41(v)*P41.x*w41 + B42(v)*P42.x*w42 + B43(v)*P43.x*w43 + B44(v)*P44.x*w44)) /sum;
          S[uu][vv].y = (B40(u)*(B40(v)*P00.y*w00 + B41(v)*P01.y*w01 + B42(v)*P02.y*w02 + B43(v)*P03.y*w03 + B44(v)*P04.y*w04)
                        +B41(u)*(B40(v)*P10.y*w10 + B41(v)*P11.y*w11 + B42(v)*P12.y*w12 + B43(v)*P13.y*w13 + B44(v)*P14.y*w14)
                        +B42(u)*(B40(v)*P20.y*w20 + B41(v)*P21.y*w21 + B42(v)*P22.y*w22 + B43(v)*P23.y*w23 + B44(v)*P24.y*w24)
                        +B43(u)*(B40(v)*P30.y*w30 + B41(v)*P31.y*w31 + B42(v)*P32.y*w32 + B43(v)*P33.y*w33 + B44(v)*P34.y*w34)
                        +B44(u)*(B40(v)*P40.y*w40 + B41(v)*P41.y*w41 + B42(v)*P42.y*w42 + B43(v)*P43.y*w43 + B44(v)*P44.y*w44)) /sum;
          S[uu][vv].z = (B40(u)*(B40(v)*P00.z*w00 + B41(v)*P01.z*w01 + B42(v)*P02.z*w02 + B43(v)*P03.z*w03 + B44(v)*P04.z*w04)
                        +B41(u)*(B40(v)*P10.z*w10 + B41(v)*P11.z*w11 + B42(v)*P12.z*w12 + B43(v)*P13.z*w13 + B44(v)*P14.z*w14)
                        +B42(u)*(B40(v)*P20.z*w20 + B41(v)*P21.z*w21 + B42(v)*P22.z*w22 + B43(v)*P23.z*w23 + B44(v)*P24.z*w24)
                        +B43(u)*(B40(v)*P30.z*w30 + B41(v)*P31.z*w31 + B42(v)*P32.z*w32 + B43(v)*P33.z*w33 + B44(v)*P34.z*w34)
                        +B44(u)*(B40(v)*P40.z*w40 + B41(v)*P41.z*w41 + B42(v)*P42.z*w42 + B43(v)*P43.z*w43 + B44(v)*P44.z*w44)) /sum;


          if (uu>0 && vv>0) {
            beginShape();
             vertex(S[uu  ][vv  ].x, S[uu  ][vv  ].y, S[uu  ][vv  ].z);
             vertex(S[uu-1][vv  ].x, S[uu-1][vv  ].y, S[uu-1][vv  ].z);
             vertex(S[uu-1][vv-1].x, S[uu-1][vv-1].y, S[uu-1][vv-1].z);
             vertex(S[uu  ][vv-1].x, S[uu  ][vv-1].y, S[uu  ][vv-1].z);
            endShape();
          }
          v = v + vs;
        }
      u = u + us;
    }



  }

}


BezierSurface b0;

void setup() {
  size(500, 500, OPENGL);
  b0 = new BezierSurface();
}

float ang=0;

void draw() {
  background(40);
  text("Press w or W", 10, 20);

  lights();
  translate(width/2, height/2);
  rotateX(map(-mouseY, 0, width, -PI, PI));
  rotateY(map(mouseX, 0, height, -PI, PI));

  b0.draw(color(255, 255, 255));

}

void keyPressed() {
  if (key=='w') {
    b0.w20+=0.1;
    b0.w21+=0.1;
    b0.w22+=0.1;
    b0.w23+=0.1;
    b0.w24+=0.1;
  }
  if (key=='W') {
    b0.w20-=0.1;
    b0.w21-=0.1;
    b0.w22-=0.1;
    b0.w23-=0.1;
    b0.w24-=0.1;
  }
}
