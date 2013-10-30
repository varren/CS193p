//
//  MatchedCardsCollectionViewCell.h
//  Matchismo
//
//  Created by mmh on 29/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"
@interface MatchedCardsCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutletCollection(CardView) NSArray *cardViews;

@end
