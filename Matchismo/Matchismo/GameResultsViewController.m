//
//  GameResultsViewController.m
//  Matchismo
//
//  Created by mmh on 10/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "GameResultsViewController.h"
#import "GameResult.h"

@interface GameResultsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *display;
@property (nonatomic) SEL sortedSelector;
@end

@implementation GameResultsViewController

#define OUTPUT_SCORES_FORMAT @"%-20s \t| %-5s \t| %5s \n"
-(void) updateUI{
    
    NSString *displayText = [NSString stringWithFormat:OUTPUT_SCORES_FORMAT,[@"Collumn names:   Date" UTF8String],[@"Score" UTF8String],[@"Time" UTF8String]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];

    for (GameResult *result in [[GameResult allGameResults]sortedArrayUsingSelector:self.sortedSelector]) {
        NSString *sScore = [NSString stringWithFormat:@"%d", result.score];
        NSString *sTime = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:result.end]];
        NSString *sDuration = [NSString stringWithFormat:@"%0g sec",round(result.duration)];
        displayText = [displayText stringByAppendingFormat:OUTPUT_SCORES_FORMAT,[sTime UTF8String], [sScore UTF8String], [sDuration UTF8String]];
        
        //displayText = [displayText stringByAppendingFormat:@"Score: %d (%@, %0g)\n", result.score, [dateFormatter stringFromDate:result.end], round(result.duration)];
    }
    
    self.display.text = displayText;
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
