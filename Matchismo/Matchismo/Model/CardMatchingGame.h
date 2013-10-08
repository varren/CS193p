//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by mmh on 06/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
@interface CardMatchingGame : NSObject

//designated init
-(id)initWithCardCount:(NSUInteger) cardCount
             usingDeck:(Deck *) deck;

-(id)initWithCardCount:(NSUInteger) cardCount
             usingDeck:(Deck *) deck
               andMode:(int) mode;

-(void)flipCardAtIndex:(NSUInteger) index;
-(Card *)cardAtIndex:(NSUInteger) index;

-(void)setMode:(int) mode;
-(NSString *)status;

@property (nonatomic,readonly) int score;

@end
