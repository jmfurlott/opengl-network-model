//January 6, 2013 - Joseph Furlott
//Most of code taken from tutorial but will provide working app for testing and dev

//text file format:
// X1  Y1  Z1  X2  Y2  Z2  D  A/V

#import "ModelViewController.h"

NSArray *file;
NSArray *onlyCoords;
CGPoint startLoc;
NSArray *colorArray;
float dx;
float dy;
CGRect screen;
float mAngle;
float TOUCH_SCALE_FACTOR; //from android

@interface ModelViewController() {
    //empty constructor
}

@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

@end

@implementation ModelViewController

@synthesize context = _context;
@synthesize effect = _effect;

- (void) viewDidLoad {
    [super viewDidLoad];
    
    screen = [[UIScreen mainScreen] bounds];
    TOUCH_SCALE_FACTOR = 180.0/320;

    file = [self readTextFromFile];
    //this coordinates array doesn't really start until position 15
    //also contains the diameter and vessel color
    onlyCoords = [self constructCoordinates:file];
    colorArray = [self buildColorArray:file];

    
    NSLog([NSString stringWithFormat:@"%d", [colorArray count]]);
    for(int i = 0; i < 15; i++) {
        //NSLog([colorArray objectAtIndex:i]);
    }
    //now to the openGL::::::
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    
    if(!self.context) {
        NSLog(@"Failed to create ES context.");
    }
    
    GLKView *view = (GLKView *) self.view;
    
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:self.context];
    
    
    
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void) glkView:(GLKView *) view drawInRect: (CGRect) rect {
    

    
   
    //construct the vertuces into a float array:
    GLfloat eyeVertices[[onlyCoords count]];
    for(int i = 0; i < [onlyCoords count]; i++) {
        eyeVertices[i] = ([[onlyCoords objectAtIndex:i] intValue]);
    }
    
    for(int i = 0; i < [onlyCoords count]; i++) {
        eyeVertices[i] = (eyeVertices[i]/2000);
    }
    
    
    
    //need to build color array!
    //for now just doing one color: red (helps to figure out rendering)
    
    GLubyte colors[[colorArray count]]; //need four for every point; RGBA
    for(int i = 0; i < [colorArray count]; i++) {
        colors[i] = ([[colorArray objectAtIndex:i] intValue]);
    }
    
    
    
    
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    glTranslatef(-.75, -.5, 0.0);
    
    //motion tracking used!!!
    glRotatef(mAngle, 0.0, 1.0, 0.0);
    
    
    glLineWidth(3);
    
    glVertexPointer(3, GL_FLOAT, 0, eyeVertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, colors);
    glEnableClientState(GL_COLOR_ARRAY);
    
    //NSLog([NSString stringWithFormat:@"%d", sizeof(eyeVertices)]);
    glDrawArrays(GL_LINES, 0, 13000);
    
    
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);

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



//methods for determining the vertices, colors, and radius:
//to go into the constructor so they aren't called multiple times


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




//-------------------------------------------------------------where touch events are to go
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"Touches began"); //responding correctly.  but how to derive coordinates/motion?
    for (UITouch *touch in touches) {
        startLoc = [touch locationInView:nil];
    }
    
    
    //NSLog([[NSNumber numberWithFloat:startLoc.x] stringValue]);



}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for(UITouch *touch in touches) {
        CGPoint tracker = [[touches anyObject] locationInView:nil]; //where I am at in real time
    
    
        //calculate the differential and this will be used in the motion of the model
        dx = tracker.x - startLoc.x;
        dy = tracker.y - startLoc.y;
        
        
        if(tracker.y > screen.size.height/2) {
   //         dx = dx*-1;
        }
        if(tracker.x > screen.size.width/2) {
    //        dy = dy* -1;
        }
        
        //also need to set mAngle
        mAngle = ((dx+dy)*TOUCH_SCALE_FACTOR);
        
        //NSLog([[NSNumber numberWithFloat:dx] stringValue]);
    }
    


    
}


-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"Touches ended");
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touches cancelled");
}


@end


