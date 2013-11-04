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
#define HIGHLIGHT_STAR_SCALE 0.5
- (void)drawRect:(CGRect)rect{

    if(self.hintHighlighted && !self.unplayable) {
        
        UIImage *starImage = [UIImage imageNamed:@"star.png"];
        
        CGRect starRect = CGRectMake(self.bounds.size.width * HIGHLIGHT_STAR_SCALE, self.bounds.origin.y, self.bounds.size.width * HIGHLIGHT_STAR_SCALE, self.bounds.size.width * HIGHLIGHT_STAR_SCALE);
        [starImage drawInRect:starRect];
        
    }
}
-(void)setFaceUp:(BOOL)faceUp{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

-(void)setHintHighlighted:(BOOL)hintHighlighted{
    _hintHighlighted = hintHighlighted;
    [self setNeedsDisplay];
}

#define ACTIVE_ALPHA 1.0
#define INACTIVE_ALPHA 0.5
-(void)setUnplayable:(BOOL)unplayable{
    _unplayable = unplayable;
    self.alpha = unplayable ? INACTIVE_ALPHA : ACTIVE_ALPHA;
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
