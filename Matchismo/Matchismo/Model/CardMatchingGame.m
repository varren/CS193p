//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by mmh on 06/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (readwrite, nonatomic) int score;
@property (nonatomic) int mode; // 2, 3 or 4... cards matching mode
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
-(NSString*)flippedCardsDesc{
    return [[self.flippedCards valueForKey:@"contents"] componentsJoinedByString:@" & "];
}

#define DEFAULT_GAME_MODE 2 // 2-cards mathcing game
-(int) mode{
    return (!_mode) ? DEFAULT_GAME_MODE : _mode;
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

-(id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck andMode: (int) mode{
    self = [self initWithCardCount:count usingDeck:deck];
    self.mode = mode;
    return self;
}

-(Card *)cardAtIndex:(NSUInteger)index{
    return (index < self.cards.count) ? self.cards[index] : nil;
}
# define MISMATCH_PENALTY self.mode
# define MATCH_BONUS 4
# define FLIP_COST 1
# define DIFFICALTY_COEFFITIENT 2/MISMATCH_PENALTY
-(void)flipCardAtIndex:(NSUInteger)index{
 
    Card *card = [self cardAtIndex:index];
    if(!card.isUnplayable){
        self.lastTurnScore = 0;
        self.flippedCards = [[NSMutableArray alloc]initWithObjects:card, nil];
        
        if(!card.isFaceUp){

            for (Card *otherCard in self.cards)
                if (otherCard.isFaceUp && !otherCard.isUnplayable)
                    [self.flippedCards  addObject:otherCard];
        
        
            if([self.flippedCards  count] == self.mode) //got n cards flipeed according to mode
                [self calculateScoreFor: self.flippedCards];
        }
        
        card.faceUp = !card.isFaceUp;
        
        self.score += self.lastTurnScore ;
        self.score -= FLIP_COST;
    }
}



// here is main maching algorithm for card combinations
-(void)calculateScoreFor: (NSArray *)cards{
    
    for (int i = 0; i < [cards count]; i++) 
        for (int j = i + 1; j < [cards count]; j++) 
            self.lastTurnScore += [cards[i] match:@[cards[j]]];
        
    
    if (self.lastTurnScore) {
        self.lastTurnScore *= MATCH_BONUS * DIFFICALTY_COEFFITIENT;
        for (Card *card in cards)
            card.unplayable = YES;
    }
    else  {
        self.lastTurnScore -= MISMATCH_PENALTY;
        for (Card *card in cards)
            card.faceUp = NO;
    }
}


-(NSString *) status{
    NSString *status = @"";
    if ([self.flippedCards count] == 0 ) status = @"New Game Started";
    else if (self.lastTurnScore > 0) status = [NSString stringWithFormat:@"Matched %@ for %d points", [self flippedCardsDesc], self.lastTurnScore];
    else if (self.lastTurnScore < 0) status = [NSString stringWithFormat:@"%@ don't match! %d points penalty", [self flippedCardsDesc], self.lastTurnScore];
    else if (self.lastTurnScore == 0) status = [NSString stringWithFormat:@"Flipped up %@", ((Card *)self.flippedCards[0]).contents];
    return status;
}

@end