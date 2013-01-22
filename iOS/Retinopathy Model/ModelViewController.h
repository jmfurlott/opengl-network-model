//
//  ModelViewController.h
//  Retinopathy Model
//
//  Created by Joseph Furlott on 1/6/13.
//  Copyright (c) 2013 Joseph Furlott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "Options.h"


@interface ModelViewController : GLKViewController <UIGestureRecognizerDelegate> {
    GLuint vertexBufferID[2];
    GLuint colorBufferID;
    GLKVector3 _anchor_position;
    GLKVector3 _current_position;
    GLKQuaternion _quatStart;
    GLKQuaternion _quat;
    GLKMatrix4 _rotMatrix;
    GLKMatrix4 modelViewMatrix;
    GLuint programObject;
    GLuint vertexShader;
    GLuint fragmentShader;
    GLuint linked;

    
    //for double tapping and returning the model to its original place
    BOOL _slerping;
    float _slerpCur;
    float _slerpMax;
    GLKQuaternion _slerpStart;
    GLKQuaternion _slerpEnd;
    
}
@property (strong, nonatomic) GLKBaseEffect *baseEffect;


- (NSArray *) readTextFromFile;
- (NSArray *) constructCoordinates: (NSArray*) total;
- (NSArray *) buildColorArray: (NSArray*) total;
- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer;
- (GLuint) loadShader: (GLenum)type from:(char *)shaderSrc;
- (Boolean) attachAndLinkShaders;
- (void) doubleTap:(UITapGestureRecognizer *) tap;


extern NSArray *file;
extern NSArray *onlyCoords;
extern CGPoint startLoc;
extern float dy;
extern float dx;
extern NSArray *colorArray;

@end
