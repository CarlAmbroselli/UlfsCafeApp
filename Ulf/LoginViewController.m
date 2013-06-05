//
//  ViewController.m
//  Ulf
//
//  Created by Carl Ambroselli on 04.06.13.
//  Copyright (c) 2013 iDev. All rights reserved.
//

#import "LoginViewController.h"
#import "MenuViewController.h"

@interface LoginViewController ()

@property (strong, nonatomic) NSString* meal;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (IBAction)loginButtonPressed:(id)sender{
    //TODO: Handle Login
    //Help (Maybe): https://developers.facebook.com/docs/tutorials/ios-sdk-tutorial/authenticate/
    
    //1. Login to Facebook
    
    [self loadMeal];
}

- (void)loadMeal
{
    //TODO: Implement Facebook Graph Request
    
    //Help: You need https://graph.facebook.com/ulf.hansen.73/feed?limit=1 with a valid access token (you should get it after login)
    //You should only load the last meal, old meals are uninteresting, not?
    
    //Help (Maybe) (source: https://developers.facebook.com/docs/howtos/batch-requests-ios-sdk/ )
    
    /*
     [FBRequestConnection startWithGraphPath:@"ulf.hansen.73/feed?limit=1" 
                completionHandler:^(FBRequestConnection *connection, id result, NSError *error) 
         {
            if (!error) {
     
                //We don't want the whole text... extract everything behind the :
     
                // Set the menu
                self.meal = [[[result objectForKey:@"data"]
                    objectAtIndex:0]
                    objectForKey:@"message"];
     
                [self performSegueWithIdentifier:@"menuViewSegue" sender:self];
         }
     }];
     */
    
    /* remove this later!! */ self.meal = @"Bouletten mit Bohnen in Bechamelsauce, dazu Kartoffeln und Salat";
    /* remove this later!! */ [self performSegueWithIdentifier:@"menuViewSegue" sender:self]; // remove this later

    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"menuViewSegue"])
    {
        // Get reference to the destination view controller
        MenuViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.meal = self.meal;
    }
}

@end
