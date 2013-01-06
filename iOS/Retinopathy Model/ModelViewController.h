//
//  ModelViewController.h
//  Retinopathy Model
//
//  Created by Joseph Furlott on 1/6/13.
//  Copyright (c) 2013 Joseph Furlott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface ModelViewController : GLKViewController

- (NSArray *) readTextFromFile;
- (NSArray *) constructCoordinates: (NSArray*) total;

@end
