Bezier B;
Ball ball;
int thresh = 100;
PFont font;
boolean bDrawControl;

void setup()
{
    size(1000, 800);
    B = new Bezier();
     //B.bDrawNormal = true;
    font = loadFont("Chalkboard-48.vlw");
    frameRate(60);

    bDrawControl = false;
}

void draw()
{
    background(255);

    fill(0);
    rect(0, height-thresh, width, height);

    //update
    if(B.P.size() == B.n && ball == null)
    {
        B.calcCurve();
        PVector middle = new PVector();
        middle = B.R[B.tn/2];
        PVector middle_normal = new PVector();
        middle_normal = B.getNormal(0.5);
        ball = new Ball(middle, middle_normal);
    }

    if(ball != null)
    {
        ball.update();
        B.checkDistance(ball);


        if(ball.p.y > height)
        {
            B.removeAllPoint();
            ball = null;
            B = new Bezier();
        }
    }

    // draw
    B.calcCurve();
    B.drawCurve();
    if(bDrawControl) B.drawPoint();
    if(ball != null) ball.draw();

    // text
    textSize(30);
    textFont(font);
    fill(0);
    float tx = 10; float ty = 35;
    if(ball == null) text("NULL", tx, ty);
    else if(ball.alive) text("ALIVE", tx, ty);
    else if(!ball.alive) text("DEAD", tx, ty);
}

void mousePressed()
{
    B.addPoint(new PVector(mouseX, mouseY));
    B.removePoint();
}

void keyPressed()
{
  if(key  =='n') B.bDrawNormal = !B.bDrawNormal;
  else if(key == 'b') bDrawControl = !bDrawControl;
}
