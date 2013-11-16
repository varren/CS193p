//
//  FlickrRecentPhotosTVC.m
//  SPoT
//
//  Created by mmh on 10/11/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "FlickrRecentPhotosTVC.h"
#import "DataSource.h"

@implementation FlickrRecentPhotosTVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.photos = [[DataSource instance] recentlyViewedPhotos];
}

@end
