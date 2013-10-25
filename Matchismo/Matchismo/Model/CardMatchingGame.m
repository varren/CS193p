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
@property (strong, nonatomic) NSMutableArray *flippedCards;
@property (strong, nonatomic) NSMutableArray *matchedCards;
@property (readwrite, nonatomic) int score;

@property (nonatomic) int lastTurnScore;
@property (strong,nonatomic) Deck *deck;
@property (nonatomic) GAME_STATUS status;

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
-(NSMutableArray *)matchedCards{
    if (!_matchedCards) {
        _matchedCards = [NSMutableArray array];
    }
    
    return  _matchedCards;
}

-(NSArray*) allFlippedCards{
    return [self.flippedCards copy];
}

#define DEFAULT_MODE 3

-(int) mode{
    if(!_mode) _mode = DEFAULT_MODE;
    return _mode;
}

-(int)currentCardsCount{
    return [self.cards count];
}

-(id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck{
    self = [super init];
    self.deck = deck;
    
    for (int i = 0; i < count; i++) {
        if([self addCard] == 0){
            NSLog(@"Can`t init deck");
            self = nil;
            break;
        }
    }
    
    self.status = NEW_GAME;
    return self;
}

-(Card *)cardAtIndex:(NSUInteger)index{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

-(void)flipCardAtIndex:(NSUInteger)index{
    
    Card *card = [self cardAtIndex:index];
    if(!card.isUnplayable){ //have some user interaction after this step
        
        if(self.status == GOT_MATCH || self.status == GOT_MISMATCH)
            self.flippedCards = [[NSMutableArray alloc] init];
        
        self.lastTurnScore = 0;
        self.status = FLIPPED_A_CARD;
        
        if(!card.isFaceUp){

            if([self.flippedCards count] + 1 == self.mode) // got n cards flipped according to mode
                [self calculateScoreFor:card with: self.flippedCards];

            [self.flippedCards addObject:card];
        } else {
            [self.flippedCards removeObject:card];
        }
        
        card.faceUp = !card.isFaceUp;
        self.score += self.lastTurnScore ;
        self.score -= self.flipCost;
    }
}

-(void)calculateScoreFor:(Card*)card with: (NSArray *)otherCards{
    
    self.lastTurnScore = [card match:otherCards];
    
    if (self.lastTurnScore > 0) {
        self.lastTurnScore *= self.matchBonus;
        for (Card *otherCard in otherCards)
            otherCard.unplayable = YES;
        card.unplayable = YES;
        self.status = GOT_MATCH;
        

        
    } else {
        self.status = GOT_MISMATCH;
        self.lastTurnScore -= self.mismatchPenalty;
        for (Card *otherCard in otherCards)
            otherCard.faceUp = NO;
        card.faceUp = YES;
    }
}

-(int)addCard{
    return [self addCardAtIndex:self.cards.count];
}

-(int)addCardAtIndex:(NSInteger) index{
    int cardsAdded = 0;

    if(self.cards.count >= index || index >= 0){
        Card *card = [self.deck drawRandomCard];
        if(card){
            self.cards[index] = card;
            cardsAdded = 1;
        }
    }
    
    return cardsAdded;
}

-(void)saveAndRemoveMatchAtIndex:(NSInteger)index{
    if(self.cards.count > index || index >= 0){
        [self.matchedCards addObject:self.cards[index]];
        [self.cards removeObjectAtIndex:index];
    }

}


-(void)removeCardAtIndex:(NSInteger)index {
    if(self.cards.count > index || index >= 0){
        [self.cards removeObjectAtIndex:index];
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
