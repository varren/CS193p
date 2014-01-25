//
//  DataSource.h
//  SPoT
//
//  Created by mmh on 10/11/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCache : NSObject
+(DataCache*)instance; //singletone

-(UIImage *) getImage: (NSURL *) imageURL;
-(NSData*)loadImageFromNet: (NSURL *) imageURL;
-(NSArray *) loadPhotosInfoFromNet;

@end
