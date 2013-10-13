//
//  CardGameViewController.h
//  Matchismo
//
//  Created by mmh on 31/07/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardGame.h"
@interface CardGameViewController : UIViewController

@property (readonly, strong, nonatomic) CardGame *game;
@property (readonly, strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@property (nonatomic) NSInteger cardsCount; // abstract
-(Deck*) createDeck; // abstract

-(void)updateUI;
@end
