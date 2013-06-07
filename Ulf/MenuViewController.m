//
//  MenuViewController.m
//  Ulf
//
//  Created by Carl Ambroselli on 05.06.13.
//  Copyright (c) 2013 iDev. All rights reserved.
//

#import "MenuViewController.h"

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
    NSData * jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://openmensa.org/api/v2/canteens/112/meals"]];
    if (jsonData != nil){
    NSArray * arrayData = [NSJSONSerialization
                 JSONObjectWithData: jsonData
                 options: NSJSONReadingMutableContainers
                 error:nil];
    
    NSString * meal  = [[[[arrayData objectAtIndex:0] objectForKey:@"meals"] objectAtIndex:0] objectForKey:@"name"];
    id price = [[[[[arrayData objectAtIndex:0] objectForKey:@"meals"] objectAtIndex:0] objectForKey:@"prices"] objectForKey:@"others"];
        
        self.menuLabel.text = meal;
    } else {
        self.menuLabel.text = @"Tagesessen konnte nicht geladen werden.";
    }
    


}


@end
