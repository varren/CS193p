//
//  SetCard.m
//  Matchismo
//
//  Created by mmh on 12/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "SetCard.h"
@interface SetCard()
@property(strong,nonatomic)NSString *shape;
@property(strong,nonatomic)UIColor *color;
@property(nonatomic) NSInteger number;
@property(nonatomic)double shading;

@end
@implementation SetCard

-(id)initCardOf: (NSNumber *)number shape: (NSString*)shape color: (UIColor*)color shading:(NSNumber*) shading{
    self = [super init];
    if(self){
        _shape = shape;
        _color = color;
        _number = [number intValue];
        _shading = [shading doubleValue];
    }
    return self;
}

#define MATCH_SCORES 10

-(int)match:(NSArray *)otherCards{
    NSMutableSet *shapes = [[NSMutableSet alloc] initWithObjects:self.shape, nil];
    NSMutableSet *number = [[NSMutableSet alloc] initWithObjects:@(self.number), nil];
    NSMutableSet *color =[[NSMutableSet alloc] initWithObjects:self.color, nil];
    NSMutableSet *shading = [[NSMutableSet alloc] initWithObjects:@(self.shading), nil];
    
    for (SetCard* otherCard in otherCards) {
        [shapes addObject:otherCard.shape];
        [number addObject:@(otherCard.number)];
        [color addObject:otherCard.color];
        [shading addObject:@(otherCard.shading)];
    }
    
    if([self isValidSetOfShapes:shapes number:number color:color shading:shading ofSize:otherCards.count + 1])
        return MATCH_SCORES;
    else
        return -MATCH_SCORES/2;
  
}
        
-(BOOL)isValidSetOfShapes: (NSSet*) shapes number:(NSSet *)number color:(NSSet *)color shading:(NSSet *)shading ofSize: (NSInteger) size{
    return [self isValidSet: shapes ofSize:size] &&
           [self isValidSet: number ofSize:size] &&
           [self isValidSet: color ofSize:size] &&
           [self isValidSet: shading ofSize:size] ;
    
}
#define ALL_THE_SAME 1
-(BOOL)isValidSet: (NSSet*) set ofSize: (NSInteger) size{
    return set.count == size || set.count == ALL_THE_SAME;
}

+(NSArray *)validShape{
    return @[@"▲", @"●", @"■"];
}

+(NSArray *)validColor{
    return @[[UIColor blueColor],[UIColor greenColor],[UIColor redColor]];
}
+(NSArray *)validShading{
    return @[@(0.0), @(0.2), @(1.0)]; //alpha
}

+(NSArray *)validNumbers{
    return @[@(1),@(2),@(3)];
}

-(NSString *)contents{
    return [self.shape stringByPaddingToLength:self.number withString:self.shape startingAtIndex:0];
}

@end
