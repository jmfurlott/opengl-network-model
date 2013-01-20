//
//  OptionViewController.h
//  Retinopathy Model
//
//  Created by Joseph Furlott on 1/19/13.
//  Copyright (c) 2013 Joseph Furlott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Options.h";

@interface OptionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSArray *options;
}


@property (nonatomic, retain) NSArray *options;


@end
