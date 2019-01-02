class Ball
{
    PVector p;
    PVector v;
    int r = 15;
    boolean alive = true;
    int thresh_max = 20;
    int thresh_min = 10;

    Ball(PVector _p, PVector _v)
    {
        p = _p;
        v = _v;
        checkV();
        // print("ball init : ");
        // print("P[" + p.x + " " + p.y + "] ");
        // println("V[" + v.x + " " + v.y + "] ");
    }

    void checkV()
    {
        if(v.mag() > thresh_max) v.setMag(thresh_max);
        else if(v.mag() < thresh_min) v.setMag(thresh_min);
    }

    void update()
    {
        p.x += v.x;
        if(p.x > width+5 || p.x < 5) v.x *= -1;

        p.y += v.y;
        if(p.y > height - 100) alive = false;
        else if (p.y < 5) v.y *= -1;

        checkV();

        // print("ball update : ");
        // print("P[" + p.x + " " + p.y + "] ");
        // println("V[" + v.x + " " + v.y + "] ");
    }

    void reflect(PVector l)
    {
        float d = v.dot(l);
        if(d > 0) return;

        PVector temp_v = new PVector();
        temp_v = v;
        temp_v.x *= -1;
        temp_v.y *= -1;

        checkV();

        float r_ball = atan2(ball.v.y, ball.v.x);
        float r_norm = atan2(l.y, l.x);
        float radian = r_norm - r_ball;

         // println("REFRECT");
        // print("bv: " + temp_v.x + " " + temp_v.y);
        // println(" norm: " + l.x + " " + l.y);
        // print("ball rad: " + r_ball);
        // println(" norm rad: " + r_norm);
        // println("radian " + radian + " degree " + degrees(radian));
        // println("");

        if (radian == 0.0)
            v = temp_v;
        else
            temp_v.rotate(radian*2);
            v = temp_v;
    }

    void draw()
    {
        stroke(0);
        if (alive) fill(0, 0, 255);
        else fill(255, 0, 0);

        ellipse(p.x, p.y, r, r);
    }
}
