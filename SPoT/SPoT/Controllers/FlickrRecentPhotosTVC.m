//
//  FlickrRecentPhotosTVC.m
//  SPoT
//
//  Created by mmh on 10/11/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "FlickrRecentPhotosTVC.h"

@implementation FlickrRecentPhotosTVC

-(void)viewDidAppear:(BOOL)animated{
    self.photos = [[DataSource instance] recentlyViewedPhotos];
}

@end
