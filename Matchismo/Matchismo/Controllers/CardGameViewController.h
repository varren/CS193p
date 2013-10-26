//
//  CardGameViewController.h
//  Matchismo
//
//  Created by mmh on 31/07/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h" 

@interface CardGameViewController : UIViewController

-(Deck*) createDeck; //abstract
@property (nonatomic) NSInteger startCardsCount; // abstract
@property (nonatomic) NSInteger gameType; //abstract
@property(nonatomic) int mode; //abstract
@property(nonatomic) BOOL saveMatches; // default is YES;
-(void)updateCell: (id) cardCell usingCard: (Card*)card; // abstract

// can override next methods but also need to use [super ...] version 
-(void)startNewGame;
-(void)flipCardAtIndex: (NSInteger) index;
- (int)addCards: (NSInteger) numCardsToAdd;
@end
