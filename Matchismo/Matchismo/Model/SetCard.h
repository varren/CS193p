//
//  SetCard.h
//  Matchismo
//
//  Created by mmh on 12/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

-(id)initCardOf: (NSNumber *)number shape: (NSString*)shape color: (UIColor*)color shading:(NSString*)shading;

@property(readonly, strong, nonatomic)NSString *shape;
@property(readonly, strong, nonatomic)NSString *color;
@property(readonly, strong, nonatomic)NSNumber *number;
@property(readonly, strong, nonatomic)NSNumber *shading;

+(NSArray *)validShape; //of NSString
+(NSArray *)validColor; //of NSString
+(NSArray *)validShading; // float (alpha)
+(NSArray *)validNumbers; // int



@end
