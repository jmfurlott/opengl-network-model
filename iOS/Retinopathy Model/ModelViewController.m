//January 6, 2013 - Joseph Furlott
//Most of code taken from tutorial but will provide working app for testing and dev

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
    
    //how to call another method
    //this is where we read in the text!
    [self readTextFromFile];
    
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
    
    glTranslatef(0.0, (GLfloat) (sinf(transY)/2), 0.0);
    
    transY += 0.075f;
    
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



- (void) readTextFromFile {
    NSLog(@"Starting to read in text:");
    
    //file for now will be hard coded as Coordinates10.txt
    NSString *filename = @"Coordinates10.txt";
    
    
}

@end


