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
//    [[FBSession activeSession] closeAndClearTokenInformation];
}


- (IBAction)loginButtonPressed:(id)sender{
    //TODO: Handle Login
    //Help (Maybe): https://developers.facebook.com/docs/tutorials/ios-sdk-tutorial/authenticate/
    
    //1. Login to Facebook
    NSArray *permissions = [NSArray arrayWithObjects:@"read_stream", nil];
    [FBSession openActiveSessionWithReadPermissions: permissions
                                       allowLoginUI:YES
                                  completionHandler: ^(FBSession *session, FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
    

}

- (void)loadMeal
{
    [[FBRequest requestForGraphPath:@"/ulf.hansen73/feed?fields=message"] startWithCompletionHandler:
     ^(FBRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             self.meal = [[[result objectForKey:@"data"]
                           objectAtIndex:0]
                          objectForKey:@"message"];
             NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"Tagesessen .*: " options:NSRegularExpressionCaseInsensitive error:&error];
             
             self.meal = [regex stringByReplacingMatchesInString:self.meal options:0 range:NSMakeRange(0, [self.meal length]) withTemplate:@""];
             [self performSegueWithIdentifier:@"menuViewSegue" sender:self];
         }
     } ];
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


- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            NSLog(@"Open");
            [self loadMeal];
            break;
        }        
        case FBSessionStateClosed:
            NSLog(@"Closed");
            break;
        case FBSessionStateClosedLoginFailed:
            NSLog(@"LoginFailed");
            break;
        default:
            NSLog(@"Def.");
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }    
}

@end
