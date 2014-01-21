//
//  Photo+Flickr.h
//  SPoT
//
//  Created by mmh on 20/01/2014.
//  Copyright (c) 2014 mmh. All rights reserved.
//

#import "Photo.h"

@interface Photo (Flickr)
+(Photo*) photoWithFlickrInfo:(NSDictionary*)photoDictionary
       inManagedObjectContext: (NSManagedObjectContext *) context;
@end
