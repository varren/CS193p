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

-(NSString*)flippedCardsDescription{
    return [[self.flippedCards valueForKey:@"contents"] componentsJoinedByString:@" & "];
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
    
    if(self) NSLog(@"Game init successful");
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
    if(!card.isUnplayable){ //have some user interaction after this step
        self.flippedCards = [[NSMutableArray alloc] initWithObjects:card, nil];
        self.lastTurnScore = 0;

        
        if(!card.isFaceUp){
            
            for (Card *otherCard in self.cards)
                if (otherCard.isFaceUp && !otherCard.isUnplayable)
                    [self.flippedCards  addObject:otherCard];
            
            NSLog(@"cards flipped = %d", [self.flippedCards count]);
            if([self.flippedCards count] == self.mode) // got n cards flipeed according to mode
                [self calculateScoreFor: self.flippedCards];
        }
         NSLog(@"status = %d", self.mode);
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
    
    NSLog(@"score = %d", self.lastTurnScore);
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
    
    if ([self.flippedCards count] == 0) // because there can be 0 cards only on start of a new game
        status = @"New Game Started";
    else if (self.lastTurnScore > 0)
        status = [NSString stringWithFormat:@"Matched %@ for %d points", [self flippedCardsDescription], self.lastTurnScore];
    else if (self.lastTurnScore < 0)
        status = [NSString stringWithFormat:@"%@ don't match! %d points penalty", [self flippedCardsDescription], self.lastTurnScore];
    else if (self.lastTurnScore == 0)
        status = [NSString stringWithFormat:@"Flipped %@", ((Card *)self.flippedCards[0]).contents];
    
    return status;
}

@end
