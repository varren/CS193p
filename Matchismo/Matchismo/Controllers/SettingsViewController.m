//
//  SettingsViewController.m
//  Matchismo
//
//  Created by mmh on 14/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "SettingsViewController.h"
#import "GameResult.h"
@interface SettingsViewController ()

@end

@implementation SettingsViewController


- (IBAction)resetScores {
    [[NSUserDefaults standardUserDefaults] setObject:@{} forKey: USER_DEFAULTS_SCORES_KEY];
}

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
