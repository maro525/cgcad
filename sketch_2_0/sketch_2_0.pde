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

}

void draw() {
  background(40);



}