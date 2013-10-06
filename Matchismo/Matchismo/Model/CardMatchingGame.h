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

-(id)initWithCardCount:(NSUInteger) cardCount
             usingDeck:(Deck *) deck;

-(void)flipCardAtIndex:(NSUInteger) index;
-(Card *)cardAtIndex:(NSUInteger) index;

@property (nonatomic,readonly) int score;
@end
