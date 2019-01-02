// Vertex Class
class CVertex {
  int x;
  int y;
  CVertex() { x=0; y=0; }
  void draw() {
    set(x, y, color(255));
  }
}

CVertex v0;
CVertex v1;

void setup() {
  size(400, 400);
	background(40);

	v0=new CVertex(); v0.x=10;  v0.y=10;
	v1=new CVertex(); v1.x=222; v1.y=100;

	int dx=v1.x-v0.x;
	int dy=v1.y-v0.y;
	float e=0.0; // 2
	int x, y;

	x=v0.x;
	y=v0.y;

	for( ; x<v1.x; x++ ) {
		set(x,y,color(255));
		e=e+(float)dy/dx;    // 3
		if( ************ ) { // 1
			************
			************     // 4
		}
	}

}
