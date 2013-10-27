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

-(Card *)cardAtIndex:(NSUInteger) index;
-(NSArray*) flippedCards;
-(NSArray*) matchedCards;

@property (nonatomic) int currentCardsCount;

-(int)addCards:(NSInteger) numberOfCrds;
-(void)saveMatchForIndex:(NSInteger)index;
-(void)removeCardAtIndex:(NSInteger)index;
-(void)flipCardAtIndex:(NSUInteger) index;

-(NSArray*)findPossibleSolution;

@property (readonly, nonatomic) GAME_STATUS status;

-(int)scoreForPlayer:(NSInteger) playerIndex;
@property (readonly, nonatomic) int currentPlayer;
-(void)endOfTurnForPlayer: (NSInteger) player;

@property(readonly, nonatomic) int lastTurnScore;

//interfaces for scoring
@property (readonly, nonatomic) int bonus;
@property (readonly, nonatomic) int penalty;
@property (readonly, nonatomic) int flipCost;
@property (readonly, nonatomic) int difficulty;


@end