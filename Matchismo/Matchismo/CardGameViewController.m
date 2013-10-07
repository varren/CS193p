//
//  CardGameViewController.m
//  Matchismo
//
//  Created by mmh on 31/07/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeControl;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipResultLable;
@property (nonatomic) BOOL needNewDeck;

@end

@implementation CardGameViewController

-(CardMatchingGame *)game{
    if(!_game || self.needNewDeck) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                  usingDeck:[[PlayingCardDeck alloc]init]];
        self.needNewDeck = NO;
    }
    return _game;
}

- (IBAction)changeMode:(id)sender {
    [self.game setMode: self.modeControl.selectedSegmentIndex ? 3 : 2];
    
}

-(void) setCardButtons:(NSArray *)cardButtons{
    _cardButtons = cardButtons;
    [self updateUI];
}

-(void)updateUI{
    
    // updating cards view
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    
    self.modeControl.alpha =
    self.modeControl.isUserInteractionEnabled ? 1.0 :0.3;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    self.lastFlipResultLable.text = self.game.lastActionStatus;
}

- (IBAction)reDealCards:(id)sender {
    self.needNewDeck = YES;
    self.flipCount = 0;
    self.modeControl.userInteractionEnabled = YES;
    [self updateUI];
}


- (IBAction)flipCard:(UIButton *)sender {
    self.modeControl.userInteractionEnabled = NO;
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];

}



@end
