//
//  SetGameViewController.m
//  Matchismo
//
//  Created by mmh on 12/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetDeck.h"
#import "SetCard.h"

@interface SetGameViewController ()

@end

@implementation SetGameViewController


-(Deck*) createDeck{
    Deck* deck = [[SetDeck alloc]init];
    return deck;
}


#define DEFAULT_SET_GAME_MODE 3
-(int)mode{
    return DEFAULT_SET_GAME_MODE;
}


#define DEFAULT_CARDBACK_TOP_INSERTS 6
#define DEFAULT_CARDBACK_SIDES_INSERTS 2
#define ACTIVE_ALPHA 1.0
#define INACTIVE_ALPHA 0.0
#define DEFAULT_TEXT_FONT_SIZE 20


-(void)updateButton: (UIButton*) cardButton withCard: (Card*)card{
 
        NSMutableAttributedString *aCard = [[self arrtibutedCard:card] mutableCopy];
        
        NSRange len = [[aCard string]rangeOfString:[aCard string]];
        [aCard addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:DEFAULT_TEXT_FONT_SIZE] range:len];
        
        [cardButton setAttributedTitle:aCard forState:UIControlStateNormal];
        [cardButton setAttributedTitle:aCard forState:UIControlStateSelected];
        [cardButton setAttributedTitle:aCard forState:UIControlStateSelected|UIControlStateDisabled];
   
        cardButton.selected = card.isFaceUp;
        cardButton.backgroundColor = card.isFaceUp ? [UIColor lightGrayColor] : nil;
        cardButton.enabled = !card.isUnplayable;
        
        cardButton.alpha = card.isUnplayable ? INACTIVE_ALPHA : ACTIVE_ALPHA;
    
    
}

#define DEFAULT_STROKE_SIZE @-5
-(NSAttributedString*) arrtibutedCard:(Card*) card{
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:card.contents];
    SetCard *setCard = (SetCard*)card;
    
    NSRange range = NSMakeRange(0, aString.length);
    
    NSDictionary* attributes = @{ NSForegroundColorAttributeName: [setCard.color colorWithAlphaComponent:(setCard.shading)],
                                  NSStrokeWidthAttributeName : DEFAULT_STROKE_SIZE,
                                  NSStrokeColorAttributeName: setCard.color};
    
    if(range.location != NSNotFound)
        [aString setAttributes: attributes range:range];
    
    return aString;
    
}

@end
