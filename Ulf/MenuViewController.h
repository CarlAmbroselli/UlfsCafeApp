//
//  MenuViewController.h
//  Ulf
//
//  Created by Carl Ambroselli on 05.06.13.
//  Copyright (c) 2013 iDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *menuLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
- (IBAction)refreshButtonPressed:(id)sender;

@end
