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

@interface CardGameViewController : UIViewController;

#pragma mark - Abstract
-(Deck*) createDeck; //abstract
@property (nonatomic) NSInteger startCardsCount; // abstract
@property (nonatomic) NSInteger gameType; //abstract
@property (nonatomic) int mode; //abstract
-(void)setGameDifficultyFor: (NSInteger) mode;

#pragma mark - Optional
-(void)updateView: (UIView*) cardView usingCard: (Card*)card; // abstract

-(void)endTurnForPlayer:(NSInteger) currentPlayer;

@property(nonatomic) int numberOfPlayers; // default is 1
@property(nonatomic) BOOL saveMatches; // default is YES;

#pragma mark - Required to use [super ...] version if overridden
// can override next methods but also need to use [super ...] version
-(void)startNewGame;
-(void)flipCardAtIndex:(NSInteger) index;
-(int)addCards: (NSInteger) numCardsToAdd;
-(void) setGameBonus:(NSInteger)bonus penalty:(NSInteger)penalty flipCost:(NSInteger) flipCost dificultyModifier: (NSInteger) difMod;
@end
