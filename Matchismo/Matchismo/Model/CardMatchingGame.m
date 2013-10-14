//
//  CardGame.m
//  Matchismo
//
//  Created by mmh on 12/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (readwrite, nonatomic) int score;
@property (strong, nonatomic) NSMutableArray *flippedCards;
@property (nonatomic) int lastTurnScore;


@end

@implementation CardMatchingGame

-(NSMutableArray *) cards{
    if(!_cards)_cards =[[NSMutableArray alloc]init];
    return _cards;
}

-(NSMutableArray *) flippedCards{
    if(!_flippedCards)_flippedCards =[[NSMutableArray alloc]init];
    return _flippedCards;
}
-(NSArray*) allFlippedCards{
    return [self.flippedCards copy];
}

#define DEFAULT_MODE 3

-(int) mode{
    if(!_mode) _mode = DEFAULT_MODE;
    return _mode;
}


-(id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck{
    self = [super init];
    
    if (self) {
        for (int i =0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if(!card){
                self = nil;
            }else{
                self.cards[i] = card;
            }
        }
    }
    
    return self;
}


-(Card *)cardAtIndex:(NSUInteger)index{
    return (index < self.cards.count) ? self.cards[index] : nil;
}



-(void)flipCardAtIndex:(NSUInteger)index{
    
    Card *card = [self cardAtIndex:index];
    if(!card.isUnplayable){ //have some user interaction after this step
        self.flippedCards = [[NSMutableArray alloc] init];
        self.lastTurnScore = 0;

        if(!card.isFaceUp){
            
            for (Card *otherCard in self.cards)
                if (otherCard.isFaceUp && !otherCard.isUnplayable)
                    [self.flippedCards  addObject:otherCard];
  
            if([self.flippedCards count] + 1 == self.mode) // got n cards flipeed according to mode
                [self calculateScoreFor:card with: self.flippedCards];
            
        }
        
        [self.flippedCards addObject:card];
        card.faceUp = !card.isFaceUp;
        self.score += self.lastTurnScore ;
        self.score -= self.flipCost;
    }
}


-(void)calculateScoreFor:(Card*)card with: (NSArray *)otherCards{
    
    self.lastTurnScore = [card match:otherCards];
    
    if (self.lastTurnScore) {
        self.lastTurnScore *= self.matchBonus;
        for (Card *otherCard in otherCards)
            otherCard.unplayable = YES;
        card.unplayable = YES;
    } else {
        self.lastTurnScore -= self.mismatchPenalty;
        for (Card *otherCard in otherCards)
            otherCard.faceUp = NO;
    }
}

# define DIFFICALTY_COEFFITIENT 2/MISMATCH_PENALTY
# define MISMATCH_PENALTY self.mode
# define MATCH_BONUS 4 * DIFFICALTY_COEFFITIENT
# define FLIP_COST 1
-(int)matchBonus{return MATCH_BONUS;}
-(int)flipCost{return FLIP_COST;}
-(int)difficulty{return DIFFICALTY_COEFFITIENT;}
-(int)mismatchPenalty{return MISMATCH_PENALTY;}


@end
