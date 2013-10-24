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

-(id)initCardOf: (NSUInteger)number shape: (NSUInteger)shape color: (NSUInteger)color shading:(NSUInteger)shading;

@property(readonly, nonatomic)NSUInteger shape;
@property(readonly, nonatomic)NSUInteger color;
@property(readonly, nonatomic)NSUInteger number;
@property(readonly, nonatomic)NSUInteger shading;

+(NSArray *)validShape; //of NSString
+(NSArray *)validColor; //of NSString
+(NSArray *)validShading; // float (alpha)
+(NSArray *)validNumbers; // int



@end
