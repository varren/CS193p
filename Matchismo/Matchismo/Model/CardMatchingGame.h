//
//  CardGame.h
//  Matchismo
//
//  Created by mmh on 12/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

typedef NS_ENUM(NSUInteger, GAME_STATUS) {NEW_GAME, GOT_MATCH, GOT_MISMATCH, FLIPPED_A_CARD};

@interface CardMatchingGame : NSObject

//designated init
-(id)initWithCardCount:(NSUInteger) cardCount
          numOfPlayers:(NSInteger)playersNum
             usingDeck:(Deck *) deck
               andMode:(int)mode;

@property (nonatomic) int mode; //2, 3, 4... cards matching mode

// cards
-(Card *)cardAtIndex: (NSUInteger) index;
@property (nonatomic) int currentCardsCount;
-(int)addCards: (NSInteger) numberOfCards;
-(void)removeCardAtIndex: (NSInteger) index;

// flipped cards
-(NSArray*) flippedCards;
-(void)flipCardAtIndex: (NSUInteger) index;

// matched cards
-(NSArray*) matchAtIndex: (NSInteger) index forPlayer:(NSInteger) player;
-(int)numberOfMatchesForPlayer:(NSInteger) player;

// ...
-(NSArray*)findPossibleSolution;

@property (readonly, nonatomic) GAME_STATUS status;
@property(readonly, nonatomic) int lastTurnScore;

@property (readonly, nonatomic) int currentPlayer;
-(int)scoreForPlayer: (NSInteger) playerIndex;

-(void)givePenaltyForPlayer:(NSInteger) playerIndex;
-(void)endOfTurnForPlayer: (NSInteger) player;
-(BOOL)hasSolution;


//interfaces for scoring
@property (nonatomic) int bonus;
@property (nonatomic) int penalty;
@property (nonatomic) int flipCost;
@property (nonatomic) int difficulty;


@end