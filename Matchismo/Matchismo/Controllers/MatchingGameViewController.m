//
//  MatchingGameViewController.m
//  Matchismo
//
//  Created by mmh on 12/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "MatchingGameViewController.h"
#import "PlayingCardView.h"
#import "CardCollectionViewCell.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@interface MatchingGameViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeControl;
@end

@implementation MatchingGameViewController
#define CARDS_GAME_ID 1
#define CARDS_GAME_STARTING_CARDS_COUNT 22
#define ACTIVE_ALPHA 1.0
#define INACTIVE_ALPHA 0.5
#define INVIS_ALPHA 0.0

-(Deck*) createDeck{
    Deck* deck = [[PlayingCardDeck alloc]init];
    return deck;
}

@synthesize mode = _mode;
-(int)mode{
    _mode = [[self.modeControl titleForSegmentAtIndex:[self.modeControl selectedSegmentIndex]] integerValue];
    return _mode;
}

-(NSInteger)gameType  {return CARDS_GAME_ID;}

@synthesize startCardsCount = _startCardsCount;

-(NSInteger)startCardsCount{
    if (!_startCardsCount) _startCardsCount = CARDS_GAME_STARTING_CARDS_COUNT;
    return _startCardsCount ;
}

-(void)startNewGame{
    [self inputCardsCount];
    self.modeControl.userInteractionEnabled = YES;
    self.modeControl.alpha = ACTIVE_ALPHA;
}

-(void)inputCardsCount{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Enter Number of Cards" message:@"" delegate:self cancelButtonTitle:@"Select" otherButtonTitles:nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alertView textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeNumberPad;
    alertTextField.text = [NSString stringWithFormat:@"%d", [self startCardsCount]];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    self.startCardsCount = [[[alertView textFieldAtIndex:0] text] integerValue];
    [super startNewGame];

}

-(void)flipCardAtIndex:(NSInteger)index{
    self.modeControl.userInteractionEnabled = NO;
    self.modeControl.alpha = INACTIVE_ALPHA;
    [super flipCardAtIndex:index];
    
}



#define DEFAULT_CARDBACK_TOP_INSERTS 6
#define DEFAULT_CARDBACK_SIDES_INSERTS 2

-(void)updateCell: (id) cardCell usingCard: (Card*)card {
    [super updateCell:cardCell usingCard:card ];
    
    if([cardCell isKindOfClass:[CardCollectionViewCell class]]){
        CardView *cardView = ((CardCollectionViewCell *)cardCell).cardView;
        if([cardView isKindOfClass:[PlayingCardView class]]){
            PlayingCardView * playingCardView = (PlayingCardView *)cardView;
            if ([card isKindOfClass:[PlayingCard class]]) {
                PlayingCard *playingCard =(PlayingCard *) card;
                playingCardView.rank = playingCard.rank;
                playingCardView.suit = playingCard.suit;
                

            }
        }
    }
}

@end
