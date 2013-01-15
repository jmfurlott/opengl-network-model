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
CGPoint location;
bool zooming = false;
UIPinchGestureRecognizer* recognizer;


typedef struct {
    GLKVector3 positionCoords;
} SceneVertex;

//the actual vertices
static const SceneVertex vertices[] = {
    {{-0.5f, -0.5f, 0.0}},
    {{ 0.5f, -0.5f, 0.0}},
    {{-0.5f,  0.5f, 0,0}}
    
};



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    file = [self readTextFromFile];
    //this coordinates array doesn't really start until position 15
    //also contains the diameter and vessel color
    onlyCoords = [self constructCoordinates:file];
    colorArray = [self buildColorArray:file];
    
    
    NSLog([NSString stringWithFormat:@"%d", [colorArray count]]);
    for(int i = 0; i < 15; i++) {
        //NSLog([colorArray objectAtIndex:i]);
    }
    
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handlePinch:)];
    [self.view addGestureRecognizer:pinchGesture];
    //[pinchGesture release];
    
    
    //construct the vertuces into a float array:
    GLfloat eyeVertices[[onlyCoords count]];
    for(int i = 0; i < [onlyCoords count]; i++) {
        eyeVertices[i] = ([[onlyCoords objectAtIndex:i] intValue]);
    }
    
    for(int i = 0; i < [onlyCoords count]; i++) {
        eyeVertices[i] = (eyeVertices[i]/2000);
    }
    
    
    GLubyte colors[[colorArray count]]; //need four for every point; RGBA
    for(int i = 0; i < [colorArray count]; i++) {
        colors[i] = ([[colorArray objectAtIndex:i] intValue]);
    }
    
    
    GLKView *view = (GLKView *) self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"View controller's view is not a GLKView");
    
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    //    self.baseEffect.useConstantColor = GL_TRUE;
    //    self.baseEffect.constantColor = GLKVector4Make(1.0f, 0.0f, 0.0f, 1.0f);
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    glGenBuffers(1, &vertexBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(eyeVertices), eyeVertices, GL_STATIC_DRAW);
    
    
    
    
    
    
    
    
    //glGenBuffers(1, &colorBufferID);
    //glBindBuffer(GL_COLOR_BUFFER_BIT, colorBufferID);
    //glBufferData(GL_COLOR_BUFFER_BIT, sizeof(colors), colors, GL_STATIC_DRAW);
    
    //quaternion stuff
    _quat = GLKQuaternionMake(0, 0, 0, 1);
    _quatStart = GLKQuaternionMake(0, 0, 0, 1);
    
    _rotMatrix = GLKMatrix4Identity;
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) glkView:(GLKView *) view drawInRect:(CGRect)rect {
    [self.baseEffect prepareToDraw];
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    //NSLog([NSString stringWithFormat:@"%d", )]);
    
    glLineWidth(2.0);
    
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 12, NULL);
    
    glDrawArrays(GL_LINES, 0, 14080);
}


#pragma mark - GLKViewControllerDelegate

- (void)update {
    
    if(!([recognizer state] == UIGestureRecognizerStateBegan)) {
        modelViewMatrix = GLKMatrix4MakeTranslation(-1.0f, -.5f, 0.0f);
        modelViewMatrix = GLKMatrix4Multiply(modelViewMatrix, _rotMatrix);
        self.baseEffect.transform.modelviewMatrix = modelViewMatrix;
        
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
    
    //    UITouch * touch = [touches anyObject];
    //    location = [touch locationInView:self.view];
    //
    //    _anchor_position = GLKVector3Make(location.x, location.y, 0);
    //    _anchor_position = [self projectOntoSurface:_anchor_position];
    //
    //    _current_position = _anchor_position;
    //
    //
    //    _quatStart = _quat;
    
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
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // [self computeIncremental];
    
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
        
        
        
    }
}


@end
