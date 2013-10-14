//
//  SetCard.m
//  Matchismo
//
//  Created by mmh on 12/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "SetCard.h"
@interface SetCard()
@property(strong, nonatomic)NSString *shape;
@property(strong, nonatomic)NSString *color;
@property(strong, nonatomic)NSNumber *number;
@property(strong, nonatomic)NSNumber *shading;

@end
@implementation SetCard

-(id)initCardOf: (NSNumber *)number shape: (NSString*)shape color: (NSString*)color shading:(NSNumber*) shading{
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
    return @[@"▲", @"●", @"■"];
}

+(NSArray *)validColor{
    return @[@"blueColor", @"greenColor", @"redColor"];
}
+(NSArray *)validShading{
    return @[@(0.0), @(0.2), @(1.0)]; //alpha
}

+(NSArray *)validNumbers{
    return @[@(1), @(2), @(3)];
}

-(NSString *)contents{
    return [self.shape stringByPaddingToLength:[self.number intValue] withString:self.shape startingAtIndex:0];
}

@end
