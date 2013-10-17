//
//  CardGameViewController.m
//  Matchismo
//
//  Created by mmh on 31/07/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "CardGameViewController.h"
#import "GameResult.h"
#import "CardMatchingGame.h" 

@interface CardGameViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeControl;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;

@property (strong,nonatomic) NSMutableDictionary *history;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) GameResult *gameResult;
@property (nonatomic) int flipCount;
@property (nonatomic) int mode;

@end

@implementation CardGameViewController

-(GameResult*)gameResult{
    if (!_gameResult) {
        _gameResult = [[GameResult alloc] initFor: self.gameType];
    }
    return _gameResult;
}


-(CardMatchingGame *)game{
    if(!_game) {
        _game = [[CardMatchingGame alloc]
                 initWithCardCount:self.cardsCount
                 usingDeck:[self createDeck]];
    }
    return _game;
}


-(NSInteger) cardsCount{
    if(!_cardsCount)_cardsCount = self.cardButtons.count;
    return _cardsCount;
} // kinda abstract 
-(Deck*) createDeck{return nil;} //abstract
-(void)updateButton: (UIButton*) cardButton withCard: (Card*)card{} //abstract

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
    for(UIButton* cardButton in self.cardButtons){
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [self updateButton: cardButton withCard: card];
    }
    self.modeControl.alpha =
    self.modeControl.isUserInteractionEnabled ? ACTIVE_ALPHA : INACTIVE_ALPHA;
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];

    //slider update
    [self.statusLabel setAttributedText:  [self status] ];
    NSMutableAttributedString *historyStatus = [[self status] mutableCopy];
    NSRange range = NSMakeRange(0, historyStatus.length);
    [historyStatus addAttributes:@{NSBackgroundColorAttributeName: [UIColor lightGrayColor]} range:range];
    [self.history setObject: historyStatus forKey:@(self.flipCount)];
    [self.historySlider setValue:self.flipCount];

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
    
    if(!self.flipCount){ // if first flip
        self.modeControl.userInteractionEnabled = NO;
        [self.game setMode: [self mode]];
    }
    
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self.historySlider setMaximumValue:self.flipCount];
    self.gameResult.score = self.game.score;
    [self updateUI];

}

- (IBAction)historySliderMoved:(id)sender {
    int value = (int)self.historySlider.value;
    NSAttributedString *text = (value == (int)self.historySlider.maximumValue) ? [self status] : self.history[@(value)];
    [self.statusLabel setAttributedText: text];
}


- (IBAction)changeMode {
    [self.game setMode: [self mode]];
}


-(NSAttributedString*) flippedCards{
    NSMutableAttributedString * cards = [[NSMutableAttributedString alloc] init];
    
    for (int i = 0; i < [self.game.allFlippedCards count]; i++) {
        if(i) [cards appendAttributedString:[[NSMutableAttributedString alloc] initWithString: @" & " ]];
        Card * card = self.game.allFlippedCards[i];
        [cards appendAttributedString: [self arrtibutedCard:card]];
    }
    
    return cards;
}

-(NSAttributedString*) arrtibutedCard:(Card*) card {
    return [[NSMutableAttributedString alloc] initWithString: [card contents]];
}

-(NSAttributedString *) status{
    NSMutableAttributedString *status = [[NSMutableAttributedString alloc] initWithString: @""];
   
    if ([self.game.allFlippedCards count] == 0) // because there can be 0 cards only on start of a new game
        status = [[NSMutableAttributedString alloc] initWithString: @"New Game Started"];
    
    else if (self.game.lastTurnScore > 0){
        [status appendAttributedString: [[NSMutableAttributedString alloc] initWithString: @"Matched " ]];
        [status appendAttributedString: [self flippedCards]];
        [status appendAttributedString: [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@" for %d points", self.game.lastTurnScore]]];
                                         
    }else if (self.game.lastTurnScore < 0){
        [status appendAttributedString: [self flippedCards]];
        [status appendAttributedString: [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@" don't match! %d points penalty", self.game.lastTurnScore]]];
    
    }else if (self.game.lastTurnScore == 0){
        [status appendAttributedString: [[NSMutableAttributedString alloc] initWithString: @"Flipped " ]];
        [status appendAttributedString: [self flippedCards]];
    }

    return status;
}

@end
