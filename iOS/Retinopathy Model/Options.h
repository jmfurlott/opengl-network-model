//
//  Options.h
//  Retinopathy Model
//
//  Created by Joseph Furlott on 1/19/13.
//  Copyright (c) 2013 Joseph Furlott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Options : NSObject {
    NSString *option;
}

@property(nonatomic, retain) NSString *option;

+(Options*) getInstance;

@end
