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
@property (strong, readwrite, nonatomic) NSString *lastActionStatus;
@property (nonatomic) int mode; // 2, 3 or 4... cards matching mode

@end

@implementation CardMatchingGame

-(NSMutableArray *) cards{
    if(!_cards)_cards =[[NSMutableArray alloc]init];
    return _cards;
}

// lastFlipStatus getter and setter
@synthesize lastActionStatus = _lastFlipStatus;

- (NSString *) lastActionStatus{
    return _lastFlipStatus ? _lastFlipStatus : @"";
}
-(void) setLastActionStatus:(NSString *)newStatus{
    _lastFlipStatus = newStatus;
}

#define DEFAULT_GAME_MODE 2 // 2-cards mathcing game
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
    self.mode = DEFAULT_GAME_MODE;
    self.lastActionStatus = @"New Game Started";
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
        if(!card.isFaceUp)
            [self checkMatch:card];
        card.faceUp = !card.isFaceUp;
    }
}

-(void) checkMatch: (Card *) card{
    self.lastActionStatus = [NSString stringWithFormat:@"Flipped up %@", card.contents];
    NSMutableArray *cards = [[NSMutableArray alloc]initWithObjects:card, nil];
    
    for (Card *otherCard in self.cards) 
        if (otherCard.isFaceUp && !otherCard.isUnplayable)
            [cards addObject:otherCard];
    
    if([cards count] == self.mode){ 
        int finalPoints = [self calculateMatchPointsFor: cards];
        [self setMatchStateForCards:cards scorePoints:finalPoints];
        self.score += finalPoints;
    }
    

    self.score -= FLIP_COST;
    
}
// here is main maching algorithm for card combinations
-(int)calculateMatchPointsFor: (NSArray *)cards{ 
    int finalPoints = 0;
    
    for (int i = 0; i < [cards count]; i++) 
        for (int j = i + 1; j < [cards count]; j++) 
            finalPoints += [cards[i] match:@[cards[j]]];
        
    
    if (finalPoints) finalPoints *= MATCH_BONUS * DIFFICALTY_COEFFITIENT;
    else  finalPoints -= MISMATCH_PENALTY;
    
    return finalPoints;
}

-(void) setMatchStateForCards:(NSArray *) otherCards scorePoints: (int) scorePoints {
    NSString *cardValues = [[otherCards valueForKey:@"contents"] componentsJoinedByString:@" & "];
    
    if (scorePoints > 0) {
        for (Card *otherCard in otherCards)
            otherCard.unplayable = YES;
        
        self.lastActionStatus = [NSString stringWithFormat:@"Matched %@ for %d points",
                                 cardValues, scorePoints];
    }else{
        for (Card *otherCard in otherCards)
            otherCard.faceUp = NO;
        
        self.lastActionStatus = [NSString stringWithFormat:@"%@ don't match! %d points penalty",
                                 cardValues, scorePoints];
        
    }
}
@end