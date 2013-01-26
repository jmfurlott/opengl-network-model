//January 6, 2013 - Joseph Furlott
//Most of code taken from tutorial but will provide working app for testing and dev

//text file format:
// X1  Y1  Z1  X2  Y2  Z2  D  A/V

#import "ModelViewController.h"



@interface ModelViewController()

@end

@implementation ModelViewController

@synthesize baseEffect;



NSArray *file;
NSArray *onlyCoords;
CGPoint startLoc;
NSArray *colorArray;
float dx;
float dy;
CGRect screen;
float mAngle;
float TOUCH_SCALE_FACTOR; //from android
//CGPoint location;
bool zooming = false;
UIPinchGestureRecognizer* recognizer;
GLuint program;
//const GLfloat offset[4] = {-1.0f, -.5f, 0.0f, 1.0f};
float rot[16] = {1.0f, 0.0f, 0.0f, 0.0f,
    0.0f, 1.0f, 0.0f, 0.0f,
    0.0f, 0.0f, 1.0f, 0.0f,
    0.0f, 0.0f, 0.0f, 1.0f};

float rot0[4] = {1.0f, 0.0f, 0.0f, 0.0f};
float rot1[4] = {0.0f, 1.0f, 0.0f, 0.0f};
float rot2[4] = {0.0f, 0.0f, 1.0f, 0.0f};
float rot3[4] = {0.0f, 0.0f, 0.0f, 1.0f};

GLfloat eyeVertices[169032]; //cheating
GLfloat cylinders[169032*36]; //where 6 must stay congruent with the number of sides per cylinder
GLfloat colors[56336];

GLint totalLines = 1;
int offset = 0;

GLuint vertexArray;
GLuint vertexBuffer;

float scale = 1.0f;

enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    file = [self readTextFromFile];
    //this coordinates array doesn't really start until position 15
    //also contains the diameter and vessel color
    onlyCoords = [self constructCoordinates:file];
    colorArray = [self buildColorArray:file];
    
    //GLfloat eyeVertices[[onlyCoords count]];
    for(int i = 0; i < [onlyCoords count]; i++) {
        eyeVertices[i] = ([[onlyCoords objectAtIndex:i] intValue]);
    }
    for(int i = 0; i < [onlyCoords count]; i++) {
        eyeVertices[i] = (eyeVertices[i]/2000);
    }
    
    //GLfloat colors[[colorArray count]]; //need four for every point; RGBA
    for(int i = 0; i < [colorArray count]; i++) {
        colors[i] = ([[colorArray objectAtIndex:i] intValue]/255);
    }
    
    //NSLog(@"sizeof colors: %d", sizeof(colors));
    //NSLog(@"sizeof colorarray: %d", [colorArray count]);
    
    totalLines = [onlyCoords count]/3;
    NSLog(@"total number of lines: %d", totalLines);
    
    
    
    
    
    //TESTING cylinders
    //NSMutableArray* test = [NSMutableArray alloc];
    //test = [self constructAllCylinders];
//    offset = 0;
//    for(int i = 0; i < sizeof(eyeVertices); i = i + 6) { //not sure if six
//        [self createCylinderCoordinates:eyeVertices[i] y0:eyeVertices[i+1] z0:eyeVertices[i+2] x1:eyeVertices[i+3] y1:eyeVertices[i+4] z1:eyeVertices[i+5] radius:0.0001f];
//    }
//    
//    NSLog(@"size of the test cylindrical array: %d", sizeof(cylinders));
//    
//    
//    
    

    
  //  NSLog(@"sizeof eyeVertices: %d", sizeof(eyeVertices));
   // NSLog(@"sizeof colorArray: %d", sizeof(colors));
    
    //to handle double tapping
    UITapGestureRecognizer *doubleTapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTapRec.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTapRec];
    
    
    _quat = GLKQuaternionMake(0, 0, 0, 1);
    _quatStart = GLKQuaternionMake(0, 0, 0, 1);
    
    GLKView *view = (GLKView *) self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"View controller's view is not a GLKView");
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    self.baseEffect = [[GLKBaseEffect alloc] init];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) glkView:(GLKView *) view drawInRect:(CGRect)rect {
    [self.baseEffect prepareToDraw];
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    
    [self setUpVerticesAndShaders];
    
    
    
    
    
    
    glDrawArrays(GL_LINES, 0, totalLines);
    
    glDisableVertexAttribArray(0);
    glDisableVertexAttribArray(1);
    glDeleteBuffers(2, vertexBufferID);
}


#pragma mark - GLKViewControllerDelegate

- (void)update {
    
    
    Options *opt = [Options getInstance];
    NSLog(opt.option);
    
    
    //in case we are double tapping:::
    //if we have double tapped, _quat will have been re-defined
    if(_slerping) {
        NSLog(@"trying to slerp");
        _slerpCur += self.timeSinceLastUpdate;
        float slerpAmt = _slerpCur/_slerpMax;
        if(slerpAmt > 1.0) {
            slerpAmt = 1.0;
            _slerping = NO;
        }
        _quat = GLKQuaternionSlerp(_slerpStart, _slerpEnd, slerpAmt);
    }
    
    
    GLKMatrix4 rotation = GLKMatrix4MakeWithQuaternion(_quat);
    
    rot0[0] = rotation.m00;
    rot0[1] = rotation.m10;
    rot0[2] = rotation.m20;
    rot0[3] = rotation.m30;
    
    rot1[0] = rotation.m01;
    rot1[1] = rotation.m11;
    rot1[2] = rotation.m21;
    rot1[3] = rotation.m31;
    
    rot2[0] = rotation.m02;
    rot2[1] = rotation.m12;
    rot2[2] = rotation.m22;
    rot2[3] = rotation.m32;
    
    rot3[0] = rotation.m03;
    rot3[1] = rotation.m13;
    rot3[2] = rotation.m23;
    rot3[3] = rotation.m33;
    
    
    
    
}



-(void) viewDidUnload {
    [super viewDidUnload];
    
    GLKView *view = (GLKView *) self.view;
    [EAGLContext setCurrentContext:view.context];
    
    if(0 != vertexBufferID ) {
        glDeleteBuffers(1, &vertexBufferID);
        vertexBufferID[0] = 0;
    }
}


- (NSArray*) readTextFromFile {
    //NSLog(@"Starting to read in text:");
    
    //file for now will be hard coded as Coordinates10.txt
    //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Coordinates10" ofType:@"txt"];
    //NSData *coordData = [NSData dataWithContentsOfFile:filePath];
    
    NSError *fileError = nil;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Coordinates10" ofType:@"txt"];
    
    NSString *contents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&fileError ];
    if (contents == nil) {
        NSLog(@"FileError: %@", [fileError localizedDescription]);
    } else {
        //correctly reading!!!
        
        NSArray *values = [contents componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //NSLog([NSString stringWithFormat:@"%d", [values count]]);
        
        //NSLog([values objectAtIndex:15]); //because of whitespace, actually coordinats start at 15
        
        return values;
    }
    
    return nil;
    
}

//now assuming I have the list of everything but what if I want only coordinates?
- (NSArray*) constructCoordinates: (NSArray*) total  {
    NSMutableArray *coordinates = [[NSMutableArray alloc] initWithCapacity:[total count]]; //double check that this the correct size everytime
    
    for (int i = 15; i < [total count] - 7; i += 8) { //fix the correct total count!!
        NSString *x0 = [total objectAtIndex:i];
        NSString *y0 = [total objectAtIndex:i + 1];
        NSString *z0 = [total objectAtIndex:i + 2];
        
        NSString *x1 = [total objectAtIndex:i + 3];
        NSString *y1 = [total objectAtIndex:i + 4];
        NSString *z1 = [total objectAtIndex:i + 5];
        
        //skip the diameter and vessel color!
        [coordinates addObject:x0];
        [coordinates addObject:y0];
        [coordinates addObject:z0];
        [coordinates addObject:x1];
        [coordinates addObject:y1];
        [coordinates addObject:z1];
        
        
        
    }
    
    return coordinates;
    
}






//implement here
- (NSArray *) buildColorArray: (NSArray*) total {
    NSMutableArray *colors = [[NSMutableArray alloc] initWithCapacity:([total count]/4)];
    
    
    for (int i = 22; i < [total count] - 7; i += 8) { //fix the correct total count!!
        NSString *tempColor = [total objectAtIndex:i];
        //NSLog(tempColor);
        if([tempColor intValue] == 1) {
            [colors addObject:@"255"];
            [colors addObject:@"0"];
            [colors addObject:@"0"];
            [colors addObject:@"255"]; //if 1 == red in RGBA
            [colors addObject:@"255"];
            [colors addObject:@"0"];
            [colors addObject:@"0"];
            [colors addObject:@"255"]; //if 1 == red in RGBA
        } else if([tempColor intValue] == 0) {
            [colors addObject:@"0"];
            [colors addObject:@"0"];
            [colors addObject:@"255"];
            [colors addObject:@"255"]; //if 1 == blue in RGBA
            [colors addObject:@"0"];
            [colors addObject:@"0"];
            [colors addObject:@"255"];
            [colors addObject:@"255"]; //if 1 == blue in RGBA
            
        }
        
        
        
        
        
    }
    
    NSLog(@"size of the mutable color array: %d", [colors count]);
    return colors;
    
}






-(void) setUpVerticesAndShaders {
    //NSLog([NSString stringWithFormat:@"%d", )]);
    
    NSString *vertexShaderSource = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"] encoding:NSUTF8StringEncoding error:nil];
    const char *vertexShaderSourceCString = [vertexShaderSource cStringUsingEncoding:NSUTF8StringEncoding];
    
    
    GLuint vertexShader0 = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertexShader0, 1, &vertexShaderSourceCString, NULL);
    glCompileShader(vertexShader0);
    
    NSString *fragmentShaderSource = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"] encoding:NSUTF8StringEncoding error:nil];
    const char *fragmentShaderSourceCString = [fragmentShaderSource cStringUsingEncoding:NSUTF8StringEncoding];
    
    
    GLuint fragmentShader0 = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader0, 1, &fragmentShaderSourceCString, NULL);
    glCompileShader(fragmentShader0);
    
    GLuint program = glCreateProgram();
    glAttachShader(program, vertexShader0);
    glAttachShader(program, fragmentShader0);
    glLinkProgram(program);
    
    glUseProgram(program);
    


    

    
  //  NSLog(@"sizeof colors: %d", sizeof(colors));
  //  NSLog(@"sizeof colorarray: %d", [colorArray count]);

    //GLint vertexLoc = glGetAttribLocation(program, "a_position");
    //NSLog([NSString stringWithFormat:@"vertexLoc position: %d", vertexLoc]);
    
    
    //glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, eyeVertices);
    
    glGenBuffers(2, &vertexBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID[0]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(eyeVertices), eyeVertices, GL_STATIC_DRAW);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);
    
    glEnableVertexAttribArray(0);
    
    
    //now colors using that same vbo!!
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID[1]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(colors), colors, GL_STATIC_DRAW);
    glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 0, 0);
    
    //GLint colorLoc = glGetAttribLocation(program, "a_color");
    //NSLog([NSString stringWithFormat:@"a_color position: %d", colorLoc]);
   //glVertexAttribPointer(colorLoc, 4, GL_FLOAT, GL_FALSE, 0, colors);
    glEnableVertexAttribArray(1);
    
    
    //now the rotation matrix
    GLint rot0Pos = glGetUniformLocation(program, "rot_0");
    glUniform4fv(rot0Pos, 1, rot0);
    //NSLog([NSString stringWithFormat:@"rot0: %d", rot0Pos]);
    
    GLint rot1Pos = glGetUniformLocation(program, "rot1");
    glUniform4fv(rot1Pos, 1, rot1);
    //NSLog([NSString stringWithFormat:@"rot1: %d", rot1Pos]);
    
    
    GLint rot2Pos = glGetUniformLocation(program, "rot2");
    glUniform4fv(rot2Pos, 1, rot2);
    //NSLog([NSString stringWithFormat:@"rot2: %d", rot2Pos]);
    
    
    GLint rot3Pos = glGetUniformLocation(program, "rot3");
    glUniform4fv(rot3Pos, 1, rot3);
    //NSLog([NSString stringWithFormat:@"rot3: %d", rot3Pos]);
    
    GLint scalePos = glGetUniformLocation(program, "scale");
    glUniform1f(scalePos, scale);
    
    glBindAttribLocation(program, 0, "a_position");
    glBindAttribLocation(program, 1, "a_color");

}





//quaternion stuff
- (GLKVector3) projectOntoSurface:(GLKVector3) touchPoint
{
    float radius = self.view.bounds.size.width/3;
    GLKVector3 center = GLKVector3Make(self.view.bounds.size.width/2, self.view.bounds.size.height/2, 0);
    GLKVector3 P = GLKVector3Subtract(touchPoint, center);
    
    // Flip the y-axis because pixel coords increase toward the bottom.
    P = GLKVector3Make(P.x, P.y * -1, P.z);
    
    float radius2 = radius * radius;
    float length2 = P.x*P.x + P.y*P.y;
    
    if (length2 <= radius2)
        P.z = sqrt(radius2 - length2);
    else
    {
        P.x *= radius / sqrt(length2);
        P.y *= radius / sqrt(length2);
        P.z = 0;
    }
    
    return GLKVector3Normalize(P);
}


- (void)computeIncremental {
    
    GLKVector3 axis = GLKVector3CrossProduct(_anchor_position, _current_position);
    float dot = GLKVector3DotProduct(_anchor_position, _current_position);
    float angle = acosf(dot);
    
    GLKQuaternion Q_rot = GLKQuaternionMakeWithAngleAndVector3Axis(angle * 2, axis);
    Q_rot = GLKQuaternionNormalize(Q_rot);
    
    // TODO: Do something with Q_rot...
    
    _quat = GLKQuaternionMultiply(Q_rot, _quatStart);
    
    
}



//touches stuff
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    float backup = scale;
    NSSet *allTouches = [event allTouches];
    int totalNumTouches = [allTouches count];
    
    if(totalNumTouches == 1) {
        UITouch * touch = [[allTouches allObjects] objectAtIndex:0];
        CGPoint location = [touch locationInView:self.view];
        
        _anchor_position = GLKVector3Make(location.x, location.y, 0);
        _anchor_position = [self projectOntoSurface:_anchor_position];
        
        _current_position = _anchor_position;
        
        _quatStart = _quat;
        scale = backup;

    } else {
        scale = backup;
    }
    
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //grabs all the touches and puts it into a set
    NSSet *allTouches = [event allTouches];
    int totalNumTouches = [allTouches count];
    NSLog(@"Number of touches: %d", totalNumTouches);

    //so basically if you are doing one touch then you know to do arcball rotation
    //but if you have two touches drops into pinch and zoom (here using euclidean distance
    
    
    if(totalNumTouches == 1) {
        UITouch * touch = [touches anyObject];
        CGPoint location = [touch locationInView:self.view];
        CGPoint lastLoc = [touch previousLocationInView:self.view];
        CGPoint diff = CGPointMake(lastLoc.x - location.x, lastLoc.y - location.y);
        
        
        _current_position = GLKVector3Make(location.x, location.y, 0);
        _current_position = [self projectOntoSurface:_current_position];
        //scale = 1.0f;

    
       
    } else if([allTouches count] > 1) {
        //double touch stuff

        UITouch *touch0 = [[allTouches allObjects] objectAtIndex:0]; //first touch
        UITouch *touch1 = [[allTouches allObjects] objectAtIndex:1]; //second touch
    
        CGPoint p0 = [touch0 locationInView:self.view];
        CGPoint p1 = [touch1 locationInView:self.view]; //coordinates of both points
        
        //now need to calculate the distance between the two and set that to scale!
        //we'll try the euclidean distance sqrt((p1.x - p0.x)^2 + (p1.y - p0.y)^2)
        float xdiff = p1.x - p0.x;
        //NSLog(@"xdiff: %f", xdiff);
        float ydiff = p1.y - p0.y;
        //NSLog(@"ydiff: %f", ydiff);
        
        //and find the distance and set it to scale which goes to the shader
        scale = sqrt((xdiff*xdiff) + (ydiff*ydiff))/400; //400 here is arbitrary because it made the most sense after
                                                         //a few quick checks but depending on screen size and RATE at
                                                         //which you want to scale, change it. 400 is good for iPad 2
        NSLog(@"euclidean distance: %f", scale);
        
        
    
    } else {
        scale = 1.0f;
    }
    
    
    
    
    
    //putting this here helps speed up the rotation effect...still kind of slow
    [self computeIncremental];
    
    
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // [self computeIncremental];
    //scale = 1.0f;
    
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    scale = 1.0f;
}

//gestures like pinch and zoom, and double tap

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}




//double tap
-(void) doubleTap:(UITapGestureRecognizer *) sender {
    
    NSLog(@"caught tap");
    _slerping = YES;
    _slerpCur = 0;
    _slerpMax = 1.0;
    _slerpStart = _quat;
    _slerpEnd = GLKQuaternionMake(0,0,0,1);
    
}





//--------------------------------------------------------------------HEXAGON BUILDING
-(NSMutableArray*) buildCylinder: (float)x0 y0:(float)y0 z0:(float)z0 x1:(float)x1 y1:(float)y1 z1:(float)z1 radius:(float)radius {
    //add these coordinates to cylinderVertces which has already been defined
    
    
    GLfloat cylinderVertices[108];
    NSMutableArray* cylArray = [NSMutableArray alloc];
    
    if(radius < 0) { //checking errors
        radius = radius * (-1);
    }
    
    float xprime = radius*cos(60);
    float yprime = radius*sin(60);
    
    
    //--------------------------------------------------------------------first rectangle
    cylinderVertices[0] = x0 - radius; cylinderVertices[1] = y0; cylinderVertices[2] = z0;
    
    cylinderVertices[3] = x0 - xprime; cylinderVertices[4] = y0 + yprime; cylinderVertices[5] = z0;
    
    cylinderVertices[6] = x1 - radius; cylinderVertices[7] = y1; cylinderVertices[8] = z1;
    
    
    cylinderVertices[9] = x0 - xprime; cylinderVertices[10] = y0 + yprime; cylinderVertices[11] = z0;
    
    cylinderVertices[12] = x1 - radius; cylinderVertices[13] = y1; cylinderVertices[14] = z1;
    
    cylinderVertices[15] = x1 - xprime; cylinderVertices[16] = y1 + yprime; cylinderVertices[17] = z1;
    
    
    
    
    //--------------------------------------------------------------------2nd
    
    cylinderVertices[18] = x0 - xprime; cylinderVertices[19] = y0 + yprime; cylinderVertices[20] = z0;
    
    cylinderVertices[21] = x0 + xprime; cylinderVertices[22] = y0 + yprime; cylinderVertices[23] = z0;
    
    cylinderVertices[24] = x1 - xprime; cylinderVertices[25] = y1 + yprime; cylinderVertices[26] = z1;
    
    
    
    cylinderVertices[27] = x0 + xprime; cylinderVertices[28] = y0 + yprime; cylinderVertices[29] = z0;
    
    cylinderVertices[30] = x1 - xprime; cylinderVertices[31] = y1 + yprime; cylinderVertices[32] = z1;
    
    cylinderVertices[33] = x1 + xprime; cylinderVertices[34] = y1 + yprime; cylinderVertices[35] = z1;
    
    
    
    //--------------------------------------------------------------------3rd
    
    cylinderVertices[36] = x0 + xprime; cylinderVertices[37] = y0 + yprime; cylinderVertices[38] = z0;
    
    cylinderVertices[39] = x0 + radius; cylinderVertices[40] = y0 + yprime; cylinderVertices[41] = z0;
    
    cylinderVertices[42] = x1 + xprime; cylinderVertices[43] = y1 + yprime; cylinderVertices[44] = z1;
    
    
    cylinderVertices[45] = x0 + radius; cylinderVertices[46] = y0; cylinderVertices[47] = z0;
    
    cylinderVertices[48] = x1 + xprime; cylinderVertices[49] = y1 + yprime; cylinderVertices[50] = z1;
    
    cylinderVertices[51] = x1 + radius; cylinderVertices[52] = y1; cylinderVertices[53] = z1;
    
    
    
    //--------------------------------------------------------------------4th
    
    cylinderVertices[54] = x0 + radius; cylinderVertices[55] = y0; cylinderVertices[56] = z0;
    
    cylinderVertices[57] = x0 + xprime; cylinderVertices[58] = y0 - yprime; cylinderVertices[59] = z0;
    
    cylinderVertices[60] = x1 + radius; cylinderVertices[61] = y1; cylinderVertices[62] = z1;
    
    
    cylinderVertices[63] = x0 + xprime; cylinderVertices[64] = y0 - yprime; cylinderVertices[65] = z0;
    
    cylinderVertices[66] = x1 + radius; cylinderVertices[67] = y1; cylinderVertices[68] = z1;
    
    cylinderVertices[69] = x1 + xprime; cylinderVertices[70] = y1 - yprime; cylinderVertices[71] = z1;
    
    
    
    //--------------------------------------------------------------------5th
    
    cylinderVertices[72] = x0 + xprime; cylinderVertices[73] = y0 - yprime; cylinderVertices[74] = z0;
    
    cylinderVertices[75] = x0 - xprime; cylinderVertices[76] = y0 - yprime; cylinderVertices[77] = z0;
    
    cylinderVertices[78] = x1 + xprime; cylinderVertices[79] = y1 - yprime; cylinderVertices[80] = z1;
    
    
    cylinderVertices[81] = x0 - xprime; cylinderVertices[82] = y0 - yprime; cylinderVertices[83] = z0;
    
    cylinderVertices[84] = x1 + xprime; cylinderVertices[85] = y1 - yprime; cylinderVertices[86] = z1;
    
    cylinderVertices[87] = x1 - xprime; cylinderVertices[88] = y1 - yprime; cylinderVertices[89] = z1;
    
    
    
    
    //--------------------------------------------------------------------6th
    
    cylinderVertices[90] = x0 - xprime; cylinderVertices[91] = y0 - yprime; cylinderVertices[92] = z0;
    
    cylinderVertices[93] = x0 - radius; cylinderVertices[94] = y0; cylinderVertices[95] = z0;
    
    cylinderVertices[96] = x1 - xprime; cylinderVertices[97] = y1 - yprime; cylinderVertices[98] = z1;
    
    
    cylinderVertices[99] = x0 - radius; cylinderVertices[100] = y0; cylinderVertices[101] = z0;
    
    cylinderVertices[102] = x1 - xprime; cylinderVertices[103] = y1 - yprime; cylinderVertices[104] = z1;
    
    cylinderVertices[105] = x1 - radius; cylinderVertices[106] = y1; cylinderVertices[107] = z1;

    
    //least efficient way
    for(int i = 0; i < 108; i++) {
        [cylArray addObject:[NSString stringWithFormat:@"%f", cylinderVertices[i]]];
    }
    
    return cylArray;
    
}


-(NSMutableArray*) constructAllCylinders {
    //will take in the eyeVertices float[] and construct a new one called cylinders
    //as of right now both these arrays have that memory allocated so nothing to return or take as parameters
    //no radius yet!!!!! assuming radius is uniform
    
    NSMutableArray* finalCoords = [NSMutableArray alloc]; //final answer
    
    for(int i = 0; i < sizeof(eyeVertices); i = i + 6) { //i+6 because want to does for each SEGMENT
        
        NSMutableArray* temp = [NSMutableArray alloc];
        temp = [self buildCylinder:eyeVertices[i] y0:eyeVertices[i+1] z0:eyeVertices[i+2] x1:eyeVertices[i+3] y1:eyeVertices[i+4] z1:eyeVertices[i+5] radius:0.1f];
        
        
        //now that all those cylindrical vertices are constructed need to add them back to BIG array list
        for(int j = 0; j < 108; j++) {
            [finalCoords addObject:[temp objectAtIndex:j]];
        }
        
        //then delete that temp array so we can use it again
        temp = nil;
        
        
    }
    
    
    return finalCoords;
    //returned as strings in there
    
    
    
}


//this method is not working correctly but will surely be used before the others!!!
- (void) createCylinderCoordinates: (float)x0 y0:(float)y0 z0:(float)z0 x1:(float)x1 y1:(float)y1 z1:(float)z1 radius:(float)radius {
    //maybe need to include offset to fill in the cylinders array
    
    float sides = 6; //what is the best performance vs. detail here???
    
    //need to calculate height. this can be done via the euclidean distance..
    float height = sqrtf((x0-x1)*(x0-x1) + (y0-y1)*(y0-y1) + (z0-z1)*(z0-z1)); //double check
    //do we need to do any scaling?!?!!?
    
    const theta = 2*M_PI/sides;
    
    float c = cos(theta);
    float s = sin(theta); //get our angles
    
    float x2 = radius;
    float z2 = 0;
    
    //offset variable refers to how far along I should be in the whole cylinder list of coordinates
    
    for(int i = 0; i <= sides; i++) {
        
        cylinders[offset] = x0 + x2;
        offset++;
        cylinders[offset] = y0;
        offset++;
        cylinders[offset] = z0 + z2;
        offset++;
        
        cylinders[offset] = x0 + x2;
        offset++;
        cylinders[offset] = y0 + height;
        offset++;
        cylinders[offset] = z0 + z2;
        offset++;
        
        const float x3 = x2;
        x2 = c*x2 - s*z2;
        z2 = s*x3 + c*z2;
        
    }
}





@end
