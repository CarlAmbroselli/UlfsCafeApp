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

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    // if FBSession is already actve instantly change to MenuView
    
    if (FBSession.activeSession.isOpen) {
        [self changeView];
    } else {
    // else try to login without UI
        NSArray *permissions = [NSArray arrayWithObjects:@"read_stream", nil];
        [FBSession openActiveSessionWithReadPermissions: permissions
                                           allowLoginUI:NO
                                      completionHandler: ^(FBSession *session, FBSessionState state, NSError *error) {
                                          [self sessionStateChanged:session state:state error:error];
                                      }
         ];
    }
    
}

- (IBAction)loginButtonPressed:(id)sender{
    
    NSArray *permissions = [NSArray arrayWithObjects:@"read_stream", nil];
    [FBSession openActiveSessionWithReadPermissions: permissions
                                        allowLoginUI:YES
                                        completionHandler: ^(FBSession *session, FBSessionState state, NSError *error) {
                                        [self sessionStateChanged:session state:state error:error];
                                  }
     ];
}

- (void)changeView {
    [self performSegueWithIdentifier:@"menuViewSegue" sender:self];
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            NSLog(@"Open");
            [self changeView];
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
