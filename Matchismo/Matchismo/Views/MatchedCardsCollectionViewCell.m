//
//  MatchedCardsCollectionViewCell.m
//  Matchismo
//
//  Created by mmh on 29/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "MatchedCardsCollectionViewCell.h"


@implementation MatchedCardsCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}


#define CORNER_RADIUS 32.0
-(void)setup{
    
    //UIBezierPath * roundedRect = [UIBezierPath bezierPathWithRoundedRect: self.bounds  cornerRadius:CORNER_RADIUS];
    
    //[roundedRect addClip];
    //cell.backgroundColor = [UIColor redColor];
    
   // self.backgroundColor = [UIColor whiteColor];
   // self.backgroundView.backgroundColor = [UIColor whiteColor];
    
    //self.translatesAutoresizingMaskIntoConstraints = NO;
 //   self.superview.translatesAutoresizingMaskIntoConstraints = NO;
   // self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;

   // for (CardView *cardView in self.cardViews)
    //cardView.translatesAutoresizingMaskIntoConstraints = NO;
   
}
@end
