//
//  HeaderCollectionViewCell.m
//  Matchismo
//
//  Created by mmh on 30/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "HeaderCollectionViewCell.h"

@implementation HeaderCollectionViewCell
@synthesize color = _color;
-(UIColor*)color{
    if(!_color)_color = [UIColor whiteColor];
    return _color;
}

-(void)setColor:(UIColor *)color{
    _color = color;
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#define CORNER_RADIUS 32.0

- (void)drawRect:(CGRect)rect
{
    UIBezierPath * roundedRect = [UIBezierPath bezierPathWithRoundedRect: self.bounds  cornerRadius:CORNER_RADIUS];
    
    [roundedRect addClip];
	 //cell.backgroundColor = [UIColor redColor];
    [self.color setFill];
    UIRectFill(self.bounds);
    
    
    [super drawRect:rect];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
