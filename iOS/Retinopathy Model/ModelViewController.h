//
//  ModelViewController.h
//  Retinopathy Model
//
//  Created by Joseph Furlott on 1/6/13.
//  Copyright (c) 2013 Joseph Furlott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>


@interface ModelViewController : GLKViewController <UIGestureRecognizerDelegate> {
    GLuint vertexBufferID;
    GLuint colorBufferID;
    GLKVector3 _anchor_position;
    GLKVector3 _current_position;
    GLKQuaternion _quatStart;
    GLKQuaternion _quat;
    GLKMatrix4 _rotMatrix;
    GLKMatrix4 modelViewMatrix;
    
}
@property (strong, nonatomic) GLKBaseEffect *baseEffect;


- (NSArray *) readTextFromFile;
- (NSArray *) constructCoordinates: (NSArray*) total;
- (NSArray *) buildColorArray: (NSArray*) total;
- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer;

extern NSArray *file;
extern NSArray *onlyCoords;
extern CGPoint startLoc;
extern float dy;
extern float dx;
extern NSArray *colorArray;

@end
