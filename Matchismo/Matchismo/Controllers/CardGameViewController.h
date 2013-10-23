//
//  CardGameViewController.h
//  Matchismo
//
//  Created by mmh on 31/07/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"


@interface CardGameViewController : UIViewController

-(Deck*) createDeck; //abstract
@property (nonatomic) NSInteger startCardsCount; // abstract
@property (nonatomic) NSInteger gameType; //abstract
-(void)updateCell: (id) cardCell usingCard: (Card*)card; // abstract
-(int) mode; 
@end
