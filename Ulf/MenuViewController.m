//
//  MenuViewController.m
//  Ulf
//
//  Created by Carl Ambroselli on 05.06.13.
//  Copyright (c) 2013 iDev. All rights reserved.
//

#import "MenuViewController.h"
#import "MBProgressHUD.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"MenuViewDidAppear");
    [self loadMeal];
}

- (void)loadMeal
{
    NSLog(@"loading Meal");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Wird geladen...";
    
    NSData * jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://openmensa.org/api/v2/canteens/112/meals"]];
    if (jsonData != nil){
        NSLog(@"Meal loaded");
        NSArray * arrayData = [NSJSONSerialization
                 JSONObjectWithData: jsonData
                 options: NSJSONReadingMutableContainers
                 error:nil];
    
        NSString * meal  = [[[[arrayData objectAtIndex:0] objectForKey:@"meals"] objectAtIndex:0] objectForKey:@"name"];
        
        NSNumber * price = [[[[[arrayData objectAtIndex:0] objectForKey:@"meals"] objectAtIndex:0] objectForKey:@"prices"] objectForKey:@"others"];
        NSNumberFormatter * format = [[NSNumberFormatter alloc ] init];
        [format setNumberStyle:NSNumberFormatterDecimalStyle];
        [format setPositiveFormat: @"Preis: #.00€"];
        

        self.menuLabel.text = meal;
        self.priceLabel.text = [format stringFromNumber:price];
    } else {
        NSLog(@"Meal could not be retrieved");
        self.menuLabel.text = @"Tagesessen konnte nicht geladen werden.";
        self.priceLabel.text = @"";
    }
    [hud hide:YES];
}


- (IBAction)refreshButtonPressed:(id)sender {
    [self loadMeal];
}
- (void)viewDidUnload {
    [self setPriceLabel:nil];
    [super viewDidUnload];
}
@end
