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
        for (NSString *shape in [SetCard validShape]) 
            for (UIColor *color in [SetCard validColor]) 
                for (NSNumber *number in [SetCard validNumbers]) 
                    for (NSString *shading in [SetCard validShading]){
                        Card *card = [[SetCard alloc] initCardOf: number shape: shape color: color shading: shading];
                        
                        [self addCard:card atTop:YES];
                    }
        
    }
    return self;
}
@end
