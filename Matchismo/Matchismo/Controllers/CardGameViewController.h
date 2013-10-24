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

@property (readonly, strong, nonatomic) CardMatchingGame *game;


-(Deck*) createDeck; //abstract
@property (nonatomic) NSInteger startCardsCount; // abstract
@property (nonatomic) NSInteger gameType; //abstract
-(void)updateCell: (id) cardCell usingCard: (Card*)card withGameState: (BOOL) needState; // probably want to override it
-(int) mode;
@property(nonatomic) BOOL keepMatchedCards; // default is YES;
@end
