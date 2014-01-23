//
//  PhotosCDTVC.h
//  SPoT
//
//  Created by mmh on 22/01/2014.
//  Copyright (c) 2014 mmh. All rights reserved.
//
// can preform "setTag:" segue

#import "PhotosCDTVC.h"
#import "Tag.h"

@interface PhotosByTagCDTVC : PhotosCDTVC
@property(strong,nonatomic) Tag * tag;
@end
