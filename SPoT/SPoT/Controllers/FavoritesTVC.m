//
//  FavoritesTVC.m
//  SPoT
//
//  Created by mmh on 10/11/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "FavoritesTVC.h"

@implementation FavoritesTVC

-(void)viewDidAppear:(BOOL)animated{
    self.photos = [[DataSource instance] favoritePhotos];
}

@end
