//  有理化しました

class BezierCurve {

  PVector P0, P1, P2, P3, P4;
  PVector[] R;
  float w0, w1, w2, w3, w4;
  int tn;
  int selected = 0;
  float diff = 0.01;

  BezierCurve() {
    P0 = new PVector(); P0.x =  20; P0.y = 300;
    P1 = new PVector(); P1.x = 140; P1.y = 100;
    P2 = new PVector(); P2.x = 210; P2.y = 60;
    P3 = new PVector(); P3.x = 280; P3.y = 100;
    P4 = new PVector(); P4.x = 380; P4.y = 300;

    w0=1; w1=1; w2=1; w3=1; w4=1;

    tn = 50;
    R = new PVector[tn+1];
  }

  void changeSelected(int diff)
  {
      switch(diff)
      {
          case 1:
            selected += 1;
            if(selected > 4) selected = 0;
            break;
          case -1:
            selected -= 1;
            if(selected < 0) selected = 4;
            break;
          default:
            break;
      }
  }

  void changeWeight(boolean _b)
  {
      switch(selected)
      {
          case 0:
            if(_b) w0 += diff;
            else w0 -= diff;
            break;
          case 1:
            if(_b) w1 += diff;
            else w1 -= diff;
            break;
          case 2:
            if(_b) w2 += diff;
            else w2 -= diff;
            break;
          case 3:
            if(_b) w3 += diff;
            else w3 -= diff;
            break;
          case 4:
            if(_b) w4 += diff;
            else w4 -= diff;
            break;
          default: break;
      }
  }

  void draw() {

    int   i, tt;
    float t=0.0;
    float ts = (float)1 / tn;
    float B40t, B41t, B42t, B43t, B44t;

    stroke(0, 255, 255);
    fill(0, 255, 255, 30);
    //quad(P0.x, P0.y, P1.x, P1.y, P2.x, P2.y, P3.x, P3.y);
    line(P0.x, P0.y, P1.x, P1.y);
    line(P1.x, P1.y, P2.x, P2.y);
    line(P2.x, P2.y, P3.x, P3.y);
    line(P3.x, P3.y, P4.x, P4.y);

    fill(0, 255, 255);
    ellipse(P0.x, P0.y, 10, 10);
    ellipse(P1.x, P1.y, 10, 10);
    ellipse(P2.x, P2.y, 10, 10);
    ellipse(P3.x, P3.y, 10, 10);
    ellipse(P4.x, P4.y, 10, 10);

    // text control points
    fill(255, 255, 255);
    text("P0", P0.x+15, P0.y   ); // p0
    text("P1", P1.x,    P1.y-15); // p1
    text("P2", P2.x+10, P2.y-15); // p2
    text("P3", P3.x-30, P3.y   ); // p3
    text("P4", P4.x+10, P4.y);

    noFill();
    stroke(255, 255, 255);

    for(tt = 0; tt <= tn ; tt+=1) {
        B40t =  (1-t) * (1-t) * (1-t) * (1-t);
        B41t =  4 * (1-t) * (1-t) * (1-t) * t;
        B42t =  6 * (1-t) * (1-t) * t * t;
        B43t =  4 * (1-t) * t * t * t;
        B44t =  t * t * t * t;
        float sum = B40t*w0 + B41t*w1 + B42t*w2 + B43t*w3 + B44t*w4;

        R[tt] = new PVector();
        R[tt].x = (B40t*P0.x + B41t*P1.x + B42t*P2.x + B43t*P3.x + B44t*P4.x) / sum;
        R[tt].y = (B40t*P0.y + B41t*P1.y + B42t*P2.y + B43t*P3.y + B44t*P4.y) / sum;
        if(tt != 0) line(R[tt-1].x, R[tt-1].y, R[tt].x, R[tt].y);

      t = t + ts;
    }
  }

  void drawSelected()
  {
      fill(255, 0, 0);
      switch(selected)
      {
          case 0: ellipse(P0.x, P0.y, 11, 11); break;
          case 1: ellipse(P1.x, P1.y, 11, 11); break;
          case 2: ellipse(P2.x, P2.y, 11, 11); break;
          case 3: ellipse(P3.x, P3.y, 11, 11); break;
          case 4: ellipse(P4.x, P4.y, 11, 11); break;
          default: break;
      }

  }
}

BezierCurve b0;
void setup() {
  size(400, 400);
  b0 = new BezierCurve();
}

void draw() {
  background(40);

  fill(255);
  text("BezierCurve", 10, 20);

  b0.P0.x = mouseX; b0.P0.y = mouseY;

  b0.draw();
  b0.drawSelected();
}

void keyPressed()
{
    if (key == 'w') b0.w1 += 0.1;
    else if (key == 'W') b0.w1 -= 0.1;
    switch(key)
    {
        case 'w': b0.changeWeight(true); break;
        case 'W': b0.changeWeight(false); break;
        case 'u': b0.changeSelected(1); break;
        case 'd': b0.changeSelected(-1); break;
        default: break;
    }
}
