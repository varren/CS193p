//
//  SetDeck.m
//  Matchismo
//
//  Created by mmh on 12/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "SetDeck.h"
#import "SetCard.h"

@implementation SetDeck
-(id)init{
    self = [super init];
    if(self){
        for (NSNumber *shape in [SetCard validShape]) 
            for (NSNumber *color in [SetCard validColor]) 
                for (NSNumber *number in [SetCard validNumbers]) 
                    for (NSNumber *shading in [SetCard validShading]){
                        SetCard *card = [[SetCard alloc] initCardOf: [number intValue] shape: [shape intValue] color: [color intValue] shading: [shading intValue]];
                        
                        [self addCard:card atTop:YES];
                    }
        
    }
    return self;
}
@end
