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


-(Deck*) createDeck{
    Deck* deck = [[SetDeck alloc]init];
    return deck;
}

#define SET_GAME_STARTING_CARDS_COUNT 12
#define SET_GAME_ID 2
#define SET_GAME_MATCHING_MODE 3

-(NSInteger)gameType  {return SET_GAME_ID;}


-(NSInteger)startCardsCount{
    return SET_GAME_STARTING_CARDS_COUNT ;
    
}
-(int)mode            {return SET_GAME_MATCHING_MODE;}


#define DEFAULT_CARDBACK_TOP_INSERTS 6
#define DEFAULT_CARDBACK_SIDES_INSERTS 2
#define ACTIVE_ALPHA 1.0
#define INACTIVE_ALPHA 0.0
#define DEFAULT_TEXT_FONT_SIZE 20


-(void)updateCell: (id) cardCell usingCard: (Card*)card{
    if([cardCell isKindOfClass:[CardCollectionViewCell class]]){
        CardView *cardView = ((CardCollectionViewCell *)cardCell).cardView;
        if([cardView isKindOfClass:[SetCardView class]]){
            SetCardView * setCardView = (SetCardView*)cardView;
            if ([card isKindOfClass:[SetCard class]]) {
                SetCard* setCard =(SetCard*) card;
                
                setCardView.shape = [SetCardView validShapes][[setCard.shape intValue]];
                setCardView.shading = @[@(1.0), @(0.7), @(0.3)][[setCard.shading intValue] ];
                setCardView.color = [self colorFor: setCard.color];
                setCardView.number = [setCard.number intValue];
                
                setCardView.faceUp = setCard.isFaceUp;
                setCardView.alpha = setCard.isUnplayable ? INACTIVE_ALPHA : ACTIVE_ALPHA;
            }
        }
    }

    
}
-(UIColor *)colorFor:(NSNumber *) modelValue{
    NSString *stringColor = @[@"purpleColor", @"greenColor", @"redColor"][[modelValue intValue]];
    return [UIColor performSelector:NSSelectorFromString(stringColor)];
}

#define DEFAULT_STROKE_SIZE @-5
-(NSAttributedString*) arrtibutedCard:(Card*) card{
    
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:card.contents];
    SetCard *setCard = (SetCard*)card;
    
    NSRange range = NSMakeRange(0, aString.length);
    
    NSDictionary* attributes = @{ NSForegroundColorAttributeName: [[self colorFor:setCard.color] colorWithAlphaComponent:([setCard.shading doubleValue])],
                                  NSStrokeWidthAttributeName : DEFAULT_STROKE_SIZE,
                                  NSStrokeColorAttributeName: [self colorFor:setCard.color] };
    
    if(range.location != NSNotFound)
        [aString setAttributes: attributes range:range];
    
    return aString;
    
}

@end
