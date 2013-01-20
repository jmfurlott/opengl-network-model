//
//  OptionViewController.m
//  Retinopathy Model
//
//  Created by Joseph Furlott on 1/19/13.
//  Copyright (c) 2013 Joseph Furlott. All rights reserved.
//

#import "OptionViewController.h"

@interface OptionViewController ()

@end

@implementation OptionViewController
@synthesize options;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.options = [[NSArray alloc] initWithObjects:@"Arteries", @"Veins", @"Resistance", nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//table view cell methods::

//counts the number of cells need from our array
- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section {
    return [self.options count];
}

//what to do at each cell
- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifer = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        //not sure about this line without autorelease ^^^
    }
    
    //what to print at each cell (based simply off our array)
    cell.textLabel.text = [self.options objectAtIndex:[indexPath row]];
    
    return cell;
    
}

//responding to a click
- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //first deselect so button is no longer blue
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    // [indexPath row] gives me the object that was selection
    // 0 = arteries
    // 1 = veins
    // 2 = resistance (eventually)
    NSLog(@"Row selection: %d", [indexPath row]);
    
}



@end
