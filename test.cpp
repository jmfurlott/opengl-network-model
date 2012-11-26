//Joseph Furlott
//Help from www.swiftless.com tutorials - needs proper credits


#include <GLUT/glut.h>
#include <iostream>
#include <fstream>
#include <vector>
#include <string>

using namespace std;


bool* keyStates = new bool[256];  //holds all the key values; 0 is not pressed, 1 is pressed


//variables to handle rotation and transformations
bool movingUp = false;
float yLocation = 0.0f;
float yRotationAngle = 0.0f;
vector<float> coordinates(1);
vector<float> xx(1);
vector<float> yy(1);
vector<float> zz(1);
int size;


//to read in the coordinate file
int readCoordinates() {
    //first need to open the file
    ifstream file("Coordinates10.txt");
    float temp;
    string tempDiameter;
    string tempColor;
    if(file.is_open()) {
        
        //need to read in header line first!
        string header;
        getline(file,header);
        //now get the data
        int counter = 0; //so we manage collecting the diameter and color of the linesß
        int i = 0;
        while(!file.eof()) {
            file >> temp;
            coordinates[i] = temp/1000;
            i += 1;
//            counter += 1;
//            if(counter > 5) {
//                counter = 0;
//                file >> tempDiameter;
//                file >> tempColor; //tested and working
//            }
            coordinates.resize(i+2); //dynamically resize the vector such that it is always one ahead
        }
        
        size = coordinates.size();
        //so now the vector should hold the appropriate data
        //STILL NEED TO CONVERT TO FLOAT but just testing for now
        
        
            
    }
	else {
		 cout << "Unable to open file";
        return 0;
    }
    
//    xx.resize(size/3);
//    int a = 0;
//    for(int j = 0; j < size/3; j+=3) {
//        xx[a] = coordinates[j];
//     //   cout << xx[a] << endl;
//        a++;
//    }
//    
//    yy.resize(size/3);
//    a = 0;
//    for(int j = 1; j < size/3; j+=3) {
//        yy[a] = coordinates[j];
//        
//        a++;
//    }
//    
//    zz.resize(size/3);
//    a = 0;
//    for(int j = 2; j < size/3; j+=3) {
//        zz[a] = coordinates[j];
//        
//        a++;
//    }

    return 1;


}



//method to convert the vector to a GLint array (primitive)
//not sure if static
void convertVectorToArray() {
    
    int good = readCoordinates();
    size = coordinates.size();
    //first build the array
    GLfloat vertices[size];
    
    for(int i = 0; i < size; i++) {
        vertices[i] = coordinates[i];
    }
    
    //now make a pointer to that built array in GLint form
    GLfloat* a = vertices;
    
}




void reshape(int width, int height) {
	glViewport(0,0, (GLsizei) width, (GLsizei) height); //set the viewport coordinates
	glMatrixMode(GL_PROJECTION); //switch to the projection matrix we can set up rendering
	
	//now set the projection matrix to the identity so that nothing is skewed
	
	glLoadIdentity();  //gives us the identity matrix
	
	//set the field of view (FOV) and the aspect ratio
	gluPerspective(60, (GLfloat) width/ (GLfloat) height, 1.0, 100.0);
	
	//and now swich back to the Model view matrix
	glMatrixMode(GL_MODELVIEW);
	
}

void keyPressed(unsigned char key, int x, int y) {
	if(key == 'a') {
		//perform the action where a is pressed
	}
	keyStates[key] = true; //set the state of the current key pressed to be true
	
}

void keyUp(unsigned char key, int x, int y ) {
	if (key == 'a') {
		//what do when a is released AFTER being held
	}
	keyStates[key] = false; //no longer pressed
}

void keyOperations(void) {
	if (keyStates['a']) {
		
	}
}



//drawing a square in space
void renderPrimitive(void) {
	//start the beginning of the opengl call with glBegin

    int nothing = readCoordinates();
	//though there is more performance to use triangles with five vertices
//	
//    glEnableClientState(GL_VERTEX_ARRAY);
//    
////    //pulling from vector! only one dimension; slow as shit
////    //TODO:optimization
////    int i = 0;
////    int x1, y1, z1;
////    int x2, y2, z2;
////    while (i < coordinates.size()) {
////        
////        glBegin(GL_LINES);
////        x1 = coordinates[i];
////        y1 = coordinates[i+1];
////        z1 = coordinates[i+2];
////        x2 = coordinates[i+3];
////        y2 = coordinates[i+4];
////        z2 = coordinates[i+5];
////        i = i + 8; //skipping color and dimeter for now
////        
////        //now do the drawing
////        cout << x1;
////        glVertex3f(x1,y1,z1);
////        glVertex3f(x2,y2,z2);
////        glEnd();
////    }
//    
//    
//    //----------------------------------------------
//    GLfloat x_vertices[size/3];
//    GLfloat y_vertices[size/3];
//    GLfloat z_vertices[size/3];
//    int a = 0;
//    for(int j = 0; j < size/3; j++) {
//        x_vertices[j] = xx[j];
//        //cout << x_vertices[j] << endl;
//
//    }
//    
//    for(int j = 0; j < size/3; j++) {
//        y_vertices[j] = yy[j];
//        //cout << y_vertices[j] << endl;
//        
//    }
//    
//
//    for(int j = 0; j < size/3; j++) {
//        z_vertices[j] = zz[j];
//       // cout << z_vertices[j] << endl;
//        
//    }

//    
//    
//    glVertexPointer(3, GL_FLOAT, 0, x_vertices);
//    glVertexPointer(3, GL_FLOAT, 0, y_vertices);
//    glVertexPointer(3, GL_FLOAT, 0, z_vertices);

    //and now everything is loaded so draw the lines!

    //now set the diameters
    //glLineWidth(10);
    //width only changes outside of glBegin but why??
    
    
    
    //glColor3f(1.0,0.0,0.0); //red
    float tempColor;
    GLfloat tempDiameter; //not used yet
    for(int i = 0; i < size ; i+=8) {
     //   glVertex3f(x_vertices[i],y_vertices[i],z_vertices[i]);
      //  glVertex3f(x_vertices[i+1],y_vertices[i+1],z_vertices[i+1]);

        tempDiameter = coordinates[i+6];
        tempColor = coordinates[i+7];
        
        glLineWidth(tempDiameter*25);
        glBegin(GL_LINES);

        //now assign colors to artery or vein
        if(tempColor == 0)  {// means artery so be blue
            glColor3f(0.0,0.0,1.0);

        } else { //must be a vein so set red
            glColor3f(1.0,0.0,0.0);
        }
        
 
        
        //and finally draw them according to their vertices
        glVertex3f(coordinates[i], coordinates[i+1], coordinates[i+2]);
        glVertex3f(coordinates[i+3],coordinates[i+4], coordinates[i+5]);
        glEnd();
    }
//    glEnd();
    
    
}

void display(void) {
	keyOperations(); //should be done first always otherwise key presses could mess with the rendering
	

    glClearColor(0.0f,0.0f,0.0f,1.0f);
	glClear(GL_COLOR_BUFFER_BIT);
	glLoadIdentity();
	
	glTranslatef(-1.5f, -1.0f, -5.0f); //push the scene back 5z that way can see everything (0,0,0) -> (0,0,-5)
	renderPrimitive(); //method that is drawing the square
	
	//handles the moving of the cube
	//order counts!
//	glTranslatef(0.0f, yLocation, 0.0f);
//	glRotatef(yRotationAngle, 0.0f, 1.0f, 0.0f);
	
//	glutWireCube(2.0f);

	glFlush();
/*	
	//bouncing cube example:::
	if (movingUp)	
		yLocation -= 0.005f;
	else
		yLocation += 0.005f;
		
	if(yLocation < -3.0f)
		movingUp = false;
	else if(yLocation > 3.0f)
		movingUp = true;
		
	yRotationAngle += 0.0005f;
	if(yRotationAngle > 360.0f)
		yRotationAngle -= 360.0f;
*/
}

int main(int argc, char **argv) {
	

    glutInit(&argc, argv); //initialize glut
    
	glutInitDisplayMode(GLUT_SINGLE); //sets up a display buffer
	
	glutInitWindowSize(750,750); //set the width and height of the displayed window
    
	glutInitWindowPosition(100,100); //position of the actual window on the screen
	
	glutCreateWindow("Model of Eye");

	glutDisplayFunc(display);
	glutIdleFunc(display);  // has to do with the rotation and transformations
	glutReshapeFunc(reshape); //tells GLUT to use our reshape method
	

	glutKeyboardFunc(keyPressed);
	glutKeyboardUpFunc(keyUp);
	
	glutMainLoop();
    
}