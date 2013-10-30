//
//  MatchedCardsView.m
//  Matchismo
//
//  Created by mmh on 30/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "MatchedCardsView.h"
#import "CardView.h"
@implementation MatchedCardsView
/*
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

#define CORNER_RADIUS 12
-(void)setup{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS];
    [roundedRect addClip];
    
    [[UIColor whiteColor]setFill];
    UIRectFill(self.bounds);
    
    CGFloat x = self.bounds.origin.x;
    CGFloat y = self.bounds.origin.y;
    CGFloat w = self.bounds.size.width / [self.cards count];
    CGFloat h = self.bounds.size.height;
    for (int i = 0; i < [self.cards count]; i++) {
       // CardView *cardView = self.cards[i];
        CGRect rect = CGRectMake(x + i * w , y, w, h);
        CardView *cardView =[[CardView alloc] initWithFrame:rect];
        cardView.
        [self addSubview:cardView];
        
    }
    for (CardView * card in self.cards) {
       
    }
    
    
}
*/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
