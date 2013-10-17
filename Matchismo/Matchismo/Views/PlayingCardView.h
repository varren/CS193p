//
//  PlayingCardView.h
//  Matchismo
//
//  Created by mmh on 16/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView
@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;

@property (nonatomic) BOOL faceUp;

-(void)pinch:(UIPinchGestureRecognizer *) gesture;

@end
