//
//  OptionViewController.h
//  Retinopathy Model
//
//  Created by Joseph Furlott on 1/19/13.
//  Copyright (c) 2013 Joseph Furlott. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OptionViewControllerDelegate;


@interface OptionViewController : UITableViewController {
    id<OptionViewControllerDelegate> delegate;
}

@property (nonatomic, assign) id<OptionViewControllerDelegate> delegate;
@end


@protocol OptionViewControllerDelegate <NSObject>
-(void) OptionViewController:(OptionViewController *) OptionViewController didFinishWithSelection:(NSString *)selection;
//or maybe takes in a NSInteger as a parameter
@end
