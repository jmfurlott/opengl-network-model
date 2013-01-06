//January 6, 2013 - Joseph Furlott
//Most of code taken from tutorial but will provide working app for testing and dev

//text file format:
// X1  Y1  Z1  X2  Y2  Z2  D  A/V

#import "ModelViewController.h"

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
    
   
    
    //this is where we read in the text!
    NSArray *file = [self readTextFromFile];
        //this coordinates array doesn't really start until position 15
        //also contains the diameter and vessel color
    NSArray *onlyCoords = [self constructCoordinates:file];
    
    for(int i = 0; i < 15; i++) {
        NSLog([onlyCoords objectAtIndex:i]);
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
    static int counter = 0;
    
    static const GLfloat squareVertices[] = {
        -0.5, -0.33,
        0.5, -0.33,
        -0.5, 0.33,
        0.5, 0.33,
    };
    
    static const GLubyte squareColors[] = {
        255, 255, 0, 255,
        0, 255, 255, 255,
        0, 0, 0, 0,
        255, 0, 255, 255,
    };
    
    static float transY = 0.0;
    
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    glTranslatef(0.0, 0.0, 0.0);
    
    
    
    glVertexPointer(2, GL_FLOAT, 0, squareVertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
    glEnableClientState(GL_COLOR_ARRAY);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    if(!(counter%100)){
        //NSLog(@"FPS: %d\n", self.framesPerSecond);
    }
    counter++;
}



- (NSArray*) readTextFromFile {
    NSLog(@"Starting to read in text:");
    
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
- (NSArray*) constructCoordinates: (NSArray*) total {
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



@end


