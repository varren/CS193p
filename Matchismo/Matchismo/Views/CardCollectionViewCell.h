//
//  PlayingCardCollectionViewCell.h
//  Matchismo
//
//  Created by mmh on 18/10/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"

@interface CardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet CardView *cardView;
@end
