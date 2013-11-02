//
//  SettingsViewController.m
//  Matchismo
//
//  Created by mmh on 14/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "SettingsViewController.h"
#import "Settings.h"
@interface SettingsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *numberOfPlayersLabel;
@property (weak, nonatomic) IBOutlet UISlider *numberOfPlayersSlider;

@property (nonatomic) int difficulty;
@property (nonatomic) int numberOfPlayers;

@end

@implementation SettingsViewController;
#pragma mark - UITableView Protocols

#define DIFFICULTY_SECTION 0
#define PLAYERS_SECTION 1
#define OTHER_OPTIONS_SECTION 2

#define EASY_DIFFICULTY 0
#define NORMAL_DIFFICULTY 1
#define HARD_DIFFICULTY 2

#define RESET_SCORES 0
#define RESET_SETTINGS 1
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [super tableView:tableView numberOfRowsInSection:section];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case DIFFICULTY_SECTION:
            self.difficulty = indexPath.row;
            break;
        case PLAYERS_SECTION:
            break;
        case OTHER_OPTIONS_SECTION:
            if(indexPath.row == RESET_SCORES)
                [self resetScores];
            else
                [self resetSettingsToDefaults];
            break;
        default:
            break;
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];


    
    switch (indexPath.section) {
        case DIFFICULTY_SECTION:
            NSLog(@"ROW: %d , DIF: %d", indexPath.row, self.difficulty);
            cell.accessoryType = indexPath.row  == self.difficulty ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            break;
            
        case PLAYERS_SECTION:
            break;
            
        case OTHER_OPTIONS_SECTION:

            break;
            
        default:
            break;
    }
    
    return cell;
}
-(BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    if(indexPath.section == PLAYERS_SECTION)
        return NO;
    return YES;
}

#pragma mark - Difficulty Options
@synthesize difficulty = _difficulty;
-(int)difficulty{
    if(!_difficulty)_difficulty = [Settings instance].difficulty;
    return _difficulty;
}

-(void)setDifficulty:(NSInteger) difficulty{
    _difficulty = difficulty;
    [Settings instance].difficulty = difficulty;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:DIFFICULTY_SECTION] withRowAnimation:UITableViewRowAnimationNone];
    NSLog(@"Difficulty set to %d", difficulty);
}

#pragma mark - Players Options

@synthesize numberOfPlayers = _numberOfPlayers;
-(int)numberOfPlayers{
    if(!_numberOfPlayers)_numberOfPlayers = [Settings instance].numberOfPlayers;
    return _numberOfPlayers;
}

#define PLAYERS_SECTION_MAX_INDEX 2
-(void)setNumberOfPlayers:(int)numberOfPlayers{
    
    if(numberOfPlayers != [self.numberOfPlayersLabel.text intValue]){
        self.numberOfPlayersLabel.text = [NSString stringWithFormat:@"%d", numberOfPlayers];
        self.numberOfPlayersSlider.value = numberOfPlayers;
        _numberOfPlayers = numberOfPlayers;
        [Settings instance].numberOfPlayers = numberOfPlayers;
        NSLog(@"Number of players is %d",  numberOfPlayers);
    }

}


- (IBAction)changeNumberOfPlayers {
   self.numberOfPlayers = (int)self.numberOfPlayersSlider.value;
    
}

#pragma mark - Other Options

-(void)resetSettingsToDefaults{
    NSLog(@"Reset Settings To Defaults");

    [[Settings instance] resetSettings];
    self.numberOfPlayers = [Settings instance].numberOfPlayers;
    self.difficulty = [Settings instance].difficulty;
}

- (void)resetScores {
    NSLog(@"Reset Scores");
    [[Settings instance] resetSavedScores];
    [self.tableView reloadSectionIndexTitles]
}

#pragma mark - Livecycle
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
