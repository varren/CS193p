//
//  Tag+Create.h
//  SPoT
//
//  Created by mmh on 21/01/2014.
//  Copyright (c) 2014 mmh. All rights reserved.
//

#import "Tag.h"

@interface Tag (Create)

+ (Tag *) tagWithName:(NSString*) name inManagedObjectContext: (NSManagedObjectContext *) context;
+(NSString*) allTag;
+(NSArray*) ignoredTags;
@end
