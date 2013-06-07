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
    
    // start asynchron download
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSData * jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://openmensa.org/api/v2/canteens/112/meals"]];
        // callback routine
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (jsonData != nil){
                NSLog(@"Meal loaded");
                @try {
                    NSArray * arrayData = [NSJSONSerialization
                                           JSONObjectWithData: jsonData
                                           options: NSJSONReadingMutableContainers
                                           error:nil];
                                      
                    BOOL closed  = [[[arrayData objectAtIndex:0] objectForKey:@"closed"] boolValue];
                    
                    if(!closed){
                        // parsing Data
                        NSString * meal  = [[[[arrayData objectAtIndex:0] objectForKey:@"meals"] objectAtIndex:0] objectForKey:@"name"];
                        NSNumber * price = [[[[[arrayData objectAtIndex:0] objectForKey:@"meals"] objectAtIndex:0] objectForKey:@"prices"] objectForKey:@"others"];
                        // formating price
                        NSNumberFormatter * format = [[NSNumberFormatter alloc ] init];
                        [format setNumberStyle:NSNumberFormatterDecimalStyle];
                        [format setPositiveFormat: @"Preis: #.00€"];
                        // setting UILabels
                        self.menuLabel.text = meal;
                        self.priceLabel.text = [format stringFromNumber:price];
                        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                        hud.mode = MBProgressHUDModeCustomView;
                        hud.labelText = @"";
                        
                        
                    }
                    else{
                        // Ulf closed
                        self.menuLabel.text = @"Ulf's Cafe ist momentan leider geschlossen!";
                        self.priceLabel.text = @"";
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"FERIEN!");
                    self.menuLabel.text = @"Momentan ist leider kein Tagesessen verfügbar.";
                    self.priceLabel.text = @"";
                }
                
                
            } else {
                NSLog(@"Meal could not be retrieved");
                self.menuLabel.text = @"Tagesessen konnte nicht geladen werden.";
                self.priceLabel.text = @"";
            }
            [hud hide:YES afterDelay:0.5];
            
        });
    });
}


- (IBAction)refreshButtonPressed:(id)sender {
    [self loadMeal];
}
- (void)viewDidUnload {
    [self setPriceLabel:nil];
    [super viewDidUnload];
}
@end
