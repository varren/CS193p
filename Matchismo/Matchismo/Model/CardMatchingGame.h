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
             usingDeck:(Deck *) deck
               andMode:(int)mode;

-(void)flipCardAtIndex:(NSUInteger) index;
-(Card *)cardAtIndex:(NSUInteger) index;
-(NSArray*) allFlippedCards;
@property (readonly, strong, nonatomic) NSMutableArray *matchedCards;

-(int)addCard;
-(int)addCardAtIndex:(NSInteger) index;
-(void)saveMatchForIndex:(NSInteger)index;
-(void)removeCardAtIndex:(NSInteger)index;
-(NSArray*)findPossibleSolution;

@property (nonatomic) int currentCardsCount;
@property (nonatomic) int mode; //2, 3, 4... cards matching mode

@property (readonly, nonatomic) int score;
@property (readonly, nonatomic) GAME_STATUS status;
@property (readonly, nonatomic) int lastTurnScore;


//interfaces for scoring
@property (readonly, nonatomic) int matchBonus;
@property (readonly, nonatomic) int mismatchPenalty;
@property (readonly, nonatomic) int flipCost;
@property (readonly, nonatomic) int difficulty;


@end