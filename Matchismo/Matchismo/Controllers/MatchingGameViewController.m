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

@interface MatchingGameViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeControl;
@end

@implementation MatchingGameViewController

-(Deck*) createDeck{
    Deck* deck = [[PlayingCardDeck alloc]init];
    return deck;
}
#define CARDS_GAME_ID 1
#define CARDS_GAME_STARTING_CARDS_COUNT 22

-(NSInteger)gameType  {return CARDS_GAME_ID;}
-(NSInteger)startCardsCount{return CARDS_GAME_STARTING_CARDS_COUNT;}

#define DEFAULT_CARDBACK_TOP_INSERTS 6
#define DEFAULT_CARDBACK_SIDES_INSERTS 2
#define ACTIVE_ALPHA 1.0
#define INACTIVE_ALPHA 0.3

-(void)updateCell: (id) cardCell usingCard: (Card*)card{
    if([cardCell isKindOfClass:[CardCollectionViewCell class]]){
        CardView *cardView = ((CardCollectionViewCell *)cardCell).cardView;
        if([cardView isKindOfClass:[PlayingCardView class]]){
            PlayingCardView * playingCardView = (PlayingCardView *)cardView;
            if ([card isKindOfClass:[PlayingCard class]]) {
                PlayingCard *playingCard =(PlayingCard *) card;
                playingCardView.rank = playingCard.rank;
                playingCardView.suit = playingCard.suit;
                playingCardView.faceUp = playingCard.isFaceUp;
                playingCardView.alpha = playingCard.isUnplayable ? INACTIVE_ALPHA : ACTIVE_ALPHA;
            }
        }
    }
}

@end
