// MY GLOBAL VARIABLE CLASS!!!! FOR CHANGING SETTINGS FROM POPUP OPTION MENU
//  Options.m
//  Retinopathy Model
//
//  Created by Joseph Furlott on 1/19/13.
//  Copyright (c) 2013 Joseph Furlott. All rights reserved.
//

#import "Options.h"

@implementation Options

@synthesize option;

//if nothing has bene initialized
static Options *instance = nil;

+(Options *) getInstance {
    @synchronized(self) {
        if(instance == nil) {
            instance = [Options new];
        }
    }
    
    return instance;
}


@end
