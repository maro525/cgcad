// 2段階で分割できるようにしました

class BezierCurve {

  PVector P0, P1, P2, P3;
  PVector[] R;
  int tn;

  BezierCurve() {
    P0 = new PVector(); P0.x =  20; P0.y = 300;
    P1 = new PVector(); P1.x = 140; P1.y = 100;
    P2 = new PVector(); P2.x = 280; P2.y = 100;
    P3 = new PVector(); P3.x = 380; P3.y = 300;

    tn = 100;
    R = new PVector[tn];
  }

  void draw(color c) {

    int   i, tt;
    float t = 0.0;
    float ts = 1.0 / tn;
    float B30t, B31t, B32t, B33t;

    stroke(0, 255, 255);
    fill(0, 255, 255, 30);
    quad(P0.x, P0.y, P1.x, P1.y, P2.x, P2.y, P3.x, P3.y);
    line(P0.x, P0.y, P1.x, P1.y);
    line(P1.x, P1.y, P2.x, P2.y);
    line(P2.x, P2.y, P3.x, P3.y);

    fill(123, 255, 205);
    ellipse(P0.x, P0.y, 3, 3);
    ellipse(P1.x, P1.y, 3, 3);
    ellipse(P2.x, P2.y, 3, 3);
    ellipse(P3.x, P3.y, 3, 3);

    //// text control points
    //fill(255, 255, 255);
    //text("P0", P0.x+15, P0.y   );
    //text("P1", P1.x,    P1.y-15);
    //text("P2", P2.x+10, P2.y-15);
    //text("P3", P3.x-30, P3.y   );

    noFill();
    stroke(c);


    for (tt = 0; tt < tn ; tt++) {
        B30t =     (1-t)*(1-t)*(1-t)        ;
        B31t = 3 * (1-t)*(1-t)       *t     ;
        B32t = 3 * (1-t)             *t*t   ;
        B33t =                        t*t*t ;
        R[tt] = new PVector();
        R[tt].x = B30t*P0.x + B31t*P1.x + B32t*P2.x + B33t*P3.x;
        R[tt].y = B30t*P0.y + B31t*P1.y + B32t*P2.y + B33t*P3.y;
      if (tt != 0) line(R[tt-1].x, R[tt-1].y, R[tt].x, R[tt].y);
      t += ts;
    }
  }

  void drawPointOnCurve(float t) {
    int   i, tt;
    float ts = 1.0 / tn;
    float B30t, B31t, B32t, B33t;
    B30t =     (1-t)*(1-t)*(1-t)        ;
    B31t = 3 * (1-t)*(1-t)       *t     ;
    B32t = 3 * (1-t)             *t*t   ;
    B33t =                        t*t*t ;
    stroke(0 , 0, 0);
    fill(255, 255, 255);
    ellipse(B30t*P0.x + B31t*P1.x + B32t*P2.x + B33t*P3.x,
            B30t*P0.y + B31t*P1.y + B32t*P2.y + B33t*P3.y, 1, 1);
  }

  void split (float tx, BezierCurve b1, BezierCurve b2) {
    // de Casteljau Algorithm
    PVector P00t = new PVector(); P00t.x = P0.x; P00t.y = P0.y;
    PVector P01t = new PVector(); P01t.x = P1.x; P01t.y = P1.y;
    PVector P02t = new PVector(); P02t.x = P2.x; P02t.y = P2.y;
    PVector P03t = new PVector(); P03t.x = P3.x; P03t.y = P3.y;

    PVector P10t = new PVector();
      P10t.x = (1-tx)*P00t.x + tx*P01t.x;
      P10t.y = (1-tx)*P00t.y + tx*P01t.y;
    PVector P11t = new PVector();
      P11t.x = (1-tx)*P01t.x + tx*P02t.x;
      P11t.y = (1-tx)*P01t.y + tx*P02t.y;
    PVector P12t = new PVector();
      P12t.x = (1-tx)*P02t.x + tx*P03t.x;
      P12t.y = (1-tx)*P02t.y + tx*P03t.y;

    PVector P20t = new PVector();
      P20t.x = (1-tx)*P10t.x + tx*P11t.x;
      P20t.y = (1-tx)*P10t.y + tx*P11t.y;
    PVector P21t = new PVector();
      P21t.x = (1-tx)*P11t.x + tx*P12t.x;
      P21t.y = (1-tx)*P11t.y + tx*P12t.y;

    PVector P30t = new PVector();
      P30t.x = (1-tx)*P20t.x + tx*P21t.x;
      P30t.y = (1-tx)*P20t.y + tx*P21t.y;

    // former bezier curve b1
    b1.P0.x = P00t.x; b1.P0.y = P00t.y;
    b1.P1.x = P10t.x; b1.P1.y = P10t.y;
    b1.P2.x = P20t.x; b1.P2.y = P20t.y;
    b1.P3.x = P30t.x; b1.P3.y = P30t.y;

    // latter bezier curve b2
    b2.P0.x = P30t.x; b2.P0.y = P30t.y;
    b2.P1.x = P21t.x; b2.P1.y = P21t.y;
    b2.P2.x = P12t.x; b2.P2.y = P12t.y;
    b2.P3.x = P03t.x; b2.P3.y = P03t.y;
  }
}

BezierCurve b0;
BezierCurve b1, b2, b3, b4, b5, b6;
PVector bp;
float t;

boolean split = false;
boolean split2 = false;

void setup() {
  size(400, 400);
  b0 = new BezierCurve();
  bp = new PVector();

  b1 = new BezierCurve();
  b2 = new BezierCurve();
  b3 = new BezierCurve();
  b4 = new BezierCurve();
  b5 = new BezierCurve();
  b6 = new BezierCurve();
}

void draw() {
  background(40);

  fill(255, 255, 255);
  text("BezierCurve Split. Press 'd' key. Press 'u' to split more.", 10, 20);
  t = map(mouseX, 0, width, 0, 1);

  b0.draw(color(255, 255, 255));
  b0.drawPointOnCurve(t);

  if(split) b1.draw(color(255, 255, 0));
  if(split) b2.draw(color(255,   0, 255));
  if(split2) b3.draw(color(255, 0, 0));
  if(split2) b4.draw(color(255, 125, 0));
  if(split2) b5.draw(color(0, 0, 255));
  if(split2) b6.draw(color(125, 0, 255));
}

void keyPressed() {
  if (key == 'd') {
    b0.split(t, b1, b2);
    split = true;
  }
  else if(key == 'u') {
    b1.split(t/2, b3, b4);
    b2.split(t+((1-t)/2), b5, b6);
    split = false;
    split2 = true;
  }

}

void keyReleased() {
  split = false;
  split2 = false;
}
