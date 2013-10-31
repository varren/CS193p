//
//  PlayingCardCollectionViewCell.m
//  Matchismo
//
//  Created by mmh on 18/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "CardCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation CardCollectionViewCell

-(void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    CALayer * layer = [self layer];
    layer.borderColor = borderColor.CGColor;
    layer.borderWidth = 3.0;
    layer.cornerRadius = 6.0;
    [self setNeedsDisplay];
}


@end
