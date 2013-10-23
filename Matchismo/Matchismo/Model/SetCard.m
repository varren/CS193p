//
//  SetCard.m
//  Matchismo
//
//  Created by mmh on 12/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "SetCard.h"
@interface SetCard()
@property(strong, nonatomic)NSNumber *shape;
@property(strong, nonatomic)NSNumber *color;
@property(strong, nonatomic)NSNumber *number;
@property(strong, nonatomic)NSNumber *shading;

@end
@implementation SetCard

-(id)initCardOf: (NSNumber *)number shape: (NSNumber*)shape color: (NSNumber*)color shading:(NSNumber*) shading{
    self = [super init];
    if(self){
        _shape = shape;
        _color = color;
        _number = number;
        _shading = shading;
    }
    return self;
}

#define MATCH_SCORES 5

-(int)match:(NSArray *)otherCards{
    
    for (NSString* property in self.properties)
        if(![self isValidSet: property forCards: otherCards])
            return -MATCH_SCORES/2;
    
    return MATCH_SCORES;
  
}
        
#define ALL_THE_SAME 1
-(BOOL)isValidSet: (NSString*) property forCards:(NSArray *)otherCards{
    NSMutableSet *valuesSet = [[NSMutableSet alloc] initWithObjects:[self valueForKey:property], nil];
    [valuesSet  addObjectsFromArray: [otherCards valueForKey:property]];
    return valuesSet.count == otherCards.count + 1 || valuesSet.count == ALL_THE_SAME;
}

-(NSArray*)properties{
    return @[@"shape", @"number", @"color", @"shading"];
}
+(NSArray *)validShape{
    return @[@(DIAMOND), @(SQUIGGLE), @(OVAL)];
}
+(NSArray *)validColor{
    return @[@(RED), @(GREEN), @(PURPLE)];
}
+(NSArray *)validShading{
    return @[@(SOLID), @(STRIPED), @(OPEN)];
}
+(NSArray *)validNumbers{
    return @[@(1), @(2), @(3)];
}

-(NSString *)stringShape{return @[@"■",@"▲", @"●"][[self.shape intValue]];}

-(NSString *)contents{
    return [self.stringShape stringByPaddingToLength:[self.number intValue] withString:self.stringShape  startingAtIndex:0];
}

@end
