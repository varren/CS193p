//
//  GameResultsCell.h
//  Matchismo
//
//  Created by mmh on 03/11/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameResultsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *logo;

@end
