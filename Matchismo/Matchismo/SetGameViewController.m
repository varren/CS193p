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

-(NSInteger)cardsCount{
    //NSLog(@"Cards on screed%d",[self.cardButtons count]);
    return [self.cardButtons count];
   
}


#define DEFAULT_CARDBACK_TOP_INSERTS 6
#define DEFAULT_CARDBACK_SIDES_INSERTS 2
#define ACTIVE_ALPHA .9
#define INACTIVE_ALPHA 0.3

-(void)updateUI{
    for(UIButton* cardButton in self.cardButtons){
        SetCard *card = (SetCard*)[self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setAttributedTitle:card.attributedContents forState:UIControlStateNormal];
        
        [cardButton setTitle:card.contents forState:UIControlStateNormal];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        
        cardButton.selected = card.isFaceUp;
        cardButton.backgroundColor = card.isFaceUp ? [UIColor lightGrayColor] : nil;
        cardButton.enabled = !card.isUnplayable;
        
        cardButton.alpha = card.isUnplayable ? INACTIVE_ALPHA : ACTIVE_ALPHA;
    }
    [super updateUI];
    // updating cards view
    
}

@end
