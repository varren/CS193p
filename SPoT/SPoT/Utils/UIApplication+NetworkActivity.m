//
//  UIApplication+NetworkActivity.m
//  SPoT
//
//  Created by mmh on 24/01/2014.
//  Copyright (c) 2014 mmh. All rights reserved.
//

#import "UIApplication+NetworkActivity.h"

@implementation UIApplication (NetworkActivity)

static NSInteger networkActivities;

+(void)showNetworkActivityIndicator{
    @synchronized(self){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        networkActivities++;
    }
}

+(void)hideNetworkActivityIndicator{
    @synchronized(self){
        networkActivities--;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = networkActivities ? YES: NO;
    }
}
@end
