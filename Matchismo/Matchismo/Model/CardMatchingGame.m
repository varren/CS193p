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
@property (strong, nonatomic) NSMutableArray *mutableFlippedCards;
@property (strong, nonatomic) NSMutableDictionary *matchedCardsForPlayer; // dictionary of @{player : mutableMatchesArray} and mutableMatchesArray consists of MatchesArrays of game-mode number of cards

@property (nonatomic) int currentPlayer;
@property (strong, nonatomic) NSMutableArray * scores;
@property (nonatomic) int lastTurnScore;

@property (strong,nonatomic) Deck *deck;
@property (nonatomic) GAME_STATUS status;
@property (nonatomic) int currentPlayerScore;

@end

@implementation CardMatchingGame;

#pragma mark - Properties

-(NSMutableArray *) cards{
    if(!_cards)_cards =[[NSMutableArray alloc]init];
    return _cards;
}

-(void)setCurrentPlayer:(int)currentPlayer{
    _currentPlayer = currentPlayer;
    
    if(_currentPlayer >= [self.scores count])
        _currentPlayer = 0;
}

-(NSMutableArray *) mutableFlippedCards{
    if(!_mutableFlippedCards)_mutableFlippedCards =[[NSMutableArray alloc]init];
    return _mutableFlippedCards;
}

-(NSMutableDictionary *)matchedCardsForPlayer{
    if (!_matchedCardsForPlayer) _matchedCardsForPlayer = [NSMutableDictionary dictionary];
        
    
    return  _matchedCardsForPlayer;
}

-(NSMutableArray *)scores{
    if(!_scores) _scores = [[NSMutableArray alloc] init];
    return _scores;
}

-(NSArray*) flippedCards{
    return [self.mutableFlippedCards copy];
}

-(NSArray*) matchedCardsForPlayer: (NSInteger) player{
    return [self.matchedCardsForPlayer[@(player)] copy];
}

-(int)currentCardsCount{
    return [self.cards count];
}

@synthesize currentPlayerScore = _currentPlayerScore;

-(int) currentPlayerScore{
    return [self.scores[self.currentPlayer] integerValue];
}

-(void)setCurrentPlayerScore: (NSInteger) score{
    self.scores[self.currentPlayer] =  @(score);
}

#pragma mark - Initialisztion

-(id)initWithCardCount:(NSUInteger)count numOfPlayers:(NSInteger)playersNum usingDeck:(Deck *)deck andMode:(int)mode{
    self = [super init];
    _deck = deck;
    _mode = mode;

    
    for(int i = 0 ; i  < playersNum; i++){
        [self.scores addObject:@(0)];
        self.matchedCardsForPlayer[@(i)] = [NSMutableArray array];
    }
    
    
    for (int i = 0; i < count; i++) {
        if([self addCardAtIndex:[self.cards count]] == 0){
            NSLog(@"Can`t init deck");
            self = nil;
            break;
        }
    }
    
    self.status = NEW_GAME;
    return self;
}

#pragma mark - Card Manipulation fns

-(Card *)cardAtIndex:(NSUInteger)index{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

-(void)flipCardAtIndex:(NSUInteger)index{
    
    Card *card = [self cardAtIndex:index];
    if(!card.isUnplayable){ //have some user interaction after this step
        
        if(self.status == GOT_MATCH || self.status == GOT_MISMATCH)
            self.mutableFlippedCards = [[NSMutableArray alloc] init];
        
        self.lastTurnScore = 0;
        self.status = FLIPPED_A_CARD;
        
        if(!card.isFaceUp){

            if([self.mutableFlippedCards count] + 1 == self.mode) // got n cards flipped according to mode
                [self calculateScoreFor:card with: self.mutableFlippedCards];

            [self.mutableFlippedCards addObject:card];
        } else {
            [self.mutableFlippedCards removeObject:card];
        }
        
        card.faceUp = !card.isFaceUp;

         self.currentPlayerScore -= self.flipCost;
    }
}

// Helper fn to score after flipping cards
-(void)calculateScoreFor:(Card*)card with: (NSArray *)otherCards{
    
    self.lastTurnScore = [card match:otherCards];
    
    if (self.lastTurnScore > 0) {
        self.lastTurnScore *= self.bonus;
        for (Card *otherCard in otherCards)
            otherCard.unplayable = YES;
        card.unplayable = YES;
        self.status = GOT_MATCH;
        
    } else {
        self.status = GOT_MISMATCH;
        self.lastTurnScore -= self.penalty;
        for (Card *otherCard in otherCards)
            otherCard.faceUp = NO;
        card.faceUp = YES;
    }
}

-(int)addCards:(NSInteger) numberOfCrds{
    int cardsAdded = 0;
    
 
    self.currentPlayerScore -= ([[self findPossibleSolution] count] == 0) ?: self.penalty;
    
    for (int i = 0 ; i<numberOfCrds; i++)
            cardsAdded += [self addCardAtIndex:[self.cards count]];
    

    
    return cardsAdded;
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

-(void)removeCardAtIndex:(NSInteger)index {
    if(self.cards.count > index || index >= 0)
        [self.cards removeObjectAtIndex:index];
    
}



-(NSArray*)findPossibleSolution{
    NSArray* found = [self findPossibleSolutionForCards:[NSMutableArray array] andCardAtIndex:0];
    //[self debugLogCardsIn:found];
    return found;
}

//helper recursive fn
-(NSArray*)findPossibleSolutionForCards:(NSMutableArray*)otherCards andCardAtIndex:(NSInteger)index{
    //[self debugLogCardsIn: otherCards];
    if(index >= [self.cards count] || [otherCards count] > self.mode)return nil;
    
    if([otherCards count] == self.mode){
        int score = [otherCards[0] match:[otherCards subarrayWithRange:NSMakeRange(1, [otherCards count] - 1)]];
        if(score > 0) return otherCards;        
    }

    for (int i = index; i < [self.cards count]; i++){
        Card* card = [self cardAtIndex:i];
        if(!card.isUnplayable){
            [otherCards addObject:card];
            
            if([self findPossibleSolutionForCards:otherCards andCardAtIndex:i + 1]) 
                return otherCards;
            
            [otherCards removeObject:card];
        }
    }
    return nil;
}

//debug fn
-(void)debugLogCardsIn: (NSArray*)cards{
    NSMutableString *text = [NSMutableString stringWithFormat:@"Size:%d: ", [cards count]];
    
    for (Card * card in cards)
        [text appendFormat:@" %d ", [self.cards indexOfObject:card]];
    
    NSLog(@" %@",text);
}
-(void)debugAllMatchedCards{
    NSMutableString *text = [NSMutableString stringWithFormat:@"Size:%d: ", [self.matchedCardsForPlayer count]];
    
    for (NSNumber *player in self.matchedCardsForPlayer.keyEnumerator){
        NSArray * matchedCards = self.matchedCardsForPlayer[player];
        [text appendFormat:@"\n%d): size %d ",[player intValue],[matchedCards count]];
        for (NSArray *match in matchedCards) {
             [text appendFormat:@" | %d", [match count]];
        }
    
    }
    
    NSLog(@" %@",text);
    
    
}

#pragma mark - Players related fns

-(int)scoreForPlayer:(NSInteger) playerIndex{
    return [self.scores[playerIndex] integerValue];
}

-(void) endOfTurnForPlayer: (NSInteger) player{
  
    self.currentPlayer = player;
    [self debugAllMatchedCards];
    if (self.status == GOT_MATCH)
        [self.matchedCardsForPlayer[@(self.currentPlayer )] addObject: self.flippedCards];
    [self debugAllMatchedCards];
    self.currentPlayerScore += self.lastTurnScore;
    self.currentPlayer++;
    
}

#pragma mark - Scoring coefficients

# define DIFFICALTY_COEFFITIENT 2/MISMATCH_PENALTY
# define MISMATCH_PENALTY self.mode
# define MATCH_BONUS 4 * DIFFICALTY_COEFFITIENT
# define FLIP_COST 1

-(int)bonus{return MATCH_BONUS;}
-(int)flipCost{return FLIP_COST;}
-(int)difficulty{return DIFFICALTY_COEFFITIENT;}
-(int)penalty{return MISMATCH_PENALTY;}

@end
