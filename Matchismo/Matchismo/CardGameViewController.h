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

-(Deck*) createDeck; //abstract
@property (nonatomic) NSInteger cardsCount; // abstract
-(void)updateButton: (UIButton*) cardButton withCard: (Card*)card; // abstract
@end
