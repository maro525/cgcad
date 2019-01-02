class Bezier
{
    int n, tn;
    ArrayList <PVector> P;
    PVector[] R, Curve;
    boolean bDrawNormal = false;

    Bezier()
    {
        n = 4;
        tn = 500;
        P = new ArrayList<PVector>();
        R = new PVector[tn+1];
        Curve = new PVector[2*tn+2];
    }

    PVector getLastP()
    {
        PVector p  = new PVector(0, 0);
        if (P.size() > 2)
            p = P.get(P.size()-1);

        return p;
    }

    float getDistanceFromLast(PVector p)
    {
        PVector last = getLastP();
        float d = last.dist(p);
        return d;
    }

    void addPoint(PVector p)
    {
        if(P.size() < n)
        {
            P.add(p);
            return;
        }

        PVector middle;
        if(getDistanceFromLast(p) > 50)
        {
            middle = PVector.lerp(getLastP(), p, 0.5);
            P.add(middle);
        }
        else
        {
            P.add(p);
        }
    }

    void removePoint()
    {
        if (P.size() > n) {
            P.remove(0);
        }
    }

    void removeAllPoint()
    {
        for(int i = 0; i < P.size(); i++)
            P.remove(i);
    }

    void calcCurve()
    {
        if(P.size() < 4) return;

        int   tt;
        float t=0.0;
        float ts = (float)1 / tn;
        float B40t, B41t, B42t, B43t;
        for(tt = 0; tt <= tn ; tt+=1) {
            B40t =  (1-t) * (1-t) * (1-t);
            B41t =  3 * (1-t) * (1-t) * t;
            B42t =  3 * (1-t) * t * t;
            B43t =  t * t * t;
            R[tt] = new PVector();
            R[tt].x = B40t*P.get(0).x + B41t*P.get(1).x + B42t*P.get(2).x + B43t*P.get(3).x;
            R[tt].y = B40t*P.get(0).y + B41t*P.get(1).y + B42t*P.get(2).y + B43t*P.get(3).y;

            t = t + ts;
        }
    }

    void checkDistance(Ball ball)
    {
        float d = 100000000.0;
        float temp = 0.0;

        for(int i=0; i <= tn; i++)
        {
            float t = (float)i/tn;
            float dx = R[i].x - ball.p.x;
            float dy = R[i].y - ball.p.y;
            float CD = dx *dx + dy * dy;
            if(CD < d) { d = CD; temp = t; }
        }
        float dis = sqrt(d);

        if(dis < ball.r)
        {
            PVector l = new PVector();
            l = getNormal(temp);
            ball.reflect(l);
        }
    }

    PVector getNormal(float t){
        PVector A1 = new PVector();

        if(P.size() < n) return A1;

        PVector Q0 = new PVector();
        Q0.x = 3 * ( P.get(1).x - P.get(0).x );
        Q0.y = 3 * ( P.get(1).y - P.get(0).y );
        PVector Q1 = new PVector();
        Q1.x = 3 * ( P.get(2).x - P.get(1).x) ;
        Q1.y = 3 * ( P.get(2).y - P.get(1).y);
        PVector Q2 = new PVector();
        Q2.x = 3 * ( P.get(3).x - P.get(2).x);
        Q2.y = 3 * ( P.get(3).y - P.get(2).y);

        PVector W0, W1;
        W0 = new PVector(); W0.x = 2*(Q1.x-Q0.x); W0.y = 2*(Q1.y-Q0.y);
        W1 = new PVector(); W1.x = 2*(Q2.x-Q1.x); W1.y = 2*(Q2.y-Q1.y);

        float D0t = (1-t) * (1-t);
        float D1t = 2 * t * (1-t);
        float D2t = t * t;

        float D10t = (1-t);
        float D11t = t;

        PVector D1 = new PVector();
        D1.x = D0t*Q0.x + D1t*Q1.x + D2t*Q2.x;
        D1.y = D0t*Q0.y + D1t*Q1.y + D2t*Q2.y;
        PVector D2 = new PVector();
        D2.x = D10t * W0.x - D11t * W1.x;
        D2.y = D10t * W0.y - D11t * W1.y;

        float K = (D1.x * D2.y - D2.x * D1.y) /
            (sqrt(D1.x * D1.x + D1.y * D1.y) * (D1.x * D1.x + D1.y * D1.y));
        float v = 0.5 / K;

        A1.x = D1.x; A1.y = D1.y;

        PVector A2 = new PVector();
        A2.x = A1.x; A2.y = A1.y;
        if(A2.x > 0) A2.rotate(-HALF_PI);
        else A2.rotate(HALF_PI);

        A2.setMag(v);

        return A2;
    }

    // not used
    void drawCurve()
    {
        if(P.size() < 4) return;

         float t=0.0;
         float ts = (float)1 / tn;
         for(int i = 0; i <= tn; i+=1) {
             stroke(0);
             if(i != 0) line(R[i-1].x, R[i-1].y, R[i].x, R[i].y);

             getNormal(t);

            if(bDrawNormal)
            {
                PVector _b = new PVector();
                _b.x = R[i].x;
                _b.y = R[i].y;
                PVector _e = new PVector();
                PVector _d = new PVector();
                _d = getNormal(t);
                _e.x = _b.x + _d.x;
                _e.y = _b.y + _d.y;
                strokeWeight(0.5);
                line(_b.x, _b.y, _e.x, _e.y);
            }

            t += ts;
         }
    }

    void drawPoint()
    {
        stroke(0);
        noFill();
        for(int i = 0; i < P.size(); i++)
            ellipse(P.get(i).x, P.get(i).y, 10, 10);
    }
}
