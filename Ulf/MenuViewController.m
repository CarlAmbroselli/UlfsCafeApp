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
    //    if FBSession is active load the meal
    //  else change to loginView to get a new FBSession

    if ( FBSession.activeSession.isOpen){
        NSLog(@"try to load Meal");
        [self loadMeal];
    } else {
        [self changeView];
    }
}

- (void)loadMeal
{
    [[FBRequest requestForGraphPath:@"/ulf.hansen73/feed?fields=message"] startWithCompletionHandler:
     ^(FBRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             if ([[[result objectForKey:@"data"] objectAtIndex:0] objectForKey:@"message"] == nil){
//               Ulf ist not your Friend :(
                 NSLog(@"Ulf is not your Friend");
                 self.menuLabel.text = @"Du bist nicht mit Ulf befreundet.";
             } else {
//               Ulf is Friend :D
             
                 NSString * meal = [[[result objectForKey:@"data"]
                           objectAtIndex:0]
                          objectForKey:@"message"];
                 NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"Tagesessen .*: " options:         NSRegularExpressionCaseInsensitive error:&error];
             
                 meal = [regex stringByReplacingMatchesInString: meal options:0 range:NSMakeRange(0, [meal length]) withTemplate:@""];
                 self.menuLabel.text = meal;
                NSLog(@"Meal loaded");
             }
             
         } else {
             [FBSession.activeSession closeAndClearTokenInformation];
             NSLog(@"FBRequest failed");
             [self changeView];
         }
     } ];
}


- (void)changeView {
    [self performSegueWithIdentifier:@"loginViewSegue" sender:self];
}


@end
