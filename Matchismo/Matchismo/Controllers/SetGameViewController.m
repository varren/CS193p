//
//  SetGameViewController.m
//  Matchismo
//
//  Created by mmh on 12/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "SetGameViewController.h"
#import "CardCollectionViewCell.h"
#import "SetDeck.h"
#import "SetCard.h"
#import "SetCardView.h"

@interface SetGameViewController ()

@end

@implementation SetGameViewController

#define SET_GAME_STARTING_CARDS_COUNT 12
#define SET_GAME_ID 2
#define SET_GAME_MATCHING_MODE 3

-(Deck*) createDeck{
    Deck* deck = [[SetDeck alloc]init];
    return deck;
}

-(NSInteger)gameType       {return SET_GAME_ID;}
-(NSInteger)startCardsCount{return SET_GAME_STARTING_CARDS_COUNT ;}
-(int)mode                 {return SET_GAME_MATCHING_MODE;}
-(BOOL)keepMatchedCards    {return NO;}


#define DEFAULT_CARDBACK_TOP_INSERTS 6
#define DEFAULT_CARDBACK_SIDES_INSERTS 2
#define DEFAULT_TEXT_FONT_SIZE 20


-(void)updateCell: (id) cardCell usingCard: (Card*)card withGameState: (BOOL) needState{

    if([cardCell isKindOfClass:[CardCollectionViewCell class]]){
        CardView *cardView = ((CardCollectionViewCell *)cardCell).cardView;
        if([cardView isKindOfClass:[SetCardView class]]){
            SetCardView * setCardView = (SetCardView*)cardView;
            if ([card isKindOfClass:[SetCard class]]) {
                SetCard* setCard = (SetCard*) card;
                
                setCardView.shape   = setCard.shape;
                setCardView.shading = setCard.shading;
                setCardView.color   = setCard.color;
                setCardView.number  = setCard.number;

            }
        }
    }

    [super updateCell:cardCell usingCard:card withGameState:  needState];   
}





#define DEFAULT_STROKE_SIZE @-5
-(NSAttributedString*) arrtibutedCard:(Card*) card{
    
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:card.contents];
      /*
       SetCard *setCard = (SetCard*)card;
    
    NSRange range = NSMakeRange(0, aString.length);
  
    NSDictionary* attributes = @{ NSForegroundColorAttributeName: [[self colorFor:setCard.color]
                                        colorWithAlphaComponent: [@[@(1.0), @(0.5), @(0.0)][setCard.shading] floatValue]],
                                  NSStrokeWidthAttributeName : DEFAULT_STROKE_SIZE,
                                  NSStrokeColorAttributeName: [self colorFor:setCard.color] };
   
    if(range.location != NSNotFound)
        [aString setAttributes: attributes range:range];
     */
    return aString;
    
}

@end
