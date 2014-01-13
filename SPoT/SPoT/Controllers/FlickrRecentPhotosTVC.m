//
//  FlickrRecentPhotosTVC.m
//  SPoT
//
//  Created by mmh on 10/11/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "FlickrRecentPhotosTVC.h"
#import "DataCache.h"

@implementation FlickrRecentPhotosTVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.photos = [[DataCache instance] recentlyViewedPhotos];
}

@end
