//
//  GameResultsViewController.m
//  Matchismo
//
//  Created by mmh on 10/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "GameResultsViewController.h"
#import "GameResult.h"
#import "GameResultsCell.h"

@interface GameResultsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *scoresTable;
@property (weak, nonatomic) IBOutlet UITextView *display;
@property (nonatomic) SEL sortedSelector;
@property (strong, nonatomic) NSArray * sortedResults;

@end

@implementation GameResultsViewController
-(NSArray*) sortedResults{
    if (!_sortedResults) {
        _sortedResults = [[GameResult allGameResults]sortedArrayUsingSelector:self.sortedSelector];
    }
    return _sortedResults;
}
#define OUTPUT_SCORES_FORMAT @"%s | %s | %s | %s | %s \n"
#define CARD_MATCHING_GAME 1
#define SETS_MATHCING_GAME 2

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.sortedResults count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GameResultCell" forIndexPath:indexPath];
    
    GameResult * result = self.sortedResults[indexPath.row];
    
    [self updateCell: cell withGameResult:result];
    
    return cell;
}

-(void) updateCell: (UITableViewCell*) cell withGameResult:(GameResult*) result{
    if([cell isKindOfClass:[GameResultsCell class]]){
        GameResultsCell * resultCell = (GameResultsCell*)cell;
        
        resultCell.score.text = [NSString stringWithFormat:@"%d", result.score];
        
        resultCell.name.text = result.playerName;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        resultCell.time.text = [NSString stringWithFormat:@"%dm %ds",(int)result.duration/60, (int)result.duration%60];
        
        resultCell.date.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:result.end]];
        
        NSString * image = result.gameType == CARD_MATCHING_GAME ? @"cardgame.png" : @"setgame.png";
        
        resultCell.logo.image = [UIImage imageNamed:image];
        
    }
}
-(void) updateUI{
    [self.scoresTable reloadData];
    NSString *text = [NSString stringWithFormat:OUTPUT_SCORES_FORMAT, [@"Type" UTF8String],[@"Name" UTF8String],[@"Score" UTF8String],[@"Time" UTF8String],[@"Date" UTF8String]];
    
    NSMutableAttributedString * displayText = [[NSMutableAttributedString alloc]initWithString:text];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];

    for (GameResult *result in self.sortedResults) {
        
        NSString *sScore = [NSString stringWithFormat:@"%d", result.score];
        NSString *sTime = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:result.end]];
        NSString *sDuration = [NSString stringWithFormat:@"%0g sec",round(result.duration)];;
        
        text = [NSString stringWithFormat:OUTPUT_SCORES_FORMAT, [[self gameNameFrom:result] UTF8String], [result.playerName UTF8String],[sScore UTF8String], [sDuration UTF8String], [sTime UTF8String]];
        
        NSMutableAttributedString * newLine = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: [self selectColorFor:result]}];
        
        [displayText appendAttributedString:newLine];
        
    }
    
    [self.display setAttributedText: displayText];
}


-(UIColor*)selectColorFor:(GameResult*) result{
    UIColor *sColor;

    if(result.gameType == SETS_MATHCING_GAME)
        sColor = [UIColor blueColor];
    else if (result.gameType == CARD_MATCHING_GAME)
        sColor = [UIColor redColor];
    else
        sColor = [UIColor blackColor];
    
    return sColor;
}

-(NSString*)gameNameFrom:(GameResult*) result{
    NSString * sGameType;
    
    if(result.gameType == SETS_MATHCING_GAME)
        sGameType = @"SETS";
    else if (result.gameType == CARD_MATCHING_GAME)
        sGameType = @"CARD";
    else sGameType = @"";
    
    return sGameType;
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateUI];
}

//unsued init methods before viewDidLoad
-(void)setup{
    [self updateUI];
    //initial setup that cant wait until viewDidLoad
}
-(void)awakeFromNib{
    [self setup];
}
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setup];
    return self;
}

//sorting methods
@synthesize sortedSelector = _sortedSelector;
-(SEL)sortedSelector{
    if(!_sortedSelector) _sortedSelector = @selector(compareScoreToGameResult:);
    return _sortedSelector;
}
-(void)setSortedSelector:(SEL)sortedSelector{
    _sortedSelector = sortedSelector;
    self.sortedResults = nil; // will resorder it if needed
    [self updateUI];
}

- (IBAction)sortByDate {
    self.sortedSelector = @selector(compareEndDateToGameResult:);
}
- (IBAction)sortByScore {
    self.sortedSelector = @selector(compareScoreToGameResult:);
    
}
- (IBAction)sortByDuration {
    self.sortedSelector = @selector(compareDurationToGameResult:);
    
}




@end
