//
//  MatchedCardsComboView.m
//  Matchismo
//
//  Created by mmh on 24/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "MatchedCardsComboView.h"
#import "CardView.h"
@implementation MatchedCardsComboView


#define CORNER_RADIUS 12.0
- (void)drawRect:(CGRect)rect
{
    UIBezierPath * roundedRect = [UIBezierPath bezierPathWithRoundedRect: self.bounds  cornerRadius:CORNER_RADIUS];
    
    [roundedRect addClip];
    
    
  
    
    [self.backgroundColor setFill];
    UIRectFill(self.bounds);
    [self drawCards];
}
-(void)drawCards{
  
}
@end
