//
//  FlickrDataTVC.h
//  SPoT
//
//  Created by mmh on 10/11/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import "FlickrFetcher.h"

@interface FlickrImagesTVC : UITableViewController

@property (strong, nonatomic) NSArray * photos;

@end
