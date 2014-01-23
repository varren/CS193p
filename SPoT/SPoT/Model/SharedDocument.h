//
//  SharedDocument.h
//  SPoT
//
//  Created by mmh on 22/01/2014.
//  Copyright (c) 2014 mmh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedDocument : NSObject
@property (strong, nonatomic) UIManagedDocument* document;

+(SharedDocument*) instance;
@end
