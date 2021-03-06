PVector tmp = new PVector(0, 0);
PVector prev = new PVector(0, 0);

int pNum = 10;
int deg = 3;
int degMax = 6;

PVector[] p = new PVector[pNum];
float w[] = new float[pNum];
int m = pNum + degMax + 1;

float nVec[] = new float[m];

int selected;

int wKey;

void setup()
{
  size(800, 800);
  colorMode(RGB, 255);

  frameRate(30);

  for(int i = 0; i < pNum; i++)
  {
    p[i] = new PVector((float)i/(float)(pNum-1)*width, random(height));
    w[i] = 1.0;
  }

  m = pNum + deg + 1;
  for (int i = 0; i < m; i++)
  {
    if(i < deg+1) nVec[1] = 0;
    else if(i > m - (deg+1)) nVec[i] = m - 1 - 2 * deg;
    else nVec[i] = i - deg;
  }

  smooth();
}

void drawPolygon()
{
  int i;
  rectMode(CENTER);
  int rectL = 6;

  for(i = 0; i < pNum; i++)
  {
    if(w[i] == 0)
    {
      stroke(255, 50, 0, 200);
      noFill();
      rect(p[i].x, p[i].y, rectL, rectL);
    }
    else
    {
      noStroke();
      fill(255,50,0,200);
      rect(p[i].x, p[i].y, (float)rectL*w[i], (float)rectL*w[i]);
    }
  }

  strokeWeight(1);
  fill(255,50,0,200);
  noFill();

  stroke(255,50,0,50);
  for(i = 0; i < pNum-1; i++)
  {
    line(p[i].x, p[i].y, p[i+1].x, p[i+1].y);
  }
}

float blending(int i, int k, float t)
{
  float val;
  float w1 = 0.0, w2 = 0.0;
  if(k == 0)
  {
    if(nVec[i] <= t && t < nVec[i+1]) val = 1.0;
    else val = 0.0;
  }
  else
  {
    if((nVec[i+k+1] - nVec[i+1]) != 0)
    w1 = blending(i+1, k-1, t) * (nVec[i+k+1] - t) / (nVec[i+k+1] - nVec[i+1]);
    if((nVec[i+k] - nVec[i]) != 0)
    w2 = blending(i, k-1, t) * (t - nVec[i]) / (nVec[i+k] - nVec[i]);
    val = w1 + w2;
  }
  return val;
}

void drawBSpline()
{
  float[] b = new float[pNum];

  for(float t = nVec[deg]; t < nVec[m-deg-1]; t += 0.001)
  {
    if(floor(t) % 2 == 1) stroke(255, 50, 0);
    else stroke(255, 170, 0);

    tmp = new PVector(0, 0);
    float wp = 0;
    for(int j = 0; j < pNum; j++)
    {
      b[j] = blending(j, deg, t);

      tmp.x += p[j].x * b[j] * w[j];
      tmp.y += p[j].y * b[j] * w[j];

      wp += b[j] * w[j];
    }
    tmp.x /= wp;
    tmp.y /= wp;

    if(t != nVec[deg] && t != nVec[m-deg-1] && ((tmp.x != -1) && (prev.x != -1)))
    {
        line(tmp.x, tmp.y, prev.x, prev.y);
    }
    prev.set(tmp);
  }
}

void drawGrid(float gScale)
{
    strokeWeight(1);

    int i;
    for(i = 0; i <= width/gScale; i++)
    {
        stroke(0, 0, 0, 20);
        line(i*gScale, 0, i*gScale, height);
    }
}

void draw()
{
    background(255, 255,255);
    drawGrid(0);

    drawPolygon();

    stroke(255, 50, 0);

    drawBSpline();
}

void mousePressed()
{
    selected = -1;

    float minD = 10;
    int i;
    for(i=0; i < pNum; i++)
    {
        float d = dist(mouseX, mouseY, p[i].x, p[i].y);
        if(d < minD)
        {
            minD = d;
            selected = i;
        }
    }

    if (selected != -1)
    {
        if(wKey == 1)
        {
            w[selected] += 0.2;
        }
        else if(wKey == 2)
        {
            w[selected] -= 0.2;
            if(w[selected] <= 0) w[selected] = 0;
        }
        else
        {
            p[selected].x = mouseX;
            p[selected].y = mouseY;
        }
    }
}

void mouseDragged()
{
    if(selected != -1)
    {
        p[selected].x = mouseX;
        p[selected].y = mouseY;
    }
}

void keyPressed()
{
    switch(keyCode)
    {
        case 49:
        case 50:
        case 51:
        case 52:
        case 53:
        case 54:
        deg = keyCode - 48;
        m = pNum + deg + 1;

        for(int i = 0; i < m; i++)
        {
            if(i < deg+1) nVec[i] = 0;
            else if (i > m - (deg+1)) nVec[i] = m - 1 - 2 * deg;
            else nVec[i] = i - deg;
        }
        break;

        case 16:
        wKey = 1;
        break;

        case 18:
        wKey = 2;
        break;

    }
}

void keyReleased()
{
    wKey = 0;
}
