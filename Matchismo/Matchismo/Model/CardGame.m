//
//  CardGame.m
//  Matchismo
//
//  Created by mmh on 12/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "CardGame.h"

@interface CardGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (readwrite, nonatomic) int score;
@property (strong, nonatomic) NSMutableArray *flippedCards;
@property (nonatomic) int lastTurnScore;


@end

@implementation CardGame

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

# define DIFFICALTY_COEFFITIENT 2/MISMATCH_PENALTY
# define MISMATCH_PENALTY self.mode
# define MATCH_BONUS 4 * DIFFICALTY_COEFFITIENT
# define FLIP_COST 1

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
        self.score -= FLIP_COST;
    }
}


-(void)calculateScoreFor:(Card*)card with: (NSArray *)otherCards{
    
    self.lastTurnScore = [card match:otherCards];
    NSLog(@"%d", self.lastTurnScore);
    if (self.lastTurnScore) {
        self.lastTurnScore *= MATCH_BONUS;
        for (Card *otherCard in otherCards)
            otherCard.unplayable = YES;
        card.unplayable = YES;
    } else {
        self.lastTurnScore -= MISMATCH_PENALTY;
        for (Card *otherCard in otherCards)
            otherCard.faceUp = NO;
    }
}



@end
