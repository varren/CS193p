//
//  CardView.m
//  Matchismo
//
//  Created by mmh on 19/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "CardView.h"

@implementation CardView

#pragma mark - Properties

-(void)setFaceUp:(BOOL)faceUp{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

-(void)setIsHint:(BOOL)isHint{
    _isHint = isHint;
    [self setNeedsDisplay];
}
#pragma mark - Initialisation

-(void)setup{
    //initial setup can be here
}

-(void)awakeFromNib{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

@end
