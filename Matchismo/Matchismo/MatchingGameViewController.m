//
//  MatchingGameViewController.m
//  Matchismo
//
//  Created by mmh on 12/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "MatchingGameViewController.h"
#import "PlayingCardDeck.h"

@interface MatchingGameViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeControl;
@end

@implementation MatchingGameViewController

-(Deck*) createDeck{
    Deck* deck = [[PlayingCardDeck alloc]init];
    return deck;
}
-(NSString*)gameType{
    return @"Card";
}

#define DEFAULT_CARDBACK_TOP_INSERTS 6
#define DEFAULT_CARDBACK_SIDES_INSERTS 2
#define ACTIVE_ALPHA 1.0
#define INACTIVE_ALPHA 0.3

-(void)updateButton: (UIButton*) cardButton withCard: (Card*)card{

        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        
        UIImage *img = card.isFaceUp ? [UIImage imageNamed: @"clear" ] : [UIImage imageNamed: @"cardback.jpg" ] ;
        [cardButton setImage: img forState:UIControlStateNormal];
        [cardButton setImageEdgeInsets:UIEdgeInsetsMake(
                                                        DEFAULT_CARDBACK_TOP_INSERTS,
                                                        DEFAULT_CARDBACK_SIDES_INSERTS,
                                                        DEFAULT_CARDBACK_TOP_INSERTS,
                                                        DEFAULT_CARDBACK_SIDES_INSERTS)];
        
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        
        cardButton.alpha = card.isUnplayable ? INACTIVE_ALPHA : ACTIVE_ALPHA;

}

@end
