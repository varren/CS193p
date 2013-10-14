//
//  CardGame.h
//  Matchismo
//
//  Created by mmh on 12/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
@interface CardMatchingGame : NSObject

//designated init
-(id)initWithCardCount:(NSUInteger) cardCount
             usingDeck:(Deck *) deck;

-(void)flipCardAtIndex:(NSUInteger) index;
-(Card *)cardAtIndex:(NSUInteger) index;
-(NSArray*) allFlippedCards;

//2, 3, 4... cards matching mode
@property (nonatomic) int mode; //abstract


@property (readonly, nonatomic) int score;
@property (readonly, nonatomic) int lastTurnScore;


//interfaces for scoring
@property (readonly, nonatomic) int matchBonus;
@property (readonly, nonatomic) int mismatchPenalty;
@property (readonly, nonatomic) int flipCost;
@property (readonly, nonatomic) int difficulty;


@end