//
//  SharedDocument.m
//  SPoT
//
//  Created by mmh on 22/01/2014.
//  Copyright (c) 2014 mmh. All rights reserved.
//

#import "SharedDocument.h"

@implementation SharedDocument
#pragma mark - Singletone

static SharedDocument *sharedSingleton;

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedSingleton = [[SharedDocument alloc] init];
  
    }
}

+(SharedDocument *) instance{
    return sharedSingleton;
}
@end
