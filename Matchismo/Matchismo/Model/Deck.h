//
//  Deck.h
//  Matchismo
//
//  Created by mmh on 05/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void) addCard:(Card *)card atTop:(BOOL)atTop;

- (Card *)drawRandomCard;

@end
