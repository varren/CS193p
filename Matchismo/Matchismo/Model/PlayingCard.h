//
//  PlayingCard.h
//  Matchismo
//
//  Created by mmh on 05/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+(NSArray *)validSuits;
+(NSUInteger)maxRank;


@end
