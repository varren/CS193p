//
//  FavoritesTVC.m
//  SPoT
//
//  Created by mmh on 10/11/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "FavoritesTVC.h"
#import "DataCache.h"

@implementation FavoritesTVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.photos = [[DataCache instance] favoritePhotos];
}

@end
