//
//  SetCard.h
//  Matchismo
//
//  Created by mmh on 12/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "Card.h"
typedef NS_ENUM(NSUInteger, SET_COLOR)   {RED,     GREEN,    PURPLE};
typedef NS_ENUM(NSUInteger, SET_SHAPE)   {DIAMOND, SQUIGGLE, OVAL  };
typedef NS_ENUM(NSUInteger, SET_SHADING) {SOLID,   STRIPED,  OPEN  };

@interface SetCard : Card

-(id)initCardOf: (NSNumber *)number shape: (NSNumber*)shape color: (NSNumber*)color shading:(NSNumber*)shading;

@property(readonly, strong, nonatomic)NSNumber *shape;
@property(readonly, strong, nonatomic)NSNumber *color;
@property(readonly, strong, nonatomic)NSNumber *number;
@property(readonly, strong, nonatomic)NSNumber *shading;

+(NSArray *)validShape; //of NSString
+(NSArray *)validColor; //of NSString
+(NSArray *)validShading; // float (alpha)
+(NSArray *)validNumbers; // int



@end
