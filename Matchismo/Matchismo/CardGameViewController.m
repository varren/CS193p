//
//  CardGameViewController.m
//  Matchismo
//
//  Created by mmh on 31/07/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "CardGameViewController.h"
#import "GameResult.h"

@interface CardGameViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeControl;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;

@property (strong,nonatomic) NSMutableDictionary *history;
@property (strong, nonatomic) CardGame *game;
@property (strong, nonatomic) GameResult *gameResult;
@property (nonatomic) int flipCount;

@end

@implementation CardGameViewController

-(GameResult*)gameResult{
    if (!_gameResult) {
        _gameResult = [[GameResult alloc] init];
    }
    return _gameResult;
}

-(CardGame *)game{
    if(!_game) {
        _game = [[CardGame alloc]
                 initWithCardCount:self.cardsCount
                 usingDeck:[self createDeck]];
    }
    return _game;
}

-(Deck*) createDeck{return nil;} //abstract

-(int)mode{
    return [[self.modeControl titleForSegmentAtIndex:[self.modeControl selectedSegmentIndex]] integerValue];
}

-(NSMutableDictionary*)history{
    if(!_history)_history = [[NSMutableDictionary alloc]init];
    return _history;
}

-(void) setCardButtons:(NSArray *)cardButtons{
    _cardButtons = cardButtons;
    [self updateUI];
}

#define ACTIVE_ALPHA 1.0
#define INACTIVE_ALPHA 0.3

-(void)updateUI{
    self.modeControl.alpha =
    self.modeControl.isUserInteractionEnabled ? ACTIVE_ALPHA : INACTIVE_ALPHA;
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    self.statusLabel.text = [self.game status];
    
    //slider update
    [self.statusLabel setTextColor:[UIColor blackColor]];
    [self.history setObject:[self.game status] forKey:@(self.flipCount)];
    [self.historySlider setValue:self.flipCount];
    //NSLog(@"%d = %@ score = %d", self.flipCount, [self.game status],self.game.score);

}

- (IBAction)deal{
    self.gameResult = nil;
    self.game = nil;
    self.history = nil;
    self.flipCount = 0;
    self.modeControl.userInteractionEnabled = YES;
    [self updateUI];
}

- (IBAction)flipCard:(UIButton *)sender {

    self.modeControl.userInteractionEnabled = NO;
    [self.game setMode: [self mode]];

    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self.historySlider setMaximumValue:self.flipCount];
    self.gameResult.score = self.game.score;
    [self updateUI];

}

- (IBAction)historySliderMoved:(id)sender {
    int value = (int)self.historySlider.value;
    self.statusLabel.text = self.history[@(value)];
    UIColor *textColor = (value == self.flipCount) ? [UIColor blackColor] : [UIColor grayColor];
    [self.statusLabel setTextColor:textColor];

}

- (IBAction)changeMode {
    [self.game setMode: [self mode]];
}


@end
