//Joseph Furlott
//Help from www.swiftless.com tutorials - needs proper credits

/*TODO:
 -menu system
 -camera and movement
 

*/

#include <GLUT/glut.h>
#include <iostream>
#include <fstream>
#include <vector>
#include <string>

using namespace std;


bool* keyStates = new bool[256];  //holds all the key values; 0 is not pressed, 1 is pressed
vector<float> coordinates(1);
int size;



//-------------------------------------------------------------get from text file
//to read in the coordinate file
int readCoordinates() {
    //first need to open the file
    ifstream file("CoordinatesAll.txt");
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
            coordinates.resize(i+2); //dynamically resize the vector such that it is always one ahead
        }
        
        size = coordinates.size();
        //so now the vector should hold the appropriate data
        //STILL NEED TO CONVERT TO FLOAT but just testing for now
        
        return 1;            
    }
	else {
		 cout << "Unable to open file";
        return 0;
    }

}



//-------------------------------------------------------------reshapes the window size (no objects)


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


//-------------------------------------------------------------how to handle key presses


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





//-------------------------------------------------------------rending the eye

//the actual rendering method that gets the vertices and draws the lines
void renderEye(void) {
	//start the beginning of the opengl call with glBegin

    int nothing = readCoordinates();
	//though there is more performance to use triangles with five vertices

    
    float tempColor;
    GLfloat tempDiameter;
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

    
    
}

//-------------------------------------------------------------the main window

void display(void) {
	keyOperations(); //should be done first always otherwise key presses could mess with the rendering
	

    glClearColor(0.0f,0.0f,0.0f,1.0f);
	glClear(GL_COLOR_BUFFER_BIT);
	glLoadIdentity();
	
	glTranslatef(-1.5f, -1.0f, -5.0f); //push the scene back that way can see everything
	renderEye(); 


	glFlush();

}



//-------------------------------------------------------------main method-what is running

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