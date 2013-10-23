//
//  SetCardView.h
//  Matchismo
//
//  Created by mmh on 19/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"


@interface SetCardView : CardView

@property (strong, nonatomic) NSString * shape;
@property (strong, nonatomic) UIColor* color;
@property (strong, nonatomic) NSNumber* shading; // alpha
@property (nonatomic) NSInteger number;

+(NSArray*) validShapes;
@end

