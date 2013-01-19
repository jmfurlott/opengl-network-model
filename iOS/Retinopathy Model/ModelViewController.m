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
const GLfloat offset[4] = {-1.0f, -.5f, 0.0f, 1.0f};
float rot[16] = {1.0f, 0.0f, 0.0f, 0.0f,
                  0.0f, 1.0f, 0.0f, 0.0f,
                    0.0f, 0.0f, 1.0f, 0.0f,
    0.0f, 0.0f, 0.0f, 1.0f};

float rot0[4] = {1.0f, 0.0f, 0.0f, 0.0f};
float rot1[4] = {0.0f, 1.0f, 0.0f, 0.0f};
float rot2[4] = {0.0f, 0.0f, 1.0f, 0.0f};
float rot3[4] = {0.0f, 0.0f, 0.0f, 1.0f};

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
    
    
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handlePinch:)];
    [self.view addGestureRecognizer:pinchGesture];
    //[pinchGesture release];
    
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
    


    
    

    glDrawArrays(GL_LINES, 0, 13100);
}


#pragma mark - GLKViewControllerDelegate

- (void)update {
    
    if(!([recognizer state] == UIGestureRecognizerStateBegan)) {
        
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
    
    
    if (scale < 2.0) {
        scale += 0.005;
    }
        
    
}



-(void) viewDidUnload {
    [super viewDidUnload];
    
    GLKView *view = (GLKView *) self.view;
    [EAGLContext setCurrentContext:view.context];
    
    if(0 != vertexBufferID ) {
        glDeleteBuffers(1, &vertexBufferID);
        vertexBufferID = 0;
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
    
    
    GLfloat eyeVertices[[onlyCoords count]];
    for(int i = 0; i < [onlyCoords count]; i++) {
        eyeVertices[i] = ([[onlyCoords objectAtIndex:i] intValue]);
    }
    for(int i = 0; i < [onlyCoords count]; i++) {
        eyeVertices[i] = (eyeVertices[i]/2000);
    }
    
    
    GLfloat colors[[colorArray count]]; //need four for every point; RGBA
    for(int i = 0; i < [colorArray count]; i++) {
        colors[i] = ([[colorArray objectAtIndex:i] intValue]/255);
    }
    

    
    
    
    GLint vertexLoc = glGetAttribLocation(program, "a_position");
    //NSLog([NSString stringWithFormat:@"vertexLoc position: %d", vertexLoc]);

    
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, eyeVertices);
    glEnableVertexAttribArray(0);
    
    GLint colorLoc = glGetAttribLocation(program, "a_color");
    //NSLog([NSString stringWithFormat:@"a_color position: %d", colorLoc]);
    glVertexAttribPointer(colorLoc, 4, GL_FLOAT, GL_FALSE, 0, colors);
    glEnableVertexAttribArray(colorLoc);
    

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
    
    glBindAttribLocation(program, vertexLoc, "a_position");
    glBindAttribLocation(program, colorLoc, "a_color");
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
    
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    
    _anchor_position = GLKVector3Make(location.x, location.y, 0);
    _anchor_position = [self projectOntoSurface:_anchor_position];
    
    _current_position = _anchor_position;
    
    _quatStart = _quat;

    
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //    _current_position = GLKVector3Make(location.x, location.y, 0);
    //    _current_position = [self projectOntoSurface:_current_position];
    
    
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    CGPoint lastLoc = [touch previousLocationInView:self.view];
    CGPoint diff = CGPointMake(lastLoc.x - location.x, lastLoc.y - location.y);
    
    float rotX = -1 * GLKMathDegreesToRadians(diff.y / 2.0);
    float rotY = -1 * GLKMathDegreesToRadians(diff.x / 2.0);
    
    GLKVector3 xAxis = GLKVector3Make(1, 0, 0);
    _rotMatrix = GLKMatrix4Rotate(_rotMatrix, rotX, xAxis.x, xAxis.y, xAxis.z);
    GLKVector3 yAxis = GLKVector3Make(0, 1, 0);
    _rotMatrix = GLKMatrix4Rotate(_rotMatrix, rotY, yAxis.x, yAxis.y, yAxis.z);
    
    _current_position = GLKVector3Make(location.x, location.y, 0);
    _current_position = [self projectOntoSurface:_current_position];
    


    
    
    
    
    
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
     [self computeIncremental];
    
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    if([recognizer state] == UIGestureRecognizerStateBegan) {
        NSLog([NSString stringWithFormat:@"%f", recognizer.velocity]);
        //so velocity is positive if zooming in (fingers getting further apart)
        // = negative if pinching, so zoom out
        
        //call zoom function
        GLKMatrix4 scaled = GLKMatrix4Scale(modelViewMatrix, 1.0f, 1.0f, recognizer.velocity);
        self.baseEffect.transform.modelviewMatrix = scaled;
        
        
        //scale = recognizer.velocity;
        
        
    }
}


//shader methods here ---------------------------------------------------------------------
//current stack to call:

/*
 1. loadShader
 2. attachAndLinkShaders
 3. glUseProgram(userData->programObject)
 
 */

- (GLuint) loadShader: (GLenum)type from:(char *)shaderSrc {
    GLuint shader;
    GLint compiled;
    
    //shader object
    shader = glCreateShader(type);
    
    //error checking that the object got built
    if(shader == 0) {
        return 0;
    }
    
    //source
    glShaderSource(shader, 1, &shaderSrc, NULL);
    
    //compile
    glCompileShader(shader);
    
    //eror control again
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled); //this should be logged?
    
    if(!compiled) {
        GLint infoLen = 0;
        //print out that log
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);
        if(infoLen > 1) {
            char* infoLog = malloc(sizeof(char) * infoLen);
            
            glGetShaderInfoLog(shader, infoLen, NULL, infoLog);
            //esLogMessage("Error compiling shader:\n%s\n", infoLog);
        
            free(infoLog);
        }
        
        glDeleteShader(shader);
        return 0;
    }
    //if there have been no errors, then return our shader
    return shader;
    
    
}

//method to create (using the method before), attach, and link programs
- (Boolean) attachAndLinkShaders {
    //create the program
    programObject = glCreateProgram();
    
    if(programObject == 0) {
        return 0;
    }
    
    
    //attach to our empty program both the shaders
    glAttachShader(programObject, vertexShader);
    glAttachShader(programObject, fragmentShader);
    
    //link the program
    glLinkProgram(programObject);
    
    
    //error checking to make sure its been attached and linked
    glGetProgramiv(programObject, GL_LINK_STATUS, &linked);
    
    if(!linked) {
        GLuint infoLen = 0;
        
        glGetProgramiv(programObject, GL_INFO_LOG_LENGTH, &infoLen);
        
        if(infoLen > 0) {
            char* infoLog = malloc(sizeof(char) * infoLen);
            glGetProgramInfoLog(programObject, infoLen, NULL, infoLog);
            NSLog([NSString stringWithFormat:@"Error linking program:\n%s\n", infoLog]);
            
            free(infoLog);
        }
        
        //we know it has errors so delete it
        glDeleteProgram(programObject);
        return FALSE;
        
    }
    
    return TRUE;
}








@end
