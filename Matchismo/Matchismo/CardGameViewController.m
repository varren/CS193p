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

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeControl;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipResultLable;

@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic) int flipCount;

@end

@implementation CardGameViewController

-(CardMatchingGame *)game{
    if(!_game) {
        _game = [[CardMatchingGame alloc]
                 initWithCardCount:self.cardButtons.count
                 usingDeck:[[PlayingCardDeck alloc]init]
                 andMode: [self mode]];
    }
    return _game;
}

-(int)mode{
    // if 1-st option selected (default) will start 2-cards matching game. else 3-card
    return self.modeControl.selectedSegmentIndex ? 3 : 2;
}

-(void) setCardButtons:(NSArray *)cardButtons{
    _cardButtons = cardButtons;
    [self updateUI];
}

# define DEFAULT_IMG_INSERTS 7
-(void)updateUI{
    
    // updating cards view
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];

        UIImage *img = card.isFaceUp ? [UIImage imageNamed: @"clear" ] : [UIImage imageNamed: @"cardback.jpg" ] ;
        [cardButton setImage: img forState:UIControlStateNormal];
        [cardButton setImageEdgeInsets:UIEdgeInsetsMake(DEFAULT_IMG_INSERTS *2, 2, DEFAULT_IMG_INSERTS *2, 2)];
  
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

- (IBAction)deal{
    self.game = nil;
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

- (IBAction)changeMode {
    [self.game setMode: [self mode]];
}


@end
